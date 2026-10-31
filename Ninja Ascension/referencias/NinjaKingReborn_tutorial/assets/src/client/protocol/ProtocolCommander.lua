require "client.protocol.ProtocolCommanderCopy"
require "client.protocol.ProtocolCommanderCopyEx"
require "client.protocol.ProtocolCommanderCopyExx"
require "client.protocol.ProtocolCommanderCopyExxx"
protocol_command = nil




local function command_new_get_server_list(str)
	local sliptPlatformName = zstring.split(app.configJson.OperationPlatformName,"|")
	local m_platformName = sliptPlatformName[1] == nil and app.configJson.OperationPlatformName or sliptPlatformName[1]

	local package_md5 = "0.0"
	if nil ~= getPackageMd5Param then
		package_md5 = getPackageMd5Param()
	end

	str = str.."\r\n"
	str = str..protocol_command.new_get_server_list.command
	str = str.."\r\n"
	str = str..getVersion()
	str = str.."\r\n"
	str = str..""..app.configJson.OperatorName..","..m_platformName..","..app.configJson.UserAccountPlatformName
	str = str.."\r\n"
	str = str..getPackageParam() .. "," .. package_md5

	local nameLocal = cc.UserDefault:getInstance():getStringForKey("name_local", "")
	if nameLocal ~= nil and nameLocal ~= "" then
		str = str..","..nameLocal
	else
		str = str..",".."-1"
	end

	local serverInfoTimeStamp = cc.UserDefault:getInstance():getStringForKey("serverInfoTimeStamp", "")
	if serverInfoTimeStamp ~= nil and serverInfoTimeStamp ~= "" then
		str = str..","..serverInfoTimeStamp
	else
		str = str..",".."-1"
	end

	str = str.."\r\n"
	str = str..getPlatformParam()
	return str
end




local function command_resource_update_after(str)
	str = str.."\r\n"
	str = str..protocol_command.resource_update_after.command
	str = str.."\r\n"
	str = str..protocol_command.resource_update_after.param_list
	str = str.."\r\n"
	str = str..getPlatformParam()
	return str
end




local function command_resource_mineral_init(str)
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_init.param_list
end




local function command_resource_mineral_seize(str)
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_seize.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_seize.param_list
end




local function command_resource_mineral_rob_helper(str)
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_rob_helper.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_rob_helper.param_list
end




local function command_resource_mineral_find(str)
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_find.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_find.param_list
end




local function command_resource_mineral_check_messgae(str)
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_check_messgae.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end




local function command_resource_mineral_give_up(str)
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_give_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_give_up.param_list
end




local function command_draw_month_sign_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_month_sign_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end




local function command_glories_shop_init(str)
	str = str.."\r\n"
	str = str..protocol_command.glories_shop_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end




local function command_glories_shop_exchange(str)
	str = str.."\r\n"
	str = str..protocol_command.glories_shop_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.glories_shop_exchange.param_list
	return str
end




local function command_draw_month_week_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_month_week_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_month_week_reward.param_list
end




local function command_spirite_palace_shop_init(str)
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_shop_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end




local function command_spirite_palace_shop_exchange(str)
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_shop_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_shop_exchange.param_list
end




local function command_spirite_palace_init(str)
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end




local function command_spirite_palace_choose_event(str)
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_choose_event.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_choose_event.param_list
end




local function command_spirite_palace_event_start(str)
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_event_start.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_event_start.param_list
end




local function command_spirite_palace_reset(str)
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_reset.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end




local function command_spirite_palace_look_formation(str)
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_look_formation.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end




local function command_spirite_palace_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_buy.param_list
end




local function command_spirite_palace_auto_play(str)
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_auto_play.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end




local function command_spirite_palace_cast_equipment(str)
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_cast_equipment.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_cast_equipment.param_list
end




local function command_cross_server_fight_init(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_server_fight_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end




local function command_cross_server_fight_apply(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_server_fight_apply.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end




local function command_cross_server_join_game_init(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_server_join_game_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_server_join_game_init.param_list
end




local function command_cross_server_update_info(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_server_update_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end




local function command_cross_server_encourage(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_server_encourage.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_server_encourage.param_list
end




local function command_cross_server_fight_record(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_server_fight_record.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_server_fight_record.param_list
end




local function command_cross_server_self_info(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_server_self_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end




local function command_cross_server_fight_record_list(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_server_fight_record_list.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_server_fight_record_list.param_list
end




local function command_cross_server_prostrate_init(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_server_prostrate_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end




local function command_cross_server_prostrate(str)
	str = str.."\r\n"
	str = str..protocol_command.cross_server_prostrate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_server_prostrate.param_list
end






local function command_secret_shopman_init(str)
	str = str.."\r\n"
	str = str..protocol_command.secret_shopman_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end





local function command_three_kingdoms_init(str)
	str = str.."\r\n"
	str = str..protocol_command.three_kingdoms_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end




local function command_three_kingdoms_fight(str)
	str = str.."\r\n"
	str = str..protocol_command.three_kingdoms_fight.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.three_kingdoms_fight.param_list
	return str
end



local function command_get_attribute(str)
	str = str.."\r\n"
	str = str..protocol_command.get_attribute.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_attribute.param_list
	return str
end




local function command_dignified_shop_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.dignified_shop_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.dignified_shop_buy.param_list

	return str
end




local function command_equipment_refining(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_refining.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_refining.param_list

	return str
end




local function command_recycle_init(str)
	str = str.."\r\n"
	str = str..protocol_command.recycle_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.recycle_init.param_list

	return str
end




local function command_daily_instance(str)
	str = str.."\r\n"
	str = str..protocol_command.daily_instance.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.daily_instance.param_list

	return str
end




local function command_cultivate_start(str)
	str = str.."\r\n"
	str = str..protocol_command.cultivate_start.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cultivate_start.param_list

	return str
end




local function command_cultivate_replace(str)
	str = str.."\r\n"
	str = str..protocol_command.cultivate_replace.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cultivate_replace.param_list

	return str
end




local function command_manor_init(str)
	str = str.."\r\n"
	str = str..protocol_command.manor_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.manor_init.param_list
	return str
end




local function command_manor_fight(str)
	str = str.."\r\n"
	str = str..protocol_command.manor_fight.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.manor_fight.param_list

	return str
end




local function command_manor_patrol(str)
	str = str.."\r\n"
	str = str..protocol_command.manor_patrol.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.manor_patrol.param_list

	return str
end




local function command_manor_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.manor_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.manor_reward.param_list

	return str
end




local function command_manor_friend(str)
	str = str.."\r\n"
	str = str..protocol_command.manor_friend.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id

	return str
end




local function command_manor_repress_rebellion(str)
	str = str.."\r\n"
	str = str..protocol_command.manor_repress_rebellion.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.manor_repress_rebellion.param_list

	return str
end




local function command_rebel_army_init(str)
	str = str.."\r\n"
	str = str..protocol_command.rebel_army_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.rebel_army_init.param_list
	return str
end




local function command_rebel_army_exploit(str)
	str = str.."\r\n"
	str = str..protocol_command.rebel_army_exploit.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.rebel_army_exploit.param_list
	return str
end




local function command_rebel_exploit_shop_init(str)
	str = str.."\r\n"
	str = str..protocol_command.rebel_exploit_shop_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.rebel_exploit_shop_init.param_list

	return str
end




local function command_rebel_exploit_shop_exchange(str)
	str = str.."\r\n"
	str = str..protocol_command.rebel_exploit_shop_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.rebel_exploit_shop_exchange.param_list
	return str
end




local function command_draw_scene_npc_rewad(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_scene_npc_rewad.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_scene_npc_rewad.param_list
	return str
end




local function command_destiny_click(str)
	str = str.."\r\n"
	str = str..protocol_command.destiny_click.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.destiny_click.param_list
	return str
end




local function command_daily_mission_init(str)
	str = str.."\r\n"
	str = str..protocol_command.daily_mission_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.daily_mission_init.param_list
	return str
end




local function command_draw_daily_mission_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_daily_mission_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_daily_mission_reward.param_list
	return str
end




local function command_draw_liveness_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_liveness_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_liveness_reward.param_list
	return str
end




local function command_server_fund_init(str)
	str = str.."\r\n"
	str = str..protocol_command.server_fund_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.server_fund_init.param_list
	return str
end




local function command_see_user_info(str)
	str = str.."\r\n"
	str = str..protocol_command.see_user_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.see_user_info.param_list
	return str
end




local function command_pull_black(str)
	str = str.."\r\n"
	str = str..protocol_command.pull_black.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pull_black.param_list
	return str
end




local function command_draw_achieve_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_achieve_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_achieve_reward.param_list
	return str
end




local function command_draw_server_fund(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_server_fund.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_server_fund.param_list
	return str
end




local function command_search_friend_apply(str)
	str = str.."\r\n"
	str = str..protocol_command.search_friend_apply.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end




local function command_dignified_shop_init(str)
	str = str.."\r\n"
	str = str..protocol_command.dignified_shop_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end




local function command_week_active_init(str)
	str = str.."\r\n"
	str = str..protocol_command.week_active_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.week_active_init.param_list
	return str
end




local function command_celebrity_bulletin_init(str)
	str = str.."\r\n"
	str = str..protocol_command.celebrity_bulletin_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.celebrity_bulletin_init.param_list
	return str
end




local function command_celebrity_bulletin_support(str)
	str = str.."\r\n"
	str = str..protocol_command.celebrity_bulletin_support.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.celebrity_bulletin_support.param_list
	return str
end




local function command_celebrity_leave_msg(str)
	str = str.."\r\n"
	str = str..protocol_command.celebrity_leave_msg.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.celebrity_leave_msg.param_list
	return str
end




local function command_unparallel_purchase(str)
	str = str.."\r\n"
	str = str..protocol_command.unparallel_purchase.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.unparallel_purchase.param_list
	return str
end





local function command_sweep_kingdoms(str)
	str = str.."\r\n"
	str = str..protocol_command.sweep_kingdoms.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end




local function command_draw_week_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_week_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_week_reward.param_list
	return str
end




local function command_refush_msg(str)
	str = str.."\r\n"
	str = str..protocol_command.refush_msg.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end




local function command_manor_user_init(str)
	str = str.."\r\n"
	str = str..protocol_command.manor_user_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.manor_user_init.param_list
	return str
end




local function command_remove_black(str)
	str = str.."\r\n"
	str = str..protocol_command.remove_black.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.remove_black.param_list
	return str
end





local function command_tencent_balance(str)
	str = str.."\r\n"
	str = str..protocol_command.tencent_balance.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..m_platform_tx_login_info
	str = str.."\r\n"
	str = str..protocol_command.tencent_balance.param_list
	return str
end




local function command_tencent_pay(str)
	str = str.."\r\n"
	str = str..protocol_command.tencent_pay.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..m_platform_tx_login_info
	str = str.."\r\n"
	str = str..protocol_command.tencent_pay.param_list
	return str
end




local function command_rebel_army_fight(str)
	str = str.."\r\n"
	str = str..protocol_command.rebel_army_fight.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.rebel_army_fight.param_list
	return str
end




local function command_refush_rebel_army(str)
	str = str.."\r\n"
	str = str..protocol_command.refush_rebel_army.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id


	return str
end




function command_battle_result_verify(str)
	str = str.."\r\n"
	str = str..protocol_command.battle_result_verify.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str.._ED._battle_init_type
	str = str.."\r\n"
	str = str..protocol_command.battle_result_verify.param_list
	return str
end





protocol_command = {
	get_server_list = { 			code = 1, 		command = "get_server_list", 					command_fun = command_get_server_list, 					param_list=""},
	platform_manage = { 			code = 2, 		command = "platform_manage", 					command_fun = command_platform_manage,  				param_list=""},
	search_user_platform = {		code = 3, 		command = "search_user_platform", 				command_fun = command_search_user_platform,  			param_list=""},
	platform_login = {				code = 4, 		command = "platform_login", 					command_fun = command_platform_login,  					param_list=""},
	modify_platform_password = {	code = 5, 		command = "modify_platform_password", 			command_fun = command_modify_platform_password,  		param_list=""},
	get_random_name = {				code = 6, 		command = "get_random_name", 					command_fun = command_get_random_name,  				param_list=""},
	vali_register = {				code = 7, 		command = "vali_register", 						command_fun = command_vali_register,  					param_list=""},
	login_init = {					code = 8, 		command = "login_init", 						command_fun = command_login_init,  						param_list=""},
	register_game_account = {		code = 9, 		command = "register", 							command_fun = command_register_game_account,  			param_list=""},
	formation_change = {			code = 10, 		command = "formation_change", 					command_fun = command_formation_change, 				param_list=""},
	equipment_adorn = {				code = 11, 		command = "equipment_adorn", 					command_fun = command_equipment_adorn,  				param_list=""},
	environment_fight = {			code = 12,		command = "environment_fight",					command_fun = command_environment_fight, 				param_list=""},
	shop_view = {					code = 13,		command = "shop_view",							command_fun = command_shop_view, 						param_list=""},
	ship_bounty={					code = 14,		command = "ship_bounty",						command_fun = command_ship_bounty, 						param_list=""},
	search_order_list={				code = 15,		command = "search_order_list",					command_fun = command_search_order_list, 				param_list=""},
	draw_scene_rewad={				code = 16,		command = "draw_scene_rewad",					command_fun = command_draw_scene_rewad, 				param_list=""},
	trigger_scene_surprise={		code = 17,		command = "trigger_scene_surprise",				command_fun = command_trigger_scene_surprise, 			param_list=""},
	ship_grow_up={					code = 18,		command = "ship_grow_up",						command_fun = command_ship_grow_up, 					param_list=""},
	battle_field_init={				code = 19,		command = "battle_field_init",					command_fun = command_battle_field_init, 				param_list=""},
	prop_sell={ 					code = 20, 		command = "prop_sell", 							command_fun = command_prop_sell, 						param_list=""},
	view_ship_grow_up_additional={ 	code = 21, 		command = "view_ship_grow_up_additional", 		command_fun = command_view_ship_grow_up_additional, 	param_list=""},
	prop_use={ 						code = 22, 		command = "prop_use", 							command_fun = command_prop_use, 						param_list=""},
	basic_consumption={ 			code = 23, 		command = "basic_consumption", 					command_fun = command_basic_consumption, 				param_list=""},
	equipment_sell={				code = 24, 		command = "equipment_sell", 					command_fun = command_equipment_sell, 					param_list=""},
	equipment_escalate={			code = 25, 		command = "equipment_escalate", 				command_fun = command_equipment_escalate, 				param_list=""},
	prop_compound={					code = 26, 		command = "prop_compound", 						command_fun = command_prop_compound, 					param_list=""},
	ship_sell={						code = 27, 		command = "ship_sell", 							command_fun = command_ship_sell, 						param_list=""},
	ship_batch_bounty={				code = 28, 		command = "ship_batch_bounty", 					command_fun = command_ship_batch_bounty, 				param_list=""},
	refusal_start={					code = 29, 		command = "refusal_start", 						command_fun = command_refusal_start, 					param_list=""},
	refresh_grab_list={				code = 30, 		command = "refresh_grab_list", 					command_fun = command_refresh_grab_list, 				param_list=""},
	grab_launch={					code = 31, 		command = "grab_launch", 						command_fun = command_grab_launch, 						param_list=""},
	companion_change={				code = 32, 		command = "companion_change", 					command_fun = command_companion_change, 				param_list=""},
	ship_escalate={					code = 33, 		command = "ship_escalate", 						command_fun = command_ship_escalate, 					param_list=""},
	treasure_escalate={				code = 34, 		command = "treasure_escalate", 					command_fun = command_treasure_escalate, 				param_list=""},
	get_activity_reward={			code = 35, 		command = "get_activity_reward", 				command_fun = command_get_activity_reward, 				param_list=""},
	draw_online_reward={			code = 36, 		command = "draw_online_reward", 				command_fun = command_draw_online_reward,				param_list=""},
	bounty_limit_init={				code = 37,		command = "bounty_limit_init", 					command_fun = command_bounty_limit_init,				param_list=""},
	bounty_limit_start={			code = 38,		command = "bounty_limit_start",					command_fun = command_bounty_limit_start,				param_list=""},
	dinner_init={			        code = 39,		command = "dinner_init",				    	command_fun = command_dinner_init,				        param_list=""},
	dinner_time={			        code = 40,		command = "dinner_time",				    	command_fun = command_dinner_time,				        param_list=""},
	draw_bounty_limit_reward={		code = 41,		command = "draw_bounty_limit_reward",			command_fun = command_draw_bounty_limit_reward,			param_list=""},
	secret_shop_init={				code = 42,		command = "secret_shop_init",					command_fun = command_secret_shop_init,					param_list=""},
	secret_shop_refresh={			code = 43,		command = "secret_shop_refresh",				command_fun = command_secret_shop_refresh,				param_list=""},
	secret_shop_exchange={			code = 44,		command = "secret_shop_exchange",				command_fun	= command_secret_shop_exchange,				param_list=""},
	divine_init={			        code = 45,		command = "divine_init",				    	command_fun = command_divine_init,				        param_list=""},
	divine_start={			        code = 46,		command = "divine_start",				    	command_fun = command_divine_start,				        param_list=""},
	divine_refresh={			    code = 47,		command = "divine_refresh",				    	command_fun = command_divine_refresh,				    param_list=""},
	friend_update={			    	code = 48,		command = "friend_update",				    	command_fun = command_friend_update,				    param_list=""},
	email_init={					code = 49,		command = "email_init",				    		command_fun = command_email_init,				   		param_list=""},
	prop_purchase={					code = 50,		command = "prop_purchase",						command_fun = command_prop_purchase,					param_list=""},
	equipment_purchase={			code = 51,		command = "equipment_purchase",					command_fun = command_equipment_purchase,				param_list=""},
	equipment_onekey_adorn={		code = 52,		command = "equipment_onekey_adorn",				command_fun = command_equipment_onekey_adorn,			param_list=""},
	draw_divine_reward={			code = 53,		command = "draw_divine_reward",					command_fun = command_draw_divine_reward,				param_list=""},
	random_user_list={			    code = 54,		command = "random_user_list",				    command_fun = command_random_user_list,				    param_list=""},
	present_endurance={			    code = 55,		command = "present_endurance",				    command_fun = command_present_endurance,			    param_list=""},
	attack_purchase={			    code = 56,		command = "attack_purchase",				    command_fun = command_attack_purchase,			   	 	param_list=""},
	search_user={			    	code = 57,		command = "search_user",					    command_fun = command_search_user,			   	 		param_list=""},
	refining={						code = 58, 		command = "refining",							command_fun = command_refining,							param_list=""},
	friend_msg={				    code = 59,		command = "friend_msg",						    command_fun = command_friend_msg,			  		    param_list=""},
	friend_del={				    code = 60,		command = "friend_del",						    command_fun = command_friend_del,			  		    param_list=""},
	friend_request={				code = 61,		command = "friend_request",						command_fun = command_friend_request,			  		param_list=""},
	draw_endurance_init={			code = 62,		command = "draw_endurance_init",				command_fun = command_draw_endurance_init,			  	param_list=""},
	draw_cdkey_reward={				code = 63,		command = "draw_cdkey_reward",					command_fun = command_draw_cdkey_reward,			  	param_list=""},
	draw_endurance={				code = 64,		command = "draw_endurance",						command_fun = command_draw_endurance,				  	param_list=""},
	friend_pass = {					code = 65,		command = "friend_pass",						command_fun = command_friend_pass,				  		param_list=""},
	get_system_notice = {			code = 66,		command = "get_system_notice",					command_fun = command_get_system_notice,		  		param_list=""},
	draw_vip_every_day_reward = {	code = 67,		command = "draw_vip_every_day_reward",			command_fun = command_draw_vip_every_day_reward,		param_list=""},
	keep_alive = {					code = 68,		command = "keep_alive",							command_fun = command_keep_alive,						param_list=""},
	request_top_up_order_number = {	code = 69,		command = "request_top_up_order_number",		command_fun = command_request_top_up_order_number,		param_list=""},
	vali_top_up_order_number = {	code = 70,		command = "vali_top_up_order_number",			command_fun = command_vali_top_up_order_number,			param_list=""},
	vali_top_up_order_number7000 = {code = 7000,	command = "vali_top_up_order_number",			command_fun = command_vali_top_up_order_number7000,			param_list=""},
	arena_init = { 					code = 71, 		command = "arena_init",							command_fun = command_arena_init,						param_list=""},
	arena_launch = {				code = 72,		command = "arena_launch",						command_fun	= command_arena_launch,						param_list=""},
	arena_order = {					code = 73,		command = "arena_order",						command_fun = command_arena_order,						param_list=""},
	send_message = {				code = 74,		command = "send_message",						command_fun = command_send_message,						param_list=""},
	gm_message_send = {				code = 75,		command = "gm_message_send",					command_fun = command_gm_message_send,					param_list=""},
	gm_message_init = {				code = 76,		command = "gm_message_init",					command_fun = command_gm_message_init,					param_list=""},
	arena_shop_init = {				code = 77,		command = "arena_shop_init",					command_fun = command_arena_shop_init,					param_list=""},
	arena_shop_exchange = {			code = 78,		command = "arena_shop_exchange",				command_fun = command_arena_shop_exchange,				param_list=""},
	look_at_user_fleet = {			code = 79,		command = "look_at_user_fleet",					command_fun = command_look_at_user_fleet,				param_list=""},
	reward_center_init = {			code = 80,		command = "reward_center_init",					command_fun = command_reward_center_init,				param_list=""},
	arena_reward_draw = {			code = 81,		command = "arena_reward_draw",					command_fun = command_arena_reward_draw,				param_list=""},
	draw_arena_lucky = {			code = 82,		command = "draw_arena_lucky",					command_fun = command_draw_arena_lucky,					param_list=""},
	draw_reward_center = {			code = 83,		command = "draw_reward_center",					command_fun = command_draw_reward_center,				param_list=""},
	destiny_init = {				code = 84,		command = "destiny_init",						command_fun = command_destiny_init,						param_list=""},
	destiny_start = {				code = 85,		command = "destiny_start",						command_fun = command_destiny_start,					param_list=""},
	favor_item_use = {				code = 86,		command = "favor_item_use",						command_fun = command_favor_item_use,					param_list=""},
	activate_app = {				code = 87,		command = "activate_app",						command_fun = command_activate_app,						param_list=""},
	education_change = {			code = 88,		command = "education_change",					command_fun = command_education_change,					param_list=""},
	record_crash = {				code = 89,		command = "record_crash",						command_fun = command_record_crash,						param_list=""},
	equipment_rank_up = {			code = 90,		command = "equipment_rank_up",					command_fun = command_equipment_rank_up,				param_list=""},
	get_resource = {				code = 91,		command = "get_resource",						command_fun = command_get_resource,						param_list=""},
	refining_equipment = {			code = 92,		command = "refining_equipment",					command_fun = command_refining_equipment,				param_list=""},
	refining_replace = {			code = 93,		command = "refining_replace",					command_fun = command_refining_replace,					param_list=""},
	draw_first_top_up_reward = {	code = 94,		command = "draw_first_top_up_reward",			command_fun = command_draw_first_top_up_reward,			param_list=""},
	login_init_again = {			code = 95,		command = "login_init_again",					command_fun = command_login_init_again,					param_list=""},
	rebirth = {						code = 96,		command = "rebirth",							command_fun = command_rebirth,							param_list=""},
	draw_bounty_limit = {			code = 97,		command = "draw_bounty_limit",					command_fun = command_draw_bounty_limit,				param_list=""},
	sweep = {						code = 98,		command = "sweep",								command_fun = command_sweep,							param_list=""},
	clear_sweep_cd = {				code = 99,		command = "clear_sweep_cd",						command_fun = command_clear_sweep_cd,					param_list=""},
	grow_plan_purchase = {			code = 100,		command = "grow_plan_purchase",					command_fun = command_grow_plan_purchase,				param_list=""},
	treasure_digger_init = {		code = 101,		command = "treasure_digger_init",				command_fun = command_treasure_digger_init,				param_list=""},
	treasure_digger_start = {		code = 102,		command = "treasure_digger_start",				command_fun = command_treasure_digger_start,			param_list=""},
	world_boss_init = {				code = 103,		command = "world_boss_init",					command_fun = command_world_boss_init,					param_list=""},
	world_boss_launch = {			code = 104,		command = "world_boss_launch",					command_fun = command_world_boss_launch,				param_list=""},
	world_boss_repair = {			code = 105,		command = "world_boss_repair",					command_fun = command_world_boss_repair,				param_list=""},
	world_boss_inspire = {			code = 106,		command = "world_boss_inspire",					command_fun = command_world_boss_inspire,				param_list=""},
	draw_world_boss_reward = {		code = 107,		command = "draw_world_boss_reward",				command_fun = command_draw_world_boss_reward,			param_list=""},
	duel_init = {					code = 108, 	command = "duel_init",							command_fun = command_duel_init,						param_list=""},
	refresh_duel = {				code = 109,		command = "refresh_duel",						command_fun = command_refresh_duel,						param_list=""},
	duel_launch = {					code = 110,		command = "duel_launch",						command_fun = command_duel_launch,						param_list=""},
	duel_revenge_launch = {			code = 111,		command = "duel_revenge_launch",				command_fun = command_duel_revenge_launch,				param_list=""},
	draw_duel_order_reward = {		code = 112,		command = "draw_duel_order_reward",				command_fun = command_draw_duel_order_reward,			param_list=""},
	view_world_boss_reward = {		code = 113,		command = "view_world_boss_reward",				command_fun = command_view_world_boss_reward,			param_list=""},
	trans_tower_init = {			code = 114,		command = "trans_tower_init",					command_fun = command_trans_tower_init,					param_list=""},
	towel_launch = {				code = 115,		command = "towel_launch",						command_fun = command_towel_launch,						param_list=""},
	sweep_towel = {					code = 116,		command = "sweep_towel",						command_fun = command_sweep_towel,						param_list=""},
	towel_reset = {					code = 117,		command = "towel_reset",						command_fun = command_towel_reset,						param_list=""},
	ship_bounty_check = {			code = 118,		command = "ship_bounty_check",					command_fun = command_ship_bounty_check,				param_list=""},
	system_time = {					code = 119,		command = "system_time",						command_fun = command_system_time,						param_list=""},
	user_sweep_rewards = {			code = 120,		command = "user_sweep_rewards",					command_fun = command_user_sweep_rewards,				param_list=""},
	refresh_grab_list_for_education = {			code = 121,		command = "refresh_grab_list_for_education",					command_fun = command_refresh_grab_list_for_education,				param_list=""},
	grab_launch_for_education = {	code = 122,		command = "grab_launch_for_education",			command_fun = command_grab_launch_for_education,		param_list=""},
	union_create =	{				code = 123,		command = "union_create",						command_fun = command_union_create,						param_list=""},
	union_list = 	{				code = 124,		command = "union_list",							command_fun = command_union_list,						param_list=""},
	union_search = 	{				code = 125,		command = "union_search",						command_fun = command_union_search,						param_list=""},
	union_apply = 	{				code = 126,		command = "union_apply",						command_fun = command_union_apply,						param_list=""},
	union_init = 	{				code = 127,		command = "union_init",							command_fun = command_union_init,						param_list=""},
	union_content_update = 	{		code = 128,		command = "union_content_update",				command_fun = command_union_content_update,				param_list=""},
	union_password_update = {		code = 129,		command = "union_password_update",				command_fun = command_union_password_update,			param_list=""},
	union_dismiss = {				code = 130,		command = "union_dismiss",						command_fun = command_union_dismiss,					param_list=""},
	union_persion_list = {			code = 131,		command = "union_persion_list",					command_fun = command_union_persion_list,				param_list=""},
	union_examine_list = {			code = 132,		command = "union_examine_list",					command_fun = command_union_examine_list,				param_list=""},
	union_persion_manage = {		code = 133,		command = "union_persion_manage",				command_fun = command_union_persion_manage,				param_list=""},
	union_appoint = {				code = 134,		command = "union_appoint",						command_fun = command_union_appoint,					param_list=""},
	union_fight = {					code = 135,		command = "union_fight",						command_fun = command_union_fight,						param_list=""},
	union_impeach = {				code = 136,		command = "union_impeach",						command_fun = command_union_impeach,					param_list=""},
	union_exit= {					code = 137,		command = "union_exit",							command_fun = command_union_exit,						param_list=""},
	union_message = {				code = 138,		command = "union_message",						command_fun = command_union_message,					param_list=""},
	union_build = {					code = 139,		command = "union_build",						command_fun = command_union_build,						param_list=""},
	temple_init= {					code = 140,		command = "temple_init",						command_fun = command_temple_init,						param_list=""},
	temple_fete = {					code = 141,		command = "temple_fete",						command_fun = command_temple_fete,						param_list=""},
	union_shop_init = {				code = 142,		command = "union_shop_init",					command_fun = command_union_shop_init,					param_list=""},
	union_shop_exchange = {			code = 143,		command = "union_shop_exchange",				command_fun = command_union_shop_exchange,				param_list=""},
	union_upgrade = {				code = 144,		command = "union_upgrade",						command_fun = command_union_upgrade,					param_list=""},
	union_counterpart_init = {		code = 145,		command = "union_counterpart_init",				command_fun = command_union_counterpart_init,			param_list=""},
	union_counterpart_team = {		code = 146,		command = "union_counterpart_team",				command_fun = command_union_counterpart_team,			param_list=""},
	union_counterpart_details = {	code = 147,		command = "union_counterpart_details",			command_fun = command_union_counterpart_details,		param_list=""},
	union_counterpart_organize = {	code = 148,		command = "union_counterpart_organize",			command_fun = command_union_counterpart_organize,		param_list=""},
	union_counterpart_add = {		code = 149,		command = "union_counterpart_add",				command_fun = command_union_counterpart_add,			param_list=""},
	union_counterpart_remove = {	code = 150,		command = "union_counterpart_remove",			command_fun = command_union_counterpart_remove,			param_list=""},
	union_counterpart_dismiss = {	code = 151,		command = "union_counterpart_dismiss",			command_fun = command_union_counterpart_dismiss,		param_list=""},
	union_counterpart_fight= {		code = 152,		command = "union_counterpart_fight",			command_fun = command_union_counterpart_fight,			param_list=""},
	union_counterpart_exit= {		code = 153,		command = "union_counterpart_exit",				command_fun = command_union_counterpart_exit,			param_list=""},
	union_counterpart_refush= {		code = 154,		command = "union_counterpart_refush",			command_fun = command_union_counterpart_refush,			param_list=""},
	union_counterpart_invite_list= {code = 155,		command = "union_counterpart_invite_list",		command_fun = command_union_counterpart_invite_list,	param_list=""},
	union_counterpart_invite= {		code = 156,		command = "union_counterpart_invite",			command_fun = command_union_counterpart_invite, 		param_list=""},
	union_battleground_init= {		code = 157,		command = "union_battleground_init",			command_fun = command_union_battleground_init, 			param_list=""},
	union_battleground_seize_info= {code = 158,		command = "union_battleground_seize_info",		command_fun = command_union_battleground_seize_info, 	param_list=""},
	union_battleground_apply= {		code = 159,		command = "union_battleground_apply",			command_fun = command_union_battleground_apply,			param_list=""},
	union_battleground_apply_count= {code = 160,	command = "union_battleground_apply_count",		command_fun = command_union_battleground_apply_count, 	param_list=""},
	union_battleground_apply_list= {code = 161,		command = "union_battleground_apply_list",		command_fun = command_union_battleground_apply_list, 	param_list=""},
	union_battleground_state= {		code = 162,		command = "union_battleground_state",			command_fun = command_union_battleground_state, 		param_list=""},
	union_battleground_last_fights= {code = 163,	command = "union_battleground_last_fights",		command_fun = command_union_battleground_last_fights, 	param_list=""},
	union_battleground_apply_time= {code = 164,		command = "union_battleground_apply_time",		command_fun = command_union_battleground_apply_time, 	param_list=""},
	union_battleground_count_down= {code = 165,		command = "union_battleground_count_down",		command_fun = command_union_battleground_count_down, 	param_list=""},
	union_battleground_join= {		code = 166,		command = "union_battleground_join",			command_fun = command_union_battleground_join, 			param_list=""},
	union_battleground_fight= {		code = 167,		command = "union_battleground_fight",			command_fun = command_union_battleground_fight, 		param_list=""},
	union_battleground_inspire= {	code = 168,		command = "union_battleground_inspire",			command_fun = command_union_battleground_inspire, 		param_list=""},
	union_battleground_add_victor= {code = 169,		command = "union_battleground_add_victor",		command_fun = command_union_battleground_add_victor, 	param_list=""},
	union_battleground_leave= {		code = 170,		command = "union_battleground_leave",			command_fun = command_union_battleground_leave, 		param_list=""},
	union_battleground_refush= {	code = 171,		command = "union_battleground_refush",			command_fun = command_union_battleground_refush, 		param_list=""},
	grab_init= {					code = 172,		command = "grab_init",							command_fun = command_grab_init, 						param_list=""},
	activity_superchange_exchange= {code = 173,		command = "super_change",						command_fun = command_activity_superchange_exchange, 	param_list=""},
	activity_subsection_discount_init= {code = 174,	command = "subsection_discount_init",			command_fun = command_activity_subsection_discount_init, param_list=""},
	activity_lucky_dial_init= {		code = 175,		command = "lucky_dial_init",					command_fun = command_activity_lucky_dial_init, 		param_list=""},
	activity_lucky_dial_start= {	code = 176,		command = "lucky_dial_start",					command_fun = command_activity_lucky_dial_start, 		param_list=""},
	union_battleground_reward= {	code = 177,		command = "union_battleground_reward",			command_fun = command_union_battleground_reward, 		param_list=""},
	get_environment_param= {		code = 178,		command = "get_environment_param",				command_fun = command_get_environment_param, 			param_list=""},
	vali_platform_user= {			code = 179,		command = "vali_platform_user",					command_fun = command_vali_platform_user, 				param_list=""},
	grab_launch_ten={				code = 180, 	command = "grab_launch_ten", 					command_fun = command_grab_launch_ten, 					param_list=""},
	stride_dial_init={				code = 181, 	command = "stride_dial_init", 					command_fun = command_stride_dial_init, 					param_list=""},
	stride_dial_start={				code = 182,     command = "stride_dial_start",					command_fun = command_stride_dial_start,				param_list=""},
	stride_dial_reward={			code = 183,     command = "stride_dial_reward",					command_fun = command_stride_dial_reward,				param_list=""},
	stride_dial_refush={			code = 184,		command = "stride_dial_refush",					command_fun = command_stride_dial_refush,				param_list=""},
	draw_month_card_reward={		code = 185,		command = "draw_month_card_reward",				command_fun = command_draw_month_card_reward,			param_list=""},
	greet_fortune={					code = 186,		command = "greet_fortune",						command_fun = command_greet_fortune,					param_list=""},
	fashion_escalate={				code = 187,		command = "fashion_escalate",					command_fun = command_fashion_escalate,					param_list=""},
	modify_nick_name={				code = 188,		command = "modify_nick_name",					command_fun = command_modify_nick_name,					param_list=""},
	study_event={					code = 189,		command = "study_event",						command_fun = command_study_event,						param_list=""},
	study_skill={					code = 190,		command = "study_skill",						command_fun = command_study_skill,						param_list=""},
	study_event_reward ={			code = 191,		command = "study_event_reward",					command_fun = command_study_event_reward,				param_list=""},
	skill_adron={					code = 192,     command = "skill_adron",						command_fun = command_skill_adron,						param_list=""},
	power_make = {					code = 193,		command = "power_make" ,						command_fun = command_power_make,						param_list=""},
	power_swallow = {				code = 194,		command = "power_swallow",						command_fun = command_power_swallow,					param_list=""},
	power_sell = {					code = 195,		command = "power_sell",						    command_fun = command_power_sell,						param_list=""},
	power_take = {					code = 196,		command = "power_take",							command_fun = command_power_take,						param_list=""},
	power_equip = {					code = 197,		command = "power_equip",						command_fun = command_power_equip,						param_list=""},
	power_exchange = {				code = 198,		command = "power_exchange",						command_fun = command_power_exchange,					param_list=""},
	buy_master_four ={				code = 199,		command = "buy_master_four",					command_fun = command_buy_master_four,					param_list=""},
    power_operation ={				code = 200,		command = "power_operation",					command_fun = command_power_operation,					param_list=""},
    new_get_server_list ={			code = 201,		command = "new_get_server_list",				command_fun = command_new_get_server_list,				param_list=""},
    resource_update_after ={		code = 202,		command = "resource_update_after",				command_fun = command_resource_update_after,			param_list=""},
	resource_mineral_init = {		code = 203,		command = "resource_mineral_init",				command_fun = command_resource_mineral_init,			param_list=""},
	resource_mineral_seize = {		code = 204,		command = "resource_mineral_seize",				command_fun = command_resource_mineral_seize,			param_list=""},
	resource_mineral_rob_helper = {	code = 205,		command = "resource_mineral_rob_helper",		command_fun = command_resource_mineral_rob_helper,		param_list=""},
	resource_mineral_find = {		code = 206,		command = "resource_mineral_find",				command_fun = command_resource_mineral_find,			param_list=""},
	resource_mineral_check_messgae = {code = 207,	command = "resource_mineral_check_messgae", 	command_fun = command_resource_mineral_check_messgae, 	param_list=""},
	resource_mineral_give_up = {	code = 208,		command = "resource_mineral_give_up", 			command_fun = command_resource_mineral_give_up, 		param_list=""},
	draw_month_sign_reward = {		code = 209,		command = "draw_month_sign_reward", 			command_fun = command_draw_month_sign_reward, 			param_list=""},
	glories_shop_init = {			code = 210,		command = "glories_shop_init", 					command_fun = command_glories_shop_init, 				param_list=""},
	glories_shop_exchange = {		code = 211,		command = "glories_shop_exchange", 				command_fun = command_glories_shop_exchange, 			param_list=""},
	draw_month_week_reward = {		code = 212,		command = "draw_month_week_reward",				command_fun = command_draw_month_week_reward,			param_list=""},
	spirite_palace_shop_init = {	code = 213,		command = "spirite_palace_shop_init",			command_fun = command_spirite_palace_shop_init,			param_list=""},
	spirite_palace_shop_exchange = {code = 214,		command = "spirite_palace_shop_exchange",		command_fun = command_spirite_palace_shop_exchange,		param_list=""},
	spirite_palace_init = {			code = 215,		command = "spirite_palace_init",				command_fun = command_spirite_palace_init,				param_list=""},
	spirite_palace_choose_event = {	code = 216,		command = "spirite_palace_choose_event",		command_fun = command_spirite_palace_choose_event,		param_list=""},
	spirite_palace_event_start = {	code = 217,		command = "spirite_palace_event_start",			command_fun = command_spirite_palace_event_start,		param_list=""},
	spirite_palace_reset = {		code = 218,		command = "spirite_palace_reset",				command_fun = command_spirite_palace_reset,				param_list=""},
	spirite_palace_look_formation = {code = 219,	command = "spirite_palace_look_formation",		command_fun = command_spirite_palace_look_formation,	param_list=""},
	spirite_palace_buy = {			code = 220,		command = "spirite_palace_buy",					command_fun = command_spirite_palace_buy,				param_list=""},
	spirite_palace_auto_play = {	code = 221,		command = "spirite_palace_auto_play",			command_fun = command_spirite_palace_auto_play,			param_list=""},
	spirite_palace_cast_equipment = {code = 222,	command = "spirite_palace_cast_equipment",		command_fun = command_spirite_palace_cast_equipment,	param_list=""},
	cross_server_fight_init = {		code = 223,		command = "cross_server_fight_init",			command_fun = command_cross_server_fight_init,			param_list=""},
	cross_server_fight_apply = {	code = 224,		command = "cross_server_fight_apply",			command_fun = command_cross_server_fight_apply,			param_list=""},
	cross_server_join_game_init = {	code = 225,		command = "cross_server_join_game_init",		command_fun = command_cross_server_join_game_init,		param_list=""},
	cross_server_update_info = {	code = 226,		command = "cross_server_update_info",			command_fun = command_cross_server_update_info,			param_list=""},
	cross_server_encourage = {		code = 227,		command = "cross_server_encourage",				command_fun = command_cross_server_encourage,			param_list=""},
	cross_server_fight_record = {	code = 228,		command = "cross_server_fight_record",			command_fun = command_cross_server_fight_record,		param_list=""},
	cross_server_self_info = {		code = 229,		command = "cross_server_self_info",				command_fun = command_cross_server_self_info,			param_list=""},
	cross_server_fight_record_list = {code = 230,	command = "cross_server_fight_record_list",		command_fun = command_cross_server_fight_record_list,	param_list=""},
	cross_server_prostrate_init = { code = 231,		command = "cross_server_prostrate_init",		command_fun = command_cross_server_prostrate_init,		param_list=""},
	cross_server_prostrate = { 		code = 232,		command = "cross_server_prostrate",				command_fun = command_cross_server_prostrate,			param_list=""},
	equipment_limit_init = { 		code = 233,		command = "equipment_limit_init",				command_fun = command_equipment_limit_init,				param_list=""},
	equipment_limit_start = { 		code = 234,		command = "equipment_limit_start",				command_fun = command_equipment_limit_start,			param_list=""},
	draw_equipment_limit = { 		code = 235,	    command = "draw_equipment_limit",		        command_fun = command_draw_equipment_limit,		        param_list=""},
	secret_shopman_init = { 		code = 236,	    command = "secret_shopman_init",		        command_fun = command_secret_shopman_init,		        param_list=""},
	three_kingdoms_init = { 		code = 237,	    command = "three_kingdoms_init",		        command_fun = command_three_kingdoms_init,		        param_list=""},
	three_kingdoms_fight = { 		code = 238,	    command = "three_kingdoms_fight",		        command_fun = command_three_kingdoms_fight,		        param_list=""},
	get_attribute = { 				code = 239,	    command = "get_attribute",		        		command_fun = command_get_attribute,		        	param_list=""},
	dignified_shop_buy = { 			code = 240,	    command = "dignified_shop_buy",		        	command_fun = command_dignified_shop_buy,		        param_list=""},
	equipment_refining = { 			code = 241,	    command = "equipment_refining",		        	command_fun = command_equipment_refining,		        param_list=""},
	recycle_init = { 				code = 242,	    command = "recycle_init",		        		command_fun = command_recycle_init,		        		param_list=""},
	daily_instance = { 				code = 243,	    command = "daily_instance",		        		command_fun = command_daily_instance,		       		param_list=""},
	cultivate_start = { 			code = 244,		command = "cultivate_start",		        	command_fun = command_cultivate_start,		       		param_list=""},
	cultivate_replace = { 			code = 245,		command = "cultivate_replace",		        	command_fun = command_cultivate_replace,		       	param_list=""},
	manor_init = { 					code = 246,		command = "manor_init",		        			command_fun = command_manor_init,		      		 	param_list=""},
	manor_fight = { 				code = 247,		command = "manor_fight",		       			command_fun = command_manor_fight,		      		 	param_list=""},
	manor_patrol = { 				code = 248,		command = "manor_patrol",		       			command_fun = command_manor_patrol,		      		 	param_list=""},
	manor_reward = { 				code = 249,		command = "manor_reward",		       			command_fun = command_manor_reward,		      		 	param_list=""},
	manor_friend = { 				code = 250,		command = "manor_friend",		       			command_fun = command_manor_friend,		      		 	param_list=""},
	manor_repress_rebellion = { 	code = 251,		command = "manor_repress_rebellion",		    command_fun = command_manor_repress_rebellion,		    param_list=""},
	rebel_army_init = { 			code = 252,		command = "rebel_army_init",		        	command_fun = command_rebel_army_init,		      	 	param_list=""},
	rebel_army_exploit = { 			code = 253,		command = "rebel_army_exploit",		        	command_fun = command_rebel_army_exploit,		      	param_list=""},
	rebel_exploit_shop_init = { 	code = 254,		command = "rebel_exploit_shop_init",		    command_fun = command_rebel_exploit_shop_init,		   	param_list=""},
	rebel_exploit_shop_exchange = { code = 255,		command = "rebel_exploit_shop_exchange",		command_fun = command_rebel_exploit_shop_exchange,		param_list=""},
	draw_scene_npc_rewad = { 		code = 256,		command = "draw_scene_npc_rewad",				command_fun = command_draw_scene_npc_rewad,				param_list=""},
	destiny_click = { 				code = 257,		command = "destiny_click",						command_fun = command_destiny_click,					param_list=""},
	daily_mission_init = { 			code = 258,		command = "daily_mission_init",					command_fun = command_daily_mission_init,				param_list=""},
	draw_daily_mission_reward = { 	code = 259,		command = "draw_daily_mission_reward",			command_fun = command_draw_daily_mission_reward,		param_list=""},
	draw_liveness_reward = { 		code = 260,		command = "draw_liveness_reward",				command_fun = command_draw_liveness_reward,				param_list=""},
	server_fund_init = { 			code = 261,		command = "server_fund_init",					command_fun = command_server_fund_init,					param_list=""},
	see_user_info = { 				code = 262,		command = "see_user_info",						command_fun = command_see_user_info,					param_list=""},
	pull_black = { 					code = 263,		command = "pull_black",							command_fun = command_pull_black,						param_list=""},
	draw_achieve_reward = { 		code = 264,		command = "draw_achieve_reward",				command_fun = command_draw_achieve_reward,				param_list=""},
	draw_server_fund = { 			code = 265,		command = "draw_server_fund",					command_fun = command_draw_server_fund,					param_list=""},
	search_friend_apply = { 		code = 266,		command = "search_friend_apply",				command_fun = command_search_friend_apply,				param_list=""},
	dignified_shop_init = { 		code = 267,		command = "dignified_shop_init",				command_fun = command_dignified_shop_init,				param_list=""},
	week_active_init = { 			code = 268,		command = "week_active_init",					command_fun = command_week_active_init,					param_list=""},
	celebrity_bulletin_init = { 	code = 269,		command = "celebrity_bulletin_init",			command_fun = command_celebrity_bulletin_init,			param_list=""},
	celebrity_bulletin_support = { 	code = 270,		command = "celebrity_bulletin_support",			command_fun = command_celebrity_bulletin_support,		param_list=""},
	celebrity_leave_msg = { 		code = 271,		command = "celebrity_leave_msg",				command_fun = command_celebrity_leave_msg,				param_list=""},
	unparallel_purchase = { 		code = 272,		command = "unparallel_purchase",				command_fun = command_unparallel_purchase,				param_list=""},
	sweep_kingdoms = { 				code = 273,		command = "sweep_kingdoms",						command_fun = command_sweep_kingdoms,					param_list=""},
	draw_week_reward = { 			code = 274,		command = "draw_week_reward",					command_fun = command_draw_week_reward,					param_list=""},
	vali_platform_account = { 		code = 275,		command = "vali_platform_account",				command_fun = command_vali_platform_account,			param_list=""},
	refush_msg = { 					code = 276,		command = "refush_msg",							command_fun = command_refush_msg,						param_list=""},
	manor_user_init = { 			code = 277,		command = "manor_user_init",					command_fun = command_manor_user_init,					param_list=""},
	remove_black = { 				code = 278,		command = "remove_black",						command_fun = command_remove_black,						param_list=""},
	tencent_balance = { 			code = 279,		command = "tencent_balance",					command_fun = command_tencent_balance,					param_list=""},
	tencent_pay = { 				code = 280,		command = "tencent_pay",						command_fun = command_tencent_pay,						param_list=""},
	rebel_army_fight = { 			code = 281,		command = "rebel_army_fight",					command_fun = command_rebel_army_fight,					param_list=""},
	refush_rebel_army = { 			code = 282,		command = "refush_rebel_army",					command_fun = command_refush_rebel_army,				param_list=""},
	camp_preference = { 			code = 283,		command = "camp_preference",					command_fun = command_camp_preference, 					param_list=""},
	battle_result_verify={			code = 284,		command = "battle_result_verify",				command_fun = command_battle_result_verify, 			param_list=""},
	draw_morrow_reward={			code = 285,		command = "draw_morrow_reward",					command_fun = command_draw_morrow_reward, 				param_list=""},
	rebel_army_share={				code = 286,		command = "rebel_army_share",					command_fun = command_rebel_army_share, 				param_list=""},
	black_shop_init={				code = 287,		command = "black_shop_init",					command_fun = command_black_shop_init, 					param_list=""},
	black_shop_refush={				code = 288,		command = "black_shop_refush",					command_fun = command_black_shop_refush, 				param_list=""},
	black_shop_exchange={			code = 289,		command = "black_shop_exchange",				command_fun = command_black_shop_exchange, 				param_list=""},
	draw_black_shop_reward={		code = 290,		command = "draw_black_shop_reward",				command_fun = command_draw_black_shop_reward, 			param_list=""},
	on_hook={						code = 291,		command = "on_hook",							command_fun = command_on_hook, 							param_list=""},
	refush_on_hook={				code = 292,		command = "refush_on_hook",						command_fun = command_refush_on_hook, 					param_list=""},
	draw_on_hook_reward={			code = 293,		command = "draw_on_hook_reward",				command_fun = command_draw_on_hook_reward, 				param_list=""},
	arena_init2={					code = 294,		command = "arena_init2",						command_fun = command_arena_init2, 						param_list=""},
	mineral_init={					code = 295,		command = "mineral_init",						command_fun = command_mineral_init, 					param_list=""},
	mineral_explore={				code = 296,		command = "mineral_explore",					command_fun = command_mineral_explore, 					param_list=""},
	mineral_pick={					code = 297,		command = "mineral_pick",						command_fun = command_mineral_pick, 					param_list=""},
	mineral_new_project={			code = 298,		command = "mineral_new_project",				command_fun = command_mineral_new_project, 				param_list=""},
	mineral_reward_gain={			code = 299,		command = "mineral_reward_gain",				command_fun = command_mineral_reward_gain, 				param_list=""},
	mineral_workspace_init={		code = 300,		command = "mineral_workspace_init",				command_fun = command_mineral_workspace_init, 			param_list=""},
	mineral_workspace_add={			code = 301,		command = "mineral_workspace_add",				command_fun = command_mineral_workspace_add, 			param_list=""},
	strategy_list={					code = 302,		command = "strategy_list",						command_fun = command_strategy_list, 					param_list=""},
	strategy_add={					code = 303,		command = "strategy_add",						command_fun = command_strategy_add, 					param_list=""},
	strategy_favor={				code = 304,		command = "strategy_favor",						command_fun = command_strategy_favor, 					param_list=""},
	mineral_reset={					code = 305,		command = "mineral_reset",						command_fun = command_mineral_reset, 					param_list=""},
	show_self_message={				code = 306,		command = "show_self_message",					command_fun = command_show_self_message, 				param_list=""},
	reply_message={					code = 307,		command = "reply_message",						command_fun = command_reply_message, 					param_list=""},
	show_reply_message={			code = 308,		command = "show_reply_message",					command_fun = command_show_reply_message, 				param_list=""},
	on_hook_init={					code = 309,		command = "on_hook_init",						command_fun = command_on_hook_init, 					param_list=""},
	show_ship_mould_list={			code = 310,		command = "show_ship_mould_list",				command_fun = command_show_ship_mould_list, 			param_list=""},
	mineral_add_workspace={			code = 311,		command = "mineral_add_workspace",				command_fun = command_mineral_add_workspace, 			param_list=""},
	get_mineral_prop_list={			code = 312,		command = "get_mineral_prop_list",				command_fun = command_get_mineral_prop_list, 			param_list=""},
	user_combat_force_order_reward_init={			code = 313,		command = "user_combat_force_order_reward_init",		command_fun = command_user_combat_force_order_reward_init, 				param_list=""},
	sky_temple_init={				code = 314,		command = "sky_temple_init",					command_fun = command_sky_temple_init, 					param_list=""},
	sky_temple_exchange={			code = 315,		command = "sky_temple_exchange",				command_fun = command_sky_temple_exchange, 				param_list=""},
	ship_destiny_strength={			code = 316,		command = "ship_destiny_strength",				command_fun = command_ship_destiny_strength, 			param_list=""},
	ship_limit_break={				code = 317,		command = "ship_limit_break",					command_fun = command_ship_limit_break, 				param_list=""},
	ship_equip_strength={			code = 318,		command = "ship_equip_strength",				command_fun = command_ship_equip_strength, 				param_list=""},
	ship_train={					code = 319,		command = "ship_train",							command_fun = command_ship_train, 						param_list=""},
	switch_equipment={				code = 320,		command = "switch_equipment",					command_fun = command_switch_equipment, 				param_list=""},
	daily_instance_verify={			code = 321,		command = "daily_instance_verify",				command_fun = command_daily_instance_verify, 			param_list=""},
	ship_transfer={					code = 322,		command = "ship_transfer",						command_fun = command_ship_transfer, 					param_list=""},
	arena_launch2={					code = 323,		command = "arena_launch2",						command_fun = command_arena_launch2, 					param_list=""},
	arena2_refush={					code = 324,		command = "arena2_refush",						command_fun = command_arena2_refush, 					param_list=""},
	ship_purchase={					code = 325,		command = "ship_purchase",						command_fun = command_ship_purchase, 					param_list=""},
	formation_exchange={			code = 326,		command = "formation_exchange",					command_fun = command_formation_exchange, 				param_list=""},
	mine_fight_launch={				code = 327,		command = "mine_fight_launch",					command_fun = command_mine_fight_launch, 				param_list=""},
	battle_result_start={			code = 328,		command = "battle_result_start",				command_fun = command_battle_result_start, 				param_list=""},
	draw_union_liveness_reward={    code = 329,		command = "draw_union_liveness_reward",			command_fun = command_draw_union_liveness_reward, 		param_list=""},
	unino_pic_frame_exchange={		code = 330,		command = "unino_pic_frame_exchange",		 	command_fun = command_unino_pic_frame_exchange, 		param_list=""},
	set_accept_friend_request={		code = 331,		command = "set_accept_friend_request",		 	command_fun = command_set_accept_friend_request, 		param_list=""},
	union_pve_init={				code = 332,		command = "union_pve_init",						command_fun = command_union_pve_init,					param_list=""},
	draw_union_scene_reward={		code = 333,		command = "draw_union_scene_reward",			command_fun = command_draw_union_scene_reward,			param_list=""},
	partner_bounty_init = {			code = 334,		command = "partner_bounty_init",				command_fun = command_partner_bounty_init,				param_list=""},
	partner_bounty_get = {			code = 335,		command = "partner_bounty_get",					command_fun = command_partner_bounty_get,				param_list=""},
	partner_bounty_get_reward = {	code = 336,		command = "partner_bounty_get_reward",			command_fun = command_partner_bounty_get_reward,		param_list=""},
	random_event_launch = 		{	code = 337,		command = "random_event_launch",				command_fun = command_random_event_launch,				param_list=""},
	random_event_close = {			code = 338,		command = "random_event_close",					command_fun = command_random_event_close,				param_list=""},
	random_event_refresh = {		code = 339,		command = "random_event_refresh",				command_fun = command_random_event_refresh,				param_list=""},
	share_reward_init = {			code = 340,		command = "share_reward_init",					command_fun = command_share_reward_init,				param_list=""},
	share_reward = {				code = 341,		command = "share_reward",						command_fun = command_share_reward,						param_list=""},
	share_game = {					code = 342,		command = "share_game",							command_fun = command_share_game,						param_list=""},
	random_event_open = {			code = 343,		command = "random_event_open",					command_fun = command_random_event_open,				param_list=""},
	mineral_reward_gain_all = {		code = 344,		command = "mineral_reward_gain_all",			command_fun = command_mineral_reward_gain_all,			param_list=""},
	bomb_purchase =           {		code = 345,		command = "bomb_purchase",				        command_fun = command_bomb_purchase,			        param_list=""},
	ship_comment_init ={			code = 346,		command = "ship_comment_init",				    command_fun = command_ship_comment_init,			    param_list=""},
	ship_comment_content ={			code = 347,		command = "ship_comment_content",				command_fun = command_ship_comment_content,			    param_list=""},
	ship_comment_add ={				code = 348,		command = "ship_comment_add",				    command_fun = command_ship_comment_add,			    	param_list=""},
	ship_comment_favour ={			code = 349,		command = "ship_comment_favour",				command_fun = command_ship_comment_favour,				param_list=""},
	reply_grade ={					code = 350,		command = "reply_grade",						command_fun = command_reply_grade,						param_list=""},
	mine_event_launch ={			code = 351,		command = "mine_event_launch",					command_fun = command_mine_event_launch,				param_list=""},
	mine_boss_launch ={				code = 352,		command = "mine_boss_launch",					command_fun = command_mine_boss_launch,					param_list=""},
	mine_monster_reset={			code = 353,		command = "mine_monster_reset",					command_fun = command_mine_monster_reset,				param_list=""},
	map_scattered_init={			code = 354,		command = "map_scattered_init",					command_fun = command_map_scattered_init,				param_list=""},
	map_init={						code = 355,		command = "map_init",							command_fun = command_map_init,							param_list=""},
	self_grab_land_init={			code = 356,		command = "self_grab_land_init",				command_fun = command_self_grab_land_init,				param_list=""},
	hold_build={					code = 357,		command = "hold_build",							command_fun = command_hold_build,						param_list=""},
	hold_view={						code = 358,		command = "hold_view",							command_fun = command_hold_view,						param_list=""},
	hold_extend={					code = 359,		command = "hold_extend",						command_fun = command_hold_extend,						param_list=""},
	hold_drop={						code = 360,		command = "hold_drop",							command_fun = command_hold_drop,						param_list=""},
	hold_drop_efficacy={			code = 361,		command = "hold_drop_efficacy",					command_fun = command_hold_drop_efficacy,				param_list=""},
	marquee_init={					code = 362,		command = "marquee_init",						command_fun = command_marquee_init,						param_list=""},
	cast_soul_stone={				code = 363,		command = "cast_soul_stone",					command_fun = command_cast_soul_stone,					param_list=""},
	make_contract={					code = 364,		command = "make_contract",						command_fun = command_make_contract,					param_list=""},
	rush_four_attribute={			code = 365,		command = "rush_four_attribute",				command_fun = command_rush_four_attribute,				param_list=""},
	warcraft_info_init={			code = 366,		command = "warcraft_info_init",					command_fun = command_warcraft_info_init,				param_list=""},
	warcraft_fight={				code = 367,		command = "warcraft_fight",						command_fun = command_warcraft_fight,					param_list=""},
	warcraft_get_reward={			code = 368,		command = "warcraft_get_reward",				command_fun = command_warcraft_get_reward,				param_list=""},
	warcraft_shop_init={			code = 369,		command = "warcraft_shop_init",					command_fun = command_warcraft_shop_init,				param_list=""},
	warcraft_shop_buy={				code = 370,		command = "warcraft_shop_buy",					command_fun = command_warcraft_shop_buy	,				param_list=""},
	warcraft_show_rank_list={		code = 371,		command = "warcraft_show_rank_list",			command_fun = command_warcraft_show_rank_list,			param_list=""},
	warcraft_rush_fighter={			code = 372,		command = "warcraft_rush_fighter",				command_fun = command_warcraft_rush_fighter,			param_list=""},
	warcraft_buy_fight_count={		code = 373,		command = "warcraft_buy_fight_count",			command_fun = command_warcraft_buy_fight_count,			param_list=""},
	warcraft_see_user_formation={	code = 374,		command = "warcraft_see_user_formation",		command_fun = command_warcraft_see_user_formation,		param_list=""},
	switch_formation={				code = 375,		command = "switch_formation",					command_fun = command_switch_formation,					param_list=""},
	draw_win_count_reward={			code = 376,		command = "draw_win_count_reward",				command_fun = command_draw_win_count_reward,			param_list=""},
	buy_fourth_formation={			code = 377,		command = "buy_fourth_formation",				command_fun = command_buy_fourth_formation,				param_list=""},
	ship_one_key_escalate ={		code = 378,		command = "ship_one_key_escalate",				command_fun = command_ship_one_key_escalate,			param_list=""},
	equipment_one_key_escalate ={	code = 379,		command = "equipment_one_key_escalate",			command_fun = command_equipment_one_key_escalate,		param_list=""},
	one_key_draw_reward ={			code = 380,		command = "one_key_draw_reward",			    command_fun = command_one_key_draw_reward,				param_list=""},
	draw_hold_integral_reward = {	code = 381,		command = "draw_hold_integral_reward",			command_fun = command_draw_hold_integral_reward,		param_list=""},
	hold_integral_init = {			code = 382,		command = "hold_integral_init",					command_fun = command_hold_integral_init,				param_list=""},
	unino_formation_menber_list = {	code = 383,		command = "unino_formation_menber_list",		command_fun = command_unino_formation_menber_list,		param_list=""},
	unino_set_formation = {			code = 384,		command = "unino_set_formation",				command_fun = command_unino_set_formation,				param_list=""},
	unino_fight_apply = {			code = 385,		command = "unino_fight_apply",					command_fun = command_unino_fight_apply,				param_list=""},
	unino_fight_init = {			code = 386,		command = "unino_fight_init",					command_fun = command_unino_fight_init,					param_list=""},
	unino_fight = {					code = 387,		command = "unino_fight",						command_fun = command_unino_fight,						param_list=""},
	unino_map_refush = {			code = 388,		command = "unino_map_refush",					command_fun = command_unino_map_refush,					param_list=""},
	unino_message_refush = {		code = 389,		command = "unino_message_refush",				command_fun = command_unino_message_refush,				param_list=""},
	draw_union_campsite_reward = {	code = 390,		command = "draw_union_campsite_reward",			command_fun = command_draw_union_campsite_reward,		param_list=""},
	refush_cache_message = {		code = 391,		command = "refush_cache_message",				command_fun = command_refush_cache_message,				param_list=""},
	fortune = 					{	code = 392,		command = "fortune",							command_fun = command_fortune,							param_list=""},
	manor_double_reward = 		{	code = 393,		command = "manor_double_reward",				command_fun = command_manor_double_reward,				param_list=""},
	warcraft_info_refrush = 	{	code = 394,		command = "warcraft_info_refrush",				command_fun = command_warcraft_info_refrush,			param_list=""},
	magic_trap_formation_change = {	code = 395,		command = "magic_trap_formation_change",		command_fun = command_magic_trap_formation_change,		param_list=""},
	magic_trap_formation_clear = {	code = 396,		command = "magic_trap_formation_clear",			command_fun = command_magic_trap_formation_clear,		param_list=""},
	awaken_shop_init = 			{	code = 397,		command = "awaken_shop_init",					command_fun = command_awaken_shop_init,					param_list=""},
	awaken_shop_exchange = 		{	code = 398,		command = "awaken_shop_exchange",				command_fun = command_awaken_shop_exchange,				param_list=""},
	awaken_shop_refresh = 		{	code = 399,		command = "awaken_shop_refresh",				command_fun = command_awaken_shop_refresh,				param_list=""},
	awaken_equipment_form = 	{	code = 400,		command = "awaken_equipment_form",				command_fun = command_awaken_equipment_form,			param_list=""},
	awaken_equipment_adron = 	{	code = 401,		command = "awaken_equipment_adron",				command_fun = command_awaken_equipment_adron,			param_list=""},
	ship_awaken = 				{	code = 402,		command = "ship_awaken",						command_fun = command_ship_awaken,						param_list=""},
	awaken_refine = 			{	code = 403,		command = "awaken_refine",						command_fun = command_awaken_refine,					param_list=""},
	magic_trap_escalate = 		{	code = 404,		command = "magic_trap_escalate",				command_fun = command_magic_trap_escalate,				param_list=""},
	magic_trap_grow_up = 		{	code = 405,		command = "magic_trap_grow_up",					command_fun = command_magic_trap_grow_up,				param_list=""},
	secret_shopman_exchange = 	{	code = 406,		command = "secret_shopman_exchange",			command_fun = command_secret_shopman_exchange,			param_list=""},
	equipment_up_star = 		{	code = 407,		command = "equipment_up_star",					command_fun = command_equipment_up_star,				param_list=""},


	id_register = {					code = 410,		command = "id_register",		 				command_fun = command_id_register, 						param_list=""},
	birthday_record = {				code = 411,		command = "birthday_record",		 			command_fun = command_birthday_record, 					param_list=""},
	vali_id = {						code = 412,		command = "vali_id",		 					command_fun = command_vali_id, 							param_list=""},

	pet_change_formation =  	{	code = 450,		command = "pet_change_formation",				command_fun = command_pet_change_formation,				param_list=""},
	pet_escalate =  			{	code = 451,		command = "pet_escalate",						command_fun = command_pet_escalate,						param_list=""},
	pet_grow_up =  				{	code = 452,		command = "pet_grow_up",						command_fun = command_pet_grow_up,						param_list=""},
	pet_shop_init=				{	code = 453,		command = "pet_shop_init",						command_fun = command_pet_shop_init,					param_list=""},
	pet_shop_refresh=			{   code = 454,		command = "pet_shop_refresh",					command_fun = command_pet_shop_refresh,					param_list=""},
	pet_shop_exchange=          {   code = 455,		command = "pet_shop_exchange",					command_fun	= command_pet_shop_exchange,				param_list=""},
	pet_train=          		{   code = 456,		command = "pet_train",							command_fun	= command_pet_train,						param_list=""},
	pet_equip=          		{   code = 457,		command = "pet_equip",							command_fun	= command_pet_equip,						param_list=""},
	pet_counterpart_init=       {   code = 458,		command = "pet_counterpart_init",				command_fun	= command_pet_counterpart_init,				param_list=""},
	pet_counterpart_launch=     {   code = 459,		command = "pet_counterpart_launch",				command_fun	= command_pet_counterpart_launch,			param_list=""},
	pet_counterpart_get_reward= {   code = 460,		command = "pet_counterpart_get_reward",			command_fun	= command_pet_counterpart_get_reward,		param_list=""},
	pet_counterpart_go_next=    {   code = 461,		command = "pet_counterpart_go_next",			command_fun	= command_pet_counterpart_go_next,			param_list=""},
	pet_counterpart_reset=      {   code = 462,		command = "pet_counterpart_reset",				command_fun	= command_pet_counterpart_reset,			param_list=""},


	new_share_reward_init =     {   code = 470,		command = "new_share_reward_init",				command_fun	= command_new_share_reward_init,			param_list=""},

	draw_share_reward =         {   code = 471,		command = "draw_share_reward",					command_fun	= command_draw_share_reward,				param_list=""},

	share_write_invite_key =    {   code = 472,		command = "share_write_invite_key",				command_fun	= command_share_write_invite_key,			param_list=""},
	one_key_sweep_arena =    	{   code = 480,		command = "one_key_sweep_arena",				command_fun	= command_one_key_sweep_arena,				param_list=""},
	one_key_sweep_three_kingdoms ={   code = 481,	command = "one_key_sweep_three_kingdoms",		command_fun	= command_one_key_sweep_three_kingdoms,		param_list=""},
	rush_fight_times =  		{	code = 482,		command = "rush_fight_times",					command_fun = command_rush_fight_times,					param_list=""},
	limited_recharge_init =  	{	code = 490,		command = "limited_recharge_init",				command_fun = command_limited_recharge_init,			param_list=""},
	limited_recharge_buy =  	{	code = 491,		command = "limited_recharge_buy",				command_fun = command_limited_recharge_buy,				param_list=""},
	limited_recharge_get_reward = {	code = 492,		command = "limited_recharge_get_reward",		command_fun = command_limited_recharge_get_reward,		param_list=""},



	rebel_boss_init = 			{	code = 520,		command = "rebel_boss_init",					command_fun = command_rebel_boss_init,					param_list=""},
	rebel_boss_fight = 			{	code = 521,		command = "rebel_boss_fight",					command_fun = command_rebel_boss_fight,					param_list=""},
	level_gift_buy = 			{	code = 550,		command = "level_gift_buy",						command_fun = command_level_gift_buy,					param_list=""},
	user_create_time = 			{	code = 560,		command = "user_create_time",					command_fun = command_user_create_time,					param_list=""},
	top_rank_init = 			{	code = 561,		command = "top_rank_init",						command_fun = command_top_rank_init,					param_list=""},
	recharge_rank_init = 		{	code = 562,		command = "recharge_rank_init",					command_fun = command_recharge_rank_init,				param_list=""},
	get_online_gift_info = 		{	code = 563,		command = "get_online_gift_info",				command_fun = command_get_online_gift_info,				param_list=""},




	lighten_star =				{	code = 6001,	command = "lighten_star",						command_fun = command_lighten_star,						param_list=""},
	binding_fetter = 			{	code = 6002,	command = "binding_fetter",						command_fun = command_binding_fetter,					param_list=""},
	remove_fetter = 			{	code = 6003,	command = "remove_fetter",						command_fun = command_remove_fetter,					param_list=""},
	join_warfare = 				{	code = 6004,	command = "join_warfare",						command_fun = command_join_warfare,						param_list=""},
	join_city = 				{	code = 6006,	command = "join_city",							command_fun = command_join_city,						param_list=""},
	shoot_city = 				{	code = 6007,	command = "shoot_city",							command_fun = command_shoot_city,						param_list=""},
	retreat_city = 				{	code = 6008,	command = "retreat_city",						command_fun = command_retreat_city,						param_list=""},
	begin_match = 				{	code = 6009,	command = "begin_match",						command_fun = command_begin_match,						param_list=""},
	use_card = 					{	code = 6010,	command = "use_card",							command_fun = command_use_card,							param_list=""},
	look_up_situation = 		{	code = 6011,	command = "look_up_situation",					command_fun = command_look_up_situation,				param_list=""},
	release_order = 			{	code = 6012,	command = "release_order",						command_fun = command_release_order,					param_list=""},
	look_up_war_situation = 	{	code = 6013,	command = "look_up_war_situation",				command_fun = command_look_up_war_situation,			param_list=""},
	response_situation = 		{	code = 6014,	command = "response_situation",					command_fun = command_response_situation,				param_list=""},
	renascence = 				{	code = 6015,	command = "renascence",							command_fun = command_renascence,						param_list=""},
	provisions_buy = 			{	code = 6016,	command = "provisions_buy",						command_fun = command_provisions_buy,					param_list=""},
	chose_camp = 				{	code = 6017,	command = "chose_camp",							command_fun = command_chose_camp,						param_list=""},
	get_warfare_task = 			{	code = 6018,	command = "get_warfare_task",					command_fun = command_get_warfare_task,					param_list=""},
	draw_warfare_task_reward = 	{	code = 6019,	command = "draw_warfare_task_reward",			command_fun = command_draw_warfare_task_reward,			param_list=""},
	get_warfare_ranking = 		{	code = 6020,	command = "get_warfare_ranking",				command_fun = command_get_warfare_ranking,				param_list=""},
	refush_city_info = 			{	code = 6021,	command = "refush_city_info",					command_fun = command_refush_city_info_ranking,			param_list=""},
	clear_fight_cd = 			{	code = 6022,	command = "clear_fight_cd",						command_fun = command_clear_fight_cd,					param_list=""},
	warfare_get_my_fight_info = {	code = 6023,	command = "warfare_get_my_fight_info",			command_fun = command_warfare_get_my_fight_info,		param_list=""},
	draw_warfare_order_reward = {	code = 6024,	command = "draw_warfare_order_reward",			command_fun = command_draw_warfare_order_reward,		param_list=""},
	build_level_up = 			{	code = 6025,	command = "build_level_up",						command_fun = command_build_level_up,					param_list=""},
	build_check_up = 			{	code = 6026,	command = "build_check_up",						command_fun = command_build_check_up,					param_list=""},
	build_speed_up = 			{	code = 6027,	command = "build_speed_up",						command_fun = command_build_speed_up,					param_list=""},
	get_home_resource = 		{	code = 6028,	command = "get_home_resource",					command_fun = command_get_home_resource,				param_list=""},
	gem_level_up = 				{	code = 6029,	command = "gem_level_up",						command_fun = command_gem_level_up,						param_list=""},
	gem_inlay = 				{	code = 6030,	command = "gem_inlay",							command_fun = command_gem_inlay,						param_list=""},
	gem_inlay_down = 			{	code = 6031,	command = "gem_inlay_down",						command_fun = command_gem_inlay_down,					param_list=""},
	ship_refining =  			{	code = 6032,	command = "ship_refining",						command_fun = command_ship_refining,					param_list=""},
	barracks_teach_check_cd =  	{	code = 6033,	command = "barracks_teach_check_cd",			command_fun = command_barracks_teach_check_cd,			param_list=""},
	barracks_teach_clear_cd =  	{	code = 6034,	command = "barracks_teach_clear_cd",			command_fun = command_barracks_teach_clear_cd,			param_list=""},
	barracks_teach_update =  	{	code = 6035,	command = "barracks_teach_update",				command_fun = command_barracks_teach_update,			param_list=""},
	wear_majesty_change =  		{	code = 6036,	command = "wear_majesty_change",				command_fun = command_wear_majesty_change,				param_list=""},
	request_fate = 				{	code = 6038,	command = "request_fate",						command_fun = command_request_fate,						param_list=""},
	awaken_equipment = 			{	code = 6039,	command = "awaken_equipment",					command_fun = command_awaken_equipment,					param_list=""},
	ship_rebirth = 				{	code = 6040,	command = "ship_rebirth",						command_fun = command_ship_rebirth,						param_list=""},
	buy_copy_attack_times =  	{	code = 6041,	command = "buy_copy_attack_times",				command_fun = command_buy_copy_attack_times,			param_list=""},
	gem_sweep =  				{	code = 6042,	command = "gem_sweep",							command_fun = command_gem_sweep,						param_list=""},
	equip_sweep =  				{	code = 6043,	command = "equip_sweep",						command_fun = command_equip_sweep,						param_list=""},
	three_kings_sweep=  		{	code = 6044,	command = "three_kings_sweep",					command_fun = command_three_kings_sweep,				param_list=""},
	three_kings_reset =  		{	code = 6045,	command = "three_kings_reset",					command_fun = command_three_kings_reset,				param_list=""},
	raiders_cut_refrush =  		{	code = 6046,	command = "raiders_cut_refrush",				command_fun = command_raiders_cut_refrush,				param_list=""},
	ship_military_init =  		{	code = 6047,	command = "ship_military_init",					command_fun = command_ship_military_init,				param_list=""},
	ship_military_refrush_quality = {	code = 6048,	command = "ship_military_refrush_quality",	command_fun = command_ship_military_refrush_quality,	param_list=""},
	ship_military_start_transport = {	code = 6049,	command = "ship_military_start_transport",	command_fun = command_ship_military_start_transport,	param_list=""},
	ship_military_speed_transport = {	code = 6050,	command = "ship_military_speed_transport",	command_fun = command_ship_military_speed_transport,	param_list=""},
	ship_military_check_transport_end = {	code = 6051,	command = "ship_military_check_transport_end",	command_fun = command_ship_military_check_transport_end,	param_list=""},
	ship_military_change_users = {	code = 6052,	command = "ship_military_change_users",	command_fun = command_ship_military_change_users,				param_list=""},
	three_kings_get_rank_info = {	code = 6053,	command = "three_kings_get_rank_info",	command_fun = command_three_kings_get_rank_info,				param_list=""},
	order_get_info = 			{	code = 6054,	command = "order_get_info",						command_fun = command_order_get_info,					param_list=""},
	buy_arena_launch_count	= 	{	code = 6055,	command = "buy_arena_launch_count",				command_fun = command_buy_arena_launch_count,			param_list=""},
	arena_lounch_refresh = 		{	code = 6056,	command = "arena_lounch_refresh",				command_fun = command_arena_lounch_refresh,				param_list=""},
	get_user_mail = 			{	code = 6057,	command = "get_user_mail",					    command_fun = command_get_user_mail,					param_list=""},
	delete_mail = 				{	code = 6058,	command = "delete_mail",					    command_fun = command_delete_mail,						param_list=""},
	draw_attachment_in_mail = 	{	code = 6059,	command = "draw_attachment_in_mail",			command_fun = command_draw_attachment_in_mail,			param_list=""},
	get_task_reward = 			{	code = 6060,	command = "get_task_reward",					command_fun = command_get_task_reward,					param_list=""},
	activity_init = 			{	code = 6061,	command = "activity_init",						command_fun = command_activity_init,					param_list=""},
	draw_activity_reward = 		{	code = 6062,	command = "draw_activity_reward",				command_fun = command_draw_activity_reward,				param_list=""},
	get_other_user_info = 		{	code = 6063,	command = "get_other_user_info",				command_fun = command_get_other_user_info,				param_list=""},
	get_other_user_ship_info = 	{	code = 6064,	command = "get_other_user_ship_info",			command_fun = command_get_other_user_ship_info,			param_list=""},
	get_other_user_equip_info = {	code = 6065,	command = "get_other_user_equip_info",			command_fun = command_get_other_user_equip_info,		param_list=""},
	grow_up_activity_buy = 		{	code = 6066,	command = "grow_up_activity_buy",				command_fun = command_grow_up_activity_buy,				param_list=""},
	one_key_lighten_star = 		{	code = 6067,	command = "one_key_lighten_star",				command_fun = command_one_key_lighten_star,				param_list=""},
	shop_buy_prop = 			{	code = 6068,	command = "shop_buy_prop",						command_fun = command_shop_buy_prop,					param_list=""},
	rider_horse = 				{	code = 6069,	command = "rider_horse",						command_fun = command_rider_horse,						param_list=""},
	inlay_horse_spirit = 		{	code = 6070,	command = "inlay_horse_spirit",					command_fun = command_inlay_horse_spirit,				param_list=""},
	find_horse = 				{	code = 6071,	command = "find_horse",							command_fun = command_find_horse,						param_list=""},
	recuit_horse = 				{	code = 6072,	command = "recuit_horse",						command_fun = command_recuit_horse,						param_list=""},
	get_recuit_horse_info = 	{	code = 6073,	command = "get_recuit_horse_info",				command_fun = command_get_recuit_horse_info,			param_list=""},
	horse_spirit_pay = 			{	code = 6074,	command = "horse_spirit_pay",					command_fun = command_horse_spirit_pay,					param_list=""},
	combing_horse = 			{	code = 6075,	command = "combing_horse",						command_fun = command_combing_horse,					param_list=""},
	horse_spirit_level_up = 	{	code = 6076,	command = "horse_spirit_level_up",				command_fun = command_horse_spirit_level_up,			param_list=""},
	refining_horse = 			{	code = 6077,	command = "refining_horse",						command_fun = command_refining_horse,					param_list=""},
	union_endless_init = 		{	code = 6078,	command = "union_endless_init",					command_fun = command_union_endless_init,				param_list=""},
	union_endless_join_group = 	{	code = 6079,	command = "union_endless_join_group",			command_fun = command_union_endless_join_group,			param_list=""},
	union_endless_create_group ={	code = 6080,	command = "union_endless_create_group",			command_fun = command_union_endless_create_group,		param_list=""},
	get_ship_info =				{	code = 6081,	command = "get_ship_info",						command_fun = command_get_ship_info,					param_list=""},
	union_order =				{	code = 6082,	command = "union_order",						command_fun = command_union_order,						param_list=""},
	union_other_persion_list =	{	code = 6083,	command = "union_other_persion_list",			command_fun = command_union_other_persion_list,			param_list=""},
	union_food_copy_init =		{	code = 6084,	command = "union_food_copy_init",				command_fun = command_union_food_copy_init,				param_list=""},
	union_food_copy_create_group ={	code = 6085,	command = "union_food_copy_create_group",		command_fun = command_union_food_copy_create_group,		param_list=""},
	union_food_copy_join_group ={	code = 6086,	command = "union_food_copy_join_group",			command_fun = command_union_food_copy_join_group,		param_list=""},
	union_stronghold_hold 		={	code = 6087,	command = "union_stronghold_hold",				command_fun = command_union_stronghold_hold,			param_list=""},
	union_stronghold_init 		={	code = 6088,	command = "union_stronghold_init",				command_fun = command_union_stronghold_init,			param_list=""},
	union_stronghold_fight 		={	code = 6089,	command = "union_stronghold_fight",				command_fun = command_union_stronghold_fight,			param_list=""},
	union_stronghold_resurrect 	={	code = 6090,	command = "union_stronghold_resurrect",			command_fun = command_union_stronghold_resurrect,		param_list=""},
	union_stronghold_retreat 	={	code = 6091,	command = "union_stronghold_retreat",			command_fun = command_union_stronghold_retreat,			param_list=""},
	union_stronghold_clear_match_cd={	code = 6092,command = "union_stronghold_clear_match_cd",	command_fun = command_union_stronghold_clear_match_cd,	param_list=""},
	union_stronghold_bidding	={	code = 6093,	command = "union_stronghold_bidding",			command_fun = command_union_stronghold_bidding,			param_list=""},
	union_stronghold_battle_switch	={	code = 6094,command = "union_stronghold_battle_switch",		command_fun = command_union_stronghold_battle_switch,	param_list=""},
	union_stronghold_battle_details	={	code = 6095,command = "union_stronghold_battle_details",	command_fun = command_union_stronghold_battle_details,	param_list=""},


	battle_result_fail 			={	code = 6100,	command = "battle_result_fail",					command_fun = command_battle_result_fail,				param_list=""},
	init_user_socket_service 	={	code = 6101,	command = "init_user_socket_service",			command_fun = command_init_user_socket_service,			param_list=""},
	city_resource_hold_init 	={	code = 6102,	command = "city_resource_hold_init",			command_fun = command_city_resource_hold_init,			param_list=""},
	city_resource_hold_quit 	={	code = 6103,	command = "city_resource_hold_quit",			command_fun = command_city_resource_hold_quit,			param_list=""},
	city_resource_hold_move_to_city 	={	code = 6104,	command = "city_resource_hold_move_to_city",			command_fun = command_city_resource_hold_move_to_city,		param_list=""},
	city_resource_hold_get_city_resource 	={	code = 6105,	command = "city_resource_hold_get_city_resource",	command_fun = command_city_resource_hold_get_city_resource,	param_list=""},
	city_resource_hold_get_resource_users   ={code = 6106,command = "city_resource_hold_get_resource_users",	command_fun = command_city_resource_hold_get_resource_users,	param_list=""},
	city_resource_hold   		={code = 6107,		command = "city_resource_hold",					command_fun = command_city_resource_hold,				param_list=""},
	city_resource_hold_get_user_position_info ={code = 6108,command = "city_resource_hold_get_user_position_info",command_fun = command_city_resource_hold_get_user_position_info,param_list=""},
	city_resource_hold_encourage ={code = 6109,		command = "city_resource_hold_encourage",		command_fun = command_city_resource_hold_encourage,		param_list=""},
	city_resource_un_hold 		={code = 6110,		command = "city_resource_un_hold",				command_fun = command_city_resource_un_hold,				param_list=""},
	city_resource_hold_buy_robot_count 	={code = 6111,command = "city_resource_hold_buy_robot_count",command_fun = command_city_resource_hold_buy_robot_count,	param_list=""},
	city_resource_hold_get_invites 	={code = 6112,	command = "city_resource_hold_get_invites",		command_fun = command_city_resource_hold_get_invites,	param_list=""},
	city_resource_hold_init_invite 	={code = 6113,	command = "city_resource_hold_init_invite",		command_fun = command_city_resource_hold_init_invite,	param_list=""},
	battlefield_report_get 			={code = 6114,	command = "battlefield_report_get",				command_fun = command_battlefield_report_get,			param_list=""},

	answer											={code = 6115, command = "answer",											command_fun = command_answer,											param_list=""},
	answer_exit										={code = 6116, command = "answer_exit",										command_fun = command_answer_exit,										param_list=""},
	answer_init										={code = 6117, command = "answer_init",										command_fun = command_answer_init,										param_list=""},
	arena_launch_clear_cd							={code = 6118, command = "arena_launch_clear_cd",							command_fun = command_arena_launch_clear_cd,							param_list=""},
	arena_launch_formation_change					={code = 6119, command = "arena_launch_formation_change",					command_fun = command_arena_launch_formation_change,					param_list=""},
	arena_lounch_refresh							={code = 6120, command = "arena_lounch_refresh",							command_fun = command_arena_lounch_refresh,								param_list=""},
	arena_shop_refresh								={code = 6121, command = "arena_shop_refresh",								command_fun = command_arena_shop_refresh,								param_list=""},
	arena_worship									={code = 6122, command = "arena_worship",									command_fun = command_arena_worship,									param_list=""},
	armor_buy_times									={code = 6123, command = "armor_buy_times",									command_fun = command_armor_buy_times,									param_list=""},
	armor_check_time								={code = 6124, command = "armor_check_time",								command_fun = command_armor_check_time,									param_list=""},
	armor_formation_change							={code = 6125, command = "armor_formation_change",							command_fun = command_armor_formation_change,							param_list=""},
	armor_packs_expansion							={code = 6126, command = "armor_packs_expansion",							command_fun = command_armor_packs_expansion,							param_list=""},
	armor_production								={code = 6127, command = "armor_production",								command_fun = command_armor_production,									param_list=""},
	armor_quick_wear								={code = 6128, command = "armor_quick_wear",								command_fun = command_armor_quick_wear,									param_list=""},
	armor_sell										={code = 6129, command = "armor_sell",										command_fun = command_armor_sell,										param_list=""},
	armor_upgrade									={code = 6130, command = "armor_upgrade",									command_fun = command_armor_upgrade,									param_list=""},
	armor_wear										={code = 6131, command = "armor_wear",										command_fun = command_armor_wear,										param_list=""},
	avatar_shop_buy									={code = 6132, command = "avatar_shop_buy",									command_fun = command_avatar_shop_buy,									param_list=""},
	barracks_teach_check_cd							={code = 6133, command = "barracks_teach_check_cd",							command_fun = command_barracks_teach_check_cd,							param_list=""},
	barracks_teach_clear_cd							={code = 6134, command = "barracks_teach_clear_cd",							command_fun = command_barracks_teach_clear_cd,							param_list=""},
	barracks_teach_update							={code = 6135, command = "barracks_teach_update",							command_fun = command_barracks_teach_update,							param_list=""},
	barracks_teach_update_cancel					={code = 6136, command = "barracks_teach_update_cancel",					command_fun = command_barracks_teach_update_cancel,						param_list=""},
	battlefield_report_battle_info_get				={code = 6137, command = "battlefield_report_battle_info_get",				command_fun = command_battlefield_report_battle_info_get,				param_list=""},
	battlefield_report_details_get					={code = 6138, command = "battlefield_report_details_get",					command_fun = command_battlefield_report_details_get,					param_list=""},
	battlefield_report_save							={code = 6139, command = "battlefield_report_save",							command_fun = command_battlefield_report_save,							param_list=""},
	battlefield_report_save_delete					={code = 6140, command = "battlefield_report_save_delete",					command_fun = command_battlefield_report_save_delete,					param_list=""},
	battlefield_report_save_get						={code = 6141, command = "battlefield_report_save_get",						command_fun = command_battlefield_report_save_get,						param_list=""},
	boom_buy										={code = 6142, command = "boom_buy",										command_fun = command_boom_buy,											param_list=""},
	build_auto_update								={code = 6143, command = "build_auto_update",								command_fun = command_build_auto_update,								param_list=""},
	build_level_up_cancel							={code = 6144, command = "build_level_up_cancel",							command_fun = command_build_level_up_cancel,							param_list=""},
	build_patrol_check_time							={code = 6145, command = "build_patrol_check_time",							command_fun = command_build_patrol_check_time,							param_list=""},
	build_patrol_draw								={code = 6146, command = "build_patrol_draw",								command_fun = command_build_patrol_draw,								param_list=""},
	build_restore									={code = 6147, command = "build_restore",									command_fun = command_build_restore,									param_list=""},
	build_shop_buy									={code = 6148, command = "build_shop_buy",									command_fun = command_build_shop_buy,									param_list=""},
	buy_build_queue									={code = 6149, command = "buy_build_queue",									command_fun = command_buy_build_queue,									param_list=""},
	buy_prestige									={code = 6150, command = "buy_prestige",									command_fun = command_buy_prestige,										param_list=""},
	buy_super_equipment_copy_attack_count			={code = 6151, command = "buy_super_equipment_copy_attack_count",			command_fun = command_buy_super_equipment_copy_attack_count,			param_list=""},
	camp_duel_battle_init							={code = 6152, command = "camp_duel_battle_init",							command_fun = command_camp_duel_battle_init,							param_list=""},
	camp_duel_check_move							={code = 6153, command = "camp_duel_check_move",							command_fun = command_camp_duel_check_move,								param_list=""},
	camp_duel_choose_line							={code = 6154, command = "camp_duel_choose_line",							command_fun = command_camp_duel_choose_line,							param_list=""},
	camp_duel_exit									={code = 6155, command = "camp_duel_exit",									command_fun = command_camp_duel_exit,									param_list=""},
	camp_duel_init									={code = 6156, command = "camp_duel_init",									command_fun = command_camp_duel_init,									param_list=""},
	camp_duel_rank_list_get							={code = 6157, command = "camp_duel_rank_list_get",							command_fun = command_camp_duel_rank_list_get,							param_list=""},
	camp_duel_shop_exchange							={code = 6158, command = "camp_duel_shop_exchange",							command_fun = command_camp_duel_shop_exchange,							param_list=""},
	camp_duel_shop_refresh							={code = 6159, command = "camp_duel_shop_refresh",							command_fun = command_camp_duel_shop_refresh,							param_list=""},
	camp_duel_signup								={code = 6160, command = "camp_duel_signup",								command_fun = command_camp_duel_signup,									param_list=""},
	check_boom_recover								={code = 6161, command = "check_boom_recover",								command_fun = command_check_boom_recover,								param_list=""},
	check_food_recover								={code = 6162, command = "check_food_recover",								command_fun = command_check_food_recover,								param_list=""},
	check_task_time									={code = 6163, command = "check_task_time",									command_fun = command_check_task_time,									param_list=""},
	check_title_state								={code = 6164, command = "check_title_state",								command_fun = command_check_title_state,								param_list=""},
	city_resource_hold_list_refresh					={code = 6165, command = "city_resource_hold_list_refresh",					command_fun = command_city_resource_hold_list_refresh,					param_list=""},
	city_resource_refrush							={code = 6166, command = "city_resource_refrush",							command_fun = command_city_resource_refrush,							param_list=""},
	command_update									={code = 6167, command = "command_update",									command_fun = command_command_update,									param_list=""},
	complete_fb_task								={code = 6168, command = "complete_fb_task",								command_fun = command_complete_fb_task,									param_list=""},
	delete_all_mail									={code = 6169, command = "delete_all_mail",									command_fun = command_delete_all_mail,									param_list=""},
	delete_all_message								={code = 6170, command = "delete_all_message",								command_fun = command_delete_all_message,								param_list=""},
	delete_message									={code = 6171, command = "delete_message",									command_fun = command_delete_message,									param_list=""},
	draw_answer_reward								={code = 6172, command = "draw_answer_reward",								command_fun = command_draw_answer_reward,								param_list=""},
	draw_arena_lucky_reward							={code = 6173, command = "draw_arena_lucky_reward",							command_fun = command_draw_arena_lucky_reward,							param_list=""},
	draw_arena_order_reward							={code = 6174, command = "draw_arena_order_reward",							command_fun = command_draw_arena_order_reward,							param_list=""},
	draw_arena_score_reward							={code = 6175, command = "draw_arena_score_reward",							command_fun = command_draw_arena_score_reward,							param_list=""},
	draw_attachment_in_mail							={code = 6176, command = "draw_attachment_in_mail",							command_fun = command_draw_attachment_in_mail,							param_list=""},
	draw_expedition_reward							={code = 6177, command = "draw_expedition_reward",							command_fun = command_draw_expedition_reward,							param_list=""},
	draw_fb_reward									={code = 6178, command = "draw_fb_reward",									command_fun = command_draw_fb_reward,									param_list=""},
	draw_first_join_union_reward					={code = 6179, command = "draw_first_join_union_reward",					command_fun = command_draw_first_join_union_reward,						param_list=""},
	draw_rebel_week_reward							={code = 6180, command = "draw_rebel_week_reward",							command_fun = command_draw_rebel_week_reward,							param_list=""},
	draw_union_active_share							={code = 6181, command = "draw_union_active_share",							command_fun = command_draw_union_active_share,							param_list=""},
	draw_union_copy_reward							={code = 6182, command = "draw_union_copy_reward",							command_fun = command_draw_union_copy_reward,							param_list=""},
	draw_union_stronghold_reward					={code = 6183, command = "draw_union_stronghold_reward",					command_fun = command_draw_union_stronghold_reward,						param_list=""},
	elit_sweep										={code = 6184, command = "elit_sweep",										command_fun = command_elit_sweep,										param_list=""},
	enemy_boss_exit									={code = 6185, command = "enemy_boss_exit",									command_fun = command_enemy_boss_exit,									param_list=""},
	enemy_boss_formation_change						={code = 6186, command = "enemy_boss_formation_change",						command_fun = command_enemy_boss_formation_change,						param_list=""},
	enemy_boss_init									={code = 6187, command = "enemy_boss_init",									command_fun = command_enemy_boss_init,									param_list=""},
	enemy_boss_rank_list_get						={code = 6188, command = "enemy_boss_rank_list_get",						command_fun = command_enemy_boss_rank_list_get,							param_list=""},
	equipment_adorn									={code = 6189, command = "equipment_adorn",									command_fun = command_equipment_adorn,									param_list=""},
	equipment_escalate								={code = 6190, command = "equipment_escalate",								command_fun = command_equipment_escalate,								param_list=""},
	equipment_rank_up								={code = 6191, command = "equipment_rank_up",								command_fun = command_equipment_rank_up,								param_list=""},
	equipment_refine								={code = 6192, command = "equipment_refine",								command_fun = command_equipment_refine,									param_list=""},
	equipment_refine_lock							={code = 6193, command = "equipment_refine_lock",							command_fun = command_equipment_refine_lock,							param_list=""},
	equipment_refine_replace						={code = 6194, command = "equipment_refine_replace",						command_fun = command_equipment_refine_replace,							param_list=""},
	equipment_return								={code = 6195, command = "equipment_return",								command_fun = command_equipment_return,									param_list=""},
	expedition_init									={code = 6196, command = "expedition_init",									command_fun = command_expedition_init,									param_list=""},
	expedition_reset								={code = 6197, command = "expedition_reset",								command_fun = command_expedition_reset,									param_list=""},
	expedition_shop_exchange						={code = 6198, command = "expedition_shop_exchange",						command_fun = command_expedition_shop_exchange,							param_list=""},
	expedition_shop_refresh							={code = 6199, command = "expedition_shop_refresh",							command_fun = command_expedition_shop_refresh,							param_list=""},
	expedition_sweep								={code = 6200, command = "expedition_sweep",								command_fun = command_expedition_sweep,									param_list=""},
	extreme_buff_buy								={code = 6201, command = "extreme_buff_buy",								command_fun = command_extreme_buff_buy,									param_list=""},
	extreme_fast_battle								={code = 6202, command = "extreme_fast_battle",								command_fun = command_extreme_fast_battle,								param_list=""},
	extreme_formation_change						={code = 6203, command = "extreme_formation_change",						command_fun = command_extreme_formation_change,							param_list=""},
	extreme_init									={code = 6204, command = "extreme_init",									command_fun = command_extreme_init,										param_list=""},
	extreme_rank_get								={code = 6205, command = "extreme_rank_get",								command_fun = command_extreme_rank_get,									param_list=""},
	extreme_start									={code = 6206, command = "extreme_start",									command_fun = command_extreme_start,									param_list=""},
	facebook_get_reward								={code = 6207, command = "facebook_get_reward",								command_fun = command_facebook_get_reward,								param_list=""},
	facebook_invite_friend							={code = 6208, command = "facebook_invite_friend",							command_fun = command_facebook_invite_friend,							param_list=""},
	factory_product									={code = 6209, command = "factory_product",									command_fun = command_factory_product,									param_list=""},
	factory_product_cancel							={code = 6210, command = "factory_product_cancel",							command_fun = command_factory_product_cancel,							param_list=""},
	factory_product_check_cd						={code = 6211, command = "factory_product_check_cd",						command_fun = command_factory_product_check_cd,							param_list=""},
	factory_product_clear_cd						={code = 6212, command = "factory_product_clear_cd",						command_fun = command_factory_product_clear_cd,							param_list=""},
	fb_launch										={code = 6213, command = "fb_launch",										command_fun = command_fb_launch,										param_list=""},
	fb_login_init									={code = 6214, command = "fb_login_init",									command_fun = command_fb_login_init,									param_list=""},
	fb_reward_init									={code = 6215, command = "fb_reward_init",									command_fun = command_fb_reward_init,									param_list=""},
	formation_save									={code = 6216, command = "formation_save",									command_fun = command_formation_save,									param_list=""},
	gain_limit_check								={code = 6217, command = "gain_limit_check",								command_fun = command_gain_limit_check,									param_list=""},
	get_activity_rank								={code = 6218, command = "get_activity_rank",								command_fun = command_get_activity_rank,								param_list=""},
	get_open_server_rank_info						={code = 6219, command = "get_open_server_rank_info",						command_fun = command_get_open_server_rank_info,						param_list=""},
	get_other_user_horse_info						={code = 6220, command = "get_other_user_horse_info",						command_fun = command_get_other_user_horse_info,						param_list=""},
	get_other_user_ship_info						={code = 6221, command = "get_other_user_ship_info",						command_fun = command_get_other_user_ship_info,							param_list=""},
	get_server_maintenance_info						={code = 6222, command = "get_server_maintenance_info",						command_fun = command_get_server_maintenance_info,						param_list=""},
	get_server_open_info							={code = 6223, command = "get_server_open_info",							command_fun = command_get_server_open_info,								param_list=""},
	get_share_message								={code = 6224, command = "get_share_message",								command_fun = command_get_share_message,								param_list=""},
	get_ship_count									={code = 6225, command = "get_ship_count",									command_fun = command_get_ship_count,									param_list=""},
	get_union_create_info							={code = 6226, command = "get_union_create_info",							command_fun = command_get_union_create_info,							param_list=""},
	get_user_level_rank_info						={code = 6227, command = "get_user_level_rank_info",						command_fun = command_get_user_level_rank_info,							param_list=""},
	get_user_showing_info							={code = 6228, command = "get_user_showing_info",							command_fun = command_get_user_showing_info,							param_list=""},
	get_world_coord_collect							={code = 6229, command = "get_world_coord_collect",							command_fun = command_get_world_coord_collect,							param_list=""},
	grab_red_packet									={code = 6230, command = "grab_red_packet",									command_fun = command_grab_red_packet,									param_list=""},
	guard_buff_buy									={code = 6231, command = "guard_buff_buy",									command_fun = command_guard_buff_buy,									param_list=""},
	guard_check_gain_cd_time						={code = 6232, command = "guard_check_gain_cd_time",						command_fun = command_guard_check_gain_cd_time,							param_list=""},
	guard_clear_cd									={code = 6233, command = "guard_clear_cd",									command_fun = command_guard_clear_cd,									param_list=""},
	guard_exit										={code = 6234, command = "guard_exit",										command_fun = command_guard_exit,										param_list=""},
	guard_formation_save							={code = 6235, command = "guard_formation_save",							command_fun = command_guard_formation_save,								param_list=""},
	guard_list_init									={code = 6236, command = "guard_list_init",									command_fun = command_guard_list_init,									param_list=""},
	guard_order_list								={code = 6237, command = "guard_order_list",								command_fun = command_guard_order_list,									param_list=""},
	guard_set_auto_clear_cd							={code = 6238, command = "guard_set_auto_clear_cd",							command_fun = command_guard_set_auto_clear_cd,							param_list=""},
	guard_stronghold_init							={code = 6239, command = "guard_stronghold_init",							command_fun = command_guard_stronghold_init,							param_list=""},
	head_save										={code = 6240, command = "head_save",										command_fun = command_head_save,										param_list=""},
	horn_use										={code = 6241, command = "horn_use",										command_fun = command_horn_use,											param_list=""},
	horse_spirit_awaken								={code = 6242, command = "horse_spirit_awaken",								command_fun = command_horse_spirit_awaken,								param_list=""},
	majesty_skill_reset								={code = 6243, command = "majesty_skill_reset",								command_fun = command_majesty_skill_reset,								param_list=""},
	mission_skip_info								={code = 6244, command = "mission_skip_info",								command_fun = command_mission_skip_info,								param_list=""},
	one_key_draw_attachment_in_mail					={code = 6245, command = "one_key_draw_attachment_in_mail",					command_fun = command_one_key_draw_attachment_in_mail,					param_list=""},
	one_key_read_mail								={code = 6246, command = "one_key_read_mail",								command_fun = command_one_key_read_mail,								param_list=""},
	one_key_read_message							={code = 6247, command = "one_key_read_message",							command_fun = command_one_key_read_message,								param_list=""},
	order_self_get_info								={code = 6248, command = "order_self_get_info",								command_fun = command_order_self_get_info,								param_list=""},
	parts_exchange									={code = 6249, command = "parts_exchange",									command_fun = command_parts_exchange,									param_list=""},
	prop_change_to									={code = 6250, command = "prop_change_to",									command_fun = command_prop_change_to,									param_list=""},
	rebel_haunt_exit								={code = 6251, command = "rebel_haunt_exit",								command_fun = command_rebel_haunt_exit,									param_list=""},
	rebel_haunt_list_init							={code = 6252, command = "rebel_haunt_list_init",							command_fun = command_rebel_haunt_list_init,							param_list=""},
	rebel_haunt_rank_list_get						={code = 6253, command = "rebel_haunt_rank_list_get",						command_fun = command_rebel_haunt_rank_list_get,						param_list=""},
	refresh_world_target_event						={code = 6254, command = "refresh_world_target_event",						command_fun = command_refresh_world_target_event,						param_list=""},
	reset_elit_copy									={code = 6255, command = "reset_elit_copy",									command_fun = command_reset_elit_copy,									param_list=""},
	send_share_message								={code = 6256, command = "send_share_message",								command_fun = command_send_share_message,								param_list=""},
	share_red_packet								={code = 6257, command = "share_red_packet",								command_fun = command_share_red_packet,									param_list=""},
	ship_evolution									={code = 6258, command = "ship_evolution",									command_fun = command_ship_evolution,									param_list=""},
	ship_inheritance								={code = 6259, command = "ship_inheritance",								command_fun = command_ship_inheritance,									param_list=""},
	ship_military_buyrob_count						={code = 6260, command = "ship_military_buyrob_count",						command_fun = command_ship_military_buyrob_count,						param_list=""},
	ship_purify_buy_battle_reward					={code = 6261, command = "ship_purify_buy_battle_reward",					command_fun = command_ship_purify_buy_battle_reward,					param_list=""},
	ship_purify_init								={code = 6262, command = "ship_purify_init",								command_fun = command_ship_purify_init,									param_list=""},
	ship_purify_team_launch							={code = 6263, command = "ship_purify_team_launch",							command_fun = command_ship_purify_team_launch,							param_list=""},
	ship_purify_team_manager						={code = 6264, command = "ship_purify_team_manager",						command_fun = command_ship_purify_team_manager,							param_list=""},
	ship_repair_ship_count							={code = 6265, command = "ship_repair_ship_count",							command_fun = command_ship_repair_ship_count,							param_list=""},
	ship_skill_grow_up								={code = 6266, command = "ship_skill_grow_up",								command_fun = command_ship_skill_grow_up,								param_list=""},
	ship_skill_level_up								={code = 6267, command = "ship_skill_level_up",								command_fun = command_ship_skill_level_up,								param_list=""},
	ship_skill_point_buy							={code = 6268, command = "ship_skill_point_buy",							command_fun = command_ship_skill_point_buy,								param_list=""},
	ship_star_up									={code = 6269, command = "ship_star_up",									command_fun = command_ship_star_up,										param_list=""},
	ship_talent_update								={code = 6270, command = "ship_talent_update",								command_fun = command_ship_talent_update,								param_list=""},
	shop_buy										={code = 6271, command = "shop_buy",										command_fun = command_shop_buy,											param_list=""},
	shop_request_product_refresh					={code = 6272, command = "shop_request_product_refresh",					command_fun = command_shop_request_product_refresh,						param_list=""},
	super_equipment_grow_up							={code = 6273, command = "super_equipment_grow_up",							command_fun = command_super_equipment_grow_up,							param_list=""},
	task_init										={code = 6274, command = "task_init",										command_fun = command_task_init,										param_list=""},
	three_kingdoms_draw_score_reward				={code = 6275, command = "three_kingdoms_draw_score_reward",				command_fun = command_three_kingdoms_draw_score_reward,					param_list=""},
	three_kingdoms_launch							={code = 6276, command = "three_kingdoms_launch",							command_fun = command_three_kingdoms_launch,							param_list=""},
	union_active_init								={code = 6277, command = "union_active_init",								command_fun = command_union_active_init,								param_list=""},
	union_apply_review_update						={code = 6278, command = "union_apply_review_update",						command_fun = command_union_apply_review_update,						param_list=""},
	union_contest_formation_change					={code = 6279, command = "union_contest_formation_change",					command_fun = command_union_contest_formation_change,					param_list=""},
	union_copy_draw_npc_reward						={code = 6280, command = "union_copy_draw_npc_reward",						command_fun = command_union_copy_draw_npc_reward,						param_list=""},
	union_copy_fight								={code = 6281, command = "union_copy_fight",								command_fun = command_union_copy_fight,									param_list=""},
	union_copy_get_lucky_reward_info				={code = 6282, command = "union_copy_get_lucky_reward_info",				command_fun = command_union_copy_get_lucky_reward_info,					param_list=""},
	union_copy_init									={code = 6283, command = "union_copy_init",									command_fun = command_union_copy_init,									param_list=""},
	union_copy_look_npc_info						={code = 6284, command = "union_copy_look_npc_info",						command_fun = command_union_copy_look_npc_info,							param_list=""},
	union_craft_exit								={code = 6285, command = "union_craft_exit",								command_fun = command_union_craft_exit,									param_list=""},
	union_craft_init								={code = 6286, command = "union_craft_init",								command_fun = command_union_craft_init,									param_list=""},
	union_craft_rank_list_get						={code = 6287, command = "union_craft_rank_list_get",						command_fun = command_union_craft_rank_list_get,						param_list=""},
	union_craft_signup								={code = 6288, command = "union_craft_signup",								command_fun = command_union_craft_signup,								param_list=""},
	union_donate									={code = 6289, command = "union_donate",									command_fun = command_union_donate,										param_list=""},
	union_name_update								={code = 6290, command = "union_name_update",								command_fun = command_union_name_update,								param_list=""},
	union_one_key_join								={code = 6291, command = "union_one_key_join",								command_fun = command_union_one_key_join,								param_list=""},
	union_person_manage								={code = 6292, command = "union_person_manage",								command_fun = command_union_person_manage,								param_list=""},
	union_red_packet_draw_reward					={code = 6293, command = "union_red_packet_draw_reward",					command_fun = command_union_red_packet_draw_reward,						param_list=""},
	union_red_packet_rap_manager					={code = 6294, command = "union_red_packet_rap_manager",					command_fun = command_union_red_packet_rap_manager,						param_list=""},
	union_red_packet_rap_rank						={code = 6295, command = "union_red_packet_rap_rank",						command_fun = command_union_red_packet_rap_rank,						param_list=""},
	union_red_packet_send							={code = 6296, command = "union_red_packet_send",							command_fun = command_union_red_packet_send,							param_list=""},
	union_science_init								={code = 6297, command = "union_science_init",								command_fun = command_union_science_init,								param_list=""},
	union_send_mail									={code = 6298, command = "union_send_mail",									command_fun = command_union_send_mail,									param_list=""},
	union_setting_manage							={code = 6299, command = "union_setting_manage",							command_fun = command_union_setting_manage,								param_list=""},
	union_ship_slot_machine_change_result			={code = 6300, command = "union_ship_slot_machine_change_result",			command_fun = command_union_ship_slot_machine_change_result,			param_list=""},
	union_ship_slot_machine_draw_reward				={code = 6301, command = "union_ship_slot_machine_draw_reward",				command_fun = command_union_ship_slot_machine_draw_reward,				param_list=""},
	union_ship_slot_machine_get_rank				={code = 6302, command = "union_ship_slot_machine_get_rank",				command_fun = command_union_ship_slot_machine_get_rank,					param_list=""},
	union_ship_slot_machine_start_rotate			={code = 6303, command = "union_ship_slot_machine_start_rotate",			command_fun = command_union_ship_slot_machine_start_rotate,				param_list=""},
	union_ship_train								={code = 6304, command = "union_ship_train",								command_fun = command_union_ship_train,									param_list=""},
	union_ship_train_check							={code = 6305, command = "union_ship_train_check",							command_fun = command_union_ship_train_check,							param_list=""},
	union_ship_train_help							={code = 6306, command = "union_ship_train_help",							command_fun = command_union_ship_train_help,							param_list=""},
	union_ship_train_init							={code = 6307, command = "union_ship_train_init",							command_fun = command_union_ship_train_init,							param_list=""},
	union_ship_train_place_buy						={code = 6308, command = "union_ship_train_place_buy",						command_fun = command_union_ship_train_place_buy,						param_list=""},
	union_shop_buy									={code = 6309, command = "union_shop_buy",									command_fun = command_union_shop_buy,									param_list=""},
	union_shop_init									={code = 6310, command = "union_shop_init",									command_fun = command_union_shop_init,									param_list=""},
	union_stick_crazy_adventure_draw_reward			={code = 6311, command = "union_stick_crazy_adventure_draw_reward",			command_fun = command_union_stick_crazy_adventure_draw_reward,			param_list=""},
	union_welfare_distribute						={code = 6312, command = "union_welfare_distribute",						command_fun = command_union_welfare_distribute,							param_list=""},
	user_accumlate_consumption_score_get			={code = 6313, command = "user_accumlate_consumption_score_get",			command_fun = command_user_accumlate_consumption_score_get,				param_list=""},
	user_info_modify								={code = 6314, command = "user_info_modify",								command_fun = command_user_info_modify,									param_list=""},
	user_read_mail									={code = 6315, command = "user_read_mail",									command_fun = command_user_read_mail,									param_list=""},
	user_save_mail									={code = 6316, command = "user_save_mail",									command_fun = command_user_save_mail,									param_list=""},
	user_send_mail									={code = 6317, command = "user_send_mail",									command_fun = command_user_send_mail,									param_list=""},
	user_stronghold_clear_be_rob_cd					={code = 6318, command = "user_stronghold_clear_be_rob_cd",					command_fun = command_user_stronghold_clear_be_rob_cd,					param_list=""},
	user_stronghold_init							={code = 6319, command = "user_stronghold_init",							command_fun = command_user_stronghold_init,								param_list=""},
	user_stronghold_plunder							={code = 6320, command = "user_stronghold_plunder",							command_fun = command_user_stronghold_plunder,							param_list=""},
	user_stronghold_plunder_refresh					={code = 6321, command = "user_stronghold_plunder_refresh",					command_fun = command_user_stronghold_plunder_refresh,					param_list=""},
	user_stronghold_plunder_search					={code = 6322, command = "user_stronghold_plunder_search",					command_fun = command_user_stronghold_plunder_search,					param_list=""},
	user_stronghold_plunder_view					={code = 6323, command = "user_stronghold_plunder_view",					command_fun = command_user_stronghold_plunder_view,						param_list=""},
	user_stronghold_revived							={code = 6324, command = "user_stronghold_revived",							command_fun = command_user_stronghold_revived,							param_list=""},
	user_stronghold_view_score_rank					={code = 6325, command = "user_stronghold_view_score_rank",					command_fun = command_user_stronghold_view_score_rank,					param_list=""},
	verify_system_time								={code = 6326, command = "verify_system_time",								command_fun = command_verify_system_time,								param_list=""},
	world_add_target_event							={code = 6327, command = "world_add_target_event",							command_fun = command_world_add_target_event,							param_list=""},
	world_change_user_city_position					={code = 6328, command = "world_change_user_city_position",					command_fun = command_world_change_user_city_position,					param_list=""},
	world_city_bonus_draw							={code = 6329, command = "world_city_bonus_draw",							command_fun = command_world_city_bonus_draw,							param_list=""},
	world_city_boom_recover							={code = 6330, command = "world_city_boom_recover",							command_fun = command_world_city_boom_recover,							param_list=""},
	world_city_detail_get							={code = 6331, command = "world_city_detail_get",							command_fun = command_world_city_detail_get,							param_list=""},
	world_city_disband								={code = 6332, command = "world_city_disband",								command_fun = command_world_city_disband,								param_list=""},
	world_city_energy_buy							={code = 6333, command = "world_city_energy_buy",							command_fun = command_world_city_energy_buy,							param_list=""},
	world_city_list_get								={code = 6334, command = "world_city_list_get",								command_fun = command_world_city_list_get,								param_list=""},
	world_city_order_list_get						={code = 6335, command = "world_city_order_list_get",						command_fun = command_world_city_order_list_get,						param_list=""},
	world_city_shop_buy								={code = 6336, command = "world_city_shop_buy",								command_fun = command_world_city_shop_buy,								param_list=""},
	world_city_shop_init							={code = 6337, command = "world_city_shop_init",							command_fun = command_world_city_shop_init,								param_list=""},
	world_coord_collect								={code = 6338, command = "world_coord_collect",								command_fun = command_world_coord_collect,								param_list=""},
	world_exit										={code = 6339, command = "world_exit",										command_fun = command_world_exit,										param_list=""},
	world_help_defend_set							={code = 6340, command = "world_help_defend_set",							command_fun = command_world_help_defend_set,							param_list=""},
	world_info_init									={code = 6341, command = "world_info_init",									command_fun = command_world_info_init,									param_list=""},
	world_info_scout								={code = 6342, command = "world_info_scout",								command_fun = command_world_info_scout,									param_list=""},
	world_info_search								={code = 6343, command = "world_info_search",								command_fun = command_world_info_search,								param_list=""},
	world_join										={code = 6344, command = "world_join",										command_fun = command_world_join,										param_list=""},
	world_look_mine_info							={code = 6345, command = "world_look_mine_info",							command_fun = command_world_look_mine_info,								param_list=""},
	world_map_arena_info_refresh					={code = 6346, command = "world_map_arena_info_refresh",					command_fun = command_world_map_arena_info_refresh,						param_list=""},
	world_request_help_defend						={code = 6347, command = "world_request_help_defend",						command_fun = command_world_request_help_defend,						param_list=""},
	ship_spirit_init								={code = 6348, command = "ship_spirit_init",								command_fun = command_ship_spirit_init,									param_list=""},
	ship_spirit_level_up							={code = 6349, command = "ship_spirit_level_up",							command_fun = command_ship_spirit_level_up,								param_list=""},
	ship_talent_init								={code = 6350, command = "ship_talent_init",								command_fun = command_ship_talent_init,									param_list=""},
	ship_talent_reset								={code = 6351, command = "ship_talent_reset",								command_fun = command_ship_talent_reset,								param_list=""},
	ship_talent_level_up							={code = 6352, command = "ship_talent_level_up",							command_fun = command_ship_talent_level_up,								param_list=""},
	the_kings_battle_init							={code = 6353, command = "the_kings_battle_init",							command_fun = command_the_kings_battle_init,							param_list=""},
	the_kings_battle_manager						={code = 6354, command = "the_kings_battle_manager",						command_fun = command_the_kings_battle_manager,							param_list=""},
	world_city_army_exchange						={code = 6355, command = "world_city_army_exchange",						command_fun = command_world_city_army_exchange,							param_list=""},
	world_check_investigate_end_time				={code = 6356, command = "world_check_investigate_end_time",				command_fun = command_world_check_investigate_end_time,					param_list=""},
	ship_soul_level_up								={code = 6357, command = "ship_soul_level_up",								command_fun = command_ship_soul_level_up,								param_list=""},
	shop_frags_init									={code = 6358, command = "shop_frags_init",									command_fun = command_shop_frags_init,									param_list=""},
	shop_frags_exchange								={code = 6359, command = "shop_frags_exchange",								command_fun = command_shop_frags_exchange,								param_list=""},
	union_send_all_member_mail						={code = 6360, command = "union_send_all_member_mail",						command_fun = command_union_send_all_member_mail,						param_list=""},
	union_warfare_init								={code = 6361, command = "union_warfare_init",								command_fun = command_union_warfare_init,								param_list=""},
	union_warfare_manager							={code = 6362, command = "union_warfare_manager",							command_fun = command_union_warfare_manager,							param_list=""},
	union_warfare_exit								={code = 6363, command = "union_warfare_exit",								command_fun = command_union_warfare_exit,								param_list=""},
	fortune_init									={code = 6364, command = "fortune_init",									command_fun = command_fortune_init,										param_list=""},
	three_kingdoms_sweep							={code = 6365, command = "three_kingdoms_sweep",							command_fun = command_three_kingdoms_sweep,								param_list=""},
	treasure_onekey_escalate						={code = 6366, command = "treasure_onekey_escalate",						command_fun = command_treasure_onekey_escalate,							param_list=""},
	arena_sweep										={code = 6367, command = "arena_sweep",										command_fun = command_arena_sweep,										param_list=""},
	ship_rebirth_init								={code = 6368, command = "ship_rebirth_init",								command_fun = command_ship_rebirth_init,								param_list=""},
	ship_rebirth									={code = 6369, command = "ship_rebirth",									command_fun = command_ship_rebirth,										param_list=""},
	equipment_rebirth_init							={code = 6370, command = "equipment_rebirth_init",							command_fun = command_equipment_rebirth_init,							param_list=""},
	equipment_rebirth								={code = 6371, command = "equipment_rebirth",								command_fun = command_equipment_rebirth,								param_list=""},
	artifact_init									={code = 6372, command = "artifact_init",									command_fun = command_artifact_init,									param_list=""},
	artifact_unlock									={code = 6373, command = "artifact_unlock",									command_fun = command_artifact_unlock,									param_list=""},
	artifact_culture								={code = 6374, command = "artifact_culture",								command_fun = command_artifact_culture,									param_list=""},
	artifact_confirm								={code = 6375, command = "artifact_confirm",								command_fun = command_artifact_confirm,									param_list=""},
	platform_user_register							={code = 9001, command = "platform_user_register",							command_fun = command_platform_user_register,							param_list=""},
	platform_user_login								={code = 9002, command = "platform_user_login",								command_fun = command_platform_user_login,								param_list=""},
	platform_user_modify_password					={code = 9003, command = "platform_user_modify_password",					command_fun = command_platform_user_modify_password,					param_list=""},
	bi_forward										={code = 9004, command = "bi_forward",										command_fun = command_bi_forward,										param_list=""},
	get_copy_clear_user_info						={code = 9005, command = "get_copy_clear_user_info",						command_fun = command_get_copy_clear_user_info,							param_list=""},
	ship_praise										={code = 9006, command = "ship_praise",										command_fun = command_ship_praise,										param_list=""},

	linkage_bind									={code = 9007, command = "linkage_bind",									command_fun = command_linkage_bind,										param_list=""},
	linkage_check_server							={code = 9008, command = "linkage_check_server",							command_fun = command_linkage_check_server,								param_list=""},
	mystical_shop_buy								={code = 9009, command = "mystical_shop_buy",								command_fun = command_mystical_shop_buy,								param_list=""},
	mystical_shop_refresh							={code = 9010, command = "mystical_shop_refresh",							command_fun = command_mystical_shop_refresh,							param_list=""},
	user_title_modify								={code = 9011, command = "user_title_modify",								command_fun = command_user_title_modify,								param_list=""},
	find_password									={code = 9012, command = "find_password",									command_fun = command_find_password,									param_list=""},
	five_star_praise								={code = 9013, command = "five_star_praise",								command_fun = command_five_star_praise,									param_list=""},
	draw_achievement_reward							={code = 9014, command = "draw_achievement_reward",							command_fun = command_draw_achievement_reward,							param_list=""},
	ship_skin_buy 									={code = 9015, command = "ship_skin_buy", 									command_fun = command_ship_skin_buy, 									param_list=""},
	ship_skin_use 									={code = 9016, command = "ship_skin_use", 									command_fun = command_ship_skin_use, 									param_list=""},
	union_ship_train_exit							={code = 9017, command = "union_ship_train_exit",							command_fun = command_union_ship_train_exit,							param_list=""},
	get_hard_copy_user_formation					={code = 9018, command = "get_hard_copy_user_formation",					command_fun = command_get_hard_copy_user_formation,						param_list=""},
	save_hard_copy_user_formation					={code = 9019, command = "save_hard_copy_user_formation",					command_fun = command_save_hard_copy_user_formation,					param_list=""},
	face_book_share_complete						={code = 9020, command = "face_book_share_complete",						command_fun = command_face_book_share_complete,							param_list=""},
	constellation_buy 								={code = 9021, command = "constellation_buy",								command_fun = command_constellation_buy,								param_list=""},
	constellation_exchange							={code = 9022, command = "constellation_exchange",							command_fun = command_constellation_exchange,							param_list=""},
	cross_mine_init									={code = 9023, command = "cross_mine_init",									command_fun = command_cross_mine_init,									param_list=""},
	cross_mine_user_shop_buy						={code = 9024, command = "cross_mine_user_shop_buy",						command_fun = command_cross_mine_user_shop_buy,							param_list=""},
	cross_mine_user_feed 							={code = 9025, command = "cross_mine_user_feed",							command_fun = command_cross_mine_user_feed,								param_list=""},
	cross_mine_order_info							={code = 9026, command = "cross_mine_order_info",							command_fun = command_cross_mine_order_info,							param_list=""},
	cross_mine_user_formation 						={code = 9027, command = "cross_mine_user_formation",						command_fun = command_cross_mine_user_formation,						param_list=""},
	ship_potential_up								={code = 9028, command = "ship_potential_up",								command_fun = command_ship_potential_up,								param_list=""},
	cross_mine_user_do_loot 						={code = 9029, command = "cross_mine_user_do_loot",							command_fun = command_cross_mine_user_do_loot,							param_list=""},
	cross_mine_load_battle_info 					={code = 9030, command = "cross_mine_load_battle_info",						command_fun = command_cross_mine_load_battle_info,						param_list=""},
	cross_mine_user_lounch_refresh 					={code = 9031, command = "cross_mine_user_lounch_refresh",					command_fun = command_cross_mine_user_lounch_refresh,					param_list=""},
	cross_mine_load_all_loot_info 					={code = 9032, command = "cross_mine_load_all_loot_info",					command_fun = command_cross_mine_load_all_loot_info,					param_list=""},
	cross_mine_user_join_not_open					={code = 9033, command = "cross_mine_user_join_not_open",					command_fun = command_cross_mine_user_join_not_open,					param_list=""},
	cross_mine_buy_loot_or_revenge					={code = 9034, command = "cross_mine_buy_loot_or_revenge",					command_fun = command_cross_mine_buy_loot_or_revenge,					param_list=""},
	cross_mine_revenge 								={code = 9035, command = "cross_mine_revenge",								command_fun = command_cross_mine_revenge,								param_list=""},
	cross_mine_get_rank_formation					={code = 9036, command = "cross_mine_get_rank_formation",					command_fun = command_cross_mine_get_rank_formation,					param_list=""},

	ship_metal_set									={code = 9037, command = "ship_metal_set",									command_fun = command_ship_metal_set,									param_list=""},
	ship_metal_escalate								={code = 9038, command = "ship_metal_escalate",								command_fun = command_ship_metal_escalate,								param_list=""},
	ship_metal_dissolve 							={code = 9039, command = "ship_metal_dissolve", 							command_fun = command_ship_metal_dissolve,								param_list=""},
	draw_matrix_reward								={code = 9040, command = "draw_matrix_reward", 								command_fun = command_draw_matrix_reward,								param_list=""},
	ship_metal_onekey_escalate 						={code = 9041, command = "ship_metal_onekey_escalate",						command_fun = command_ship_metal_onekey_escalate,						param_list=""},

	reward_happy_n_day 								={code = 9042, command = "reward_happy_n_day",								command_fun = command_reward_happy_n_day,								param_list=""},

	fileIslandEnter 								={code = 9043, command = "file_island_enter",								command_fun = command_fileIslandEnter,									param_list=""},
	fileIslandSearch 								={code = 9044, command = "file_island_search",								command_fun = command_fileIslandSearch,									param_list=""},
	fileIslandSearchPointBuy 						={code = 9045, command = "file_island_search_point_buy",					command_fun = command_fileIslandSearchPointBuy,							param_list=""},
	fileIslandBossInfo 								={code = 9046, command = "file_island_boss_info",							command_fun = command_fileIslandBossInfo,								param_list=""},
	fileIslandTaskInfo 								={code = 9047, command = "file_island_task_info",							command_fun = command_fileIslandTaskInfo,								param_list=""},
	fileIslandHolyThingsInfo 						={code = 9048, command = "file_island_holy_things_info",					command_fun = command_fileIslandHolyThingsInfo,							param_list=""},
	fileIslandSearchRewardInfo 						={code = 9049, command = "file_island_search_reward_info",					command_fun = command_fileIslandSearchRewardInfo,						param_list=""},
	fileIslandHolyThingUnlock 						={code = 9050, command = "file_island_holy_thing_unlock",					command_fun = command_fileIslandHolyThingUnlock,						param_list=""},
	fileIslandHolyThingLevUp 						={code = 9051, command = "file_island_holy_thing_levup",					command_fun = command_fileIslandHolyThingLevUp,							param_list=""},
	fileIslandTaskRelease 							={code = 9052, command = "file_island_task_release",						command_fun = command_fileIslandTaskRelease,							param_list=""},
	fileIslandSingleChallenge 						={code = 9053, command = "file_island_single_challenge",					command_fun = command_fileIslandSingleChallenge,						param_list=""},
	fileIslandSingleChallengeCancle 				={code = 9054, command = "file_island_single_challenge_cancel",				command_fun = command_fileIslandSingleChallengeCancle,					param_list=""},
	fileIslandRewardBoxBuy 							={code = 9055, command = "file_island_reward_box_buy",						command_fun = command_fileIslandRewardBoxBuy,							param_list=""},
	fileIslandAnswer 								={code = 9056, command = "file_island_answer",								command_fun = command_fileIslandAnswer,									param_list=""},
	fileIslandFriendTaskJoin 						={code = 9057, command = "file_island_friend_task_join",					command_fun = command_fileIslandFriendTaskJoin,							param_list=""},
	fileIslandFriendTaskExecute 					={code = 9058, command = "file_island_friend_task_execute",					command_fun = command_fileIslandFriendTaskExecute,						param_list=""},
	fileIslandFriendTaskReward 						={code = 9059, command = "file_island_friend_task_reward",					command_fun = command_fileIslandFriendTaskReward,						param_list=""},
	fileIslandShopInfo 								={code = 9060, command = "file_island_shop_info",							command_fun = command_fileIslandShopInfo,								param_list=""},
	fileIslandShopThingsBuy 						={code = 9061, command = "file_island_shop_things_buy",						command_fun = command_fileIslandShopThingsBuy,							param_list=""},
	composeEquip 									={code = 9062, command = "compose_equip",									command_fun = command_composeEquip,										param_list=""},
	refreshSearchPoint								={code = 9063, command = "file_island_refresh_search_point",				command_fun = command_refreshSearchPoint,								param_list=""},
	file_island_finish_search_result				={code = 9064, command = "file_island_finish_search_result",				command_fun = command_file_island_finish_search_result,					param_list=""},
	file_island_single_challenge_cancel 			={code = 9065, command = "file_island_single_challenge_cancel",				command_fun = command_file_island_single_challenge_cancel,				param_list=""},
	file_island_boss_challenge 						={code = 9066, command = "file_island_boss_challenge",						command_fun = command_file_island_boss_challenge,						param_list=""},
	file_island_dispose_next_search_eventId   		={code = 9067, command = "file_island_dispose_next_search_eventId",			command_fun = command_file_island_dispose_next_search_eventId,			param_list=""},

	draw_google_bind_reward 						={code = 9068, command = "draw_google_bind_reward",							command_fun = command_draw_google_bind_reward,							param_list=""},
	google_bind_hotgame								={code = 9069, command = "google_bind_hotgame",								command_fun = command_google_bind_hotgame,								param_list=""},
	cross_mine_ref_user_mine_and_server_info		={code = 9070, command = "cross_mine_ref_user_mine_and_server_info",		command_fun = command_cross_mine_ref_user_mine_and_server_info,			param_list=""},
	reward_grow_by_level							={code = 9071, command = "reward_grow_by_level",							command_fun = command_reward_grow_by_level,								param_list=""},
	activity_refresh								={code = 9072, command = "activity_refresh",								command_fun = command_activity_refresh,									param_list=""},
	pokemon_explore_enter							={code = 9073, command = "pokemon_explore_enter",							command_fun = command_pokemon_explore_enter,							param_list=""},
	pokemon_explore_search_point_buy				={code = 9074, command = "pokemon_explore_search_point_buy",				command_fun = command_pokemon_explore_search_point_buy,					param_list=""},
	pokemon_explore_search							={code = 9075, command = "pokemon_explore_search",							command_fun = command_pokemon_explore_search,							param_list=""},
	pokemon_explore_dispose_next_search_eventId		={code = 9076, command = "pokemon_explore_dispose_next_search_eventId",		command_fun = command_pokemon_explore_dispose_next_search_eventId,		param_list=""},
	exlore_achievement_unlock		                ={code = 9077, command = "exlore_achievement_unlock",		                command_fun = command_exlore_achievement_unlock,		                param_list=""},
	explore_achievement_level_up_talent		        ={code = 9078, command = "explore_achievement_level_up_talent",		        command_fun = command_explore_achievement_level_up_talent,		        param_list=""},
	pokemon_explore_reward_box_buy		        	={code = 9079, command = "pokemon_explore_reward_box_buy",		        	command_fun = command_pokemon_explore_reward_box_buy,		        	param_list=""},
	pokemon_explore_finish_search_result		    ={code = 9080, command = "pokemon_explore_finish_search_result",		    command_fun = command_pokemon_explore_finish_search_result,		        param_list=""},
	pokemon_explore_single_challenge		    	={code = 9081, command = "pokemon_explore_single_challenge",		    	command_fun = command_pokemon_explore_single_challenge,		        	param_list=""},
	pokemon_explore_score_reward		    		={code = 9082, command = "pokemon_explore_score_reward",		    		command_fun = command_pokemon_explore_score_reward,		        		param_list=""},
	draw_reward_main		    					={code = 9083, command = "draw_reward_main",		    					command_fun = command_draw_reward_main,		        					param_list=""},
	pokemon_explore_refresh_search_point			={code = 9084, command = "pokemon_explore_refresh_search_point",			command_fun = command_pokemon_explore_refresh_search_point,				param_list=""},
	monopoly_throw									={code = 9085, command = "monopoly_throw",									command_fun = command_monopoly_throw,									param_list=""},
	monopoly_move_end								={code = 9086, command = "monopoly_move_end",								command_fun = command_monopoly_move_end,								param_list=""},
	monopoly_finger_game							={code = 9087, command = "monopoly_finger_game",							command_fun = command_monopoly_finger_game,								param_list=""},
	monololy_open_cheast							={code = 9088, command = "monololy_open_cheast",							command_fun = command_monololy_open_cheast,								param_list=""},
	treasures_draw									={code = 9089, command = "treasures_draw",									command_fun = command_treasures_draw,									param_list=""},
	treasures_refresh								={code = 9090, command = "treasures_refresh",								command_fun = command_treasures_refresh,								param_list=""},
	treasures_shop_buy								={code = 9091, command = "treasures_shop_buy",								command_fun = command_treasures_shop_buy,								param_list=""},
	treasures_shop_info								={code = 9092, command = "treasures_shop_info",								command_fun = command_treasures_shop_info,								param_list=""},
    activity_time_limit_rank_init                   ={code = 9093, command = "activity_time_limit_rank_init",	                command_fun = command_activity_time_limit_rank_init,                    param_list=""},
    activity_time_limit_rank_order                  ={code = 9094, command = "activity_time_limit_rank_order",	                command_fun = command_activity_time_limit_rank_order,                   param_list=""},
    pokemon_explore_shop_info                  		={code = 9095, command = "pokemon_explore_shop_info",	                	command_fun = command_pokemon_explore_shop_info,                   		param_list=""},
    pokemon_explore_answer                  		={code = 9096, command = "pokemon_explore_answer",	                		command_fun = command_pokemon_explore_answer,                   		param_list=""},
    pokemon_explore_boss_info                  		={code = 9097, command = "pokemon_explore_boss_info",	                	command_fun = command_pokemon_explore_boss_info,                   		param_list=""},
    pokemon_explore_single_challenge_cancel         ={code = 9098, command = "pokemon_explore_single_challenge_cancel",	        command_fun = command_pokemon_explore_single_challenge_cancel,         	param_list=""},
    pokemon_explore_shop_things_buy         		={code = 9099, command = "pokemon_explore_shop_things_buy",	        		command_fun = command_pokemon_explore_shop_things_buy,         			param_list=""},
    pokemon_explore_rank_info                       ={code = 9100, command = "pokemon_explore_rank_info",	                    command_fun = command_pokemon_explore_rank_info,                        param_list=""},
    pokemon_explore_map_catch_buy                   ={code = 9101, command = "pokemon_explore_map_catch_buy",	                command_fun = command_pokemon_explore_map_catch_buy,                    param_list=""},
    pokemon_explore_map_catch_hit                   ={code = 9102, command = "pokemon_explore_map_catch_hit",	                command_fun = command_pokemon_explore_map_catch_hit,                    param_list=""},
    pokemon_explore_map_catch_over                  ={code = 9103, command = "pokemon_explore_map_catch_over",	                command_fun = command_pokemon_explore_map_catch_over,                   param_list=""},
    pokemon_explore_map_catch_enter                 ={code = 9104, command = "pokemon_explore_map_catch_enter",	                command_fun = command_pokemon_explore_map_catch_enter,                  param_list=""},
    pokemon_explore_map_catch_cancel                ={code = 9105, command = "pokemon_explore_map_catch_cancel",	            command_fun = command_pokemon_explore_map_catch_cancel,                 param_list=""},
    pokemon_explore_boss_challenge                	={code = 9106, command = "pokemon_explore_boss_challenge",	            	command_fun = command_pokemon_explore_boss_challenge,                 	param_list=""},
    mega_unblock                                    ={code = 9107, command = "mega_unblock",	            	                command_fun = command_mega_unblock,                 	                param_list=""},
    mega_level_up                                   ={code = 9108, command = "mega_level_up",	            	                command_fun = command_mega_level_up,                 	                param_list=""},
    mega_use_skill                                  ={code = 9109, command = "mega_use_skill",	            	                command_fun = command_mega_use_skill,                 	                param_list=""},
    pokemon_explore_event_touch                     ={code = 9110, command = "pokemon_explore_event_touch",	            	    command_fun = command_pokemon_explore_event_touch,                 	    param_list=""},
    pokemon_explore_single_event_finish             ={code = 9111, command = "pokemon_explore_single_event_finish",	            command_fun = command_pokemon_explore_single_event_finish,              param_list=""},
    activity_red_packet_init                        ={code = 9112, command = "activity_red_packet_init",	                    command_fun = command_activity_red_packet_init,                         param_list=""},
    activity_send_red_packet                        ={code = 9113, command = "activity_send_red_packet",	            	    command_fun = command_activity_send_red_packet,                         param_list=""},
    activity_draw_red_packet                        ={code = 9114, command = "activity_draw_red_packet",	                    command_fun = command_activity_draw_red_packet,                       	param_list=""},
    pokemon_world_boss_init                        	={code = 9115, command = "pokemon_world_boss_init",	                    	command_fun = command_pokemon_world_boss_init,                       	param_list=""},
    world_boss_attack_start                        	={code = 9116, command = "world_boss_attack_start",	                    	command_fun = command_world_boss_attack_start,                       	param_list=""},
    world_boss_attack_finish                        ={code = 9117, command = "world_boss_attack_finish",	                    command_fun = command_world_boss_attack_finish,                       	param_list=""},
    world_boss_change_formation                     ={code = 9118, command = "world_boss_change_formation",	                    command_fun = command_world_boss_change_formation,                      param_list=""},
    world_boss_ref_cd                     			={code = 9119, command = "world_boss_ref_cd",	                    		command_fun = command_world_boss_ref_cd,                      			param_list=""},
    world_boss_get_order                     		={code = 9120, command = "world_boss_get_order",	                    	command_fun = command_world_boss_get_order,                      		param_list=""},
    world_boss_draw_task_reward                     ={code = 9121, command = "world_boss_draw_task_reward",	                    command_fun = command_world_boss_draw_task_reward,                      param_list=""},
    soul_gruad_un_lock                              ={code = 9122, command = "soul_gruad_un_lock",	                            command_fun = command_soul_gruad_un_lock,                               param_list=""},
    soul_gruad_level_up                             ={code = 9123, command = "soul_gruad_level_up",	                            command_fun = command_soul_gruad_level_up,                              param_list=""},
    soul_gruad_use_ship_mould                       ={code = 9124, command = "soul_gruad_use_ship_mould ",	                    command_fun = command_soul_gruad_use_ship_mould ,                       param_list=""},
    activity_pokemon_master_show_task               ={code = 9125, command = "activity_pokemon_master_show_task ",	            command_fun = command_activity_pokemon_master_show_task ,               param_list=""},
    activity_pokemon_master_init                    ={code = 9126, command = "activity_pokemon_master_init ",	                command_fun = command_activity_pokemon_master_init ,                    param_list=""},
    activity_pokemon_master_exchage_reward          ={code = 9127, command = "activity_pokemon_master_exchage_reward",	        command_fun = command_activity_pokemon_master_exchage_reward,           param_list=""},
    activity_pokemon_master_buy_master              ={code = 9128, command = "activity_pokemon_master_buy_master",	            command_fun = command_activity_pokemon_master_buy_master,               param_list=""},
    activity_pokemon_master_get_reward              ={code = 9129, command = "activity_pokemon_master_get_reward",	            command_fun = command_activity_pokemon_master_get_reward,               param_list=""},
    activity_pokemon_master_buy_level               ={code = 9130, command = "activity_pokemon_master_buy_level",	            command_fun = command_activity_pokemon_master_buy_level,                param_list=""},
    activity_pokemon_master_get_exp                 ={code = 9131, command = "activity_pokemon_master_get_exp",	           	    command_fun = command_activity_pokemon_master_get_exp,                  param_list=""},
    activity_pokemon_master_one_key                 ={code = 9132, command = "activity_pokemon_master_one_key",	           	    command_fun = command_activity_pokemon_master_one_key,                  param_list=""},
	ship_skill_level_up_one_key						={code = 9133, command = "ship_skill_level_up_one_key",						command_fun = command_ship_skill_level_up_one_key,						param_list=""},
    activity_pockmon_rescue_exchange                ={code = 9134, command = "activity_pockmon_rescue_exchange",				command_fun = command_activity_pockmon_rescue_exchange,				    param_list=""},
	activity_pockmon_rescue_donation_item           ={code = 9135, command = "activity_pockmon_rescue_donation_item",		    command_fun = command_activity_pockmon_rescue_donation_item,		    param_list=""},
 	activity_pockmon_rescue_get_cross_rank          ={code = 9136, command = "activity_pockmon_rescue_get_cross_rank",		    command_fun = command_activity_pockmon_rescue_get_cross_rank,		    param_list=""},
    activity_pockmon_rescue_show_task               ={code = 9137, command = "activity_pockmon_rescue_show_task",		        command_fun = command_activity_pockmon_rescue_show_task,		        param_list=""},
    activity_pockmon_rescue_draw_ultimate_reward    ={code = 9138, command = "activity_pockmon_rescue_draw_ultimate_reward",    command_fun = command_activity_pockmon_rescue_draw_ultimate_reward,		param_list=""},
    ship_slik_bag_use 				 				={code = 9139, command = "ship_slik_bag_use",    							command_fun = command_ship_slik_bag_use,								param_list=""},
    ship_slik_bag_un_use 				 			={code = 9140, command = "ship_slik_bag_un_use",    						command_fun = command_ship_slik_bag_un_use,								param_list=""},
    ship_slik_bag_level_up 				 			={code = 9141, command = "ship_slik_bag_level_up",    						command_fun = command_ship_slik_bag_level_up,							param_list=""},
    ship_slik_bag_promote 				 			={code = 9142, command = "ship_slik_bag_promote",    						command_fun = command_ship_slik_bag_promote,							param_list=""},
    ship_slik_bag_change_mould 				 		={code = 9143, command = "ship_slik_bag_change_mould",    					command_fun = command_ship_slik_bag_change_mould,						param_list=""},
    ship_slik_bag_resolve 				 		    ={code = 9144, command = "ship_slik_bag_resolve",    						command_fun = command_ship_slik_bag_resolve,						    param_list=""},
    ship_slik_bag_one_key_level_up 				 	={code = 9145, command = "ship_slik_bag_one_key_level_up",    				command_fun = command_ship_slik_bag_one_key_level_up,				    param_list=""},
	get_lucky_divine_info  							={code = 9146, command = "get_lucky_divine_info",   				command_fun = command_get_lucky_divine_info,		param_list=""},
	lucky_divine			  						={code = 9147, command = "lucky_divine",   		  							command_fun = command_lucky_divine,	 				param_list=""},
	get_lucky_divine_rank_info			  			={code = 9148, command = "get_lucky_divine_rank_info",   		  			command_fun = command_get_lucky_divine_rank_info,	 				param_list=""},
	the_kings_battle_self_change_formation			={code = 9149, command = "the_kings_battle_self_change_formation",			command_fun = command_the_kings_battle_self_change_formation,			param_list=""},
	the_kings_battle_self_bottom_pour				={code = 9150, command = "the_kings_battle_self_bottom_pour",				command_fun = command_the_kings_battle_self_bottom_pour,				param_list=""},
	the_kings_battle_cross_base_get_battle_report	={code = 9151, command = "the_kings_battle_cross_base_get_battle_report",	command_fun = command_the_kings_battle_cross_base_get_battle_report,		param_list=""},
	the_kings_battle_self_match_info				={code = 9152, command = "the_kings_battle_self_match_info",				command_fun = command_the_kings_battle_self_match_info,					param_list=""},
	the_kings_battle_self_battle_peakedness_duel_info	={code = 9153, command = "the_kings_battle_self_battle_peakedness_duel_info",		command_fun = command_the_kings_battle_self_battle_peakedness_duel_info,	param_list=""},
	the_kings_battle_self_battle_rank				={code = 9154, command = "the_kings_battle_self_battle_rank",				command_fun = command_the_kings_battle_self_battle_rank,				param_list=""},
	the_kings_battle_self_get_other_info			={code = 9155, command = "the_kings_battle_self_get_other_info",			command_fun = command_the_kings_battle_self_get_other_info,				param_list=""},
	the_kings_battle_self_get_battle_report			={code = 9156, command = "the_kings_battle_self_get_battle_report",			command_fun = command_the_kings_battle_self_get_battle_report,				param_list=""},
	the_kings_battle_self_init						={code = 9157, command = "the_kings_battle_self_init",						command_fun = command_the_kings_battle_self_init,						param_list=""},
	the_kings_battle_self_apply						={code = 9158, command = "the_kings_battle_self_apply",						command_fun = command_the_kings_battle_self_apply,						param_list=""},
	new_bi_log_cmd 				 	                ={code = 9159, command = "new_bi_log_cmd",    				                command_fun = command_new_bi_log_cmd,				                    param_list=""},
	combine_ship_init								={code = 9160, command = "combine_ship_init",								command_fun = command_combine_ship_init,								param_list=""},
	combine_ship_unlock_card						={code = 9161, command = "combine_ship_unlock_card",						command_fun = command_combine_ship_unlock_card,							param_list=""},
	combine_ship_unlock_slot						={code = 9162, command = "combine_ship_unlock_slot",						command_fun = command_combine_ship_unlock_slot,							param_list=""},
	combine_ship_change_slot						={code = 9163, command = "combine_ship_change_slot",						command_fun = command_combine_ship_change_slot,							param_list=""},
	combine_ship_update_slot						={code = 9164, command = "combine_ship_update_slot",						command_fun = command_combine_ship_update_slot,							param_list=""},
	combine_ship_debris_exchange					={code = 9165, command = "combine_ship_debris_exchange",					command_fun = command_combine_ship_debris_exchange,						param_list=""},
	combine_ship_slot_field							={code = 9166, command = "combine_ship_slot_field",							command_fun = command_combine_ship_slot_field,							param_list=""},
	combine_ship_filed_expansion					={code = 9167, command = "combine_ship_filed_expansion",					command_fun = command_combine_ship_filed_expansion,						param_list=""},
	combine_ship_get_one							={code = 9168, command = "combine_ship_get_one",							command_fun = command_combine_ship_get_one,								param_list=""},
	lucky_pull_rod_init  							={code = 9169, command = "lucky_pull_rod_init",   				command_fun = command_lucky_pull_rod_init,		param_list=""},
	lucky_pull_rod_start  							={code = 9170, command = "lucky_pull_rod_start",   				command_fun = command_lucky_pull_rod_start,		param_list=""},
	get_lucky_pull_rod_lottery_record  				={code = 9171, command = "get_lucky_pull_rod_lottery_record",   command_fun = command_get_lucky_pull_rod_lottery_record,		param_list=""},
	privilege_card_init  							={code = 9172, command = "privilege_card_init",   				command_fun = command_privilege_card_init,		param_list=""},
	privilege_card_get_reward  						={code = 9173, command = "privilege_card_get_reward",   				command_fun = command_privilege_card_get_reward,		param_list=""},
	old_user_back_seven_day_init  					={code = 9174, command = "old_user_back_seven_day_init",   					command_fun = command_old_user_back_seven_day_init,							param_list=""},
	old_user_back_seven_day_get_reward  			={code = 9175, command = "old_user_back_seven_day_get_reward",   			command_fun = command_old_user_back_seven_day_get_reward,					param_list=""},
	old_user_back_recharge_init  					={code = 9176, command = "old_user_back_recharge_init",   					command_fun = command_old_user_back_recharge_init,							param_list=""},
	old_user_back_recharge_get_reward  				={code = 9177, command = "old_user_back_recharge_get_reward",   			command_fun = command_old_user_back_recharge_get_reward,					param_list=""},
	old_user_back_reward_happy_n_day  				={code = 9178, command = "old_user_back_reward_happy_n_day",   				command_fun = command_old_user_back_reward_happy_n_day,						param_list=""},
	activity_fortune_cat_init   					={code = 9179, command = "activity_fortune_cat_init",   					command_fun = command_activity_fortune_cat_init,						param_list=""},
    activity_fortune_cat_draw   					={code = 9180, command = "activity_fortune_cat_draw",   					command_fun = command_activity_fortune_cat_draw,						param_list=""},
	union_assistance_init							={code = 9181, command = "union_assistance_init",   					command_fun = command_union_assistance_init,		param_list=""},
	union_assistance_donate  						={code = 9182, command = "union_assistance_donate",   					command_fun = command_union_assistance_donate,		param_list=""},
	union_assistance_seek_help  					={code = 9183, command = "union_assistance_seek_help",   				command_fun = command_union_assistance_seek_help,		param_list=""},
	union_assistance_all_record  					={code = 9184, command = "union_assistance_all_record",   				command_fun = command_union_assistance_all_record,		param_list=""},
	old_user_back_recharge_close  					={code = 9185, command = "old_user_back_recharge_close",   				command_fun = command_old_user_back_recharge_close,							param_list=""},
	old_user_back_seven_day_close  					={code = 9186, command = "old_user_back_seven_day_close",   			command_fun = command_old_user_back_seven_day_close,						param_list=""},
	user_card_info_activate  						={code = 9187, command = "user_card_info_activate",   					command_fun = command_user_card_info_activate,								param_list=""},
	user_card_info_advance  						={code = 9188, command = "user_card_info_advance",   					command_fun = command_user_card_info_advance,								param_list=""},
	user_card_info_rank  							={code = 9189, command = "user_card_info_rank",   						command_fun = command_user_card_info_rank,									param_list=""},

	time_limit_jackpot_init  						={code = 9190, command = "time_limit_jackpot_init",   					command_fun = command_time_limit_jackpot_init,								param_list=""},
	time_limit_jackpot_draw  						={code = 9191, command = "time_limit_jackpot_draw",   					command_fun = command_time_limit_jackpot_draw,								param_list=""},
	time_limit_jackpot_rank  						={code = 9192, command = "time_limit_jackpot_rank",   					command_fun = command_time_limit_jackpot_rank,								param_list=""},
	time_limit_jackpot_notice  						={code = 9193, command = "time_limit_jackpot_notice",   				command_fun = command_time_limit_jackpot_notice,							param_list=""},
	time_limit_jackpot_buy_prop  					={code = 9194, command = "time_limit_jackpot_buy_prop",   				command_fun = command_time_limit_jackpot_buy_prop,							param_list=""},
	time_limit_jackpot_get_task_reward  			={code = 9195, command = "time_limit_jackpot_get_task_reward",   		command_fun = command_time_limit_jackpot_get_task_reward,					param_list=""},
	cross_arena_init  							={code = 9196, command = "cross_arena_init",   						command_fun = command_cross_arena_init,									param_list=""},
	cross_arena_defensive_formation_get  							={code = 9197, command = "cross_arena_defensive_formation_get",   						command_fun = command_cross_arena_defensive_formation_get,									param_list=""},
	cross_arena_defensive_formation_set  							={code = 9198, command = "cross_arena_defensive_formation_set",   						command_fun = command_cross_arena_defensive_formation_set,									param_list=""},
	cross_arena_remaining_challenges  							={code = 9199, command = "cross_arena_remaining_challenges",   						command_fun = command_cross_arena_remaining_challenges,									param_list=""},
	cross_arena_shop_init  							={code = 9200, command = "cross_arena_shop_init",   						command_fun = command_cross_arena_shop_init,									param_list=""},
	cross_arena_battle_report_list  							={code = 9201, command = "cross_arena_battle_report_list",   						command_fun = command_cross_arena_battle_report_list,									param_list=""},
	cross_arena_check_battle_report  							={code = 9202, command = "cross_arena_check_battle_report",   						command_fun = command_cross_arena_check_battle_report,									param_list=""},
	cross_arena_matching  							={code = 9203, command = "cross_arena_matching",   						command_fun = command_cross_arena_matching,									param_list=""},
	cross_arena_challenge  							={code = 9204, command = "cross_arena_challenge",   						command_fun = command_cross_arena_challenge,									param_list=""},
	cross_arena_choose_reward  							={code = 9205, command = "cross_arena_choose_reward",   						command_fun = command_cross_arena_choose_reward,									param_list=""},
	cross_arena_shop_buy  							={code = 9206, command = "cross_arena_shop_buy",   						command_fun = command_cross_arena_shop_buy,									param_list=""},
	cross_arena_like  							={code = 9207, command = "cross_arena_like",   						command_fun = command_cross_arena_like,									param_list=""},
	cross_arena_bet  							={code = 9208, command = "cross_arena_bet",   						command_fun = command_cross_arena_bet,									param_list=""},
	cross_arena_attack_formation_get  							={code = 9209, command = "cross_arena_attack_formation_get",   						command_fun = command_cross_arena_attack_formation_get,									param_list=""},
	cross_arena_attack_formation_set  							={code = 9210, command = "cross_arena_attack_formation_set",   						command_fun = command_cross_arena_attack_formation_set,									param_list=""},
	lucky_match_init  							={code = 9211, command = "lucky_match_init",   						command_fun = command_lucky_match_init,									param_list=""},
	lucky_match_draw  							={code = 9212, command = "lucky_match_draw",   						command_fun = command_lucky_match_draw,									param_list=""},
	lucky_match_notice  						={code = 9213, command = "lucky_match_notice",   					command_fun = command_lucky_match_notice,								param_list=""},
	lucky_match_get_reward  					={code = 9214, command = "lucky_match_get_reward",   				command_fun = command_lucky_match_get_reward,							param_list=""},
	lucky_match_exchange_prop  					={code = 9215, command = "lucky_match_exchange_prop",   			command_fun = command_lucky_match_exchange_prop,						param_list=""},

	private_custom_enter  						={code = 9216, command = "private_custom_enter",   					command_fun = command_private_custom_enter,								param_list=""},
	private_custom_reward_set  					={code = 9217, command = "private_custom_reward_set",   			command_fun = command_private_custom_reward_set,						param_list=""},
	private_custom_reward_get  					={code = 9218, command = "private_custom_reward_get",   			command_fun = command_private_custom_reward_get,						param_list=""},

	user_card_info_init  						={code = 9219, command = "user_card_info_init",   					command_fun = command_user_card_info_init,								param_list=""},
	team_arena_enter  						={code = 9220, command = "team_arena_enter",   					command_fun = command_team_arena_enter,								param_list=""},
	team_arena_formation_set  						={code = 9221, command = "team_arena_formation_set",   					command_fun = command_team_arena_formation_set,								param_list=""},
	team_arena_enter_build_up_hall  						={code = 9222, command = "team_arena_enter_build_up_hall",   					command_fun = command_team_arena_enter_build_up_hall,								param_list=""},
	team_arena_create_team  						={code = 9223, command = "team_arena_create_team",   					command_fun = command_team_arena_create_team,								param_list=""},
	team_arena_apply  						={code = 9224, command = "team_arena_apply",   					command_fun = command_team_arena_apply,								param_list=""},
	team_arena_find  						={code = 9225, command = "team_arena_find",   					command_fun = command_team_arena_find,								param_list=""},
	team_arena_exit_team  						={code = 9226, command = "team_arena_exit_team",   					command_fun = command_team_arena_exit_team,								param_list=""},
	team_arena_get_invite_infos  						={code = 9227, command = "team_arena_get_invite_infos",   					command_fun = command_team_arena_get_invite_infos,								param_list=""},
	team_arena_handle_invite_info  						={code = 9228, command = "team_arena_handle_invite_info",   					command_fun = command_team_arena_handle_invite_info,								param_list=""},
	team_arena_get_can_invite_users  						={code = 9229, command = "team_arena_get_can_invite_users",   					command_fun = command_team_arena_get_can_invite_users,								param_list=""},
	team_arena_invite  						={code = 9230, command = "team_arena_invite",   					command_fun = command_team_arena_invite,								param_list=""},
	team_arena_get_apply_infos  						={code = 9231, command = "team_arena_get_apply_infos",   					command_fun = command_team_arena_get_apply_infos,								param_list=""},
	team_arena_handle_apply_info  						={code = 9232, command = "team_arena_handle_apply_info",   					command_fun = command_team_arena_handle_apply_info,								param_list=""},
	team_arena_transfer_captain  						={code = 9233, command = "team_arena_transfer_captain",   					command_fun = command_team_arena_transfer_captain,								param_list=""},
	team_arena_kick_out  						={code = 9234, command = "team_arena_kick_out",   					command_fun = command_team_arena_kick_out,								param_list=""},
	team_arena_commit_team  						={code = 9235, command = "team_arena_commit_team",   					command_fun = command_team_arena_commit_team,								param_list=""},
	team_arena_challenge_times  						={code = 9236, command = "team_arena_challenge_times",   					command_fun = command_team_arena_challenge_times,								param_list=""},
	team_arena_matching  						={code = 9237, command = "team_arena_matching",   					command_fun = command_team_arena_matching,								param_list=""},
	team_arena_challenge  						={code = 9238, command = "team_arena_challenge",   					command_fun = command_team_arena_challenge,								param_list=""},
	team_arena_team_info_get  						={code = 9239, command = "team_arena_team_info_get",   					command_fun = command_team_arena_team_info_get,								param_list=""},
	team_arena_change_fight_turn  						={code = 9240, command = "team_arena_change_fight_turn",   					command_fun = command_team_arena_change_fight_turn,								param_list=""},
	team_arena_battle_report_list  						={code = 9241, command = "team_arena_battle_report_list",   					command_fun = command_team_arena_battle_report_list,								param_list=""},
	team_arena_check_battle_report  						={code = 9242, command = "team_arena_check_battle_report",   					command_fun = command_team_arena_check_battle_report,								param_list=""},
	team_arena_formation_get  						={code = 9243, command = "team_arena_formation_get",   					command_fun = command_team_arena_formation_get,								param_list=""},

	egg_frenzy_init  						={code = 9244, command = "egg_frenzy_init",   					command_fun = command_egg_frenzy_init,						param_list=""},
	egg_frenzy_draw  						={code = 9245, command = "egg_frenzy_draw",   					command_fun = command_egg_frenzy_draw,						param_list=""},
	egg_frenzy_get_reward  					={code = 9246, command = "egg_frenzy_get_reward",   			command_fun = command_egg_frenzy_get_reward,				param_list=""},
	egg_frenzy_bug_prop  					={code = 9247, command = "egg_frenzy_bug_prop",   				command_fun = command_egg_frenzy_bug_prop,					param_list=""},

	world_boss_attack 						={code = 9248, command = "world_boss_attack",   				command_fun = command_world_boss_attack,					param_list=""},

	ship_spirit_batch_level_up 				={code = 9249, command = "ship_spirit_batch_level_up",   		command_fun = command_ship_spirit_batch_level_up,			param_list=""},
	combine_ship_prop_state_get 			={code = 9250, command = "combine_ship_prop_state_get",   		command_fun = command_combine_ship_prop_state_get,			param_list=""},
	combine_ship_prop_receive 				={code = 9251, command = "combine_ship_prop_receive",   		command_fun = command_combine_ship_prop_receive,			param_list=""},

	summer_cool_weal_init 					={code = 9252, command = "summer_cool_weal_init",   			command_fun = command_summer_cool_weal_init,				param_list=""},
	summer_cool_weal_get_reward 			={code = 9253, command = "summer_cool_weal_get_reward",   		command_fun = command_summer_cool_weal_get_reward,			param_list=""},

	secret_travel_init 						={code = 9254, command = "secret_travel_init",   				command_fun = command_secret_travel_init,				param_list=""},
	secret_travel_draw 						={code = 9255, command = "secret_travel_draw",   				command_fun = command_secret_travel_draw,				param_list=""},
	secret_travel_get_reward 				={code = 9256, command = "secret_travel_get_reward",   			command_fun = command_secret_travel_get_reward,			param_list=""},
	secret_travel_set_reward 				={code = 9257, command = "secret_travel_set_reward",   			command_fun = command_secret_travel_set_reward,			param_list=""},
	secret_travel_next_tier 				={code = 9258, command = "secret_travel_next_tier",   			command_fun = command_secret_travel_next_tier,			param_list=""},

	equipment_harden						={code = 9259, command = "equipment_harden",   					command_fun = command_equipment_harden,					param_list=""},
	equipment_harden_replace 				={code = 9260, command = "equipment_harden_replace",   			command_fun = command_equipment_harden_replace,			param_list=""},
	equipment_harden_locking 				={code = 9261, command = "equipment_harden_locking",   			command_fun = command_equipment_harden_locking,			param_list=""},

	biographies_init 						={code = 9262, command = "biographies_init",   					command_fun = command_biographies_init,					param_list=""},
	biographies_activate 					={code = 9263, command = "biographies_activate",   				command_fun = command_biographies_activate,				param_list=""},
	biographies_achieve_activate 			={code = 9264, command = "biographies_achieve_activate",   		command_fun = command_biographies_achieve_activate,		param_list=""},
	biographies_advance 					={code = 9265, command = "biographies_advance",   				command_fun = command_biographies_advance,				param_list=""},
	biographies_rebirth 					={code = 9266, command = "biographies_rebirth",   				command_fun = command_biographies_rebirth,				param_list=""},
	biographies_rank 						={code = 9267, command = "biographies_rank",   					command_fun = command_biographies_rank,					param_list=""},
	biographies_draw 						={code = 9268, command = "biographies_draw",   					command_fun = command_biographies_draw,					param_list=""},
	biographies_buy_prop					={code = 9269, command = "biographies_buy_prop",   				command_fun = command_biographies_buy_prop,				param_list=""},

	get_user_ban_time					={code = 9270, command = "get_user_ban_time",   				command_fun = command_get_user_ban_time,				param_list=""},

	biographies_get_extra_reward		={code = 9271, command = "biographies_get_extra_reward",   				command_fun = command_biographies_get_extra_reward,				param_list=""},

	activity_orders_world_init			={code = 9272, command = "activity_orders_world_init",   				command_fun = command_activity_orders_world_init,				param_list=""},
	activity_orders_world_donate		={code = 9273, command = "activity_orders_world_donate",   				command_fun = command_activity_orders_world_donate,				param_list=""},
	activity_orders_world_exchange		={code = 9274, command = "activity_orders_world_exchange",   			command_fun = command_activity_orders_world_exchange,			param_list=""},
	activity_orders_world_get_order		={code = 9275, command = "activity_orders_world_get_order",   			command_fun = command_activity_orders_world_get_order,			param_list=""},
	activity_orders_world_glory_list	={code = 9276, command = "activity_orders_world_glory_list",   			command_fun = command_activity_orders_world_glory_list,			param_list=""},
	activity_orders_world_get_reward	={code = 9277, command = "activity_orders_world_get_reward",   			command_fun = command_activity_orders_world_get_reward,			param_list=""},

	half_the_ritual_init	={code = 9278, command = "half_the_ritual_init",   			command_fun = command_half_the_ritual_init,			param_list=""},
	half_the_ritual_get_reward	={code = 9279, command = "half_the_ritual_get_reward",   			command_fun = command_half_the_ritual_get_reward,			param_list=""},

	magical_animals_init						={code = 9280, command = "magical_animals_init",   						command_fun = command_magical_animals_init,						param_list=""},
	magical_animals_activate					={code = 9281, command = "magical_animals_activate",   					command_fun = command_magical_animals_activate,					param_list=""},
	magical_animals_advance_star				={code = 9282, command = "magical_animals_advance_star",   				command_fun = command_magical_animals_advance_star,				param_list=""},
	magical_animals_steps_rebirth				={code = 9283, command = "magical_animals_steps_rebirth",   			command_fun = command_magical_animals_steps_rebirth,			param_list=""},
	magical_animals_forging						={code = 9284, command = "magical_animals_forging",   					command_fun = command_magical_animals_forging,					param_list=""},
	magical_animals_relevant_active				={code = 9285, command = "magical_animals_relevant_active",   			command_fun = command_magical_animals_relevant_active,			param_list=""},
	magical_animals_set_skill					={code = 9286, command = "magical_animals_set_skill",   				command_fun = command_magical_animals_set_skill,				param_list=""},
	magical_animals_activate_fate				={code = 9287, command = "magical_animals_activate_fate",   			command_fun = command_magical_animals_activate_fate,			param_list=""},
	magical_animals_set_skill_release_method	={code = 9288, command = "magical_animals_set_skill_release_method",   	command_fun = command_magical_animals_set_skill_release_method,	param_list=""},

	activity_group_buy_init	={code = 9289, command = "activity_group_buy_init",   			command_fun = command_activity_group_buy_init,			param_list=""},
	activity_group_buy_gift_pack	={code = 9290, command = "activity_group_buy_gift_pack",   			command_fun = command_activity_group_buy_gift_pack,			param_list=""},
	activity_group_buy_get_reward	={code = 9291, command = "activity_group_buy_get_reward",   			command_fun = command_activity_group_buy_get_reward,			param_list=""},

	magical_animals_activate_get_fate_task_reward	={code = 9292, command = "magical_animals_activate_get_fate_task_reward",   	command_fun = command_magical_animals_activate_get_fate_task_reward,	param_list=""},

	fight_spirit_init		={code = 9293, command = "fight_spirit_init",	command_fun = command_fight_spirit_init,	param_list=""},
	fight_spirit_compund	={code = 9294, command = "fight_spirit_compund",	command_fun = command_fight_spirit_compund,	param_list=""},
	fight_spirit_ehance		={code = 9295, command = "fight_spirit_ehance",	command_fun = command_fight_spirit_ehance,	param_list=""},
	fight_spirit_awake		={code = 9296, command = "fight_spirit_awake",	command_fun = command_fight_spirit_awake,	param_list=""},
	fight_spirit_refine		={code = 9297, command = "fight_spirit_refine",	command_fun = command_fight_spirit_refine,	param_list=""},
	fight_spirit_break_down	={code = 9298, command = "fight_spirit_break_down",	command_fun = command_fight_spirit_break_down,	param_list=""},
	fight_spirit_lock		={code = 9299, command = "fight_spirit_lock",	command_fun = command_fight_spirit_lock,	param_list=""},
	fight_spirit_change		={code = 9300, command = "fight_spirit_change",	command_fun = command_fight_spirit_change,	param_list=""},
	fight_spirit_refine_define		={code = 9301, command = "fight_spirit_refine_define",	command_fun = command_fight_spirit_refine_define,	param_list=""},

	biographies_mark_synthesis	={code = 9302, command = "biographies_mark_synthesis",	command_fun = command_biographies_mark_synthesis,	param_list=""},
	seven_day_recharge_init	={code = 9303, command = "seven_day_recharge_init",	command_fun = command_seven_day_recharge_init,	param_list=""},
	seven_day_recharge_get_reward	={code = 9304, command = "seven_day_recharge_get_reward",	command_fun = command_seven_day_recharge_get_reward,	param_list=""},
	seven_day_recharge_use_voucher	={code = 9305, command = "seven_day_recharge_use_voucher",	command_fun = command_seven_day_recharge_use_voucher,	param_list=""},

	get_web_recharge_state	=	{code = 9306, command = "get_web_recharge_state",	command_fun = command_get_web_recharge_state,	param_list=""},
	use_voucher				=	{code = 9307, command = "use_voucher",	       		command_fun = command_use_voucher,				param_list=""},
	sell_voucher			=	{code = 9308, command = "sell_voucher",				command_fun = command_sell_voucher,				param_list=""},

	limit_blessing_init					=	{code = 9309, command = "limit_blessing_init",					command_fun = command_limit_blessing_init,					param_list=""},
	limit_blessing_set					=	{code = 9310, command = "limit_blessing_set",					command_fun = command_limit_blessing_set,					param_list=""},
	limit_blessing_draw					=	{code = 9311, command = "limit_blessing_draw",					command_fun = command_limit_blessing_draw,					param_list=""},
	limit_blessing_get_blessing_reward	=	{code = 9312, command = "limit_blessing_get_blessing_reward",	command_fun = command_limit_blessing_get_blessing_reward,	param_list=""},
	limit_blessing_get_task_reward		=	{code = 9313, command = "limit_blessing_get_task_reward",		command_fun = command_limit_blessing_get_task_reward,		param_list=""},
	limit_blessing_set_spree_reward		=	{code = 9314, command = "limit_blessing_set_spree_reward",		command_fun = command_limit_blessing_set_spree_reward,		param_list=""},
	limit_blessing_get_spree_reward		=	{code = 9315, command = "limit_blessing_get_spree_reward",		command_fun = command_limit_blessing_get_spree_reward,		param_list=""},
	limit_blessing_buy_prop				=	{code = 9316, command = "limit_blessing_buy_prop",				command_fun = command_limit_blessing_buy_prop,				param_list=""},

	lucky_turntable_init				=	{code = 9317, command = "lucky_turntable_init",				command_fun = command_lucky_turntable_init,				param_list=""},
	lucky_turntable_draw				=	{code = 9318, command = "lucky_turntable_draw",				command_fun = command_lucky_turntable_draw,				param_list=""},
	lucky_turntable_open_chest			=	{code = 9319, command = "lucky_turntable_open_chest",		command_fun = command_lucky_turntable_open_chest,		param_list=""},
	lucky_turntable_flash				=	{code = 9320, command = "lucky_turntable_flash",			command_fun = command_lucky_turntable_flash,			param_list=""},
	lucky_turntable_buy_prop			=	{code = 9321, command = "lucky_turntable_buy_prop",			command_fun = command_lucky_turntable_buy_prop,			param_list=""},

	celebration_order_init				=	{code = 9322, command = "celebration_order_init",				command_fun = command_celebration_order_init,				param_list=""},
	celebration_order_get_order			=	{code = 9323, command = "celebration_order_get_order",			command_fun = command_celebration_order_get_order,			param_list=""},
	celebration_order_get_day_reward	=	{code = 9324, command = "celebration_order_get_day_reward",		command_fun = command_celebration_order_get_day_reward,		param_list=""},
	celebration_order_get_order_reward	=	{code = 9325, command = "celebration_order_get_order_reward",	command_fun = command_celebration_order_get_order_reward,	param_list=""},
	celebration_order_get_achieve		=	{code = 9326, command = "celebration_order_get_achieve",		command_fun = command_celebration_order_get_achieve,		param_list=""},
	carnival_n_day						=	{code = 9327, command = "carnival_n_day",						command_fun = command_carnival_n_day,						param_list=""},

	new_recruitment_system	    		=   {code = 9328, command = "new_recruitment_system",				command_fun = command_new_recruitment_system,				param_list=""},
	new_recruitment_shop_buy	    	=   {code = 9329, command = "new_recruitment_shop_buy",				command_fun = command_new_recruitment_shop_buy,				param_list=""},
	view_draw_items	    				=   {code = 9330, command = "view_draw_items",						command_fun = command_view_draw_items,						param_list=""},
	wish_list_enter	    				=   {code = 9331, command = "wish_list_enter",						command_fun = command_wish_list_enter,						param_list=""},
	wish_list_set	    				=   {code = 9332, command = "wish_list_set",						command_fun = command_wish_list_set,						param_list=""},

	user_build_war_order_init			=   {code = 9333, command = "user_build_war_order_init",			command_fun = command_user_build_war_order_init, 			param_list=""},
	user_build_war_order_get_reward		=   {code = 9334, command = "user_build_war_order_get_reward",		command_fun = command_user_build_war_order_get_reward, 		param_list=""},
	user_build_war_order_buy			=   {code = 9335, command = "user_build_war_order_buy",				command_fun = command_user_build_war_order_buy, 			param_list=""},

	normal_war_order_init				=   {code = 9336, command = "normal_war_order_init",				command_fun = command_normal_war_order_init, 				param_list=""},
	normal_war_order_get_reward			=   {code = 9337, command = "normal_war_order_get_reward",			command_fun = command_normal_war_order_get_reward, 			param_list=""},

	war_order_activation				=   {code = 9338, command = "war_order_activation",					command_fun = command_war_order_activation, 				param_list=""},

	monopoly_init						=   {code = 9339, command = "monopoly_init",						command_fun = command_monopoly_init, 						param_list=""},
	monopoly_throw_dice					=   {code = 9340, command = "monopoly_throw_dice",					command_fun = command_monopoly_throw_dice, 					param_list=""},
	monopoly_transmission				=   {code = 9341, command = "monopoly_transmission",				command_fun = command_monopoly_transmission, 				param_list=""},
	monopoly_get_task_reward			=   {code = 9342, command = "monopoly_get_task_reward",				command_fun = command_monopoly_get_task_reward, 			param_list=""},
	monopoly_change_achieve_reward		=   {code = 9343, command = "monopoly_change_achieve_reward",		command_fun = command_monopoly_change_achieve_reward, 		param_list=""},
	monopoly_get_achieve_reward			=   {code = 9344, command = "monopoly_get_achieve_reward",			command_fun = command_monopoly_get_achieve_reward, 			param_list=""},
	monopoly_reward_log					=   {code = 9345, command = "monopoly_reward_log",					command_fun = command_monopoly_reward_log, 					param_list=""},
	monopoly_buy						=   {code = 9346, command = "monopoly_buy",							command_fun = command_monopoly_buy, 						param_list=""},

	cross_time_limit_jackpot_init					=   {code = 9347, command = "cross_time_limit_jackpot_init",				command_fun = command_cross_time_limit_jackpot_init, 					param_list=""},
	cross_time_limit_jackpot_draw					=   {code = 9348, command = "cross_time_limit_jackpot_draw",				command_fun = command_cross_time_limit_jackpot_draw, 					param_list=""},
	cross_time_limit_jackpot_rank					=   {code = 9349, command = "cross_time_limit_jackpot_rank",				command_fun = command_cross_time_limit_jackpot_rank, 					param_list=""},
	cross_time_limit_jackpot_notice					=   {code = 9350, command = "cross_time_limit_jackpot_notice",				command_fun = command_cross_time_limit_jackpot_notice, 					param_list=""},
	cross_time_limit_jackpot_buy_prop				=   {code = 9351, command = "cross_time_limit_jackpot_buy_prop",			command_fun = command_cross_time_limit_jackpot_buy_prop, 				param_list=""},
	cross_time_limit_jackpot_get_task_reward		=   {code = 9352, command = "cross_time_limit_jackpot_get_task_reward",		command_fun = command_cross_time_limit_jackpot_get_task_reward, 		param_list=""},

	rift_data											=   {code = 9991, command = "rift_data", command_fun = command_rift_data, param_list=""},
	six_paths											=   {code = 9992, command = "six_paths", command_fun = command_six_paths, param_list=""},
	tutorial_skip											=   {code = 9993, command = "tutorial_skip", command_fun = command_tutorial_skip, param_list=""},
	ninja_review										=   {code = 9990, command = "ninja_review", command_fun = command_ninja_review, param_list=""},

	change_user_head_frame								=   {code = 9353, command = "change_user_head_frame",							command_fun = command_change_user_head_frame, 								param_list=""},

	combine_ship_one_key_update_slot					=   {code = 9354, command = "combine_ship_one_key_update_slot",					command_fun = command_combine_ship_one_key_update_slot, 					param_list=""},

	user_advertisement_click						=   {code = 9355, command = "user_advertisement_click",						command_fun = command_user_advertisement_click, 					param_list=""},
	user_advertisement_finish						=   {code = 9356, command = "user_advertisement_finish",					command_fun = command_user_advertisement_finish, 					param_list=""},

	one_key_draw_scene_reward						=   {code = 9357, command = "one_key_draw_scene_reward",					command_fun = command_one_key_draw_scene_reward, 					param_list=""},

	one_key_draw_union_copy_draw_reward				=   {code = 9358, command = "one_key_draw_union_copy_draw_reward",			command_fun = command_one_key_draw_union_copy_draw_reward, 			param_list=""},

	see_union_info									=   {code = 9359, command = "see_union_info",								command_fun = command_see_union_info, 								param_list=""},

	jump_page_get_reward							=   {code = 9360, command = "jump_page_get_reward",							command_fun = command_jump_page_get_reward, 						param_list=""},

	stick_crazy_one_key_get							=	{code = 9361, command = "stick_crazy_one_key_get",							command_fun = command_stick_crazy_one_key_get,							param_list=""},
	stick_crazy_jump_cost							=	{code = 9362, command = "stick_crazy_jump_cost",							command_fun = command_stick_crazy_jump_cost,							param_list=""},

	time_limit_lottery_init							=	{code = 9363, command = "time_limit_lottery_init",							command_fun = command_time_limit_lottery_init,							param_list=""},
	time_limit_lottery_draw							=	{code = 9364, command = "time_limit_lottery_draw",							command_fun = command_time_limit_lottery_draw,							param_list=""},
	time_limit_lottery_buy							=	{code = 9365, command = "time_limit_lottery_buy",							command_fun = command_time_limit_lottery_buy,							param_list=""},
	time_limit_lottery_draw_log						=	{code = 9366, command = "time_limit_lottery_draw_log",						command_fun = command_time_limit_lottery_draw_log,						param_list=""},

	mysterious_egg_receive_reward					=	{code = 9367, command = "mysterious_egg_receive_reward",					command_fun = command_mysterious_egg_receive_reward,					param_list=""},

	first_charge_init								=	{code = 9368, command = "first_charge_init",								command_fun = command_first_charge_init,								param_list=""},
	first_charge_receive_reward						=	{code = 9369, command = "first_charge_receive_reward",						command_fun = command_first_charge_receive_reward,						param_list=""},
	monthly_card_receive_reward						=	{code = 9370, command = "monthly_card_receive_reward",						command_fun = command_monthly_card_receive_reward,						param_list=""},
	monthly_card_activate							=	{code = 9371, command = "monthly_card_activate",							command_fun = command_monthly_card_activate,							param_list=""},

	guest_account_generate							=	{code = 9372, command = "guest_account_generate",							command_fun = command_guest_account_generate,							param_list=""},
}
local protocol_command_count = table.getn(protocol_command)

function find_command(code)
	for i, v in pairs(protocol_command) do
		if v.code == code then
			return v
		end
	end
	return nil
end


 function find_param_list(command)
	for i, v in pairs(protocol_command) do
		if v.command == command then
			return v.param_list
		end
	end
	return nil
end

function replaceDomainName()



	local domainStr = "j7game.com"

	if __lua_project_id == __lua_project_l_pokemon then
		domainStr = "bdwmjl.com"
	elseif __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
		domainStr = "mmwdb.com"
	elseif __lua_project_id == __lua_project_l_naruto then
		domainStr = "ngkhwhg.com"
	end

	local needReplaceStr_1 = "jar%-world3000.com"
	local needReplaceStr_2 = "j7game.com"

	local domainUrl = app.configJson.url
	local announceUrl = app.configJson.urlForAnnounce

	if domainUrl then
		if string.find(domainUrl, needReplaceStr_1) ~= nil then
			app.configJson.url = string.gsub(domainUrl, needReplaceStr_1, domainStr)
		elseif string.find(domainUrl, needReplaceStr_2) ~= nil then
			app.configJson.url = string.gsub(domainUrl, needReplaceStr_2, domainStr)
		end
	end
	if announceUrl then
		if string.find(announceUrl, needReplaceStr_1) ~= nil then
			app.configJson.urlForAnnounce = string.gsub(announceUrl, needReplaceStr_1, domainStr)
		elseif string.find(announceUrl, needReplaceStr_2) ~= nil then
			app.configJson.urlForAnnounce = string.gsub(announceUrl, needReplaceStr_2, domainStr)
		end
	end



end

replaceDomainName()