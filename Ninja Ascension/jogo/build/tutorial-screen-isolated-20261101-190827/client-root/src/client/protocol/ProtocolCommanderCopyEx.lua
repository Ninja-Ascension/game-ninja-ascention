-- -------------------------------------------------------------------------------------------------------
-- command_camp_preference 283
-- -------------------------------------------------------------------------------------------------------
function command_camp_preference(str)
	str = str.."\r\n"
	str = str..protocol_command.camp_preference.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str.._ED._battle_init_type
	str = str.."\r\n"
	str = str..protocol_command.camp_preference.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_draw_morrow_reward 285 --次日活动领取
-- -------------------------------------------------------------------------------------------------------
function command_draw_morrow_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_morrow_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_morrow_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_rebel_army_share 286 --叛军分享接口
-- -------------------------------------------------------------------------------------------------------
function command_rebel_army_share(str)
	str = str.."\r\n"
	str = str..protocol_command.rebel_army_share.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.rebel_army_share.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_black_shop_init 287 --黑市初始化
-- -------------------------------------------------------------------------------------------------------
function command_black_shop_init(str)
	str = str.."\r\n"
	str = str..protocol_command.black_shop_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_black_shop_refush 288 --黑市刷新
-- -------------------------------------------------------------------------------------------------------
function command_black_shop_refush(str)
	str = str.."\r\n"
	str = str..protocol_command.black_shop_refush.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_black_shop_exchange 289 --黑市兑换
-- -------------------------------------------------------------------------------------------------------
function command_black_shop_exchange(str)
	str = str.."\r\n"
	str = str..protocol_command.black_shop_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.black_shop_exchange.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_draw_black_shop_reward 290 --黑市刷新
-- -------------------------------------------------------------------------------------------------------
function command_draw_black_shop_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_black_shop_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_on_hook 291 --通知挂机接口
-- -------------------------------------------------------------------------------------------------------
function command_on_hook(str)
	str = str.."\r\n"
	str = str..protocol_command.on_hook.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.on_hook.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_refush_on_hook 292 -- 刷新挂机接口
-- -------------------------------------------------------------------------------------------------------
function command_refush_on_hook(str)
	str = str.."\r\n"
	str = str..protocol_command.refush_on_hook.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.refush_on_hook.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_draw_on_hook_reward 293 -- 领取挂机宝箱接口
-- -------------------------------------------------------------------------------------------------------
function command_draw_on_hook_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_on_hook_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_on_hook_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_arena_init2 294 -- 竞技场初始化2
-- -------------------------------------------------------------------------------------------------------
function command_arena_init2(str)
	str = str.."\r\n"
	str = str..protocol_command.arena_init2.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.arena_init2.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_mineral_init 295 -- 获取矿区信息接口
-- -------------------------------------------------------------------------------------------------------
function command_mineral_init(str)
	str = str.."\r\n"
	str = str..protocol_command.mineral_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.mineral_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_mineral_explore 296 -- 探索矿区接口
-- -------------------------------------------------------------------------------------------------------
function command_mineral_explore(str)
	str = str.."\r\n"
	str = str..protocol_command.mineral_explore.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.mineral_explore.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_mineral_pick 297 -- 捡起矿资源接口
-- -------------------------------------------------------------------------------------------------------
function command_mineral_pick(str)
	str = str.."\r\n"
	str = str..protocol_command.mineral_pick.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.mineral_pick.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_mineral_new_project 298 -- 新建矿区工坊接口
-- -------------------------------------------------------------------------------------------------------
function command_mineral_new_project(str)
	str = str.."\r\n"
	str = str..protocol_command.mineral_new_project.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.mineral_new_project.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_mineral_reward_gain 299 -- 领取工坊奖励接口
-- -------------------------------------------------------------------------------------------------------
function command_mineral_reward_gain(str)
	str = str.."\r\n"
	str = str..protocol_command.mineral_reward_gain.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.mineral_reward_gain.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_mineral_workspace_init 300 -- 获取工坊信息接口
-- -------------------------------------------------------------------------------------------------------
function command_mineral_workspace_init(str)
	str = str.."\r\n"
	str = str..protocol_command.mineral_workspace_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.mineral_workspace_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_mineral_workspace_add 301 -- 获取工坊信息接口
-- -------------------------------------------------------------------------------------------------------
function command_mineral_workspace_add(str)
	str = str.."\r\n"
	str = str..protocol_command.mineral_workspace_add.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.mineral_workspace_add.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_strategy_list 302 -- 获取攻略列表
-- -------------------------------------------------------------------------------------------------------
function command_strategy_list(str)
	str = str.."\r\n"
	str = str..protocol_command.strategy_list.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.strategy_list.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_strategy_add 303 -- 发表攻略
-- -------------------------------------------------------------------------------------------------------
function command_strategy_add(str)
	str = str.."\r\n"
	str = str..protocol_command.strategy_add.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.strategy_add.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_strategy_favor 304 -- 攻略点赞
-- -------------------------------------------------------------------------------------------------------
function command_strategy_favor(str)
	str = str.."\r\n"
	str = str..protocol_command.strategy_favor.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.strategy_favor.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_mineral_reset 305 -- 重置资源矿
-- -------------------------------------------------------------------------------------------------------
function command_mineral_reset(str)
	str = str.."\r\n"
	str = str..protocol_command.mineral_reset.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.mineral_reset.param_list
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- command_show_self_message 306 -- 查看自身当天发布信息
-- -------------------------------------------------------------------------------------------------------
function command_show_self_message(str)
	str = str.."\r\n"
	str = str..protocol_command.show_self_message.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_reply_message 307 -- 回复信息
-- -------------------------------------------------------------------------------------------------------
function command_reply_message(str)
	str = str.."\r\n"
	str = str..protocol_command.reply_message.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.reply_message.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_show_reply_message 308 -- 查看回复信息
-- -------------------------------------------------------------------------------------------------------
function command_show_reply_message(str)
	str = str.."\r\n"
	str = str..protocol_command.show_reply_message.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.show_reply_message.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_on_hook_init 309 -- 挂机初始化
-- -------------------------------------------------------------------------------------------------------
function command_on_hook_init(str)
	str = str.."\r\n"
	str = str..protocol_command.on_hook_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_show_ship_mould_list 310 -- 请求图鉴
-- -------------------------------------------------------------------------------------------------------
function command_show_ship_mould_list(str)
	str = str.."\r\n"
	str = str..protocol_command.show_ship_mould_list.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_mineral_add_workspace 311 -- 请求新的矿工工坊
-- -------------------------------------------------------------------------------------------------------
function command_mineral_add_workspace(str)
	str = str.."\r\n"
	str = str..protocol_command.mineral_add_workspace.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_get_mineral_prop_list 312 -- 请求矿工包或矿石物品
-- -------------------------------------------------------------------------------------------------------
function command_get_mineral_prop_list(str)
	str = str.."\r\n"
	str = str..protocol_command.get_mineral_prop_list.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- user_combat_force_order_reward_init 313 -- 排行榜活动初始化
-- -------------------------------------------------------------------------------------------------------
function command_user_combat_force_order_reward_init(str)
	str = str.."\r\n"
	str = str..protocol_command.user_combat_force_order_reward_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_combat_force_order_reward_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- sky_temple_init 314 -- 请求天空神殿
-- -------------------------------------------------------------------------------------------------------
function command_sky_temple_init(str)
	str = str.."\r\n"
	str = str..protocol_command.sky_temple_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- sky_temple_exchange 315 -- 请求天空神殿兑换
-- -------------------------------------------------------------------------------------------------------
function command_sky_temple_exchange(str)
	str = str.."\r\n"
	str = str..protocol_command.sky_temple_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.sky_temple_exchange.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_destiny_strength 316 -- 宿命强化请求
-- -------------------------------------------------------------------------------------------------------
function command_ship_destiny_strength(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_destiny_strength.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_destiny_strength.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_limit_break 317 -- 界限突破请求
-- -------------------------------------------------------------------------------------------------------
function command_ship_limit_break(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_limit_break.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_limit_break.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_equip_strength 318 -- 武具强化请求
-- -------------------------------------------------------------------------------------------------------
function command_ship_equip_strength(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_equip_strength.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_equip_strength.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_train 319 -- 宝具锻造请求
-- -------------------------------------------------------------------------------------------------------
function command_ship_train(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_train.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_train.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_switch_equipment 320 -- 切换宿命武器请求
-- -------------------------------------------------------------------------------------------------------
function command_switch_equipment(str)
	str = str.."\r\n"
	str = str..protocol_command.switch_equipment.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.switch_equipment.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_battle_field_init 321	日常副本效验结算接口
-- -------------------------------------------------------------------------------------------------------
function command_daily_instance_verify(str)
	str = str.."\r\n"
	str = str..protocol_command.daily_instance_verify.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.daily_instance_verify.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_ship_train 322 -- 灵力转移请求
-- -------------------------------------------------------------------------------------------------------
function command_ship_transfer(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_transfer.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_transfer.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_arena_launch2 323 --竞技场请求战斗2
-- -------------------------------------------------------------------------------------------------------
function command_arena_launch2(str)
	str = str.."\r\n"
	str = str..protocol_command.arena_launch2.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.arena_launch2.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_arena_launch2 324 --竞技场重置
-- -------------------------------------------------------------------------------------------------------
function command_arena2_refush(str)
	str = str.."\r\n"
	str = str..protocol_command.arena2_refush.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.arena2_refush.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_ship_purchase 325 --灵魂召唤请求
-- -------------------------------------------------------------------------------------------------------
function command_ship_purchase(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_purchase.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_purchase.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_formation_exchange 326 --阵型换位请求
-- -------------------------------------------------------------------------------------------------------
function command_formation_exchange(str)
	str = str.."\r\n"
	str = str..protocol_command.formation_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.formation_exchange.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_mine_fight_launch 327 --矿区战斗请求
-- -------------------------------------------------------------------------------------------------------
function command_mine_fight_launch(str)
	str = str.."\r\n"
	str = str..protocol_command.mine_fight_launch.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.mine_fight_launch.param_list
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- 	command_battle_result_start 328 --通知进入战斗
-- -------------------------------------------------------------------------------------------------------
function command_battle_result_start(str)
	str = str.."\r\n"
	str = str..protocol_command.battle_result_start.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.battle_result_start.param_list
	return str
end
---  command_draw_union_liveness_reward 329 领取工会祭天积分宝箱
function command_draw_union_liveness_reward( str )
	str = str.."\r\n"
	str = str..protocol_command.draw_union_liveness_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_union_liveness_reward.param_list
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- 	command_unino_pic_frame_exchanget 330 --修改图标
-- -------------------------------------------------------------------------------------------------------
function command_unino_pic_frame_exchange(str)
	str = str.."\r\n"
	str = str..protocol_command.unino_pic_frame_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.unino_pic_frame_exchange.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_set_accept_friend_request 331 --设置是否接受好友申请
-- -------------------------------------------------------------------------------------------------------
function command_set_accept_friend_request(str)
	str = str.."\r\n"
	str = str..protocol_command.set_accept_friend_request.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.set_accept_friend_request.param_list
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- 	command_union_pve_init 332 --请求初始化军团副本界面
-- -------------------------------------------------------------------------------------------------------
function command_union_pve_init(str)
	str = str.."\r\n"
	str = str..protocol_command.union_pve_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.union_pve_init.param_list
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- 	command_union_pve_init 333 --请求通关奖励宝箱数据
-- -------------------------------------------------------------------------------------------------------
function command_draw_union_scene_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_union_scene_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_union_scene_reward.param_list
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- 	command_union_pve_init 334 --请求初始化阵容招募初始数据
-- -------------------------------------------------------------------------------------------------------
function command_partner_bounty_init(str)
	str = str.."\r\n"
	str = str..protocol_command.partner_bounty_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.partner_bounty_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_partner_bounty_get 335 --请求阵营招募抽取
-- -------------------------------------------------------------------------------------------------------
function command_partner_bounty_get(str)
	str = str.."\r\n"
	str = str..protocol_command.partner_bounty_get.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.partner_bounty_get.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_union_pve_init 336 --请求阵营招募积分兑奖
-- -------------------------------------------------------------------------------------------------------
function command_partner_bounty_get_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.partner_bounty_get_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.partner_bounty_get_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_random_event_launch 337 --请求随机事件
-- -------------------------------------------------------------------------------------------------------
function command_random_event_launch(str)
	str = str.."\r\n"
	str = str..protocol_command.random_event_launch.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.random_event_launch.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_random_event_close 338 --请求关闭随机事件
-- -------------------------------------------------------------------------------------------------------
function command_random_event_close(str)
	str = str.."\r\n"
	str = str..protocol_command.random_event_close.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.random_event_close.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_random_event_refresh 339 --请求随机事件刷新
-- -------------------------------------------------------------------------------------------------------
function command_random_event_refresh(str)
	str = str.."\r\n"
	str = str..protocol_command.random_event_refresh.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.random_event_refresh.param_list
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- 	command_share_reward_init 340 --请求初始化分享信息
-- -------------------------------------------------------------------------------------------------------
function command_share_reward_init(str)
	str = str.."\r\n"
	str = str..protocol_command.share_reward_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.share_reward_init.param_list
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- 	command_share_reward 341 --请求领取分享奖励
-- -------------------------------------------------------------------------------------------------------
function command_share_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.share_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.share_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_share_game 342 --请求通知服务器邀请分享成功
-- -------------------------------------------------------------------------------------------------------
function command_share_game(str)
	str = str.."\r\n"
	str = str..protocol_command.share_game.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.share_game.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_random_event_open 343 --请求打开随机事件
-- -------------------------------------------------------------------------------------------------------
function command_random_event_open(str)
	str = str.."\r\n"
	str = str..protocol_command.random_event_open.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.random_event_open.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_random_event_open 344 --获取矿区所有工程奖励
-- -------------------------------------------------------------------------------------------------------
function command_mineral_reward_gain_all(str)
	str = str.."\r\n"
	str = str..protocol_command.mineral_reward_gain_all.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.mineral_reward_gain_all.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_bomb_purchase 345 --购买炸弹
-- -------------------------------------------------------------------------------------------------------
function command_bomb_purchase(str)
	str = str.."\r\n"
	str = str..protocol_command.bomb_purchase.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.bomb_purchase.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_ship_comment_init 346 --佣兵评论初始化
-- -------------------------------------------------------------------------------------------------------
function command_ship_comment_init(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_comment_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_comment_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_ship_comment_content 347 --查看佣兵评论内容
-- -------------------------------------------------------------------------------------------------------
function command_ship_comment_content(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_comment_content.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_comment_content.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_ship_comment_add 348 --添加佣兵评论
-- -------------------------------------------------------------------------------------------------------
function command_ship_comment_add(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_comment_add.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_comment_add.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_ship_comment_favour 348 --佣兵评论点赞
-- -------------------------------------------------------------------------------------------------------
function command_ship_comment_favour(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_comment_favour.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_comment_favour.param_list
	return str
end


-- -------------------------------------------------------------------------------------------------------
-- 	command_reply_grade 350 --评分通知
-- -------------------------------------------------------------------------------------------------------
function command_reply_grade(str)
	str = str.."\r\n"
	str = str..protocol_command.reply_grade.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.reply_grade.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_mine_event_launche 351 -- 矿区NPC战斗
-- -------------------------------------------------------------------------------------------------------
function command_mine_event_launch(str)
	str = str.."\r\n"
	str = str..protocol_command.mine_event_launch.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.mine_event_launch.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_mine_boss_launch 352 -- 矿区BOSS战斗
-- -------------------------------------------------------------------------------------------------------
function command_mine_boss_launch(str)
	str = str.."\r\n"
	str = str..protocol_command.mine_boss_launch.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.mine_boss_launch.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_mine_monster_reset 353 -- 重置矿区BOSS
-- -------------------------------------------------------------------------------------------------------
function command_mine_monster_reset(str)
	str = str.."\r\n"
	str = str..protocol_command.mine_monster_reset.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.mine_monster_reset.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_map_scattered_init 354 -- 初始化地图分布
-- -------------------------------------------------------------------------------------------------------
function command_map_scattered_init(str)
	str = str.."\r\n"
	str = str..protocol_command.map_scattered_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.map_scattered_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_map_init 355 -- 初始化地图信息
-- -------------------------------------------------------------------------------------------------------
function command_map_init(str)
	str = str.."\r\n"
	str = str..protocol_command.map_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.map_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_self_grab_land_init 356 -- 初始化个人占领信息接口
-- -------------------------------------------------------------------------------------------------------
function command_self_grab_land_init(str)
	str = str.."\r\n"
	str = str..protocol_command.self_grab_land_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.self_grab_land_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_hold_build 357 -- 占领接口
-- -------------------------------------------------------------------------------------------------------
function command_hold_build(str)
	str = str.."\r\n"
	str = str..protocol_command.hold_build.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.hold_build.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_hold_view 358 -- 占领效验
-- -------------------------------------------------------------------------------------------------------
function command_hold_view(str)
	str = str.."\r\n"
	str = str..protocol_command.hold_view.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.hold_view.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_hold_extend 359 -- 占领延长
-- -------------------------------------------------------------------------------------------------------
function command_hold_extend(str)
	str = str.."\r\n"
	str = str..protocol_command.hold_extend.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.hold_extend.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_hold_drop 360 -- 放弃占领
-- -------------------------------------------------------------------------------------------------------
function command_hold_drop(str)
	str = str.."\r\n"
	str = str..protocol_command.hold_drop.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.hold_drop.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_hold_drop_efficacy 361 -- 效验放弃占领奖励
-- -------------------------------------------------------------------------------------------------------
function command_hold_drop_efficacy(str)
	str = str.."\r\n"
	str = str..protocol_command.hold_drop_efficacy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.hold_drop_efficacy.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_marquee_init 362 -- GMxiaox
-- -------------------------------------------------------------------------------------------------------
function command_marquee_init(str)
	str = str.."\r\n"
	str = str..protocol_command.marquee_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.marquee_init.param_list
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- 	command_cast_soul_stone 363 -- 合成灵魂石
-- -------------------------------------------------------------------------------------------------------
function command_cast_soul_stone(str)
	str = str.."\r\n"
	str = str..protocol_command.cast_soul_stone.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.cast_soul_stone.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_command_make_contract 364 -- 签订契约
-- -------------------------------------------------------------------------------------------------------
function command_make_contract(str)
	str = str.."\r\n"
	str = str..protocol_command.make_contract.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.make_contract.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_command_make_contract 365 -- 签订契约
-- -------------------------------------------------------------------------------------------------------
function command_rush_four_attribute(str)
	str = str.."\r\n"
	str = str..protocol_command.rush_four_attribute.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.rush_four_attribute.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_command_make_contract 366 -- 排位赛信息初始化请求
-- -------------------------------------------------------------------------------------------------------
function command_warcraft_info_init(str)
	str = str.."\r\n"
	str = str..protocol_command.warcraft_info_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.warcraft_info_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_command_make_contract 367 -- 排位赛战斗请求
-- -------------------------------------------------------------------------------------------------------
function command_warcraft_fight(str)
	str = str.."\r\n"
	str = str..protocol_command.warcraft_fight.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.warcraft_fight.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_command_warcraft_get_reward 368 -- 排位赛奖励领取请求
-- -------------------------------------------------------------------------------------------------------
function command_warcraft_get_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.warcraft_get_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.warcraft_get_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_warcraft_shop_init369 -- 排位赛奖励领取请求
-- -------------------------------------------------------------------------------------------------------
function command_warcraft_shop_init(str)
	str = str.."\r\n"
	str = str..protocol_command.warcraft_shop_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.warcraft_shop_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_warcraft_shop_buy 370 -- 排位赛商店购买请求
-- -------------------------------------------------------------------------------------------------------
function command_warcraft_shop_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.warcraft_shop_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.warcraft_shop_buy.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_warcraft_show_rank_list 371 -- 排位赛查看排行版请求
-- -------------------------------------------------------------------------------------------------------
function command_warcraft_show_rank_list(str)
	str = str.."\r\n"
	str = str..protocol_command.warcraft_show_rank_list.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.warcraft_show_rank_list.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_warcraft_rush_fighte 372 -- -- 排位赛对手刷新
-- -------------------------------------------------------------------------------------------------------
function command_warcraft_rush_fighter(str)
	str = str.."\r\n"
	str = str..protocol_command.warcraft_rush_fighter.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.warcraft_rush_fighter.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_warcraft_buy_fight_count 373 -- -- 排位赛次数刷新
-- -------------------------------------------------------------------------------------------------------
function command_warcraft_buy_fight_count(str)
	str = str.."\r\n"
	str = str..protocol_command.warcraft_buy_fight_count.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.warcraft_buy_fight_count.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_warcraft_see_user_formation 374 -- -- 查看排位赛玩家阵型
-- -------------------------------------------------------------------------------------------------------
function command_warcraft_see_user_formation(str)
	str = str.."\r\n"
	str = str..protocol_command.warcraft_see_user_formation.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.warcraft_see_user_formation.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_switch_formation 375 -- -- -- 确定出战阵型ID
-- -------------------------------------------------------------------------------------------------------
function command_switch_formation(str)
	str = str.."\r\n"
	str = str..protocol_command.switch_formation.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.switch_formation.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_draw_win_count_reward 376 -- -- -- 领取连胜奖励
-- -------------------------------------------------------------------------------------------------------
function command_draw_win_count_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_win_count_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_win_count_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_buy_fourth_formation 377 -- -- --  购买阵型4
-- -------------------------------------------------------------------------------------------------------
function command_buy_fourth_formation(str)
	str = str.."\r\n"
	str = str..protocol_command.buy_fourth_formation.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.buy_fourth_formation.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_ship_one_key_escalate 378 -- -- -- 一键升级人物
-- -------------------------------------------------------------------------------------------------------
function command_ship_one_key_escalate(str)
	str = str.."\r\n"
	str = str..protocol_command.ship_one_key_escalate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_one_key_escalate.param_list
	return str
end


-- -------------------------------------------------------------------------------------------------------
-- 	command_ship_one_key_escalate 379 -- -- -- 一键升级装备
-- -------------------------------------------------------------------------------------------------------
function command_equipment_one_key_escalate(str)
	str = str.."\r\n"
	str = str..protocol_command.equipment_one_key_escalate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_one_key_escalate.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_ship_one_key_escalate 380 -- -- -- 一键升级装备
-- -------------------------------------------------------------------------------------------------------
function command_one_key_draw_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.one_key_draw_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.one_key_draw_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_draw_hold_integral_reward 381 -- -- -- 占领排行奖励
-- -------------------------------------------------------------------------------------------------------
function command_draw_hold_integral_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.draw_hold_integral_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_hold_integral_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_hold_integral_init 382 -- -- -- 占领排
-- -------------------------------------------------------------------------------------------------------
function command_hold_integral_init(str)
	str = str.."\r\n"
	str = str..protocol_command.hold_integral_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.hold_integral_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_unino_formation_menber_list 383 -- -- -- 请求公会战布阵成员列表
-- -------------------------------------------------------------------------------------------------------
function command_unino_formation_menber_list(str)
	str = str.."\r\n"
	str = str..protocol_command.unino_formation_menber_list.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.unino_formation_menber_list.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_unino_set_formation 384 -- -- -- 请求公会战布阵
-- -------------------------------------------------------------------------------------------------------
function command_unino_set_formation(str)
	str = str.."\r\n"
	str = str..protocol_command.unino_set_formation.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.unino_set_formation.param_list
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- 	command_unino_fight_apply 385 -- -- -- 请求报名公会战
-- -------------------------------------------------------------------------------------------------------
function command_unino_fight_apply(str)
	str = str.."\r\n"
	str = str..protocol_command.unino_fight_apply.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.unino_fight_apply.param_list
	return str
end


function command_unino_fight_init(str)
	str = str.."\r\n"
	str = str..protocol_command.unino_fight_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.unino_fight_init.param_list
	return str
end

function command_unino_fight(str)
	str = str.."\r\n"
	str = str..protocol_command.unino_fight.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.unino_fight.param_list
	return str
end

function command_unino_map_refush(str)
	str = str.."\r\n"
	str = str..protocol_command.unino_map_refush.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.unino_map_refush.param_list
	return str
end

function command_unino_message_refush(str)
	str = str.."\r\n"
	str = str..protocol_command.unino_message_refush.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.unino_message_refush.param_list
	return str
end

function command_draw_union_campsite_reward( str )
	str = str.."\r\n"
	str = str..protocol_command.draw_union_campsite_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_union_campsite_reward.param_list
	return str
end

function command_refush_cache_message( str )
	str = str.."\r\n"
	str = str..protocol_command.refush_cache_message.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.refush_cache_message.param_list
	return str
end

function command_fortune( str )
	str = str.."\r\n"
	str = str..protocol_command.fortune.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.fortune.param_list
	return str
end

function command_manor_double_reward( str )
	str = str.."\r\n"
	str = str..protocol_command.manor_double_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.manor_double_reward.param_list
	return str
end

function command_warcraft_info_refrush( str )
	str = str.."\r\n"
	str = str..protocol_command.warcraft_info_refrush.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.warcraft_info_refrush.param_list
	return str
end

function command_magic_trap_formation_change( str )
	str = str.."\r\n"
	str = str..protocol_command.magic_trap_formation_change.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.magic_trap_formation_change.param_list
	return str
end

function command_magic_trap_formation_clear( str )
	str = str.."\r\n"
	str = str..protocol_command.magic_trap_formation_clear.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.magic_trap_formation_clear.param_list
	return str
end

function command_awaken_shop_init( str )
	str = str.."\r\n"
	str = str..protocol_command.awaken_shop_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.awaken_shop_init.param_list
	return str
end

function command_awaken_shop_exchange( str )
	str = str.."\r\n"
	str = str..protocol_command.awaken_shop_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.awaken_shop_exchange.param_list
	return str
end

function command_awaken_shop_refresh( str )
	str = str.."\r\n"
	str = str..protocol_command.awaken_shop_refresh.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.awaken_shop_refresh.param_list
	return str
end

function command_awaken_equipment_form( str )
	str = str.."\r\n"
	str = str..protocol_command.awaken_equipment_form.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.awaken_equipment_form.param_list
	return str
end

function command_awaken_equipment_adron( str )
	str = str.."\r\n"
	str = str..protocol_command.awaken_equipment_adron.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.awaken_equipment_adron.param_list
	return str
end


function command_ship_awaken( str )
	str = str.."\r\n"
	str = str..protocol_command.ship_awaken.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.ship_awaken.param_list
	return str
end

function command_awaken_refine( str )
	str = str.."\r\n"
	str = str..protocol_command.awaken_refine.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.awaken_refine.param_list
	return str
end

function command_magic_trap_escalate( str )
	str = str.."\r\n"
	str = str..protocol_command.magic_trap_escalate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.magic_trap_escalate.param_list
	return str
end

function command_magic_trap_grow_up( str )
	str = str.."\r\n"
	str = str..protocol_command.magic_trap_grow_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.magic_trap_grow_up.param_list
	return str
end

function command_secret_shopman_exchange( str )
	str = str.."\r\n"
	str = str..protocol_command.secret_shopman_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.secret_shopman_exchange.param_list
	return str
end

function command_equipment_up_star( str )
	str = str.."\r\n"
	str = str..protocol_command.equipment_up_star.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.equipment_up_star.param_list
	return str
end

--上阵战宠修改
function command_pet_change_formation( str )
	str = str.."\r\n"
	str = str..protocol_command.pet_change_formation.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pet_change_formation.param_list
	return str
end

--请求战宠强化
function command_pet_escalate( str )
	str = str.."\r\n"
	str = str..protocol_command.pet_escalate.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pet_escalate.param_list
	return str
end

--请求战宠升星
function command_pet_grow_up( str )
	str = str.."\r\n"
	str = str..protocol_command.pet_grow_up.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pet_grow_up.param_list
	return str
end

--请求战宠商店初始化
function command_pet_shop_init( str )
	str = str.."\r\n"
	str = str..protocol_command.pet_shop_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pet_shop_init.param_list
	return str
end

--请求战宠商店刷新
function command_pet_shop_refresh( str )
	str = str.."\r\n"
	str = str..protocol_command.pet_shop_refresh.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pet_shop_refresh.param_list
	return str
end

--请求战宠商店购买
function command_pet_shop_exchange( str )
	str = str.."\r\n"
	str = str..protocol_command.pet_shop_exchange.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pet_shop_exchange.param_list
	return str
end

--请求战宠训练
function command_pet_train( str )
	str = str.."\r\n"
	str = str..protocol_command.pet_train.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pet_train.param_list
	return str
end

--请求战宠驯养
function command_pet_equip( str )
	str = str.."\r\n"
	str = str..protocol_command.pet_equip.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pet_equip.param_list
	return str
end

--请求战宠副本初始化数据
function command_pet_counterpart_init( str )
	str = str.."\r\n"
	str = str..protocol_command.pet_counterpart_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pet_counterpart_init.param_list
	return str
end

--请求战宠副本战斗
function command_pet_counterpart_launch( str )
	str = str.."\r\n"
	str = str..protocol_command.pet_counterpart_launch.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pet_counterpart_launch.param_list
	return str
end

--请求宠物副本奖励
function command_pet_counterpart_get_reward( str )
	str = str.."\r\n"
	str = str..protocol_command.pet_counterpart_get_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pet_counterpart_get_reward.param_list
	return str
end

--请求下一关卡副本
function command_pet_counterpart_go_next( str )
	str = str.."\r\n"
	str = str..protocol_command.pet_counterpart_go_next.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pet_counterpart_go_next.param_list
	return str
end

--请求重置宠物副本
function command_pet_counterpart_reset( str )
	str = str.."\r\n"
	str = str..protocol_command.pet_counterpart_reset.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.pet_counterpart_reset.param_list
	return str
end

--请求领取分享奖励
function command_new_share_reward_init( str )
	str = str.."\r\n"
	str = str..protocol_command.new_share_reward_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.new_share_reward_init.param_list
	return str
end

--请求分享初始化
function command_draw_share_reward( str )
	str = str.."\r\n"
	str = str..protocol_command.draw_share_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.draw_share_reward.param_list
	return str
end

--请求竞技场一键扫荡
function command_one_key_sweep_arena( str )
	str = str.."\r\n"
	str = str..protocol_command.one_key_sweep_arena.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.one_key_sweep_arena.param_list
	return str
end

--请求无限山一键三星
function command_one_key_sweep_three_kingdoms( str )
	str = str.."\r\n"
	str = str..protocol_command.one_key_sweep_three_kingdoms.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.one_key_sweep_three_kingdoms.param_list
	return str
end
-- -------------------------------------------------------------------------------------------------------
-- 	command_id_register 410 --防沉迷注册请求
-- -------------------------------------------------------------------------------------------------------
function command_id_register(str)
	str = str.."\r\n"
	str = str..protocol_command.id_register.command
	str = str.."\r\n"
	str = str..protocol_command.id_register.param_list
	return str	
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_id_register 411 --防沉迷记录生日
-- -------------------------------------------------------------------------------------------------------
function command_birthday_record(str)
	str = str.."\r\n"
	str = str..protocol_command.birthday_record.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.birthday_record.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- 	command_id_register 412 --防沉迷验证
-- -------------------------------------------------------------------------------------------------------
function command_vali_id(str)
	str = str.."\r\n"
	str = str..protocol_command.vali_id.command
	str = str.."\r\n"
	str = str..protocol_command.vali_id.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- command_rush_fight_times 482  跨服战倒计时刷新
-- -------------------------------------------------------------------------------------------------------
function command_rush_fight_times(str)
	str = str.."\r\n"
	str = str..protocol_command.rush_fight_times.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.rush_fight_times.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- limited_recharge_init 490  请求限时优惠
-- -------------------------------------------------------------------------------------------------------
function command_limited_recharge_init(str)
	str = str.."\r\n"
	str = str..protocol_command.limited_recharge_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.limited_recharge_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- limited_recharge_buy 491  请求购买限时优惠道具
-- -------------------------------------------------------------------------------------------------------
function command_limited_recharge_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.limited_recharge_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.limited_recharge_buy.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- limited_recharge_get_reward 492  请求限时优惠全民福利领奖
-- -------------------------------------------------------------------------------------------------------
function command_limited_recharge_get_reward(str)
	str = str.."\r\n"
	str = str..protocol_command.limited_recharge_get_reward.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.limited_recharge_get_reward.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- rebel_boss_init 520  请求叛军初始化
-- -------------------------------------------------------------------------------------------------------
function command_rebel_boss_init(str)
	str = str.."\r\n"
	str = str..protocol_command.rebel_boss_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.rebel_boss_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- rebel_boss_fight 521  请求叛军战斗
-- -------------------------------------------------------------------------------------------------------
function command_rebel_boss_fight(str)
	str = str.."\r\n"
	str = str..protocol_command.rebel_boss_fight.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.rebel_boss_fight.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- level_gift_buy 550  请求等级礼包购买/领取
-- -------------------------------------------------------------------------------------------------------
function command_level_gift_buy(str)
	str = str.."\r\n"
	str = str..protocol_command.level_gift_buy.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.level_gift_buy.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- user_create_time 560  请求角色创建时间
-- -------------------------------------------------------------------------------------------------------
function command_user_create_time(str)
	str = str.."\r\n"
	str = str..protocol_command.user_create_time.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.user_create_time.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- user_create_time 561  请求top排行榜初始化
-- -------------------------------------------------------------------------------------------------------
function command_top_rank_init(str)
	str = str.."\r\n"
	str = str..protocol_command.top_rank_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.top_rank_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- user_create_time 561  请求充值排行初始化
-- -------------------------------------------------------------------------------------------------------
function command_recharge_rank_init(str)
	str = str.."\r\n"
	str = str..protocol_command.recharge_rank_init.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.recharge_rank_init.param_list
	return str
end

-- -------------------------------------------------------------------------------------------------------
-- user_create_time 562  请求在線禮包初始化
-- -------------------------------------------------------------------------------------------------------
function command_get_online_gift_info(str)
	str = str.."\r\n"
	str = str..protocol_command.get_online_gift_info.command
	str = str.."\r\n"
	str = str.._ED.user_info.user_id
	str = str.."\r\n"
	str = str..protocol_command.get_online_gift_info.param_list
	return str
end




