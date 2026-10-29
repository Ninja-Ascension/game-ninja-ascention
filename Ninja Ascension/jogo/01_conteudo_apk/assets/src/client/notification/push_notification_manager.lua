-- Initialize push notification center state machine.
local function init_push_notification_center_terminal()
    local push_notification_center_manager_terminal = {
        _name = "push_notification_center_manager",
        _init = function (terminal)

            --if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto then 
				--临时添加，后面跟新底层后还原代码
                app.load("client.notification.push_local_datas")
            --end
			app.load("client.cells.utils.notification_tip_cell")
		
            app.load("client.notification.push_notification_activity")
            app.load("client.notification.push_notification_formation")
            app.load("client.notification.push_notification_mall")
            app.load("client.notification.push_notification_shop")
            app.load("client.notification.push_notification_equipment_warehouse")
            app.load("client.notification.push_notification_ship_warehouse")
            app.load("client.notification.push_notification_recovery")
            app.load("client.notification.push_notification_military_rank")
            app.load("client.notification.push_notification_expedition")
            app.load("client.notification.push_notification_battle")
            app.load("client.notification.push_notification_friend")
            app.load("client.notification.push_notification_chat")
            app.load("client.notification.push_notification_player")
            
			if __lua_project_id == __lua_project_gragon_tiger_gate
                or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                or __lua_project_id == __lua_project_red_alert 
                then
                app.load("client.notification.push_notification_capture")
                app.load("client.notification.push_notification_union")
            end
            app.load("client.notification.push_notification_home_expand")
			if (__lua_project_id == __lua_project_warship_girl_a 
				or __lua_project_id == __lua_project_warship_girl_b 
				or __lua_project_id == __lua_project_digimon_adventure 
				or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_pokemon 
                		or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_yugioh)
                and ___is_open_union == true 
                then
				app.load("client.notification.push_notification_union")
			end
			if __lua_project_id == __lua_project_adventure then
				app.load("client.notification.push_notification_adventure_home")
				app.load("client.notification.push_notification_adventure_mercenary")
				app.load("client.notification.push_notification_adventure_achievement")
				app.load("client.notification.push_notification_adventure_sign_in")
				app.load("client.notification.push_notification_adventure_mining")
				app.load("client.notification.push_notification_adventure_activity")
                app.load("client.notification.push_notification_adventure_friend")
			end
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                app.load("client.notification.push_notification_every_day_sign")
                app.load("client.notification.push_notification_sm_arena")
                app.load("client.notification.push_notification_sm_special_duplicate")
                app.load("client.notification.push_notification_sm_hero_develop")
                app.load("client.notification.push_notification_cultivate")
            end
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            state_machine.excute("notification_center_register", 0, params)
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    state_machine.add(push_notification_center_manager_terminal)
    state_machine.init()
end
init_push_notification_center_terminal()
