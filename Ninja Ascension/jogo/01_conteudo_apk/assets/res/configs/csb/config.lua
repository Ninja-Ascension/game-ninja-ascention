config_csb = config_csb or {}

-- activity
config_csb.activity = config_csb.activity or {}

-- activity.dailytasks
config_csb.activity.dailytasks = config_csb.activity.dailytasks or {}
config_csb.activity.dailytasks.task												= "activity/dailytasks/task.csb"
config_csb.activity.dailytasks.task_listview									= "activity/dailytasks/task_listview.csb"

-- battle
config_csb.battle = config_csb.battle or {}
config_csb.battle.battle_map													= "battle/battle_map_%s.csb"
config_csb.battle.battle_win													= "battle/battle_win.csb"
config_csb.battle.battle_fail													= "battle/battle_fail.csb"
config_csb.battle.battle_ui														= "battle/battle_ui.csb"
config_csb.battle.battle_time_out												= "battle/battle_time_out.csb"

-- campaign
config_csb.campaign = config_csb.campaign or {}
config_csb.campaign.campaign													= "campaign/campaign.csb"

--campaign.arena_storage  
config_csb.campaign.ArenaStorage = config_csb.campaign.ArenaStorage or {}
config_csb.campaign.ArenaStorage.ArenaStorage_jifen								= "campaign/ArenaStorage/ArenaStorage_jifen.csb"
config_csb.campaign.ArenaStorage.ArenaStorage_jifen_list						= "campaign/ArenaStorage/ArenaStorage_jifen_list.csb"
config_csb.campaign.ArenaStorage.ArenaStorage_ranking_reward					= "campaign/ArenaStorage/ArenaStorage_ranking_reward.csb"
config_csb.campaign.ArenaStorage.ArenaStorage_ranking_reward_list				= "campaign/ArenaStorage/ArenaStorage_ranking_reward_list.csb"
-- font
config_csb.campaign.nationalwar_font 											= "fonts/FZYiHei-M20S.ttf"

-- campaign.nationalwar
config_csb.campaign.nationalwar = config_csb.campaign.nationalwar or {}
config_csb.campaign.nationalwar.national_truce									= "campaign/nationalwar/nationalwar.csb"
config_csb.campaign.nationalwar.nationalwar_build_button						= "campaign/nationalwar/nationalwar_build_button.csb"
config_csb.campaign.nationalwar.nationalwar_build_decree						= "campaign/nationalwar/nationalwar_build_decree.csb"
config_csb.campaign.nationalwar.nationalwar_decree								= "campaign/nationalwar/nationalwar_decree.csb"
config_csb.campaign.nationalwar.nationalwar_build_infor							= "campaign/nationalwar/nationalwar_build_infor.csb"
config_csb.campaign.nationalwar.nationalwar_listview							= "campaign/nationalwar/nationalwar_listview.csb"
config_csb.campaign.nationalwar.nationalwar_map									= "campaign/nationalwar/nationalwar_map.csb"
config_csb.campaign.nationalwar.nationalwar_map_top_infor						= "campaign/nationalwar/nationalwar_map_top_infor.csb"
config_csb.campaign.nationalwar.nationalwar_map_build							= "campaign/nationalwar/nationalwar_map_build.csb"
config_csb.campaign.nationalwar.nationalwar_rank								= "campaign/nationalwar/nationalwar_rank.csb"
config_csb.campaign.nationalwar.nationalwar_rank_cell_left						= "campaign/nationalwar/nationalwar_rank_cell_left.csb"
config_csb.campaign.nationalwar.nationalwar_rank_listview						= "campaign/nationalwar/nationalwar_rank_listview.csb"
config_csb.campaign.nationalwar.nationalwar_rank_son_1							= "campaign/nationalwar/nationalwar_rank_son_1.csb"
config_csb.campaign.nationalwar.nationalwar_rank_son_2							= "campaign/nationalwar/nationalwar_rank_son_2.csb"
config_csb.campaign.nationalwar.nationalwar_reward								= "campaign/nationalwar/nationalwar_reward.csb"
config_csb.campaign.nationalwar.nationalwar_reward_listview						= "campaign/nationalwar/nationalwar_reward_listview.csb"
config_csb.campaign.nationalwar.nationalwar_task								= "campaign/nationalwar/nationalwar_task.csb"
config_csb.campaign.nationalwar.nationalwar_fighting							= "campaign/nationalwar/nationalwar_fighting.csb"
config_csb.campaign.nationalwar.natinalwar_hero_listview						= "campaign/nationalwar/natinalwar_hero_listview.csb"
config_csb.campaign.nationalwar.natinalwar_smlle_map							= "campaign/nationalwar/natinalwar_smlle_map.csb"
config_csb.campaign.nationalwar.nationalwar_hero_icon							= "battle/battle_ui_icon.csb"
config_csb.campaign.nationalwar.nationalwar_battle_ui							= "campaign/nationalwar/nationalwar_battle_ui.csb"
config_csb.campaign.nationalwar.natinalwar_battle_map							= "campaign/nationalwar/natinalwar_battle_map.csb"
config_csb.campaign.nationalwar.nationalwar_tactical							= "campaign/nationalwar/nationalwar_tactical.csb"
config_csb.campaign.nationalwar.nationalwar_settlement_battle					= "campaign/nationalwar/nationalwar_settlement_battle.csb"
config_csb.campaign.nationalwar.nationalwar_occupied_billing					= "campaign/nationalwar/nationalwar_occupied_billing.csb"
config_csb.campaign.nationalwar.nationalwar_decree_tow							= "campaign/nationalwar/nationalwar_decree_tow.csb"
config_csb.campaign.nationalwar.natinalwar_revive_time							= "campaign/nationalwar/natinalwar_revive_time.csb"
config_csb.campaign.nationalwar.nationalwar_record								= "campaign/nationalwar/nationalwar_record.csb"
config_csb.campaign.nationalwar.nationalwar_military_order						= "campaign/nationalwar/nationalwar_military_order.csb"
config_csb.campaign.nationalwar.nationalwar_billing								= "campaign/nationalwar/nationalwar_billing.csb"
config_csb.campaign.nationalwar.nationalwar_shop								= "campaign/nationalwar/nationalwar_shop.csb"
config_csb.campaign.nationalwar.natinalwar_kill_max								= "campaign/nationalwar/natinalwar_kill_max.csb"
config_csb.campaign.nationalwar.nationalwar_my_fight_info						= "campaign/nationalwar/nationalwar_my_fight_info.csb"
config_csb.campaign.nationalwar.nationalwar_battle_renovate						= "campaign/nationalwar/nationalwar_battle_renovate.csb"

-- cells
config_csb.cells = config_csb.cells or {}
config_csb.cells.player_head_info												= "cells/player_head_cell.csb"

-- cells.activity
config_csb.cells.activity = config_csb.cells.activity or {}

-- cells.activity.dailytasks
config_csb.cells.activity.dailytasks = config_csb.cells.activity.dailytasks or {}
config_csb.cells.activity.dailytasks.task_cell									= "cells/activity/dailytasks/task_cell.csb"

-- cells.campaign
config_csb.cells.campaign = config_csb.cells.campaign or {}
config_csb.cells.campaign.campaign_cell 										= "cells/campaign/campaign_cell.csb"

-- cells.campaign.nationalwar
config_csb.cells.campaign.nationalwar = config_csb.cells.campaign.nationalwar or {}
config_csb.cells.campaign.nationalwar.nationalwar_rank_cell_right				= "cells/campaign/nationalwar/nationalwar_rank_cell_right.csb"
config_csb.cells.campaign.nationalwar.nationalwar_reward_cell					= "cells/campaign/nationalwar/nationalwar_reward_cell.csb"
config_csb.cells.campaign.nationalwar.nationalwar_task_cell						= "cells/campaign/nationalwar/nationalwar_task_cell.csb"
config_csb.cells.campaign.nationalwar.nationalwar_build_infor_cell				= "cells/campaign/nationalwar/nationalwar_build_infor_cell.csb"
config_csb.cells.campaign.nationalwar.nationalwar_decree_cell					= "cells/campaign/nationalwar/nationalwar_decree_cell.csb"
config_csb.cells.campaign.nationalwar.nationalwar_battle_hero					= "cells/campaign/nationalwar/nationalwar_battle_hero.csb"
config_csb.cells.campaign.nationalwar.nationalwar_military_order_cell			= "cells/campaign/nationalwar/nationalwar_military_order_cell.csb"

-- cells.hero
config_csb.cells.hero = config_csb.cells.hero or {}
config_csb.cells.hero.hero_icon_cell 											= "cells/hero/hero_icon_cell.csb"
config_csb.cells.hero.hero_packs_icon_cell 										= "cells/hero/hero_packs_icon_cell.csb"
config_csb.cells.hero.hero_main_skills_up_cell 									= "cells/hero/hero_main_skills_up_cell.csb"
config_csb.cells.hero.hero_fetters_cell 										= "cells/hero/hero_fetters_cell.csb"
config_csb.cells.hero.hero_fetter_chosee_cell 									= "cells/hero/hero_fetter_chosee_cell.csb"

-- cells.home
config_csb.cells.home = config_csb.cells.home or {}
config_csb.cells.home.home_build_cell 											= "cells/home/home_build_cell.csb"

-- cells.duplicate
config_csb.cells.duplicate = config_csb.cells.duplicate or {}
config_csb.cells.duplicate.duplicate_list_cell 									= "cells/duplicate/duplicate_list_cell.csb"
config_csb.cells.duplicate.duplicate_npc_cell 									= "cells/duplicate/duplicate_npc_cell.csb"
config_csb.cells.duplicate.duplicate_current_level_cell							= "cells/duplicate/duplicate_current_level_cell.csb"
config_csb.cells.duplicate.duplicate_raids_cell									= "cells/duplicate/duplicate_raids_cell.csb"

-- cells.shop
config_csb.cells.shop = config_csb.cells.shop or {}
config_csb.cells.shop.mystery_shop_cell											= "cells/shop/mystery_shop_cell.csb"

-- cells.login
config_csb.cells.login = config_csb.cells.login or {}
config_csb.cells.login.server_list_left_cell								    = "cells/login/server_list_left_cell.csb"
config_csb.cells.login.server_list_cell											= "cells/login/server_list_cell.csb"

-- cells.game_announcement
config_csb.cells.game_announcement = config_csb.cells.game_announcement or {}
config_csb.cells.game_announcement.game_announcement_cell 						= "cells/game_announcement/game_announcement_cell.csb"
config_csb.cells.game_announcement.game_announcement_list_one					= "game_announcement/game_announcement_list_1.csb"

-- recharge
config_csb.cells.recharge = config_csb.cells.recharge or {}
config_csb.cells.recharge.recharge_cell											= "cells/recharge/recharge_cell.csb" 

-- cells.reward
config_csb.cells.reward = config_csb.cells.reward or {}
config_csb.cells.reward.star_box_duplicate_cell									= "cells/reward/star_box_duplicate_cell.csb"

-- chat
config_csb.chat = config_csb.chat or {}
config_csb.chat.chat_view 														= "chat/chat_view.csb"

-- duplicate
config_csb.duplicate = config_csb.duplicate or {}
config_csb.duplicate.duplicate_manager											= "duplicate/duplicate_manager.csb"
config_csb.duplicate.easy_duplicate 											= "duplicate/duplicate.csb"
config_csb.duplicate.normal_duplicate 											= "duplicate/duplicate.csb"
config_csb.duplicate.hard_duplicate 											= "duplicate/duplicate.csb"
config_csb.duplicate.duplicate_title											= "duplicate/duplicate_title.csb"
config_csb.duplicate.duplicate_npc_icon											= "duplicate/duplicate_npc_icon.csb"
config_csb.duplicate.duplicate_npc_window										= "duplicate/duplicate_npc_window.csb"
config_csb.duplicate.duplicate_star_box_window									= "duplicate/duplicate_star_box_window.csb"
config_csb.duplicate.duplicate_raids											= "duplicate/duplicate_raids.csb"

-- duplicate.map
config_csb.duplicate.map = config_csb.duplicate.map or {}
config_csb.duplicate.map.duplicate_map											= "duplicate/map/duplicate_map_%s.csb"

-- forgoing
config_csb.forging = config_csb.forging or {}
config_csb.forging.refining 													= "forging/refining.csb"
config_csb.forging.rebirth 														= "forging/rebirth.csb"
config_csb.forging.combining 													= "forging/combining.csb"
config_csb.forging.forging_scrollview 											= "forging/forging_scrollview.csb"
config_csb.forging.refining_batch												= "forging/refining_batch.csb"

-- formation
config_csb.formation = config_csb.formation or {}
config_csb.formation.formation_setting 											= "formation/formation_setting.csb"

-- home 
config_csb.home = config_csb.home or {}
config_csb.home.home_button 													= "home/home_button.csb"
config_csb.home.home_button_foraction 											= "home/home_button_foraction.csb"
config_csb.home.main_window 													= "home/main_window.csb"
config_csb.home.home_select_action 												= "home/home_select_action_%s.csb"
config_csb.home.build_level_up 													= "home/build_level_up.csb"
config_csb.home.protagonist_skills 												= "home/protagonist_skills.csb"

-- hero
config_csb.hero = config_csb.hero or {}
config_csb.hero.hero_main														= "hero/hero_main.csb"
config_csb.hero.hero_main_grow_up										    	= "hero/hero_main_grow_up.csb"
config_csb.hero.hero_main_skills_up												= "hero/hero_main_skills_up.csb"
config_csb.hero.hero_main_star_up										        = "hero/hero_main_star_up.csb"
config_csb.hero.hero_fetters										            = "hero/hero_fetters.csb"
config_csb.hero.hero_attributes										            = "hero/hero_attributes.csb"
config_csb.hero.hero_main_god_hero										        = "hero/hero_main_god_hero.csb"
config_csb.hero.hero_star_activation										    = "hero/hero_star_activation.csb"
config_csb.hero.hero_talent_activation										    = "hero/hero_talent_activation.csb"
config_csb.hero.hero_fetter_chosee										    	= "hero/hero_fetter_chosee.csb"

-- login
config_csb.login = config_csb.login or {} 
config_csb.login.server_managers												= "login/server_managers.csb"
config_csb.login.create_character												= "login/create_character.csb"
config_csb.login.camp_chose 													= "login/camp_chose.csb"
config_csb.login.camp_chose_join												= "login/camp_chose_join.csb"

-- packs
config_csb.packs = config_csb.packs or {}
config_csb.packs.packs															= "packs/packs.csb"
config_csb.packs.packs_scrollview												= "packs/packs_scrollview.csb"
config_csb.packs.to_get_window													= "packs/to_get_window.csb"
config_csb.packs.warehouse_information_2										= "packs/warehouse_information_2.csb"

-- packs.equipstorage
config_csb.packs.equipstorage = config_csb.packs.equipstorage or {}
config_csb.packs.equipstorage.equipment											= "packs/equipstorage/equipment.csb"
config_csb.packs.equipstorage.equipment_wear 									= "packs/equipstorage/equipment_wear.csb"

-- packs.herostorage
config_csb.packs.herostorage = config_csb.packs.herostorage or {}
config_csb.packs.herostorage.hero_packs 										= "packs/herostorage/hero_packs.csb"
config_csb.packs.herostorage.hero_packs_scrollview 								= "packs/herostorage/hero_packs_scrollview.csb"
config_csb.packs.herostorage.hero_packs_information								= "packs/herostorage/hero_packs_information.csb"
config_csb.packs.herostorage.sm_role_strengthen_tab_cell_3_window				= "packs/herostorage/sm_role_strengthen_tab_cell_3_window.csb"

-- player
config_csb.player = config_csb.player or {}
config_csb.player.player_info 													= "player/player_info.csb"
config_csb.player.player_resource 												= "player/player_resource.csb"
config_csb.player.player_upgrade 												= "player/player_upgrade.csb"

-- recharge
config_csb.recharge = config_csb.recharge or {}
config_csb.recharge.recharge													= "recharge/recharge.csb" 

-- recruit
config_csb.recruit = config_csb.recruit or {}
config_csb.recruit.hero_recruit													= "recruit/hero_recruit.csb"
config_csb.recruit.hero_recruit_one												= "recruit/hero_recruit_one.csb"
config_csb.recruit.hero_recruit_ten												= "recruit/hero_recruit_ten.csb"

-- shop
config_csb.shop = config_csb.shop or {}
config_csb.shop.mystery_shop  													= "shop/mystery_shop.csb"
config_csb.shop.mystery_shop_buy  												= "shop/mystery_shop_buy.csb"
config_csb.shop.buy_exp_props  													= "shop/buy_exp_props.csb"

-- utils
config_csb.utils = config_csb.utils or {}
config_csb.utils.loading_window													= "utils/loading_window.csb"
config_csb.utils.reward_obtain													= "utils/reward_obtain.csb"
config_csb.utils.props_information												= "utils/props_information.csb"
config_csb.utils.buy_resource  												    = "utils/buy_resource.csb"
config_csb.utils.prompt_1														= "utils/prompt_1.csb"
config_csb.utils.fight_up														= "utils/fight_up.csb"
config_csb.utils.prompt_server_time												= "utils/prompt_server_time.csb"

-- game_announcement
config_csb.game_announcement = config_csb.game_announcement or {}
config_csb.game_announcement.game_announcement 									= "game_announcement/game_announcement.csb"

config_csb.union_fight = config_csb.union_fight or {}
config_csb.union_fight.sm_legion_ghz 									= "legion/sm_legion_ghz.csb"
config_csb.union_fight.sm_legion_ghz_tab 								= "legion/sm_legion_ghz_tab_%d.csb"
config_csb.union_fight.sm_legion_ghz_tab_1_cell 						= "legion/sm_legion_ghz_tab_1_cell.csb"
config_csb.union_fight.sm_legion_ghz_tab_4_cell 						= "legion/sm_legion_ghz_tab_4_cell_%d.csb"
config_csb.union_fight.sm_legion_ghz_line_up 							= "legion/sm_legion_ghz_line_up.csb"
config_csb.union_fight.sm_legion_ghz_line_up_cell 						= "legion/sm_legion_ghz_line_up_cell_%d.csb"
config_csb.union_fight.sm_legion_ghz_line_up_icon 						= "legion/sm_legion_ghz_line_up_icon.csb"
config_csb.union_fight.sm_legion_ghz_fighting 							= "legion/sm_legion_ghz_fighting.csb"
config_csb.union_fight.sm_legion_ghz_fighting_cell 						= "legion/sm_legion_ghz_fighting_cell_%d.csb"
config_csb.union_fight.sm_legion_ghz_rule 						        = "legion/sm_legion_ghz_rule.csb"
config_csb.union_fight.sm_legion_ghz_rule_cell 						    = "legion/sm_legion_ghz_rule_cell_%d.csb"
config_csb.union_fight.sm_legion_ghz_rank 						        = "legion/sm_legion_ghz_rank.csb"
config_csb.union_fight.sm_legion_ghz_rank_cell 						    = "legion/sm_legion_ghz_rank_cell_%d.csb"
config_csb.union_fight.sm_legion_ghz_js_fighting 						= "legion/sm_legion_ghz_js_fighting.csb"

-- image path
config_img = config_img or {}

config_img.imagePath = config_img.imagePath or {}
config_img.imagePath.nationalwar_paihang										= "images/ui/play/secret_society/paihang_%s.png"
config_img.imagePath.nationalwar_paihang_jiangli								= "images/ui/text/paihangb_%s.png"