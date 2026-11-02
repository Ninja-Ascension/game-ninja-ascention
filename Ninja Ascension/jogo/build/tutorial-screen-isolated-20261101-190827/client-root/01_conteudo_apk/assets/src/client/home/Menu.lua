-- ----------------------------------------------------------------------------------------------------
-- 说明：底层菜单
-- 创建时间 2015-03-06
-- 作者：胡文轩
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
local is2002 = false
if __lua_project_id == __lua_project_warship_girl_a 
or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
or __lua_project_id == __lua_project_koone
then
    if dev_version >= 2002 then
        is2002 = true
    end
end
Menu = class("MenuClass", Window)


--登录弹窗
local menu_window_open_terminal = {
    _name = "menu_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        app.load("client.home.Menu")
        fwin:open(Menu:new(), fwin._taskbar)
        state_machine.excute("menu_manager", 0, 
            {
                _datas = {
                    terminal_name = "menu_manager",     
                    next_terminal_name = "menu_show_home_page", 
                    current_button_name = "Button_home",
                    but_image = "Image_home",       
                    terminal_state = 0, 
                    isPressedActionEnabled = true
                }
            }
        )
        fwin:__show(fwin._frameview)
        return false
    end,
    _terminal = nil,
    _terminals = nil
}

local menu_window_open_mission_terminal = {
    _name = "menu_window_open_mission",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		state_machine.excute("menu_window_open", 0, 0)
		resetMission()
		if executeMissionExt(mission_mould_tuition, nil, nil, nil, true, "l".._ED.user_info.user_grade.."e".._ED.user_info.user_experience, true) == false then
			if executeMissionExt(mission_mould_plot, nil, nil, nil, true, "l".._ED.user_info.user_grade.."e".._ED.user_info.user_experience, true) == false then
			end
		end

        fwin:addService({
            callback = function ( params )
                local menuWindow = fwin:find("MenuClass")
                fwin._bg_music_indexs = {}
                fwin._last_music = -1
                fwin._stop_music = false
                fwin._current_music = menuWindow.__cmusic
            end,
            delay = 0.1,
            params = nil
        })
        return false
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(menu_window_open_terminal)
state_machine.add(menu_window_open_mission_terminal)
state_machine.init()


function Menu:ctor()
    self.super:ctor()
    self.roots = {}
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
        app.load("client.home.LevelPacks")
        self._view = fwin._frameview
        self._zorder = 2
    end
    self.keepAcliveInterval = os.time()
    self.platform_tx_pay_time = os.time()
    self._base_client_time = 0
    
    self._is_onenter = false
    self._is_running_state = 0
    self._execute_login_game_mission = false
    self._close_touch_end_event = true
    fwin._close_touch_end_event = true

    app.load("client.home.PushInfo")
    if __lua_project_id == __lua_project_adventure then
	   app.load("client.adventure.home.AdventurePushInfo")
    end
    app.load("client.campaign.worldboss.BetrayArmyNpcArrival")
    if __lua_project_id == __lua_project_gragon_tiger_gate 
    	or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
    	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
    	or __lua_project_id == __lua_project_red_alert 
    	then
    	app.load("client.packs.hero.SmRoleInformation")
        app.load("client.home.LevelPacks")
        app.load("client.reward.DrawRareReward")
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
            or __lua_project_id == __lua_project_l_naruto 
            then
            app.load("client.activity.sevendaysnew.SevenDaysManager")
            app.load("client.red_alert_time.utils.combatEffectivenessUp")
        end
    end
    -- Initialize Menu page state machine.
    local function init_menu_terminal()

        local menu_manager_terminal = {
            _name = "menu_manager",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    if params._datas.next_terminal_name == "menu_show_campaign" then
                        if true == funOpenDrawTip(79) then
                            return false
                        end
                    end
                end
				if __lua_project_id == __lua_project_adventure then
                    state_machine.excute("adventure_mercenary_hero_handbook_hide",0,0)
					if params._datas.next_terminal_name ~= "menu_show_home_page" 
					and params._datas.next_terminal_name ~= "menu_adventure_avg"  
					and funOpenConditionJudge(params._datas.openId) == false then
						TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], params._datas.openId, fun_open_condition.tip_info))
						return
					end
				end
                local lock_terminal = state_machine.find("menu_manager_change_to_page", 0, "")
                if lock_terminal ~= nil then
                    if lock_terminal._lock == true then
                        return false
                    end
                end
                -- set select ui button is highlighted
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(false)
                    terminal.select_button:setTouchEnabled(true)
                end
                if params._datas.current_button_name ~= nil or params._datas.current_button_name ~= "" then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name) 
                end
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(true)
                    terminal.select_button:setTouchEnabled(false)         
                end
                ---动画
               if terminal.animation_panel ~= nil and terminal.animation_panel:isVisible() == true then 
                   terminal.animation_panel:setVisible(false)
                   terminal.animation_image:setVisible(true)
               end
                if params._datas.animation_name ~= nil or params._datas.animation_name ~= "" then
                    terminal.animation_panel = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.animation_name) 
                    terminal.animation_image = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.but_image) 
                end
                if terminal.animation_panel ~= nil and terminal.animation_panel:isVisible() == false then
                     terminal.animation_panel:setVisible(true)
                     terminal.animation_image:setVisible(false)  
                end
                --
                if terminal.last_terminal_name ~= params._datas.next_terminal_name and params._datas.next_terminal_name ~= params._datas.terminal_name then
                    local but_bgImage = nil
                    if terminal.page_name ~= nil then
                        but_bgImage = ccui.Helper:seekWidgetByName(instance.roots[1], terminal.page_name)
                        if but_bgImage ~= nil then
                            if __lua_project_id ~= __lua_project_adventure then
                                but_bgImage:setVisible(false)
                            end
                        end
                    end
                    terminal.page_name = params._datas.but_image
                    but_bgImage = ccui.Helper:seekWidgetByName(instance.roots[1], terminal.page_name)
                    if but_bgImage ~= nil then
                         if __lua_project_id ~= __lua_project_adventure then
                             but_bgImage:setVisible(false)
                         end
                    end

                    -- fwin:cleanView(fwin._background)
                    -- fwin:cleanView(fwin._view)
                    -- fwin:cleanView(fwin._viewdialog)
              --       fwin:cleanView(fwin._ui)
              --       terminal.last_terminal_name = params._datas.next_terminal_name
                    -- state_machine.excute(params._datas.next_terminal_name, 0, params)
                    
                    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
                        params._datas._enter_type = nil
                    end
                    
                    if (__lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game) and
                      "menu_show_home_page" == terminal.last_terminal_name and 
                      "menu_show_formation" == params._datas.next_terminal_name then
                        params._datas._enter_type = "home"
                    else
                        fwin:freeCache()
                        if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
                        else
                            cc.Director:getInstance():getTextureCache():unbindAllImageAsync()
                        end
                        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
                    end  
                    
                    state_machine.excute("activity_window_hide", 0, 0)
                    terminal.last_terminal_name = params._datas.next_terminal_name
                    state_machine.excute("menu_manager_change_to_page", 0, params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 切换页面
        local menu_manager_change_to_page_terminal = {
            _name = "menu_manager_change_to_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("menu_manager_change_to_page", 0, "")
                
                if  (__lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game) and
                  "menu_show_home_page" == terminal.last_terminal_name and 
                  "menu_show_formation" == params._datas.next_terminal_name then
                    
                else   
                    if __lua_project_id == __lua_project_adventure then
                        --特殊情况 ,界面需要 此界面在windows层中,切换主页按钮无法正常关闭
                        fwin:close(fwin:find("AdventureMercenaryheroInfoClass"))
                    end
                    fwin:cleanView(fwin._background)
                    fwin:cleanView(fwin._view)
                    fwin:cleanView(fwin._viewdialog)
                    fwin:cleanView(fwin._ui)
                end
                
                terminal.last_terminal_name = params._datas.next_terminal_name
                state_machine.excute(params._datas.next_terminal_name, 0, params)

                -- if __lua_project_id == __lua_project_adventure then
                --     local Button_daditu = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_daditu")
                --     local Button_wakuang = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_wakuang")
                --     if "menu_show_home_page" == terminal.last_terminal_name then
                --         Button_daditu:setVisible(false)
                --         Button_wakuang:setVisible(true)
                --         Button_wakuang:setHighlighted(true)
                --     elseif "menu_adventure_mining" == terminal.last_terminal_name then
                --         Button_daditu:setVisible(true)
                --         Button_daditu:setHighlighted(true)
                --         Button_wakuang:setVisible(false)
                --         Button_wakuang:setHighlighted(false)
                --     else
                --         Button_daditu:setVisible(true)
                --         Button_daditu:setHighlighted(false)
                --         Button_wakuang:setVisible(false)
                --     end
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 清除主页页面状态
        local menu_clean_page_state_terminal = {
            _name = "menu_clean_page_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local menu_manager_terminal = state_machine.find("menu_manager")
                if menu_manager_terminal ~= nil then
                    menu_manager_terminal.last_terminal_name = nil
                end
                state_machine.unlock("menu_manager", 0, "")

                fwin:cleanView(fwin._background)
                fwin:cleanView(fwin._view)
                fwin:cleanView(fwin._viewdialog)
                fwin:cleanView(fwin._ui)
               
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
                    state_machine.unlock("menu_manager_change_to_page", 0, "")
                elseif __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
                    state_machine.unlock("menu_manager_change_to_page", 0, "")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 历练里面清除主页页面状态
        local menu_clean_page_state_campaign_terminal = {
            _name = "menu_clean_page_state_campaign",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local menu_manager_terminal = state_machine.find("menu_manager")
                if menu_manager_terminal ~= nil then
                    menu_manager_terminal.last_terminal_name = nil
                end
                state_machine.unlock("menu_manager", 0, "")

                -- fwin:cleanView(fwin._background)
                -- fwin:cleanView(fwin._view)
                -- fwin:cleanView(fwin._viewdialog)
                -- fwin:cleanView(fwin._ui)
                state_machine.unlock("menu_manager_change_to_page", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		 -- 清除与强化冲突
        local menu_clean_page_state_for_streng_terminal = {
            _name = "menu_clean_page_state_for_streng",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local menu_manager_terminal = state_machine.find("menu_manager")
                if menu_manager_terminal ~= nil then
                    menu_manager_terminal.last_terminal_name = nil
                end
         
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 打开主面的状态机
        local menu_show_home_page_terminal = {
            _name = "menu_show_home_page",
            _init = function (terminal) 
                app.load("client.home.Home")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:cleanView(fwin._background)
                fwin:cleanView(fwin._view)
                fwin:cleanView(fwin._viewdialog)
                fwin:cleanView(fwin._ui)
                if (__lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game) and 
                  params._datas._needOpenHomeHero == true then
                    local home_wnd = Home:new()
                    state_machine.excute("home_change_open_atrribute", 0, true)
                    fwin:open(home_wnd, fwin._view)
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                        fwin:open(UserInformation:new(), fwin._frameview)
                    end
                elseif __lua_project_id == __lua_project_adventure then
                --     state_machine.excute("menu_adventure_avg", 0, 0)
                --     fwin:open(Home:new(), fwin._view)

                    state_machine.unlock("menu_manager_change_to_page", 0, "")
                    state_machine.excute("menu_manager", 0, 
                        {
                            _datas = {
                                terminal_name = "menu_manager",     
                                next_terminal_name = "menu_adventure_avg", 
                                current_button_name = "Button_maoxian",
                                 but_image = "Image_beijing_4",
                                 animation_name = "Panel_maoxian",          
                                terminal_state = 0, 
                                isPressedActionEnabled = false
                            }
                        }
                    )
                else
                    fwin:open(Home:new(), fwin._view)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开主面的状态机
        local menu_back_home_page_terminal = {
            _name = "menu_back_home_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                    fwin:cleanView(fwin._background)
                    fwin:cleanView(fwin._view)
                    fwin:cleanView(fwin._viewdialog)
                    fwin:cleanView(fwin._ui)
                    LoginLoading.load_plist()
                    fwin:__show(fwin._frameview)
                    local home = fwin:find("HomeClass")
                    local HomeHero = fwin:find("HomeHeroClass")
                    local UserInformation = fwin:find("UserInformationClass")
                    if home ~= nil then
                        home:setVisible(true)
                    end
                    if HomeHero ~= nil then
                        HomeHero:setVisible(true)
                    end
                    if UserInformation ~= nil then
                        UserInformation:setVisible(true)
                    end
                    state_machine.excute("home_show_event",0,"home_show_event")
                    state_machine.excute("menu_show_event", 0, "menu_show_event.")

                    if missionIsOver() == true then
                        local clv = tonumber(_ED.user_info.user_grade)
                        if clv >= 7 then
                            _ED.user_info.mission_user_grade = _ED.user_info.mission_user_grade or 7
                            if (_ED.user_info.mission_user_grade < 7) then
                                _ED.user_info.mission_user_grade = 7
                            end
                            -- print("校验升级事件：", clv, _ED.user_info.mission_user_grade)
                            if clv > _ED.user_info.mission_user_grade then
                                for level = _ED.user_info.mission_user_grade + 1, clv do
                                    _ED.user_info.mission_user_grade = level
                                    -- print("当前校验等级：", level)
                                    local exploreWindow = fwin:find("ExploreWindowClass")
                                    if _ED.user_info.mission_user_grade1 == _ED.user_info.mission_user_grade then
                                    else
                                        if executeMissionExt(mission_mould_tuition, touch_off_mission_ls_scene, "".._ED.user_info.mission_user_grade, nil, true, nil, false) == true then
                                            -- print("有升级事件执行")
                                            if nil ~= exploreWindow then
                                                fwin:close(exploreWindow) 
                                            end
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                    return false
                end
                -- state_machine.find("menu_manager").last_terminal_name = "menu_show_home_page"
                -- fwin:open(Home:new(), fwin._view)
                state_machine.excute("menu_manager", 0, 
                {
                    _datas = {
                        terminal_name = "menu_manager",     
                        next_terminal_name = "menu_show_home_page",     
                        current_button_name = "Button_home",     
                        but_image = "Image_home",  
                        terminal_state = 0, 
                        isPressedActionEnabled = true
                    }
                })
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --打开阵容界面
        local menu_show_formation_terminal = {
            _name = "menu_show_formation",
            _init = function (terminal) 
                app.load("client.formation.Formation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
    --             local ship = params._datas._shipInstance
                -- local formation = Formation:new()
    --             if ship ~= nil then
    --                 formation:init(ship)
    --             else
    --              for i = 2, 7 do
    --                  local shipId = _ED.formetion[i]
    --                  if tonumber(shipId) > 0 then
    --                      local isleadtype = dms.int(dms["ship_mould"], _ED.user_ship[shipId].ship_template_id, ship_mould.captain_type)
    --                      if tonumber(isleadtype) == 0 then
    --                          formation:init(_ED.user_ship[_ED.formetion[i]])
    --                      end
    --                  end
    --              end
    --             end
                -- fwin:open(formation, fwin._view) 
                state_machine.excute("formation_open_instance_window", 0, params)
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then         --龙虎门项目控制
                    fwin:__hide(fwin._frameview)
                    state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
                    state_machine.excute("home_hide_event", 0, "home_hide_event.")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --直接进入到场景时判定是否存在教学并启动教学(主要用于教学)
        local menu_start_scene_event_execute_mission_terminal = {
            _name = "menu_start_scene_event_execute_mission",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

                local function startSceneEvent(pveSceneID)
                    local currentPveSceneID = zstring.tonumber(pveSceneID)
                    local sceneParam = "sc".._ED.scene_current_state[zstring.tonumber(""..currentPveSceneID)]..
                        "m".._ED.scene_max_state[zstring.tonumber(""..currentPveSceneID)]
                        
                    local pve_scene_event_mark_str = readKey("pve_scene_event_mark_"..currentPveSceneID..sceneParam)
                    
                    if pve_scene_event_mark_str == "1" or 
                      executeMissionExt(mission_mould_plot, touch_off_mission_into_scene, ""..currentPveSceneID, nil, true, sceneParam, false) == false then
                        if executeMissionExt(mission_mould_tuition, touch_off_mission_into_scene, ""..currentPveSceneID, nil, true, sceneParam, false) == false then
                            local sceneData = dms.element(dms["pve_scene"], currentPveSceneID)
                            local placeView = zstring.split(dms.atos(sceneData,pve_scene.star_reward_id),",")
                            local rewardView = zstring.split(dms.atos(sceneData, pve_scene.reward_need_star),",")
                            local sceneDrawParam = "s"..currentPveSceneID
                            if zstring.tonumber(_ED.get_star_count[currentPveSceneID]) >= zstring.tonumber(rewardView[1]) then
                                if zstring.tonumber(_ED.star_reward_state[currentPveSceneID]) == 0 then
                                    sceneDrawParam = sceneDrawParam.."".."d"..0
                                end
                            end
                            if executeMissionExt(mission_mould_tuition, touch_off_mission_into_scene, ""..currentPveSceneID, nil, true, sceneDrawParam, false) == false then
                                executeNextEvent(nil, true)
                            end
                        end
                    else
                        writeKey("pve_scene_event_mark_"..currentPveSceneID..sceneParam, "1")
                    end
                    if missionIsOver() == false then
                        local windowLock = fwin:find("WindowLockClass")
                        if windowLock == nil then
                            fwin:open(WindowLock:new():init(), fwin._windows)
                        end
                    end
                end
                
                local pveSceneID = params._datas._pveSceneID
                if nil ~= pveSceneID then
                    startSceneEvent(pveSceneID)
                end
                
               return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        
        --直接进入到当前进度的普通副本npc界面(主要用于教学)
        local menu_show_duplicate_goto_npc_terminal = {
            _name = "menu_show_duplicate_goto_npc",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

                if __lua_project_id == __lua_project_warship_girl_a 
                or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
                or __lua_project_id == __lua_project_koone
                then
                    if dev_version >= 2002 then

                        _ED._current_seat_index = 1
                        
                        _ED._last_page_type = 1
                        state_machine.excute("shortcut_open_duplicate_window", 0, nil)
                    end
                end
               return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        
        -- 外界 战斗后回到之前界面
        local menu_show_duplicate_goto_last_view_terminal = {
            _name = "menu_show_duplicate_goto_last_view",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)            
                if true == _ED.user_is_level_up then
                    app.load("client.battle.BattleLevelUp")
                    local win = fwin:find("BattleLevelUpClass")
                    if nil ~= win then
                        fwin:close(win)
                    end
                    -- fwin:open(BattleLevelUp:new(), fwin._windows)
                    state_machine.excute("battle_level_up_window_open", 0, 0)
                    _ED.user_info.last_user_grade = _ED.user_info.user_grade
                end
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
                    local now_scene_count = 0
                    for i,v in pairs(_ED.scene_max_state) do
                        if tonumber(v) == -1 then
                            now_scene_count = now_scene_count + i
                            break
                        end
                    end
                    local now_hard_scene_count = 0
                    for i,v in pairs(_ED.scene_max_state) do
                        if i > 50 and tonumber(v) == -1 then
                            now_hard_scene_count = i
                            break
                        end
                    end
                    if tonumber(LDuplicateWindow._infoDatas._type) == 1 then
                        local scene_id = LDuplicateWindow._infoDatas._chapter
                        -- print("=======================",scene_id,_ED._now_scene_count,now_scene_count)
                        if _ED._now_scene_count ~= now_scene_count then
                            local open_scene_str = dms.string(dms["pve_scene"],tonumber(scene_id),pve_scene.open_scene) 
                            if open_scene_str ~= nil then                                
                                local open_scene_tab = zstring.split(open_scene_str , ",")
                                local next_sceneID = tonumber(open_scene_tab[1])
                                if next_sceneID == -1 or next_sceneID == nil then
                                    scene_id = LDuplicateWindow._infoDatas._chapter
                                else
                                    if missionIsOver() == true and checkGetLastSceneReward(scene_id) == true then
                                        _ED.is_open_get_last_scend_reward = true
                                    end
                                    scene_id = next_sceneID
                                end
                            end
                            _ED._now_scene_count = now_scene_count
                         end
                         
                        state_machine.excute("lduplicate_window_pve_quick_entrance", 0, 
                        {
                            _type    = LDuplicateWindow._infoDatas._type, 
                            _sceneId = scene_id
                        })                         
                    elseif tonumber(LDuplicateWindow._infoDatas._type) == 15 then
                        local scene_id = LDuplicateWindow._infoDatas._chapter
                        if _ED._now_hard_scene_count ~= now_hard_scene_count then
                            local _scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, 15)
                            for i, v in pairs(_scenes) do
                                local tempSceneId = dms.atoi(v, pve_scene.id)
                                if _ED.scene_current_state[tempSceneId] == nil
                                    or _ED.scene_current_state[tempSceneId] == ""
                                    or tonumber(_ED.scene_current_state[tempSceneId]) < 0 
                                    then
                                    scene_id = tempSceneId - 1
                                    break
                                end
                            end
                            _ED._now_hard_scene_count = now_hard_scene_count
                        end
                        state_machine.excute("lduplicate_window_pve_quick_entrance", 0, 
                        {
                            _type    = LDuplicateWindow._infoDatas._type, 
                            _sceneId = scene_id
                        })
                    else
                        local scene_id = LDuplicateWindow._infoDatas._chapter
                        if _ED._now_hard_scene_count ~= now_hard_scene_count then
                            local _scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, 1)
                            for i, v in pairs(_scenes) do
                                local tempSceneId = dms.atoi(v, pve_scene.id)
                                if _ED.scene_current_state[tempSceneId] == nil
                                    or _ED.scene_current_state[tempSceneId] == ""
                                    or tonumber(_ED.scene_current_state[tempSceneId]) < 0 
                                    then
                                    scene_id = tempSceneId - 1
                                    break
                                end
                            end
                            _ED._now_hard_scene_count = now_hard_scene_count
                        end
                        state_machine.excute("lduplicate_window_pve_quick_entrance", 0, 
                        {
                            _type    = LDuplicateWindow._infoDatas._type, 
                            _sceneId = scene_id
                        })
                    end
                    -- smFightingChange()
                    
                else
                    if tonumber(_ED.battleData.battle_init_type) == 9 or tonumber(_ED.battleData.battle_init_type) == 10 then

                        if true == is2002 then
                            -- _ED._current_scene_id = _ED._duplicate_current_scene_id
                    
                            -- _ED._current_seat_index = _ED._duplicate_current_seat_index
                            
                            -- _ED._last_page_type = 1
        
                            -- state_machine.unlock("menu_manager_change_to_page", 0, "")
                            -- state_machine.excute("shortcut_open_duplicate_hight_copy_window", 0, nil)
                            
                            _ED._current_scene_id = nil
                            _ED._current_seat_index = nil
                            _ED._last_page_type = nil
                            
                            local scene_id = _ED._duplicate_current_scene_id --场景id
                            local seat_index = _ED._duplicate_current_seat_index --攻打的npc位置
                            local scene_index =_ED._duplicate_current_scene_index --场景序号
                            local scene_type =_ED._duplicate_current_scene_type --场景类型
                            
                            local scene = PVESecondaryScene:new()
                            scene:init(scene_id, scene_type, scene_index, seat_index)
                            fwin:open(scene, fwin._view)
                        
                        else
                            state_machine.excute("menu_manager", 0, 
                                {
                                    _datas = {
                                        terminal_name = "menu_manager",     
                                        next_terminal_name = "menu_show_duplicate_hero",     
                                        current_button_name = "Button_mingjiang",            
                                        but_image = "Image_hight_copy",       
                                        terminal_state = 0, 
                                        isPressedActionEnabled = true
                                    }
                                }
                            )
                            state_machine.unlock("menu_manager_change_to_page", 0, "")
                            state_machine.excute("pve_daily_activity_copy_change_to_page", 0, 0)
                        
                        end
                    else
                        
                        -- 定位到副本
                        if true == is2002 then
                            _ED._current_scene_id = nil
                            _ED._current_seat_index = nil
                            _ED._last_page_type = nil
                            --state_machine.excute("shortcut_open_duplicate_window", 0, nil)
                            
                            local scene_id = _ED._duplicate_current_scene_id --场景id
                            local seat_index = _ED._duplicate_current_seat_index --攻打的npc位置
                            local scene_index =_ED._duplicate_current_scene_index --场景序号
                            local scene_type =_ED._duplicate_current_scene_type --场景类型
                            
                            -- 执行场景教学检查
                            state_machine.excute("menu_start_scene_event_execute_mission", 0, {
                                    _datas = {
                                        _pveSceneID = scene_id
                                    }
                                }
                            )
                            
							if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                                or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
								local tentType = dms.string(dms["pve_scene"], scene_id, pve_scene.scene_type)
								if tonumber(tentType) == 10 then
									app.load("client.duplicate.DuplicateController")
									local swin = fwin:find("DuplicateControllerClass")
									if nil == swin then
										fwin:open(DuplicateController:new(), fwin._view)
										state_machine.excute("duplicate_controller_manager", 0, 
											{
												_datas = {
													terminal_name = "duplicate_controller_manager",     
													next_terminal_name = "duplicate_select_hight_copy_panel",       
													current_button_name = "Button_putong",    
													but_image = "Image_copy",       
													terminal_state = 0, 
													isPressedActionEnabled = true
												}
											}
										)
									end	
								else
									local swin = fwin:find("PVESecondarySceneClass")
									-- 检查npc列表场景是否存在
									if nil == swin then
										local scene = PVESecondaryScene:new()
										scene:init(scene_id, scene_type, scene_index, seat_index)
										fwin:open(scene, fwin._view)
									end
								end
								
							else	
								local swin = fwin:find("PVESecondarySceneClass")
								-- 检查npc列表场景是否存在
								if nil == swin then
									local scene = PVESecondaryScene:new()
									scene:init(scene_id, scene_type, scene_index, seat_index)
									fwin:open(scene, fwin._view)
								end
							end
                            
                            
                        else
                            _ED._current_scene_id = _ED._duplicate_sceneID
                            _ED._current_seat_index = _ED._duplicate_npcIndex
                            _ED._last_page_type = 1
                        
                            state_machine.excute("menu_manager", 0, 
                                {
                                    _datas = {
                                        terminal_name = "menu_manager",     
                                        next_terminal_name = "menu_show_duplicate", 
                                        current_button_name = "Button_duplicate",
                                        but_image = "Image_duplicate",      
                                        terminal_state = 0, 
                                        isPressedActionEnabled = true
                                    }
                                }
                            )
                        end
                    
                    end
                end 
                
                -- 返回到叛军
                if _ED.rebel_army_mould_id ~= "" and _ED.rebel_army_mould_id ~= nil then
                    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                    else
                        local BetrayArmyPve = BetrayArmyNpcArrival:new()
                        BetrayArmyPve:init()
                        fwin:open(BetrayArmyPve, fwin._ui)
                    end
                end
               return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --打开副本界面
        local menu_show_duplicate_terminal = {
            _name = "menu_show_duplicate",
            _init = function (terminal) 

                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
                    app.load("client.landscape.duplicate.LDuplicateWindow")
                else
                    app.load("client.duplicate.DuplicateController")
                end
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --fwin:open(Duplicate:new(), fwin._view)
                -- fwin:open(PVEStage:new(), fwin._view)

                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
                    fwin:__hide(fwin._frameview)
                    state_machine.excute("lduplicate_window_manager", 0, "")

                else
                    fwin:open(DuplicateController:new(), fwin._view)
                    if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
                        or __lua_project_id == __lua_project_pokemon 
                        or __lua_project_id == __lua_project_rouge 
                        or __lua_project_id == __lua_project_warship_girl_b 
                        or __lua_project_id == __lua_project_yugioh
                        then 
                        state_machine.excute("duplicate_controller_manager", 0, 
                        {
                            _datas = {
                                terminal_name = "duplicate_controller_manager",     
                                next_terminal_name = "duplicate_controller_copy_page",       
                                current_button_name = "Button_ptfb_2",    
                                but_image = "Image_copy",       
                                terminal_state = 0, 
                                isPressedActionEnabled = true
                            }
                        })
                    else
                        state_machine.excute("duplicate_controller_manager", 0, 
                        {
                            _datas = {
                                terminal_name = "duplicate_controller_manager",     
                                next_terminal_name = "duplicate_controller_copy_page",       
                                current_button_name = "Button_putong",    
                                but_image = "Image_copy",       
                                terminal_state = 0, 
                                isPressedActionEnabled = true
                            }
                        })
                    
                    end
                    
                end
            
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --打开日常副本界面
        local menu_show_duplicate_everyday_terminal = {
            _name = "menu_show_duplicate_everyday",
            _init = function (terminal) 
                app.load("client.duplicate.DuplicateController")
                app.load("client.cells.utils.resources_icon_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
                    --龙虎门的是新的副本资源界面
                    fwin:__hide(fwin._frameview)
                    state_machine.excute("lduplicate_window_manager", 0, 4)--参数4为日常
                else
                    fwin:open(DuplicateController:new(), fwin._view)
                    state_machine.excute("duplicate_controller_manager", 0, 
                        {
                            _datas = {
                                terminal_name = "duplicate_controller_manager",     
                                next_terminal_name = "duplicate_select_daily_activity_copy_panel",      
                                current_button_name = "Button_richang",
                                but_image = "Image_daily_activity_copy",       
                                terminal_state = 0, 
                                isPressedActionEnabled = true
                            }
                        }
                    )
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --打开名将副本界面
        local menu_show_duplicate_hero_terminal = {
            _name = "menu_show_duplicate_hero",
            _init = function (terminal) 
                app.load("client.duplicate.DuplicateController")
                app.load("client.cells.utils.resources_icon_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
                    --龙虎门的是新的副本资源界面
                    fwin:__hide(fwin._frameview)
                    state_machine.excute("lduplicate_window_manager", 0, 3)--参数3为名将副本
                else
                    fwin:open(DuplicateController:new(), fwin._view)
                    state_machine.excute("duplicate_controller_manager", 0, 
                        {
                            _datas = {
                                terminal_name = "duplicate_controller_manager",     
                                next_terminal_name = "duplicate_select_hight_copy_panel",     
                                current_button_name = "Button_mingjiang",            
                                but_image = "Image_hight_copy",       
                                terminal_state = 0, 
                                isPressedActionEnabled = true
                            }
                        }
                    )
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --打开精英副本
        local menu_show_duplicate_abyss_terminal = {
            _name = "menu_show_duplicate_abyss",
            _init = function (terminal) 
                app.load("client.duplicate.DuplicateController")
                app.load("client.cells.utils.resources_icon_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
                    --龙虎门的是新的副本资源界面
                    fwin:__hide(fwin._frameview)
                    state_machine.excute("lduplicate_window_manager", 0,2 )--参数2为名将
                else
                   fwin:open(DuplicateController:new(), fwin._view)
                    
                    state_machine.excute("duplicate_controller_manager", 0, 
                    {
                        _datas = {
                            terminal_name = "duplicate_controller_manager",     
                            next_terminal_name = "duplicate_controller_elite_copy_page",       
                            current_button_name = "Button_jingyingbt",    
                            but_image = "Image_copy",       
                            terminal_state = 0, 
                            isPressedActionEnabled = true
                        }
                    })
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --打开征战的主界面
        local menu_show_campaign_terminal = {
            _name = "menu_show_campaign",
            _init = function (terminal) 
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    app.load("client.l_digital.campaign.Campaign")
                else
                    app.load("client.campaign.Campaign")
                end
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    state_machine.excute("campaign_window_open", 0, 0)
                elseif __lua_project_id == __lua_project_gragon_tiger_gate
                    then
					--武神台调用第1界面
					--残卷抢夺调用第2界面
					--罗刹道场调用第3界面
					--包子山调用第4界面
					--惩奸除恶调用第5界面
					--print("enter params",params)
                    local view = fwin:find("CampaignClass")
                    if view == nil then
    					local _Campaign=Campaign:CreateCampaign()
    					-- if params ~= 1 and params ~= 2 and params ~= 3 and params ~= 4 and params ~= 5 then--武神台
    					-- 	params=1
    					-- end	
    					--print("params===:",params)
    					_Campaign:initPages(1)
    					fwin:open(_Campaign, fwin._view)
                        local userinfo = EquipPlayerInfomation:new()
                        local info = fwin:open(userinfo,fwin._view)

                        fwin:__hide(fwin._frameview)

                        local se = cc.Sequence:create({cc.DelayTime:create(0.1), cc.CallFunc:create(function(sender)
                            if _Campaign ~= nil and _Campaign.addAnimation ~= nil then
                                _Campaign:addAnimation()
                            end
                        end)})
                        instance:runAction(se)
                    else
                        view:setVisible(true)
                    end
				else
					fwin:open(Campaign:new(), fwin._view)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local menu_button_hide_highlighted_all_terminal = {
            _name = "menu_button_hide_highlighted_all",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                local btnName = {"Button_activity","Button_home"}
                
                for i,v in pairs(btnName) do
                    local btn = ccui.Helper:seekWidgetByName(instance.roots[1], v)
                    if btn ~= nil then
                        btn:setHighlighted(false)
                    end
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        

        
        -- 打开包裹的主界面
        local menu_show_prop_terminal = {
            _name = "menu_show_prop",
            _init = function (terminal) 
                app.load("client.packs.prop.PropStorage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                    fwin:open(PropStorage:new(), fwin._background)
                    fwin:__hide(fwin._view)
                else
                    fwin:open(PropStorage:new(), fwin._view)
                end
                state_machine.excute("prop_storage_manager", 0, 
                    {
                        _datas = {
                            terminal_name = "Button_daoju",     
                            next_terminal_name = "prop_storage_chick_prop_storages",            
                            current_button_name = "Button_daoju",       
                            but_image = "",         
                            terminal_state = 0, 
                            isPressedActionEnabled = true
                        }
                    }
                )
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 打开商店的主界面
        local menu_show_shop_terminal = {
            _name = "menu_show_shop",
            _init = function (terminal) 
                app.load("client.shop.Shop")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_unlock_state_machine", 0, nil)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    if params._datas.shop_type == "shop" then
                        if funOpenDrawTip(114) then
                            state_machine.excute("menu_back_home_page", 0, "") 
                            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                                then
                                state_machine.excute("menu_clean_page_state", 0, "") 
                            end
                            return false
                        end
                    end
                end
                local _shop = Shop:new()
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                    if params._datas.shop_type == "zhaomu" then
                        _shop:init(1)
                    elseif params._datas.shop_type == "shop" then
                        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                            then
                            _shop:init(0,zstring.tonumber(params._datas.shop_page))
                        else
                            _shop:init()
                        end
                    end
                end
                fwin:open(_shop, fwin._view)
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                    if params._datas.shop_type == "zhaomu" then
                        state_machine.excute("shop_manager", 0, 
                        {
                            _datas = {
                                terminal_name = "shop_manager",     
                                next_terminal_name = "shop_ship_recruit",
                                current_button_name = "Button_tavern",  
                                but_image = "recruit",      
                                terminal_state = 0,
                                shop_type = "zhaomu",
                                isPressedActionEnabled = true
                            }
                        }
                    )
                    elseif params._datas.shop_type == "shop" then
                        state_machine.excute("shop_manager", 0, 
                            {
                                _datas = {
                                    terminal_name = "shop_manager",     
                                    next_terminal_name = "shop_prop_buy",
                                    current_button_name = "Button_props",  
                                    but_image = "prop",      
                                    terminal_state = 0, 
                                    shop_type = "shop",
                                    isPressedActionEnabled = false
                                }
                            }
                        )
                    end
                 elseif __lua_project_id == __lua_project_yugioh then
                    state_machine.excute("shop_manager", 0, 
                        {
                            _datas = {
                                terminal_name = "shop_manager",     
                                next_terminal_name = "shop_prop_buy",
                                current_button_name = "Button_props",  
                                but_image = "prop",      
                                terminal_state = 0, 
                                isPressedActionEnabled = true
                            }
                        }
                    )
                elseif  __lua_project_id == __lua_project_rouge then 
                    state_machine.excute("shop_manager", 0, 
                        {
                            _datas = {
                                terminal_name = "shop_manager",     
                                next_terminal_name = "shop_prop_buy",
                                current_button_name = "Button_props",  
                                but_image = "prop",      
                                terminal_state = 0, 
                                isPressedActionEnabled = true
                            }
                        }
                    )
                else
                    state_machine.excute("shop_manager", 0, 
                        {
                            _datas = {
                                terminal_name = "shop_manager",     
                                next_terminal_name = "shop_ship_recruit",
                                current_button_name = "Button_tavern",  
                                but_image = "recruit",      
                                terminal_state = 0, 
                                isPressedActionEnabled = true
                            }
                        }
                    )
                end
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then         --龙虎门项目控制
                    state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
                    state_machine.excute("home_hide_event", 0, "home_hide_event.")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 隐藏界面
        local menu_hide_event_terminal = {
            _name = "menu_hide_event",
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
        
        -- 隐藏界面
        local menu_show_event_terminal = {
            _name = "menu_show_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:onShow()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local show_activity_first_recharge_popup_terminal = {
            _name = "show_activity_first_recharge_popup",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.active_activity[4] ~= nil and _ED.active_activity[4]~="" and _ED.active_activity[4].activity_id == "0" then
                    app.load("client.activity.ActivityFirstRechargePopup")
                    fwin:open(ActivityFirstRechargePopup:new(), fwin._ui)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        
        local menu_change_button_state_terminal = {
            _name = "menu_change_button_state",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local buttonName = params._datas.buttonName
                
                local btnName = {"Button_home","Button_line-uo","Button_activity","Button_warehouse","Button_shop","Button_duplicate"}
                
                -- for i,v in pairs(btnName) do
                    -- local btn = ccui.Helper:seekWidgetByName(instance.roots[1], v)
                    -- if btn ~= nil then
                        -- if v == buttonName  then
                            -- btn:setHighlighted(true)
                        -- else
                            -- btn:setHighlighted(false)
                        -- end
                    -- end
                -- end
                
                if buttonName == btnName[1] then
                    state_machine.excute("menu_manager", 0, {_datas = {
                        terminal_name = "menu_manager",     
                        next_terminal_name = "menu_manager",    
                        current_button_name = "Button_home",    
                        but_image = "Image_home",   
                        terminal_state = 0, 
                        isPressedActionEnabled = true
                    }})
                elseif buttonName == btnName[5] then
                    state_machine.excute("menu_manager", 0, {_datas = {
                        terminal_name = "menu_manager",     
                        next_terminal_name = "menu_manager",    
                        current_button_name = "Button_shop",    
                        but_image = "Image_shop",   
                        terminal_state = 0, 
                        isPressedActionEnabled = true
                    }})
                
                
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 冒险与挖矿的独立状态机
        -- 冒险
        local menu_adventure_avg_terminal = {
            _name = "menu_adventure_avg",
            _init = function (terminal)
                app.load("client.adventure.duplicate.AdventureDuplicate")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureDuplicate:new():init(), fwin._view)
                fwin:open(Home:new(), fwin._view)
                state_machine.unlock("menu_manager_change_to_page", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 挖矿
        local menu_adventure_mining_terminal = {
            _name = "menu_adventure_mining",
            _init = function (terminal)
                app.load("client.adventure.campaign.mine.AdventureMineManager")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
				if funOpenConditionJudge(51) == false then
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 51, fun_open_condition.tip_info))
					return
				end
                --fwin:open(AdventureMineManager:new():init(), fwin._view)
                state_machine.excute("adventure_mine_manager_open",0,false)
                state_machine.unlock("menu_manager_change_to_page", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 竞技场
        local menu_adventure_arena_terminal = {
            _name = "menu_adventure_arena",
            _init = function (terminal)
                app.load("client.adventure.campaign.arena.AdventureArenaManager")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if funOpenConditionJudge(52) == false then
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 52, fun_open_condition.tip_info))
					return
				end
                fwin:open(AdventureArenaManager:new():init(), fwin._view)
                state_machine.unlock("menu_manager_change_to_page", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 招募
        local menu_adventure_recruit_terminal = {
            _name = "menu_adventure_recruit",
            _init = function (terminal)
                app.load("client.adventure.shop.AdventureRecruit")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if funOpenConditionJudge(53) == false then
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 53, fun_open_condition.tip_info))
					return
				end
                fwin:open(AdventureRecruit:new():init(), fwin._view)
                state_machine.unlock("menu_manager_change_to_page", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 佣兵
        local menu_adventure_mercenary_terminal = {
            _name = "menu_adventure_mercenary",
            _init = function (terminal)
                app.load("client.adventure.mercenary.AdventureMercenary")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if funOpenConditionJudge(54) == false then
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 54, fun_open_condition.tip_info))
					return
				end
                state_machine.excute("menu_clean_page_state", 0,"")
                fwin:open(AdventureMercenary:new():init(), fwin._view)
                state_machine.unlock("menu_manager_change_to_page", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 商店
        local menu_adventure_shop_terminal = {
            _name = "menu_adventure_shop",
            _init = function (terminal)
                app.load("client.adventure.shop.AdventureShop")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if funOpenConditionJudge(60) == false then
                    TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 60, fun_open_condition.tip_info))
                    return
                end
                
                state_machine.excute("menu_clean_page_state", 0,"")
                fwin:open(AdventureShop:new():init(), fwin._view)
                state_machine.unlock("menu_manager_change_to_page", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 开启选中按钮的点击响应
        local menu_adventure_open_button_terminal = {
            _name = "menu_adventure_open_button",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local menu_manager_terminal = state_machine.find("menu_manager")
                if menu_manager_terminal ~= nil then
                    menu_manager_terminal.select_button:setTouchEnabled(true)
                else
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 挖矿项目功能锁
        local menu_adventure_update_open_condition_terminal = {
            _name = "menu_adventure_update_open_condition",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--挖矿
				if funOpenConditionJudge(51) == true then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_suo_3"):removeAllChildren(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_beijing_3"):setColor(cc.c3b(255, 255, 255))
				else
					local ball = cc.Sprite:create("images/ui/icon/icon_global_lock.png")
					ball:setAnchorPoint(cc.p(0.5, 0.5))
					ball:setPosition(cc.p(ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_suo_3"):getContentSize().width/2 , ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_suo_3"):getContentSize().height/2))
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_suo_3"):addChild(ball)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_beijing_3"):setColor(cc.c3b(150, 150, 150))
				end
				--竞技场
				if funOpenConditionJudge(52) == true then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_suo_1"):removeAllChildren(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_beijing_1"):setColor(cc.c3b(255, 255, 255))
				else
					local ball = cc.Sprite:create("images/ui/icon/icon_global_lock.png")
					ball:setAnchorPoint(cc.p(0.5, 0.5))
					ball:setPosition(cc.p(ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_suo_1"):getContentSize().width/2 , ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_suo_1"):getContentSize().height/2))
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_suo_1"):addChild(ball)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_beijing_1"):setColor(cc.c3b(150, 150, 150))
				end
				--招募
				if funOpenConditionJudge(53) == true then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_suo_2"):removeAllChildren(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_beijing_2"):setColor(cc.c3b(255, 255, 255))
				else
					local ball = cc.Sprite:create("images/ui/icon/icon_global_lock.png")
					ball:setAnchorPoint(cc.p(0.5, 0.5))
					ball:setPosition(cc.p(ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_suo_2"):getContentSize().width/2 , ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_suo_2"):getContentSize().height/2))
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_suo_2"):addChild(ball)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_beijing_2"):setColor(cc.c3b(150, 150, 150))
				end
				--佣兵
				if funOpenConditionJudge(54) == true then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_suo_5"):removeAllChildren(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_beijing_5"):setColor(cc.c3b(255, 255, 255))
				else
					local ball = cc.Sprite:create("images/ui/icon/icon_global_lock.png")
					ball:setAnchorPoint(cc.p(0.5, 0.5))
					ball:setPosition(cc.p(ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_suo_5"):getContentSize().width/2 , ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_suo_5"):getContentSize().height/2))
					ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_suo_5"):addChild(ball)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_beijing_5"):setColor(cc.c3b(150, 150, 150))
				end
                --商店
                if funOpenConditionJudge(60) == true then
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_suo_6"):removeAllChildren(true)
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Image_beijing_6"):setColor(cc.c3b(255, 255, 255))
                else
                    local ball = cc.Sprite:create("images/ui/icon/icon_global_lock.png")
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_suo_6"):getContentSize().width/2 , ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_suo_6"):getContentSize().height/2))
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_suo_6"):addChild(ball)
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Image_beijing_6"):setColor(cc.c3b(150, 150, 150))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
                        -- 主界面偷师学艺按钮
        local menu_show_skills_school_terminal = {
            _name = "menu_show_skills_school",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _level = tonumber(dms.string(dms["fun_open_condition"],54, fun_open_condition.level))
                local user_level = tonumber(_ED.user_info.user_grade)
                if user_level >= _level then
                    app.load("client.learingskills.LearingSkillsDevelop")
                    state_machine.excute("learing_skills_develop_open",0,{1,1})
                else
                    state_machine.excute("menu_clean_page_state", 0, "")
                    local text = dms.string(dms["fun_open_condition"],54, fun_open_condition.tip_info)
                    TipDlg.drawTextDailog(text)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
                                -- 主界面等级奖励按钮
        local menu_show_level_packs_terminal = {
            _name = "menu_show_level_packs",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                app.load("client.home.LevelPacks")
                state_machine.excute("level_packs_open",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --登录弹窗
        local menu_window_login_popup_banner_mission_terminal = {
            _name = "menu_window_login_popup_banner_mission",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- if _ED.login_popup_banner == false then
                --     return
                -- end    
                -- if terminal.isOpend ~= nil or nil == params then 
                --     --本次运行时已经弹出过
                --     if params ~= true then
                --         terminal.isOpend = nil
                --     end
                --     _ED.login_popup_banner = false
                --     return false
                -- end
                -- if fwin:find("LoginClass") ~= nil then
                --     _ED.login_popup_banner = false
                --     return false
                -- end
                -- -- if missionIsOver() == false then
                --     -- _ED.login_popup_banner = false
                --     -- return false
                -- -- end
                
                -- --只有第一次进入游戏的时候 
                -- if terminal.isOpend == nil then 
                --     terminal.isOpend = true
                --     _ED.login_popup_banner = false
                -- end

                -- local result = {}
                -- if _ED.activity_push_banner_info ~= nil then
                --     for k,v in pairs(_ED.activity_push_banner_info) do
                --         table.insert(result, v)
                --     end
                --     _ED.activity_push_banner_info = nil
                --     local function sortFun( a, b )
                --         return a.activity_priority > b.activity_priority
                --     end
                --     table.sort(result, sortFun)
                --     local isHavePush = false
                --     for k,v in pairs(result) do
                --         local fileName = "images/ui/activity/activity_poster_"..v.activity_pic_id..".png"
                --         if true == cc.FileUtils:getInstance():isFileExist(fileName) then
                --             isHavePush = true
                --             break
                --         end
                --     end
                --     app.load("client.l_digital.activity.wonderful.SmActivityVipPush")
                --     if isHavePush == true then
                --         state_machine.excute("sm_activity_vip_push_window_open", 0, result)
                --     else
                --         state_machine.excute("sm_activity_vip_push_window_close", 0, nil)
                --     end
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --登录弹窗
        local menu_window_login_popup_banner_terminal = {
            _name = "menu_window_login_popup_banner",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.login_popup_banner == false then
                    return
                end    
                if terminal.isOpend ~= nil or nil == params then 
                    --本次运行时已经弹出过
                    if params ~= true then
                        terminal.isOpend = nil
                    end
                    _ED.login_popup_banner = false
                    return false
                end
                if fwin:find("LoginClass") ~= nil then
                    _ED.login_popup_banner = false
                    return false
                end

                if missionIsOver() == false then
                    -- _ED.login_popup_banner = false
                    return false
                end
                
                --只有第一次进入游戏的时候 
                if terminal.isOpend == nil then 
                    terminal.isOpend = true
                    _ED.login_popup_banner = false
                end

                --打开绑定谷歌账号界面
                -- app.load("client.utils.BandingGooglePlay")
                -- state_machine.excute("sm_binding_google_play_window_open", 0, "")
                local moveLofinType = cc.UserDefault:getInstance():getStringForKey("moveLofinType","0")
                if __lua_project_id == __lua_project_l_digital and tonumber(moveLofinType) == 3 and _ED.bind_google_paly_info and tonumber(_ED.bind_google_paly_info.bind_reword_state) == 0 
                    and cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
                    app.load("client.utils.BandingGooglePlay")
                    state_machine.excute("sm_binding_google_play_window_open", 0, "")
                end
                local function pushCallback() 
                    local result = {}
                    if _ED.activity_push_banner_info ~= nil then
                        for k,v in pairs(_ED.activity_push_banner_info) do
                            table.insert(result, v)
                        end
                        _ED.activity_push_banner_info = nil
                        local function sortFun( a, b )
                            return a.activity_priority > b.activity_priority
                        end
                        table.sort(result, sortFun)
                        local isHavePush = false
                        for k,v in pairs(result) do
                            local fileName = "images/ui/activity/activity_poster_"..v.activity_pic_id..".png"
                            if true == cc.FileUtils:getInstance():isFileExist(fileName) then
                                isHavePush = true
                                break
                            end     
                        end
                        app.load("client.l_digital.activity.wonderful.SmActivityVipPush")
                        if isHavePush == true then
                            state_machine.excute("sm_activity_vip_push_window_open", 0, result)
                        --大R推送
                            local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.ActivityVipPush)
                            if fun_is_open == true then
                                state_machine.excute("activity_r_vip_push_window_open", 0, {type=1})
                            end
                        else
                            state_machine.excute("sm_activity_vip_push_window_close", 0, nil)
                        end
                    end
                end
               
                local openIdx = 0  -- 当前弹框下标
                local openList = {
                  "SmGotoShopWindow",   -- 下包跳转商店页
                  "SmGotoFansWindow",   -- 粉丝页跳转功能
                  "OtherPopWindow",     -- 其他弹窗
                }   -- 弹框列表
                local function popupCallback()    
                    local openFlag = false
                    openIdx = openIdx + 1       
                    if openList[openIdx] == "SmGotoShopWindow" then -- 下包跳转商店页功能判断
                        local rechargeState = GetRechargeState()    
                        local skipState = readKey("goto_shop_page_push_skip") -- 跳过:1
                        if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_naruto then 
                            -- DB和HY重置跳过
                            skipState = readKey("go_store_page_push_skip")
                        end
                        local isNotSkip = skipState ~= nil and (skipState == "" or (skipState ~= "" and tostring(skipState) ~= "1"))
                        if getGotoShopFuncOpenState() and _ED.push_goto_shop_page_url ~= nil and _ED.push_goto_shop_page_url ~= "" and rechargeState == 1 and isNotSkip then 
                            -- 打开跳转页
                            openFlag = true 
                            app.load("client.activity.wonderful.SmGotoShopWindow")
                            state_machine.excute("sm_goto_shop_window_open", 0, {closeCallback = popupCallback})
                        end
                    elseif openList[openIdx] == "SmGotoFansWindow" then -- 粉丝页跳转功能判断
                        if GetProjectFunctionIsOpen(ProjectFunctionEnum.FansPagePopup) then 
                            -- 打开粉丝跳转页
                            openFlag = true 
                            app.load("client.activity.wonderful.SmGotoFansWindow")
                            state_machine.excute("sm_goto_fans_window_open", 0, {closeCallback = popupCallback})
                        end
                    elseif openList[openIdx] == "OtherPopWindow" then   -- 其他弹窗
                        openFlag = true 
                        pushCallback() 
                    end
                    if openFlag == false and openIdx <= #openList then 
                        popupCallback()
                    end
                end   
                requetRechageState(popupCallback)
                -- local t = state_machine.find("menu_window_login_popup_banner_open", 0, 0)
                -- t.index = 1
                -- t.maxCount = 1
                -- state_machine.excute("menu_window_login_popup_banner_open", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --登录弹窗
        local menu_window_login_popup_banner_open_terminal = {
            _name = "menu_window_login_popup_banner_open",
            _init = function (terminal)
                app.load("client.l_digital.activity.wonderful.SmActivityVipPush")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if true then
                    return
                end
                -- local maxCount = terminal.maxCount -- 最大弹窗数量
                local nCount = dms.count(dms["load_popup_interface"])
                local server_date = os.date("%x", _ED.system_time)
                -- for i, v in pairs(dms["load_popup_interface"]) do
                if terminal.index == nil or terminal.maxCount == nil or terminal.maxCount <= 0 then
                    return false
                end
                for i = terminal.index, nCount do
                    local v = dms.element(dms["load_popup_interface"], i)
                    terminal.index = i + 1
                    local notification_type = dms.atoi(v, load_popup_interface.notification_type)
                    local addition_png = dms.atos(v, load_popup_interface.addition_png)
                    local notification_param = dms.atos(v, load_popup_interface.notification_param)
                    local notification_state = dms.atoi(v, load_popup_interface.notification_state)
                    local tracking = dms.atoi(v, load_popup_interface.notification_state)
                    if notification_state == 1 then
                        if 0 == notification_type then
                            -- 预告
                            if fwin:find("SmActivityVipPushClass") == nil then
                                local save_date = cc.UserDefault:getInstance():getStringForKey(getKey("notification_popup_windows_" .. notification_type), "")
                                if save_date ~= server_date then
                                    state_machine.excute("sm_activity_vip_push_window_open", 0, {notification_type, addition_png, tracking, terminal.maxCount - 10})
                                    -- terminal.maxCount = terminal.maxCount - 1
                                    return true
                                end
                            end
                        -- elseif 1 == notification_type then
                            
                        -- elseif 2 == notification_type then
                            
                        -- elseif 3 == notification_type then
                            
                        -- elseif 4 == notification_type then
                        --     -- 2充

                        -- elseif 5 == notification_type then
                        --     -- 月卡
                            
                        -- elseif 6 == notification_type then
                        --     -- VIP礼包
                        --     if fwin:find("SmActivityVipPushClass") == nil then
                        --         local save_date = cc.UserDefault:getInstance():getStringForKey(getKey("notification_popup_windows_" .. notification_type), "")
                        --         if save_date ~= server_date then
                        --             notification_param = zstring.split(notification_param, ",")
                        --             local needVipLevel = zstring.tonumber(notification_param[1])
                        --             local vipLevel = zstring.tonumber(notification_param[2])
                        --             if needVipLevel == zstring.tonumber(_ED.user_info.vip_level) then
                        --                 app.load("client.l_digital.activity.wonderful.SmActivityVipPush")
                        --                 state_machine.excute("sm_activity_vip_push_window_open", 0, {notification_type, addition_png, tracking, terminal.maxCount - 10})
                        --                 -- terminal.maxCount = terminal.maxCount - 1
                        --                 return true
                        --             end
                        --         end
                        --     end
                        elseif -1 == notification_type then
                            --自动签到
                            if fwin:find("SmCheckInInfoWindowClass") == nil then
                                app.load("client.l_digital.activity.wonderful.SmCheckInInfoWindow")
                                -- server_date = _ED.system_time + (os.time() - _ED.native_time)
                                -- server_date = os.date("*t", zstring.tonumber(server_date) - _ED.GTM_Time)
                                -- local save_date = cc.UserDefault:getInstance():getStringForKey(getKey("notification_popup_windows_" .. notification_type))
                                -- save_date = os.date("*t", zstring.tonumber(save_date))
                                -- if tonumber(save_date.day) ~= tonumber(server_date.day) then
                                    if _ED.active_activity ~= nil 
                                        and _ED.active_activity[38] ~= nil
                                        then
                                        local activityInfo = _ED.active_activity[38].activity_Info[tonumber(_ED.active_activity[38].activity_login_day)]
                                        if activityInfo ~= nil 
                                            and zstring.tonumber(activityInfo.activityInfo_isReward) == 0
                                            then
                                            state_machine.excute("sm_check_in_info_window_window_open", 0, {notification_type, addition_png, tracking, terminal.maxCount - 10})
                                            return true
                                        end
                                    end
                                    -- terminal.maxCount = terminal.maxCount - 1
                                -- end
                            end
                        else
                            --各种活动
                            if fwin:find("SmActivityVipPushClass") == nil then
                                if _ED.active_activity[notification_type] ~= nil then
                                    local save_date = cc.UserDefault:getInstance():getStringForKey(getKey("notification_popup_windows_" .. notification_type), "")
                                    if save_date ~= server_date then
                                        state_machine.excute("sm_activity_vip_push_window_open", 0, {notification_type, addition_png, tracking, terminal.maxCount - 10})
                                        -- terminal.maxCount = terminal.maxCount - 1
                                        return true
                                    end
                                end
                            end
                        end
                        if terminal.maxCount <= 0 then
                            _ED.login_popup_banner = false
                            break
                        end
                    end
                end
                return false
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(menu_change_button_state_terminal)
        state_machine.add(menu_start_scene_event_execute_mission_terminal)
        state_machine.add(menu_show_duplicate_goto_last_view_terminal)
        state_machine.add(menu_show_duplicate_goto_npc_terminal)
        state_machine.add(show_activity_first_recharge_popup_terminal)
        state_machine.add(menu_button_hide_highlighted_all_terminal)
        state_machine.add(menu_manager_terminal)
        state_machine.add(menu_manager_change_to_page_terminal)
        state_machine.add(menu_clean_page_state_terminal)
        state_machine.add(menu_clean_page_state_campaign_terminal)
        state_machine.add(menu_show_home_page_terminal)
        state_machine.add(menu_back_home_page_terminal)
        state_machine.add(menu_show_formation_terminal)
        state_machine.add(menu_show_duplicate_terminal)
        state_machine.add(menu_show_duplicate_everyday_terminal)
        state_machine.add(menu_show_duplicate_hero_terminal)
        state_machine.add(menu_show_duplicate_abyss_terminal)
        state_machine.add(menu_show_campaign_terminal)
        state_machine.add(menu_show_prop_terminal)
        state_machine.add(menu_show_shop_terminal)
        state_machine.add(menu_show_event_terminal)
        state_machine.add(menu_hide_event_terminal)
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            state_machine.add(menu_show_skills_school_terminal)
            state_machine.add(menu_show_level_packs_terminal)
        end
        if __lua_project_id == __lua_project_adventure then
            state_machine.add(menu_adventure_avg_terminal)
            state_machine.add(menu_adventure_mining_terminal)
            state_machine.add(menu_adventure_arena_terminal)
            state_machine.add(menu_adventure_recruit_terminal)
            state_machine.add(menu_adventure_mercenary_terminal)
            state_machine.add(menu_adventure_shop_terminal)
			state_machine.add(menu_clean_page_state_for_streng_terminal)	
			state_machine.add(menu_adventure_update_open_condition_terminal)
            state_machine.add(menu_adventure_open_button_terminal)                
        end
        if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
            or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
             state_machine.add(menu_adventure_open_button_terminal)                
        end
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
            then
            state_machine.add(menu_window_login_popup_banner_terminal)
            state_machine.add(menu_window_login_popup_banner_mission_terminal)
            state_machine.add(menu_window_login_popup_banner_open_terminal)
        end
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_menu_terminal()
end

function Menu:init(execute_mission)
    self._execute_login_game_mission = execute_mission or false
    return self
end

function Menu:onEnterTransitionFinish()
    -- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    -- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.imageLoaded, self)
    local csbMenu = csb.createNode("home/home.csb")
    local root = csbMenu:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbMenu)

    local action = csb.createTimeline("home/home.csb")
    csbMenu:runAction(action)
    self.action = action

    if __lua_project_id == __lua_project_adventure then
		
		state_machine.excute("menu_adventure_update_open_condition", 0, nil)
        --打开消息推送
--        --fwin:open(PushInfo:new(), fwin._taskbar)
        -- 大地图
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_daditu"),       nil, 
        {
            terminal_name = "menu_manager",     
            next_terminal_name = "menu_show_home_page", 
            current_button_name = "Button_daditu",
            but_image = "Image_daditu",         
            terminal_state = 0, 
            isPressedActionEnabled = false
        }, 
        nil, 0)

        local maoxianButton = ccui.Helper:seekWidgetByName(root, "Button_maoxian")
        -- 冒险
        fwin:addTouchEventListener(maoxianButton,       nil, 
        {
            terminal_name = "menu_manager",     
            next_terminal_name = "menu_adventure_avg", 
            -- terminal_name = "menu_adventure_avg",  
            current_button_name = "Button_maoxian",
            but_image = "Image_beijing_4",
            animation_name = "Panel_maoxian",         
            terminal_state = 0, 
            isPressedActionEnabled = false
        }, 
        nil, 0)
        --定时器获取冒险事件
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_adventure_home_event",
        _widget = maoxianButton,
        _invoke = nil,
        _interval = 60,})
    
          
        -- 挖矿
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wakuang"),       nil, 
        {
            terminal_name = "menu_manager",     
            next_terminal_name = "menu_adventure_mining", 
            -- terminal_name = "menu_adventure_mining",   
            current_button_name = "Button_wakuang",
            but_image = "Image_beijing_3",
            animation_name = "Panel_wakuang",         
            terminal_state = 0, 
			openId = 51,
            isPressedActionEnabled = false
        }, 
        nil, 0)
		
		if __lua_project_id == __lua_project_adventure then
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_adventure_mining",
                _widget = ccui.Helper:seekWidgetByName(root, "Button_wakuang"),
                _invoke = nil,
				_isHome = true,
                _interval = 0.5,})
		end
        
        -- 竞技场
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jingjichang"),       nil, 
        {
            terminal_name = "menu_manager",     
            next_terminal_name = "menu_adventure_arena", 
            current_button_name = "Button_jingjichang",
            but_image = "Image_beijing_1",
            animation_name = "Panel_jingjichang",         
            terminal_state = 0, 
			openId = 52,
            isPressedActionEnabled = false
        }, 
        nil, 0)
        
        -- 招募
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhaomu"),       nil, 
        {
            terminal_name = "menu_manager",     
            next_terminal_name = "menu_adventure_recruit", 
            current_button_name = "Button_zhaomu",
            but_image = "Image_beijing_2", 
            animation_name = "Panel_zhaomu",        
            terminal_state = 0, 
			openId = 53,
            isPressedActionEnabled = false
        }, 
        nil, 0)
		
		--这个地方不要求做了
		-- if __lua_project_id == __lua_project_adventure then
			-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_adventure_home_zhaomu",
                -- _widget = ccui.Helper:seekWidgetByName(root, "Button_zhaomu"),
                -- _invoke = nil,
                -- _interval = 0.8,})
		-- end
        
        -- 佣兵 
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yongbing"),       nil, 
        {
            terminal_name = "menu_manager",     
            next_terminal_name = "menu_adventure_mercenary", 
            current_button_name = "Button_yongbing",
            but_image = "Image_beijing_5",  
            animation_name = "Panel_yongbing",       
            terminal_state = 0, 
			openId = 54,
            isPressedActionEnabled = false
        }, 
        nil, 0)

        --商店
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shangdian"),       nil, 
        {
            terminal_name = "menu_manager",     
            next_terminal_name = "menu_adventure_shop", 
            current_button_name = "Button_shangdian",
            but_image = "Image_beijing_6",  
            animation_name = "Panel_shangdian",       
            terminal_state = 0, 
            openId = 60,
            isPressedActionEnabled = false
        }, 
        nil, 0)
        app.load("client.adventure.chat.AdventureChatHomeView")
        if fwin:find("AdventureChatHomeView") == nil then
            local cell = AdventureChatHomeView:new()
            fwin:open(cell,fwin._dialog)
        end
	
		if __lua_project_id == __lua_project_adventure then
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_adventure_mercenary_update",
                _widget = ccui.Helper:seekWidgetByName(root, "Button_yongbing"),
                _invoke = nil,
                _interval = 0.5,})
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_vip_package",
                _widget = ccui.Helper:seekWidgetByName(root, "Button_shangdian"),
                _invoke = nil,
                _interval = 1,})
        end
        
        if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
        and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
        and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
            handlePlatformRequest(0, CC_INITIALIZE_RECHARGE_PARAM, "0")
        end
        
        app.load("client.player.UserInformationHeroStorage")
        fwin:open(UserInformationHeroStorage:new(), fwin._windows)

        self._is_onenter = true
    else
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_home"),       nil, 
        {
            terminal_name = "menu_manager",     
            next_terminal_name = "menu_show_home_page",     
            current_button_name = "Button_home",
            but_image = "Image_home",       
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)
        
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
        else
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_line-uo"),    nil, 
            {
                terminal_name = "menu_manager",     
                next_terminal_name = "menu_show_formation",     
                current_button_name = "Button_line-uo",     
                but_image = "Image_line-uo",    
                _touch_type = "menu",
                terminal_state = 0, 
                isPressedActionEnabled = true
            }, 
            nil, 0)
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_all",
                _widget = ccui.Helper:seekWidgetByName(root, "Button_line-uo"),
                _invoke = nil,
                _interval = 0.5,})  
        end
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
        else
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_duplicate"),  nil, 
            {
                terminal_name = "menu_manager",     
                next_terminal_name = "menu_show_duplicate",     
                current_button_name = "Button_duplicate",   
                but_image = "Image_duplicate",  
                terminal_state = 0, 
                isPressedActionEnabled = true
            }, 
            nil, 0)
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_battle_all",
                _widget = ccui.Helper:seekWidgetByName(root, "Button_duplicate"),
                _invoke = nil,
                _interval = 0.5,})  
        end
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
        else    
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_activity"),   nil, 
            {
                terminal_name = "menu_manager",     
                next_terminal_name = "menu_show_campaign",      
                current_button_name = "Button_activity",        
                but_image = "Image_activity",   
                terminal_state = 0, 
                isPressedActionEnabled = true
            }, 
            nil, 0)
            _ED._is_recharge_push_expedition = false
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_expedition_all",
                _widget = ccui.Helper:seekWidgetByName(root, "Button_activity"),
                _invoke = nil,
                _interval = 0.5,})  
        end
        
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_warehouse"),  nil, 
        {
            terminal_name = "menu_manager",     
            next_terminal_name = "menu_show_prop",          
            current_button_name = "Button_warehouse",   
            but_image = "Image_warehouse",  
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)
        
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
        else
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shop"),       nil, 
            {
                terminal_name = "menu_manager",     
                next_terminal_name = "menu_show_shop",          
                current_button_name = "Button_shop",        
                but_image = "Image_shop",       
                terminal_state = 0, 
                isPressedActionEnabled = true
            }, 
            nil, 0)
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_shop_all",
            _widget = ccui.Helper:seekWidgetByName(root, "Button_shop"),
            _invoke = nil,
            _interval = 0.5,})  
        end
        
        self._is_onenter = true

        if missionIsOver() == false then
            local windowLock = fwin:find("WindowLockClass")
            if windowLock == nil then
                fwin:open(WindowLock:new():init(), fwin._windows)
            end
        end
        
        app.load("client.chat.ChatHomeView")
        if fwin:find("ChatHomeViewClass") == nil then
            local cell = ChatHomeView:new()
            fwin:open(cell,fwin._dialog)
        end
        -- cell:setPosition(cc.p(530,950))
        if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
            or __lua_project_id == __lua_project_warship_girl_b 
            or __lua_project_id == __lua_project_pokemon 
            or __lua_project_id == __lua_project_rouge
            then 
            --数码弹出活动推送界面
            app.load("client.activity.ActivityPushDialog")
            state_machine.excute("activity_push_goto_open",0,0)
        end
        
        if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
        and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
        and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
            handlePlatformRequest(0, CC_INITIALIZE_RECHARGE_PARAM, "0")
        end

        local iphoneData = {
            {
                _png = {"images/ui/home/home.png"}, 
                _plist = {"images/ui/home/home.plist"}
            }
        }

        local otherPlatformData = {
            {
                _png = {"images/ui/home/home.png"}, 
                _plist = {"images/ui/home/home.plist"}
            },
            {
                _png = {"images/ui/play/wonderful_activity/wonderful_he_1.png"}, 
                _plist = {"images/ui/play/wonderful_activity/wonderful_he_1.plist"}
            },
            {
                _png = {"images/ui/play/wonderful_activity/wonderful_he_2.png"}, 
                _plist = {"images/ui/play/wonderful_activity/wonderful_he_2.plist"}
            }
        }
            

        local plistData = otherPlatformData
        if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE 
            or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD 
            or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_MAC then
                plistData = iphoneData
        end

        Loading.loading(
            { 
                _pic = {}, 
                _plist = plistData, 
                _ui = {}
            },
            nil,
        nil) 
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        --添加获取网络强度和网络延时的请求
        -- state_machine.excute("platform_get_signal_strength_and_network_delay_time_ms", 0, nil)
        --固定时间推送
        state_machine.excute("platform_push_fixed_request_terminal", 0, nil)
    else
        app.load("client.chat.ChatHomeView")
        if fwin:find("ChatHomeViewClass") == nil then
            local cell = ChatHomeView:new()
            fwin:open(cell,fwin._dialog)
        end
    end
end

function Menu:onHide()
    for i, v in pairs(self.roots) do
        v:setVisible(false)
    end
end

function Menu:onShow()
    for i, v in pairs(self.roots) do
        v:setVisible(true)
    end
end

function Menu:onUpdate(dt)
    if self._is_onenter == false then
        return
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto
        then
        if (os.time() - self.keepAcliveInterval) > 120 
            or (zstring.tonumber(_ED.user_info.max_user_food) > 0
            and zstring.tonumber(_ED.user_info.user_food) < zstring.tonumber(_ED.user_info.max_user_food)
            and (os.time() + _ED.time_add_or_sub) >= _ED._next_energy_recover_time/1000)
            then
            self.keepAcliveInterval = os.time()
            local function responseKeepAliveCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                end             
            end
            NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, responseKeepAliveCallback,-1)
        end
        -- TODO 减少进入游戏前端向后端请求的次数
        -- local current_time = os.time()
        -- if math.abs(current_time - self._base_client_time) >= 60 then
        --     local function respondCallBack(response)
        --         if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    
        --         end
        --     end
        --     NetworkManager:register(protocol_command.verify_system_time.code, nil, nil, nil, self, respondCallBack, false, nil)
        -- end
        -- self._base_client_time = current_time
    end
    if self._is_running_state  == 0 then
        
    else
        if self._is_running_state == 1 then
            if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            else
                if self.action ~= nil then 
                    self.action:gotoFrameAndPlay(0, self.action:getDuration(), false)
                    self.action = nil
                end
            end
            if (os.time() - self.keepAcliveInterval) > 180 then
                self.keepAcliveInterval = os.time()
                local function responseKeepAliveCallback(response)
                    local str = nil
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    
                        for i, v in pairs(_ED.send_information) do
                            str = v.information_content
                        end
                        if str ~= nil then
                            state_machine.excute("push_infomation_home", 0, nil)
                        end
                    end             
                end
                NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, responseKeepAliveCallback,-1)
            elseif (os.time() - self.keepAcliveInterval) == 8 then
                if fwin:find("PushInfoClass")~= nil then 
                    state_machine.excute("close_push_infomation_home", 0, nil)
                end
            end

            if __lua_project_id == __lua_project_adventure then
                if  _ED.adventure_create_character == false then
                    if self._execute_login_game_mission == true then
                        if executeMissionExt(mission_mould_tuition, nil, nil, nil, true, "l".._ED.user_info.user_grade.."e".._ED.user_info.user_experience, true) == false then
                            if executeMissionExt(mission_mould_battle, nil, nil, nil, true, "l".._ED.user_info.user_grade.."e".._ED.user_info.user_experience, true) == false then
                            end
                        end
                        
                        -- executeNextEvent(nil, true)
                    end
                    
                    if missionIsOver() == true then
                        if executeMissionExt(mission_mould_tuition, nil, nil, nil, true, "l".._ED.user_info.user_grade.."e".._ED.user_info.user_experience, false) == false then
                            if executeMissionExt(mission_mould_plot, nil, nil, nil, true, "l".._ED.user_info.user_grade.."e".._ED.user_info.user_experience, false) == false then
                            end
                        end
                    end
                    if missionIsOver() == true and self._execute_login_game_mission== true then
                        state_machine.excute("adventure_reward_center_open", 0, 0)
                    end
                    
                    self._execute_login_game_mission = false
                else
                    fwin._close_touch_end_event = false			
					self._is_running_state = self._is_running_state + 1
                    if executeMissionExt(mission_mould_battle, nil, nil, nil, true, "0", true) == false  then 
                    end
                        
                    return
                end
            else
                if self._execute_login_game_mission == true then
                    self._execute_login_game_mission = false
                                    
                    if executeMissionExt(mission_mould_tuition, nil, nil, nil, false, "l".._ED.user_info.user_grade.."e".._ED.user_info.user_experience, true) == false then
                        if executeMissionExt(mission_mould_battle, nil, nil, nil, false, "l".._ED.user_info.user_grade.."e".._ED.user_info.user_experience, true) == false then
                        end
                    end
                    
                    -- executeNextEvent(nil, true)
                end

                if missionIsOver() == true then
                    if executeMissionExt(mission_mould_tuition, nil, nil, nil, true, "l".._ED.user_info.user_grade.."e".._ED.user_info.user_experience, true) == false then
                        if executeMissionExt(mission_mould_plot, nil, nil, nil, true, "l".._ED.user_info.user_grade.."e".._ED.user_info.user_experience, true) == false then
                        end
                    end
                end
            end
        elseif self._is_running_state == 15 then
            if self._close_touch_end_event == true then
                fwin._close_touch_end_event = false
                self._close_touch_end_event = false
            end
        end
        if missionIsOver() == false then
            local windowLock = fwin:find("WindowLockClass")
            if windowLock == nil then
                fwin:open(WindowLock:new():init(), fwin._windows)
            end
        end
        
        if app.configJson.OperatorName == "tencent" or app.configJson.OperatorName == "gdtppk" then
            if m_tx_pay_index <= 6 and (os.time() - self.platform_tx_pay_time) > 20 then
                m_tx_pay_index = m_tx_pay_index+1
                self.platform_tx_pay_time = os.time()
                state_machine.excute("tencent_balance_inquiry", 0, "tencent_balance_inquiry.")
            end
        end
		if app.configJson.OperatorName == "morefun" then
			if m_tx_pay_start == true and (os.time() - self.platform_tx_pay_time) > 5 then
                m_tx_pay_index = m_tx_pay_index+1
                self.platform_tx_pay_time = os.time()
                state_machine.excute("check_the_order_to_refresh_the_list", 0, "check_the_order_to_refresh_the_list.")
            end
		end
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            if self._is_running_state == 4 then
                app.load("client.l_digital.chat.SmChatHomeView")
                state_machine.excute("sm_chat_view_window_open", 0 , self)

                -- local function openMainWindowLoginPopup()
                    state_machine.excute("menu_window_login_popup_banner", 0, true)
                -- end
                -- local action7 = cc.Sequence:create(cc.DelayTime:create(0.7), cc.CallFunc:create(openMainWindowLoginPopup))
                -- self:runAction(action7)  
                if config_operation.AccountManager == true then
                    app.load("client.login.Manager.AccountSysFloatingWindow")
                    if fwin:find("AccountSysFloatingWindowClass") == nil then
                        local cell = AccountSysFloatingWindow:new()
                        fwin:open(cell,fwin._taskbar)
                        if app.configJson.OperatorName == "move" then 
                            local moveLofinType = cc.UserDefault:getInstance():getStringForKey("moveLofinType","0")
                            if zstring.tonumber(moveLofinType) ~= 3 then
                                fwin:close(fwin:find("AccountSysFloatingWindowClass"))
                            end
                        end
                    end
                end
            end
        end
    end
    self._is_running_state = self._is_running_state + 1
end

function Menu:onExit()
    state_machine.remove("menu_change_button_state")
    -- state_machine.remove("menu_start_scene_event_execute_mission")
    -- state_machine.remove("menu_show_duplicate_goto_npc")
    state_machine.remove("menu_button_hide_highlighted_all")
    state_machine.remove("menu_manager")
    state_machine.remove("menu_clean_page_state")
    state_machine.remove("menu_clean_page_state_campaign")
    state_machine.remove("menu_show_home_page")
    state_machine.remove("menu_back_home_page")
    state_machine.remove("menu_show_formation")
    state_machine.remove("menu_show_duplicate")
    state_machine.remove("menu_show_duplicate_everyday")
    state_machine.remove("menu_show_duplicate_hero")
    state_machine.remove("menu_show_campaign")
    state_machine.remove("menu_show_prop")
    state_machine.remove("menu_show_shop")
    state_machine.remove("menu_show_event")
    state_machine.remove("menu_hide_event")

    state_machine.remove("menu_adventure_avg")
    state_machine.remove("menu_adventure_mining")
    state_machine.remove("menu_adventure_arena")
    state_machine.remove("menu_adventure_recruit")
    state_machine.remove("menu_adventure_mercenary")
    state_machine.remove("menu_adventure_shop")
end


