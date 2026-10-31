


function command_get_server_list(str)
	str = str.."\r\n"
	str = str..protocol_command.get_server_list.command
	str = str.."\r\n"
	str = str..getVersion()
	str = str.."\r\n"
	str = str..""..m_sOperatorName..","..m_sOperationPlatformName..","..m_sUserAccountPlatformName
	str = str.."\r\n"
	str = str..getPackageParam()
	return str
end




function command_platform_manage(str)
	str = str.."\r\n"
	str = str..protocol_command.platform_manage.command
	str = str.."\r\n"
	str = str..getVersion()
	str = str.."\r\n"
	str = str..protocol_command.platform_manage.param_list
	str = str.."\r\n"
	str = str..getPlatformParam()
	return str
end




function command_search_user_platform(str)
	str = str.."\r\n"
	str = str..protocol_command.search_user_platform.command
	str = str.."\r\n"
	str = str..getVersion()
	str = str.."\r\n"
	str = str..getPlatformParam()
	return str
end




function command_platform_login(str)
	str = str.."\r\n"
	str = str..protocol_command.platform_login.command
	str = str.."\r\n"
	str = str..getVersion()
	str = str.."\r\n"
	str = str..protocol_command.platform_login.param_list
	str = str.."\r\n"
	str = str..getPlatformParam()
	return str
end




function command_modify_platform_password(str)
	str = str.."\r\n"
	str = str..protocol_command.modify_platform_password.command
	str = str.."\r\n"
	str = str..getVersion()
	str = str.."\r\n"
	str = str..protocol_command.modify_platform_password.param_list
	str = str.."\r\n"
	str = str..getPlatformParam()
	return str
end




function command_get_random_name(str)
	str = str.."\r\n"
	str = str..protocol_command.get_random_name.command
	str = str.."\r\n"
	str = str..protocol_command.get_random_name.param_list
	str = str.."\r\n"
	str = str..getPlatformParam()
	return str
end




function command_vali_register(str)
	str = str.."\r\n"
	str = str..protocol_command.vali_register.command
	str = str.."\r\n"
	str = str..protocol_command.vali_register.param_list
	return str
end



function command_login_init(str)
	str = str.."\r\n"
	str = str..protocol_command.login_init.command
	str = str.."\r\n"
	str = str..getVersion()
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_naruto or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		str = str.."\r\n"
		if m_curr_choose_language ~= nil and m_curr_choose_language ~= "" then
			str = str..m_curr_choose_language
		else
			str = str..""
		end
	end
	str = str.."\r\n"

	str = str..protocol_command.login_init.param_list
	str = str.."\r\n"
	str = str..(userLoginPackageName == nil and "" or userLoginPackageName)
	str = str.."\r\n"
	str = str..(userLoginToken == nil and "" or userLoginToken)
	str = str.."\r\n"

	str = str..getPlatformParam()
	str = str.."\r\n"
	str = str..(m_sUin == nil and "" or m_sUin)
	str = str.."\r\n"
	str = str..(m_sSessionId == nil and "" or m_sSessionId)
	str = str.."\r\n"
	return str
end



function command_register_game_account(str)
	str = str.."\r\n"
	str = str..protocol_command.register_game_account.command
	str = str.."\r\n"
	str = str..protocol_command.register_game_account.param_list
	str = str.."\r\n"
	str = str..getPlatformParam()
	str = str..m_curr_choose_language
	return str
end



function command_formation_change(str)
	str = str.."\r\n"
	str = str..protocol_command.formation_change.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.formation_change.param_list
	return str
end



function command_equipment_adorn(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_adorn.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_adorn.param_list
	return str
end




function command_environment_fight(str)
	str = str.."\r\n"
	str = str..protocol_command.environment_fight.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.environment_fight.param_list
	return str
end




function command_shop_view(str)
	str = str.."\r\n"
	str = str..protocol_command.shop_view.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.shop_view.param_list
	return str
end




function command_ship_bounty(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_bounty.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_bounty.param_list
	return str
end




function command_search_order_list(str)
	str = str.."\r\n"
	str = str..protocol_command.search_order_list.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.search_order_list.param_list
	return str
end




function command_draw_scene_rewad(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_scene_rewad.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_scene_rewad.param_list
	return str
end




function command_trigger_scene_surprise(str)
	str = str.."\r\n"
	str = str..protocol_command.trigger_scene_surprise.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		str = str.."1"
	else
		str = str.._ED._current_scene_id
	end
	str = str.."\r\n"
	str = str..protocol_command.trigger_scene_surprise.param_list
	return str
end




function command_ship_grow_up(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_grow_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_grow_up.param_list
	return str
end




function command_battle_field_init(str)
	str = str.."\r\n"
	str = str..protocol_command.battle_field_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str.._ED._battle_init_type
	str = str.."\r\n"
	str = str..protocol_command.battle_field_init.param_list
	return str
end




function command_prop_sell(str)
	str = str.."\r\n"
	str = str..protocol_command.prop_sell.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.prop_sell.param_list
	return str
end




function command_view_ship_grow_up_additional(str)
	str = str.."\r\n"
	str = str..protocol_command.view_ship_grow_up_additional.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.view_ship_grow_up_additional.param_list
	return str
end




function command_prop_use(str)
	str = str.."\r\n"
	str = str..protocol_command.prop_use.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.prop_use.param_list
	return str
end




function command_basic_consumption(str)
	str = str.."\r\n"
	str = str..protocol_command.basic_consumption.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.basic_consumption.param_list
	return str
end




function command_equipment_sell(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_sell.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_sell.param_list
	return str
end




function command_equipment_escalate(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_escalate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_escalate.param_list
	return str
end




function command_prop_compound(str)
	str = str.."\r\n"
	str = str..protocol_command.prop_compound.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.prop_compound.param_list
	return str
end




function command_ship_sell(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_sell.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_sell.param_list
	return str
end




function command_ship_batch_bounty(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_batch_bounty.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_batch_bounty.param_list
	return str
end




function command_refusal_start(str)
	str = str.."\r\n"
	str = str..protocol_command.refusal_start.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.refusal_start.param_list
	return str
end




function command_refresh_grab_list(str)
	str = str.."\r\n"
	str = str..protocol_command.refresh_grab_list.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.refresh_grab_list.param_list
	return str
end




function command_grab_launch(str)
	str = str.."\r\n"
	str = str..protocol_command.grab_launch.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.grab_launch.param_list
	return str
end




function command_companion_change(str)
	str = str.."\r\n"
	str = str..protocol_command.companion_change.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.companion_change.param_list
	return str
end




function command_ship_escalate(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_escalate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_escalate.param_list
	return str
end




function command_treasure_escalate(str)
	str = str.."\r\n"
	str = str..protocol_command.treasure_escalate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.treasure_escalate.param_list
	return str
end




function command_get_activity_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.get_activity_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_activity_reward.param_list
	return str
end




function command_draw_online_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_online_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_online_reward.param_list
	return str
end



function command_bounty_limit_init(str)
	str = str.."\r\n"
	str = str..protocol_command.bounty_limit_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.bounty_limit_init.param_list
	return str
end



function command_bounty_limit_start(str)
	str = str.."\r\n"
	str = str..protocol_command.bounty_limit_start.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.bounty_limit_start.param_list
	return str
end



function command_dinner_init(str)
	str = str.."\r\n"
	str = str..protocol_command.dinner_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end



function command_dinner_time(str)
	str = str.."\r\n"
	str = str..protocol_command.dinner_time.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.dinner_time.param_list
	return str
end



function command_draw_bounty_limit_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_bounty_limit_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_bounty_limit_reward.param_list
	return str
end



function command_secret_shop_init(str)
	str = str.."\r\n"
	str = str..protocol_command.secret_shop_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.secret_shop_init.param_list
	return str
end



function command_secret_shop_refresh(str)
	str = str.."\r\n"
	str = str..protocol_command.secret_shop_refresh.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.secret_shop_refresh.param_list
	return str
end



function command_secret_shop_exchange(str)
	str = str.."\r\n"
	str = str..protocol_command.secret_shop_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.secret_shop_exchange.param_list
	return str
end



function command_divine_init(str)
	str = str.."\r\n"
	str = str..protocol_command.divine_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end



function command_divine_start(str)
	str = str.."\r\n"
	str = str..protocol_command.divine_start.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.divine_start.param_list
	return str
end



function command_divine_refresh(str)
	str = str.."\r\n"
	str = str..protocol_command.divine_refresh.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end



function command_friend_update(str)
	str = str.."\r\n"
	str = str..protocol_command.friend_update.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end



function command_email_init(str)
	str = str.."\r\n"
	str = str..protocol_command.email_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.email_init.param_list
	return str
end




function command_prop_purchase(str)
	str = str.."\r\n"
	str = str..protocol_command.prop_purchase.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.prop_purchase.param_list
	return str
end




function command_equipment_purchase(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_purchase.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_purchase.param_list
	return str
end




function command_equipment_onekey_adorn(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_onekey_adorn.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_onekey_adorn.param_list
	return str
end



function command_draw_divine_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_divine_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end



function command_random_user_list(str)
	str = str.."\r\n"
	str = str..protocol_command.random_user_list.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.random_user_list.param_list
	return str
end



function command_present_endurance(str)
	str = str.."\r\n"
	str = str..protocol_command.present_endurance.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.present_endurance.param_list
	return str
end




function command_attack_purchase(str)
	str = str.."\r\n"
	str = str..protocol_command.attack_purchase.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.attack_purchase.param_list
	return str
end




function command_search_user(str)
	str = str.."\r\n"
	str = str..protocol_command.search_user.command
	str = str.."\r\n"
	str = str..protocol_command.search_user.param_list
	return str
end




function command_refining(str)
	str = str.."\r\n"
	str = str..protocol_command.refining.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.refining.param_list
	return str
end



function command_friend_msg(str)
	str = str.."\r\n"
	str = str..protocol_command.friend_msg.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.friend_msg.param_list
	return str
end



function command_friend_del(str)
	str = str.."\r\n"
	str = str..protocol_command.friend_del.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.friend_del.param_list
	return str
end



function command_friend_request(str)
	str = str.."\r\n"
	str = str..protocol_command.friend_request.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.friend_request.param_list
	return str
end



function command_draw_endurance_init(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_endurance_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end




function command_draw_cdkey_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_cdkey_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_cdkey_reward.param_list
	return str
end



function command_draw_endurance(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_endurance.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_endurance.param_list
	return str
end




function command_friend_pass(str)
	str = str.."\r\n"
	str = str..protocol_command.friend_pass.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.friend_pass.param_list
	return str
end




function command_get_system_notice(str)
	str = str.."\r\n"
	str = str..protocol_command.get_system_notice.command
	str = str.."\r\n"
	if m_curr_choose_language ~= nil and m_curr_choose_language ~= "" then
		if zstring.tonumber(m_curr_choose_language) == 0 then
			str = str.."zh_CN"
		else
			str = str..m_curr_choose_language
		end
	else
		str = str..""
	end
	str = str.."\r\n"
	if __lua_project_id == __lua_project_red_alert_time
		or __lua_project_id == __lua_project_pacific_rim
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
		or __lua_project_id == __lua_project_l_naruto
		then
		if _ED.selected_server ~= nil and _ED.all_servers ~= nil and _ED.all_servers[_ED.selected_server] ~= nil then
			local server_number = _ED.all_servers[_ED.selected_server].server_number
			if server_number ~= nil then
				str = str..server_number.."\r\n"
			end
		end

		if app.configJson.OperatorName then
			str = str..app.configJson.OperatorName.."\r\n"
		end
	end
	return str
end




function command_draw_vip_every_day_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_vip_every_day_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_vip_every_day_reward.param_list
	return str
end




function command_keep_alive(str)
	str = str.."\r\n"
	str = str..protocol_command.keep_alive.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	if _ED.signal_strength ~= 0 and _ED.network_delay_time_ms ~= 0 then
		str = str.."\r\n"
		str = str.._ED.signal_strength.."|".._ED.network_delay_time_ms
	end
	return str
end




function command_request_top_up_order_number(str)
	str = str.."\r\n"
	str = str..protocol_command.request_top_up_order_number.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.request_top_up_order_number.param_list


	if _ED.curPurchaseGiftID ~= nil then
		str = str.."\r\n"
		str = str.._ED.curPurchaseGiftID
	else
		str = str.."\r\n"
		str = str.."-1"
	end





	return str
end





function command_vali_top_up_order_number(str)
	str = str.."\r\n"
	str = str..protocol_command.vali_top_up_order_number.command


	str = str.."\r\n"
	str = str..protocol_command.vali_top_up_order_number.param_list


	if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_MAC then
		local paramListStr = protocol_command.vali_top_up_order_number.param_list
		local param_list = zstring.split(paramListStr, "\r\n")
		local isAppStore = false
		if param_list ~= nil then
			isAppStore = param_list[3] == "AppStore"
		end

		if isAppStore == true then
			local recharge_id = _ED.recharge_result.recharge_id
			if recharge_id == nil or recharge_id == "" then
				recharge_id = "-1"
			else
				local rechargeInfo = zstring.split(recharge_id, "_")
				if rechargeInfo ~= nil then
					recharge_id = rechargeInfo[2]
					if recharge_id == nil or recharge_id == "" then
						recharge_id = "-1"
					end
				end
			end
			str = str.."\r\n"
			str = str..recharge_id
		end
	end
	return str
end




function command_vali_top_up_order_number7000(str)
	str = str.."\r\n"
	str = str..protocol_command.vali_top_up_order_number7000.command


	str = str.."\r\n"
	str = str..protocol_command.vali_top_up_order_number7000.param_list
	return str
end



function command_arena_init(str)
	str = str.."\r\n"
	str = str..protocol_command.arena_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.arena_init.param_list
	return str
end




function command_arena_launch(str)
	str = str.."\r\n"
	str = str..protocol_command.arena_launch.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.arena_launch.param_list
	return str
end




function command_arena_order(str)
	str = str.."\r\n"
	str = str..protocol_command.arena_order.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.arena_order.param_list
	return str
end




function command_send_message(str)
	str = str.."\r\n"
	str = str..protocol_command.send_message.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.send_message.param_list
	return str
end




function command_gm_message_send(str)
	str = str.."\r\n"
	str = str..protocol_command.gm_message_send.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.gm_message_send.param_list
	return str
end




function command_gm_message_init(str)
	str = str.."\r\n"
	str = str..protocol_command.gm_message_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.gm_message_init.param_list
	return str
end




function command_arena_shop_init(str)
	str = str.."\r\n"
	str = str..protocol_command.arena_shop_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.arena_shop_init.param_list
	return str
end




function command_arena_shop_exchange(str)
	str = str.."\r\n"
	str = str..protocol_command.arena_shop_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.arena_shop_exchange.param_list
	return str
end




function command_look_at_user_fleet(str)
	str = str.."\r\n"
	str = str..protocol_command.look_at_user_fleet.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.look_at_user_fleet.param_list
	return str
end




function command_reward_center_init(str)
	str = str.."\r\n"
	str = str..protocol_command.reward_center_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.reward_center_init.param_list
	return str
end




function command_arena_reward_draw(str)
	str = str.."\r\n"
	str = str..protocol_command.arena_reward_draw.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.arena_reward_draw.param_list
	return str
end




function command_draw_arena_lucky(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_arena_lucky.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_arena_lucky.param_list
	return str
end





function command_draw_reward_center(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_reward_center.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_reward_center.param_list
	return str
end




function command_destiny_init(str)
	str = str.."\r\n"
	str = str..protocol_command.destiny_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end




function command_destiny_start(str)
	str = str.."\r\n"
	str = str..protocol_command.destiny_start.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end




function command_favor_item_use(str)
	str = str.."\r\n"
	str = str..protocol_command.favor_item_use.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.favor_item_use.param_list
	return str
end




function command_activate_app(str)
	str = str.."\r\n"
	str = str..protocol_command.activate_app.command
	str = str.."\r\n"
	str = str..getVersion()
	str = str.."\r\n"
	str = str..getPlatformParam()
	return str
end




function command_education_change(str)
	str = str.."\r\n"
	str = str..protocol_command.education_change.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.education_change.param_list
	return str
end




function command_record_crash(str)
	str = str.."\r\n"
	str = str..protocol_command.record_crash.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.record_crash.param_list
	return str
end




function command_equipment_rank_up(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_rank_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_rank_up.param_list
	return str
end




function command_get_resource(str)
	str = str.."\r\n"
	str = str..protocol_command.get_resource.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_resource.param_list
	return str
end




function command_refining_equipment(str)
	str = str.."\r\n"
	str = str..protocol_command.refining_equipment.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.refining_equipment.param_list
	return str
end

function command_refining_replace(str)
	str = str.."\r\n"
	str = str..protocol_command.refining_replace.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.refining_replace.param_list
	return str
end




function command_draw_first_top_up_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_first_top_up_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_first_top_up_reward.param_list
	return str
end




function command_login_init_again(str)
	str = str.."\r\n"
	str = str..protocol_command.login_init_again.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.login_init_again.param_list
	return str
end




function command_rebirth(str)
	str = str.."\r\n"
	str = str..protocol_command.rebirth.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.rebirth.param_list
	return str
end




function command_draw_bounty_limit(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_bounty_limit.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_bounty_limit.param_list
	return str
end




function command_sweep(str)
	str = str.."\r\n"
	str = str..protocol_command.sweep.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.sweep.param_list
	return str
end




function command_clear_sweep_cd(str)
	str = str.."\r\n"
	str = str..protocol_command.clear_sweep_cd.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end




function command_grow_plan_purchase(str)
	str = str.."\r\n"
	str = str..protocol_command.grow_plan_purchase.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.grow_plan_purchase.param_list
	return str
end




function command_treasure_digger_init(str)
	str = str.."\r\n"
	str = str..protocol_command.treasure_digger_init.command
	str = str.."\r\n"
	str = str.."23"
	return str
end




function command_treasure_digger_start(str)
	str = str.."\r\n"
	str = str..protocol_command.treasure_digger_start.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.treasure_digger_start.param_list
	return str
end




function command_world_boss_init(str)
	str = str.."\r\n"
	str = str..protocol_command.world_boss_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end





function command_world_boss_launch(str)
	str = str.."\r\n"
	str = str..protocol_command.world_boss_launch.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end




function command_world_boss_repair(str)
	str = str.."\r\n"
	str = str..protocol_command.world_boss_repair.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end




function command_world_boss_inspire(str)
	str = str.."\r\n"
	str = str..protocol_command.world_boss_inspire.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.world_boss_inspire.param_list
	return str
end




function command_draw_world_boss_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_world_boss_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_world_boss_reward.param_list
	return str
end




function command_duel_init(str)
	str = str.."\r\n"
	str = str..protocol_command.duel_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end




function command_refresh_duel(str)
	str = str.."\r\n"
	str = str..protocol_command.refresh_duel.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end




function command_duel_launch(str)
	str = str.."\r\n"
	str = str..protocol_command.duel_launch.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.duel_launch.param_list
	return str
end




function command_duel_revenge_launch(str)
	str = str.."\r\n"
	str = str..protocol_command.duel_revenge_launch.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.duel_revenge_launch.param_list
	return str
end




function command_draw_duel_order_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_duel_order_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_duel_order_reward.param_list
	return str
end




function command_view_world_boss_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.view_world_boss_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end




function command_trans_tower_init(str)
	str = str.."\r\n"
	str = str..protocol_command.trans_tower_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.trans_tower_init.param_list
	return str
end




function command_towel_launch(str)
	str = str.."\r\n"
	str = str..protocol_command.towel_launch.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.towel_launch.param_list
	return str
end





function command_sweep_towel(str)
	str = str.."\r\n"
	str = str..protocol_command.sweep_towel.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.sweep_towel.param_list
	return str
end




function command_towel_reset(str)
	str = str.."\r\n"
	str = str..protocol_command.towel_reset.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end




function command_ship_bounty_check(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_bounty_check.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end




function command_system_time(str)
	str = str.."\r\n"
	str = str..protocol_command.system_time.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end




function command_user_sweep_rewards(str)
	str = str.."\r\n"
	str = str..protocol_command.user_sweep_rewards.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_sweep_rewards.param_list
	return str
end




function command_refresh_grab_list_for_education(str)
	str = str.."\r\n"
	str = str..protocol_command.refresh_grab_list_for_education.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.refresh_grab_list_for_education.param_list
	return str
end




function command_grab_launch_for_education(str)
	str = str.."\r\n"
	str = str..protocol_command.grab_launch_for_education.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.grab_launch_for_education.param_list
	return str
end




function command_union_create(str)
	str = str.."\r\n"
	str = str..protocol_command.union_create.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_create.param_list
	return str
end




function command_union_list (str)
	str = str.."\r\n"
	str = str..protocol_command.union_list.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_list.param_list
	return str
end




function command_union_search(str)
	str = str.."\r\n"
	str = str..protocol_command.union_search.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_search.param_list
	return str
end




function command_union_apply(str)
	str = str.."\r\n"
	str = str..protocol_command.union_apply.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_apply.param_list
	return str
end




function command_union_init(str)
	str = str.."\r\n"
	str = str..protocol_command.union_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_init.param_list
	return str
end




function command_union_content_update(str)
	str = str.."\r\n"
	str = str..protocol_command.union_content_update.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_content_update.param_list
	return str
end





function command_union_password_update(str)
	str = str.."\r\n"
	str = str..protocol_command.union_password_update.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_password_update.param_list
	return str
end




function command_union_dismiss(str)
	str = str.."\r\n"
	str = str..protocol_command.union_dismiss.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_dismiss.param_list
	return str
end




function command_union_persion_list(str)
	str = str.."\r\n"
	str = str..protocol_command.union_persion_list.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_persion_list.param_list
	return str
end




function command_union_examine_list(str)
	str = str.."\r\n"
	str = str..protocol_command.union_examine_list.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_examine_list.param_list
	return str
end




function command_union_persion_manage(str)
	str = str.."\r\n"
	str = str..protocol_command.union_persion_manage.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_persion_manage.param_list
	return str
end




function command_union_appoint(str)
	str = str.."\r\n"
	str = str..protocol_command.union_appoint.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_appoint.param_list
	return str
end




function command_union_fight(str)
	str = str.."\r\n"
	str = str..protocol_command.union_fight.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_fight.param_list
	return str
end




function command_union_impeach(str)
	str = str.."\r\n"
	str = str..protocol_command.union_impeach.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_impeach.param_list
	return str
end





function command_union_exit(str)
	str = str.."\r\n"
	str = str..protocol_command.union_exit.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_exit.param_list
	return str
end




function command_union_message(str)
	str = str.."\r\n"
	str = str..protocol_command.union_message.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_message.param_list
	return str
end




function command_union_build(str)
	str = str.."\r\n"
	str = str..protocol_command.union_build.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_build.param_list
	return str
end




function command_temple_init(str)
	str = str.."\r\n"
	str = str..protocol_command.temple_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end




function command_temple_fete(str)
	str = str.."\r\n"
	str = str..protocol_command.temple_fete.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end




function command_union_shop_init(str)
	str = str.."\r\n"
	str = str..protocol_command.union_shop_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_shop_init.param_list
	return str
end




function command_union_shop_exchange(str)
	str = str.."\r\n"
	str = str..protocol_command.union_shop_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_shop_exchange.param_list
	return str
end




function command_union_upgrade(str)
	str = str.."\r\n"
	str = str..protocol_command.union_upgrade.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_upgrade.param_list
	return str
end




function command_union_counterpart_init(str)
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_init.param_list
	return str
end





function command_union_counterpart_team(str)
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_team.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_team.param_list
	return str
end




function command_union_counterpart_details(str)
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_details.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_details.param_list
	return str
end





function command_union_counterpart_organize(str)
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_organize.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_organize.param_list
	return str
end




function command_union_counterpart_add(str)
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_add.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_add.param_list
	return str
end




function command_union_counterpart_remove(str)
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_remove.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_remove.param_list
	return str
end




function command_union_counterpart_dismiss(str)
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_dismiss.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_dismiss.param_list
	return str
end




function command_union_counterpart_fight(str)
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_fight.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_fight.param_list
	return str
end



function command_union_counterpart_exit(str)
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_exit.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_exit.param_list
	return str
end



function command_union_counterpart_refush(str)
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_refush.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_refush.param_list
	return str
end




function command_union_counterpart_invite_list(str)
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_invite_list.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end




function command_union_counterpart_invite(str)
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_invite.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_counterpart_invite.param_list
	return str
end




function command_union_battleground_init(str)
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_init.param_list
	return str
end




function command_union_battleground_seize_info(str)
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_seize_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_seize_info.param_list
	return str
end




function command_union_battleground_apply(str)
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_apply.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_apply.param_list
	return str
end




function command_union_battleground_apply_count(str)
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_apply_count.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_apply_count.param_list
	return str
end




function command_union_battleground_apply_list(str)
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_apply_list.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_apply_list.param_list
	return str
end




function command_union_battleground_state(str)
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_state.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_state.param_list
	return str
end





function command_union_battleground_last_fights(str)
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_last_fights.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_last_fights.param_list
	return str
end




function command_union_battleground_apply_time(str)
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_apply_time.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_apply_time.param_list
	return str
end




function command_union_battleground_count_down(str)
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_count_down.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_count_down.param_list
	return str
end




function command_union_battleground_join(str)
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_join.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_join.param_list
	return str
end




function command_union_battleground_fight(str)
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_fight.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_fight.param_list
	return str
end




function command_union_battleground_inspire(str)
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_inspire.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_inspire.param_list
	return str
end




function command_union_battleground_add_victor(str)
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_add_victor.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_add_victor.param_list
	return str
end




function command_union_battleground_leave(str)
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_leave.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_leave.param_list
	return str
end




function command_union_battleground_refush(str)
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_refush.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_refush.param_list
	return str
end




function command_grab_init(str)
	str = str.."\r\n"
	str = str..protocol_command.grab_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.grab_init.param_list
	return str
end




function command_activity_superchange_exchange(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_superchange_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_superchange_exchange.param_list
	return str
end




function command_activity_subsection_discount_init(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_subsection_discount_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_subsection_discount_init.param_list
	return str
end




function command_activity_lucky_dial_init(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_lucky_dial_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_lucky_dial_init.param_list
	return str
end




function command_activity_lucky_dial_start(str)
	str = str.."\r\n"
	str = str..protocol_command.activity_lucky_dial_start.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.activity_lucky_dial_start.param_list
	return str
end




function command_union_battleground_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_battleground_reward.param_list
	return str
end





function command_get_environment_param(str)
	str = str.."\r\n"
	str = str..protocol_command.get_environment_param.command
	str = str.."\r\n"
	str = str..protocol_command.get_environment_param.param_list
	return str
end





function command_vali_platform_user(str)
	str = str.."\r\n"
	str = str..protocol_command.vali_platform_user.command
	str = str.."\r\n"
	str = str..protocol_command.vali_platform_user.param_list
	return str
end




function command_grab_launch_ten(str)
	str = str.."\r\n"
	str = str..protocol_command.grab_launch_ten.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.grab_launch_ten.param_list
	return str
end




function command_stride_dial_init(str)
	str = str.."\r\n"
	str = str..protocol_command.stride_dial_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.stride_dial_init.param_list
	return str
end





function command_stride_dial_start(str)
	str = str.."\r\n"
	str = str..protocol_command.stride_dial_start.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.stride_dial_start.param_list
	return str
end





function command_stride_dial_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.stride_dial_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.stride_dial_reward.param_list
	return str
end




function command_stride_dial_refush(str)
	str = str.."\r\n"
	str = str..protocol_command.stride_dial_refush.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.stride_dial_refush.param_list
	return str
end




function command_draw_month_card_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_month_card_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_month_card_reward.param_list
	return str
end




function command_greet_fortune(str)
	str = str.."\r\n"
	str = str..protocol_command.greet_fortune.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.greet_fortune.param_list
	return str
end




function command_fashion_escalate(str)
	str = str.."\r\n"
	str = str..protocol_command.fashion_escalate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fashion_escalate.param_list
	return str
end





function command_modify_nick_name(str)
	str = str.."\r\n"
	str = str..protocol_command.modify_nick_name.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.modify_nick_name.param_list
	return str
end





function command_study_event(str)
	str = str.."\r\n"
	str = str..protocol_command.study_event.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.study_event.param_list
	return str
end





function command_study_skill(str)
	str = str.."\r\n"
	str = str..protocol_command.study_skill.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.study_skill.param_list
	return str
end




function command_study_event_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.study_event_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.study_event_reward.param_list
	return str
end




function command_skill_adron(str)
	str = str.."\r\n"
	str = str..protocol_command.skill_adron.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.skill_adron.param_list
	return str
end





function command_power_make(str)
	str = str.."\r\n"
	str = str..protocol_command.power_make.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.power_make.param_list
	return str
end




function command_power_swallow(str)
	str = str.."\r\n"
	str = str..protocol_command.power_swallow.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.power_swallow.param_list
	return str
end




function command_power_sell(str)
	str = str.."\r\n"
	str = str..protocol_command.power_sell.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.power_sell.param_list
	return str
end




function command_power_take(str)
	str = str.."\r\n"
	str = str..protocol_command.power_take.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.power_take.param_list
	return str
end




function command_power_equip(str)
	str = str.."\r\n"
	str = str..protocol_command.power_equip.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.power_equip.param_list
	return str
end




function command_power_exchange(str)
	str = str.."\r\n"
	str = str..protocol_command.power_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.power_exchange.param_list
	return str
end




function command_buy_master_four(str)
	str = str.."\r\n"
	str = str..protocol_command.buy_master_four.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.buy_master_four.param_list
	return str
end




function command_power_operation(str)
	str = str.."\r\n"
	str = str..protocol_command.power_operation.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.power_operation.param_list
	return str
end



function command_equipment_limit_init(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_limit_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_limit_init.param_list
	return str
end



function command_equipment_limit_start(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_limit_start.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_limit_start.param_list
	return str
end



function command_draw_equipment_limit(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_equipment_limit.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_equipment_limit.param_list
	return str
end



function command_vali_platform_account(str)
	str = str.."\r\n"
	str = str..protocol_command.vali_platform_account.command
	str = str.."\r\n"
	str = str..app.configJson.OperatorName
	str = str.."\r\n"
	str = str..protocol_command.vali_platform_account.param_list
	return str
end