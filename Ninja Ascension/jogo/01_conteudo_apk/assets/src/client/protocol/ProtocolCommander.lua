require "client.protocol.ProtocolCommanderCopy" 
require "client.protocol.ProtocolCommanderCopyEx" 
require "client.protocol.ProtocolCommanderCopyExx"
require "client.protocol.ProtocolCommanderCopyExxx"
protocol_command = nil

-------------------------------------------------------------------------------------------------------
-- command_new_get_server_list	201
-------------------------------------------------------------------------------------------------------
local function command_new_get_server_list(str)--服务器地址列表接口（新）
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

-------------------------------------------------------------------------------------------------------
-- command_resource_update_after	202
-------------------------------------------------------------------------------------------------------
local function command_resource_update_after(str)--资源更新完成接口
	str = str.."\r\n"
	str = str..protocol_command.resource_update_after.command
	str = str.."\r\n"
	str = str..protocol_command.resource_update_after.param_list
	str = str.."\r\n"
	str = str..getPlatformParam()
	return str
end

-------------------------------------------------------------------------------------------------------
-- resource_mineral_init	203
-------------------------------------------------------------------------------------------------------
local function command_resource_mineral_init(str)--资源矿初始化接口
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_init.param_list
end

-------------------------------------------------------------------------------------------------------
-- resource_mineral_seize	204
-------------------------------------------------------------------------------------------------------
local function command_resource_mineral_seize(str)--资源矿占领接口
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_seize.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_seize.param_list
end

-------------------------------------------------------------------------------------------------------
-- resource_mineral_rob_helper	205
-------------------------------------------------------------------------------------------------------
local function command_resource_mineral_rob_helper(str)--资源矿抢夺协助者接口
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_rob_helper.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_rob_helper.param_list
end

-------------------------------------------------------------------------------------------------------
-- resource_mineral_find	206
-------------------------------------------------------------------------------------------------------
local function command_resource_mineral_find(str)--资源矿一键找矿接口
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_find.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_find.param_list
end

-------------------------------------------------------------------------------------------------------
-- resource_mineral_check_messgae	207
-------------------------------------------------------------------------------------------------------
local function command_resource_mineral_check_messgae(str)--资源矿查看抢夺信息
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_check_messgae.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end

-------------------------------------------------------------------------------------------------------
-- resource_mineral_give_up	208
-------------------------------------------------------------------------------------------------------
local function command_resource_mineral_give_up(str)--资源矿放弃占领
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_give_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.resource_mineral_give_up.param_list
end

-------------------------------------------------------------------------------------------------------
-- draw_month_sign_reward	209
-------------------------------------------------------------------------------------------------------
local function command_draw_month_sign_reward(str)--领取月签奖励
	str = str.."\r\n"
	str = str..protocol_command.draw_month_sign_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end

-------------------------------------------------------------------------------------------------------
-- glories_shop_init	210
-------------------------------------------------------------------------------------------------------
local function command_glories_shop_init(str)--荣誉商店初始化
	str = str.."\r\n"
	str = str..protocol_command.glories_shop_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-------------------------------------------------------------------------------------------------------
-- glories_shop_exchange	211
-------------------------------------------------------------------------------------------------------
local function command_glories_shop_exchange(str)--荣誉商店兑换
	str = str.."\r\n"
	str = str..protocol_command.glories_shop_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.glories_shop_exchange.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- draw_month_week_reward	212
-------------------------------------------------------------------------------------------------------
local function command_draw_month_week_reward(str)--领取周末签到奖励
	str = str.."\r\n"
	str = str..protocol_command.draw_month_week_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_month_week_reward.param_list
end

-------------------------------------------------------------------------------------------------------
-- spirite_palace_shop_init	213
-------------------------------------------------------------------------------------------------------
local function command_spirite_palace_shop_init(str)--灵王宫积分商店初始化
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_shop_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end

-------------------------------------------------------------------------------------------------------
-- spirite_palace_shop_exchange	214
-------------------------------------------------------------------------------------------------------
local function command_spirite_palace_shop_exchange(str)--灵王宫积分商店兑换
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_shop_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_shop_exchange.param_list
end

-------------------------------------------------------------------------------------------------------
-- spirite_palace_init	215
-------------------------------------------------------------------------------------------------------
local function command_spirite_palace_init(str)--灵王宫活动初始化
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end

-------------------------------------------------------------------------------------------------------
-- spirite_palace_choose_event	216
-------------------------------------------------------------------------------------------------------
local function command_spirite_palace_choose_event(str)--灵王宫活动选择事件
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_choose_event.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_choose_event.param_list
end

-------------------------------------------------------------------------------------------------------
-- spirite_palace_event_start	217
-------------------------------------------------------------------------------------------------------
local function command_spirite_palace_event_start(str)--灵王宫活动触发事件
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_event_start.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_event_start.param_list
end

-------------------------------------------------------------------------------------------------------
-- spirite_palace_reset	218
-------------------------------------------------------------------------------------------------------
local function command_spirite_palace_reset(str)--灵王宫重置
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_reset.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end

-------------------------------------------------------------------------------------------------------
-- spirite_palace_look_formation	219
-------------------------------------------------------------------------------------------------------
local function command_spirite_palace_look_formation(str)--灵王宫查看阵容
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_look_formation.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end

-------------------------------------------------------------------------------------------------------
-- spirite_palace_buy	220
-------------------------------------------------------------------------------------------------------
local function command_spirite_palace_buy(str)--灵王宫购买行动力和血槽
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_buy.param_list
end

-------------------------------------------------------------------------------------------------------
-- spirite_palace_auto_play	221
-------------------------------------------------------------------------------------------------------
local function command_spirite_palace_auto_play(str)--灵王宫自动探宝
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_auto_play.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end

-------------------------------------------------------------------------------------------------------
-- spirite_palace_cast_equipment	222
-------------------------------------------------------------------------------------------------------
local function command_spirite_palace_cast_equipment(str)--灵王宫橙装铸造
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_cast_equipment.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.spirite_palace_cast_equipment.param_list
end

-------------------------------------------------------------------------------------------------------
-- cross_server_fight_init	223
-------------------------------------------------------------------------------------------------------
local function command_cross_server_fight_init(str)--跨服争霸初始化
	str = str.."\r\n"
	str = str..protocol_command.cross_server_fight_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end

-------------------------------------------------------------------------------------------------------
-- cross_server_fight_apply	224
-------------------------------------------------------------------------------------------------------
local function command_cross_server_fight_apply(str)--跨服争霸报名
	str = str.."\r\n"
	str = str..protocol_command.cross_server_fight_apply.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end

-------------------------------------------------------------------------------------------------------
-- cross_server_join_game_init 225
-------------------------------------------------------------------------------------------------------
local function command_cross_server_join_game_init(str)--跨服争霸进入战场初始化
	str = str.."\r\n"
	str = str..protocol_command.cross_server_join_game_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_server_join_game_init.param_list
end

-------------------------------------------------------------------------------------------------------
-- cross_server_update_info	226
-------------------------------------------------------------------------------------------------------
local function command_cross_server_update_info(str)--跨服争霸更新战斗信息
	str = str.."\r\n"
	str = str..protocol_command.cross_server_update_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end

-------------------------------------------------------------------------------------------------------
-- cross_server_encourage 227
-------------------------------------------------------------------------------------------------------
local function command_cross_server_encourage(str)--跨服争霸助威
	str = str.."\r\n"
	str = str..protocol_command.cross_server_encourage.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_server_encourage.param_list
end

-------------------------------------------------------------------------------------------------------
-- cross_server_fight_record 228
-------------------------------------------------------------------------------------------------------
local function command_cross_server_fight_record(str)--跨服争霸查看战斗录像
	str = str.."\r\n"
	str = str..protocol_command.cross_server_fight_record.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_server_fight_record.param_list
end

-------------------------------------------------------------------------------------------------------
-- cross_server_self_info 229
-------------------------------------------------------------------------------------------------------
local function command_cross_server_self_info(str)--跨服争霸我的信息
	str = str.."\r\n"
	str = str..protocol_command.cross_server_self_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end

-------------------------------------------------------------------------------------------------------
-- cross_server_fight_record_list 230
-------------------------------------------------------------------------------------------------------
local function command_cross_server_fight_record_list(str)--跨服争霸晋级赛战斗录像列表
	str = str.."\r\n"
	str = str..protocol_command.cross_server_fight_record_list.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_server_fight_record_list.param_list
end

-------------------------------------------------------------------------------------------------------
-- cross_server_prostrate_init 231
-------------------------------------------------------------------------------------------------------
local function command_cross_server_prostrate_init(str)--跨服争霸膜拜冠军初始化
	str = str.."\r\n"
	str = str..protocol_command.cross_server_prostrate_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end

-------------------------------------------------------------------------------------------------------
-- cross_server_prostrate 232
-------------------------------------------------------------------------------------------------------
local function command_cross_server_prostrate(str)--跨服争霸膜拜冠军
	str = str.."\r\n"
	str = str..protocol_command.cross_server_prostrate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cross_server_prostrate.param_list
end

-------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------
-- secret_shopman_init 236
-------------------------------------------------------------------------------------------------------
local function command_secret_shopman_init(str)--神秘商人初始化
	str = str.."\r\n"
	str = str..protocol_command.secret_shopman_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
end


-------------------------------------------------------------------------------------------------------
-- three_kingdoms_init 237
-------------------------------------------------------------------------------------------------------
local function command_three_kingdoms_init(str)--三国无双初始化
	str = str.."\r\n"
	str = str..protocol_command.three_kingdoms_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-------------------------------------------------------------------------------------------------------
-- three_kingdoms_fight 238
-------------------------------------------------------------------------------------------------------
local function command_three_kingdoms_fight(str)--三国无双战斗
	str = str.."\r\n"
	str = str..protocol_command.three_kingdoms_fight.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.three_kingdoms_fight.param_list
	return str
end
-------------------------------------------------------------------------------------------------------
-- get_attribute 239
-------------------------------------------------------------------------------------------------------
local function command_get_attribute(str)--三国无双获得属性加成
	str = str.."\r\n"
	str = str..protocol_command.get_attribute.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_attribute.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- dignified_shop_buy 240
-------------------------------------------------------------------------------------------------------
local function command_dignified_shop_buy(str)--三国无双商店购买
	str = str.."\r\n"
	str = str..protocol_command.dignified_shop_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.dignified_shop_buy.param_list
	
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_equipment_refining 241
-------------------------------------------------------------------------------------------------------
local function command_equipment_refining(str)--装备精炼接口
	str = str.."\r\n"
	str = str..protocol_command.equipment_refining.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_refining.param_list
	
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_recycle_init 242
-------------------------------------------------------------------------------------------------------
local function command_recycle_init(str)--回收预览接口
	str = str.."\r\n"
	str = str..protocol_command.recycle_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.recycle_init.param_list
	
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_daily_instance 243
-------------------------------------------------------------------------------------------------------
local function command_daily_instance(str)--日常副本战斗接口
	str = str.."\r\n"
	str = str..protocol_command.daily_instance.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.daily_instance.param_list
	
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_cultivate_start 244
-------------------------------------------------------------------------------------------------------
local function command_cultivate_start(str)--武将培养开始接口
	str = str.."\r\n"
	str = str..protocol_command.cultivate_start.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cultivate_start.param_list
	
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_cultivate_replace 245
-------------------------------------------------------------------------------------------------------
local function command_cultivate_replace(str)--武将培养替换接口
	str = str.."\r\n"
	str = str..protocol_command.cultivate_replace.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cultivate_replace.param_list
	
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_manor_init 246
-------------------------------------------------------------------------------------------------------
local function command_manor_init(str)--领地攻讨初始化接口
	str = str.."\r\n"
	str = str..protocol_command.manor_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.manor_init.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_manor_occupy 247
-------------------------------------------------------------------------------------------------------
local function command_manor_fight(str)--领地攻讨占领接口
	str = str.."\r\n"
	str = str..protocol_command.manor_fight.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.manor_fight.param_list
	
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_manor_patrol 248
-------------------------------------------------------------------------------------------------------
local function command_manor_patrol(str)--领地巡逻接口
	str = str.."\r\n"
	str = str..protocol_command.manor_patrol.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.manor_patrol.param_list
	
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_manor_reward 249
-------------------------------------------------------------------------------------------------------
local function command_manor_reward(str)--领地奖励领取
	str = str.."\r\n"
	str = str..protocol_command.manor_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.manor_reward.param_list
	
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_manor_friend 250
-------------------------------------------------------------------------------------------------------
local function command_manor_friend(str)--领地好友信息
	str = str.."\r\n"
	str = str..protocol_command.manor_friend.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_manor_repress_rebellion 251
-------------------------------------------------------------------------------------------------------
local function command_manor_repress_rebellion(str)--领地镇压接口
	str = str.."\r\n"
	str = str..protocol_command.manor_repress_rebellion.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.manor_repress_rebellion.param_list
	
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_rebel_army_init 252
-------------------------------------------------------------------------------------------------------
local function command_rebel_army_init(str)--围剿叛军初始化接口
	str = str.."\r\n"
	str = str..protocol_command.rebel_army_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.rebel_army_init.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_rebel_army_exploit 253
-------------------------------------------------------------------------------------------------------
local function command_rebel_army_exploit(str)--每日功勋奖励领取
	str = str.."\r\n"
	str = str..protocol_command.rebel_army_exploit.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.rebel_army_exploit.param_list
	return str
end
	
-------------------------------------------------------------------------------------------------------
-- command_rebel_exploit_shop_init 254
-------------------------------------------------------------------------------------------------------
local function command_rebel_exploit_shop_init(str)--战功商店初始化
	str = str.."\r\n"
	str = str..protocol_command.rebel_exploit_shop_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.rebel_exploit_shop_init.param_list
	--> print("str ===========",str)
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_rebel_exploit_shop_exchange 255
-------------------------------------------------------------------------------------------------------
local function command_rebel_exploit_shop_exchange(str)--战功商店兑换
	str = str.."\r\n"
	str = str..protocol_command.rebel_exploit_shop_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.rebel_exploit_shop_exchange.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_draw_scene_rewad 256
-------------------------------------------------------------------------------------------------------
local function command_draw_scene_npc_rewad(str)--战功商店兑换
	str = str.."\r\n"
	str = str..protocol_command.draw_scene_npc_rewad.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_scene_npc_rewad.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_destiny_click 257
-------------------------------------------------------------------------------------------------------
local function command_destiny_click(str)--天命初始化
	str = str.."\r\n"
	str = str..protocol_command.destiny_click.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.destiny_click.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_daily_mission_init 258
-------------------------------------------------------------------------------------------------------
local function command_daily_mission_init(str)--日常任务初始化
	str = str.."\r\n"
	str = str..protocol_command.daily_mission_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.daily_mission_init.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_draw_daily_mission_reward 259
-------------------------------------------------------------------------------------------------------
local function command_draw_daily_mission_reward(str)--领取日常任务奖励
	str = str.."\r\n"
	str = str..protocol_command.draw_daily_mission_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_daily_mission_reward.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_draw_liveness_reward 260
-------------------------------------------------------------------------------------------------------
local function command_draw_liveness_reward(str)--领取日常任务宝箱接口
	str = str.."\r\n"
	str = str..protocol_command.draw_liveness_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_liveness_reward.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_server_fund_init 261
-------------------------------------------------------------------------------------------------------
local function command_server_fund_init(str)--全服基金初始化
	str = str.."\r\n"
	str = str..protocol_command.server_fund_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.server_fund_init.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_see_user_info 262
-------------------------------------------------------------------------------------------------------
local function command_see_user_info(str)
	str = str.."\r\n"
	str = str..protocol_command.see_user_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.see_user_info.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_pull_black 263		拉黑
-------------------------------------------------------------------------------------------------------
local function command_pull_black(str)
	str = str.."\r\n"
	str = str..protocol_command.pull_black.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pull_black.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_pull_black 264		领取成就奖励
-------------------------------------------------------------------------------------------------------
local function command_draw_achieve_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_achieve_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_achieve_reward.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_draw_server_fund 265		领取全服基金奖励
-------------------------------------------------------------------------------------------------------
local function command_draw_server_fund(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_server_fund.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_server_fund.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_draw_server_fund 266   查找好友请求接口
-------------------------------------------------------------------------------------------------------
local function command_search_friend_apply(str)
	str = str.."\r\n"
	str = str..protocol_command.search_friend_apply.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_dignified_shop_init 267  三国商店初始化
-------------------------------------------------------------------------------------------------------
local function command_dignified_shop_init(str)
	str = str.."\r\n"
	str = str..protocol_command.dignified_shop_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_week_active_init 268  七日活动初始化
-------------------------------------------------------------------------------------------------------
local function command_week_active_init(str)
	str = str.."\r\n"
	str = str..protocol_command.week_active_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.week_active_init.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_celebrity_bulletin_init 269  名人堂初始化
-------------------------------------------------------------------------------------------------------
local function command_celebrity_bulletin_init(str)
	str = str.."\r\n"
	str = str..protocol_command.celebrity_bulletin_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.celebrity_bulletin_init.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_celebrity_bulletin_support 270  名人堂点赞
-------------------------------------------------------------------------------------------------------
local function command_celebrity_bulletin_support(str)
	str = str.."\r\n"
	str = str..protocol_command.celebrity_bulletin_support.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.celebrity_bulletin_support.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_celebrity_leave_msg 271  名人堂留言接口
-------------------------------------------------------------------------------------------------------
local function command_celebrity_leave_msg(str)
	str = str.."\r\n"
	str = str..protocol_command.celebrity_leave_msg.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.celebrity_leave_msg.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_unparallel_purchase 272  无双秘籍购买
-------------------------------------------------------------------------------------------------------
local function command_unparallel_purchase(str)
	str = str.."\r\n"
	str = str..protocol_command.unparallel_purchase.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.unparallel_purchase.param_list
	return str
end


-------------------------------------------------------------------------------------------------------
-- command_unparallel_purchase 273  三国无双扫荡
-------------------------------------------------------------------------------------------------------
local function command_sweep_kingdoms(str)
	str = str.."\r\n"
	str = str..protocol_command.sweep_kingdoms.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_draw_week_reward 273  三国无双扫荡
-------------------------------------------------------------------------------------------------------
local function command_draw_week_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_week_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_week_reward.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_refush_msg 275  刷新聊天信息
-------------------------------------------------------------------------------------------------------
local function command_refush_msg(str)
	str = str.."\r\n"
	str = str..protocol_command.refush_msg.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_manor_user_init 277  领地事件刷新
-------------------------------------------------------------------------------------------------------
local function command_manor_user_init(str)
	str = str.."\r\n"
	str = str..protocol_command.manor_user_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.manor_user_init.param_list
	return str
end

-------------------------------------------------------------------------------------------------------
-- command_manor_user_init 278  移除黑名单
-------------------------------------------------------------------------------------------------------
local function command_remove_black(str)
	str = str.."\r\n"
	str = str..protocol_command.remove_black.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.remove_black.param_list
	return str
end


-------------------------------------------------------------------------------------------------------
-- command_refush_msg 279  腾讯查询余额
-------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
-- command_refush_msg 280  腾讯扣除游戏币
-------------------------------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-- command_rebel_army_fight 281  叛军战斗
-------------------------------------------------------------------------------------------------------
local function command_rebel_army_fight(str)
	str = str.."\r\n"
	str = str..protocol_command.rebel_army_fight.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.rebel_army_fight.param_list
	return str
end
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-- command_refush_rebel_army 282  叛军信息刷新
-------------------------------------------------------------------------------------------------------
local function command_refush_rebel_army(str)
	str = str.."\r\n"
	str = str..protocol_command.refush_rebel_army.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	-- str = str.."\r\n"
	-- str = str..protocol_command.refush_rebel_army.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_battle_field_init 284
-- -------------------------------------------------------------------------------------------------------
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


-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

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
	search_order_list={				code = 15,		command = "search_order_list",					command_fun = command_search_order_list, 				param_list=""}, -- 返回排行榜信息
	draw_scene_rewad={				code = 16,		command = "draw_scene_rewad",					command_fun = command_draw_scene_rewad, 				param_list=""},	-- 领取场景奖励
	trigger_scene_surprise={		code = 17,		command = "trigger_scene_surprise",				command_fun = command_trigger_scene_surprise, 			param_list=""},	-- 触发场景惊喜奖励
	ship_grow_up={					code = 18,		command = "ship_grow_up",						command_fun = command_ship_grow_up, 					param_list=""},	-- 英雄升阶
	battle_field_init={				code = 19,		command = "battle_field_init",					command_fun = command_battle_field_init, 				param_list=""},	-- 战场初始化
	prop_sell={ 					code = 20, 		command = "prop_sell", 							command_fun = command_prop_sell, 						param_list=""},	--道具出售
	view_ship_grow_up_additional={ 	code = 21, 		command = "view_ship_grow_up_additional", 		command_fun = command_view_ship_grow_up_additional, 	param_list=""},	--显示战船升阶附加属性
	prop_use={ 						code = 22, 		command = "prop_use", 							command_fun = command_prop_use, 						param_list=""},	--道具使用
	basic_consumption={ 			code = 23, 		command = "basic_consumption", 					command_fun = command_basic_consumption, 				param_list=""},	--基础消费
	equipment_sell={				code = 24, 		command = "equipment_sell", 					command_fun = command_equipment_sell, 					param_list=""},	--装备变卖接口
	equipment_escalate={			code = 25, 		command = "equipment_escalate", 				command_fun = command_equipment_escalate, 				param_list=""},	--装备强化
	prop_compound={					code = 26, 		command = "prop_compound", 						command_fun = command_prop_compound, 					param_list=""},	--道具合成
	ship_sell={						code = 27, 		command = "ship_sell", 							command_fun = command_ship_sell, 						param_list=""},	--船只变卖接口
	ship_batch_bounty={				code = 28, 		command = "ship_batch_bounty", 					command_fun = command_ship_batch_bounty, 				param_list=""},	--伙伴批量悬赏
	refusal_start={					code = 29, 		command = "refusal_start", 						command_fun = command_refusal_start, 					param_list=""},	--开始免战
	refresh_grab_list={				code = 30, 		command = "refresh_grab_list", 					command_fun = command_refresh_grab_list, 				param_list=""},	--刷新抢夺列表
	grab_launch={					code = 31, 		command = "grab_launch", 						command_fun = command_grab_launch, 						param_list=""},	--抢夺宝物碎片
	companion_change={				code = 32, 		command = "companion_change", 					command_fun = command_companion_change, 				param_list=""},	--小伙伴阵型变更
	ship_escalate={					code = 33, 		command = "ship_escalate", 						command_fun = command_ship_escalate, 					param_list=""},	--战船强化接口
	treasure_escalate={				code = 34, 		command = "treasure_escalate", 					command_fun = command_treasure_escalate, 				param_list=""},	--宝物强化
	get_activity_reward={			code = 35, 		command = "get_activity_reward", 				command_fun = command_get_activity_reward, 				param_list=""},	--领取活动奖励
	draw_online_reward={			code = 36, 		command = "draw_online_reward", 				command_fun = command_draw_online_reward,				param_list=""}, --在线时长奖励
	bounty_limit_init={				code = 37,		command = "bounty_limit_init", 					command_fun = command_bounty_limit_init,				param_list=""},	--限时神将初始化
	bounty_limit_start={			code = 38,		command = "bounty_limit_start",					command_fun = command_bounty_limit_start,				param_list=""},	--限时神将抽取
	dinner_init={			        code = 39,		command = "dinner_init",				    	command_fun = command_dinner_init,				        param_list=""},	--烧鸡初始化
	dinner_time={			        code = 40,		command = "dinner_time",				    	command_fun = command_dinner_time,				        param_list=""},	--吃烧鸡
	draw_bounty_limit_reward={		code = 41,		command = "draw_bounty_limit_reward",			command_fun = command_draw_bounty_limit_reward,			param_list=""},
	secret_shop_init={				code = 42,		command = "secret_shop_init",					command_fun = command_secret_shop_init,					param_list=""},
	secret_shop_refresh={			code = 43,		command = "secret_shop_refresh",				command_fun = command_secret_shop_refresh,				param_list=""},
	secret_shop_exchange={			code = 44,		command = "secret_shop_exchange",				command_fun	= command_secret_shop_exchange,				param_list=""},
	divine_init={			        code = 45,		command = "divine_init",				    	command_fun = command_divine_init,				        param_list=""},	--占星初始化
	divine_start={			        code = 46,		command = "divine_start",				    	command_fun = command_divine_start,				        param_list=""},	--占星开始
	divine_refresh={			    code = 47,		command = "divine_refresh",				    	command_fun = command_divine_refresh,				    param_list=""},	--占星刷新
	friend_update={			    	code = 48,		command = "friend_update",				    	command_fun = command_friend_update,				    param_list=""},	--好友列表更新接口
	email_init={					code = 49,		command = "email_init",				    		command_fun = command_email_init,				   		param_list=""},		--邮件初始化
	prop_purchase={					code = 50,		command = "prop_purchase",						command_fun = command_prop_purchase,					param_list=""},
	equipment_purchase={			code = 51,		command = "equipment_purchase",					command_fun = command_equipment_purchase,				param_list=""},
	equipment_onekey_adorn={		code = 52,		command = "equipment_onekey_adorn",				command_fun = command_equipment_onekey_adorn,			param_list=""},-- 一键装备
	draw_divine_reward={			code = 53,		command = "draw_divine_reward",					command_fun = command_draw_divine_reward,				param_list=""},-- 领取占星奖励
	random_user_list={			    code = 54,		command = "random_user_list",				    command_fun = command_random_user_list,				    param_list=""},	--好友请求接口
	present_endurance={			    code = 55,		command = "present_endurance",				    command_fun = command_present_endurance,			    param_list=""},	--赠送好友耐力接口
	attack_purchase={			    code = 56,		command = "attack_purchase",				    command_fun = command_attack_purchase,			   	 	param_list=""},	--购买攻击次数
	search_user={			    	code = 57,		command = "search_user",					    command_fun = command_search_user,			   	 		param_list=""},	--购买攻击次数
	refining={						code = 58, 		command = "refining",							command_fun = command_refining,							param_list=""},
	friend_msg={				    code = 59,		command = "friend_msg",						    command_fun = command_friend_msg,			  		    param_list=""},	--发送留言接口
	friend_del={				    code = 60,		command = "friend_del",						    command_fun = command_friend_del,			  		    param_list=""},	--删除好友接口
	friend_request={				code = 61,		command = "friend_request",						command_fun = command_friend_request,			  		param_list=""},	--好友请求接口
	draw_endurance_init={			code = 62,		command = "draw_endurance_init",				command_fun = command_draw_endurance_init,			  	param_list=""},	--领取耐力初始化接口
	draw_cdkey_reward={				code = 63,		command = "draw_cdkey_reward",					command_fun = command_draw_cdkey_reward,			  	param_list=""},	--Cdkey领取奖励
	draw_endurance={				code = 64,		command = "draw_endurance",						command_fun = command_draw_endurance,				  	param_list=""},	--领取耐力初始化接口
	friend_pass = {					code = 65,		command = "friend_pass",						command_fun = command_friend_pass,				  		param_list=""},	--好友请求通过接口
	get_system_notice = {			code = 66,		command = "get_system_notice",					command_fun = command_get_system_notice,		  		param_list=""},	--获得系统公告接口
	draw_vip_every_day_reward = {	code = 67,		command = "draw_vip_every_day_reward",			command_fun = command_draw_vip_every_day_reward,		param_list=""},	--领取每日vip奖励
	keep_alive = {					code = 68,		command = "keep_alive",							command_fun = command_keep_alive,						param_list=""}, --保活
	request_top_up_order_number = {	code = 69,		command = "request_top_up_order_number",		command_fun = command_request_top_up_order_number,		param_list=""}, --获取充值订单编号
	vali_top_up_order_number = {	code = 70,		command = "vali_top_up_order_number",			command_fun = command_vali_top_up_order_number,			param_list=""}, --查询充值订单编号
	vali_top_up_order_number7000 = {code = 7000,	command = "vali_top_up_order_number",			command_fun = command_vali_top_up_order_number7000,			param_list=""}, --查询充值订单编号7000
	arena_init = { 					code = 71, 		command = "arena_init",							command_fun = command_arena_init,						param_list=""}, --竞技场初始化
	arena_launch = {				code = 72,		command = "arena_launch",						command_fun	= command_arena_launch,						param_list=""},	--竞技场挑战发起
	arena_order = {					code = 73,		command = "arena_order",						command_fun = command_arena_order,						param_list=""}, --竞技场排行榜
	send_message = {				code = 74,		command = "send_message",						command_fun = command_send_message,						param_list=""}, --发送聊天信息
	gm_message_send = {				code = 75,		command = "gm_message_send",					command_fun = command_gm_message_send,					param_list=""}, --GM消息发送
	gm_message_init = {				code = 76,		command = "gm_message_init",					command_fun = command_gm_message_init,					param_list=""},	--GM消息初始
	arena_shop_init = {				code = 77,		command = "arena_shop_init",					command_fun = command_arena_shop_init,					param_list=""}, --竞技场商店初始化
	arena_shop_exchange = {			code = 78,		command = "arena_shop_exchange",				command_fun = command_arena_shop_exchange,				param_list=""},	--竞技场商店兑换
	look_at_user_fleet = {			code = 79,		command = "look_at_user_fleet",					command_fun = command_look_at_user_fleet,				param_list=""},	--查询用户舰队信息接口
	reward_center_init = {			code = 80,		command = "reward_center_init",					command_fun = command_reward_center_init,				param_list=""},	--奖励中心初始化
	arena_reward_draw = {			code = 81,		command = "arena_reward_draw",					command_fun = command_arena_reward_draw,				param_list=""},	--领取竞技场奖励
	draw_arena_lucky = {			code = 82,		command = "draw_arena_lucky",					command_fun = command_draw_arena_lucky,					param_list=""},	--领取竞技场幸运排名奖励
	draw_reward_center = {			code = 83,		command = "draw_reward_center",					command_fun = command_draw_reward_center,				param_list=""},	--领取奖励中心奖励
	destiny_init = {				code = 84,		command = "destiny_init",						command_fun = command_destiny_init,						param_list=""},	--天命初始化
	destiny_start = {				code = 85,		command = "destiny_start",						command_fun = command_destiny_start,					param_list=""}, --点亮天命
	favor_item_use = {				code = 86,		command = "favor_item_use",						command_fun = command_favor_item_use,					param_list=""},	--使用好感道具
	activate_app = {				code = 87,		command = "activate_app",						command_fun = command_activate_app,						param_list=""},	--激活应用
	education_change = {			code = 88,		command = "education_change",					command_fun = command_education_change,					param_list=""},	--事件进程记录
	record_crash = {				code = 89,		command = "record_crash",						command_fun = command_record_crash,						param_list=""},	--记录客户端崩溃日志
	equipment_rank_up = {			code = 90,		command = "equipment_rank_up",					command_fun = command_equipment_rank_up,				param_list=""},	--装备升阶
	get_resource = {				code = 91,		command = "get_resource",						command_fun = command_get_resource,						param_list=""},	--获得资源
	refining_equipment = {			code = 92,		command = "refining_equipment",					command_fun = command_refining_equipment,				param_list=""},
	refining_replace = {			code = 93,		command = "refining_replace",					command_fun = command_refining_replace,					param_list=""},
	draw_first_top_up_reward = {	code = 94,		command = "draw_first_top_up_reward",			command_fun = command_draw_first_top_up_reward,			param_list=""}, --领取首充奖励
	login_init_again = {			code = 95,		command = "login_init_again",					command_fun = command_login_init_again,					param_list=""},
	rebirth = {						code = 96,		command = "rebirth",							command_fun = command_rebirth,							param_list=""},--重生
	draw_bounty_limit = {			code = 97,		command = "draw_bounty_limit",					command_fun = command_draw_bounty_limit,				param_list=""},--领取限时神将奖励
	sweep = {						code = 98,		command = "sweep",								command_fun = command_sweep,							param_list=""},--扫荡接口
	clear_sweep_cd = {				code = 99,		command = "clear_sweep_cd",						command_fun = command_clear_sweep_cd,					param_list=""},--扫荡清除CD接口
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
	view_world_boss_reward = {		code = 113,		command = "view_world_boss_reward",				command_fun = command_view_world_boss_reward,			param_list=""},--查看世界boss奖励
	trans_tower_init = {			code = 114,		command = "trans_tower_init",					command_fun = command_trans_tower_init,					param_list=""},--试练塔初始化
	towel_launch = {				code = 115,		command = "towel_launch",						command_fun = command_towel_launch,						param_list=""},--试练塔战斗
	sweep_towel = {					code = 116,		command = "sweep_towel",						command_fun = command_sweep_towel,						param_list=""},--试练塔扫荡接口
	towel_reset = {					code = 117,		command = "towel_reset",						command_fun = command_towel_reset,						param_list=""},--试练塔重置接口
	ship_bounty_check = {			code = 118,		command = "ship_bounty_check",					command_fun = command_ship_bounty_check,				param_list=""},--招募验证
	system_time = {					code = 119,		command = "system_time",						command_fun = command_system_time,						param_list=""},--获取服务器系统时间
	user_sweep_rewards = {			code = 120,		command = "user_sweep_rewards",					command_fun = command_user_sweep_rewards,				param_list=""},--领取机械塔奖励
	refresh_grab_list_for_education = {			code = 121,		command = "refresh_grab_list_for_education",					command_fun = command_refresh_grab_list_for_education,				param_list=""},--教学刷新抢夺列表
	grab_launch_for_education = {	code = 122,		command = "grab_launch_for_education",			command_fun = command_grab_launch_for_education,		param_list=""},--教学抢夺宝物碎片
	union_create =	{				code = 123,		command = "union_create",						command_fun = command_union_create,						param_list=""},--公会创建
	union_list = 	{				code = 124,		command = "union_list",							command_fun = command_union_list,						param_list=""},--公会列表
	union_search = 	{				code = 125,		command = "union_search",						command_fun = command_union_search,						param_list=""},--公会搜索
	union_apply = 	{				code = 126,		command = "union_apply",						command_fun = command_union_apply,						param_list=""},--公会0申请/1取消
	union_init = 	{				code = 127,		command = "union_init",							command_fun = command_union_init,						param_list=""},--公会初始化
	union_content_update = 	{		code = 128,		command = "union_content_update",				command_fun = command_union_content_update,				param_list=""},--公会内容变更
	union_password_update = {		code = 129,		command = "union_password_update",				command_fun = command_union_password_update,			param_list=""},--公会密码更新
	union_dismiss = {				code = 130,		command = "union_dismiss",						command_fun = command_union_dismiss,					param_list=""},--公会解散
	union_persion_list = {			code = 131,		command = "union_persion_list",					command_fun = command_union_persion_list,				param_list=""},--公会成员列表
	union_examine_list = {			code = 132,		command = "union_examine_list",					command_fun = command_union_examine_list,				param_list=""},--公会审核列表
	union_persion_manage = {		code = 133,		command = "union_persion_manage",				command_fun = command_union_persion_manage,				param_list=""},--公会审核管理
	union_appoint = {				code = 134,		command = "union_appoint",						command_fun = command_union_appoint,					param_list=""},--公会成员管理
	union_fight = {					code = 135,		command = "union_fight",						command_fun = command_union_fight,						param_list=""},--公会成员切磋
	union_impeach = {				code = 136,		command = "union_impeach",						command_fun = command_union_impeach,					param_list=""},--公会弹劾
	union_exit= {					code = 137,		command = "union_exit",							command_fun = command_union_exit,						param_list=""},--公会退出
	union_message = {				code = 138,		command = "union_message",						command_fun = command_union_message,					param_list=""},--公会消息
	union_build = {					code = 139,		command = "union_build",						command_fun = command_union_build,						param_list=""},--公会建设
	temple_init= {					code = 140,		command = "temple_init",						command_fun = command_temple_init,						param_list=""},--公会祠堂初始化
	temple_fete = {					code = 141,		command = "temple_fete",						command_fun = command_temple_fete,						param_list=""},--公会祠堂参拜
	union_shop_init = {				code = 142,		command = "union_shop_init",					command_fun = command_union_shop_init,					param_list=""},--公会商品初始化
	union_shop_exchange = {			code = 143,		command = "union_shop_exchange",				command_fun = command_union_shop_exchange,				param_list=""},--公会商品兑换
	union_upgrade = {				code = 144,		command = "union_upgrade",						command_fun = command_union_upgrade,					param_list=""},--公会建筑升级
	union_counterpart_init = {		code = 145,		command = "union_counterpart_init",				command_fun = command_union_counterpart_init,			param_list=""},--公会军机大厅初始化
	union_counterpart_team = {		code = 146,		command = "union_counterpart_team",				command_fun = command_union_counterpart_team,			param_list=""},--公会军机大厅请求场景队伍数
	union_counterpart_details = {	code = 147,		command = "union_counterpart_details",			command_fun = command_union_counterpart_details,		param_list=""},--军团副本场景队伍列表
	union_counterpart_organize = {	code = 148,		command = "union_counterpart_organize",			command_fun = command_union_counterpart_organize,		param_list=""},--军团副本创建队伍
	union_counterpart_add = {		code = 149,		command = "union_counterpart_add",				command_fun = command_union_counterpart_add,			param_list=""},--军团副本队伍加入
	union_counterpart_remove = {	code = 150,		command = "union_counterpart_remove",			command_fun = command_union_counterpart_remove,			param_list=""},--军团队伍踢出人员
	union_counterpart_dismiss = {	code = 151,		command = "union_counterpart_dismiss",			command_fun = command_union_counterpart_dismiss,		param_list=""},--军团队伍解散
	union_counterpart_fight= {		code = 152,		command = "union_counterpart_fight",			command_fun = command_union_counterpart_fight,			param_list=""},--军团副本战斗
	union_counterpart_exit= {		code = 153,		command = "union_counterpart_exit",				command_fun = command_union_counterpart_exit,			param_list=""},--军团副本退出小队
	union_counterpart_refush= {		code = 154,		command = "union_counterpart_refush",			command_fun = command_union_counterpart_refush,			param_list=""},--军团副本刷新我的小队
	union_counterpart_invite_list= {code = 155,		command = "union_counterpart_invite_list",		command_fun = command_union_counterpart_invite_list,	param_list=""},--军团副本邀请列表请求接口
	union_counterpart_invite= {		code = 156,		command = "union_counterpart_invite",			command_fun = command_union_counterpart_invite, 		param_list=""},--军团副本邀请队员请求接口
	union_battleground_init= {		code = 157,		command = "union_battleground_init",			command_fun = command_union_battleground_init, 			param_list=""},--军团战场界面初始化
	union_battleground_seize_info= {code = 158,		command = "union_battleground_seize_info",		command_fun = command_union_battleground_seize_info, 	param_list=""},--军团战场据点(占领)信息
	union_battleground_apply= {		code = 159,		command = "union_battleground_apply",			command_fun = command_union_battleground_apply,			param_list=""},--军团战场据点申请
	union_battleground_apply_count= {code = 160,	command = "union_battleground_apply_count",		command_fun = command_union_battleground_apply_count, 	param_list=""},--军团战场据点还可以申请个数
	union_battleground_apply_list= {code = 161,		command = "union_battleground_apply_list",		command_fun = command_union_battleground_apply_list, 	param_list=""},--军团战场据点已经申请的列表数
	union_battleground_state= {		code = 162,		command = "union_battleground_state",			command_fun = command_union_battleground_state, 		param_list=""},--军团战场查看据点开战的战况
	union_battleground_last_fights= {code = 163,	command = "union_battleground_last_fights",		command_fun = command_union_battleground_last_fights, 	param_list=""},--军团战场查看据点上一次战况
	union_battleground_apply_time= {code = 164,		command = "union_battleground_apply_time",		command_fun = command_union_battleground_apply_time, 	param_list=""},--军团战场查看据点可报名时间
	union_battleground_count_down= {code = 165,		command = "union_battleground_count_down",		command_fun = command_union_battleground_count_down, 	param_list=""},--军团战场查看据点可战斗时间
	union_battleground_join= {		code = 166,		command = "union_battleground_join",			command_fun = command_union_battleground_join, 			param_list=""},--军团战场加入战场
	union_battleground_fight= {		code = 167,		command = "union_battleground_fight",			command_fun = command_union_battleground_fight, 		param_list=""},--军团战场进入战斗
	union_battleground_inspire= {	code = 168,		command = "union_battleground_inspire",			command_fun = command_union_battleground_inspire, 		param_list=""},--军团战场准备阶段的鼓舞
	union_battleground_add_victor= {code = 169,		command = "union_battleground_add_victor",		command_fun = command_union_battleground_add_victor, 	param_list=""},--军团战场准备阶段的连胜
	union_battleground_leave= {		code = 170,		command = "union_battleground_leave",			command_fun = command_union_battleground_leave, 		param_list=""},--军团战场离开战场
	union_battleground_refush= {	code = 171,		command = "union_battleground_refush",			command_fun = command_union_battleground_refush, 		param_list=""},--军团战场人员刷新
	grab_init= {					code = 172,		command = "grab_init",							command_fun = command_grab_init, 						param_list=""}, --抢夺初始化：
	activity_superchange_exchange= {code = 173,		command = "super_change",						command_fun = command_activity_superchange_exchange, 	param_list=""}, --超级变变变兑换协议
	activity_subsection_discount_init= {code = 174,	command = "subsection_discount_init",			command_fun = command_activity_subsection_discount_init, param_list=""}, --分段折扣初始化协议
	activity_lucky_dial_init= {		code = 175,		command = "lucky_dial_init",					command_fun = command_activity_lucky_dial_init, 		param_list=""}, --幸运大转盘初始化协议
	activity_lucky_dial_start= {	code = 176,		command = "lucky_dial_start",					command_fun = command_activity_lucky_dial_start, 		param_list=""}, --幸运大转盘抽取协议
	union_battleground_reward= {	code = 177,		command = "union_battleground_reward",			command_fun = command_union_battleground_reward, 		param_list=""}, --军团战场奖励领取
	get_environment_param= {		code = 178,		command = "get_environment_param",				command_fun = command_get_environment_param, 			param_list=""}, --获取服务器当前环境数据状态
	vali_platform_user= {			code = 179,		command = "vali_platform_user",					command_fun = command_vali_platform_user, 				param_list=""}, --校验平台用户	
	grab_launch_ten={				code = 180, 	command = "grab_launch_ten", 					command_fun = command_grab_launch_ten, 					param_list=""},	--抢夺十次宝物碎片
	stride_dial_init={				code = 181, 	command = "stride_dial_init", 					command_fun = command_stride_dial_init, 					param_list=""},	--跨服大转盘初始化协议
	stride_dial_start={				code = 182,     command = "stride_dial_start",					command_fun = command_stride_dial_start,				param_list=""},	--跨服大转盘抽取 协议
	stride_dial_reward={			code = 183,     command = "stride_dial_reward",					command_fun = command_stride_dial_reward,				param_list=""},	--跨服大转盘奖励
	stride_dial_refush={			code = 184,		command = "stride_dial_refush",					command_fun = command_stride_dial_refush,				param_list=""},	--跨服转盘刷新道具
	draw_month_card_reward={		code = 185,		command = "draw_month_card_reward",				command_fun = command_draw_month_card_reward,			param_list=""},	--月卡领取奖励请求
	greet_fortune={					code = 186,		command = "greet_fortune",						command_fun = command_greet_fortune,					param_list=""},	--迎财神抽取请求
	fashion_escalate={				code = 187,		command = "fashion_escalate",					command_fun = command_fashion_escalate,					param_list=""},	--时装强化请求
	modify_nick_name={				code = 188,		command = "modify_nick_name",					command_fun = command_modify_nick_name,					param_list=""}, --修改用户名称
	study_event={					code = 189,		command = "study_event",						command_fun = command_study_event,						param_list=""},--学艺事件
	study_skill={					code = 190,		command = "study_skill",						command_fun = command_study_skill,						param_list=""},--学习技能
	study_event_reward ={			code = 191,		command = "study_event_reward",					command_fun = command_study_event_reward,				param_list=""},--领取学艺技能奖励	
	skill_adron={					code = 192,     command = "skill_adron",						command_fun = command_skill_adron,						param_list=""},--替换技能
	power_make = {					code = 193,		command = "power_make" ,						command_fun = command_power_make,						param_list=""},--霸气产生
	power_swallow = {				code = 194,		command = "power_swallow",						command_fun = command_power_swallow,					param_list=""},--霸气吞噬
	power_sell = {					code = 195,		command = "power_sell",						    command_fun = command_power_sell,						param_list=""},--霸气出售
	power_take = {					code = 196,		command = "power_take",							command_fun = command_power_take,						param_list=""},--霸气拾取
	power_equip = {					code = 197,		command = "power_equip",						command_fun = command_power_equip,						param_list=""},--霸气装备
	power_exchange = {				code = 198,		command = "power_exchange",						command_fun = command_power_exchange,					param_list=""},--霸气的兑换
	buy_master_four ={				code = 199,		command = "buy_master_four",					command_fun = command_buy_master_four,					param_list=""},--直接开始第四个霸气师
    power_operation ={				code = 200,		command = "power_operation",					command_fun = command_power_operation,					param_list=""},--霸气一键装备
    new_get_server_list ={			code = 201,		command = "new_get_server_list",				command_fun = command_new_get_server_list,				param_list=""},--服务器地址列表接口（新）
    resource_update_after ={		code = 202,		command = "resource_update_after",				command_fun = command_resource_update_after,			param_list=""},--资源更新完成接口
	resource_mineral_init = {		code = 203,		command = "resource_mineral_init",				command_fun = command_resource_mineral_init,			param_list=""},--资源矿初始化接口
	resource_mineral_seize = {		code = 204,		command = "resource_mineral_seize",				command_fun = command_resource_mineral_seize,			param_list=""},--资源矿占领接口
	resource_mineral_rob_helper = {	code = 205,		command = "resource_mineral_rob_helper",		command_fun = command_resource_mineral_rob_helper,		param_list=""},--资源矿抢夺协助者接口
	resource_mineral_find = {		code = 206,		command = "resource_mineral_find",				command_fun = command_resource_mineral_find,			param_list=""},--资源矿一键找矿接口
	resource_mineral_check_messgae = {code = 207,	command = "resource_mineral_check_messgae", 	command_fun = command_resource_mineral_check_messgae, 	param_list=""},--资源矿查看抢夺信息
	resource_mineral_give_up = {	code = 208,		command = "resource_mineral_give_up", 			command_fun = command_resource_mineral_give_up, 		param_list=""},--资源矿放弃占领
	draw_month_sign_reward = {		code = 209,		command = "draw_month_sign_reward", 			command_fun = command_draw_month_sign_reward, 			param_list=""},--领取月签奖励
	glories_shop_init = {			code = 210,		command = "glories_shop_init", 					command_fun = command_glories_shop_init, 				param_list=""},--荣誉商店初始化
	glories_shop_exchange = {		code = 211,		command = "glories_shop_exchange", 				command_fun = command_glories_shop_exchange, 			param_list=""},--荣誉商店兑换
	draw_month_week_reward = {		code = 212,		command = "draw_month_week_reward",				command_fun = command_draw_month_week_reward,			param_list=""},--领取周末签到奖励
	spirite_palace_shop_init = {	code = 213,		command = "spirite_palace_shop_init",			command_fun = command_spirite_palace_shop_init,			param_list=""},--灵王宫积分商店初始化
	spirite_palace_shop_exchange = {code = 214,		command = "spirite_palace_shop_exchange",		command_fun = command_spirite_palace_shop_exchange,		param_list=""},--灵王宫积分商店兑换
	spirite_palace_init = {			code = 215,		command = "spirite_palace_init",				command_fun = command_spirite_palace_init,				param_list=""},--灵王宫活动初始化
	spirite_palace_choose_event = {	code = 216,		command = "spirite_palace_choose_event",		command_fun = command_spirite_palace_choose_event,		param_list=""},--灵王宫活动选择事件
	spirite_palace_event_start = {	code = 217,		command = "spirite_palace_event_start",			command_fun = command_spirite_palace_event_start,		param_list=""},--灵王宫活动触发事件
	spirite_palace_reset = {		code = 218,		command = "spirite_palace_reset",				command_fun = command_spirite_palace_reset,				param_list=""},--灵王宫重置
	spirite_palace_look_formation = {code = 219,	command = "spirite_palace_look_formation",		command_fun = command_spirite_palace_look_formation,	param_list=""},--灵王宫查看阵容
	spirite_palace_buy = {			code = 220,		command = "spirite_palace_buy",					command_fun = command_spirite_palace_buy,				param_list=""},--灵王宫购买行动力和血槽
	spirite_palace_auto_play = {	code = 221,		command = "spirite_palace_auto_play",			command_fun = command_spirite_palace_auto_play,			param_list=""},--灵王宫自动探宝
	spirite_palace_cast_equipment = {code = 222,	command = "spirite_palace_cast_equipment",		command_fun = command_spirite_palace_cast_equipment,	param_list=""},--灵王宫橙装铸造
	cross_server_fight_init = {		code = 223,		command = "cross_server_fight_init",			command_fun = command_cross_server_fight_init,			param_list=""},--跨服争霸初始化
	cross_server_fight_apply = {	code = 224,		command = "cross_server_fight_apply",			command_fun = command_cross_server_fight_apply,			param_list=""},--跨服争霸报名
	cross_server_join_game_init = {	code = 225,		command = "cross_server_join_game_init",		command_fun = command_cross_server_join_game_init,		param_list=""},--跨服争霸进入战场初始化
	cross_server_update_info = {	code = 226,		command = "cross_server_update_info",			command_fun = command_cross_server_update_info,			param_list=""},--跨服争霸更新战斗信息
	cross_server_encourage = {		code = 227,		command = "cross_server_encourage",				command_fun = command_cross_server_encourage,			param_list=""},--跨服争霸助威
	cross_server_fight_record = {	code = 228,		command = "cross_server_fight_record",			command_fun = command_cross_server_fight_record,		param_list=""},--跨服争霸查看战斗录像
	cross_server_self_info = {		code = 229,		command = "cross_server_self_info",				command_fun = command_cross_server_self_info,			param_list=""},--跨服争霸我的信息
	cross_server_fight_record_list = {code = 230,	command = "cross_server_fight_record_list",		command_fun = command_cross_server_fight_record_list,	param_list=""},--跨服争霸晋级赛战斗录像列表
	cross_server_prostrate_init = { code = 231,		command = "cross_server_prostrate_init",		command_fun = command_cross_server_prostrate_init,		param_list=""},--跨服争霸膜拜冠军初始化
	cross_server_prostrate = { 		code = 232,		command = "cross_server_prostrate",				command_fun = command_cross_server_prostrate,			param_list=""},--跨服争霸膜拜冠军
	equipment_limit_init = { 		code = 233,		command = "equipment_limit_init",				command_fun = command_equipment_limit_init,				param_list=""},--天降神兵初始化
	equipment_limit_start = { 		code = 234,		command = "equipment_limit_start",				command_fun = command_equipment_limit_start,			param_list=""},--天降神兵抽取
	draw_equipment_limit = { 		code = 235,	    command = "draw_equipment_limit",		        command_fun = command_draw_equipment_limit,		        param_list=""},--领取天降神兵奖励
	secret_shopman_init = { 		code = 236,	    command = "secret_shopman_init",		        command_fun = command_secret_shopman_init,		        param_list=""},--神秘商人初始化
	three_kingdoms_init = { 		code = 237,	    command = "three_kingdoms_init",		        command_fun = command_three_kingdoms_init,		        param_list=""},--三国无双初始化
	three_kingdoms_fight = { 		code = 238,	    command = "three_kingdoms_fight",		        command_fun = command_three_kingdoms_fight,		        param_list=""},--三国无双战斗
	get_attribute = { 				code = 239,	    command = "get_attribute",		        		command_fun = command_get_attribute,		        	param_list=""},--三国无双获得属性加成
	dignified_shop_buy = { 			code = 240,	    command = "dignified_shop_buy",		        	command_fun = command_dignified_shop_buy,		        param_list=""},--三国无双商店购买接口
	equipment_refining = { 			code = 241,	    command = "equipment_refining",		        	command_fun = command_equipment_refining,		        param_list=""},--装备精炼接口
	recycle_init = { 				code = 242,	    command = "recycle_init",		        		command_fun = command_recycle_init,		        		param_list=""},--回收预览接口
	daily_instance = { 				code = 243,	    command = "daily_instance",		        		command_fun = command_daily_instance,		       		param_list=""},--日常副本战斗接口
	cultivate_start = { 			code = 244,		command = "cultivate_start",		        	command_fun = command_cultivate_start,		       		param_list=""},--武将培养开始接口
	cultivate_replace = { 			code = 245,		command = "cultivate_replace",		        	command_fun = command_cultivate_replace,		       	param_list=""},--武将培养替换接口
	manor_init = { 					code = 246,		command = "manor_init",		        			command_fun = command_manor_init,		      		 	param_list=""},--领地攻讨初始化接口
	manor_fight = { 				code = 247,		command = "manor_fight",		       			command_fun = command_manor_fight,		      		 	param_list=""},--领地攻讨占领接口
	manor_patrol = { 				code = 248,		command = "manor_patrol",		       			command_fun = command_manor_patrol,		      		 	param_list=""},--领地攻讨巡逻接口
	manor_reward = { 				code = 249,		command = "manor_reward",		       			command_fun = command_manor_reward,		      		 	param_list=""},--领地攻讨奖励领取接口
	manor_friend = { 				code = 250,		command = "manor_friend",		       			command_fun = command_manor_friend,		      		 	param_list=""},--领地攻讨好友信息接口
	manor_repress_rebellion = { 	code = 251,		command = "manor_repress_rebellion",		    command_fun = command_manor_repress_rebellion,		    param_list=""},--领地攻讨镇压接口
	rebel_army_init = { 			code = 252,		command = "rebel_army_init",		        	command_fun = command_rebel_army_init,		      	 	param_list=""},--围剿叛军初始化接口
	rebel_army_exploit = { 			code = 253,		command = "rebel_army_exploit",		        	command_fun = command_rebel_army_exploit,		      	param_list=""},--每日功勋奖励领取
	rebel_exploit_shop_init = { 	code = 254,		command = "rebel_exploit_shop_init",		    command_fun = command_rebel_exploit_shop_init,		   	param_list=""},--战功商店初始化
	rebel_exploit_shop_exchange = { code = 255,		command = "rebel_exploit_shop_exchange",		command_fun = command_rebel_exploit_shop_exchange,		param_list=""},--战功商店兑换
	draw_scene_npc_rewad = { 		code = 256,		command = "draw_scene_npc_rewad",				command_fun = command_draw_scene_npc_rewad,				param_list=""},--领取NPC宝箱奖励
	destiny_click = { 				code = 257,		command = "destiny_click",						command_fun = command_destiny_click,					param_list=""},--天命
	daily_mission_init = { 			code = 258,		command = "daily_mission_init",					command_fun = command_daily_mission_init,				param_list=""},--日常任务初始化
	draw_daily_mission_reward = { 	code = 259,		command = "draw_daily_mission_reward",			command_fun = command_draw_daily_mission_reward,		param_list=""},--领取日常任务奖励
	draw_liveness_reward = { 		code = 260,		command = "draw_liveness_reward",				command_fun = command_draw_liveness_reward,				param_list=""},--领取日常任务宝箱接口
	server_fund_init = { 			code = 261,		command = "server_fund_init",					command_fun = command_server_fund_init,					param_list=""},--全服基金初始化
	see_user_info = { 				code = 262,		command = "see_user_info",						command_fun = command_see_user_info,					param_list=""},--查看人员信息
	pull_black = { 					code = 263,		command = "pull_black",							command_fun = command_pull_black,						param_list=""},--拉黑
	draw_achieve_reward = { 		code = 264,		command = "draw_achieve_reward",				command_fun = command_draw_achieve_reward,				param_list=""},--领取成就奖励
	draw_server_fund = { 			code = 265,		command = "draw_server_fund",					command_fun = command_draw_server_fund,					param_list=""},--领取全服基金奖励
	search_friend_apply = { 		code = 266,		command = "search_friend_apply",				command_fun = command_search_friend_apply,				param_list=""},--查找好友请求
	dignified_shop_init = { 		code = 267,		command = "dignified_shop_init",				command_fun = command_dignified_shop_init,				param_list=""},--三国商店初始化
	week_active_init = { 			code = 268,		command = "week_active_init",					command_fun = command_week_active_init,					param_list=""},--七日活动初始化
	celebrity_bulletin_init = { 	code = 269,		command = "celebrity_bulletin_init",			command_fun = command_celebrity_bulletin_init,			param_list=""},--名人堂初始化
	celebrity_bulletin_support = { 	code = 270,		command = "celebrity_bulletin_support",			command_fun = command_celebrity_bulletin_support,		param_list=""},--名人堂点赞接口
	celebrity_leave_msg = { 		code = 271,		command = "celebrity_leave_msg",				command_fun = command_celebrity_leave_msg,				param_list=""},--名人堂留言
	unparallel_purchase = { 		code = 272,		command = "unparallel_purchase",				command_fun = command_unparallel_purchase,				param_list=""},--无双秘籍购买
	sweep_kingdoms = { 				code = 273,		command = "sweep_kingdoms",						command_fun = command_sweep_kingdoms,					param_list=""},--三国无双扫荡
	draw_week_reward = { 			code = 274,		command = "draw_week_reward",					command_fun = command_draw_week_reward,					param_list=""},--领取七日活动奖励
	vali_platform_account = { 		code = 275,		command = "vali_platform_account",				command_fun = command_vali_platform_account,			param_list=""},--教验渠道用户名
	refush_msg = { 					code = 276,		command = "refush_msg",							command_fun = command_refush_msg,						param_list=""},--刷新聊天信息
	manor_user_init = { 			code = 277,		command = "manor_user_init",					command_fun = command_manor_user_init,					param_list=""},--领地事件刷新
	remove_black = { 				code = 278,		command = "remove_black",						command_fun = command_remove_black,						param_list=""},--移除黑名单
	tencent_balance = { 			code = 279,		command = "tencent_balance",					command_fun = command_tencent_balance,					param_list=""},--腾讯查询余额
	tencent_pay = { 				code = 280,		command = "tencent_pay",						command_fun = command_tencent_pay,						param_list=""},--腾讯扣除游戏币
	rebel_army_fight = { 			code = 281,		command = "rebel_army_fight",					command_fun = command_rebel_army_fight,					param_list=""},--叛军请求战斗
	refush_rebel_army = { 			code = 282,		command = "refush_rebel_army",					command_fun = command_refush_rebel_army,				param_list=""},--刷新叛军信息
	camp_preference = { 			code = 283,		command = "camp_preference",					command_fun = command_camp_preference, 					param_list=""},-- 向性请求接口
	battle_result_verify={			code = 284,		command = "battle_result_verify",				command_fun = command_battle_result_verify, 			param_list=""},	-- [超神]本地战斗结果验证
	draw_morrow_reward={			code = 285,		command = "draw_morrow_reward",					command_fun = command_draw_morrow_reward, 				param_list=""},	-- 次日活动领取
	rebel_army_share={				code = 286,		command = "rebel_army_share",					command_fun = command_rebel_army_share, 				param_list=""},	-- 叛军分享接口
	black_shop_init={				code = 287,		command = "black_shop_init",					command_fun = command_black_shop_init, 					param_list=""},	-- 黑市初始化
	black_shop_refush={				code = 288,		command = "black_shop_refush",					command_fun = command_black_shop_refush, 				param_list=""},	-- 黑市刷新
	black_shop_exchange={			code = 289,		command = "black_shop_exchange",				command_fun = command_black_shop_exchange, 				param_list=""},	-- 黑市兑换
	draw_black_shop_reward={		code = 290,		command = "draw_black_shop_reward",				command_fun = command_draw_black_shop_reward, 			param_list=""},	-- 黑市领取订单奖励
	on_hook={						code = 291,		command = "on_hook",							command_fun = command_on_hook, 							param_list=""},	-- 通知挂机接口
	refush_on_hook={				code = 292,		command = "refush_on_hook",						command_fun = command_refush_on_hook, 					param_list=""},	-- 刷新挂机接口
	draw_on_hook_reward={			code = 293,		command = "draw_on_hook_reward",				command_fun = command_draw_on_hook_reward, 				param_list=""},	-- 领取挂机宝箱接口
	arena_init2={					code = 294,		command = "arena_init2",						command_fun = command_arena_init2, 						param_list=""},	-- 竞技场初始化2
	mineral_init={					code = 295,		command = "mineral_init",						command_fun = command_mineral_init, 					param_list=""},	-- 获取矿区信息接口
	mineral_explore={				code = 296,		command = "mineral_explore",					command_fun = command_mineral_explore, 					param_list=""},	-- 探索矿区接口
	mineral_pick={					code = 297,		command = "mineral_pick",						command_fun = command_mineral_pick, 					param_list=""},	-- 捡起矿资源接口
	mineral_new_project={			code = 298,		command = "mineral_new_project",				command_fun = command_mineral_new_project, 				param_list=""},	-- 新建矿区工坊接口
	mineral_reward_gain={			code = 299,		command = "mineral_reward_gain",				command_fun = command_mineral_reward_gain, 				param_list=""},	-- 领取工坊奖励接口
	mineral_workspace_init={		code = 300,		command = "mineral_workspace_init",				command_fun = command_mineral_workspace_init, 			param_list=""},	-- 获取工坊信息接口
	mineral_workspace_add={			code = 301,		command = "mineral_workspace_add",				command_fun = command_mineral_workspace_add, 			param_list=""},	-- 增加工坊数量接口
	strategy_list={					code = 302,		command = "strategy_list",						command_fun = command_strategy_list, 					param_list=""},	-- 获取攻略列表
	strategy_add={					code = 303,		command = "strategy_add",						command_fun = command_strategy_add, 					param_list=""},	-- 发表攻略
	strategy_favor={				code = 304,		command = "strategy_favor",						command_fun = command_strategy_favor, 					param_list=""},	-- 攻略点赞
	mineral_reset={					code = 305,		command = "mineral_reset",						command_fun = command_mineral_reset, 					param_list=""},	-- 重置资源矿
	show_self_message={				code = 306,		command = "show_self_message",					command_fun = command_show_self_message, 				param_list=""},	-- 查看自身当天发布信息
	reply_message={					code = 307,		command = "reply_message",						command_fun = command_reply_message, 					param_list=""},	-- 回复信息
	show_reply_message={			code = 308,		command = "show_reply_message",					command_fun = command_show_reply_message, 				param_list=""},	-- 查看回复信息
	on_hook_init={					code = 309,		command = "on_hook_init",						command_fun = command_on_hook_init, 					param_list=""},	-- 挂机初始化
	show_ship_mould_list={			code = 310,		command = "show_ship_mould_list",				command_fun = command_show_ship_mould_list, 			param_list=""},	-- 请求图鉴
	mineral_add_workspace={			code = 311,		command = "mineral_add_workspace",				command_fun = command_mineral_add_workspace, 			param_list=""},	-- 请求新的矿工工坊
	get_mineral_prop_list={			code = 312,		command = "get_mineral_prop_list",				command_fun = command_get_mineral_prop_list, 			param_list=""},	-- 请求矿工包或矿石物品
	user_combat_force_order_reward_init={			code = 313,		command = "user_combat_force_order_reward_init",		command_fun = command_user_combat_force_order_reward_init, 				param_list=""},	-- 排行榜活动初始化
	sky_temple_init={				code = 314,		command = "sky_temple_init",					command_fun = command_sky_temple_init, 					param_list=""},	-- 请求天空神殿
	sky_temple_exchange={			code = 315,		command = "sky_temple_exchange",				command_fun = command_sky_temple_exchange, 				param_list=""},	-- 请求天空神殿兑换
	ship_destiny_strength={			code = 316,		command = "ship_destiny_strength",				command_fun = command_ship_destiny_strength, 			param_list=""},	-- 宿命强化请求
	ship_limit_break={				code = 317,		command = "ship_limit_break",					command_fun = command_ship_limit_break, 				param_list=""},	-- 界限突破请求
	ship_equip_strength={			code = 318,		command = "ship_equip_strength",				command_fun = command_ship_equip_strength, 				param_list=""},	-- 武具强化请求
	ship_train={					code = 319,		command = "ship_train",							command_fun = command_ship_train, 						param_list=""},	-- 宝具锻造请求
	switch_equipment={				code = 320,		command = "switch_equipment",					command_fun = command_switch_equipment, 				param_list=""},	-- 切换宿命武器请求
	daily_instance_verify={			code = 321,		command = "daily_instance_verify",				command_fun = command_daily_instance_verify, 			param_list=""},	-- 日常副本效验结算
	ship_transfer={					code = 322,		command = "ship_transfer",						command_fun = command_ship_transfer, 					param_list=""},	-- 灵力转移请求
	arena_launch2={					code = 323,		command = "arena_launch2",						command_fun = command_arena_launch2, 					param_list=""},	-- 竞技场战斗请求
	arena2_refush={					code = 324,		command = "arena2_refush",						command_fun = command_arena2_refush, 					param_list=""},	-- 竞技场重置
	ship_purchase={					code = 325,		command = "ship_purchase",						command_fun = command_ship_purchase, 					param_list=""},	-- 灵魂召唤请求
	formation_exchange={			code = 326,		command = "formation_exchange",					command_fun = command_formation_exchange, 				param_list=""},	-- 阵型换位请求
	mine_fight_launch={				code = 327,		command = "mine_fight_launch",					command_fun = command_mine_fight_launch, 				param_list=""},	-- 矿区战斗请求
	battle_result_start={			code = 328,		command = "battle_result_start",				command_fun = command_battle_result_start, 				param_list=""},	-- 通知进入战斗
	draw_union_liveness_reward={    code = 329,		command = "draw_union_liveness_reward",			command_fun = command_draw_union_liveness_reward, 		param_list=""},	-- 领取工会祭天积分宝箱
	unino_pic_frame_exchange={		code = 330,		command = "unino_pic_frame_exchange",		 	command_fun = command_unino_pic_frame_exchange, 		param_list=""},	-- 修改军团图标
	set_accept_friend_request={		code = 331,		command = "set_accept_friend_request",		 	command_fun = command_set_accept_friend_request, 		param_list=""},	-- 设置是否接受好友申请
	union_pve_init={				code = 332,		command = "union_pve_init",						command_fun = command_union_pve_init,					param_list=""},	-- 请求初始化军团副本界面
	draw_union_scene_reward={		code = 333,		command = "draw_union_scene_reward",			command_fun = command_draw_union_scene_reward,			param_list=""}, -- 请求领取通关奖励
	partner_bounty_init = {			code = 334,		command = "partner_bounty_init",				command_fun = command_partner_bounty_init,				param_list=""}, -- 请求阵营招募初始化
	partner_bounty_get = {			code = 335,		command = "partner_bounty_get",					command_fun = command_partner_bounty_get,				param_list=""}, -- 请求阵营招募抽取
	partner_bounty_get_reward = {	code = 336,		command = "partner_bounty_get_reward",			command_fun = command_partner_bounty_get_reward,		param_list=""}, -- 请求阵营招募积分兑奖
	random_event_launch = 		{	code = 337,		command = "random_event_launch",				command_fun = command_random_event_launch,				param_list=""}, -- 请求随机事件
	random_event_close = {			code = 338,		command = "random_event_close",					command_fun = command_random_event_close,				param_list=""}, -- 请求关闭随机事件
	random_event_refresh = {		code = 339,		command = "random_event_refresh",				command_fun = command_random_event_refresh,				param_list=""}, -- 请求随机事件刷新
	share_reward_init = {			code = 340,		command = "share_reward_init",					command_fun = command_share_reward_init,				param_list=""}, -- 请求初始化分享信息
	share_reward = {				code = 341,		command = "share_reward",						command_fun = command_share_reward,						param_list=""}, -- 请求领取分享奖励
	share_game = {					code = 342,		command = "share_game",							command_fun = command_share_game,						param_list=""}, -- 请求领取分享奖励
	random_event_open = {			code = 343,		command = "random_event_open",					command_fun = command_random_event_open,				param_list=""}, -- 请求打开随机事件
	mineral_reward_gain_all = {		code = 344,		command = "mineral_reward_gain_all",			command_fun = command_mineral_reward_gain_all,			param_list=""}, -- 请求获取矿区所有工程奖励
	bomb_purchase =           {		code = 345,		command = "bomb_purchase",				        command_fun = command_bomb_purchase,			        param_list=""}, -- 请求购买炸弹
	ship_comment_init ={			code = 346,		command = "ship_comment_init",				    command_fun = command_ship_comment_init,			    param_list=""}, -- 请求佣兵评论初始化
	ship_comment_content ={			code = 347,		command = "ship_comment_content",				command_fun = command_ship_comment_content,			    param_list=""}, -- 查看佣兵评论内容
	ship_comment_add ={				code = 348,		command = "ship_comment_add",				    command_fun = command_ship_comment_add,			    	param_list=""}, -- 添加佣兵评论
	ship_comment_favour ={			code = 349,		command = "ship_comment_favour",				command_fun = command_ship_comment_favour,				param_list=""}, -- 佣兵评论点赞
	reply_grade ={					code = 350,		command = "reply_grade",						command_fun = command_reply_grade,						param_list=""}, -- 评分通知接口
	mine_event_launch ={			code = 351,		command = "mine_event_launch",					command_fun = command_mine_event_launch,				param_list=""}, -- 矿区NPC战斗
	mine_boss_launch ={				code = 352,		command = "mine_boss_launch",					command_fun = command_mine_boss_launch,					param_list=""}, -- 矿区Boss战斗
	mine_monster_reset={			code = 353,		command = "mine_monster_reset",					command_fun = command_mine_monster_reset,				param_list=""}, -- 请求重置矿区杂兵
	map_scattered_init={			code = 354,		command = "map_scattered_init",					command_fun = command_map_scattered_init,				param_list=""}, -- 初始化地图分布
	map_init={						code = 355,		command = "map_init",							command_fun = command_map_init,							param_list=""}, -- 初始化地图信息
	self_grab_land_init={			code = 356,		command = "self_grab_land_init",				command_fun = command_self_grab_land_init,				param_list=""}, -- 初始化个人占领信息接口
	hold_build={					code = 357,		command = "hold_build",							command_fun = command_hold_build,						param_list=""}, -- 占领接口
	hold_view={						code = 358,		command = "hold_view",							command_fun = command_hold_view,						param_list=""}, -- 占领效验
	hold_extend={					code = 359,		command = "hold_extend",						command_fun = command_hold_extend,						param_list=""}, -- 延长占领
	hold_drop={						code = 360,		command = "hold_drop",							command_fun = command_hold_drop,						param_list=""}, -- 放弃占领
	hold_drop_efficacy={			code = 361,		command = "hold_drop_efficacy",					command_fun = command_hold_drop_efficacy,				param_list=""}, -- 效验放弃占领奖励
	marquee_init={					code = 362,		command = "marquee_init",						command_fun = command_marquee_init,						param_list=""}, -- GM消息
	cast_soul_stone={				code = 363,		command = "cast_soul_stone",					command_fun = command_cast_soul_stone,					param_list=""}, -- 合成灵魂石
	make_contract={					code = 364,		command = "make_contract",						command_fun = command_make_contract,					param_list=""}, -- 签订契约
	rush_four_attribute={			code = 365,		command = "rush_four_attribute",				command_fun = command_rush_four_attribute,				param_list=""}, -- 刷新四维属性
	warcraft_info_init={			code = 366,		command = "warcraft_info_init",					command_fun = command_warcraft_info_init,				param_list=""}, -- 排位赛信息初始化请求
	warcraft_fight={				code = 367,		command = "warcraft_fight",						command_fun = command_warcraft_fight,					param_list=""}, -- 排位赛战斗请求
	warcraft_get_reward={			code = 368,		command = "warcraft_get_reward",				command_fun = command_warcraft_get_reward,				param_list=""}, -- 排位赛奖励领取请求
	warcraft_shop_init={			code = 369,		command = "warcraft_shop_init",					command_fun = command_warcraft_shop_init,				param_list=""}, -- 排位赛商店初始化请求
	warcraft_shop_buy={				code = 370,		command = "warcraft_shop_buy",					command_fun = command_warcraft_shop_buy	,				param_list=""}, -- 排位赛商店购买请求
	warcraft_show_rank_list={		code = 371,		command = "warcraft_show_rank_list",			command_fun = command_warcraft_show_rank_list,			param_list=""}, -- 排位赛查看排行版请求
	warcraft_rush_fighter={			code = 372,		command = "warcraft_rush_fighter",				command_fun = command_warcraft_rush_fighter,			param_list=""}, -- 排位赛对手刷新
	warcraft_buy_fight_count={		code = 373,		command = "warcraft_buy_fight_count",			command_fun = command_warcraft_buy_fight_count,			param_list=""}, -- 排位赛挑战次数
	warcraft_see_user_formation={	code = 374,		command = "warcraft_see_user_formation",		command_fun = command_warcraft_see_user_formation,		param_list=""}, -- 查看排位赛玩家阵型
	switch_formation={				code = 375,		command = "switch_formation",					command_fun = command_switch_formation,					param_list=""}, -- 确定出战阵型ID
	draw_win_count_reward={			code = 376,		command = "draw_win_count_reward",				command_fun = command_draw_win_count_reward,			param_list=""}, -- 领取连胜奖励
	buy_fourth_formation={			code = 377,		command = "buy_fourth_formation",				command_fun = command_buy_fourth_formation,				param_list=""}, -- 购买阵型4
	ship_one_key_escalate ={		code = 378,		command = "ship_one_key_escalate",				command_fun = command_ship_one_key_escalate,			param_list=""}, -- 一键升级人物
	equipment_one_key_escalate ={	code = 379,		command = "equipment_one_key_escalate",			command_fun = command_equipment_one_key_escalate,		param_list=""}, -- 一键升级装备
	one_key_draw_reward ={			code = 380,		command = "one_key_draw_reward",			    command_fun = command_one_key_draw_reward,				param_list=""}, -- 一键领取场景奖励
	draw_hold_integral_reward = {	code = 381,		command = "draw_hold_integral_reward",			command_fun = command_draw_hold_integral_reward,		param_list=""}, -- 领取占领排行奖励
	hold_integral_init = {			code = 382,		command = "hold_integral_init",					command_fun = command_hold_integral_init,				param_list=""}, -- 占领中自己的积分排行，奖励领取状态
	unino_formation_menber_list = {	code = 383,		command = "unino_formation_menber_list",		command_fun = command_unino_formation_menber_list,		param_list=""}, -- 请求公会战布阵成员列表
	unino_set_formation = {			code = 384,		command = "unino_set_formation",				command_fun = command_unino_set_formation,				param_list=""}, -- 请求公会战布阵
	unino_fight_apply = {			code = 385,		command = "unino_fight_apply",					command_fun = command_unino_fight_apply,				param_list=""}, -- 请求报名公会战
	unino_fight_init = {			code = 386,		command = "unino_fight_init",					command_fun = command_unino_fight_init,					param_list=""}, -- 请求公会初始化
	unino_fight = {					code = 387,		command = "unino_fight",						command_fun = command_unino_fight,						param_list=""}, -- 请求公会战
	unino_map_refush = {			code = 388,		command = "unino_map_refush",					command_fun = command_unino_map_refush,					param_list=""}, -- 请求公会战推送
	unino_message_refush = {		code = 389,		command = "unino_message_refush",				command_fun = command_unino_message_refush,				param_list=""}, -- 请求公会战刷新
	draw_union_campsite_reward = {	code = 390,		command = "draw_union_campsite_reward",			command_fun = command_draw_union_campsite_reward,		param_list=""}, -- 领取公会战建筑奖励
	refush_cache_message = {		code = 391,		command = "refush_cache_message",				command_fun = command_refush_cache_message,				param_list=""}, -- 刷新工会缓存数据
	fortune = 					{	code = 392,		command = "fortune",							command_fun = command_fortune,							param_list=""}, -- 迎财神
	manor_double_reward = 		{	code = 393,		command = "manor_double_reward",				command_fun = command_manor_double_reward,				param_list=""}, -- 巡逻双倍奖励
	warcraft_info_refrush = 	{	code = 394,		command = "warcraft_info_refrush",				command_fun = command_warcraft_info_refrush,			param_list=""}, -- 报名排位赛
	magic_trap_formation_change = {	code = 395,		command = "magic_trap_formation_change",		command_fun = command_magic_trap_formation_change,		param_list=""}, -- 魔陷卡布阵
	magic_trap_formation_clear = {	code = 396,		command = "magic_trap_formation_clear",			command_fun = command_magic_trap_formation_clear,		param_list=""}, -- 清除魔陷卡
	awaken_shop_init = 			{	code = 397,		command = "awaken_shop_init",					command_fun = command_awaken_shop_init,					param_list=""}, -- 覺醒商店初始化
	awaken_shop_exchange = 		{	code = 398,		command = "awaken_shop_exchange",				command_fun = command_awaken_shop_exchange,				param_list=""}, -- 覺醒商店購買
	awaken_shop_refresh = 		{	code = 399,		command = "awaken_shop_refresh",				command_fun = command_awaken_shop_refresh,				param_list=""}, -- 覺醒商店刷新
	awaken_equipment_form = 	{	code = 400,		command = "awaken_equipment_form",				command_fun = command_awaken_equipment_form,			param_list=""}, -- 合成觉醒道具
	awaken_equipment_adron = 	{	code = 401,		command = "awaken_equipment_adron",				command_fun = command_awaken_equipment_adron,			param_list=""}, -- 穿上觉醒道具
	ship_awaken = 				{	code = 402,		command = "ship_awaken",						command_fun = command_ship_awaken,						param_list=""}, -- 开始觉醒
	awaken_refine = 			{	code = 403,		command = "awaken_refine",						command_fun = command_awaken_refine,					param_list=""}, -- 分解
	magic_trap_escalate = 		{	code = 404,		command = "magic_trap_escalate",				command_fun = command_magic_trap_escalate,				param_list=""}, -- 强化魔陷卡
	magic_trap_grow_up = 		{	code = 405,		command = "magic_trap_grow_up",					command_fun = command_magic_trap_grow_up,				param_list=""}, -- 同调魔陷卡
	secret_shopman_exchange = 	{	code = 406,		command = "secret_shopman_exchange",			command_fun = command_secret_shopman_exchange,			param_list=""}, -- 神秘商人购买
	equipment_up_star = 		{	code = 407,		command = "equipment_up_star",					command_fun = command_equipment_up_star,				param_list=""}, -- 装备升星

	--防沉迷
	id_register = {					code = 410,		command = "id_register",		 				command_fun = command_id_register, 						param_list=""},	-- 防沉迷注册请求
	birthday_record = {				code = 411,		command = "birthday_record",		 			command_fun = command_birthday_record, 					param_list=""},	-- 防沉迷记录生日
	vali_id = {						code = 412,		command = "vali_id",		 					command_fun = command_vali_id, 							param_list=""},	-- 防沉迷验证
	-- 宠物从450开始
	pet_change_formation =  	{	code = 450,		command = "pet_change_formation",				command_fun = command_pet_change_formation,				param_list=""}, -- 上阵战宠修改
	pet_escalate =  			{	code = 451,		command = "pet_escalate",						command_fun = command_pet_escalate,						param_list=""}, -- 请求战宠强化
	pet_grow_up =  				{	code = 452,		command = "pet_grow_up",						command_fun = command_pet_grow_up,						param_list=""}, -- 请求战宠升星
	pet_shop_init=				{	code = 453,		command = "pet_shop_init",						command_fun = command_pet_shop_init,					param_list=""}, -- 宠物商店初始化
	pet_shop_refresh=			{   code = 454,		command = "pet_shop_refresh",					command_fun = command_pet_shop_refresh,					param_list=""}, -- 宠物商店刷新
	pet_shop_exchange=          {   code = 455,		command = "pet_shop_exchange",					command_fun	= command_pet_shop_exchange,				param_list=""}, -- 宠物商店购买
	pet_train=          		{   code = 456,		command = "pet_train",							command_fun	= command_pet_train,						param_list=""}, -- 宠物训练
	pet_equip=          		{   code = 457,		command = "pet_equip",							command_fun	= command_pet_equip,						param_list=""}, -- 宠物驯养
	pet_counterpart_init=       {   code = 458,		command = "pet_counterpart_init",				command_fun	= command_pet_counterpart_init,				param_list=""}, -- 请求宠物副本初始化
	pet_counterpart_launch=     {   code = 459,		command = "pet_counterpart_launch",				command_fun	= command_pet_counterpart_launch,			param_list=""}, -- 请求宠物副本战斗
	pet_counterpart_get_reward= {   code = 460,		command = "pet_counterpart_get_reward",			command_fun	= command_pet_counterpart_get_reward,		param_list=""}, -- 请求宠物副本奖励
	pet_counterpart_go_next=    {   code = 461,		command = "pet_counterpart_go_next",			command_fun	= command_pet_counterpart_go_next,			param_list=""}, -- 请求下一关卡副本
	pet_counterpart_reset=      {   code = 462,		command = "pet_counterpart_reset",				command_fun	= command_pet_counterpart_reset,			param_list=""}, -- 请求重置宠物副本

	--分享
	new_share_reward_init =     {   code = 470,		command = "new_share_reward_init",				command_fun	= command_new_share_reward_init,			param_list=""}, -- 请求分享初始化
	--领取分享奖励
	draw_share_reward =         {   code = 471,		command = "draw_share_reward",					command_fun	= command_draw_share_reward,				param_list=""}, -- 请求领取分享奖励
	--填写邀请码
	share_write_invite_key =    {   code = 472,		command = "share_write_invite_key",				command_fun	= command_share_write_invite_key,			param_list=""}, -- 请求填写验证码
	one_key_sweep_arena =    	{   code = 480,		command = "one_key_sweep_arena",				command_fun	= command_one_key_sweep_arena,				param_list=""}, -- 请求竞技场一键扫荡
	one_key_sweep_three_kingdoms ={   code = 481,	command = "one_key_sweep_three_kingdoms",		command_fun	= command_one_key_sweep_three_kingdoms,		param_list=""}, -- 请求无限山一键三星
	rush_fight_times =  		{	code = 482,		command = "rush_fight_times",					command_fun = command_rush_fight_times,					param_list=""}, -- 跨服战倒计时
	limited_recharge_init =  	{	code = 490,		command = "limited_recharge_init",				command_fun = command_limited_recharge_init,			param_list=""}, -- 请求限时优惠
	limited_recharge_buy =  	{	code = 491,		command = "limited_recharge_buy",				command_fun = command_limited_recharge_buy,				param_list=""}, -- 请求购买限时优惠道具
	limited_recharge_get_reward = {	code = 492,		command = "limited_recharge_get_reward",		command_fun = command_limited_recharge_get_reward,		param_list=""}, -- 请求限时优惠全民福利领奖


	--叛军BOSS 520 开始 还有活动没有接
	rebel_boss_init = 			{	code = 520,		command = "rebel_boss_init",					command_fun = command_rebel_boss_init,					param_list=""}, -- 请求叛军初始化
	rebel_boss_fight = 			{	code = 521,		command = "rebel_boss_fight",					command_fun = command_rebel_boss_fight,					param_list=""}, -- 请求叛军战斗
	level_gift_buy = 			{	code = 550,		command = "level_gift_buy",						command_fun = command_level_gift_buy,					param_list=""}, -- 请求等级礼包购买/领取
	user_create_time = 			{	code = 560,		command = "user_create_time",					command_fun = command_user_create_time,					param_list=""}, -- 请求角色创建时间
	top_rank_init = 			{	code = 561,		command = "top_rank_init",						command_fun = command_top_rank_init,					param_list=""}, -- 请求top排行榜初始化
	recharge_rank_init = 		{	code = 562,		command = "recharge_rank_init",					command_fun = command_recharge_rank_init,				param_list=""}, -- 请求累計充值排行榜初始化
	get_online_gift_info = 		{	code = 563,		command = "get_online_gift_info",				command_fun = command_get_online_gift_info,				param_list=""}, -- 请求在線禮包初始化
	
	
	-- 红警项目
	-- lighten_star =				{	code = 5103,	command = "lighten_star",						command_fun = command_lighten_star,						param_list=""}, -- 点亮星格
	lighten_star =				{	code = 6001,	command = "lighten_star",						command_fun = command_lighten_star,						param_list=""}, -- 点亮星格
	binding_fetter = 			{	code = 6002,	command = "binding_fetter",						command_fun = command_binding_fetter,					param_list=""}, -- 绑定羁绊
	remove_fetter = 			{	code = 6003,	command = "remove_fetter",						command_fun = command_remove_fetter,					param_list=""}, -- 移除羁绊
	join_warfare = 				{	code = 6004,	command = "join_warfare",						command_fun = command_join_warfare,						param_list=""}, -- 加入国战
	join_city = 				{	code = 6006,	command = "join_city",							command_fun = command_join_city,						param_list=""}, -- 进入城市
	shoot_city = 				{	code = 6007,	command = "shoot_city",							command_fun = command_shoot_city,						param_list=""}, -- 突进
	retreat_city = 				{	code = 6008,	command = "retreat_city",						command_fun = command_retreat_city,						param_list=""}, -- 撤退
	begin_match = 				{	code = 6009,	command = "begin_match",						command_fun = command_begin_match,						param_list=""}, -- 开始匹配
	use_card = 					{	code = 6010,	command = "use_card",							command_fun = command_use_card,							param_list=""}, -- 使用卡牌
	look_up_situation = 		{	code = 6011,	command = "look_up_situation",					command_fun = command_look_up_situation,				param_list=""}, -- 查看战况
	release_order = 			{	code = 6012,	command = "release_order",						command_fun = command_release_order,					param_list=""}, -- 发布号令
	look_up_war_situation = 	{	code = 6013,	command = "look_up_war_situation",				command_fun = command_look_up_war_situation,			param_list=""}, -- 查看军情
	response_situation = 		{	code = 6014,	command = "response_situation",					command_fun = command_response_situation,				param_list=""}, -- 响应号令(集结)
	renascence = 				{	code = 6015,	command = "renascence",							command_fun = command_renascence,						param_list=""}, -- 立即复活
	provisions_buy = 			{	code = 6016,	command = "provisions_buy",						command_fun = command_provisions_buy,					param_list=""}, -- 购买粮草
	chose_camp = 				{	code = 6017,	command = "chose_camp",							command_fun = command_chose_camp,						param_list=""}, -- 选择阵营
	get_warfare_task = 			{	code = 6018,	command = "get_warfare_task",					command_fun = command_get_warfare_task,					param_list=""}, -- 获得国战任务列表
	draw_warfare_task_reward = 	{	code = 6019,	command = "draw_warfare_task_reward",			command_fun = command_draw_warfare_task_reward,			param_list=""}, -- 获得国战任务奖励
	get_warfare_ranking = 		{	code = 6020,	command = "get_warfare_ranking",				command_fun = command_get_warfare_ranking,				param_list=""}, -- 获得国战排行列表
	refush_city_info = 			{	code = 6021,	command = "refush_city_info",					command_fun = command_refush_city_info_ranking,			param_list=""}, -- 刷新城池人数信息
	clear_fight_cd = 			{	code = 6022,	command = "clear_fight_cd",						command_fun = command_clear_fight_cd,					param_list=""}, -- 清除当前城池CD
	warfare_get_my_fight_info = {	code = 6023,	command = "warfare_get_my_fight_info",			command_fun = command_warfare_get_my_fight_info,		param_list=""}, -- 获得个人战报
	draw_warfare_order_reward = {	code = 6024,	command = "draw_warfare_order_reward",			command_fun = command_draw_warfare_order_reward,		param_list=""}, -- 获得国战奖励
	build_level_up = 			{	code = 6025,	command = "build_level_up",						command_fun = command_build_level_up,					param_list=""}, -- 建筑升级
	build_check_up = 			{	code = 6026,	command = "build_check_up",						command_fun = command_build_check_up,					param_list=""}, -- 升级请求
	build_speed_up = 			{	code = 6027,	command = "build_speed_up",						command_fun = command_build_speed_up,					param_list=""}, -- 建筑加速升级
	get_home_resource = 		{	code = 6028,	command = "get_home_resource",					command_fun = command_get_home_resource,				param_list=""}, -- 获得建筑资源奖励
	gem_level_up = 				{	code = 6029,	command = "gem_level_up",						command_fun = command_gem_level_up,						param_list=""}, -- 宝石升级
	gem_inlay = 				{	code = 6030,	command = "gem_inlay",							command_fun = command_gem_inlay,						param_list=""}, -- 宝石镶嵌
	gem_inlay_down = 			{	code = 6031,	command = "gem_inlay_down",						command_fun = command_gem_inlay_down,					param_list=""}, -- 宝石卸下
	ship_refining =  			{	code = 6032,	command = "ship_refining",						command_fun = command_ship_refining,					param_list=""}, -- 英雄分解
	barracks_teach_check_cd =  	{	code = 6033,	command = "barracks_teach_check_cd",			command_fun = command_barracks_teach_check_cd,			param_list=""}, -- 兵营科技升级检测
	barracks_teach_clear_cd =  	{	code = 6034,	command = "barracks_teach_clear_cd",			command_fun = command_barracks_teach_clear_cd,			param_list=""}, -- 兵营科技清除冷却时间
	barracks_teach_update =  	{	code = 6035,	command = "barracks_teach_update",				command_fun = command_barracks_teach_update,			param_list=""}, -- 兵营科技升级
	wear_majesty_change =  		{	code = 6036,	command = "wear_majesty_change",				command_fun = command_wear_majesty_change,				param_list=""}, -- 主公技改变
	request_fate = 				{	code = 6038,	command = "request_fate",						command_fun = command_request_fate,						param_list=""}, -- 请求祭祀
	awaken_equipment = 			{	code = 6039,	command = "awaken_equipment",					command_fun = command_awaken_equipment,					param_list=""}, -- 装备觉醒
	ship_rebirth = 				{	code = 6040,	command = "ship_rebirth",						command_fun = command_ship_rebirth,						param_list=""}, -- 英雄重生
	buy_copy_attack_times =  	{	code = 6041,	command = "buy_copy_attack_times",				command_fun = command_buy_copy_attack_times,			param_list=""}, -- 副本购买次数
	gem_sweep =  				{	code = 6042,	command = "gem_sweep",							command_fun = command_gem_sweep,						param_list=""}, -- 宝石副本扫荡
	equip_sweep =  				{	code = 6043,	command = "equip_sweep",						command_fun = command_equip_sweep,						param_list=""}, -- 兵器塚副本扫荡
	three_kings_sweep=  		{	code = 6044,	command = "three_kings_sweep",					command_fun = command_three_kings_sweep,				param_list=""}, -- 三国无双扫荡
	three_kings_reset =  		{	code = 6045,	command = "three_kings_reset",					command_fun = command_three_kings_reset,				param_list=""}, -- 三国无双重置
	raiders_cut_refrush =  		{	code = 6046,	command = "raiders_cut_refrush",				command_fun = command_raiders_cut_refrush,				param_list=""}, -- 斩将夺宝刷新
	ship_military_init =  		{	code = 6047,	command = "ship_military_init",					command_fun = command_ship_military_init,				param_list=""}, -- 运送军资信息初始化
	ship_military_refrush_quality = {	code = 6048,	command = "ship_military_refrush_quality",	command_fun = command_ship_military_refrush_quality,	param_list=""}, -- 运送军资品质刷新
	ship_military_start_transport = {	code = 6049,	command = "ship_military_start_transport",	command_fun = command_ship_military_start_transport,	param_list=""}, -- 开始运送
	ship_military_speed_transport = {	code = 6050,	command = "ship_military_speed_transport",	command_fun = command_ship_military_speed_transport,	param_list=""}, -- 加速运送
	ship_military_check_transport_end = {	code = 6051,	command = "ship_military_check_transport_end",	command_fun = command_ship_military_check_transport_end,	param_list=""}, --检测运送完毕
	ship_military_change_users = {	code = 6052,	command = "ship_military_change_users",	command_fun = command_ship_military_change_users,				param_list=""}, --换一批
	three_kings_get_rank_info = {	code = 6053,	command = "three_kings_get_rank_info",	command_fun = command_three_kings_get_rank_info,				param_list=""}, --获得三国无双排行信息
	order_get_info = 			{	code = 6054,	command = "order_get_info",						command_fun = command_order_get_info,					param_list=""}, --获得所有用户排行信息
	buy_arena_launch_count	= 	{	code = 6055,	command = "buy_arena_launch_count",				command_fun = command_buy_arena_launch_count,			param_list=""}, --(皇城)竞技场购买次数
	arena_lounch_refresh = 		{	code = 6056,	command = "arena_lounch_refresh",				command_fun = command_arena_lounch_refresh,				param_list=""}, --皇城换一批
	get_user_mail = 			{	code = 6057,	command = "get_user_mail",					    command_fun = command_get_user_mail,					param_list=""}, --获取邮件
	delete_mail = 				{	code = 6058,	command = "delete_mail",					    command_fun = command_delete_mail,						param_list=""}, --删除邮件
	draw_attachment_in_mail = 	{	code = 6059,	command = "draw_attachment_in_mail",			command_fun = command_draw_attachment_in_mail,			param_list=""}, --领取附件
	get_task_reward = 			{	code = 6060,	command = "get_task_reward",					command_fun = command_get_task_reward,					param_list=""}, --获取任务奖励
	activity_init = 			{	code = 6061,	command = "activity_init",						command_fun = command_activity_init,					param_list=""}, --活动初始化
	draw_activity_reward = 		{	code = 6062,	command = "draw_activity_reward",				command_fun = command_draw_activity_reward,				param_list=""}, --领取活动奖励
	get_other_user_info = 		{	code = 6063,	command = "get_other_user_info",				command_fun = command_get_other_user_info,				param_list=""}, --获取其他用户信息
	get_other_user_ship_info = 	{	code = 6064,	command = "get_other_user_ship_info",			command_fun = command_get_other_user_ship_info,			param_list=""}, --获取其他用户英雄信息
	get_other_user_equip_info = {	code = 6065,	command = "get_other_user_equip_info",			command_fun = command_get_other_user_equip_info,		param_list=""}, --获取其他用户装备信息
	grow_up_activity_buy = 		{	code = 6066,	command = "grow_up_activity_buy",				command_fun = command_grow_up_activity_buy,				param_list=""}, --购买开服基金
	one_key_lighten_star = 		{	code = 6067,	command = "one_key_lighten_star",				command_fun = command_one_key_lighten_star,				param_list=""}, --一键升星
	shop_buy_prop = 			{	code = 6068,	command = "shop_buy_prop",						command_fun = command_shop_buy_prop,					param_list=""}, --商城购买
	rider_horse = 				{	code = 6069,	command = "rider_horse",						command_fun = command_rider_horse,						param_list=""}, --上马下马
	inlay_horse_spirit = 		{	code = 6070,	command = "inlay_horse_spirit",					command_fun = command_inlay_horse_spirit,				param_list=""}, --马魂附魔
	find_horse = 				{	code = 6071,	command = "find_horse",							command_fun = command_find_horse,						param_list=""}, --宝物购买
	recuit_horse = 				{	code = 6072,	command = "recuit_horse",						command_fun = command_recuit_horse,						param_list=""}, --相马
	get_recuit_horse_info = 	{	code = 6073,	command = "get_recuit_horse_info",				command_fun = command_get_recuit_horse_info,			param_list=""}, --获取相马次数
	horse_spirit_pay = 			{	code = 6074,	command = "horse_spirit_pay",					command_fun = command_horse_spirit_pay,					param_list=""}, --马魂兑换
	combing_horse = 			{	code = 6075,	command = "combing_horse",						command_fun = command_combing_horse,					param_list=""}, --龙马合成
	horse_spirit_level_up = 	{	code = 6076,	command = "horse_spirit_level_up",				command_fun = command_horse_spirit_level_up,			param_list=""}, --马魂升级
	refining_horse = 			{	code = 6077,	command = "refining_horse",						command_fun = command_refining_horse,					param_list=""}, --战马分解
	union_endless_init = 		{	code = 6078,	command = "union_endless_init",					command_fun = command_union_endless_init,				param_list=""}, --请求公会组队争霸信息
	union_endless_join_group = 	{	code = 6079,	command = "union_endless_join_group",			command_fun = command_union_endless_join_group,			param_list=""}, --参加公会组队争霸队伍
	union_endless_create_group ={	code = 6080,	command = "union_endless_create_group",			command_fun = command_union_endless_create_group,		param_list=""}, --创建公会组队争霸队伍
	get_ship_info =				{	code = 6081,	command = "get_ship_info",						command_fun = command_get_ship_info,					param_list=""}, --获取战船实例数据
	union_order =				{	code = 6082,	command = "union_order",						command_fun = command_union_order,						param_list=""}, --工会排行
	union_other_persion_list =	{	code = 6083,	command = "union_other_persion_list",			command_fun = command_union_other_persion_list,			param_list=""}, --查看其他工会成员
	union_food_copy_init =		{	code = 6084,	command = "union_food_copy_init",				command_fun = command_union_food_copy_init,				param_list=""}, --阿希拉初始信息
	union_food_copy_create_group ={	code = 6085,	command = "union_food_copy_create_group",		command_fun = command_union_food_copy_create_group,		param_list=""}, --阿希拉创建队伍
	union_food_copy_join_group ={	code = 6086,	command = "union_food_copy_join_group",			command_fun = command_union_food_copy_join_group,		param_list=""}, --阿希拉加入队伍
	union_stronghold_hold 		={	code = 6087,	command = "union_stronghold_hold",				command_fun = command_union_stronghold_hold,			param_list=""}, --请求占领工会据点
	union_stronghold_init 		={	code = 6088,	command = "union_stronghold_init",				command_fun = command_union_stronghold_init,			param_list=""}, --请求工会城池据点信息
	union_stronghold_fight 		={	code = 6089,	command = "union_stronghold_fight",				command_fun = command_union_stronghold_fight,			param_list=""}, --请求公会据点挑战
	union_stronghold_resurrect 	={	code = 6090,	command = "union_stronghold_resurrect",			command_fun = command_union_stronghold_resurrect,		param_list=""}, --请求公会战复活
	union_stronghold_retreat 	={	code = 6091,	command = "union_stronghold_retreat",			command_fun = command_union_stronghold_retreat,			param_list=""}, --请求公会战撤退
	union_stronghold_clear_match_cd={	code = 6092,command = "union_stronghold_clear_match_cd",	command_fun = command_union_stronghold_clear_match_cd,	param_list=""}, --请求公会战清除攻击cd
	union_stronghold_bidding	={	code = 6093,	command = "union_stronghold_bidding",			command_fun = command_union_stronghold_bidding,			param_list=""}, --请求公会战竞价
	union_stronghold_battle_switch	={	code = 6094,command = "union_stronghold_battle_switch",		command_fun = command_union_stronghold_battle_switch,	param_list=""}, --切换攻防状态
	union_stronghold_battle_details	={	code = 6095,command = "union_stronghold_battle_details",	command_fun = command_union_stronghold_battle_details,	param_list=""}, --查看工会战城池详情


	battle_result_fail 			={	code = 6100,	command = "battle_result_fail",					command_fun = command_battle_result_fail,				param_list=""}, --战斗失败
	init_user_socket_service 	={	code = 6101,	command = "init_user_socket_service",			command_fun = command_init_user_socket_service,			param_list=""}, --长连初始化
	city_resource_hold_init 	={	code = 6102,	command = "city_resource_hold_init",			command_fun = command_city_resource_hold_init,			param_list=""}, --大地图初始化
	city_resource_hold_quit 	={	code = 6103,	command = "city_resource_hold_quit",			command_fun = command_city_resource_hold_quit,			param_list=""}, --退出大地图界面传：用户ID
	city_resource_hold_move_to_city 	={	code = 6104,	command = "city_resource_hold_move_to_city",			command_fun = command_city_resource_hold_move_to_city,		param_list=""}, --在大地图上面移动到某个城池
	city_resource_hold_get_city_resource 	={	code = 6105,	command = "city_resource_hold_get_city_resource",	command_fun = command_city_resource_hold_get_city_resource,	param_list=""}, --请求某个城池的资源
	city_resource_hold_get_resource_users   ={code = 6106,command = "city_resource_hold_get_resource_users",	command_fun = command_city_resource_hold_get_resource_users,	param_list=""}, --请求某个城池某个资源的数据
	city_resource_hold   		={code = 6107,		command = "city_resource_hold",					command_fun = command_city_resource_hold,				param_list=""}, --请求占领空的资源
	city_resource_hold_get_user_position_info ={code = 6108,command = "city_resource_hold_get_user_position_info",command_fun = command_city_resource_hold_get_user_position_info,param_list=""}, --请求单个采集点信息
	city_resource_hold_encourage ={code = 6109,		command = "city_resource_hold_encourage",		command_fun = command_city_resource_hold_encourage,		param_list=""}, --请求鼓舞
	city_resource_un_hold 		={code = 6110,		command = "city_resource_un_hold",				command_fun = command_city_resource_un_hold,				param_list=""}, --放弃占领
	city_resource_hold_buy_robot_count 	={code = 6111,command = "city_resource_hold_buy_robot_count",command_fun = command_city_resource_hold_buy_robot_count,	param_list=""}, --购买掠夺次数
	city_resource_hold_get_invites 	={code = 6112,	command = "city_resource_hold_get_invites",		command_fun = command_city_resource_hold_get_invites,	param_list=""}, --获取邀请列表
	city_resource_hold_init_invite 	={code = 6113,	command = "city_resource_hold_init_invite",		command_fun = command_city_resource_hold_init_invite,	param_list=""}, --邀请
	battlefield_report_get 			={code = 6114,	command = "battlefield_report_get",				command_fun = command_battlefield_report_get,			param_list=""}, --获取战报列表
	
	answer											={code = 6115, command = "answer",											command_fun = command_answer,											param_list=""}, -- 学霸答题	
	answer_exit										={code = 6116, command = "answer_exit",										command_fun = command_answer_exit,										param_list=""}, -- 学霸退出	
	answer_init										={code = 6117, command = "answer_init",										command_fun = command_answer_init,										param_list=""}, -- 学霸初始化	
	arena_launch_clear_cd							={code = 6118, command = "arena_launch_clear_cd",							command_fun = command_arena_launch_clear_cd,							param_list=""}, -- 竞技场清除cd	
	arena_launch_formation_change					={code = 6119, command = "arena_launch_formation_change",					command_fun = command_arena_launch_formation_change,					param_list=""}, -- 克隆竞技场阵容	
	arena_lounch_refresh							={code = 6120, command = "arena_lounch_refresh",							command_fun = command_arena_lounch_refresh,								param_list=""}, -- 竞技场刷新接口	
	arena_shop_refresh								={code = 6121, command = "arena_shop_refresh",								command_fun = command_arena_shop_refresh,								param_list=""}, -- 竞技场商店刷新	
	arena_worship									={code = 6122, command = "arena_worship",									command_fun = command_arena_worship,									param_list=""}, -- 竞技场膜拜接口	
	armor_buy_times									={code = 6123, command = "armor_buy_times",									command_fun = command_armor_buy_times,									param_list=""}, -- 装甲副本攻打次数购买	
	armor_check_time								={code = 6124, command = "armor_check_time",								command_fun = command_armor_check_time,									param_list=""}, -- 装甲生产免费次数时间校验	
	armor_formation_change							={code = 6125, command = "armor_formation_change",							command_fun = command_armor_formation_change,							param_list=""}, -- 装甲阵型变更	
	armor_packs_expansion							={code = 6126, command = "armor_packs_expansion",							command_fun = command_armor_packs_expansion,							param_list=""}, -- 装甲仓库扩容	
	armor_production								={code = 6127, command = "armor_production",								command_fun = command_armor_production,									param_list=""}, -- 装甲生产	
	armor_quick_wear								={code = 6128, command = "armor_quick_wear",								command_fun = command_armor_quick_wear,									param_list=""}, -- 装甲一键穿戴/一键卸下	
	armor_sell										={code = 6129, command = "armor_sell",										command_fun = command_armor_sell,										param_list=""}, -- 装甲出售	
	armor_upgrade									={code = 6130, command = "armor_upgrade",									command_fun = command_armor_upgrade,									param_list=""}, -- 装甲升级	
	armor_wear										={code = 6131, command = "armor_wear",										command_fun = command_armor_wear,										param_list=""}, -- 装甲穿戴/卸下/变更	
	avatar_shop_buy									={code = 6132, command = "avatar_shop_buy",									command_fun = command_avatar_shop_buy,									param_list=""}, -- 用户商店购买	
	barracks_teach_check_cd							={code = 6133, command = "barracks_teach_check_cd",							command_fun = command_barracks_teach_check_cd,							param_list=""}, -- 科研中心检测升级	
	barracks_teach_clear_cd							={code = 6134, command = "barracks_teach_clear_cd",							command_fun = command_barracks_teach_clear_cd,							param_list=""}, -- 科研中心升级加速	
	barracks_teach_update							={code = 6135, command = "barracks_teach_update",							command_fun = command_barracks_teach_update,							param_list=""}, -- 科研中心升级请求	
	barracks_teach_update_cancel					={code = 6136, command = "barracks_teach_update_cancel",					command_fun = command_barracks_teach_update_cancel,						param_list=""}, -- 科研中心升级取消	
	battlefield_report_battle_info_get				={code = 6137, command = "battlefield_report_battle_info_get",				command_fun = command_battlefield_report_battle_info_get,				param_list=""}, -- 获取回放	
	battlefield_report_details_get					={code = 6138, command = "battlefield_report_details_get",					command_fun = command_battlefield_report_details_get,					param_list=""}, -- 获取战报奖励	
	battlefield_report_save							={code = 6139, command = "battlefield_report_save",							command_fun = command_battlefield_report_save,							param_list=""}, -- 信息保存接口	
	battlefield_report_save_delete					={code = 6140, command = "battlefield_report_save_delete",					command_fun = command_battlefield_report_save_delete,					param_list=""}, -- 保存信息的删除接口	
	battlefield_report_save_get						={code = 6141, command = "battlefield_report_save_get",						command_fun = command_battlefield_report_save_get,						param_list=""}, -- 信息获取接口	
	boom_buy										={code = 6142, command = "boom_buy",										command_fun = command_boom_buy,											param_list=""}, -- 繁荣度购买	
	build_auto_update								={code = 6143, command = "build_auto_update",								command_fun = command_build_auto_update,								param_list=""}, -- 建筑自动升级	
	build_level_up_cancel							={code = 6144, command = "build_level_up_cancel",							command_fun = command_build_level_up_cancel,							param_list=""}, -- 建筑升级取消	
	build_patrol_check_time							={code = 6145, command = "build_patrol_check_time",							command_fun = command_build_patrol_check_time,							param_list=""}, -- 主城巡逻兵结算	
	build_patrol_draw								={code = 6146, command = "build_patrol_draw",								command_fun = command_build_patrol_draw,								param_list=""}, -- 主城巡逻兵领奖	
	build_restore									={code = 6147, command = "build_restore",									command_fun = command_build_restore,									param_list=""}, -- 拆除建筑	
	build_shop_buy									={code = 6148, command = "build_shop_buy",									command_fun = command_build_shop_buy,									param_list=""}, -- 建筑商店购买	
	buy_build_queue									={code = 6149, command = "buy_build_queue",									command_fun = command_buy_build_queue,									param_list=""}, -- 购买建造队列	
	buy_prestige									={code = 6150, command = "buy_prestige",									command_fun = command_buy_prestige,										param_list=""}, -- 购买声望	
	buy_super_equipment_copy_attack_count			={code = 6151, command = "buy_super_equipment_copy_attack_count",			command_fun = command_buy_super_equipment_copy_attack_count,			param_list=""}, -- 请求购买神兵副本攻击次数	
	camp_duel_battle_init							={code = 6152, command = "camp_duel_battle_init",							command_fun = command_camp_duel_battle_init,							param_list=""}, -- 阵营对决战场初始化	
	camp_duel_check_move							={code = 6153, command = "camp_duel_check_move",							command_fun = command_camp_duel_check_move,								param_list=""}, -- 阵营对决战场移动校验	
	camp_duel_choose_line							={code = 6154, command = "camp_duel_choose_line",							command_fun = command_camp_duel_choose_line,							param_list=""}, -- 阵营对决战场路线选择	
	camp_duel_exit									={code = 6155, command = "camp_duel_exit",									command_fun = command_camp_duel_exit,									param_list=""}, -- 阵营对决界面退出	
	camp_duel_init									={code = 6156, command = "camp_duel_init",									command_fun = command_camp_duel_init,									param_list=""}, -- 阵营对决初始化	
	camp_duel_rank_list_get							={code = 6157, command = "camp_duel_rank_list_get",							command_fun = command_camp_duel_rank_list_get,							param_list=""}, -- 阵营对决排行榜获取	
	camp_duel_shop_exchange							={code = 6158, command = "camp_duel_shop_exchange",							command_fun = command_camp_duel_shop_exchange,							param_list=""}, -- 阵营对决商店兑换	
	camp_duel_shop_refresh							={code = 6159, command = "camp_duel_shop_refresh",							command_fun = command_camp_duel_shop_refresh,							param_list=""}, -- 阵营对决战商店刷新	
	camp_duel_signup								={code = 6160, command = "camp_duel_signup",								command_fun = command_camp_duel_signup,									param_list=""}, -- 阵营对决报名	
	check_boom_recover								={code = 6161, command = "check_boom_recover",								command_fun = command_check_boom_recover,								param_list=""}, -- 检查繁荣度回复	
	check_food_recover								={code = 6162, command = "check_food_recover",								command_fun = command_check_food_recover,								param_list=""}, -- 检查体力回复	
	check_task_time									={code = 6163, command = "check_task_time",									command_fun = command_check_task_time,									param_list=""}, -- 紧急任务时间校验	
	check_title_state								={code = 6164, command = "check_title_state",								command_fun = command_check_title_state,								param_list=""}, -- 检查称号状态	
	city_resource_hold_list_refresh					={code = 6165, command = "city_resource_hold_list_refresh",					command_fun = command_city_resource_hold_list_refresh,					param_list=""}, -- 请求资源点排行和搜索信息
	city_resource_refrush							={code = 6166, command = "city_resource_refrush",							command_fun = command_city_resource_refrush,							param_list=""}, -- 请求刷新资源薪资	
	command_update									={code = 6167, command = "command_update",									command_fun = command_command_update,									param_list=""}, -- 统率升级	
	complete_fb_task								={code = 6168, command = "complete_fb_task",								command_fun = command_complete_fb_task,									param_list=""}, -- facebook完成任务 任务类型(1:邀请 2:点赞 3:分享)	
	delete_all_mail									={code = 6169, command = "delete_all_mail",									command_fun = command_delete_all_mail,									param_list=""}, -- 删除所有邮件接口	
	delete_all_message								={code = 6170, command = "delete_all_message",								command_fun = command_delete_all_message,								param_list=""}, -- 删除所有信息接口	
	delete_message									={code = 6171, command = "delete_message",									command_fun = command_delete_message,									param_list=""}, -- 删除信息接口	
	draw_answer_reward								={code = 6172, command = "draw_answer_reward",								command_fun = command_draw_answer_reward,								param_list=""}, -- 领取学霸奖励	
	draw_arena_lucky_reward							={code = 6173, command = "draw_arena_lucky_reward",							command_fun = command_draw_arena_lucky_reward,							param_list=""}, -- 竞技场幸运排名奖励领取	
	draw_arena_order_reward							={code = 6174, command = "draw_arena_order_reward",							command_fun = command_draw_arena_order_reward,							param_list=""}, -- 竞技场排名奖励领取	
	draw_arena_score_reward							={code = 6175, command = "draw_arena_score_reward",							command_fun = command_draw_arena_score_reward,							param_list=""}, -- 竞技场积分奖励领取	
	draw_attachment_in_mail							={code = 6176, command = "draw_attachment_in_mail",							command_fun = command_draw_attachment_in_mail,							param_list=""}, -- 领取邮件的附件接口	
	draw_expedition_reward							={code = 6177, command = "draw_expedition_reward",							command_fun = command_draw_expedition_reward,							param_list=""}, -- 远征奖励领取	
	draw_fb_reward									={code = 6178, command = "draw_fb_reward",									command_fun = command_draw_fb_reward,									param_list=""}, -- facebook领奖	
	draw_first_join_union_reward					={code = 6179, command = "draw_first_join_union_reward",					command_fun = command_draw_first_join_union_reward,						param_list=""}, -- 领取初次加入军团奖励	
	draw_rebel_week_reward							={code = 6180, command = "draw_rebel_week_reward",							command_fun = command_draw_rebel_week_reward,							param_list=""}, -- 领取叛军周排行奖励	
	draw_union_active_share							={code = 6181, command = "draw_union_active_share",							command_fun = command_draw_union_active_share,							param_list=""}, -- 领取军团活跃分享	
	draw_union_copy_reward							={code = 6182, command = "draw_union_copy_reward",							command_fun = command_draw_union_copy_reward,							param_list=""}, -- 军团副本奖励领取	
	draw_union_stronghold_reward					={code = 6183, command = "draw_union_stronghold_reward",					command_fun = command_draw_union_stronghold_reward,						param_list=""}, -- 公会战奖励领取接口	
	elit_sweep										={code = 6184, command = "elit_sweep",										command_fun = command_elit_sweep,										param_list=""}, -- 配件副本扫荡	
	enemy_boss_exit									={code = 6185, command = "enemy_boss_exit",									command_fun = command_enemy_boss_exit,									param_list=""}, -- 敌军来袭退出	
	enemy_boss_formation_change						={code = 6186, command = "enemy_boss_formation_change",						command_fun = command_enemy_boss_formation_change,						param_list=""}, -- 敌军来袭设置部队	
	enemy_boss_init									={code = 6187, command = "enemy_boss_init",									command_fun = command_enemy_boss_init,									param_list=""}, -- 敌军来袭初始化	
	enemy_boss_rank_list_get						={code = 6188, command = "enemy_boss_rank_list_get",						command_fun = command_enemy_boss_rank_list_get,							param_list=""}, -- 敌军来袭排行榜	
	equipment_adorn									={code = 6189, command = "equipment_adorn",									command_fun = command_equipment_adorn,									param_list=""}, -- 配件穿戴	
	equipment_escalate								={code = 6190, command = "equipment_escalate",								command_fun = command_equipment_escalate,								param_list=""}, -- 配件强化	
	equipment_rank_up								={code = 6191, command = "equipment_rank_up",								command_fun = command_equipment_rank_up,								param_list=""}, -- 配件改造	
	equipment_refine								={code = 6192, command = "equipment_refine",								command_fun = command_equipment_refine,									param_list=""}, -- 装备洗练	
	equipment_refine_lock							={code = 6193, command = "equipment_refine_lock",							command_fun = command_equipment_refine_lock,							param_list=""}, -- 装备洗练锁定	
	equipment_refine_replace						={code = 6194, command = "equipment_refine_replace",						command_fun = command_equipment_refine_replace,							param_list=""}, -- 装备洗练替换	
	equipment_return								={code = 6195, command = "equipment_return",								command_fun = command_equipment_return,									param_list=""}, -- 装备回炉	
	expedition_init									={code = 6196, command = "expedition_init",									command_fun = command_expedition_init,									param_list=""}, -- 远征初始化	
	expedition_reset								={code = 6197, command = "expedition_reset",								command_fun = command_expedition_reset,									param_list=""}, -- 远征重置	
	expedition_shop_exchange						={code = 6198, command = "expedition_shop_exchange",						command_fun = command_expedition_shop_exchange,							param_list=""}, -- 远征商店兑换	
	expedition_shop_refresh							={code = 6199, command = "expedition_shop_refresh",							command_fun = command_expedition_shop_refresh,							param_list=""}, -- 远征商店刷新	
	expedition_sweep								={code = 6200, command = "expedition_sweep",								command_fun = command_expedition_sweep,									param_list=""}, -- 远征扫荡	
	extreme_buff_buy								={code = 6201, command = "extreme_buff_buy",								command_fun = command_extreme_buff_buy,									param_list=""}, -- 极限挑战购买buff	
	extreme_fast_battle								={code = 6202, command = "extreme_fast_battle",								command_fun = command_extreme_fast_battle,								param_list=""}, -- 极限挑战快速激战	
	extreme_formation_change						={code = 6203, command = "extreme_formation_change",						command_fun = command_extreme_formation_change,							param_list=""}, -- 极限挑战阵容设置	
	extreme_init									={code = 6204, command = "extreme_init",									command_fun = command_extreme_init,										param_list=""}, -- 极限挑战初始化	
	extreme_rank_get								={code = 6205, command = "extreme_rank_get",								command_fun = command_extreme_rank_get,									param_list=""}, -- 极限挑战排行榜获取	
	extreme_start									={code = 6206, command = "extreme_start",									command_fun = command_extreme_start,									param_list=""}, -- 极限挑战开始	
	facebook_get_reward								={code = 6207, command = "facebook_get_reward",								command_fun = command_facebook_get_reward,								param_list=""}, -- facebook邀请领取奖励	
	facebook_invite_friend							={code = 6208, command = "facebook_invite_friend",							command_fun = command_facebook_invite_friend,							param_list=""}, -- facebook邀请好友	
	factory_product									={code = 6209, command = "factory_product",									command_fun = command_factory_product,									param_list=""}, -- 工厂生产	
	factory_product_cancel							={code = 6210, command = "factory_product_cancel",							command_fun = command_factory_product_cancel,							param_list=""}, -- 工厂取消生产	
	factory_product_check_cd						={code = 6211, command = "factory_product_check_cd",						command_fun = command_factory_product_check_cd,							param_list=""}, -- 工厂检查生产cd	
	factory_product_clear_cd						={code = 6212, command = "factory_product_clear_cd",						command_fun = command_factory_product_clear_cd,							param_list=""}, -- 工厂生产加速	
	fb_launch										={code = 6213, command = "fb_launch",										command_fun = command_fb_launch,										param_list=""}, -- 请求Facebook发起	
	fb_login_init									={code = 6214, command = "fb_login_init",									command_fun = command_fb_login_init,									param_list=""}, -- facebook登陆	
	fb_reward_init									={code = 6215, command = "fb_reward_init",									command_fun = command_fb_reward_init,									param_list=""}, -- facebook奖励初始化	
	formation_save									={code = 6216, command = "formation_save",									command_fun = command_formation_save,									param_list=""}, -- 阵容保存	
	gain_limit_check								={code = 6217, command = "gain_limit_check",								command_fun = command_gain_limit_check,									param_list=""}, -- 检查限时增益cd	
	get_activity_rank								={code = 6218, command = "get_activity_rank",								command_fun = command_get_activity_rank,								param_list=""}, -- 请求活动排行数据	
	get_open_server_rank_info						={code = 6219, command = "get_open_server_rank_info",						command_fun = command_get_open_server_rank_info,						param_list=""}, -- 开服top	
	get_other_user_horse_info						={code = 6220, command = "get_other_user_horse_info",						command_fun = command_get_other_user_horse_info,						param_list=""}, -- 获取其他用户珍兽信息	
	get_other_user_ship_info						={code = 6221, command = "get_other_user_ship_info",						command_fun = command_get_other_user_ship_info,							param_list=""}, -- 查看对方武将	
	get_server_maintenance_info						={code = 6222, command = "get_server_maintenance_info",						command_fun = command_get_server_maintenance_info,						param_list=""}, -- 请求维护服务器信息	
	get_server_open_info							={code = 6223, command = "get_server_open_info",							command_fun = command_get_server_open_info,								param_list=""}, -- 请求开服服务器信息	
	get_share_message								={code = 6224, command = "get_share_message",								command_fun = command_get_share_message,								param_list=""}, -- 聊天战报查看接口	
	get_ship_count									={code = 6225, command = "get_ship_count",									command_fun = command_get_ship_count,									param_list=""}, -- 校验阵型战损数据	
	get_union_create_info							={code = 6226, command = "get_union_create_info",							command_fun = command_get_union_create_info,							param_list=""}, -- 获取军团创建信息	
	get_user_level_rank_info						={code = 6227, command = "get_user_level_rank_info",						command_fun = command_get_user_level_rank_info,							param_list=""}, -- 请求获取个人等级排行	
	get_user_showing_info							={code = 6228, command = "get_user_showing_info",							command_fun = command_get_user_showing_info,							param_list=""}, -- 查看玩家的展示信息	
	get_world_coord_collect							={code = 6229, command = "get_world_coord_collect",							command_fun = command_get_world_coord_collect,							param_list=""}, -- 获取世界地图收藏信息	
	grab_red_packet									={code = 6230, command = "grab_red_packet",									command_fun = command_grab_red_packet,									param_list=""}, -- 抢红包	
	guard_buff_buy									={code = 6231, command = "guard_buff_buy",									command_fun = command_guard_buff_buy,									param_list=""}, -- 守卫战buff购买	
	guard_check_gain_cd_time						={code = 6232, command = "guard_check_gain_cd_time",						command_fun = command_guard_check_gain_cd_time,							param_list=""}, -- 守卫战检查增益cd	
	guard_clear_cd									={code = 6233, command = "guard_clear_cd",									command_fun = command_guard_clear_cd,									param_list=""}, -- 守卫战清除战斗cd	
	guard_exit										={code = 6234, command = "guard_exit",										command_fun = command_guard_exit,										param_list=""}, -- 守卫战退出	
	guard_formation_save							={code = 6235, command = "guard_formation_save",							command_fun = command_guard_formation_save,								param_list=""}, -- 守卫战设置防守阵容	
	guard_list_init									={code = 6236, command = "guard_list_init",									command_fun = command_guard_list_init,									param_list=""}, -- 守卫战防守列表初始化	
	guard_order_list								={code = 6237, command = "guard_order_list",								command_fun = command_guard_order_list,									param_list=""}, -- 守卫战排行榜	
	guard_set_auto_clear_cd							={code = 6238, command = "guard_set_auto_clear_cd",							command_fun = command_guard_set_auto_clear_cd,							param_list=""}, -- 守卫战设置自动清除战斗cd	
	guard_stronghold_init							={code = 6239, command = "guard_stronghold_init",							command_fun = command_guard_stronghold_init,							param_list=""}, -- 守卫战据点初始化	
	head_save										={code = 6240, command = "head_save",										command_fun = command_head_save,										param_list=""}, -- 保存头像	
	horn_use										={code = 6241, command = "horn_use",										command_fun = command_horn_use,											param_list=""}, -- 使用喇叭	
	horse_spirit_awaken								={code = 6242, command = "horse_spirit_awaken",								command_fun = command_horse_spirit_awaken,								param_list=""}, -- 兽魂觉醒	
	majesty_skill_reset								={code = 6243, command = "majesty_skill_reset",								command_fun = command_majesty_skill_reset,								param_list=""}, -- 主角技能重置	
	mission_skip_info								={code = 6244, command = "mission_skip_info",								command_fun = command_mission_skip_info,								param_list=""}, -- 用户事件跳过记录	
	one_key_draw_attachment_in_mail					={code = 6245, command = "one_key_draw_attachment_in_mail",					command_fun = command_one_key_draw_attachment_in_mail,					param_list=""}, -- 键领取所有邮件的附件接口
	one_key_read_mail								={code = 6246, command = "one_key_read_mail",								command_fun = command_one_key_read_mail,								param_list=""}, -- 键阅读所有邮件接口	
	one_key_read_message							={code = 6247, command = "one_key_read_message",							command_fun = command_one_key_read_message,								param_list=""}, -- 信息标记全部阅读接口	
	order_self_get_info								={code = 6248, command = "order_self_get_info",								command_fun = command_order_self_get_info,								param_list=""}, -- 获取用户自己排行	
	parts_exchange									={code = 6249, command = "parts_exchange",									command_fun = command_parts_exchange,									param_list=""}, -- 配件兑换	
	prop_change_to									={code = 6250, command = "prop_change_to",									command_fun = command_prop_change_to,									param_list=""}, -- 万能碎片兑换接口	
	rebel_haunt_exit								={code = 6251, command = "rebel_haunt_exit",								command_fun = command_rebel_haunt_exit,									param_list=""}, -- 叛军退出	
	rebel_haunt_list_init							={code = 6252, command = "rebel_haunt_list_init",							command_fun = command_rebel_haunt_list_init,							param_list=""}, -- 叛军列表初始化	
	rebel_haunt_rank_list_get						={code = 6253, command = "rebel_haunt_rank_list_get",						command_fun = command_rebel_haunt_rank_list_get,						param_list=""}, -- 叛军排行榜信息	
	refresh_world_target_event						={code = 6254, command = "refresh_world_target_event",						command_fun = command_refresh_world_target_event,						param_list=""}, -- 刷新世界行军事件	
	reset_elit_copy									={code = 6255, command = "reset_elit_copy",									command_fun = command_reset_elit_copy,									param_list=""}, -- 配件副本重置	
	send_share_message								={code = 6256, command = "send_share_message",								command_fun = command_send_share_message,								param_list=""}, -- 发送战报分享	
	share_red_packet								={code = 6257, command = "share_red_packet",								command_fun = command_share_red_packet,									param_list=""}, -- 分享红包	
	ship_evolution									={code = 6258, command = "ship_evolution",									command_fun = command_ship_evolution,									param_list=""}, -- 武将进化接口	
	ship_inheritance								={code = 6259, command = "ship_inheritance",								command_fun = command_ship_inheritance,									param_list=""}, -- 传承	
	ship_military_buyrob_count						={code = 6260, command = "ship_military_buyrob_count",						command_fun = command_ship_military_buyrob_count,						param_list=""}, -- 押镖购买次数	
	ship_purify_buy_battle_reward					={code = 6261, command = "ship_purify_buy_battle_reward",					command_fun = command_ship_purify_buy_battle_reward,					param_list=""}, -- 数码净化战斗宝箱	
	ship_purify_init								={code = 6262, command = "ship_purify_init",								command_fun = command_ship_purify_init,									param_list=""}, -- 数码净化初始化接口	
	ship_purify_team_launch							={code = 6263, command = "ship_purify_team_launch",							command_fun = command_ship_purify_team_launch,							param_list=""}, -- 数码净化战斗结算接口	
	ship_purify_team_manager						={code = 6264, command = "ship_purify_team_manager",						command_fun = command_ship_purify_team_manager,							param_list=""}, -- 数码净化队伍管理接口	
	ship_repair_ship_count							={code = 6265, command = "ship_repair_ship_count",							command_fun = command_ship_repair_ship_count,							param_list=""}, -- 修复兵	
	ship_skill_grow_up								={code = 6266, command = "ship_skill_grow_up",								command_fun = command_ship_skill_grow_up,								param_list=""}, -- 玩家技能突破	
	ship_skill_level_up								={code = 6267, command = "ship_skill_level_up",								command_fun = command_ship_skill_level_up,								param_list=""}, -- 武将技能升级接口	
	ship_skill_point_buy							={code = 6268, command = "ship_skill_point_buy",							command_fun = command_ship_skill_point_buy,								param_list=""}, -- 武将购买技能点接口	
	ship_star_up									={code = 6269, command = "ship_star_up",									command_fun = command_ship_star_up,										param_list=""}, -- 将领升星	
	ship_talent_update								={code = 6270, command = "ship_talent_update",								command_fun = command_ship_talent_update,								param_list=""}, -- 将领天赋升级	
	shop_buy										={code = 6271, command = "shop_buy",										command_fun = command_shop_buy,											param_list=""}, -- 商店购买接口	
	shop_request_product_refresh					={code = 6272, command = "shop_request_product_refresh",					command_fun = command_shop_request_product_refresh,						param_list=""}, -- 商店请求刷新接口	
	super_equipment_grow_up							={code = 6273, command = "super_equipment_grow_up",							command_fun = command_super_equipment_grow_up,							param_list=""}, -- 请求进行神兵精炼/突破	
	task_init										={code = 6274, command = "task_init",										command_fun = command_task_init,										param_list=""}, -- 任务初始化(转点重置用)	
	three_kingdoms_draw_score_reward				={code = 6275, command = "three_kingdoms_draw_score_reward",				command_fun = command_three_kingdoms_draw_score_reward,					param_list=""}, -- 领取数码试炼的积分奖励	
	three_kingdoms_launch							={code = 6276, command = "three_kingdoms_launch",							command_fun = command_three_kingdoms_launch,							param_list=""}, -- 数码试炼战斗结算	
	union_active_init								={code = 6277, command = "union_active_init",								command_fun = command_union_active_init,								param_list=""}, -- 军团活跃初始化	
	union_apply_review_update						={code = 6278, command = "union_apply_review_update",						command_fun = command_union_apply_review_update,						param_list=""}, -- 这个修改公会限制	
	union_contest_formation_change					={code = 6279, command = "union_contest_formation_change",					command_fun = command_union_contest_formation_change,					param_list=""}, -- 军团切磋保存阵型	
	union_copy_draw_npc_reward						={code = 6280, command = "union_copy_draw_npc_reward",						command_fun = command_union_copy_draw_npc_reward,						param_list=""}, -- 领取工会副本npc奖励	
	union_copy_fight								={code = 6281, command = "union_copy_fight",								command_fun = command_union_copy_fight,									param_list=""}, -- 获取工会副本战斗	
	union_copy_get_lucky_reward_info				={code = 6282, command = "union_copy_get_lucky_reward_info",				command_fun = command_union_copy_get_lucky_reward_info,					param_list=""}, -- 公会分配接口
	union_copy_init									={code = 6283, command = "union_copy_init",									command_fun = command_union_copy_init,									param_list=""}, -- 军团副本初始化	
	union_copy_look_npc_info						={code = 6284, command = "union_copy_look_npc_info",						command_fun = command_union_copy_look_npc_info,							param_list=""}, -- 查看工会副本npc	
	union_craft_exit								={code = 6285, command = "union_craft_exit",								command_fun = command_union_craft_exit,									param_list=""}, -- 军团争霸界面退出	
	union_craft_init								={code = 6286, command = "union_craft_init",								command_fun = command_union_craft_init,									param_list=""}, -- 军团争霸初始化：	
	union_craft_rank_list_get						={code = 6287, command = "union_craft_rank_list_get",						command_fun = command_union_craft_rank_list_get,						param_list=""}, -- 军团争霸排行榜获取	
	union_craft_signup								={code = 6288, command = "union_craft_signup",								command_fun = command_union_craft_signup,								param_list=""}, -- 军团争霸报名	
	union_donate									={code = 6289, command = "union_donate",									command_fun = command_union_donate,										param_list=""}, -- 军团科技捐献	
	union_name_update								={code = 6290, command = "union_name_update",								command_fun = command_union_name_update,								param_list=""}, -- 这个修改公会名称	
	union_one_key_join								={code = 6291, command = "union_one_key_join",								command_fun = command_union_one_key_join,								param_list=""}, -- 快速加入公会	
	union_person_manage								={code = 6292, command = "union_person_manage",								command_fun = command_union_person_manage,								param_list=""}, -- 申请管理	
	union_red_packet_draw_reward					={code = 6293, command = "union_red_packet_draw_reward",					command_fun = command_union_red_packet_draw_reward,						param_list=""}, -- 抢公会系统红包	
	union_red_packet_rap_manager					={code = 6294, command = "union_red_packet_rap_manager",					command_fun = command_union_red_packet_rap_manager,						param_list=""}, -- 抢公会玩家红包
	union_red_packet_rap_rank						={code = 6295, command = "union_red_packet_rap_rank",						command_fun = command_union_red_packet_rap_rank,						param_list=""}, -- 公会红包各排行榜	
	union_red_packet_send							={code = 6296, command = "union_red_packet_send",							command_fun = command_union_red_packet_send,							param_list=""}, -- 发公会红包	
	union_science_init								={code = 6297, command = "union_science_init",								command_fun = command_union_science_init,								param_list=""}, -- 军团科技初始化	
	union_send_mail									={code = 6298, command = "union_send_mail",									command_fun = command_union_send_mail,									param_list=""}, -- 军团邮件发送	
	union_setting_manage							={code = 6299, command = "union_setting_manage",							command_fun = command_union_setting_manage,								param_list=""}, -- 军团管理设置	
	union_ship_slot_machine_change_result			={code = 6300, command = "union_ship_slot_machine_change_result",			command_fun = command_union_ship_slot_machine_change_result,			param_list=""}, -- 公会老虎机改结果	
	union_ship_slot_machine_draw_reward				={code = 6301, command = "union_ship_slot_machine_draw_reward",				command_fun = command_union_ship_slot_machine_draw_reward,				param_list=""}, -- 公会老虎机领奖	
	union_ship_slot_machine_get_rank				={code = 6302, command = "union_ship_slot_machine_get_rank",				command_fun = command_union_ship_slot_machine_get_rank,					param_list=""}, -- 获取老虎机的排行榜接口	
	union_ship_slot_machine_start_rotate			={code = 6303, command = "union_ship_slot_machine_start_rotate",			command_fun = command_union_ship_slot_machine_start_rotate,				param_list=""}, -- 公会老虎机转	
	union_ship_train								={code = 6304, command = "union_ship_train",								command_fun = command_union_ship_train,									param_list=""}, -- 选择能量屋训练	
	union_ship_train_check							={code = 6305, command = "union_ship_train_check",							command_fun = command_union_ship_train_check,							param_list=""}, -- 能量屋时间	
	union_ship_train_help							={code = 6306, command = "union_ship_train_help",							command_fun = command_union_ship_train_help,							param_list=""}, -- 给成员加速的接口	
	union_ship_train_init							={code = 6307, command = "union_ship_train_init",							command_fun = command_union_ship_train_init,							param_list=""}, -- 能量屋初始化	
	union_ship_train_place_buy						={code = 6308, command = "union_ship_train_place_buy",						command_fun = command_union_ship_train_place_buy,						param_list=""}, -- 能量屋位置开启	
	union_shop_buy									={code = 6309, command = "union_shop_buy",									command_fun = command_union_shop_buy,									param_list=""}, -- 军团商店兑换	
	union_shop_init									={code = 6310, command = "union_shop_init",									command_fun = command_union_shop_init,									param_list=""}, -- 军团商店初始化	
	union_stick_crazy_adventure_draw_reward			={code = 6311, command = "union_stick_crazy_adventure_draw_reward",			command_fun = command_union_stick_crazy_adventure_draw_reward,			param_list=""}, -- 比利的棍子游戏奖励结算接口
	union_welfare_distribute						={code = 6312, command = "union_welfare_distribute",						command_fun = command_union_welfare_distribute,							param_list=""}, -- 军团福利分配	
	user_accumlate_consumption_score_get			={code = 6313, command = "user_accumlate_consumption_score_get",			command_fun = command_user_accumlate_consumption_score_get,				param_list=""}, -- 积分大转盘排行榜信息
	user_info_modify								={code = 6314, command = "user_info_modify",								command_fun = command_user_info_modify,									param_list=""}, -- 修改用户信息接口	
	user_read_mail									={code = 6315, command = "user_read_mail",									command_fun = command_user_read_mail,									param_list=""}, -- 阅读邮件接口	
	user_save_mail									={code = 6316, command = "user_save_mail",									command_fun = command_user_save_mail,									param_list=""}, -- 邮件与信息的保存接口	
	user_send_mail									={code = 6317, command = "user_send_mail",									command_fun = command_user_send_mail,									param_list=""}, -- 用户发送邮件接口	
	user_stronghold_clear_be_rob_cd					={code = 6318, command = "user_stronghold_clear_be_rob_cd",					command_fun = command_user_stronghold_clear_be_rob_cd,					param_list=""}, -- 请求个人战清空碎屏
	user_stronghold_init							={code = 6319, command = "user_stronghold_init",							command_fun = command_user_stronghold_init,								param_list=""}, -- 初始化个人战居所信息	
	user_stronghold_plunder							={code = 6320, command = "user_stronghold_plunder",							command_fun = command_user_stronghold_plunder,							param_list=""}, -- 请求个人战掠夺	
	user_stronghold_plunder_refresh					={code = 6321, command = "user_stronghold_plunder_refresh",					command_fun = command_user_stronghold_plunder_refresh,					param_list=""}, -- 获取个人据点掠夺信息
	user_stronghold_plunder_search					={code = 6322, command = "user_stronghold_plunder_search",					command_fun = command_user_stronghold_plunder_search,					param_list=""}, -- 战报查询用户山庄信息	
	user_stronghold_plunder_view					={code = 6323, command = "user_stronghold_plunder_view",					command_fun = command_user_stronghold_plunder_view,						param_list=""}, -- 获取个人据点掠夺详细信息	
	user_stronghold_revived							={code = 6324, command = "user_stronghold_revived",							command_fun = command_user_stronghold_revived,							param_list=""}, -- 请求个人战复活	
	user_stronghold_view_score_rank					={code = 6325, command = "user_stronghold_view_score_rank",					command_fun = command_user_stronghold_view_score_rank,					param_list=""}, -- 请求获取个人积分排行
	verify_system_time								={code = 6326, command = "verify_system_time",								command_fun = command_verify_system_time,								param_list=""}, -- 同步系统时间	
	world_add_target_event							={code = 6327, command = "world_add_target_event",							command_fun = command_world_add_target_event,							param_list=""}, -- 世界添加事件	
	world_change_user_city_position					={code = 6328, command = "world_change_user_city_position",					command_fun = command_world_change_user_city_position,					param_list=""}, -- 改变自己主城在世界地图上面的坐标
	world_city_bonus_draw							={code = 6329, command = "world_city_bonus_draw",							command_fun = command_world_city_bonus_draw,							param_list=""}, -- 城市战分红领取	
	world_city_boom_recover							={code = 6330, command = "world_city_boom_recover",							command_fun = command_world_city_boom_recover,							param_list=""}, -- 城市战繁荣度恢复	
	world_city_detail_get							={code = 6331, command = "world_city_detail_get",							command_fun = command_world_city_detail_get,							param_list=""}, -- 城市战城市详情	
	world_city_disband								={code = 6332, command = "world_city_disband",								command_fun = command_world_city_disband,								param_list=""}, -- 城市战遣返部队	
	world_city_energy_buy							={code = 6333, command = "world_city_energy_buy",							command_fun = command_world_city_energy_buy,							param_list=""}, -- 城市战能量购买	
	world_city_list_get								={code = 6334, command = "world_city_list_get",								command_fun = command_world_city_list_get,								param_list=""}, -- 请求城市战城市列表	
	world_city_order_list_get						={code = 6335, command = "world_city_order_list_get",						command_fun = command_world_city_order_list_get,						param_list=""}, -- 城市战排行	
	world_city_shop_buy								={code = 6336, command = "world_city_shop_buy",								command_fun = command_world_city_shop_buy,								param_list=""}, -- 城市战商店购买	
	world_city_shop_init							={code = 6337, command = "world_city_shop_init",							command_fun = command_world_city_shop_init,								param_list=""}, -- 城市战商店初始化	
	world_coord_collect								={code = 6338, command = "world_coord_collect",								command_fun = command_world_coord_collect,								param_list=""}, -- 世界地图收藏信息	
	world_exit										={code = 6339, command = "world_exit",										command_fun = command_world_exit,										param_list=""}, -- 世界地图退出接口	
	world_help_defend_set							={code = 6340, command = "world_help_defend_set",							command_fun = command_world_help_defend_set,							param_list=""}, -- 协防的部队设置接口	
	world_info_init									={code = 6341, command = "world_info_init",									command_fun = command_world_info_init,									param_list=""}, -- 世界信息初始化	
	world_info_scout								={code = 6342, command = "world_info_scout",								command_fun = command_world_info_scout,									param_list=""}, -- 世界地图侦察接口	
	world_info_search								={code = 6343, command = "world_info_search",								command_fun = command_world_info_search,								param_list=""}, -- 查看附近的人	
	world_join										={code = 6344, command = "world_join",										command_fun = command_world_join,										param_list=""}, -- 世界地图加入接口	
	world_look_mine_info							={code = 6345, command = "world_look_mine_info",							command_fun = command_world_look_mine_info,								param_list=""}, -- 获取世界地图信息侦查	
	world_map_arena_info_refresh					={code = 6346, command = "world_map_arena_info_refresh",					command_fun = command_world_map_arena_info_refresh,						param_list=""}, -- 世界地图区域信息刷新	
	world_request_help_defend						={code = 6347, command = "world_request_help_defend",						command_fun = command_world_request_help_defend,						param_list=""}, -- 请求协防接口	
	ship_spirit_init								={code = 6348, command = "ship_spirit_init",								command_fun = command_ship_spirit_init,									param_list=""}, -- 数码精神初始化
	ship_spirit_level_up							={code = 6349, command = "ship_spirit_level_up",							command_fun = command_ship_spirit_level_up,								param_list=""}, -- 数码神精升级
	ship_talent_init								={code = 6350, command = "ship_talent_init",								command_fun = command_ship_talent_init,									param_list=""}, -- 请求天赋初始化
	ship_talent_reset								={code = 6351, command = "ship_talent_reset",								command_fun = command_ship_talent_reset,								param_list=""}, -- 请求天赋重制	
	ship_talent_level_up							={code = 6352, command = "ship_talent_level_up",							command_fun = command_ship_talent_level_up,								param_list=""}, -- 请求天赋升级
	the_kings_battle_init							={code = 6353, command = "the_kings_battle_init",							command_fun = command_the_kings_battle_init,							param_list=""}, -- 王者之战初始化接口
	the_kings_battle_manager						={code = 6354, command = "the_kings_battle_manager",						command_fun = command_the_kings_battle_manager,							param_list=""}, -- 王者之战初管理接口
	world_city_army_exchange						={code = 6355, command = "world_city_army_exchange",						command_fun = command_world_city_army_exchange,							param_list=""}, -- 城市战兵种兑换
	world_check_investigate_end_time				={code = 6356, command = "world_check_investigate_end_time",				command_fun = command_world_check_investigate_end_time,					param_list=""}, -- 请求同步侦查时间
	ship_soul_level_up								={code = 6357, command = "ship_soul_level_up",								command_fun = command_ship_soul_level_up,								param_list=""}, -- 武将斗魂升级接口
	shop_frags_init									={code = 6358, command = "shop_frags_init",									command_fun = command_shop_frags_init,									param_list=""}, -- 碎片商店初始化接口
	shop_frags_exchange								={code = 6359, command = "shop_frags_exchange",								command_fun = command_shop_frags_exchange,								param_list=""}, -- 碎片商店兑换接口
	union_send_all_member_mail						={code = 6360, command = "union_send_all_member_mail",						command_fun = command_union_send_all_member_mail,						param_list=""}, -- 工会发送邮件
	union_warfare_init								={code = 6361, command = "union_warfare_init",								command_fun = command_union_warfare_init,								param_list=""}, -- 公会战初始化接口
	union_warfare_manager							={code = 6362, command = "union_warfare_manager",							command_fun = command_union_warfare_manager,							param_list=""}, -- 公会战管理接口
	union_warfare_exit								={code = 6363, command = "union_warfare_exit",								command_fun = command_union_warfare_exit,								param_list=""}, -- 公会战退出接口
	fortune_init									={code = 6364, command = "fortune_init",									command_fun = command_fortune_init,										param_list=""}, -- 大耳有福初始化
	three_kingdoms_sweep							={code = 6365, command = "three_kingdoms_sweep",							command_fun = command_three_kingdoms_sweep,								param_list=""}, -- 试炼扫荡
	treasure_onekey_escalate						={code = 6366, command = "treasure_onekey_escalate",						command_fun = command_treasure_onekey_escalate,							param_list=""}, -- 宝物一键升级
	arena_sweep										={code = 6367, command = "arena_sweep",										command_fun = command_arena_sweep,										param_list=""}, -- 竞技场五次
	ship_rebirth_init								={code = 6368, command = "ship_rebirth_init",								command_fun = command_ship_rebirth_init,								param_list=""}, -- 武将还原初始化接口
	ship_rebirth									={code = 6369, command = "ship_rebirth",									command_fun = command_ship_rebirth,										param_list=""}, -- 武将还原接口
	equipment_rebirth_init							={code = 6370, command = "equipment_rebirth_init",							command_fun = command_equipment_rebirth_init,							param_list=""}, -- 装备还原初始化接口
	equipment_rebirth								={code = 6371, command = "equipment_rebirth",								command_fun = command_equipment_rebirth,								param_list=""}, -- 装备还原接口
	artifact_init									={code = 6372, command = "artifact_init",									command_fun = command_artifact_init,									param_list=""}, -- 神器初始化
	artifact_unlock									={code = 6373, command = "artifact_unlock",									command_fun = command_artifact_unlock,									param_list=""}, -- 神器解锁
	artifact_culture								={code = 6374, command = "artifact_culture",								command_fun = command_artifact_culture,									param_list=""}, -- 神器培养
	artifact_confirm								={code = 6375, command = "artifact_confirm",								command_fun = command_artifact_confirm,									param_list=""}, -- 神器保存
	platform_user_register							={code = 9001, command = "platform_user_register",							command_fun = command_platform_user_register,							param_list=""}, -- 新平台用户注册
	platform_user_login								={code = 9002, command = "platform_user_login",								command_fun = command_platform_user_login,								param_list=""}, -- 新平台用户登陆
	platform_user_modify_password					={code = 9003, command = "platform_user_modify_password",					command_fun = command_platform_user_modify_password,					param_list=""}, -- 新平台修改密码
	bi_forward										={code = 9004, command = "bi_forward",										command_fun = command_bi_forward,										param_list=""}, -- 自己的数据打点报送
	get_copy_clear_user_info						={code = 9005, command = "get_copy_clear_user_info",						command_fun = command_get_copy_clear_user_info,							param_list=""}, --  获取副本通关用户信息接口	
	ship_praise										={code = 9006, command = "ship_praise",										command_fun = command_ship_praise,										param_list=""}, --  武将点赞	

	linkage_bind									={code = 9007, command = "linkage_bind",									command_fun = command_linkage_bind,										param_list=""}, -- 返回在联动界面点击请求需要有联动成功提示
	linkage_check_server							={code = 9008, command = "linkage_check_server",							command_fun = command_linkage_check_server,								param_list=""}, -- 返回在hg登录后请求，如果返回服务器id大于0，则限定只能登陆这个服务器
	mystical_shop_buy								={code = 9009, command = "mystical_shop_buy",								command_fun = command_mystical_shop_buy,								param_list=""}, -- 神秘商店购买接口
	mystical_shop_refresh							={code = 9010, command = "mystical_shop_refresh",							command_fun = command_mystical_shop_refresh,							param_list=""}, -- 神秘商店刷新接口
	user_title_modify								={code = 9011, command = "user_title_modify",								command_fun = command_user_title_modify,								param_list=""}, -- 修改用户头衔接口
	find_password									={code = 9012, command = "find_password",									command_fun = command_find_password,									param_list=""}, -- 找回密码
	five_star_praise								={code = 9013, command = "five_star_praise",								command_fun = command_five_star_praise,									param_list=""}, -- 5星好评接口
	draw_achievement_reward							={code = 9014, command = "draw_achievement_reward",							command_fun = command_draw_achievement_reward,							param_list=""}, -- 领取成就奖励
	ship_skin_buy 									={code = 9015, command = "ship_skin_buy", 									command_fun = command_ship_skin_buy, 									param_list=""}, --购买皮肤
	ship_skin_use 									={code = 9016, command = "ship_skin_use", 									command_fun = command_ship_skin_use, 									param_list=""}, --使用皮肤
	union_ship_train_exit							={code = 9017, command = "union_ship_train_exit",							command_fun = command_union_ship_train_exit,							param_list=""}, -- 工会能量会退出
	get_hard_copy_user_formation					={code = 9018, command = "get_hard_copy_user_formation",					command_fun = command_get_hard_copy_user_formation,						param_list=""}, -- 获取噩梦副本用户阵形接口
	save_hard_copy_user_formation					={code = 9019, command = "save_hard_copy_user_formation",					command_fun = command_save_hard_copy_user_formation,					param_list=""}, -- 保存噩梦副本用户阵形接口				
	face_book_share_complete						={code = 9020, command = "face_book_share_complete",						command_fun = command_face_book_share_complete,							param_list=""}, -- facebook 分享成功
	constellation_buy 								={code = 9021, command = "constellation_buy",								command_fun = command_constellation_buy,								param_list=""}, -- 星座守护购买
	constellation_exchange							={code = 9022, command = "constellation_exchange",							command_fun = command_constellation_exchange,							param_list=""}, -- 星座守护使用
	cross_mine_init									={code = 9023, command = "cross_mine_init",									command_fun = command_cross_mine_init,									param_list=""}, -- 跨服矿战用户信息初始化
	cross_mine_user_shop_buy						={code = 9024, command = "cross_mine_user_shop_buy",						command_fun = command_cross_mine_user_shop_buy,							param_list=""}, -- 跨服矿战商店信息、购买 -- 第四个参数-1获取商店信息
	cross_mine_user_feed 							={code = 9025, command = "cross_mine_user_feed",							command_fun = command_cross_mine_user_feed,								param_list=""}, -- 跨服矿战喂养 -- 类型和喂养ID都是-1 获取喂养信息
	cross_mine_order_info							={code = 9026, command = "cross_mine_order_info",							command_fun = command_cross_mine_order_info,							param_list=""}, -- 跨服矿战排行
	cross_mine_user_formation 						={code = 9027, command = "cross_mine_user_formation",						command_fun = command_cross_mine_user_formation,						param_list=""}, -- 跨服矿战阵型信息	
	ship_potential_up								={code = 9028, command = "ship_potential_up",								command_fun = command_ship_potential_up,								param_list=""}, -- 潜能
	cross_mine_user_do_loot 						={code = 9029, command = "cross_mine_user_do_loot",							command_fun = command_cross_mine_user_do_loot,							param_list=""}, -- 抢矿阵容信息
	cross_mine_load_battle_info 					={code = 9030, command = "cross_mine_load_battle_info",						command_fun = command_cross_mine_load_battle_info,						param_list=""}, -- 请求跨服矿战战斗信息
	cross_mine_user_lounch_refresh 					={code = 9031, command = "cross_mine_user_lounch_refresh",					command_fun = command_cross_mine_user_lounch_refresh,					param_list=""}, -- 普通矿区换一批刷新
	cross_mine_load_all_loot_info 					={code = 9032, command = "cross_mine_load_all_loot_info",					command_fun = command_cross_mine_load_all_loot_info,					param_list=""}, -- 跨服矿战战报信息
	cross_mine_user_join_not_open					={code = 9033, command = "cross_mine_user_join_not_open",					command_fun = command_cross_mine_user_join_not_open,					param_list=""}, -- 跨服矿战未开启时排行信息
	cross_mine_buy_loot_or_revenge					={code = 9034, command = "cross_mine_buy_loot_or_revenge",					command_fun = command_cross_mine_buy_loot_or_revenge,					param_list=""}, -- 跨服矿战抢矿复仇次数
	cross_mine_revenge 								={code = 9035, command = "cross_mine_revenge",								command_fun = command_cross_mine_revenge,								param_list=""}, -- 跨服矿战抢矿复仇 -- 1请求复仇数据 2进入复仇战斗
	cross_mine_get_rank_formation					={code = 9036, command = "cross_mine_get_rank_formation",					command_fun = command_cross_mine_get_rank_formation,					param_list=""}, -- 跨服矿战获取前三阵容

	ship_metal_set									={code = 9037, command = "ship_metal_set",									command_fun = command_ship_metal_set,									param_list=""}, -- 矩阵添加、卸载合金
	ship_metal_escalate								={code = 9038, command = "ship_metal_escalate",								command_fun = command_ship_metal_escalate,								param_list=""}, -- 强化 0:普通 1:一键
	ship_metal_dissolve 							={code = 9039, command = "ship_metal_dissolve", 							command_fun = command_ship_metal_dissolve,								param_list=""}, -- 熔炼
	draw_matrix_reward								={code = 9040, command = "draw_matrix_reward", 								command_fun = command_draw_matrix_reward,								param_list=""}, -- 矩阵激活奖励接口
	ship_metal_onekey_escalate 						={code = 9041, command = "ship_metal_onekey_escalate",						command_fun = command_ship_metal_onekey_escalate,						param_list=""}, -- 一键强化

	reward_happy_n_day 								={code = 9042, command = "reward_happy_n_day",								command_fun = command_reward_happy_n_day,								param_list=""}, -- 七天乐活动领奖

	fileIslandEnter 								={code = 9043, command = "file_island_enter",								command_fun = command_fileIslandEnter,									param_list=""}, -- 进入文件岛
	fileIslandSearch 								={code = 9044, command = "file_island_search",								command_fun = command_fileIslandSearch,									param_list=""}, -- 探索文件岛
	fileIslandSearchPointBuy 						={code = 9045, command = "file_island_search_point_buy",					command_fun = command_fileIslandSearchPointBuy,							param_list=""}, -- 购买探索点
	fileIslandBossInfo 								={code = 9046, command = "file_island_boss_info",							command_fun = command_fileIslandBossInfo,								param_list=""}, -- 获取团队Boss信息
	fileIslandTaskInfo 								={code = 9047, command = "file_island_task_info",							command_fun = command_fileIslandTaskInfo,								param_list=""}, -- 获取好友任务信息
	fileIslandHolyThingsInfo 						={code = 9048, command = "file_island_holy_things_info",					command_fun = command_fileIslandHolyThingsInfo,							param_list=""}, -- 获取圣物信息
	fileIslandSearchRewardInfo 						={code = 9049, command = "file_island_search_reward_info",					command_fun = command_fileIslandSearchRewardInfo,						param_list=""}, -- 处理探索结果
	fileIslandHolyThingUnlock 						={code = 9050, command = "file_island_holy_thing_unlock",					command_fun = command_fileIslandHolyThingUnlock,						param_list=""}, -- 圣物解锁
	fileIslandHolyThingLevUp 						={code = 9051, command = "file_island_holy_thing_levup",					command_fun = command_fileIslandHolyThingLevUp,							param_list=""}, -- 圣物升级
	fileIslandTaskRelease 							={code = 9052, command = "file_island_task_release",						command_fun = command_fileIslandTaskRelease,							param_list=""}, -- 任务邀请/发布
	fileIslandSingleChallenge 						={code = 9053, command = "file_island_single_challenge",					command_fun = command_fileIslandSingleChallenge,						param_list=""}, -- 单人挑战
	fileIslandSingleChallengeCancle 				={code = 9054, command = "file_island_single_challenge_cancel",				command_fun = command_fileIslandSingleChallengeCancle,					param_list=""}, -- 取消单人挑战
	fileIslandRewardBoxBuy 							={code = 9055, command = "file_island_reward_box_buy",						command_fun = command_fileIslandRewardBoxBuy,							param_list=""}, -- 奖励宝箱购买
	fileIslandAnswer 								={code = 9056, command = "file_island_answer",								command_fun = command_fileIslandAnswer,									param_list=""}, -- 答题
	fileIslandFriendTaskJoin 						={code = 9057, command = "file_island_friend_task_join",					command_fun = command_fileIslandFriendTaskJoin,							param_list=""}, -- 加入好友任务
	fileIslandFriendTaskExecute 					={code = 9058, command = "file_island_friend_task_execute",					command_fun = command_fileIslandFriendTaskExecute,						param_list=""}, -- 执行好友任务
	fileIslandFriendTaskReward 						={code = 9059, command = "file_island_friend_task_reward",					command_fun = command_fileIslandFriendTaskReward,						param_list=""}, -- 好友任务奖励
	fileIslandShopInfo 								={code = 9060, command = "file_island_shop_info",							command_fun = command_fileIslandShopInfo,								param_list=""}, -- 商店信息
	fileIslandShopThingsBuy 						={code = 9061, command = "file_island_shop_things_buy",						command_fun = command_fileIslandShopThingsBuy,							param_list=""}, -- 商店购买
	composeEquip 									={code = 9062, command = "compose_equip",									command_fun = command_composeEquip,										param_list=""}, -- 合成装备
	refreshSearchPoint								={code = 9063, command = "file_island_refresh_search_point",				command_fun = command_refreshSearchPoint,								param_list=""}, -- 刷新探索点
	file_island_finish_search_result				={code = 9064, command = "file_island_finish_search_result",				command_fun = command_file_island_finish_search_result,					param_list=""}, -- 空岛探索结束探索结果
	file_island_single_challenge_cancel 			={code = 9065, command = "file_island_single_challenge_cancel",				command_fun = command_file_island_single_challenge_cancel,				param_list=""}, -- 空岛探索取消单个挑战
	file_island_boss_challenge 						={code = 9066, command = "file_island_boss_challenge",						command_fun = command_file_island_boss_challenge,						param_list=""}, -- 挑战boss
	file_island_dispose_next_search_eventId   		={code = 9067, command = "file_island_dispose_next_search_eventId",			command_fun = command_file_island_dispose_next_search_eventId,			param_list=""}, -- 挑战boss

	draw_google_bind_reward 						={code = 9068, command = "draw_google_bind_reward",							command_fun = command_draw_google_bind_reward,							param_list=""}, -- 绑定谷歌账号奖励领取
	google_bind_hotgame								={code = 9069, command = "google_bind_hotgame",								command_fun = command_google_bind_hotgame,								param_list=""}, -- 绑定谷歌账号
	cross_mine_ref_user_mine_and_server_info		={code = 9070, command = "cross_mine_ref_user_mine_and_server_info",		command_fun = command_cross_mine_ref_user_mine_and_server_info,			param_list=""}, -- 请求矿战服务器排行刷新
	reward_grow_by_level							={code = 9071, command = "reward_grow_by_level",							command_fun = command_reward_grow_by_level,								param_list=""}, -- 成长之路奖励领取
	activity_refresh								={code = 9072, command = "activity_refresh",								command_fun = command_activity_refresh,									param_list=""}, -- 成长之路活动刷新
	pokemon_explore_enter							={code = 9073, command = "pokemon_explore_enter",							command_fun = command_pokemon_explore_enter,							param_list=""}, -- 进入探索
	pokemon_explore_search_point_buy				={code = 9074, command = "pokemon_explore_search_point_buy",				command_fun = command_pokemon_explore_search_point_buy,					param_list=""}, -- 探索点购买
	pokemon_explore_search							={code = 9075, command = "pokemon_explore_search",							command_fun = command_pokemon_explore_search,							param_list=""}, -- 探索
	pokemon_explore_dispose_next_search_eventId		={code = 9076, command = "pokemon_explore_dispose_next_search_eventId",		command_fun = command_pokemon_explore_dispose_next_search_eventId,		param_list=""}, -- 口袋探索处理下一个事件类型
	exlore_achievement_unlock		                ={code = 9077, command = "exlore_achievement_unlock",		                command_fun = command_exlore_achievement_unlock,		                param_list=""}, -- 探索图鉴属性激活
	explore_achievement_level_up_talent		        ={code = 9078, command = "explore_achievement_level_up_talent",		        command_fun = command_explore_achievement_level_up_talent,		        param_list=""}, -- 探索图鉴属性升级
	pokemon_explore_reward_box_buy		        	={code = 9079, command = "pokemon_explore_reward_box_buy",		        	command_fun = command_pokemon_explore_reward_box_buy,		        	param_list=""}, -- 探索购买宝箱
	pokemon_explore_finish_search_result		    ={code = 9080, command = "pokemon_explore_finish_search_result",		    command_fun = command_pokemon_explore_finish_search_result,		        param_list=""}, -- 探索结束探索结果
	pokemon_explore_single_challenge		    	={code = 9081, command = "pokemon_explore_single_challenge",		    	command_fun = command_pokemon_explore_single_challenge,		        	param_list=""}, -- 探索结束探索结果
	pokemon_explore_score_reward		    		={code = 9082, command = "pokemon_explore_score_reward",		    		command_fun = command_pokemon_explore_score_reward,		        		param_list=""}, -- 探索领取积分奖励
	draw_reward_main		    					={code = 9083, command = "draw_reward_main",		    					command_fun = command_draw_reward_main,		        					param_list=""}, -- 抽卡优化
	pokemon_explore_refresh_search_point			={code = 9084, command = "pokemon_explore_refresh_search_point",			command_fun = command_pokemon_explore_refresh_search_point,				param_list=""}, -- 探索点刷新
	monopoly_throw									={code = 9085, command = "monopoly_throw",									command_fun = command_monopoly_throw,									param_list=""}, -- 皮卡丘活动投掷骰子
	monopoly_move_end								={code = 9086, command = "monopoly_move_end",								command_fun = command_monopoly_move_end,								param_list=""}, -- 皮卡丘活动行走结束
	monopoly_finger_game							={code = 9087, command = "monopoly_finger_game",							command_fun = command_monopoly_finger_game,								param_list=""}, -- 皮卡丘活动猜拳
	monololy_open_cheast							={code = 9088, command = "monololy_open_cheast",							command_fun = command_monololy_open_cheast,								param_list=""}, -- 开宝箱
	treasures_draw									={code = 9089, command = "treasures_draw",									command_fun = command_treasures_draw,									param_list=""}, -- 抽奖
	treasures_refresh								={code = 9090, command = "treasures_refresh",								command_fun = command_treasures_refresh,								param_list=""}, -- 刷新
	treasures_shop_buy								={code = 9091, command = "treasures_shop_buy",								command_fun = command_treasures_shop_buy,								param_list=""}, -- 秘宝商店
	treasures_shop_info								={code = 9092, command = "treasures_shop_info",								command_fun = command_treasures_shop_info,								param_list=""}, -- 商店
    activity_time_limit_rank_init                   ={code = 9093, command = "activity_time_limit_rank_init",	                command_fun = command_activity_time_limit_rank_init,                    param_list=""}, -- 进入跨服排行
    activity_time_limit_rank_order                  ={code = 9094, command = "activity_time_limit_rank_order",	                command_fun = command_activity_time_limit_rank_order,                   param_list=""}, -- 从排行奖励跳转跨服排行榜    
    pokemon_explore_shop_info                  		={code = 9095, command = "pokemon_explore_shop_info",	                	command_fun = command_pokemon_explore_shop_info,                   		param_list=""}, -- 探索商店信息    
    pokemon_explore_answer                  		={code = 9096, command = "pokemon_explore_answer",	                		command_fun = command_pokemon_explore_answer,                   		param_list=""}, -- 探索答题结果    
    pokemon_explore_boss_info                  		={code = 9097, command = "pokemon_explore_boss_info",	                	command_fun = command_pokemon_explore_boss_info,                   		param_list=""}, -- 探索boss信息    
    pokemon_explore_single_challenge_cancel         ={code = 9098, command = "pokemon_explore_single_challenge_cancel",	        command_fun = command_pokemon_explore_single_challenge_cancel,         	param_list=""}, -- 探索取消单人挑战    
    pokemon_explore_shop_things_buy         		={code = 9099, command = "pokemon_explore_shop_things_buy",	        		command_fun = command_pokemon_explore_shop_things_buy,         			param_list=""}, -- 探索商店购买   
    pokemon_explore_rank_info                       ={code = 9100, command = "pokemon_explore_rank_info",	                    command_fun = command_pokemon_explore_rank_info,                        param_list=""}, -- 进入探索排行
    pokemon_explore_map_catch_buy                   ={code = 9101, command = "pokemon_explore_map_catch_buy",	                command_fun = command_pokemon_explore_map_catch_buy,                    param_list=""}, -- 口袋探索捕捉购买次数
    pokemon_explore_map_catch_hit                   ={code = 9102, command = "pokemon_explore_map_catch_hit",	                command_fun = command_pokemon_explore_map_catch_hit,                    param_list=""}, -- 口袋探索捕捉出手
    pokemon_explore_map_catch_over                  ={code = 9103, command = "pokemon_explore_map_catch_over",	                command_fun = command_pokemon_explore_map_catch_over,                   param_list=""}, -- 口袋探索捕捉结束
    pokemon_explore_map_catch_enter                 ={code = 9104, command = "pokemon_explore_map_catch_enter",	                command_fun = command_pokemon_explore_map_catch_enter,                  param_list=""}, -- 口袋探索捕捉进入
    pokemon_explore_map_catch_cancel                ={code = 9105, command = "pokemon_explore_map_catch_cancel",	            command_fun = command_pokemon_explore_map_catch_cancel,                 param_list=""}, -- 口袋探索捕捉取消
    pokemon_explore_boss_challenge                	={code = 9106, command = "pokemon_explore_boss_challenge",	            	command_fun = command_pokemon_explore_boss_challenge,                 	param_list=""}, -- 口袋探索捕捉boss挑战完成
    mega_unblock                                    ={code = 9107, command = "mega_unblock",	            	                command_fun = command_mega_unblock,                 	                param_list=""}, -- 口袋超进化大阶数解锁
    mega_level_up                                   ={code = 9108, command = "mega_level_up",	            	                command_fun = command_mega_level_up,                 	                param_list=""}, -- 口袋超进化小阶数解锁
    mega_use_skill                                  ={code = 9109, command = "mega_use_skill",	            	                command_fun = command_mega_use_skill,                 	                param_list=""}, -- 口袋超进化八门使用技能
    pokemon_explore_event_touch                     ={code = 9110, command = "pokemon_explore_event_touch",	            	    command_fun = command_pokemon_explore_event_touch,                 	    param_list=""}, -- 口袋探索事件触碰
    pokemon_explore_single_event_finish             ={code = 9111, command = "pokemon_explore_single_event_finish",	            command_fun = command_pokemon_explore_single_event_finish,              param_list=""}, -- 口袋探索单个事件结束
    activity_red_packet_init                        ={code = 9112, command = "activity_red_packet_init",	                    command_fun = command_activity_red_packet_init,                         param_list=""}, -- 节日红包进入红包界面
    activity_send_red_packet                        ={code = 9113, command = "activity_send_red_packet",	            	    command_fun = command_activity_send_red_packet,                         param_list=""}, -- 发送红包
    activity_draw_red_packet                        ={code = 9114, command = "activity_draw_red_packet",	                    command_fun = command_activity_draw_red_packet,                       	param_list=""}, -- 领取红包
    pokemon_world_boss_init                        	={code = 9115, command = "pokemon_world_boss_init",	                    	command_fun = command_pokemon_world_boss_init,                       	param_list=""}, -- 世界boss初始化
    world_boss_attack_start                        	={code = 9116, command = "world_boss_attack_start",	                    	command_fun = command_world_boss_attack_start,                       	param_list=""}, -- 获取世界boss战斗信息
    world_boss_attack_finish                        ={code = 9117, command = "world_boss_attack_finish",	                    command_fun = command_world_boss_attack_finish,                       	param_list=""}, -- 发送世界boss战斗结束
    world_boss_change_formation                     ={code = 9118, command = "world_boss_change_formation",	                    command_fun = command_world_boss_change_formation,                      param_list=""}, -- 世界boss挑战阵容
    world_boss_ref_cd                     			={code = 9119, command = "world_boss_ref_cd",	                    		command_fun = command_world_boss_ref_cd,                      			param_list=""}, -- 世界boss挑战刷新
    world_boss_get_order                     		={code = 9120, command = "world_boss_get_order",	                    	command_fun = command_world_boss_get_order,                      		param_list=""}, -- 世界boss挑战排行
    world_boss_draw_task_reward                     ={code = 9121, command = "world_boss_draw_task_reward",	                    command_fun = command_world_boss_draw_task_reward,                      param_list=""}, -- 世界boss 每日领奖
    soul_gruad_un_lock                              ={code = 9122, command = "soul_gruad_un_lock",	                            command_fun = command_soul_gruad_un_lock,                               param_list=""}, -- 灵魂守卫解锁
    soul_gruad_level_up                             ={code = 9123, command = "soul_gruad_level_up",	                            command_fun = command_soul_gruad_level_up,                              param_list=""}, -- 灵魂守卫升级
    soul_gruad_use_ship_mould                       ={code = 9124, command = "soul_gruad_use_ship_mould ",	                    command_fun = command_soul_gruad_use_ship_mould ,                       param_list=""}, -- 灵魂守卫上阵
    activity_pokemon_master_show_task               ={code = 9125, command = "activity_pokemon_master_show_task ",	            command_fun = command_activity_pokemon_master_show_task ,               param_list=""}, -- 大师训练营任务
    activity_pokemon_master_init                    ={code = 9126, command = "activity_pokemon_master_init ",	                command_fun = command_activity_pokemon_master_init ,                    param_list=""}, -- 大师训练营奖励
    activity_pokemon_master_exchage_reward          ={code = 9127, command = "activity_pokemon_master_exchage_reward",	        command_fun = command_activity_pokemon_master_exchage_reward,           param_list=""}, -- 大师训练营兑换
    activity_pokemon_master_buy_master              ={code = 9128, command = "activity_pokemon_master_buy_master",	            command_fun = command_activity_pokemon_master_buy_master,               param_list=""}, -- 大师训练营购买
    activity_pokemon_master_get_reward              ={code = 9129, command = "activity_pokemon_master_get_reward",	            command_fun = command_activity_pokemon_master_get_reward,               param_list=""}, -- 大师训练营领取
    activity_pokemon_master_buy_level               ={code = 9130, command = "activity_pokemon_master_buy_level",	            command_fun = command_activity_pokemon_master_buy_level,                param_list=""}, -- 大师训练营购买等级经验
    activity_pokemon_master_get_exp                 ={code = 9131, command = "activity_pokemon_master_get_exp",	           	    command_fun = command_activity_pokemon_master_get_exp,                  param_list=""}, -- 大师训练营经验盒子
    activity_pokemon_master_one_key                 ={code = 9132, command = "activity_pokemon_master_one_key",	           	    command_fun = command_activity_pokemon_master_one_key,                  param_list=""}, -- 一键领取
	ship_skill_level_up_one_key						={code = 9133, command = "ship_skill_level_up_one_key",						command_fun = command_ship_skill_level_up_one_key,						param_list=""}, -- 技能一键升级接口
    activity_pockmon_rescue_exchange                ={code = 9134, command = "activity_pockmon_rescue_exchange",				command_fun = command_activity_pockmon_rescue_exchange,				    param_list=""}, -- 救助站购买
	activity_pockmon_rescue_donation_item           ={code = 9135, command = "activity_pockmon_rescue_donation_item",		    command_fun = command_activity_pockmon_rescue_donation_item,		    param_list=""}, -- 救助站捐赠
 	activity_pockmon_rescue_get_cross_rank          ={code = 9136, command = "activity_pockmon_rescue_get_cross_rank",		    command_fun = command_activity_pockmon_rescue_get_cross_rank,		    param_list=""}, -- 救助站排行榜
    activity_pockmon_rescue_show_task               ={code = 9137, command = "activity_pockmon_rescue_show_task",		        command_fun = command_activity_pockmon_rescue_show_task,		        param_list=""}, -- 救助站任务闪光
    activity_pockmon_rescue_draw_ultimate_reward    ={code = 9138, command = "activity_pockmon_rescue_draw_ultimate_reward",    command_fun = command_activity_pockmon_rescue_draw_ultimate_reward,		param_list=""}, -- 救助站盒子
    ship_slik_bag_use 				 				={code = 9139, command = "ship_slik_bag_use",    							command_fun = command_ship_slik_bag_use,								param_list=""}, -- 装备锦囊
    ship_slik_bag_un_use 				 			={code = 9140, command = "ship_slik_bag_un_use",    						command_fun = command_ship_slik_bag_un_use,								param_list=""}, -- 卸下锦囊
    ship_slik_bag_level_up 				 			={code = 9141, command = "ship_slik_bag_level_up",    						command_fun = command_ship_slik_bag_level_up,							param_list=""}, -- 锦囊升级
    ship_slik_bag_promote 				 			={code = 9142, command = "ship_slik_bag_promote",    						command_fun = command_ship_slik_bag_promote,							param_list=""}, -- 锦囊突破
    ship_slik_bag_change_mould 				 		={code = 9143, command = "ship_slik_bag_change_mould",    					command_fun = command_ship_slik_bag_change_mould,						param_list=""}, -- 锦囊置换
    ship_slik_bag_resolve 				 		    ={code = 9144, command = "ship_slik_bag_resolve",    						command_fun = command_ship_slik_bag_resolve,						    param_list=""}, -- 锦囊分解
    ship_slik_bag_one_key_level_up 				 	={code = 9145, command = "ship_slik_bag_one_key_level_up",    				command_fun = command_ship_slik_bag_one_key_level_up,				    param_list=""}, -- 一键升级
	get_lucky_divine_info  							={code = 9146, command = "get_lucky_divine_info",   				command_fun = command_get_lucky_divine_info,		param_list=""}, -- 幸运占卜
	lucky_divine			  						={code = 9147, command = "lucky_divine",   		  							command_fun = command_lucky_divine,	 				param_list=""}, -- 幸运占卜
	get_lucky_divine_rank_info			  			={code = 9148, command = "get_lucky_divine_rank_info",   		  			command_fun = command_get_lucky_divine_rank_info,	 				param_list=""}, -- 幸运占卜
	the_kings_battle_self_change_formation			={code = 9149, command = "the_kings_battle_self_change_formation",			command_fun = command_the_kings_battle_self_change_formation,			param_list=""},	--跨服王者之战阵容新增或变化
	the_kings_battle_self_bottom_pour				={code = 9150, command = "the_kings_battle_self_bottom_pour",				command_fun = command_the_kings_battle_self_bottom_pour,				param_list=""},	--跨服王者之战下注
	the_kings_battle_cross_base_get_battle_report	={code = 9151, command = "the_kings_battle_cross_base_get_battle_report",	command_fun = command_the_kings_battle_cross_base_get_battle_report,		param_list=""},	--跨服王者请求文字战报
	the_kings_battle_self_match_info				={code = 9152, command = "the_kings_battle_self_match_info",				command_fun = command_the_kings_battle_self_match_info,					param_list=""},	--跨服王者之战 战半匹配战报
	the_kings_battle_self_battle_peakedness_duel_info	={code = 9153, command = "the_kings_battle_self_battle_peakedness_duel_info",		command_fun = command_the_kings_battle_self_battle_peakedness_duel_info,	param_list=""},--跨服王者决赛战报
	the_kings_battle_self_battle_rank				={code = 9154, command = "the_kings_battle_self_battle_rank",				command_fun = command_the_kings_battle_self_battle_rank,				param_list=""},	--跨服王者排行信息
	the_kings_battle_self_get_other_info			={code = 9155, command = "the_kings_battle_self_get_other_info",			command_fun = command_the_kings_battle_self_get_other_info,				param_list=""},	--跨服王者别人的阵型 
	the_kings_battle_self_get_battle_report			={code = 9156, command = "the_kings_battle_self_get_battle_report",			command_fun = command_the_kings_battle_self_get_battle_report,				param_list=""},	--跨服王者战斗回放
	the_kings_battle_self_init						={code = 9157, command = "the_kings_battle_self_init",						command_fun = command_the_kings_battle_self_init,						param_list=""}, -- 跨服王者之战初始化接口
	the_kings_battle_self_apply						={code = 9158, command = "the_kings_battle_self_apply",						command_fun = command_the_kings_battle_self_apply,						param_list=""}, -- 9147 跨服王者之战阵容报名
	new_bi_log_cmd 				 	                ={code = 9159, command = "new_bi_log_cmd",    				                command_fun = command_new_bi_log_cmd,				                    param_list=""}, -- 记录玩家行动打点数据		
	combine_ship_init								={code = 9160, command = "combine_ship_init",								command_fun = command_combine_ship_init,								param_list=""}, -- 9160 组合卡初始化
	combine_ship_unlock_card						={code = 9161, command = "combine_ship_unlock_card",						command_fun = command_combine_ship_unlock_card,							param_list=""}, -- 9161 组合卡请求解锁
	combine_ship_unlock_slot						={code = 9162, command = "combine_ship_unlock_slot",						command_fun = command_combine_ship_unlock_slot,							param_list=""}, -- 9162 解锁组合卡槽位
	combine_ship_change_slot						={code = 9163, command = "combine_ship_change_slot",						command_fun = command_combine_ship_change_slot,							param_list=""}, -- 9163 更改组合卡槽位角色
	combine_ship_update_slot						={code = 9164, command = "combine_ship_update_slot",						command_fun = command_combine_ship_update_slot,							param_list=""}, -- 9164 组合卡槽位升级升阶
	combine_ship_debris_exchange					={code = 9165, command = "combine_ship_debris_exchange",					command_fun = command_combine_ship_debris_exchange,						param_list=""}, -- 9165 组合卡碎片兑换
	combine_ship_slot_field							={code = 9166, command = "combine_ship_slot_field",							command_fun = command_combine_ship_slot_field,							param_list=""}, -- 9166 组合卡镶嵌槽英雄上阵下阵
	combine_ship_filed_expansion					={code = 9167, command = "combine_ship_filed_expansion",					command_fun = command_combine_ship_filed_expansion,						param_list=""}, -- 9167 组合卡可上阵数量扩展
	combine_ship_get_one							={code = 9168, command = "combine_ship_get_one",							command_fun = command_combine_ship_get_one,								param_list=""}, -- 9168 获取单个组合卡信息
	lucky_pull_rod_init  							={code = 9169, command = "lucky_pull_rod_init",   				command_fun = command_lucky_pull_rod_init,		param_list=""}, --  幸运拉霸
	lucky_pull_rod_start  							={code = 9170, command = "lucky_pull_rod_start",   				command_fun = command_lucky_pull_rod_start,		param_list=""}, --  开始拉霸
	get_lucky_pull_rod_lottery_record  				={code = 9171, command = "get_lucky_pull_rod_lottery_record",   command_fun = command_get_lucky_pull_rod_lottery_record,		param_list=""}, --  获取拉霸活动抽奖记录
	privilege_card_init  							={code = 9172, command = "privilege_card_init",   				command_fun = command_privilege_card_init,		param_list=""}, --  请求特权卡初始化
	privilege_card_get_reward  						={code = 9173, command = "privilege_card_get_reward",   				command_fun = command_privilege_card_get_reward,		param_list=""}, --  获取特权卡首次奖励
	old_user_back_seven_day_init  					={code = 9174, command = "old_user_back_seven_day_init",   					command_fun = command_old_user_back_seven_day_init,							param_list=""}, --  用户回归七日连续登录初始化
	old_user_back_seven_day_get_reward  			={code = 9175, command = "old_user_back_seven_day_get_reward",   			command_fun = command_old_user_back_seven_day_get_reward,					param_list=""}, --  用户回归七日连续登录领奖
	old_user_back_recharge_init  					={code = 9176, command = "old_user_back_recharge_init",   					command_fun = command_old_user_back_recharge_init,							param_list=""}, --  用户回归充值初始化
	old_user_back_recharge_get_reward  				={code = 9177, command = "old_user_back_recharge_get_reward",   			command_fun = command_old_user_back_recharge_get_reward,					param_list=""}, --  用户回归充值领奖
	old_user_back_reward_happy_n_day  				={code = 9178, command = "old_user_back_reward_happy_n_day",   				command_fun = command_old_user_back_reward_happy_n_day,						param_list=""}, --  用户回归七日乐领奖
	activity_fortune_cat_init   					={code = 9179, command = "activity_fortune_cat_init",   					command_fun = command_activity_fortune_cat_init,						param_list=""}, -- 金猪纳宝初始化
    activity_fortune_cat_draw   					={code = 9180, command = "activity_fortune_cat_draw",   					command_fun = command_activity_fortune_cat_draw,						param_list=""}, -- 金猪纳宝抽取砖石
	union_assistance_init							={code = 9181, command = "union_assistance_init",   					command_fun = command_union_assistance_init,		param_list=""}, --  公会援助初始化
	union_assistance_donate  						={code = 9182, command = "union_assistance_donate",   					command_fun = command_union_assistance_donate,		param_list=""}, --  公会捐赠
	union_assistance_seek_help  					={code = 9183, command = "union_assistance_seek_help",   				command_fun = command_union_assistance_seek_help,		param_list=""}, --  公会求助
	union_assistance_all_record  					={code = 9184, command = "union_assistance_all_record",   				command_fun = command_union_assistance_all_record,		param_list=""}, --  公会援助记录
	old_user_back_recharge_close  					={code = 9185, command = "old_user_back_recharge_close",   				command_fun = command_old_user_back_recharge_close,							param_list=""}, --  用户回归充值关闭
	old_user_back_seven_day_close  					={code = 9186, command = "old_user_back_seven_day_close",   			command_fun = command_old_user_back_seven_day_close,						param_list=""}, --  用户回归七日乐关闭
	user_card_info_activate  						={code = 9187, command = "user_card_info_activate",   					command_fun = command_user_card_info_activate,								param_list=""}, --  卡册激活接口
	user_card_info_advance  						={code = 9188, command = "user_card_info_advance",   					command_fun = command_user_card_info_advance,								param_list=""}, --  卡册升级接口
	user_card_info_rank  							={code = 9189, command = "user_card_info_rank",   						command_fun = command_user_card_info_rank,									param_list=""}, --  卡册排行接口

	time_limit_jackpot_init  						={code = 9190, command = "time_limit_jackpot_init",   					command_fun = command_time_limit_jackpot_init,								param_list=""}, --  限时奖池初始化
	time_limit_jackpot_draw  						={code = 9191, command = "time_limit_jackpot_draw",   					command_fun = command_time_limit_jackpot_draw,								param_list=""}, --  限时奖池抽奖接口
	time_limit_jackpot_rank  						={code = 9192, command = "time_limit_jackpot_rank",   					command_fun = command_time_limit_jackpot_rank,								param_list=""}, --  限时奖池查看排行榜接口
	time_limit_jackpot_notice  						={code = 9193, command = "time_limit_jackpot_notice",   				command_fun = command_time_limit_jackpot_notice,							param_list=""}, --  限时奖池查看跑马灯接口
	time_limit_jackpot_buy_prop  					={code = 9194, command = "time_limit_jackpot_buy_prop",   				command_fun = command_time_limit_jackpot_buy_prop,							param_list=""}, --  限时奖池购买任务道具接口
	time_limit_jackpot_get_task_reward  			={code = 9195, command = "time_limit_jackpot_get_task_reward",   		command_fun = command_time_limit_jackpot_get_task_reward,					param_list=""}, --  限时奖池领取任务奖励接口
	cross_arena_init  							={code = 9196, command = "cross_arena_init",   						command_fun = command_cross_arena_init,									param_list=""}, --  跨服忍者战接口
	cross_arena_defensive_formation_get  							={code = 9197, command = "cross_arena_defensive_formation_get",   						command_fun = command_cross_arena_defensive_formation_get,									param_list=""}, --  跨服忍者战接口
	cross_arena_defensive_formation_set  							={code = 9198, command = "cross_arena_defensive_formation_set",   						command_fun = command_cross_arena_defensive_formation_set,									param_list=""}, --  跨服忍者战接口
	cross_arena_remaining_challenges  							={code = 9199, command = "cross_arena_remaining_challenges",   						command_fun = command_cross_arena_remaining_challenges,									param_list=""}, --  跨服忍者战接口
	cross_arena_shop_init  							={code = 9200, command = "cross_arena_shop_init",   						command_fun = command_cross_arena_shop_init,									param_list=""}, --  跨服忍者战接口
	cross_arena_battle_report_list  							={code = 9201, command = "cross_arena_battle_report_list",   						command_fun = command_cross_arena_battle_report_list,									param_list=""}, --  跨服忍者战接口
	cross_arena_check_battle_report  							={code = 9202, command = "cross_arena_check_battle_report",   						command_fun = command_cross_arena_check_battle_report,									param_list=""}, --  跨服忍者战接口
	cross_arena_matching  							={code = 9203, command = "cross_arena_matching",   						command_fun = command_cross_arena_matching,									param_list=""}, --  跨服忍者战接口
	cross_arena_challenge  							={code = 9204, command = "cross_arena_challenge",   						command_fun = command_cross_arena_challenge,									param_list=""}, --  跨服忍者战接口
	cross_arena_choose_reward  							={code = 9205, command = "cross_arena_choose_reward",   						command_fun = command_cross_arena_choose_reward,									param_list=""}, --  跨服忍者战接口
	cross_arena_shop_buy  							={code = 9206, command = "cross_arena_shop_buy",   						command_fun = command_cross_arena_shop_buy,									param_list=""}, --  跨服忍者战接口
	cross_arena_like  							={code = 9207, command = "cross_arena_like",   						command_fun = command_cross_arena_like,									param_list=""}, --  跨服忍者战接口
	cross_arena_bet  							={code = 9208, command = "cross_arena_bet",   						command_fun = command_cross_arena_bet,									param_list=""}, --  跨服忍者战接口
	cross_arena_attack_formation_get  							={code = 9209, command = "cross_arena_attack_formation_get",   						command_fun = command_cross_arena_attack_formation_get,									param_list=""}, --  跨服忍者战接口
	cross_arena_attack_formation_set  							={code = 9210, command = "cross_arena_attack_formation_set",   						command_fun = command_cross_arena_attack_formation_set,									param_list=""}, --  跨服忍者战接口
	lucky_match_init  							={code = 9211, command = "lucky_match_init",   						command_fun = command_lucky_match_init,									param_list=""}, --  排重福袋初始化
	lucky_match_draw  							={code = 9212, command = "lucky_match_draw",   						command_fun = command_lucky_match_draw,									param_list=""}, --  排重福袋抽奖
	lucky_match_notice  						={code = 9213, command = "lucky_match_notice",   					command_fun = command_lucky_match_notice,								param_list=""}, --  排重福袋查看跑马灯
	lucky_match_get_reward  					={code = 9214, command = "lucky_match_get_reward",   				command_fun = command_lucky_match_get_reward,							param_list=""}, --  排重福袋领取配对奖励
	lucky_match_exchange_prop  					={code = 9215, command = "lucky_match_exchange_prop",   			command_fun = command_lucky_match_exchange_prop,						param_list=""}, --  排重福袋道具兑换

	private_custom_enter  						={code = 9216, command = "private_custom_enter",   					command_fun = command_private_custom_enter,								param_list=""}, --  进入私人定制页面
	private_custom_reward_set  					={code = 9217, command = "private_custom_reward_set",   			command_fun = command_private_custom_reward_set,						param_list=""}, --  设置私人定制奖励
	private_custom_reward_get  					={code = 9218, command = "private_custom_reward_get",   			command_fun = command_private_custom_reward_get,						param_list=""}, --  领取私人定制奖励

	user_card_info_init  						={code = 9219, command = "user_card_info_init",   					command_fun = command_user_card_info_init,								param_list=""}, --  组合卡册特殊条件接口
	team_arena_enter  						={code = 9220, command = "team_arena_enter",   					command_fun = command_team_arena_enter,								param_list=""}, -- 跨服小队竞技场进入接口 
	team_arena_formation_set  						={code = 9221, command = "team_arena_formation_set",   					command_fun = command_team_arena_formation_set,								param_list=""}, -- 设置防守阵容接口 
	team_arena_enter_build_up_hall  						={code = 9222, command = "team_arena_enter_build_up_hall",   					command_fun = command_team_arena_enter_build_up_hall,								param_list=""}, -- 进入集结大厅接口 
	team_arena_create_team  						={code = 9223, command = "team_arena_create_team",   					command_fun = command_team_arena_create_team,								param_list=""}, --创建队伍接口  
	team_arena_apply  						={code = 9224, command = "team_arena_apply",   					command_fun = command_team_arena_apply,								param_list=""}, --申请队伍接口  
	team_arena_find  						={code = 9225, command = "team_arena_find",   					command_fun = command_team_arena_find,								param_list=""}, -- 查找小队接口 
	team_arena_exit_team  						={code = 9226, command = "team_arena_exit_team",   					command_fun = command_team_arena_exit_team,								param_list=""}, --  退出队伍接口
	team_arena_get_invite_infos  						={code = 9227, command = "team_arena_get_invite_infos",   					command_fun = command_team_arena_get_invite_infos,								param_list=""}, -- 获取邀请列表信息接口 
	team_arena_handle_invite_info  						={code = 9228, command = "team_arena_handle_invite_info",   					command_fun = command_team_arena_handle_invite_info,								param_list=""}, -- 处理邀请信息接口 
	team_arena_get_can_invite_users  						={code = 9229, command = "team_arena_get_can_invite_users",   					command_fun = command_team_arena_get_can_invite_users,								param_list=""}, -- 获取可邀请玩家列表接口 
	team_arena_invite  						={code = 9230, command = "team_arena_invite",   					command_fun = command_team_arena_invite,								param_list=""}, --  邀请玩家接口
	team_arena_get_apply_infos  						={code = 9231, command = "team_arena_get_apply_infos",   					command_fun = command_team_arena_get_apply_infos,								param_list=""}, --  获取申请列表信息接口
	team_arena_handle_apply_info  						={code = 9232, command = "team_arena_handle_apply_info",   					command_fun = command_team_arena_handle_apply_info,								param_list=""}, -- 处理申请信息接口 
	team_arena_transfer_captain  						={code = 9233, command = "team_arena_transfer_captain",   					command_fun = command_team_arena_transfer_captain,								param_list=""}, --转让队长接口  
	team_arena_kick_out  						={code = 9234, command = "team_arena_kick_out",   					command_fun = command_team_arena_kick_out,								param_list=""}, -- 请离队伍接口 
	team_arena_commit_team  						={code = 9235, command = "team_arena_commit_team",   					command_fun = command_team_arena_commit_team,								param_list=""}, -- 提交队伍接口 
	team_arena_challenge_times  						={code = 9236, command = "team_arena_challenge_times",   					command_fun = command_team_arena_challenge_times,								param_list=""}, -- 获取挑战次数接口 
	team_arena_matching  						={code = 9237, command = "team_arena_matching",   					command_fun = command_team_arena_matching,								param_list=""}, -- 玩家匹配可攻打的列表接口 
	team_arena_challenge  						={code = 9238, command = "team_arena_challenge",   					command_fun = command_team_arena_challenge,								param_list=""}, -- 发起战斗接口 
	team_arena_team_info_get  						={code = 9239, command = "team_arena_team_info_get",   					command_fun = command_team_arena_team_info_get,								param_list=""}, -- 获取小队信息接口 
	team_arena_change_fight_turn  						={code = 9240, command = "team_arena_change_fight_turn",   					command_fun = command_team_arena_change_fight_turn,								param_list=""}, -- 改变挑战顺序接口 
	team_arena_battle_report_list  						={code = 9241, command = "team_arena_battle_report_list",   					command_fun = command_team_arena_battle_report_list,								param_list=""}, -- 获取战报列表接口 
	team_arena_check_battle_report  						={code = 9242, command = "team_arena_check_battle_report",   					command_fun = command_team_arena_check_battle_report,								param_list=""}, --  查看战报接口
	team_arena_formation_get  						={code = 9243, command = "team_arena_formation_get",   					command_fun = command_team_arena_formation_get,								param_list=""}, --  获取防守阵容信息接口

	egg_frenzy_init  						={code = 9244, command = "egg_frenzy_init",   					command_fun = command_egg_frenzy_init,						param_list=""}, --  进入彩蛋舞会页面
	egg_frenzy_draw  						={code = 9245, command = "egg_frenzy_draw",   					command_fun = command_egg_frenzy_draw,						param_list=""}, --  彩蛋舞会砸蛋
	egg_frenzy_get_reward  					={code = 9246, command = "egg_frenzy_get_reward",   			command_fun = command_egg_frenzy_get_reward,				param_list=""}, --  领取彩蛋舞会成就奖励
	egg_frenzy_bug_prop  					={code = 9247, command = "egg_frenzy_bug_prop",   				command_fun = command_egg_frenzy_bug_prop,					param_list=""}, --  彩蛋舞会购买道具

	world_boss_attack 						={code = 9248, command = "world_boss_attack",   				command_fun = command_world_boss_attack,					param_list=""}, --  世界boos请求战斗
	
	ship_spirit_batch_level_up 				={code = 9249, command = "ship_spirit_batch_level_up",   		command_fun = command_ship_spirit_batch_level_up,			param_list=""}, --  团队精神批量送礼
	combine_ship_prop_state_get 			={code = 9250, command = "combine_ship_prop_state_get",   		command_fun = command_combine_ship_prop_state_get,			param_list=""}, --  组合卡道具领取状态
	combine_ship_prop_receive 				={code = 9251, command = "combine_ship_prop_receive",   		command_fun = command_combine_ship_prop_receive,			param_list=""}, --  组合卡道具领取

	summer_cool_weal_init 					={code = 9252, command = "summer_cool_weal_init",   			command_fun = command_summer_cool_weal_init,				param_list=""}, --  夏日酷饮初始化
	summer_cool_weal_get_reward 			={code = 9253, command = "summer_cool_weal_get_reward",   		command_fun = command_summer_cool_weal_get_reward,			param_list=""}, --  夏日酷饮领奖接口
	
	secret_travel_init 						={code = 9254, command = "secret_travel_init",   				command_fun = command_secret_travel_init,				param_list=""}, --  秘境之旅初始化接口
	secret_travel_draw 						={code = 9255, command = "secret_travel_draw",   				command_fun = command_secret_travel_draw,				param_list=""}, --  秘境之旅抽奖/一键抽奖接口
	secret_travel_get_reward 				={code = 9256, command = "secret_travel_get_reward",   			command_fun = command_secret_travel_get_reward,			param_list=""}, --  秘境之旅领取活动任务奖励接口
	secret_travel_set_reward 				={code = 9257, command = "secret_travel_set_reward",   			command_fun = command_secret_travel_set_reward,			param_list=""}, --  秘境之旅设置终极奖励接口
	secret_travel_next_tier 				={code = 9258, command = "secret_travel_next_tier",   			command_fun = command_secret_travel_next_tier,			param_list=""}, --  秘境之旅进入下一层接口

	equipment_harden						={code = 9259, command = "equipment_harden",   					command_fun = command_equipment_harden,					param_list=""}, --  装备淬炼
	equipment_harden_replace 				={code = 9260, command = "equipment_harden_replace",   			command_fun = command_equipment_harden_replace,			param_list=""}, --  装备淬炼置换接口
	equipment_harden_locking 				={code = 9261, command = "equipment_harden_locking",   			command_fun = command_equipment_harden_locking,			param_list=""}, --  装备淬炼锁定接口

	biographies_init 						={code = 9262, command = "biographies_init",   					command_fun = command_biographies_init,					param_list=""}, --  忍列传初始化接口
	biographies_activate 					={code = 9263, command = "biographies_activate",   				command_fun = command_biographies_activate,				param_list=""}, --  忍列传列传激活接口
	biographies_achieve_activate 			={code = 9264, command = "biographies_achieve_activate",   		command_fun = command_biographies_achieve_activate,		param_list=""}, --  忍列传列传成就激活接口
	biographies_advance 					={code = 9265, command = "biographies_advance",   				command_fun = command_biographies_advance,				param_list=""}, --  忍列传列传升星接口
	biographies_rebirth 					={code = 9266, command = "biographies_rebirth",   				command_fun = command_biographies_rebirth,				param_list=""}, --  忍列传列传重置星级接口
	biographies_rank 						={code = 9267, command = "biographies_rank",   					command_fun = command_biographies_rank,					param_list=""}, --  忍列传列传排行榜接口
	biographies_draw 						={code = 9268, command = "biographies_draw",   					command_fun = command_biographies_draw,					param_list=""}, --  忍列传印记抽取接口
	biographies_buy_prop					={code = 9269, command = "biographies_buy_prop",   				command_fun = command_biographies_buy_prop,				param_list=""}, --  忍列传印记抽取道具购买接口

	get_user_ban_time					={code = 9270, command = "get_user_ban_time",   				command_fun = command_get_user_ban_time,				param_list=""}, --  封号结束时间

	biographies_get_extra_reward		={code = 9271, command = "biographies_get_extra_reward",   				command_fun = command_biographies_get_extra_reward,				param_list=""}, --  忍列传额外奖励领取接口

	activity_orders_world_init			={code = 9272, command = "activity_orders_world_init",   				command_fun = command_activity_orders_world_init,				param_list=""}, --  号令忍界初始化接口
	activity_orders_world_donate		={code = 9273, command = "activity_orders_world_donate",   				command_fun = command_activity_orders_world_donate,				param_list=""}, --  号令忍界捐赠接口
	activity_orders_world_exchange		={code = 9274, command = "activity_orders_world_exchange",   			command_fun = command_activity_orders_world_exchange,			param_list=""}, --  号令忍界商店兑换接口
	activity_orders_world_get_order		={code = 9275, command = "activity_orders_world_get_order",   			command_fun = command_activity_orders_world_get_order,			param_list=""}, --  号令忍界排行榜接口
	activity_orders_world_glory_list	={code = 9276, command = "activity_orders_world_glory_list",   			command_fun = command_activity_orders_world_glory_list,			param_list=""}, --  号令忍界荣耀榜接口
	activity_orders_world_get_reward	={code = 9277, command = "activity_orders_world_get_reward",   			command_fun = command_activity_orders_world_get_reward,			param_list=""}, --  号令忍界领取奖励接口
	
	half_the_ritual_init	={code = 9278, command = "half_the_ritual_init",   			command_fun = command_half_the_ritual_init,			param_list=""}, --  半月礼活动初始化
	half_the_ritual_get_reward	={code = 9279, command = "half_the_ritual_get_reward",   			command_fun = command_half_the_ritual_get_reward,			param_list=""}, --  半月礼活动领奖

	magical_animals_init						={code = 9280, command = "magical_animals_init",   						command_fun = command_magical_animals_init,						param_list=""}, --  神兽系统初始化接口
	magical_animals_activate					={code = 9281, command = "magical_animals_activate",   					command_fun = command_magical_animals_activate,					param_list=""}, --  神兽激活接口
	magical_animals_advance_star				={code = 9282, command = "magical_animals_advance_star",   				command_fun = command_magical_animals_advance_star,				param_list=""}, --  神兽升星接口
	magical_animals_steps_rebirth				={code = 9283, command = "magical_animals_steps_rebirth",   			command_fun = command_magical_animals_steps_rebirth,			param_list=""}, --  神兽升星重置接口
	magical_animals_forging						={code = 9284, command = "magical_animals_forging",   					command_fun = command_magical_animals_forging,					param_list=""}, --  神兽锻造接口
	magical_animals_relevant_active				={code = 9285, command = "magical_animals_relevant_active",   			command_fun = command_magical_animals_relevant_active,			param_list=""}, --  神兽连携激活接口
	magical_animals_set_skill					={code = 9286, command = "magical_animals_set_skill",   				command_fun = command_magical_animals_set_skill,				param_list=""}, --  设置神兽技能接口
	magical_animals_activate_fate				={code = 9287, command = "magical_animals_activate_fate",   			command_fun = command_magical_animals_activate_fate,			param_list=""}, --  天命激活接口
	magical_animals_set_skill_release_method	={code = 9288, command = "magical_animals_set_skill_release_method",   	command_fun = command_magical_animals_set_skill_release_method,	param_list=""}, --  设置神兽技能释放方式接口

	activity_group_buy_init	={code = 9289, command = "activity_group_buy_init",   			command_fun = command_activity_group_buy_init,			param_list=""}, --  超值团购初始化
	activity_group_buy_gift_pack	={code = 9290, command = "activity_group_buy_gift_pack",   			command_fun = command_activity_group_buy_gift_pack,			param_list=""}, --  超值团购购买礼包
	activity_group_buy_get_reward	={code = 9291, command = "activity_group_buy_get_reward",   			command_fun = command_activity_group_buy_get_reward,			param_list=""}, --  超值团购领取奖励

	magical_animals_activate_get_fate_task_reward	={code = 9292, command = "magical_animals_activate_get_fate_task_reward",   	command_fun = command_magical_animals_activate_get_fate_task_reward,	param_list=""}, --  领取神兽天命系统任务奖励接口

	fight_spirit_init		={code = 9293, command = "fight_spirit_init",	command_fun = command_fight_spirit_init,	param_list=""}, --  战魂初始化
	fight_spirit_compund	={code = 9294, command = "fight_spirit_compund",	command_fun = command_fight_spirit_compund,	param_list=""}, --  战魂合成
	fight_spirit_ehance		={code = 9295, command = "fight_spirit_ehance",	command_fun = command_fight_spirit_ehance,	param_list=""}, --  战魂强化
	fight_spirit_awake		={code = 9296, command = "fight_spirit_awake",	command_fun = command_fight_spirit_awake,	param_list=""}, --  战魂觉醒
	fight_spirit_refine		={code = 9297, command = "fight_spirit_refine",	command_fun = command_fight_spirit_refine,	param_list=""}, --  战魂洗练
	fight_spirit_break_down	={code = 9298, command = "fight_spirit_break_down",	command_fun = command_fight_spirit_break_down,	param_list=""}, --  战魂分解
	fight_spirit_lock		={code = 9299, command = "fight_spirit_lock",	command_fun = command_fight_spirit_lock,	param_list=""}, --  战魂锁定
	fight_spirit_change		={code = 9300, command = "fight_spirit_change",	command_fun = command_fight_spirit_change,	param_list=""}, --  战魂装备，卸载，替换
	fight_spirit_refine_define		={code = 9301, command = "fight_spirit_refine_define",	command_fun = command_fight_spirit_refine_define,	param_list=""}, --  战魂洗练确认取消
	
	biographies_mark_synthesis	={code = 9302, command = "biographies_mark_synthesis",	command_fun = command_biographies_mark_synthesis,	param_list=""}, --  彩色印记合成
	seven_day_recharge_init	={code = 9303, command = "seven_day_recharge_init",	command_fun = command_seven_day_recharge_init,	param_list=""}, --  七日连充初始化
	seven_day_recharge_get_reward	={code = 9304, command = "seven_day_recharge_get_reward",	command_fun = command_seven_day_recharge_get_reward,	param_list=""}, --  七日连充领奖
	seven_day_recharge_use_voucher	={code = 9305, command = "seven_day_recharge_use_voucher",	command_fun = command_seven_day_recharge_use_voucher,	param_list=""}, --  七日连充使用代金券

	get_web_recharge_state	=	{code = 9306, command = "get_web_recharge_state",	command_fun = command_get_web_recharge_state,	param_list=""}, --  获取web充值状态接口
	use_voucher				=	{code = 9307, command = "use_voucher",	       		command_fun = command_use_voucher,				param_list=""}, --  代金券使用
	sell_voucher			=	{code = 9308, command = "sell_voucher",				command_fun = command_sell_voucher,				param_list=""}, --  代金券出售
	
	limit_blessing_init					=	{code = 9309, command = "limit_blessing_init",					command_fun = command_limit_blessing_init,					param_list=""}, --  限时祈愿初始化接口
	limit_blessing_set					=	{code = 9310, command = "limit_blessing_set",					command_fun = command_limit_blessing_set,					param_list=""}, --  限时祈愿设置奖励
	limit_blessing_draw					=	{code = 9311, command = "limit_blessing_draw",					command_fun = command_limit_blessing_draw,					param_list=""}, --  限时祈愿抽奖接口
	limit_blessing_get_blessing_reward	=	{code = 9312, command = "limit_blessing_get_blessing_reward",	command_fun = command_limit_blessing_get_blessing_reward,	param_list=""}, --  限时祈愿获取祈福值奖励
	limit_blessing_get_task_reward		=	{code = 9313, command = "limit_blessing_get_task_reward",		command_fun = command_limit_blessing_get_task_reward,		param_list=""}, --  限时祈愿领取活跃任务奖励
	limit_blessing_set_spree_reward		=	{code = 9314, command = "limit_blessing_set_spree_reward",		command_fun = command_limit_blessing_set_spree_reward,		param_list=""}, --  限时祈愿设置礼包奖励
	limit_blessing_get_spree_reward		=	{code = 9315, command = "limit_blessing_get_spree_reward",		command_fun = command_limit_blessing_get_spree_reward,		param_list=""}, --  限时祈愿获得礼包奖励
	limit_blessing_buy_prop				=	{code = 9316, command = "limit_blessing_buy_prop",				command_fun = command_limit_blessing_buy_prop,				param_list=""}, --  限时祈愿购买道具
	
	lucky_turntable_init				=	{code = 9317, command = "lucky_turntable_init",				command_fun = command_lucky_turntable_init,				param_list=""}, --  圣诞奇缘初始化
	lucky_turntable_draw				=	{code = 9318, command = "lucky_turntable_draw",				command_fun = command_lucky_turntable_draw,				param_list=""}, --  圣诞奇缘转盘抽奖
	lucky_turntable_open_chest			=	{code = 9319, command = "lucky_turntable_open_chest",		command_fun = command_lucky_turntable_open_chest,		param_list=""}, --  圣诞奇缘转盘开宝箱
	lucky_turntable_flash				=	{code = 9320, command = "lucky_turntable_flash",			command_fun = command_lucky_turntable_flash,			param_list=""}, --  圣诞奇缘重置幸运转盘
	lucky_turntable_buy_prop			=	{code = 9321, command = "lucky_turntable_buy_prop",			command_fun = command_lucky_turntable_buy_prop,			param_list=""}, --  圣诞奇缘购买商城物品

	celebration_order_init				=	{code = 9322, command = "celebration_order_init",				command_fun = command_celebration_order_init,				param_list=""}, 	--  新服庆典初始化
	celebration_order_get_order			=	{code = 9323, command = "celebration_order_get_order",			command_fun = command_celebration_order_get_order,			param_list=""}, 	--  新服庆典获取排行榜接口
	celebration_order_get_day_reward	=	{code = 9324, command = "celebration_order_get_day_reward",		command_fun = command_celebration_order_get_day_reward,		param_list=""},		 --  新服庆典获取每日奖励
	celebration_order_get_order_reward	=	{code = 9325, command = "celebration_order_get_order_reward",	command_fun = command_celebration_order_get_order_reward,	param_list=""}, 	--  新服庆典领取排行榜成就奖励
	celebration_order_get_achieve		=	{code = 9326, command = "celebration_order_get_achieve",		command_fun = command_celebration_order_get_achieve,		param_list=""}, 	--  新服庆典获取用户成就任务详情
	carnival_n_day						=	{code = 9327, command = "carnival_n_day",						command_fun = command_carnival_n_day,						param_list=""}, 	--  新服庆典七天乐领取奖励

	new_recruitment_system	    		=   {code = 9328, command = "new_recruitment_system",				command_fun = command_new_recruitment_system,				param_list=""}, 	-- 	新系统抽卡
	new_recruitment_shop_buy	    	=   {code = 9329, command = "new_recruitment_shop_buy",				command_fun = command_new_recruitment_shop_buy,				param_list=""}, 	-- 	新抽卡系统招募商店购买
	view_draw_items	    				=   {code = 9330, command = "view_draw_items",						command_fun = command_view_draw_items,						param_list=""}, 	-- 	新抽卡系统查看抽卡记录
	wish_list_enter	    				=   {code = 9331, command = "wish_list_enter",						command_fun = command_wish_list_enter,						param_list=""}, 	-- 	新抽卡系统心愿单活动进入
	wish_list_set	    				=   {code = 9332, command = "wish_list_set",						command_fun = command_wish_list_set,						param_list=""}, 	-- 	新抽卡系统心愿单活动设置心愿

	user_build_war_order_init			=   {code = 9333, command = "user_build_war_order_init",			command_fun = command_user_build_war_order_init, 			param_list=""},		-- 	建号战令初始化
	user_build_war_order_get_reward		=   {code = 9334, command = "user_build_war_order_get_reward",		command_fun = command_user_build_war_order_get_reward, 		param_list=""},		-- 	建号战令奖励领取
	user_build_war_order_buy			=   {code = 9335, command = "user_build_war_order_buy",				command_fun = command_user_build_war_order_buy, 			param_list=""},		-- 	建号战令商店购买

	normal_war_order_init				=   {code = 9336, command = "normal_war_order_init",				command_fun = command_normal_war_order_init, 				param_list=""},		-- 	常规战令初始化
	normal_war_order_get_reward			=   {code = 9337, command = "normal_war_order_get_reward",			command_fun = command_normal_war_order_get_reward, 			param_list=""},		-- 	常规战令奖励领取

	war_order_activation				=   {code = 9338, command = "war_order_activation",					command_fun = command_war_order_activation, 				param_list=""},		-- 	战令道具激活

	monopoly_init						=   {code = 9339, command = "monopoly_init",						command_fun = command_monopoly_init, 						param_list=""},		-- 	大富翁初始化
	monopoly_throw_dice					=   {code = 9340, command = "monopoly_throw_dice",					command_fun = command_monopoly_throw_dice, 					param_list=""},		-- 	大富翁用户投掷
	monopoly_transmission				=   {code = 9341, command = "monopoly_transmission",				command_fun = command_monopoly_transmission, 				param_list=""},		-- 	大富翁用户传送
	monopoly_get_task_reward			=   {code = 9342, command = "monopoly_get_task_reward",				command_fun = command_monopoly_get_task_reward, 			param_list=""},		-- 	大富翁领取任务奖励
	monopoly_change_achieve_reward		=   {code = 9343, command = "monopoly_change_achieve_reward",		command_fun = command_monopoly_change_achieve_reward, 		param_list=""},		-- 	大富翁选择可选奖励
	monopoly_get_achieve_reward			=   {code = 9344, command = "monopoly_get_achieve_reward",			command_fun = command_monopoly_get_achieve_reward, 			param_list=""},		-- 	大富翁获取成就奖励
	monopoly_reward_log					=   {code = 9345, command = "monopoly_reward_log",					command_fun = command_monopoly_reward_log, 					param_list=""},		-- 	大富翁获取奖励记录
	monopoly_buy						=   {code = 9346, command = "monopoly_buy",							command_fun = command_monopoly_buy, 						param_list=""},		-- 	大富翁普通骰子购买

	cross_time_limit_jackpot_init					=   {code = 9347, command = "cross_time_limit_jackpot_init",				command_fun = command_cross_time_limit_jackpot_init, 					param_list=""},		-- 	跨服限时奖池初始化接口
	cross_time_limit_jackpot_draw					=   {code = 9348, command = "cross_time_limit_jackpot_draw",				command_fun = command_cross_time_limit_jackpot_draw, 					param_list=""},		-- 	跨服限时奖池抽奖接口
	cross_time_limit_jackpot_rank					=   {code = 9349, command = "cross_time_limit_jackpot_rank",				command_fun = command_cross_time_limit_jackpot_rank, 					param_list=""},		-- 	跨服限时奖池查看排行榜接口
	cross_time_limit_jackpot_notice					=   {code = 9350, command = "cross_time_limit_jackpot_notice",				command_fun = command_cross_time_limit_jackpot_notice, 					param_list=""},		-- 	跨服限时奖池查看跑马灯接口
	cross_time_limit_jackpot_buy_prop				=   {code = 9351, command = "cross_time_limit_jackpot_buy_prop",			command_fun = command_cross_time_limit_jackpot_buy_prop, 				param_list=""},		-- 	跨服限时奖池购买道具接口
	cross_time_limit_jackpot_get_task_reward		=   {code = 9352, command = "cross_time_limit_jackpot_get_task_reward",		command_fun = command_cross_time_limit_jackpot_get_task_reward, 		param_list=""},		-- 	跨服限时奖池领取任务奖励接口

	change_user_head_frame								=   {code = 9353, command = "change_user_head_frame",							command_fun = command_change_user_head_frame, 								param_list=""},		-- 	用户头像框更换接口

	combine_ship_one_key_update_slot					=   {code = 9354, command = "combine_ship_one_key_update_slot",					command_fun = command_combine_ship_one_key_update_slot, 					param_list=""},		-- 	组合卡一键升级接口

	user_advertisement_click						=   {code = 9355, command = "user_advertisement_click",						command_fun = command_user_advertisement_click, 					param_list=""},		-- 	广告观看功能点击观看
	user_advertisement_finish						=   {code = 9356, command = "user_advertisement_finish",					command_fun = command_user_advertisement_finish, 					param_list=""},		-- 	广告观看功能完成观看

	one_key_draw_scene_reward						=   {code = 9357, command = "one_key_draw_scene_reward",					command_fun = command_one_key_draw_scene_reward, 					param_list=""},		-- 	一键领取PVE所有奖励接口

	one_key_draw_union_copy_draw_reward				=   {code = 9358, command = "one_key_draw_union_copy_draw_reward",			command_fun = command_one_key_draw_union_copy_draw_reward, 			param_list=""},		-- 	一键领取公会副本所有奖励接口

	see_union_info									=   {code = 9359, command = "see_union_info",								command_fun = command_see_union_info, 								param_list=""},		-- 	查看公会详情接口
	
	jump_page_get_reward							=   {code = 9360, command = "jump_page_get_reward",							command_fun = command_jump_page_get_reward, 						param_list=""},		-- 	下包跳转页完成后奖励领取

	stick_crazy_one_key_get							=	{code = 9361, command = "stick_crazy_one_key_get",							command_fun = command_stick_crazy_one_key_get,							param_list=""},	-- 小悟空大冒险一键领取奖励
	stick_crazy_jump_cost							=	{code = 9362, command = "stick_crazy_jump_cost",							command_fun = command_stick_crazy_jump_cost,							param_list=""},	-- 小悟空大冒险跳转最高层扣除钻石

	time_limit_lottery_init							=	{code = 9363, command = "time_limit_lottery_init",							command_fun = command_time_limit_lottery_init,							param_list=""},	-- 限时抽奖初始化
	time_limit_lottery_draw							=	{code = 9364, command = "time_limit_lottery_draw",							command_fun = command_time_limit_lottery_draw,							param_list=""},	-- 限时抽奖抽奖
	time_limit_lottery_buy							=	{code = 9365, command = "time_limit_lottery_buy",							command_fun = command_time_limit_lottery_buy,							param_list=""},	-- 限时抽奖商店购买
	time_limit_lottery_draw_log						=	{code = 9366, command = "time_limit_lottery_draw_log",						command_fun = command_time_limit_lottery_draw_log,						param_list=""},	-- 限时抽奖查看抽奖记录

	mysterious_egg_receive_reward					=	{code = 9367, command = "mysterious_egg_receive_reward",					command_fun = command_mysterious_egg_receive_reward,					param_list=""},	-- 领取彩蛋奖励
	
	first_charge_init								=	{code = 9368, command = "first_charge_init",								command_fun = command_first_charge_init,								param_list=""},	-- 首冲重塑初始化
	first_charge_receive_reward						=	{code = 9369, command = "first_charge_receive_reward",						command_fun = command_first_charge_receive_reward,						param_list=""},	-- 首冲重塑领取奖励
	monthly_card_receive_reward						=	{code = 9370, command = "monthly_card_receive_reward",						command_fun = command_monthly_card_receive_reward,						param_list=""},	-- 月卡重塑领取奖励
	monthly_card_activate							=	{code = 9371, command = "monthly_card_activate",							command_fun = command_monthly_card_activate,							param_list=""},	-- 月卡重塑道具激活

	guest_account_generate							=	{code = 9372, command = "guest_account_generate",							command_fun = command_guest_account_generate,							param_list=""},	-- 生成游客账号

	tutorial_skip									=	{code = 9993, command = "tutorial_skip",								command_fun = command_tutorial_skip,								param_list=""},	-- 跳过教程选择
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

-- 根据命令名 取出 命令对应的传递数据
 function find_param_list(command)
	for i, v in pairs(protocol_command) do
		if v.command == command then
			return v.param_list
		end
	end
	return nil
end

function replaceDomainName()
	-- print("app.configJson.url = ", app.configJson.url)
	-- print("app.configJson.urlForAnnounce = ", app.configJson.urlForAnnounce)

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

	-- print("app.configJson.url = ", app.configJson.url)
	-- print("app.configJson.urlForAnnounce = ", app.configJson.urlForAnnounce)
end

replaceDomainName()