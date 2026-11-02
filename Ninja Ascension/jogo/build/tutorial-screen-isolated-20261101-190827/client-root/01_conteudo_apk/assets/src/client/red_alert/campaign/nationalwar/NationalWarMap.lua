-----------------------------
--国战地图
-----------------------------
NationalWarMap = class("NationalWarMapClass", Window)

local npcs_table_one = {}
local npcs_table_two = {}
local npcs_table_three = {}

local national_war_map_window_open_terminal = {
    _name = "national_war_map_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local _Window = fwin:find("NationalWarMapClass")
        if nil == _Window then
            fwin:open(NationalWarMap:new():init(params), fwin._view)
        end
        state_machine.excute("warship_girl_push_info_open",0,{_datas={_openType=7}})
		if tonumber(params[1]) == 1 then
			if missionIsOver() == true or zstring.tonumber(_ED.user_info.user_experience) > 0 then
				app.load("client.red_alert.home.HomeButtonForAction")
				state_machine.excute("home_button_for_action_window_open",0,"")
                state_machine.excute("home_button_for_action_play_hide", 0, "")
                state_machine.excute("home_button_for_action_hide_task_target", 0, false)
			end
		end
        _ED._push_rivers = 0
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_war_map_window_close_terminal = {
    _name = "national_war_map_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarMapClass"))
        state_machine.excute("union_fighting_review_time_close", 0, nil)
		if params._datas.open_type==1 then
			state_machine.excute("campaign_window_close",0,"")
            cacher.clearWindowCacher()
		else
			state_machine.excute("natinal_war_revivetime_window_close",0,"")
			state_machine.excute("national_truce_open",0,"")
			state_machine.excute("national_war_kill_max_window_close",0,"")
			state_machine.excute("warship_girl_push_info_close",0,"")
			for i,v in pairs(npcs_table_one) do
				v:release()
			end
			for i,v in pairs(npcs_table_two) do
				v:release()
			end
			for i,v in pairs(npcs_table_three) do
				v:release()
			end
			npcs_table_one = {}
			npcs_table_two = {}
			npcs_table_three = {}
		end
        _ED._push_rivers = 1
        -- _ED.presonal_fighting_map_info = {}
        state_machine.excute("home_button_for_action_play_show", 0, "")
        state_machine.excute("home_button_for_action_hide_task_target", 0, true)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_war_map_draw_npc_camp_one_terminal = {
    _name = "national_war_map_draw_npc_camp_one",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        table.insert(npcs_table_one, params)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_war_map_draw_npc_camp_two_terminal = {
    _name = "national_war_map_draw_npc_camp_two",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        table.insert(npcs_table_two, params)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_war_map_draw_npc_camp_three_terminal = {
    _name = "national_war_map_draw_npc_camp_three",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        table.insert(npcs_table_three, params)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(national_war_map_window_open_terminal)
state_machine.add(national_war_map_window_close_terminal)
state_machine.add(national_war_map_draw_npc_camp_one_terminal)
state_machine.add(national_war_map_draw_npc_camp_two_terminal)
state_machine.add(national_war_map_draw_npc_camp_three_terminal)
state_machine.init()

function NationalWarMap:ctor()
    self.super:ctor()
    self.roots = {}

    app.load("client.red_alert.campaign.nationalwar.NationalWarMapTopInfo")
    app.load("client.red_alert.campaign.nationalwar.NationalWarMapBuild")
    app.load("client.red_alert.campaign.nationalwar.NationalWarBuildButton")
    app.load("client.red_alert.campaign.nationalwar.NationalWarBuildInfor")
    app.load("client.red_alert.campaign.nationalwar.NationalWarBuildDecree")
    app.load("client.red_alert.campaign.nationalwar.NationalWarDecree")
    app.load("client.red_alert.campaign.nationalwar.NationalWarFighting")
    app.load("client.red_alert.campaign.nationalwar.NationalWarHeroIcon")
    app.load("client.red_alert.campaign.nationalwar.NatinalWarHeroListview")
    app.load("client.red_alert.campaign.nationalwar.NatinalWarSmlleMap")
    app.load("client.red_alert.campaign.nationalwar.NationalWarCityWarMap")
    app.load("client.red_alert.campaign.nationalwar.NationalWarDecreeTow")
    app.load("client.red_alert.campaign.nationalwar.NatinalWarReviveTime")
    app.load("client.red_alert.campaign.nationalwar.NationalWarRecord")
    app.load("client.red_alert.campaign.nationalwar.NatinalWarBuyResource")
    app.load("client.red_alert.campaign.nationalwar.PathFinding")
    app.load("client.red_alert.campaign.nationalwar.NationalWarBilling")
    app.load("client.red_alert.campaign.nationalwar.NationalWarKillMax")
    app.load("client.red_alert.campaign.nationalwar.NationalWarMyFightInfo")
    app.load("client.red_alert.campaign.nationalwar.NationalWarBattleRenovate")
	app.load("client.red_alert.campaign.nationalwar.NationalCityWorldBigMap")
	app.load("client.red_alert.campaign.nationalwar.NationalCityWorldBigMap")
    app.load("client.red_alert.cells.campaign.nationalwar.big_map_res_cell")
    app.load("client.red_alert.cells.big_map.map_raiderscut_npc_cell")
    app.load("client.red_alert.big_map.MapRattlingRanking")

    app.load("client.red_alert.union.unionFighting.UnionFightingMain")
    app.load("client.red_alert.union.unionFighting.UnionFightingReviewTime")
    app.load("client.red_alert.union.unionFighting.UnionFightingAttackRank")

    
    app.load("client.red_alert.personal_fight.PersonalFightBuildInfor")
    app.load("client.red_alert.personal_fight.PersonalFightResult")
    app.load("client.red_alert.cells.personal_fight.personal_player_build_map_cell")

    app.load("client.red_alert.personal_fight.PersonalFightRanking")

    self.user_at_city_id = nil
    self.city_data = nil
    self.armature = nil
    self.move_state = 0 -- 0没有移动。1 移动中
    self.will_move_table = {}
    self.scroll_view = nil
    self.now_persent_x = nil
    self.now_persent_y = nil
    self.move_index = nil
    self._last_time = nil
    self._last_city_animation_time = nil
    self._city_cells = {}
    self._sprite_all_node_table = {}
    self._sprite_city_node_table = {}
    self.panel_citys = {}
    self.last_task_level = nil
    self.war_fight_is_over = false
    self.last_time_update_all_info = nil
    self.back_city_button = nil
    self._last_get_order_time = nil
    self.last_city_id = nil
	
	self.open_type = 0
	self.m_size = 0
	self.scroll_viewWidth = 0
	self.scroll_viewHeight = 0

    self._last_resource_city_id = -1

    self._move_player_count = 0
    self._max_move_player_count = 15

    -- Initialize NationalWarMap state machine.
    local function init_national_war_map_terminal()
        -- 显示
        local national_war_map_window_show_terminal = {
            _name = "national_war_map_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 隐藏
        local national_war_map_window_hide_terminal = {
            _name = "national_war_map_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }         
        -- 移动自己的角色 -- 过程
        local national_war_map_move_my_pos_terminal = {
            _name = "national_war_map_move_my_pos",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.war_user_dead == true then
                    TipDlg.drawTextDailog(red_alert_all_str[46])
                    return
                end
				
                if self.open_type==1 then
                    if _ED.union_fight_city_user_info ~= nil and 
                        _ED.union_fight_city_user_info.is_death == "1" then
                        TipDlg.drawTextDailog(tipStringInfo_union_str[92])
                        return
                    end
                    -- if _ED._inUnionFightScene == true then
                    --     TipDlg.drawTextDailog(tipStringInfo_union_str[93])
                    --     return 
                    -- end
                    if tonumber(instance.user_at_city_id) == tonumber(params[1]) then
                        return
                    end
				else
					for i ,v in pairs(red_alert_home_city_id) do
						if tonumber(v) ~= red_alert_home_city_id[tonumber(_ED.user_info.user_force)] and tonumber(params[1]) == tonumber(v) then
							TipDlg.drawTextDailog(red_alert_all_str[53])
							return
						end
					end
					if instance.user_at_city_id == params[1] then                  
						state_machine.excute("national_war_city_war_map_window_open",0,{params[1]})
						return
					end
					
					local state = _ED.warfareCityInfo[self.user_at_city_id].state
					state = zstring.split(state,",")
					if tonumber(state[6]) == 1 then
						TipDlg.drawTextDailog(red_alert_all_str[51])
						return
					end 
                end
                
				if instance.move_state == 1 then
					TipDlg.drawTextDailog(red_alert_all_str[48])
					return
				end 			
                -- _ED.city_world_map_id_backup = tonumber(_ED.city_user_move_event.curr_city_id)	
                instance:getWay(params[1])
                -- table.insert(instance.will_move_table,params[1])
                -- instance:setUserPos(instance.will_move_table[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- national_war_build_button_window_open
        local national_war_map_open_build_button_terminal = {
            _name = "national_war_map_open_build_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local city_id = params[1]
                instance:openBuildButton(city_id)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        -- 改变坐标 通过小框
        local natinal_war_map_scroll_change_pos_terminal = {
            _name = "natinal_war_map_scroll_change_pos",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local now_persent_x = params[1]
                local now_persent_y = params[2]
                instance:changePos(now_persent_x,now_persent_y)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 检查是否到达目的地
        local natinal_war_map_check_is_at_goto_city_terminal = {
            _name = "natinal_war_map_check_is_at_goto_city",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.checkIsAtGotoCity ~= nil then
                    instance:checkIsAtGotoCity()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        -- 返回主城
        local national_war_map_return_home_city_terminal = {
            _name = "national_war_map_return_home_city",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:returnHomeCity()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 瞬间移动到某城池，主要用于集结
        local national_war_map_move_to_city_terminal = {
            _name = "national_war_map_move_to_city",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.war_user_dead == true then
                    TipDlg.drawTextDailog(red_alert_all_str[46])
                    return
                end   
                instance:cutNowMove()
                instance:moveToCity(params[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 屏幕滚动定位到指定的城池
        local national_war_map_scroll_to_city_terminal = {
            _name = "national_war_map_scroll_to_city",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:scrollToCity(params[1],true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 突进
        local national_war_map_onrush_terminal = {
            _name = "national_war_map_onrush",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onrushToCity(params[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 返回城池
        local national_war_back_city_terminal = {
            _name = "national_war_back_city",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.open_type == 1 then
                    if tonumber(_ED.union_fight_city_state) == 3 then
                        if _ED.union.union_info == nil 
                            or _ED.union.union_info == {} 
                            or _ED.union.union_info.union_id == nil 
                            or _ED.union.union_info.union_id == "" 
                            or tonumber(_ED.union.union_info.union_id) == 0 
                            or tonumber(_ED.union.union_info.union_grade) < dms.int(dms["union_config"], 30, union_config.param) 
                            then
                            TipDlg.drawTextDailog(tipStringInfo_union_str[81])
                            return
                        end
                        local mainCityInfo = _ED.union_stronghold_info_list[""..instance.user_at_city_id]
                        if mainCityInfo ~= nil then
                            local function responseCallback( response )
                                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                    state_machine.excute("union_fighting_main_open", 0, mainCityInfo)
                                end
                            end
                            protocol_command.union_stronghold_init.param_list = _ED.union.union_info.union_id.."\r\n"..instance.user_at_city_id
                            NetworkManager:register(protocol_command.union_stronghold_init.code, nil, nil, nil, nil, responseCallback, false, nil)
                        -- else
                            -- TipDlg.drawTextDailog(tipStringInfo_union_str[115])
                        -- end
                        else
                            TipDlg.drawTextDailog(tipStringInfo_union_str[115])
                        end
                    else
                        state_machine.excute("personal_fight_main_open", 0, nil)
                    end
                else
                    state_machine.excute("national_war_city_war_map_window_open",0,{self.user_at_city_id})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 任务指定过来
        local national_war_map_from_task_terminal = {
            _name = "national_war_map_from_task",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:gotoCity(params[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 强制刷新
        local national_war_map_user_to_update_terminal = {
            _name = "national_war_map_user_to_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:userToUpdateBuild(params[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 制定滚动到某个坐标
		local national_war_map_scroll_position_terminal = {
            _name = "national_war_map_scroll_position",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.scroll_view:scrollToPercentBothDirection(cc.p(zstring.tonumber(params[1]), zstring.tonumber(params[2])), zstring.tonumber(params[3]), params[4])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--退出大地图
		local national_city_resource_hold_quit_terminal = {
            _name = "national_city_resource_hold_quit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseholdquit(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("national_war_map_window_close",0,{_datas={open_type = params._datas.open_type}})
                    end
                end
				NetworkManager:register(protocol_command.city_resource_hold_quit.code, nil, nil, nil, nil, responseholdquit, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--移动城池
		local national_city_world_map_move_to_terminal = {
            _name = "national_city_world_map_move_to",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local isCityResources = false
				
				if zstring.tonumber(_ED.city_activity_status) == 1 then
					-- for i, v in pairs(_ED.city_map_info) do
					-- 	if tonumber(v.city_world_map_id) == params._datas.cityMapId then
					-- 		isCityResources = true
					-- 		break
					-- 	end
					-- end
                    isCityResources = true
				end
				if isCityResources == true then
                    local cityInfo = _ED.city_map_info["" .. params._datas.cityMapId]
                    if cityInfo == nil then
                        local mainCityInfo = nil
                        if _ED.union_stronghold_info_list ~= nil then
                            mainCityInfo = _ED.union_stronghold_info_list["" .. params._datas.cityMapId]
                        end
                        if mainCityInfo ~= nil then
                            local panel_city = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_build_"..params._datas.cityMapId)
                            local x = panel_city:getPositionX() + panel_city:getContentSize().width/2 
                            local y = panel_city:getPositionY() + panel_city:getContentSize().height/2 
                            state_machine.excute("national_city_world_big_map_window_open",0,{instance.scroll_view,params._datas.cityMapId,cc.p(x,y)})
                        end
                    else
                        -- if (cityInfo.city_Resource_points == "-1" or #cityInfo.city_Resource_points == 0) 
                        --     and instance.user_at_city_id == zstring.tonumber(params._datas.cityMapId) then
                        -- else
                        --     local panel_city = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_build_"..params._datas.cityMapId)
                        --     local x = panel_city:getPositionX() + panel_city:getContentSize().width/2 
                        --     local y = panel_city:getPositionY() + panel_city:getContentSize().height/2 
                        --     state_machine.excute("national_city_world_big_map_window_open",0,{instance.scroll_view,params._datas.cityMapId,cc.p(x,y)})
                        -- end
                    end
				else
                    local mainCityInfo = nil
                    if _ED.union_stronghold_info_list ~= nil then
                        mainCityInfo = _ED.union_stronghold_info_list["" .. params._datas.cityMapId]
                    end
                    if mainCityInfo ~= nil then
    					-- if self.user_at_city_id == zstring.tonumber(params._datas.cityMapId) then
                            local panel_city = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_build_"..params._datas.cityMapId)
                            local x = panel_city:getPositionX() + panel_city:getContentSize().width/2 
                            local y = panel_city:getPositionY() + panel_city:getContentSize().height/2 
                            state_machine.excute("national_city_world_big_map_window_open",0,{instance.scroll_view,params._datas.cityMapId,cc.p(x,y)})
         --                else
    					-- 	local function responsemapmoveto(response)
    					-- 		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
         --                            if instance.node ~= nil and instance.node.roots ~= nil then
        	-- 							state_machine.excute("national_war_map_move_my_pos",0,{zstring.tonumber(params._datas.cityMapId)})
         --                            end
    					-- 		end
    					-- 	end
    					-- 	protocol_command.city_resource_hold_move_to_city.param_list = zstring.tonumber(params._datas.cityMapId)
    					-- 	NetworkManager:register(protocol_command.city_resource_hold_move_to_city.code, nil, nil, nil, instance, responsemapmoveto, false, nil)  
    					-- end
                    end
				end
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		--大地图推送玩家移动
		local national_city_world_player_map_move_to_terminal = {
            _name = "national_city_world_player_map_move_to",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:initCityMapPlayerArmature(params)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local national_city_move_to_my_pos_terminal = {
            _name = "national_city_move_to_my_pos",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local my_city_id = tonumber(_ED.city_resource_user_info.my_city_id)
                if my_city_id > 0 then
                    if my_city_id == instance.user_at_city_id then
                        local function responseCallback( response )
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                local resource_id = 0
                                local resource_index = 0
                                for k,v in pairs(_ED.city_resource_hold_resource_infos) do
                                    if tonumber(v.id) == tonumber(_ED.city_resource_user_info.resource_id) then
                                        resource_index = k
                                        resource_id = v.mould_id
                                    end
                                end
                                app.load("client.red_alert.big_map.MapRattling")
                                state_machine.excute("map_rattling_window_open", 0, {my_city_id, resource_id, resource_index})
                            end
                        end
                        protocol_command.city_resource_refrush.param_list = my_city_id.."\r\n".._ED.city_resource_user_info.resource_id
                        NetworkManager:register(protocol_command.city_resource_refrush.code, nil, nil, nil, nil, responseCallback, false, nil)
                        -- state_machine.excute("national_city_world_big_map_button_report", 0, {_datas = {city_id = my_city_id}})
                    else
                        local function responsemapmoveto(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                local function response1Callback( response )
                                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                        local resource_id = 0
                                        local resource_index = 0
                                        local id = 0
                                        for k,v in pairs(_ED.city_resource_hold_resource_infos) do
                                            if tonumber(v.id) == tonumber(_ED.city_resource_user_info.resource_id) then
                                                resource_index = k
                                                resource_id = v.mould_id
                                                id = v.id
                                            end
                                        end
                                        _ED.city_resource_invite_goto_info = {city_id = my_city_id, resource_id = resource_id, resource_index = resource_index, id = id}
                                        state_machine.excute("national_war_map_move_my_pos",0,{zstring.tonumber(_ED.city_resource_user_info.my_city_id)})
                                        state_machine.excute("national_city_world_big_map_window_close",0,"")
                                    end
                                end
                                protocol_command.city_resource_refrush.param_list = my_city_id.."\r\n".._ED.city_resource_user_info.resource_id
                                NetworkManager:register(protocol_command.city_resource_refrush.code, nil, nil, nil, nil, response1Callback, false, nil)
                            end
                        end
                        protocol_command.city_resource_hold_move_to_city.param_list = "" .. my_city_id
                        NetworkManager:register(protocol_command.city_resource_hold_move_to_city.code, nil, nil, nil, nil, responsemapmoveto, false, nil) 
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local national_city_update_my_resource_info_terminal = {
            _name = "national_city_update_my_resource_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDrawMyResourcePos()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local national_city_update_map_resource_cells_terminal = {
            _name = "national_city_update_map_resource_cells",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:initResourceCells()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local national_city_hide_game_resource_info_terminal = {
            _name = "national_city_hide_game_resource_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("player_resource_window_hide", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local national_city_move_raiderscut_pos_terminal = {
            _name = "national_city_move_raiderscut_pos",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local max_attack_times = dms.int(dms["raiders_cut_config"],4,raiders_cut_config.param)
                if _ED.raiders_cut_attack_times >= max_attack_times then
                    TipDlg.drawTextDailog(daily_string[9])
                    return
                end
                if _ED.raiders_fight_index == nil then
                    _ED.raiders_fight_index = 0
                end
                _ED.raiders_fight_index = _ED.raiders_fight_index + 1
                local index = math.floor(_ED.raiders_fight_index%3)
                if index == 0 then
                    index = 3
                end
                local raiders_info = nil
                if _ED.raiders_user_info ~= nil then
                    raiders_info = _ED.raiders_user_info[index]
                end

                -- 切换地图显示
                local root = instance.roots[1]
                local Panel_raiderscut = ccui.Helper:seekWidgetByName(root,"Panel_raiderscut_"..raiders_info.pos_index)
                -- -- local city_panel = ccui.Helper:seekWidgetByName(root,"Panel_build_".._city_id)
                local winSize = cc.size(fwin._width - app.baseOffsetX, fwin._height - app.baseOffsetY)
                local x = Panel_raiderscut:getPositionX()
                local y = Panel_raiderscut:getPositionY()
                local size = instance.scroll_view:getInnerContainer():getContentSize()
                local scroll_size = instance.scroll_view:getContentSize()
                instance.scroll_view:scrollToPercentBothDirection(cc.p((x - winSize.width / 2) / (size.width - winSize.width) * 100, 
                        100 - (y - winSize.height / 2) / (size.height - winSize.height) * 100), 
                        0.5, 
                        true)
                
                -- 处理战斗数据
                -- app.load("client.red_alert.battle.battle_enum")
                -- local scene_npc_tab = dms.string(dms["raiders_cut_config"],8,raiders_cut_config.param)
                -- scene_npc_tab = zstring.split(scene_npc_tab,",")
                -- local scene_id = tonumber(scene_npc_tab[1])
                -- local npc_id = tonumber(scene_npc_tab[2])
                
                -- _ED._current_scene_id = scene_id
                -- _ED._scene_npc_id = npc_id
                -- _ED._npc_difficulty_index = "1"
                -- _ED.show_reward_list_group = {}
                -- _ED.last_level = _ED.user_info.user_grade
                -- _ED.last_user_food = _ED.user_info.user_food
                -- _ED._battle_init_type = battle_enum._fight_type._fight_type_10
                -- _ED.attack_user_id = raiders_info.user_id
                -- _ED.raiders_cut_id = raiders_info.raider_id

                -- _ED.raiders_need_enter_fight = true
                -- local city_info = zstring.split(dms.string(dms["city_resource_hold_config"], 16, city_resource_hold_config.param), "|")
                -- for k,v in pairs(city_info) do
                --     local info = zstring.split(v, ",")
                --     if tonumber(info[1]) == tonumber(raiders_info.pos_index) then
                --         state_machine.excute("national_city_move_raiderscut_fight", 0, {tonumber(info[2])})
                --     end
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 指定教学的UI
        local national_city_move_raiderscut_pos_tuition_terminal = {
            _name = "national_city_move_raiderscut_pos_tuition",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local max_attack_times = dms.int(dms["raiders_cut_config"],4,raiders_cut_config.param)
                if _ED.raiders_cut_attack_times >= max_attack_times then
                    TipDlg.drawTextDailog(daily_string[9])
                    return
                end
                if _ED.raiders_fight_index == nil then
                    _ED.raiders_fight_index = 0
                end
                local index = math.floor(_ED.raiders_fight_index%3)
                if index == 0 then
                    index = 3
                end
                local raiders_info = nil
                if _ED.raiders_user_info ~= nil then
                    raiders_info = _ED.raiders_user_info[index]
                end

                -- 切换地图显示
                local root = instance.roots[1]
                local Panel_raiderscut = ccui.Helper:seekWidgetByName(root,"Panel_raiderscut_"..raiders_info.pos_index)
                local Panel_raider_npc = ccui.Helper:seekWidgetByName(Panel_raiderscut._target_cell.roots[1],"Panel_raider_npc")
                state_machine.excute("tuition_controller_set_next_tuition_ui_object", 0, Panel_raider_npc)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 查找空的资源点来，供资源占领教学
        local national_city_world_map_move_to_resource_tuition_terminal = {
            _name = "national_city_world_map_move_to_resource_tuition",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local focus = nil
                for i, v in pairs(_ED.city_map_info) do
                    if v.city_Resource_points ~= "-1" and #v.city_Resource_points > 0 then
                        local c = math.random(1, 9)
                        focus = v
                        if c == 7 then
                            break
                        end
                    end
                end
                -- 切换地图显示
                local root = instance.roots[1]
                local Panel_raiderscut = ccui.Helper:seekWidgetByName(root,"Panel_build_" .. focus.city_world_map_id)
                -- -- local city_panel = ccui.Helper:seekWidgetByName(root,"Panel_build_".._city_id)
                local winSize = cc.size(fwin._width - app.baseOffsetX, fwin._height - app.baseOffsetY)
                local x = Panel_raiderscut:getPositionX()
                local y = Panel_raiderscut:getPositionY()
                local size = instance.scroll_view:getInnerContainer():getContentSize()
                local scroll_size = instance.scroll_view:getContentSize()
                instance.scroll_view:scrollToPercentBothDirection(cc.p((x - winSize.width / 2) / (size.width - winSize.width) * 100, 
                        100 - (y - winSize.height / 2) / (size.height - winSize.height) * 100), 
                        0.5, 
                        true)
                state_machine.excute("tuition_controller_set_next_tuition_ui_object", 0, Panel_raiderscut)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local national_city_move_raiderscut_fight_terminal = {
            _name = "national_city_move_raiderscut_fight",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local my_city_id = tonumber(params[1])
                if my_city_id == instance.user_at_city_id then
                    instance:requestEnterRaiderFight()
                else
                    local function responsemapmoveto(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                state_machine.excute("national_war_map_move_my_pos",0,{zstring.tonumber(my_city_id)})
                            end
                        end
                    end
                    protocol_command.city_resource_hold_move_to_city.param_list = "" .. my_city_id
                    NetworkManager:register(protocol_command.city_resource_hold_move_to_city.code, nil, nil, nil, instance, responsemapmoveto, false, nil) 
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local national_city_update_union_city_map_info_terminal = {
            _name = "national_city_update_union_city_map_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onDrawUnionCityMapInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local national_city_refresh_union_city_map_info_terminal = {
            _name = "national_city_refresh_union_city_map_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onRefreshUnionCityMapInfo(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local national_city_update_union_city_user_pos_terminal = {
            _name = "national_city_update_union_city_user_pos",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateUnionFightUserPos(params[1], params[2])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local national_city_open_union_attack_rank_terminal = {
            _name = "national_city_open_union_attack_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    or tonumber(_ED.union.union_info.union_grade) < dms.int(dms["union_config"], 30, union_config.param) 
                    then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[81])
                    return
                end
                if tonumber(_ED.union_fight_city_state) == 0 then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[102])
                    return
                end
                if tonumber(_ED.union_fight_city_state) == 2 then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[103])
                    return
                end
                if tonumber(_ED.union_fight_city_state) == 3 then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[104])
                    return
                end
                state_machine.excute("union_fighting_attack_rank_open", 0, {0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local national_city_open_union_role_death_terminal = {
            _name = "national_city_open_union_role_death",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- state_machine.excute("union_fighting_main_close", 0, nil)
                state_machine.excute("union_fighting_review_time_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local national_city_open_union_add_role_death_effect_terminal = {
            _name = "national_city_open_union_add_role_death_effect",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addRoleDeathEffect()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local national_city_open_union_add_role_review_effect_terminal = {
            _name = "national_city_open_union_add_role_review_effect",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addRoleReviewEffect()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local national_city_open_union_add_fighting_end_effect_terminal = {
            _name = "national_city_open_union_add_fighting_end_effect",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addUnionFightingEndEffect()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local national_city_open_union_add_fighting_begin_effect_terminal = {
            _name = "national_city_open_union_add_fighting_begin_effect",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addOpenEffect()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local national_city_open_personal_fighting_terminal = {
            _name = "national_city_open_personal_fighting",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if funOpenDrawTipEX(47) == true then
                    return
                end
                local cityMapId = params._datas.cityMapId
                if cityMapId == 85 then
                    state_machine.excute("personal_fight_main_open", 0, nil)
                else
                    local info = _ED.presonal_fighting_map_info[cityMapId - 85]
                    if tonumber(info.user_state) == -1 then
                        TipDlg.drawTextDailog(red_alert_all_str[246])
                    else
                        state_machine.excute("personal_fight_build_infor_open", 0, {index = cityMapId - 85})
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 刷新山庄
        local national_city_refresh_personal_fighting_terminal = {
            _name = "national_city_refresh_personal_fighting",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 山庄刷新按钮开启条件
                if funOpenDrawTipEX(37) == true then
                    return
                end
                local costs = zstring.split(dms.string(dms["user_stronghold_config"], 18, user_stronghold_config.info), ",")
                if tonumber(_ED.personal_user_refresh_times) + 1 >= table.nums(costs) then 
                    cost = tonumber(costs[table.nums(costs)])
                else
                    cost = costs[tonumber(_ED.personal_user_refresh_times) + 1]
                end
                if math.ceil(cost) > zstring.tonumber(_ED.user_info.user_silver) then
                    TipDlg.drawTextDailog(red_alert_all_str[80])
                    return
                end
                local tip = ConfirmTip:new()
                tip:init(instance, instance.sureRefreshPersonal, string.format(red_alert_all_str[247], cost))
                fwin:open(tip, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(national_war_map_window_show_terminal)
        state_machine.add(national_war_map_window_hide_terminal)
        state_machine.add(national_war_map_move_my_pos_terminal)  
        state_machine.add(national_war_map_open_build_button_terminal)  
        state_machine.add(natinal_war_map_scroll_change_pos_terminal)
        state_machine.add(natinal_war_map_check_is_at_goto_city_terminal)
        state_machine.add(national_war_map_return_home_city_terminal)
        state_machine.add(national_war_map_move_to_city_terminal)
        state_machine.add(national_war_map_scroll_to_city_terminal)
        state_machine.add(national_war_map_onrush_terminal)
        state_machine.add(national_war_back_city_terminal)
        state_machine.add(national_war_map_from_task_terminal)
        state_machine.add(national_war_map_user_to_update_terminal)
        state_machine.add(national_war_map_scroll_position_terminal)
        state_machine.add(national_city_resource_hold_quit_terminal)
        state_machine.add(national_city_world_map_move_to_terminal)
        state_machine.add(national_city_world_player_map_move_to_terminal)
        state_machine.add(national_city_move_to_my_pos_terminal)
        state_machine.add(national_city_update_my_resource_info_terminal)
        state_machine.add(national_city_update_map_resource_cells_terminal)
        state_machine.add(national_city_hide_game_resource_info_terminal)
        state_machine.add(national_city_move_raiderscut_pos_terminal)
        state_machine.add(national_city_move_raiderscut_pos_tuition_terminal)
        state_machine.add(national_city_world_map_move_to_resource_tuition_terminal)
        state_machine.add(national_city_move_raiderscut_fight_terminal)
        state_machine.add(national_city_update_union_city_map_info_terminal)
        state_machine.add(national_city_refresh_union_city_map_info_terminal)
        state_machine.add(national_city_update_union_city_user_pos_terminal)
        state_machine.add(national_city_open_union_attack_rank_terminal)
        state_machine.add(national_city_open_union_role_death_terminal)
        state_machine.add(national_city_open_union_add_role_death_effect_terminal)
        state_machine.add(national_city_open_union_add_role_review_effect_terminal)
        state_machine.add(national_city_open_union_add_fighting_end_effect_terminal)
        state_machine.add(national_city_open_union_add_fighting_begin_effect_terminal)
        state_machine.add(national_city_open_personal_fighting_terminal)
        state_machine.add(national_city_refresh_personal_fighting_terminal)
        state_machine.init()
    end
    
    -- call func init rebirth state machine.
    init_national_war_map_terminal()
end

function NationalWarMap:sureRefreshPersonal(n)
    if n ~= 0 then
        return
    end
    if self.roots == nil or self.roots[1] == nil then
        return
    end
    local function responseCallBack(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                response.node:onDrawPersonalFightInfo(1)
            end
        end
    end
    protocol_command.user_stronghold_plunder_refresh.param_list = "1"
    NetworkManager:register(protocol_command.user_stronghold_plunder_refresh.code, nil, nil, nil, self, responseCallBack, false, nil) 
end

function NationalWarMap:requestEnterRaiderFight( ... )
    _ED.raiders_need_enter_fight = false
    local function responseBattleStartCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            protocol_command.battle_result_verify.param_list = "" .. _ED.raiders_cut_id
            app.load("client.red_alert.battle.battle_loading")
            state_machine.excute("battle_loading_window_open", 0, battle_enum._fight_type._fight_type_10)                                            
        end
    end
    protocol_command.battle_result_start.param_list = ""..battle_enum._fight_type._fight_type_10.."\r\n".."1".."\r\n".._ED.attack_user_id
    NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, nil, responseBattleStartCallback, false, nil)
end

function NationalWarMap:updateRaiderInfo( ... )
    for i=1,5 do
        local Panel_raiderscut = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_raiderscut_"..i)
        Panel_raiderscut:removeAllChildren(true)
    end
    if _ED.raiders_user_info ~= nil then
        for k,v in pairs(_ED.raiders_user_info) do
            local cell = state_machine.excute("map_raiderscut_npc_cell_create_cell", 0, {k, v})
            local Panel_raiderscut = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_raiderscut_"..v.pos_index)
            Panel_raiderscut:addChild(cell)
            Panel_raiderscut._target_cell = cell
        end
    end
    local max_attack_times = dms.int(dms["raiders_cut_config"],4,raiders_cut_config.param)  
    local leave_attack_times = max_attack_times - _ED.raiders_cut_attack_times
    ccui.Helper:seekWidgetByName(self.roots[1],"Text_raiderscut_n"):setString(leave_attack_times.."/"..max_attack_times)
    state_machine.excute("natinal_war_smllemap_update_raiderscut_info", 0, nil)
end

function NationalWarMap:gotoCity(to_city_id)
    local border_city_id = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould],to_city_id,warfare_map_mould.border_city)
    border_city_id = zstring.split(border_city_id,",")
    local can_move = false
    for i,v in ipairs(border_city_id) do
        local city_id = tonumber(v)
        if _ED.warfareCityInfo[city_id].camp == tonumber(_ED.user_info.user_force) then
            can_move = true
        end
    end

    if can_move == true then
        state_machine.excute("national_war_map_move_my_pos",0,{to_city_id})
    else
        -- TipDlg.drawTextDailog("无法前往指定地点")
        state_machine.excute("national_war_map_scroll_to_city",0,{to_city_id})
    end
end

function NationalWarMap:checkGetNewOrder()
    local now_time = os.time()
    if now_time > zstring.tonumber(self._last_get_order_time) + 10 then
        self._last_get_order_time = now_time
        -- print("======倒计时=====",_ED.warfar_get_order_time - (now_time - _ED.warfar_get_order_start_time))
        -- print("=========",_ED.warfar_get_order_task_level,self.last_task_level)
        self:responseGetNewOrder()
    end
end

function NationalWarMap:responseGetNewOrder()
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if zstring.tonumber(_ED.warfar_get_order_task_level) == 0 then
                --print("========没有获取到")
                return
            end
            --print("===上次阶段======本次阶段=====",self.last_task_level,_ED.warfar_get_order_task_level)
            if #_ED.warfar_get_order_task == 0 then
                return
            end
            if self.last_task_level ~= _ED.warfar_get_order_task_level then
                --print("===========打开任务")
                state_machine.excute("nationalwar_military_order_window_open",0,"")
                self.last_task_level = _ED.warfar_get_order_task_level
            end
        end
    end
    --print("===========获取")
    NetworkManager:register(protocol_command.get_warfare_task.code, nil, nil, nil,nil, responseCallback, false, nil)
end

function NationalWarMap:onrushToCity(_city_id)-- 瞬间移动
    local city_id = _city_id
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("national_war_city_war_map_ui_close",0,"")
            -- print("===========",city_id,_ED.war_user_at_city_id)
            self.user_at_city_id = _ED.war_user_at_city_id
            self.last_city_id = _ED.war_user_at_city_id
            state_machine.excute("natinal_war_smllemap_update_pos",0,"")
            self:initUserPos()
            state_machine.excute("national_war_city_war_map_window_open",0,{city_id})
        end
    end
    -- print("===========",city_id)
    protocol_command.shoot_city.param_list = ""..city_id
    NetworkManager:register(protocol_command.shoot_city.code, nil, nil, nil,nil, responseCallback, false, nil)
end

function NationalWarMap:cutNowMove()
    self.armature:stopAllActions()
    if self.move_index ~= nil then
        local action_index =  self.move_index - 1
        csb.animationChangeToAction(self.armature,action_index, action_index, true)
    end
    self.move_state = 0
    for i,sprite in pairs(self._sprite_all_node_table) do
        sprite:setVisible(false)
    end
    self._sprite_all_node_table = {}
    self.will_move_table = {}
end

function NationalWarMap:getWay(to_city_id)
    -- self.will_move_table = {2,3,9,8,6}
    self.will_move_table = Pathfindding:new():makePath(tonumber(_ED.user_info.user_force),tonumber(self.user_at_city_id),tonumber(to_city_id),true,self.open_type)
    for i,v in pairs(self.will_move_table) do
        if tonumber(self.user_at_city_id) == tonumber(v) then
            table.remove(self.will_move_table,1)
            break
        end
    end
    if #self.will_move_table == 0 or self.will_move_table == nil then
        TipDlg.drawTextDailog(red_alert_all_str[52])
        return
    end
    -- 添加直线移动
    if self.open_type == 1 then
        -- local wmt = self.will_move_table[#self.will_move_table]
        self.will_move_table = {to_city_id}
        -- self.will_move_table[1] = wmt
    else
        self:showPath()
    end
    if self:checkNextCityCanMove(self.will_move_table[1]) == true then
        
        self:getSpriteNodePos(self.will_move_table[1])
        if #self._sprite_city_node_table == 0 then
            self:setUserPos(self.will_move_table[1])
        else
            self:setUserPosForNode(self._sprite_city_node_table[1])
        end
    else
        for i,sprite in pairs(self._sprite_all_node_table) do
            sprite:setVisible(false)
        end
        self._sprite_all_node_table = {}
        self.will_move_table = {}
    end
end

function NationalWarMap:checkNextCityCanMove(to_city_id)
    local can_move = true
    local border_city = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould],to_city_id,warfare_map_mould.border_city)
    border_city = zstring.split(border_city,",")
    local my_camp = tonumber(_ED.user_info.user_force)
	if self.open_type==1 then
		return true
	end
    local state = _ED.warfareCityInfo[tonumber(self.user_at_city_id)].state
    local state_table = zstring.split(state,",")

    -- 城池状态0,0,0,0,0,0(1:正常,2:可突进,3:包围,4:进攻任务,5:防守任务,6:交战状态)
    if tonumber(state_table[6]) == 1 then
        can_move = false
    end
 
    local isborder = false
    for i,v in pairs(border_city) do
        if my_camp == tonumber(_ED.warfareCityInfo[tonumber(v)].camp) then
            isborder = true
        end
    end
    if can_move == false then
        TipDlg.drawTextDailog(red_alert_all_str[51])
        return false
    end

    if isborder == false then
        TipDlg.drawTextDailog(red_alert_all_str[52])
        return false
    end
    return true
end

function NationalWarMap:moveToCity(_city_id)-- 瞬间移动
    local city_id = _city_id
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("national_war_city_war_map_ui_close",0,"")
            self.user_at_city_id = _ED.war_user_at_city_id
            state_machine.excute("natinal_war_smllemap_update_pos",0,"")
            self:initUserPos()
            state_machine.excute("national_war_city_war_map_window_open",0,{city_id})
        end
    end
    protocol_command.response_situation.param_list = ""..city_id
    NetworkManager:register(protocol_command.response_situation.code, nil, nil, nil,nil, responseCallback, false, nil)
end

function NationalWarMap:returnHomeCity() -- 到主城
    local home_citydata = dms.searchs(dms[config_res.campaign.nationalwar.warfare_map_mould], warfare_map_mould.city_type,1)
    local my_home_city_id = red_alert_home_city_id[tonumber(_ED.user_info.user_force)]
    for i,v in pairs(home_citydata) do
        local city_camp = dms.int(v,warfare_map_mould.city_camp)
        local city_id = dms.int(v,warfare_map_mould.id)
        if tonumber(_ED.user_info.user_force) == city_camp then
            my_home_city_id = city_id
        end
    end
    self.user_at_city_id = my_home_city_id
    state_machine.excute("natinal_war_smllemap_update_pos",0,"")
    self:initUserPos()
end

function NationalWarMap:onShow()
    self:setVisible(true)
end

function NationalWarMap:onHide()
    self:setVisible(false)
end

function NationalWarMap.ScrollViewTouchListener(sender, eventType)
    -- print("========",eventType,sender:getInnerContainer():getPositionX(),sender:getInnerContainer():getPositionY()) 
    local inner_size = sender:getInnerContainer():getContentSize()
    local x = math.abs(sender:getInnerContainer():getPositionX())
    local y = math.abs(sender:getInnerContainer():getPositionY())
    -- debug.print_r(inner_size)
    local pensert_x = x/(inner_size.width - sender:getContentSize().width )
    local pensert_y = y/(inner_size.height - sender:getContentSize().height ) 
    --print("---------------------",pensert_x,pensert_y,inner_size.width,inner_size.height,sender:getContentSize().width,sender:getContentSize().height)
    state_machine.excute("natinal_war_smllemap_change_pos",0,{pensert_x,pensert_y})
end

function NationalWarMap:changePos(now_persent_x,now_persent_y)
    if self.now_persent_x == now_persent_x and self.now_persent_y == now_persent_y then
        return
    end  
    -- print("===========================移动")
    local root = self.roots[1]
    local inner_size = self.scroll_view:getInnerContainer():getContentSize()
    self.now_persent_x = now_persent_x
    self.now_persent_y = now_persent_y
    local x = -1 * now_persent_x * (inner_size.width - self.scroll_view:getContentSize().width ) 
    local y = -1 * now_persent_y * (inner_size.height - self.scroll_view:getContentSize().height ) 
    -- print("==============",x,y,now_persent_x,now_persent_y)
    self.scroll_view:getInnerContainer():setPosition(cc.p(x,y))
end

function NationalWarMap:openBuildButton(city_id)
    local root = self.roots[1]  
    local ScrollView_nationalwar_map = ccui.Helper:seekWidgetByName(root,"ScrollView_nationalwar_map")
    local panel_city = ccui.Helper:seekWidgetByName(root,"Panel_build_"..city_id)
    local x = panel_city:getPositionX() + panel_city:getContentSize().width/2 
    local y = panel_city:getPositionY() + panel_city:getContentSize().height/2 
    state_machine.excute("national_war_build_button_window_open",0,{ScrollView_nationalwar_map,city_id,cc.p(x,y)})
end

function NationalWarMap:onUpdateDraw()
    local root = self.roots[1]
	for i,city_data in pairs(_ED.warfareCityInfo) do
	   local city = state_machine.excute("national_war_map_build_create",0,{city_data})
	   local panel_city = ccui.Helper:seekWidgetByName(root,"Panel_build_"..i)
	   panel_city:addChild(city)
	   table.insert(self._city_cells,city)
	   table.insert(self.panel_citys,panel_city)
	end
    self:onUpdateDrawMyResourcePos()
end

function NationalWarMap:onUpdateDrawMyResourcePos( ... )
    local root = self.roots[1]
    local Text_rattling_infor = ccui.Helper:seekWidgetByName(root,"Text_rattling_infor")
    local Panel_occupy = ccui.Helper:seekWidgetByName(root,"Panel_occupy")
    if Panel_occupy ~= nil then
        if _ED.city_resource_user_info ~= nil then
            if self._last_resource_city_id ~= tonumber(_ED.city_resource_user_info.my_city_id) then
                state_machine.excute("natinal_war_smllemap_add_my_resource_effect", 0, nil)
                self._last_resource_city_id = tonumber(_ED.city_resource_user_info.my_city_id)
                if tonumber(_ED.city_resource_user_info.my_city_id) <= 0 then
                    Text_rattling_infor:setString("")
                    Panel_occupy:setVisible(false)
                else
                    Panel_occupy:setVisible(true)
                    local city_name = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould], _ED.city_resource_user_info.my_city_id, warfare_map_mould.city_name)
                    Text_rattling_infor:setString(city_name)
                end
            elseif tonumber(_ED.city_resource_user_info.my_city_id) == 0 then
                Panel_occupy:setVisible(false)
            end
        else
            Panel_occupy:setVisible(false)
        end
    end
end

function NationalWarMap:initResourceCells()
    local root = self.roots[1]
    for i=1,100 do
        local panelCity = ccui.Helper:seekWidgetByName(root,"Panel_build_" .. i)
        if panelCity ~= nil then
            local childCell = panelCity:getChildByName("resource_res_"..i)
            if childCell ~= nil then
                childCell:removeFromParent(true)
                childCell = nil
            end
        end
    end
    if self.open_type==1 then
        -- 创建资源城池品质信息显示
        -- if _ED.city_activity_status == "1" then
        --     for i, v in pairs(_ED.city_map_info) do
        --         local panelCity = ccui.Helper:seekWidgetByName(root,"Panel_build_" .. v.city_world_map_id)
        --         -- local childCell = panelCity:getParent():getChildByName("resource_res_"..v.city_world_map_id)
        --         -- if childCell ~= nil then
        --         --     childCell:removeFromParent(true)
        --         --     childCell = nil
        --         -- end
        --         if v.city_Resource_points ~= "-1" and zstring.tonumber(v.city_Resource_points) > 0 then
        --             local cell = state_machine.excute("big_map_res_cell_create", 0, {panelCity, v, 1})
        --             -- cell:setPosition(cc.p(panelCity:getPosition()))
        --             cell:setName("resource_res_"..v.city_world_map_id)
        --             panelCity:addChild(cell)
        --         else
        --             -- state_machine.excute("natinal_war_smllemap_update_draw_resource_quality", 0, {v.city_world_map_id, -1})
        --         end
        --     end
        -- end
        self:onDrawUnionCityMapInfo()
        self:onDrawPersonalFightInfo()
    end
    state_machine.excute("natinal_war_smllemap_update_draw_myself_city", 0, {_ED.city_world_map_id_backup})
end

function NationalWarMap:onDrawUnionCityMapInfo( ... )
    local root = self.roots[1]
    if _ED.union_stronghold_info_list ~= nil then
        for k,v in pairs(_ED.union_stronghold_info_list) do
            local city_type = dms.int(dms[config_res.campaign.nationalwar.warfare_map_mould], v.city_id, warfare_map_mould.city_type)
            if city_type ~= 4 then
                local panelCity = ccui.Helper:seekWidgetByName(root,"Panel_build_" .. k)
                local childCell = panelCity:getChildByName("resource_res_"..k)
                if childCell ~= nil then
                    childCell:removeFromParent(true)
                    childCell = nil
                end
                local cell = state_machine.excute("big_map_res_cell_create", 0, {panelCity, v, 2})
                -- cell:setPosition(cc.p(panelCity:getPosition()))
                cell:setName("resource_res_"..k)
                panelCity:addChild(cell)
            end
        end
    end
end

function NationalWarMap:onDrawPersonalFightInfo(index)
    if funOpenDrawTipEX(47, false) == true then
        return
    end
    local root = self.roots[1]
    local panelCity = ccui.Helper:seekWidgetByName(root,"Panel_build_85")
    local childCell = panelCity:getChildByName("resource_res_85")
    if childCell ~= nil then
        childCell:removeFromParent(true)
        childCell = nil
    end

    if _ED.presonal_fighting_map_info ~= nil then
        local cell = state_machine.excute("personal_player_build_map_cell_create", 0, {panelCity, nil, true})
        cell:setName("resource_res_85")
        panelCity:addChild(cell)

        for i=86,95 do
            local info = _ED.presonal_fighting_map_info[i - 85]
            local panelCity = ccui.Helper:seekWidgetByName(root,"Panel_build_" .. i)
            local childCell = panelCity:getChildByName("resource_res_"..i)
            if childCell ~= nil then
                childCell:removeFromParent(true)
                childCell = nil
            end
            if info ~= nil then
                local isEnemy = false
                for i, enemy in pairs(_ED.personal_defender_battle_report_list) do
                    if tonumber(info.user_id) == tonumber(enemy.userId) then
                        local time = os.time() + _ED.time_add_or_sub - tonumber(enemy.time) / 1000
                        local hour = math.floor(time / 3600)
                        if hour < 48 then
                            isEnemy = true
                            break
                        end
                    end
                end
                local cell = state_machine.excute("personal_player_build_map_cell_create", 0, {panelCity, info, false, isEnemy,index})
                -- cell:setPosition(cc.p(panelCity:getPosition()))
                cell:setName("resource_res_"..i)
                panelCity:addChild(cell)
            end
        end
    end
end

function NationalWarMap:onRefreshUnionCityMapInfo( info )
    local root = self.roots[1]
    local panelCity = ccui.Helper:seekWidgetByName(root,"Panel_build_" .. info.city_id)
    if panelCity ~= nil then
        local childCell = panelCity:getChildByName("resource_res_"..info.city_id)
        if childCell ~= nil then
            childCell:removeFromParent(true)
            childCell = nil
        end
        local cell = state_machine.excute("big_map_res_cell_create", 0, {panelCity, info, 2})
        -- cell:setPosition(cc.p(panelCity:getPosition()))
        cell:setName("resource_res_"..info.city_id)
        panelCity:addChild(cell)
    end
end

function NationalWarMap:onEnterTransitionFinish( )
    if self.open_type==1 then
		if missionIsOver() == false then
			self.scroll_view:scrollToPercentBothDirection(cc.p(60, 49), 0.2, true)
		end
    end
    --跑马灯
    if funOpenDrawTip(55,false) == false then  
        app.load("client.home.WarshipGirlPushInfo")
        state_machine.excute("warship_girl_push_info_open",0,{_datas={_openType=0}})
    end

    --跑马灯top
    if funOpenDrawTip(55,false) == false then  
        app.load("client.home.WarshipGirlPushInfoTop")
        state_machine.excute("warship_girl_push_info_top_open",0,{_datas={_openType=0}})
    end
end

function NationalWarMap:onInit()
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_map)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

	--关闭
	if self.open_type==1 then
        state_machine.excute("chat_view_window_open", 0, nil)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_map_close"), nil, 
		{
			terminal_name = "national_city_resource_hold_quit", 
			terminal_state = 0, 
			touch_scale = true,
			touch_scale_xy = 0.95,
			open_type = self.open_type
		}, nil, 0)
		local city_num = dms.count(dms[config_res.campaign.nationalwar.warfare_map_mould])
		for i=1, city_num do
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_build_"..i), nil, 
			{
				terminal_name = "national_city_world_map_move_to", 
				terminal_state = 0, 
				touch_scale = true,
				touch_scale_xy = 0.95,
				cityMapId = i,
			}, nil, 0)
		end

        for i=85, 96 do
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_build_"..i), nil, 
            {
                terminal_name = "national_city_open_personal_fighting", 
                terminal_state = 0, 
                touch_scale = true,
                touch_scale_xy = 0.95,
                cityMapId = i,
            }, nil, 0)
        end

        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_map_position"), nil, 
        {
            terminal_name = "national_city_move_to_my_pos", 
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95,
        }, nil, 0)

        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_map_rattling"), nil, 
        {
            terminal_name = "national_city_move_raiderscut_pos", 
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95,
        }, nil, 0)
        -- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_foraction_lakes",
        -- _widget = ccui.Helper:seekWidgetByName(root, "Image_map_rattling"),
        -- _invoke = nil,
        -- _interval = 0.5,})
        if missionIsOver() == true or zstring.tonumber(_ED.user_info.user_experience) > 0 then
            ccui.Helper:seekWidgetByName(root,"Panel_raiderscut"):setVisible(true)
            ccui.Helper:seekWidgetByName(root,"Button_map_close"):setVisible(true)
        else
            ccui.Helper:seekWidgetByName(root,"Panel_raiderscut"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Button_map_close"):setVisible(false)
        end

        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_build_rank"), nil, 
        {
            terminal_name = "map_rattling_ranking_window_open", 
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0)

        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_attack"), nil, 
        {
            terminal_name = "national_city_open_union_attack_rank", 
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0)
        -- 刷新山庄
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_refresh"), nil, 
        {
            terminal_name = "national_city_refresh_personal_fighting", 
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0)
	else
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_map_close"), nil, 
		{
			terminal_name = "national_war_map_window_close", 
			terminal_state = 0, 
			touch_scale = true,
			touch_scale_xy = 0.95,
			open_type = self.open_type
		}, nil, 0)
	end
    
	--排名 
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rank"), nil, 
	{
		terminal_name = "national_rank_window_open",
		terminal_state = 0, 
		touch_scale = true,
		touch_scale_xy = 0.95,
	}, nil, 0)

	--任务
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task"), nil, 
	{
		terminal_name = "national_task_window_open",
		terminal_state = 0, 
		touch_scale = true,
		touch_scale_xy = 0.95,
	}, nil, 0)  

	-- 任务推送
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_war_fight_of_task",
		_widget = ccui.Helper:seekWidgetByName(root, "Button_task"),
		_invoke = nil,
		_interval = 0.5,}) 

	--号令
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_decree"), nil, 
	{
		terminal_name = "national_war_decree_window_open",
		terminal_state = 0, 
		touch_scale = true,
		touch_scale_xy = 0.95,
	}, nil, 0) 

	-- 号令推送
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_war_fight_of_decree",
		_widget = ccui.Helper:seekWidgetByName(root, "Button_decree"),
		_invoke = nil,
		_interval = 0.5,})  
	
	--战况
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fighting"), nil, 
	{
		terminal_name = "national_war_fighting_window_open",
		terminal_state = 0, 
		touch_scale = true,
		touch_scale_xy = 0.95,
	}, nil, 0)     

	--返回城池
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back_build"), nil, 
	{
		terminal_name = "national_war_back_city",
		terminal_state = 0, 
		touch_scale = true,
		touch_scale_xy = 0.95,
	}, nil, 0)

    -- 个人居所排行榜
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_player_rank"), nil, 
    {
        terminal_name = "personal_fight_ranking_window_open",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

	--关闭建筑选择功能
	local Panel_scroll_touch = ccui.Helper:seekWidgetByName(root, "Panel_scroll_touch")
    local close_script = ""
    if self.open_type == 1 then
        close_script = "national_city_world_big_map_window_close"
    else
        close_script = "national_war_build_button_window_close"
    end
	fwin:addTouchEventListener(Panel_scroll_touch, nil, 
	{
		terminal_name = close_script,
		terminal_state = 0, 
	}, nil, 0)   

	
    self.back_city_button = ccui.Helper:seekWidgetByName(root, "Button_back_build")
    if self.back_city_button~= nil then
		local ScrollView_nationalwar_map = ccui.Helper:seekWidgetByName(root,"ScrollView_nationalwar_map")
		self.scroll_view = ScrollView_nationalwar_map
		
		self.scroll_view:setSwallowTouches(false)
		

		ScrollView_nationalwar_map:addEventListener(self.ScrollViewTouchListener)
	end
	
	self:getData()
	self:onUpdateDraw()
	self:initMapPath()
	if missionIsOver() == true or zstring.tonumber(_ED.user_info.user_experience) > 0 then
		self:loadOtherWindow()
		self:initMyArmature()
		self:initUserPos()  
	end
	if self.open_type==1 then
        self:initResourceCells()
        -- self:updateRaiderInfo()
        self:addOpenEffect()
        state_machine.excute("union_fighting_review_time_open", 0, nil)
	else
		self:initNpcArmature()
		self:initNpcMove()
	end
	self.m_size = cc.size(fwin._width - app.baseOffsetX, fwin._height - app.baseOffsetY)
	self.scroll_viewWidth = self.scroll_view:getInnerContainer():getContentSize().width - self.m_size.width
	self.scroll_viewHeight = self.scroll_view:getInnerContainer():getContentSize().height - self.m_size.height
    playBgm(formatMusicFile("background", zstring.tonumber(config_res.campaign.nationalwar.music.background.warMap)))
end
--初始自己的角色
function NationalWarMap:initMyArmature()
    app.load("client.battle.fight.FightEnum")
    local temp_bust_index = 0
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
        if tonumber(_ED.user_info.user_gender) == 1 then
            temp_bust_index = "1501_2"
        else
            temp_bust_index = "1511_2"
        end
    else
		if tonumber(_ED.user_info.user_gender) == 1 then
			temp_bust_index = "1501_2"
        else
            temp_bust_index = "1511_2"
		end
    end
    local armature = sp.spine_sprite(self.scroll_view, temp_bust_index, _spine_sprite_animation_names[90], true, 1, nil, cc.p(0.5, 0))
    armature:addAnimation(0, _spine_sprite_animation_names[90], true)
    sp.initArmature(armature, true)    
    armature.animationNameList = _spine_sprite_animation_names
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)  
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
        local armature_camp = sp.spine_sprite(nil, "zy_".._ED.user_info.user_force, _spine_sprite_animation_names[90], true, nil, nil, cc.p(0.5, 0))
        armature_camp:setPositionY(20)
        armature.armature_camp = armature_camp
        if nil ~= armature.armature_camp then
            armature:addChild(armature_camp)
        end

        local armature_foot = sp.spine("images/ui/effice/effect_jd/effect_jd.json", 
            "images/ui/effice/effect_jd/effect_jd.atlas", 1, 0, effectAnimations[1], true, nil)
        armature:addChild(armature_foot,-1)
    end



    local action_index =  _enum_spine_animation_frame_index.animation_standby_dir_20
    csb.animationChangeToAction(armature,action_index, action_index, true)
    armature.playWithIndex = function(_self, actionIndex)
        -- _self:setToSetupPose()
        if actionIndex > _enum_spine_animation_frame_index.animation_attack_dir_13 
            and actionIndex < _enum_spine_animation_frame_index.animation_death 
            then
            _self:setScaleX(-1)
            if nil ~= _self.text then
                _self.text:setScaleX(-1)
            end
            if nil ~= _self.union_text then
                _self.union_text:setScaleX(-1)
            end
            if nil ~= _self.armature_camp then
                _self.armature_camp:setScaleX(-1)
            end
        else
            _self:setScaleX(1)
            if nil ~= _self.text then
                _self.text:setScaleX(1)
            end
            if nil ~= _self.union_text then
                _self.union_text:setScaleX(1)
            end
            if nil ~= _self.armature_camp then
                _self.armature_camp:setScaleX(1)
            end
        end
        _self:setAnimation(0, _self.animationNameList[actionIndex + 1], true)
        if _self.changeActionCallfunc ~= nil then
            _self.changeActionCallfunc(_self, nil, nil)
        end
    end 
    local fontName = ""
    local text = nil
    if ___is_open_leadname == true then 
        text = ccui.Text:create(_ED.user_info.user_name,fontName,16)
        text:setTextVerticalAlignment(0)
        armature:addChild(text)
        text:setPositionY(100)
        
        
        text:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
        text:enableOutline(cc.c4b(0,0,0,255), 1)
        
        armature.text = text
    else
        fontName = config_csb.campaign.nationalwar_font
        local ttfConfig = {}
        ttfConfig.fontFilePath=fontName
        ttfConfig.fontSize=16
        text = cc.Label:createWithTTF(ttfConfig, "Green", cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 180)
        text:setString(_ED.user_info.user_name)
        text:setAnchorPoint(cc.p(0.5,0.5))
        armature:addChild(text)
        text:setPositionY(100)
        armature.text = text
        -- union info
        if _ED.union.union_info ~= nil 
            and tonumber(_ED.union.union_info.union_id) ~= nil 
            and tonumber(_ED.union.union_info.union_id) > 0 
            then
            local unionName = cc.Label:createWithTTF(ttfConfig, "Green", cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 180)
            unionName:setString(_ED.union.union_info.union_name)
            unionName:setAnchorPoint(cc.p(0.5,0.5))
            armature:addChild(unionName)
            unionName:setPositionY(120)
            armature.union_text = unionName
        
            unionName:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
            unionName:enableOutline(cc.c4b(0,0,0,255), 1)
        end
    end
	
 --    local text = ccui.Text:create(_ED.user_info.user_name,fontName,16)
	-- text:setTextVerticalAlignment(0)
 --    armature:addChild(text)
 --    text:setPositionY(100)
	
	
 --    text:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
	-- text:enableOutline(cc.c4b(0,0,0,255), 1)
	-- -- text:enableGlow(cc.c4b(255,0,0,255))
	-- -- text:enableOutline(cc.c4b(113,97,73,255), 1)
	-- -- text:enableShadow(cc.c4b(0,0,0,255), cc.size(2, -1 * 2))
 --    armature.text = text



    text:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    text:enableOutline(cc.c4b(0,0,0,255), 1)

    self.armature = armature
end
--初始化npc
function NationalWarMap:initNpcArmature()
    for i,v in ipairs(npcs_table_one) do
        self:initNpcArmatureState(v,self:getRandInitCity(1))
    end
    for i,v in ipairs(npcs_table_two) do
        self:initNpcArmatureState(v,self:getRandInitCity(2))
    end
    for i,v in ipairs(npcs_table_three) do
        self:initNpcArmatureState(v,self:getRandInitCity(3))
    end        
end

function NationalWarMap:initCityMapRobotArmature()
    if _ED.city_resource_robot == nil then
        return
    end
    local idx = math.random(1, #_ED.city_resource_robot)
    local robot = _ED.city_resource_robot[idx]
    if robot == nil then
        return
    end
    local move_event = {
        user_id = robot.id,
        last_city_id = tonumber(math.random(2, 83)),
        curr_city_id = tonumber(math.random(1, 84)),
        gender = robot.gender,
        nickname = robot.name,
        union_name = robot.unionName,
    }
    -- 1 84 31

    if move_event.last_city_id ~= move_event.curr_city_id 
        and move_event.last_city_id ~= 31
        and move_event.curr_city_id ~= 31
        and zstring.tonumber(move_event.user_id) ~= zstring.tonumber(_ED.user_info.user_id)
        then
        local player_move_event = _ED.city_world_map_move_event[move_event.user_id]
        if player_move_event == nil then
            player_move_event = {_move_events = {}}
            _ED.city_world_map_move_event[move_event.user_id] = player_move_event
        end
        table.insert(player_move_event._move_events, move_event)
        state_machine.excute("national_city_world_player_map_move_to", 0, move_event.user_id)
    end
end

--创建大地图玩家
function NationalWarMap:initCityMapPlayerArmature(userId)
    -- 公会战开始后，取消地图上面的机器人移动
    if tonumber(_ED.union_fight_city_state) == 3 then
        return
    end
    local player_move_event = _ED.city_world_map_move_event[userId]
    if player_move_event._moving == true then
        return
    end
    self._move_player_count = self._move_player_count + 1
    player_move_event._moving = true
    local role_move_event = table.remove(player_move_event._move_events, 1)
	local temp_bust_index = 0
	if zstring.tonumber(role_move_event.gender) == 1 then
		temp_bust_index = "1501_2"
	else
		temp_bust_index = "1511_2"
	end

	local armature = sp.spine_sprite(nil, temp_bust_index, _spine_sprite_animation_names[90], true, nil, nil, cc.p(0.5, 0))
	-- armature:retain()
	local fontName = ""
    if ___is_open_leadname == true then 
    else
        fontName = config_csb.campaign.nationalwar_font
    end
 --    local text = ccui.Text:create(_ED.city_world_npc_map_name,fontName,16)
 --    armature:addChild(text)
 --    text:setPositionY(100)
 --    text:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
	-- text:enableOutline(cc.c4b(0,0,0,255), 1)
 --    armature.text = text

    -- local text = ccui.Text:create(role_move_event.nickname,fontName,16)
    -- text:setTextVerticalAlignment(0)

    local ttfConfig = {}
    ttfConfig.fontFilePath=fontName
    ttfConfig.fontSize=16
    local text = cc.Label:createWithTTF(ttfConfig, "Green", cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 180)
    text:setString(role_move_event.nickname)
    text:setAnchorPoint(cc.p(0.5,0.5))
    armature:addChild(text)
    text:setPositionY(100)
    armature.text = text
    
    text:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    text:enableOutline(cc.c4b(0,0,0,255), 1)
    -- text:enableGlow(cc.c4b(255,0,0,255))
    -- text:enableOutline(cc.c4b(113,97,73,255), 1)
    -- text:enableShadow(cc.c4b(0,0,0,255), cc.size(2, -1 * 2))

    -- union info
    if #role_move_event.union_name > 0 then
        local unionName = cc.Label:createWithTTF(ttfConfig, "Green", cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 180)
        unionName:setString(role_move_event.union_name)
        unionName:setAnchorPoint(cc.p(0.5,0.5))
        armature:addChild(unionName)
        unionName:setPositionY(120)
        armature.union_text = unionName
    
        unionName:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
        unionName:enableOutline(cc.c4b(0,0,0,255), 1)
    end
	
	self:initNpcArmatureState(armature,role_move_event.last_city_id)
	armature._city_id = role_move_event.last_city_id
    armature._role_move_event = role_move_event
    armature._player_move_event = player_move_event
	local function begin_move(armature)
		self:beginNpcMove(armature,1,armature._city_id)
	end
	armature:runAction(cc.Sequence:create(cc.DelayTime:create(math.random(1,5)),cc.CallFunc:create(begin_move)))
end

--获得随机初始点

function NationalWarMap:getRandInitCity(camp)
    local result = {}
    local number = 0
    for i,v in pairs(_ED.warfareCityInfo) do
        if tonumber(_ED.warfareCityInfo[i].camp) == camp then
            local city_id = tonumber(_ED.warfareCityInfo[i].city_id)
            local border_city = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould],city_id,warfare_map_mould.border_city)
            border_city = zstring.split(border_city,",")
            local can_add = true
            for k,city in ipairs(border_city) do
                if tonumber(_ED.warfareCityInfo[tonumber(city)].camp) ~= camp then
                    can_add = false
                end
            end

            local state = _ED.warfareCityInfo[i].state
            state = zstring.split(state,",")
            if state[6] == 1 then
                can_add = false
            end

            if can_add == true then
                table.insert(result,city_id)
                number = number + 1
            end

        end
    end   

    local index = math.random(1,number)
    return result[index] or red_alert_home_city_id[camp]
end

--初始化npc状态
function NationalWarMap:initNpcArmatureState(armature,home_city_id)
    local root = self.roots[1]
	if zstring.tonumber(home_city_id) == 0 or zstring.tonumber(home_city_id) == -1 then
		local city_num = dms.count(dms[config_res.campaign.nationalwar.warfare_map_mould])
		for i=1, city_num do
			if dms.int(dms[config_res.campaign.nationalwar.warfare_map_mould],i,warfare_map_mould.city_type) == 1 then
				home_city_id = i
			end
		end
	end
    armature:addAnimation(0, _spine_sprite_animation_names[90], true)
    sp.initArmature(armature, true)    
    armature.animationNameList = _spine_sprite_animation_names
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)  

    local action_index =  _enum_spine_animation_frame_index.animation_standby_dir_20
    csb.animationChangeToAction(armature,action_index, action_index, true)
    armature.playWithIndex = function(_self, actionIndex)
        if actionIndex > _enum_spine_animation_frame_index.animation_attack_dir_13 
            and actionIndex < _enum_spine_animation_frame_index.animation_death 
            then
            _self:setScaleX(-1)
            if nil ~= _self.text then
                _self.text:setScaleX(-1)
            end
            if nil ~= _self.union_text then
                _self.union_text:setScaleX(-1)
            end
            if nil ~= _self.armature_camp then
                _self.armature_camp:setScaleX(-1)
            end
        else
            _self:setScaleX(1)
            if nil ~= _self.text then
                _self.text:setScaleX(1)
            end
            if nil ~= _self.union_text then
                _self.union_text:setScaleX(1)
            end
            if nil ~= _self.armature_camp then
                _self.armature_camp:setScaleX(1)
            end
        end
        _self:setAnimation(0, _self.animationNameList[actionIndex + 1], true)
        if _self.changeActionCallfunc ~= nil then
            _self.changeActionCallfunc(_self, nil, nil)
        end
    end  

    local city_panel = ccui.Helper:seekWidgetByName(root,"Panel_build_"..home_city_id)
    local x = city_panel:getPositionX()
    local y = city_panel:getPositionY()      
    armature:setPosition(cc.p(x + city_panel:getContentSize().width/2,y + city_panel:getContentSize().height/2))
    self.scroll_view:addChild(armature, 1)
end
--初始化npc移动
function NationalWarMap:initNpcMove()

    for i,v in ipairs(npcs_table_one) do
        local function begin_move( )
            self:beginNpcMove(v,1,self:getRandInitCity(1))
        end
        self:runAction(cc.Sequence:create(cc.DelayTime:create(math.random(1,5)),cc.CallFunc:create(begin_move)))
    end
    for i,v in ipairs(npcs_table_two) do
        local function begin_move( )
            self:beginNpcMove(v,2,self:getRandInitCity(2))
        end
        self:runAction(cc.Sequence:create(cc.DelayTime:create(math.random(1,5)),cc.CallFunc:create(begin_move)))
    end
    for i,v in ipairs(npcs_table_three) do
        local function begin_move( )
            self:beginNpcMove(v,3,self:getRandInitCity(3))
        end
        self:runAction(cc.Sequence:create(cc.DelayTime:create(math.random(1,5)),cc.CallFunc:create(begin_move)))
    end
end

--npc准备移动
function NationalWarMap:beginNpcMove(armature,camp,home_city_id)
    local root = self.roots[1]
    local city_panel = ccui.Helper:seekWidgetByName(root,"Panel_build_"..home_city_id)
    local x = city_panel:getPositionX()
    local y = city_panel:getPositionY()  
    armature:setVisible(true)    
    armature:setPosition(cc.p(x + city_panel:getContentSize().width/2,y + city_panel:getContentSize().height/2))  

    local to_city_id = 0
	if self.open_type==1 then
		to_city_id = armature._role_move_event.curr_city_id
	else
		to_city_id = self:getNpcCanMoveCity(camp)
	end
    -- print("=====camp=====",camp,home_city_id,to_city_id)
    local move_table = Pathfindding:new():makePath(camp,home_city_id,to_city_id,true,self.open_type)
    if move_table == nil then
        move_table = {}
    end

    -- 添加直线移动
    if self.open_type == 1 then
        self.move_table = {to_city_id}
    end

    self:beginNpcMoveStart(armature,move_table,home_city_id,camp, to_city_id)
end
--开始移动
function NationalWarMap:beginNpcMoveStart(_armature,_move_table,home_city_id,camp, to_city_id)
    local move_table = _move_table
    local armature = _armature
    local move_index = 0
    local _city_node_table = {}
    local npc_at_id = home_city_id

    local npc_move = nil
    local get_sprite_pos = nil
    local set_user_pos_for_node = nil
    local set_npc_pos = nil
    npc_move = function(move_pos, vector)
        app.load("client.red_alert.battle.battle_macros")
        local at = CC_POSITIONS_TO_DEGREES(cc.p(move_pos), vector)
        local actionIndex = math.modf(at / (360.0 / 25.0))
        -- debug.print_r(at)
        if actionIndex < 0 then
			armature._nextIndex = nil
            actionIndex = -1 * actionIndex + 13
        end
        actionIndex = actionIndex * _spine_sprite_animation_team_count + 1
        move_index= actionIndex
        if armature._nextIndex ~= actionIndex and armature._actionIndex ~= actionIndex then
			-- if armature._nextIndex == nil or armature._nextIndex == "" then
            if armature.animationNameList[armature._nextIndex] ~= armature.animationNameList[actionIndex] 
                and armature.animationNameList[armature._actionIndex] ~= armature.animationNameList[actionIndex]
                then
				armature._nextIndex = actionIndex
				csb.animationChangeToAction(armature, actionIndex, actionIndex, true)
			end
        end
    end

    get_sprite_pos = function(to_city_id)
        -- 添加直线移动
        if self.open_type == 1 then
            local sprite = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_build_" .. to_city_id)
            table.insert(_city_node_table, 1, sprite)
            return
        else
            local root = self.roots[1]
            local border_city_path = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould],npc_at_id,warfare_map_mould.border_city_path)
            border_city_path = zstring.split(border_city_path,"|")
            for i,city_str in pairs(border_city_path) do
                local city_info = zstring.split(city_str,",")
                local city_id = city_info[1]
                local path_id = city_info[2]
                if tonumber(city_id) == to_city_id then
                    local Panel_path = ccui.Helper:seekWidgetByName(root,"Panel_path_"..path_id)
                    for i,sprite in ipairs(Panel_path:getChildren()) do
                        if tonumber(npc_at_id)  < tonumber(to_city_id) then
                            table.insert(_city_node_table,sprite)
                        else
                            table.insert(_city_node_table,1,sprite)
                        end
                    end
                end
            end
        end
    end
    set_user_pos_for_node = function(sprite_node)
        local function moveOverCallBack()
            table.remove(_city_node_table,1)
            if #_city_node_table == 0 then
                set_npc_pos(move_table[1])
            else
                set_user_pos_for_node(_city_node_table[1])
            end 

        end
        if sprite_node == nil then
            moveOverCallBack()
            return
        end
        local x = sprite_node:getPositionX()
        local y = sprite_node:getPositionY()
        -- 添加直线移动
        if self.open_type == 1 then

        else
            local root = self.roots[1]
            local path_id_panel = sprite_node:getParent()
            local path_id_panel_pos = {}
            path_id_panel_pos.x,path_id_panel_pos.y = path_id_panel:getPosition()

            local all_path_panel = path_id_panel:getParent()
            local all_path_panel_pos = {}
            all_path_panel_pos.x , all_path_panel_pos.y = all_path_panel:getPosition()

            x = x + path_id_panel_pos.x + all_path_panel_pos.x
            y = y + path_id_panel_pos.y + all_path_panel_pos.y
        end
        -- print("========",x,y)
        local move_x = x + sprite_node:getContentSize().width/2
        local move_y = y + sprite_node:getContentSize().height/2
        local user_at_x ,user_at_y = armature:getPosition()
        npc_move(cc.p(user_at_x ,user_at_y),cc.p(move_x,move_y)) 
        local move_time = self:getMoveTime(user_at_x,user_at_y,move_x,move_y)
        armature:runAction(cc.Sequence:create(cc.MoveTo:create(move_time,cc.p(move_x,move_y)),cc.CallFunc:create(moveOverCallBack)))
    end
    set_npc_pos = function(to_city_id)
        local root = self.roots[1]
        local city_panel = ccui.Helper:seekWidgetByName(root,"Panel_build_"..to_city_id)
        local x = city_panel:getPositionX()
        local y = city_panel:getPositionY()
        local move_x = x + city_panel:getContentSize().width/2
        local move_y = y + city_panel:getContentSize().height/2
        local npc_at_x ,npc_at_y = armature:getPosition()
        npc_move(cc.p(npc_at_x ,npc_at_y),cc.p(move_x,move_y))    
        local function change_npc_state()
            local action_index =  move_index - 1
			if armature._nextIndex ~= action_index and armature._actionIndex ~= action_index then
				csb.animationChangeToAction(armature,action_index, action_index, true)
				armature._nextIndex = nil
			end
            table.remove(move_table,1)
            npc_at_id = to_city_id  
            if #move_table ~= 0 then
                get_sprite_pos(move_table[1])
                set_user_pos_for_node(_city_node_table[1])
            else
               local function begin_next_move()
                   armature:setVisible(false)  
				   if self.open_type == 1 then
                        local role_move_event = armature._role_move_event
                        local player_move_event = armature._player_move_event
						armature:removeFromParent(true)player_move_event._moving = false
                        if #player_move_event._move_events > 0 then
                            self:initCityMapPlayerArmature(role_move_event.user_id)
                        else
                            self._move_player_count = self._move_player_count - 1
                        end
                        role_move_event = nil
				   else
					   local new_city_id = self:getRandInitCity(camp)
					   self:beginNpcMove(armature,camp,new_city_id)
				   end
               end

               self:runAction(cc.Sequence:create(cc.DelayTime:create(math.random(1,2)),cc.CallFunc:create(begin_next_move)))
            end       
        end
        -- print("===========================================move",npc_at_id)
        local move_time = self:getMoveTime(npc_at_x,npc_at_y,move_x,move_y)
        armature:runAction(cc.Sequence:create(cc.MoveTo:create(move_time,cc.p(move_x,move_y)),cc.CallFunc:create(change_npc_state)))
    end
    if #move_table ~= 0 then
        get_sprite_pos(move_table[1])
        set_user_pos_for_node(_city_node_table[1])  
    else
        local function createNewMove()
			if self.open_type == 1 then
				armature:removeFromParent(true)
			else
			   local reset_city_id = self:getRandInitCity(camp)
			   self:beginNpcMove(armature,camp,reset_city_id)
		   end
        end
        armature:setVisible(false)
        self:runAction(cc.Sequence:create(cc.DelayTime:create(10),cc.CallFunc:create(createNewMove)))
        if self.open_type == 1 then
		else
          armature:release()
        end
    end
end

function NationalWarMap:getMoveTime(at_x,at_y,move_x,move_y)
    local x = math.abs(move_x - at_x)
    local y = math.abs(move_y - at_y)
    local move_lenth = math.sqrt(x*x + y*y)
    move_lenth = math.floor(move_lenth)
    local will_time = move_lenth / 4 * 0.015
    return will_time
end
--根据条件随机出npc将要移动到的城池
function NationalWarMap:getNpcCanMoveCity(camp)
    local result_fight = {}
    local result_random = {}
    local fight_numbers = 0
    local random_numbers = 0
    local fighting_table = {}

    for i,city in pairs(_ED.warfareCityInfo) do
        if tonumber(city.camp) == camp then -- 自己势力的城池
            local city_id = tonumber(city.city_id)
            local border_city = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould],city_id,warfare_map_mould.border_city)
            border_city = zstring.split(border_city,",")

            --如果有相邻的不是自己的城池 说明该区域可以交战，npc可以移动
            local can_move = false
            for j,border_city_id in ipairs(border_city) do
                if tonumber(_ED.warfareCityInfo[tonumber(border_city_id)].camp) ~= camp then
                    can_move = true
                end
            end
            if can_move == true then
                table.insert(fighting_table,city)
                table.insert(result_random,city_id)
                random_numbers = random_numbers + 1
            end
        else -- 不是自己势力的城池
            local city_id = tonumber(city.city_id)
            local border_city = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould],city_id,warfare_map_mould.border_city)
            border_city = zstring.split(border_city,",")

            --如果有相邻的有自己的城池 说明该区域可以交战，npc可以移动
            local can_move = false
            for j,border_city_id in ipairs(border_city) do
                if tonumber(_ED.warfareCityInfo[tonumber(border_city_id)].camp) == camp then
                    can_move = true
                end
            end
            if can_move == true then
                table.insert(fighting_table,city)
                table.insert(result_random,city_id)
                random_numbers = random_numbers + 1
            end            
        end
    end  

    for i,city in pairs(fighting_table) do
        local state = city.state
        state = zstring.split(state,",")

        if tonumber(state[6]) == 1 then
            local city_id =  tonumber(city.city_id)
            table.insert(result_fight,city_id)
            fight_numbers = fight_numbers + 1
        end
    end

    if fight_numbers ~= 0 then
        local city_id_index = math.random(1,fight_numbers)
        return result_fight[city_id_index]
    else
        local city_id_index = math.random(1,random_numbers)
        return result_random[city_id_index]
    end

end

-- 工会战定位坐标
function NationalWarMap:updateUnionFightUserPos(cityId, isMyUser)
    local root = self.roots[1]
    local city_panel = ccui.Helper:seekWidgetByName(root,"Panel_build_"..cityId)
    local x = city_panel:getPositionX()
    local y = city_panel:getPositionY()
    -- local size = self.scroll_view:getInnerContainer():getContentSize()  
    if isMyUser == true then
        self.armature:setPosition(cc.p(x + city_panel:getContentSize().width/2,y + city_panel:getContentSize().height/2))
        _ED.city_world_map_id = cityId
        self.user_at_city_id = cityId
        self:scrollToCity(cityId)
        state_machine.excute("natinal_war_smllemap_update_draw_myself_city", 0, {cityId})
    end
    -- self.scroll_view:scrollToPercentBothDirection(cc.p((x + city_panel:getContentSize().width) /size.width*100,100 - (y + city_panel:getContentSize().height)/size.height*100),1,true)       
end

-- 初始用户坐标
function NationalWarMap:initUserPos()
    local root = self.roots[1]
	if zstring.tonumber(self.user_at_city_id) == -1 then
		self.user_at_city_id = 1
	end
    local city_panel = ccui.Helper:seekWidgetByName(root,"Panel_build_"..self.user_at_city_id)
    local x = city_panel:getPositionX()
    local y = city_panel:getPositionY()
    -- local size = self.scroll_view:getInnerContainer():getContentSize()  
    self.armature:setPosition(cc.p(x + city_panel:getContentSize().width/2,y + city_panel:getContentSize().height/2))
    self:scrollToCity(self.user_at_city_id)
    -- self.scroll_view:scrollToPercentBothDirection(cc.p((x + city_panel:getContentSize().width) /size.width*100,100 - (y + city_panel:getContentSize().height)/size.height*100),1,true)       
end

-- 滚动屏幕 不移动人物
function NationalWarMap:scrollToCity(_city_id,open_window)
    local root = self.roots[1]
    local city_panel = ccui.Helper:seekWidgetByName(root,"Panel_build_".._city_id)
    local x = city_panel:getPositionX()
    local y = city_panel:getPositionY()
    local size = self.scroll_view:getInnerContainer():getContentSize()
    local scroll_size = self.scroll_view:getContentSize()
    -- local per_x = (x + city_panel:getContentSize().width) /size.width*100
    -- local per_y = 100 - (y + city_panel:getContentSize().height)/size.height*100
    self.scroll_view:scrollToPercentBothDirection(cc.p((x + city_panel:getContentSize().width) /size.width*100,100 - (y + city_panel:getContentSize().height)/size.height*100),0.2,true)                   
    if open_window == true then
        local function open_build_button()
           state_machine.excute("national_war_map_open_build_button",0,{_city_id})
        end
        self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(open_build_button)))
    end
end

function NationalWarMap:setUserPosForNode(sprite_node)
    self.move_state = 1

    local x = sprite_node:getPositionX()
    local y = sprite_node:getPositionY()

    -- 添加直线移动
    if self.open_type == 1 then

    else
        local root = self.roots[1]
        local path_id_panel = sprite_node:getParent()
        local path_id_panel_pos = {}
        path_id_panel_pos.x,path_id_panel_pos.y = path_id_panel:getPosition()

        local all_path_panel = path_id_panel:getParent()
        local all_path_panel_pos = {}
        all_path_panel_pos.x , all_path_panel_pos.y = all_path_panel:getPosition()

        x = x + path_id_panel_pos.x + all_path_panel_pos.x
        y = y + path_id_panel_pos.y + all_path_panel_pos.y
    end
    -- print("========",x,y)
    local move_x = x + sprite_node:getContentSize().width/2
    local move_y = y + sprite_node:getContentSize().height/2
    local user_at_x ,user_at_y = self.armature:getPosition()
    self:move(cc.p(user_at_x ,user_at_y),cc.p(move_x,move_y)) 
    local function moveOverCallBack()
        if self.open_type == 1 then
        else
            sprite_node:setVisible(false)
        end
        table.remove(self._sprite_city_node_table,1)
        state_machine.excute("natinal_war_map_check_is_at_goto_city",0,"")
    end
    local move_time = self:getMoveTime(user_at_x,user_at_y,move_x,move_y)
    self.armature:runAction(cc.Sequence:create(cc.MoveTo:create(move_time,cc.p(move_x,move_y)),cc.CallFunc:create(moveOverCallBack)))
end
-- 移动用户坐标
function NationalWarMap:setUserPos(to_city_id)
    self.move_state = 1
    local root = self.roots[1]
    local city_panel = ccui.Helper:seekWidgetByName(root,"Panel_build_"..to_city_id)
    local x = city_panel:getPositionX()
    local y = city_panel:getPositionY()
    local move_x = x + city_panel:getContentSize().width/2
    local move_y = y + city_panel:getContentSize().height/2
    local user_at_x ,user_at_y = self.armature:getPosition()
    self:move(cc.p(user_at_x ,user_at_y),cc.p(move_x,move_y))    
    local function change_npc_state()
        local action_index =  self.move_index - 1
		csb.animationChangeToAction(self.armature,action_index, action_index, true)
		self.armature._nextIndex = nil
        self.move_state = 0
        table.remove(self.will_move_table,1)
        self.user_at_city_id = to_city_id
        state_machine.excute("natinal_war_smllemap_update_pos",0,"")
        if #self.will_move_table ~= 0 then
            self:getSpriteNodePos(self.will_move_table[1])
        end
        state_machine.excute("natinal_war_smllemap_update_pos",0,"")
        state_machine.excute("natinal_war_map_check_is_at_goto_city",0,"")
        -- local function responseCallback(response)
        --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
        --         state_machine.excute("natinal_war_smllemap_update_pos",0,"")
        --         state_machine.excute("natinal_war_map_check_is_at_goto_city",0,"")
        --     end
        -- end
        -- protocol_command.refush_city_info.param_list = ""..self.user_at_city_id
        -- NetworkManager:register(protocol_command.refush_city_info.code, nil, nil, nil,nil, responseCallback, false, nil)          
    end
    local move_time = self:getMoveTime(user_at_x,user_at_y,move_x,move_y)
    self.armature:runAction(cc.Sequence:create(cc.MoveTo:create(move_time,cc.p(move_x,move_y)),cc.CallFunc:create(change_npc_state)))
end

function NationalWarMap:initMapPath( )
    local root = self.roots[1]
    local Panel_paths = ccui.Helper:seekWidgetByName(root,"Panel_paths")
	if Panel_paths ~= nil then
		for i=1,116 do
			local Panel_path = ccui.Helper:seekWidgetByName(root,"Panel_path_"..i)
			if Panel_path~= nil then
				Panel_path:setVisible(false)
				for i,sprite in ipairs(Panel_path:getChildren()) do
					sprite:setVisible(false)
				end
			end
		end
    end
end

function NationalWarMap:showPath()
    local root = self.roots[1]
    local at_city_id = tonumber(self.user_at_city_id)
    local show_path_table = self.will_move_table
    self._sprite_all_node_table = {}
    -- table.insert(show_path_table,at_city_id,1)
    for i , v in pairs(show_path_table) do 
        local border_city_path = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould],at_city_id,warfare_map_mould.border_city_path)
        border_city_path = zstring.split(border_city_path,"|")
        for i,city_str in pairs(border_city_path) do
            local city_info = zstring.split(city_str,",")
            local city_id = city_info[1]
            local path_id = city_info[2]
            if tonumber(city_id) == tonumber(v) then
                local Panel_path = ccui.Helper:seekWidgetByName(root,"Panel_path_"..path_id)
                Panel_path:setVisible(true)
                for i,sprite in pairs(Panel_path:getChildren()) do
                    sprite:setVisible(true)
                    table.insert(self._sprite_all_node_table,sprite)
                end
            end
        end
        at_city_id = v
    end
end

function NationalWarMap:getSpriteNodePos(to_city_id)
    local root = self.roots[1]
    local node_pos_table = {}
    local border_city_path = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould],self.user_at_city_id,warfare_map_mould.border_city_path)
    self._sprite_city_node_table = {}
    -- 添加直线移动
    if self.open_type == 1 then
        local sprite = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_build_" .. to_city_id)
        table.insert(self._sprite_city_node_table,1, sprite)
        return
    else
        border_city_path = zstring.split(border_city_path,"|")
        for i,city_str in pairs(border_city_path) do
            local city_info = zstring.split(city_str,",")
            local city_id = city_info[1]
            local path_id = city_info[2]
            if tonumber(city_id) == to_city_id then
                local Panel_path = ccui.Helper:seekWidgetByName(root,"Panel_path_"..path_id)
                for i,sprite in ipairs(Panel_path:getChildren()) do
                    if tonumber(self.user_at_city_id)  < tonumber(to_city_id) then
                        table.insert(self._sprite_city_node_table,sprite)
                    else
                        table.insert(self._sprite_city_node_table,1,sprite)
                    end
                end
            end
        end
    end
end

function NationalWarMap:checkIsAtGotoCity()
    if #self.will_move_table == 0 then 
		if self.open_type==1 then
			_ED.city_world_map_id = _ED.city_world_map_id_backup
			self.user_at_city_id = zstring.tonumber(_ED.city_world_map_id)
			self.last_city_id = _ED.city_world_map_id

            if _ED.raiders_need_enter_fight == true then
                self:requestEnterRaiderFight()
            else
                local cityInfo = _ED.city_map_info["" .. _ED.city_world_map_id]
                -- if nil ~= cityInfo and cityInfo.city_Resource_points ~= "-1" and #cityInfo.city_Resource_points > 0 then
                    state_machine.excute("national_city_world_big_map_button_report", 0, {_datas = {city_id = _ED.city_world_map_id}})   
                -- end
                state_machine.excute("natinal_war_smllemap_update_draw_myself_city", 0, {_ED.city_world_map_id_backup})

                local cityInfo = _ED.city_map_info["" .. self.user_at_city_id]
                if nil ~= cityInfo then
                    if cityInfo.city_Resource_points ~= "-1" and #cityInfo.city_Resource_points > 0 then
                    else
                        TipDlg.drawTextDailog(string_map_rattling_info[7])
                    end
                end
            end
		else
			local function responseCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					self.user_at_city_id = _ED.war_user_at_city_id
					self.last_city_id = _ED.war_user_at_city_id                   
					state_machine.excute("national_war_city_war_map_window_open",0,{self.user_at_city_id})
					state_machine.excute("natinal_war_smllemap_update_pos",0,"")
					state_machine.excute("national_war_map_user_to_update",0,{self.user_at_city_id})
				end
			end
			protocol_command.join_city.param_list = ""..self.user_at_city_id
			NetworkManager:register(protocol_command.join_city.code, nil, nil, nil,nil, responseCallback, false, nil)  
		end
    else
        if self:checkNextCityCanMove(self.will_move_table[1]) == true then
            if #self._sprite_city_node_table == 0 then
                self:setUserPos(self.will_move_table[1])
            else
                self:setUserPosForNode(self._sprite_city_node_table[1])
            end
        else
            for i,sprite in pairs(self._sprite_all_node_table) do
                sprite:setVisible(false)
            end
            self.will_move_table = {}
            self._sprite_all_node_table = {}     

            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                   self.user_at_city_id = _ED.war_user_at_city_id
                   self.last_city_id = _ED.war_user_at_city_id                   
                   state_machine.excute("natinal_war_smllemap_update_pos",0,"")
                   state_machine.excute("national_war_map_user_to_update",0,{self.user_at_city_id})
                end
            end
            protocol_command.join_city.param_list = ""..self.user_at_city_id
            NetworkManager:register(protocol_command.join_city.code, nil, nil, nil,nil, responseCallback, false, nil)                     
        end
    end
end

function NationalWarMap:move(move_pos, vector)
    app.load("client.red_alert.battle.battle_macros")
    local at = CC_POSITIONS_TO_DEGREES(cc.p(move_pos), vector)
    local actionIndex = math.modf(at / (360.0 / 25.0))
    -- debug.print_r(at)
    if actionIndex < 0 then
		self.armature._nextIndex = nil
        actionIndex = -1 * actionIndex + 13
    end
    actionIndex = actionIndex * _spine_sprite_animation_team_count + 1
    self.move_index = actionIndex
	if self.armature._nextIndex ~= actionIndex and self.armature._actionIndex ~= actionIndex then
		-- if self.armature._nextIndex == nil or self.armature._nextIndex == "" then
        if self.armature.animationNameList[self.armature._nextIndex] ~= self.armature.animationNameList[actionIndex] 
                and self.armature.animationNameList[self.armature._actionIndex] ~= self.armature.animationNameList[actionIndex]
                then
			self.armature._nextIndex = actionIndex
			csb.animationChangeToAction(self.armature, actionIndex, actionIndex, true)
		end
		-- self.armature._nextIndex = actionIndex
	end
end

function NationalWarMap:onUpdate(dt)  
	if self.open_type==1 then
		self:onUpdateScreenMove(dt)

        -- 公会战开始后，取消地图上面的机器人移动
        if tonumber(_ED.union_fight_city_state) ~= 3 then
            if self._move_player_count < self._max_move_player_count then
                local r = tonumber(math.random(1, 100))
                if r < 10 then
                    -- 创建机器人
                    self:initCityMapRobotArmature()
                end
            end
        end
	else
		if self.war_fight_is_over == true then
			return
		end

		if _ED.warfar_is_open == 0 then
			self.war_fight_is_over = true
			state_machine.excute("national_war_billing_window_open",0,"")
			return
		end
		self:onUpdateMapCityState(dt)
		self:onUpdateMapAllCityCampAndAnimationState(dt)
		self:onUpdateAllDraw(dt)
		self:onUpdateAllInfo(dt)
		self:onUpdateBackCityButton(dt)
		self:onUpdateKillMaxTimes(dt)
		
	end
end


function NationalWarMap:onUpdateKillMaxTimes()
    local now_time = os.time()
    if now_time > zstring.tonumber(self.kill_update_time) + 2 then
        state_machine.excute("national_war_kill_max_update_kill_numbers",0,"")
        self.kill_update_time = now_time
    end
end

function NationalWarMap:onUpdateBackCityButton(dt)
    if self.back_city_button == nil or self.open_type == 1 then
        return
    end
    if self.user_at_city_id == red_alert_home_city_id[tonumber(_ED.user_info.user_force)] or self.move_state == 1 then
        self.back_city_button:setVisible(false)
    else
        self.back_city_button:setVisible(true)
    end
end

function NationalWarMap:onUpdateAllInfo()
    local now_time = os.time()
    if now_time - zstring.tonumber(self.last_time_update_all_info) > 5 then
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                state_machine.excute("natinal_war_smllemap_update_pos",0,"")
                state_machine.excute("natinal_war_smllemap_update_decree",0,"")
                state_machine.excute("natinal_war_smllemap_update_state",0,"")
                if tonumber(_ED.revive_cooling_time) > 0 and _ED.war_user_dead == true then
                    if _ED.warfar_my_fight_fail_info_is_show  == false then
                        -- print("===============1111111",_ED.warfar_my_fight_fail_info_is_show)
                        _ED.warfar_my_fight_fail_info_is_show = true
                        state_machine.excute("natinal_war_revivetime_window_open",0,"")
                        state_machine.excute("national_war_record_window_open",0,{self.last_city_id})
                        state_machine.excute("national_war_map_return_home_city",0,"")
                    end
                else
                    state_machine.excute("national_war_hero_listview_update_hp",0,"")
                end
            end
        end   
        self.last_time_update_all_info = now_time 
        protocol_command.refush_city_info.param_list = self.user_at_city_id
        NetworkManager:register(protocol_command.refush_city_info.code, nil, nil, nil,nil, responseCallback, false, nil)
    end
end

function NationalWarMap:onUpdateAllDraw()
    local root = self.roots[1]


    local min_x = math.abs(self.scroll_view:getInnerContainer():getPositionX())
    local min_y = math.abs(self.scroll_view:getInnerContainer():getPositionY())
    local max_x = self.scroll_view:getContentSize().width + min_x
    local max_y = self.scroll_view:getContentSize().height + min_y

    local width = self.panel_citys[1]:getContentSize().width
    local height = self.panel_citys[1]:getContentSize().height
    for i,panel in ipairs(self.panel_citys) do
        local x = panel:getPositionX()
        local y = panel:getPositionY()
        if x > min_x - width and x < max_x + width and y > min_y - height and y < max_y + height then
            panel:setVisible(true)
        else
            panel:setVisible(false)
        end
    end 

    for i,armature in ipairs(npcs_table_one) do
        local x = armature:getPositionX()
        local y = armature:getPositionY()        
        if x > min_x and x < max_x and y > min_y and y < max_y then
            armature:setVisible(true)
        else
            armature:setVisible(false)
        end
    end
    for i,armature in ipairs(npcs_table_two) do
        local x = armature:getPositionX()
        local y = armature:getPositionY()           
        if x > min_x and x < max_x and y > min_y and y < max_y then
            armature:setVisible(true)
        else
            armature:setVisible(false)
        end
    end
    for i,armature in ipairs(npcs_table_three) do
        local x = armature:getPositionX()
        local y = armature:getPositionY() 
        if x > min_x and x < max_x and y > min_y and y < max_y then
            armature:setVisible(true)
        else
            armature:setVisible(false)
        end        
    end    
end

function NationalWarMap:onUpdateMapAllCityCampAndAnimationState(dt)
    local now_time = os.time()
    if self._last_city_animation_time == nil or now_time >= self._last_city_animation_time + 3 then
        state_machine.excute("national_war_hero_listview_update_hp",0,"")
        self:checkGetNewOrder()
        self._last_city_animation_time = now_time
        for i,v in pairs(_ED.warfareCityInfo) do
            if (_ED.war_city_last_info[i].state ~= v.state or _ED.war_city_last_info[i].camp ~= v.camp) and self.panel_citys[i]:isVisible() == true then
                _ED.war_city_last_info[i].state = v.state
                _ED.war_city_last_info[i].camp = v.camp
                self._city_cells[i]:onUpdateDrawOtherState()
                state_machine.excute("natinal_war_smllemap_update_state",0,"")
                return
            end  
            if self.panel_citys[i]:isVisible() == true then
                self._city_cells[i]:onUpdateDrawOtherState()
            end
        end
        
    end
end

function NationalWarMap:onUpdateMapCityState(dt) --家族集结和国战集结
    local now_time = os.time()
    if self._last_time == nil or now_time >= self._last_time + 1 then
        for i,cell in ipairs(self._city_cells) do
            if _ED.war_decree_time[i] ~= nil and zstring.tonumber(_ED.war_decree_time[i].family_leave_time) ~= 0 and zstring.tonumber(_ED.war_decree_time[i].family_start_time) ~= 0 then
                if _ED.war_decree_time[i].family_leave_time - (now_time - _ED.war_decree_time[i].family_start_time) < 0 then
                    _ED.war_decree_time[i].family_leave_time = 0
                end
            end
            if _ED.war_decree_time[i] ~= nil and zstring.tonumber(_ED.war_decree_time[i].country_leave_time) ~= 0 and zstring.tonumber(_ED.war_decree_time[i].country_start_time) ~= 0 then
                if _ED.war_decree_time[i].country_leave_time - (now_time - _ED.war_decree_time[i].country_start_time) < 0 then
                    _ED.war_decree_time[i].country_leave_time = 0
                end
            end
            if self.panel_citys[i]:isVisible() == true then
                cell:onUpdateDecreeState()
            end
            state_machine.excute("natinal_war_smllemap_update_decree",0,"")
        end
        self._last_time = now_time
    end 
end

--强制刷新
function NationalWarMap:userToUpdateBuild(city_id)
    for i,cell in ipairs(self._city_cells) do
        if i == city_id then
            cell:onUpdateDecreeState()
            cell:onUpdateDrawOtherState()
        end
   end
end

function NationalWarMap:getData()
	if self.open_type==1 then
		_ED.city_world_map_id = _ED.city_world_map_id_backup
		if zstring.tonumber(_ED.city_world_map_id) == 0 or zstring.tonumber(_ED.city_world_map_id) == -1 then
			local city_num = dms.count(dms[config_res.campaign.nationalwar.warfare_map_mould])
			for i=1, city_num do
				if dms.int(dms[config_res.campaign.nationalwar.warfare_map_mould],i,warfare_map_mould.city_type) == 1 then
					_ED.city_world_map_id = i
				end
			end
		end
		self.user_at_city_id = zstring.tonumber(_ED.city_world_map_id)
		self.last_city_id = _ED.city_world_map_id
	else
		self.user_at_city_id = tonumber(_ED.war_user_at_city_id)
		self.last_city_id = _ED.war_user_at_city_id
	end
end

function NationalWarMap:loadOtherWindow()
    local root = self.roots[1]
    local Panel_top_infor = ccui.Helper:seekWidgetByName(root,"Panel_top_infor")
    local Panel_role_head = ccui.Helper:seekWidgetByName(root,"Panel_role_head")
    local Panel_smlle_map = ccui.Helper:seekWidgetByName(root,"Panel_smlle_map")
    state_machine.excute("national_warmap_top_info_window_open",0,{Panel_top_infor})
    state_machine.excute("natinal_war_hero_listview_window_open",0,{Panel_role_head})
    state_machine.excute("natinal_war_smlle_map_window_open",0,{Panel_smlle_map})
    state_machine.excute("national_war_kill_max_window_open",0,"")
	if self.open_type==1 then
		Panel_role_head:setVisible(false)
		Panel_top_infor:setVisible(false)
	end
end

function NationalWarMap:onUpdateScreenMove()
	if self.move_state == 1 then
		local container = self.scroll_view:getInnerContainer()
		local currentPosition = cc.p(container:getPosition())
		local rolePosition = cc.p(self.armature:getPosition())
		local screenPosition = cc.p(rolePosition.x + currentPosition.x, rolePosition.y + currentPosition.y)
		local centerPosition = cc.p(self.m_size.width / 2, self.m_size.height / 2)
		local moveByPosition = cc.p(centerPosition.x - screenPosition.x, centerPosition.y - screenPosition.y)
		local moveX = 0
		local movey = 0
		if currentPosition.x+moveByPosition.x > self.scroll_viewWidth*-1 then
			
			if currentPosition.x+moveByPosition.x > 0 then
				moveX = 0
			else
				moveX = currentPosition.x+moveByPosition.x
			end
		else
			moveX = self.scroll_viewWidth*-1
		end
		if currentPosition.y+moveByPosition.y > self.scroll_viewHeight*-1 then
			
			if currentPosition.y+moveByPosition.y > 0 then
				movey = 0
			else
				movey = currentPosition.y+moveByPosition.y
			end
		else
			movey = self.scroll_viewHeight*-1
		end
		container:setPosition(cc.p(moveX,movey))
	end
    state_machine.excute("national_city_update_my_resource_info", 0, nil)
end

function NationalWarMap:addOpenEffect( ... )
    if _ED.union_fight_city_state == 3 then
        state_machine.excute("union_fighting_open_open", 0, nil)
        local root = self.roots[1]
        local Panel_legion_effice = ccui.Helper:seekWidgetByName(root, "Panel_legion_effice")
        Panel_legion_effice:removeAllChildren(true)
        if _ED.union_fight_city_last_state == 2 
            and _ED.union_fight_city_opened ~= true 
            then
            _ED.union_fight_city_opened = true
            local baseName = "effect/effect_bpopen"
            local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
            skeletonNode:registerSpineEventHandler(function (event)
                event.skeletonAnimation:removeFromParent(true)
            end, sp.EventType.ANIMATION_COMPLETE)
            skeletonNode:setAnimation(0, "animation", true)
            Panel_legion_effice:addChild(skeletonNode)
            local sound = dms.int(dms["sound_effect_param"], 44, sound_effect_param.special_effect)
            if sound > 0 then
                playEffectMusic(sound)
            end
        end
    end
end

function NationalWarMap:addRoleDeathEffect( ... )
    if _ED.union_fight_city_user_info ~= nil and 
        _ED.union_fight_city_user_info.is_death == "1" 
        then
        self.armature:removeChildByTag(10000)
        local baseName = "effect/effect_youling"
        local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
        skeletonNode:setAnimation(0, "animation", true)
        self.armature:addChild(skeletonNode, 10000)
        skeletonNode:setTag(10000)
        self.armature:setColor(union_fight_report_color[8])
    end
end

function NationalWarMap:addRoleReviewEffect( ... )
    self.armature:removeChildByTag(10000)
    local baseName = "effect/effect_guozhanfuhuo"
    local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
    skeletonNode:registerSpineEventHandler(function (event)
        event.skeletonAnimation:removeFromParent(true)
    end, sp.EventType.ANIMATION_COMPLETE)
    skeletonNode:setAnimation(0, "animation", true)
    self.armature:addChild(skeletonNode, 10000)
    self.armature:setColor(union_fight_report_color[9])
end

function NationalWarMap:addUnionFightingEndEffect( ... )
    state_machine.excute("union_fighting_open_close", 0, nil)
    local root = self.roots[1]
    local Panel_legion_effice = ccui.Helper:seekWidgetByName(root, "Panel_legion_effice")
    Panel_legion_effice:removeAllChildren(true)
    local baseName = "effect/effect_bpzhanjieshu"
    local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
    skeletonNode:registerSpineEventHandler(function (event)
        event.skeletonAnimation:removeFromParent(true)
    end, sp.EventType.ANIMATION_COMPLETE)
    skeletonNode:setAnimation(0, "animation", true)
    Panel_legion_effice:addChild(skeletonNode)
    local sound = dms.int(dms["sound_effect_param"], 45, sound_effect_param.special_effect)
    if sound > 0 then
        playEffectMusic(sound)
    end
end

function NationalWarMap:init(datas)
	self.open_type = datas[1]

    config_res = config_res or {}
    config_res.campaign = config_res.campaign or {}
    config_res.campaign.nationalwar = config_res.campaign.nationalwar or {}
    if nil == config_res.campaign.nationalwar.default_world_map_mould then
        config_res.campaign.nationalwar.default_world_map_mould = "world_map_mould"
        config_res.campaign.nationalwar.default_warfare_map_mould = "warfare_map_mould"
        config_res.campaign.nationalwar.warfare_map_mould = config_res.campaign.nationalwar.default_world_map_mould
        config_res.campaign.nationalwar.default_world_order_reward = "world_order_reward"
        config_res.campaign.nationalwar.default_warfare_order_reward = "warfare_order_reward"
        config_res.campaign.nationalwar.warfare_order_reward = config_res.campaign.nationalwar.default_world_order_reward
    end

    if self.open_type == 1 then
        config_res.campaign.nationalwar.warfare_map_mould = config_res.campaign.nationalwar.default_world_map_mould
        config_res.campaign.nationalwar.warfare_order_reward = config_res.campaign.nationalwar.default_world_order_reward
    else
        config_res.campaign.nationalwar.warfare_map_mould = config_res.campaign.nationalwar.default_warfare_map_mould
        config_res.campaign.nationalwar.warfare_order_reward = config_res.campaign.nationalwar.default_warfare_order_reward
    end

    self:onInit()
    return self
end

function NationalWarMap:onExit()
    _ED.raiders_need_enter_fight = false

    config_res.campaign.nationalwar.warfare_map_mould = config_res.campaign.nationalwar.default_world_map_mould
    config_res.campaign.nationalwar.warfare_order_reward = config_res.campaign.nationalwar.default_world_order_reward

    state_machine.remove("national_war_map_move_my_pos")  
    state_machine.remove("national_war_map_open_build_button") 
    state_machine.remove("natinal_war_map_scroll_change_pos")
    state_machine.remove("national_war_map_window_show")
    state_machine.remove("national_war_map_window_hide")   
    state_machine.remove("natinal_war_map_check_is_at_goto_city",0,"") 
    state_machine.remove("national_war_map_return_home_city",0,"")
    state_machine.remove("national_war_map_move_to_city",0,"")
    state_machine.remove("national_war_map_scroll_to_city")
    state_machine.remove("national_war_map_onrush")
    state_machine.remove("national_war_back_city")
    state_machine.remove("national_war_map_from_task")
    state_machine.remove("national_war_map_user_to_update")
    state_machine.remove("national_war_map_scroll_position")
    state_machine.remove("national_city_resource_hold_quit")
    state_machine.remove("national_city_world_map_move_to")
    state_machine.remove("national_city_world_player_map_move_to")
    state_machine.remove("national_city_move_to_my_pos")
    state_machine.remove("national_city_update_my_resource_info")
    state_machine.remove("national_city_update_map_resource_cells")
    state_machine.remove("national_city_hide_game_resource_info")
    state_machine.remove("national_city_move_raiderscut_pos")
    state_machine.remove("national_city_move_raiderscut_pos_tuition")
    state_machine.remove("national_city_world_map_move_to_resource_tuition")
    state_machine.remove("national_city_move_raiderscut_fight")
    state_machine.remove("national_city_update_union_city_map_info")
    state_machine.remove("national_city_refresh_union_city_map_info")
    state_machine.remove("national_city_update_union_city_user_pos")
    state_machine.remove("national_city_open_union_attack_rank")
    state_machine.remove("national_city_open_union_role_death")
    state_machine.remove("national_city_open_union_add_role_death_effect")
    state_machine.remove("national_city_open_union_add_role_review_effect")
    state_machine.remove("national_city_open_union_add_fighting_end_effect")
    state_machine.remove("national_city_open_union_add_fighting_begin_effect")
    state_machine.remove("national_city_open_personal_fighting")
    state_machine.remove("national_city_refresh_personal_fighting")
end