-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗失败界面
-------------------------------------------------------------------------------------------------------
SmBattleLose = class("SmBattleLoseClass", Window)

local sm_battle_lose_open_terminal = {
    _name = "sm_battle_lose_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmBattleLoseClass")
        if nil == _homeWindow then
            local panel = SmBattleLose:new():init(params)
            fwin:open(panel,fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_battle_lose_close_terminal = {
    _name = "sm_battle_lose_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmBattleLoseClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmBattleLoseClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_battle_lose_open_terminal)
state_machine.add(sm_battle_lose_close_terminal)
state_machine.init()
    
function SmBattleLose:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0

    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.ship.hero_icon_list_cell")
    app.load("client.cells.ship.ship_icon_cell")

    local function init_sm_battle_lose_terminal()
        -- 显示界面
        local sm_battle_lose_display_terminal = {
            _name = "sm_battle_lose_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmBattleLoseWindow = fwin:find("SmBattleLoseClass")
                if SmBattleLoseWindow ~= nil then
                    SmBattleLoseWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_battle_lose_hide_terminal = {
            _name = "sm_battle_lose_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmBattleLoseWindow = fwin:find("SmBattleLoseClass")
                if SmBattleLoseWindow ~= nil then
                    SmBattleLoseWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --退出
        local sm_battle_lose_drop_out_terminal = {
            _name = "sm_battle_lose_drop_out",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 战报数据清空
                _ED.battle_report_info = nil

                _ED.battle_playback_arena = {}
                local _fight_type = instance._fight_type
                fwin:close(instance)
                fwin:close(fwin:find("SmBattleLoseClass"))
                -- fwin:removeAll()
                -- cacher.removeAllObject(_object)
                cacher.removeAllTextures()
                fwin:reset(nil)
                -- fwin:removeAll()
                app.load("client.home.Menu")
                fwin:open(Menu:new(), fwin._taskbar)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then                   
                    if fwin:find("HomeClass") == nil 
                        and _ED.battleData.battle_init_type ~= _enum_fight_type._fight_type_215
                        and _ED.battleData.battle_init_type ~= _enum_fight_type._fight_type_216
                        and _ED.battleData.battle_init_type ~= _enum_fight_type._fight_type_217
                        and _ED.fileIsland.fileIslandFriendCellInfo_goBattle ~= true
                        then
                        state_machine.excute("menu_manager", 0, 
                            {
                                _datas = {
                                    terminal_name = "menu_manager",     
                                    next_terminal_name = "menu_show_home_page", 
                                    current_button_name = "Button_home",
                                    but_image = "Image_home",       
                                    terminal_state = 0, 
                                    _needOpenHomeHero = true,
                                    isPressedActionEnabled = true
                                }
                            }
                        )
                    end
                    state_machine.excute("menu_back_home_page", 0, "")
                    state_machine.excute("home_change_open_atrribute", 0, false)
                end
                if _fight_type == _enum_fight_type._fight_type_11 then ----jjc
                    app.load("client.l_digital.campaign.Campaign")
                    state_machine.excute("campaign_window_open", 0, nil)
                    app.load("client.l_digital.campaign.arena.Arena")
                    state_machine.excute("arena_window_open", 0, nil)

                -- 跨服矿战
                elseif _fight_type == _enum_fight_type._fight_type_214 then
                    app.load("client.l_digital.campaign.Campaign")
                    state_machine.excute("campaign_window_open", 0, nil)
                    app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelMap")
                    state_machine.excute("cross_server_battel_map_window_open", 0, nil)
                -- 跨服忍界
                elseif _fight_type == _enum_fight_type._fight_type_219 then
                    app.load("client.l_digital.campaign.Campaign")
                    state_machine.excute("campaign_window_open", 0, nil)
                    app.load("client.l_digital.campaign.cross_total_war.CrossTotalWar")
                    state_machine.excute("cross_total_war_window_open", 0, nil)

                elseif _fight_type == _enum_fight_type._fight_type_13 then
                elseif _fight_type == _enum_fight_type._fight_type_53 then ----
                    app.load("client.l_digital.campaign.digitalpurify.DigitalPurifyWindow")
                    state_machine.excute("digital_purify_window_open", 0, 0)
                elseif _fight_type == _enum_fight_type._fight_type_102 then ----
                    app.load("client.l_digital.campaign.trialtower.TrialTower")
                    local trialTower = TrialTower:new()
                    -- trialTower:init(3) -- 示意进入时的状态 
                    fwin:open(trialTower, fwin._view)   
                elseif _fight_type == _enum_fight_type._fight_type_51 then
                    app.load("client.l_digital.explore.ExploreWindow")
                    state_machine.excute("explore_window_open", 0, 0)
                    state_machine.excute("explore_window_open_fun_window", 0, nil)
                elseif _fight_type == _enum_fight_type._fight_type_52 then
                    app.load("client.l_digital.explore.ExploreWindow")
                    state_machine.excute("explore_window_open", 0, 0)
                    state_machine.excute("explore_window_open_fun_window", 0, nil)
                elseif _fight_type == _enum_fight_type._fight_type_211 then -- 王者之战
                elseif _fight_type == _enum_fight_type._fight_type_212 then
                    if _ED.previous_ship_evo_window == "FormationTigerGateClass" then
                        state_machine.excute("formation_open_instance_window",0,{_datas = {_shipInstance = _ED.battle_evo_ship_info}})
                        -- state_machine.excute("formation_open_instance_window", 0, {_datas = {}})
                    elseif _ED.previous_ship_evo_window == "SmRoleStrengthenTabClass" then
                        app.load("client.packs.hero.HeroDevelop")
                        local heroDevelopWindow = HeroDevelop:new()
                        local ship_info = _ED.battle_evo_ship_info
                        ship_info.shengming = zstring.tonumber(ship_info.ship_health)
                        ship_info.gongji = zstring.tonumber(ship_info.ship_courage)
                        ship_info.waigong = zstring.tonumber(ship_info.ship_intellect)
                        ship_info.neigong = zstring.tonumber(ship_info.ship_quick)
                        heroDevelopWindow:init(ship_info.ship_id, "learn")
                        fwin:open(heroDevelopWindow, fwin._viewdialog)
                    end
                    state_machine.excute("generals_evo_chain_window_open", 0, {_ED.battle_evo_ship_info})

                elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_215 
                    or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_216
                    or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_217
                    or _ED.fileIsland.fileIslandFriendCellInfo_goBattle == true
                    then
                     if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                        -- if fwin:find("HomeClass") == nil then
                        --     state_machine.excute("menu_manager", 0, 
                        --         {
                        --             _datas = {
                        --                 terminal_name = "menu_manager",     
                        --                 next_terminal_name = "menu_show_home_page", 
                        --                 current_button_name = "Button_home",
                        --                 but_image = "Image_home",       
                        --                 terminal_state = 0, 
                        --                 _needOpenHomeHero = true,
                        --                 isPressedActionEnabled = true
                        --             }
                        --         }
                        --     )
                        -- end
                        -- state_machine.excute("menu_back_home_page", 0, "")
                        -- state_machine.excute("home_change_open_atrribute", 0, false)

                        app.load("client.l_digital.campaign.exploration.ExplorationLoading")
                        fwin:open(ExplorationLoading:new():init(), fwin._taskbar)
                    else
                        app.load("client.l_digital.campaign.fileIsland.FileIslandWindow")
                        state_machine.excute("fileIsland_window_open", 0, 1)
                    end
                    
                else
                    state_machine.excute("lduplicate_window_pve_quick_entrance", 0, 
                    {
                        _type    = LDuplicateWindow._infoDatas._type, 
                        _sceneId = LDuplicateWindow._infoDatas._chapter
                    })
                    
                    if zstring.tonumber(_ED.recharge_rmb_number) == 0 and zstring.tonumber(_ED.recharge_precious_number) <= 0 then
                        if battle_fail_show_frist_recharge ~= nil then
                            for k,v in pairs(battle_fail_show_frist_recharge) do
                                if tonumber(v) == zstring.tonumber(_ED._scene_npc_id) then
                                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_naruto or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                                        state_machine.excute("home_open_first_recharge_activity", 0, "")
                                    else
                                        state_machine.excute("rechargeable_open", 0, 1)
                                    end
                                    break
                                end
                            end
                        end
                    end
                end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --跳转到 武将商店招募
        local sm_battle_lose_open_hero_shop_terminal = {
            _name = "sm_battle_lose_open_hero_shop",
            _init = function (terminal) 
                 app.load("client.shop.Shop")
                 app.load("client.home.Menu")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:close(fwin:find("FightUIClass"))
                cacher.removeAllTextures()
                fwin:reset(nil)

                local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.NewRecruit)
                if fun_is_open == true then
                    app.load("client.home.Menu")
                    fwin:open(Menu:new(), fwin._taskbar)

                    if fwin:find("HomeClass") == nil then
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
                    end
                    local trace_id = 22
                    state_machine.excute("shortcut_function_trace", 0, {trace_function_id = nil, _datas = {traceId = trace_id}})
                else
                    local _shop = Shop:new()
                    _shop:init(1)
                    fwin:open(_shop, fwin._view)

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
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --跳转到 强化装备
        local sm_battle_lose_open_equipment_terminal = {
            _name = "sm_battle_lose_open_equipment",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:close(fwin:find("FightUIClass"))
                cacher.removeAllTextures()
                fwin:reset(nil)
                app.load("client.home.Menu")
                fwin:open(Menu:new(), fwin._taskbar)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    if fwin:find("HomeClass") == nil then
                        state_machine.excute("menu_manager", 0, 
                            {
                                _datas = {
                                    terminal_name = "menu_manager",     
                                    next_terminal_name = "menu_show_home_page", 
                                    current_button_name = "Button_home",
                                    but_image = "Image_home",       
                                    terminal_state = 0, 
                                    _needOpenHomeHero = true,
                                    isPressedActionEnabled = true
                                }
                            }
                        )
                    end
                    state_machine.excute("menu_back_home_page", 0, "")
                    state_machine.excute("home_change_open_atrribute", 0, false)
                end
                local ship = nil
                for i, v in pairs(_ED.user_formetion_status) do
                    if zstring.tonumber(v) > 0 then
                        ship = _ED.user_ship[""..v]
                        break
                    end
                end
                
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                else
                    if fwin:find("HeroIconListViewClass") == nil then
                        app.load("client.packs.hero.HeroIconListView")
                        state_machine.excute("hero_icon_listview_open",0,ship)
                        fwin:find("HeroIconListViewClass"):setVisible(false)
                    end
                end

                --武将装备数据(等级|品质|经验|星级|模板)
                local shipEquip = zstring.split(ship.equipInfo, "|")
                local equipData = zstring.split(shipEquip[5], ",")
                local equipStar = zstring.split(shipEquip[4], ",")
                local equipMouldId = equipData[1]
                local equip = {}
                --装备模板id
                --初始装备
                local equipAll = dms.string(dms["ship_mould"], ship.ship_template_id, ship_mould.treasureSkill)
                if tonumber(equipStar[1]) == 0 then
                    local equipMouldData = zstring.split(equipAll, ",")
                    equip.user_equiment_template = equipMouldData[1]
                else
                    equip.user_equiment_template = equipMouldId
                end
                --装备等级
                local equipLevelData = zstring.split(shipEquip[1], ",")
                equip.user_equiment_grade = equipLevelData[1]
                --所属战船
                equip.ship_id = ship.ship_id
                equip.m_index = 1
                
                if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                    app.load("client.packs.hero.HeroDevelop")
                    if fwin:find("HeroDevelopClass") ~= nil then
                        state_machine.excute("formation_set_ship",0,ship)
                        return
                        -- fwin:close(fwin:find("HeroDevelopClass"))
                    end
                    local heroDevelopWindow = HeroDevelop:new()
                    ship.shengming = zstring.tonumber(ship.ship_health)
                    ship.gongji = zstring.tonumber(ship.ship_courage)
                    ship.waigong = zstring.tonumber(ship.ship_intellect)
                    ship.neigong = zstring.tonumber(ship.ship_quick)

                    -- print("=======11=====",enter_type)
                    if enter_type ~= "learn" and enter_type ~= "pack" then
                        enter_type = "formation"
                    end
                    for i,v in pairs(_ED.user_formetion_status) do
                        if zstring.tonumber(v) == tonumber(ship.ship_id) then
                            enter_type = "formation"
                        end
                    end
                    heroDevelopWindow:init(ship.ship_id, enter_type,1)
                    fwin:open(heroDevelopWindow, fwin._viewdialog)
                else
                    app.load("client.packs.equipment.SmEquipmentQianghua")
                    state_machine.excute("sm_equipment_qianghua_open",0,equip)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --跳转到 武将进阶
        local sm_battle_lose_open_ship_advanced_terminal = {
            _name = "sm_battle_lose_open_ship_advanced",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:close(fwin:find("FightUIClass"))
                cacher.removeAllTextures()
                fwin:reset(nil)
                app.load("client.home.Menu")
                fwin:open(Menu:new(), fwin._taskbar)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    if fwin:find("HomeClass") == nil then
                        state_machine.excute("menu_manager", 0, 
                            {
                                _datas = {
                                    terminal_name = "menu_manager",     
                                    next_terminal_name = "menu_show_home_page", 
                                    current_button_name = "Button_home",
                                    but_image = "Image_home",       
                                    terminal_state = 0, 
                                    _needOpenHomeHero = true,
                                    isPressedActionEnabled = true
                                }
                            }
                        )
                    end
                    state_machine.excute("menu_back_home_page", 0, "")
                    state_machine.excute("home_change_open_atrribute", 0, false)
                end
                local ship = nil
                for i, v in pairs(_ED.user_formetion_status) do
                    if zstring.tonumber(v) > 0 then
                        ship = _ED.user_ship[""..v]
                        break
                    end
                end
                local enter_type = "learn"
                if fwin:find("HeroIconListViewClass") == nil then
                    app.load("client.packs.hero.HeroIconListView")
                    state_machine.excute("hero_icon_listview_open",0,ship)
                    fwin:find("HeroIconListViewClass"):setVisible(false)
                end
                app.load("client.packs.hero.HeroDevelop")
                if fwin:find("HeroDevelopClass") ~= nil then
                    state_machine.excute("formation_set_ship",0,ship)
                    return
                    -- fwin:close(fwin:find("HeroDevelopClass"))
                end
                local heroDevelopWindow = HeroDevelop:new()
                if __lua_project_id == __lua_project_gragon_tiger_gate 
                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    ship.shengming = zstring.tonumber(ship.ship_health)
                    ship.gongji = zstring.tonumber(ship.ship_courage)
                    ship.waigong = zstring.tonumber(ship.ship_intellect)
                    ship.neigong = zstring.tonumber(ship.ship_quick)
                end
                -- print("=======11=====",enter_type)
                if enter_type ~= "learn" and enter_type ~= "pack" then
                    enter_type = "formation"
                end
                for i,v in pairs(_ED.user_formetion_status) do
                    if zstring.tonumber(v) == tonumber(ship.ship_id) then
                        enter_type = "formation"
                    end
                end
                heroDevelopWindow:init(ship.ship_id, enter_type)
                fwin:open(heroDevelopWindow, fwin._viewdialog)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --跳转到 武将升星
        local sm_battle_lose_open_ship_rising_star_terminal = {
            _name = "sm_battle_lose_open_ship_rising_star",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:close(fwin:find("FightUIClass"))
                cacher.removeAllTextures()
                fwin:reset(nil)
                app.load("client.home.Menu")
                fwin:open(Menu:new(), fwin._taskbar)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    if fwin:find("HomeClass") == nil then
                        state_machine.excute("menu_manager", 0, 
                            {
                                _datas = {
                                    terminal_name = "menu_manager",     
                                    next_terminal_name = "menu_show_home_page", 
                                    current_button_name = "Button_home",
                                    but_image = "Image_home",       
                                    terminal_state = 0, 
                                    _needOpenHomeHero = true,
                                    isPressedActionEnabled = true
                                }
                            }
                        )
                    end
                    state_machine.excute("menu_back_home_page", 0, "")
                    state_machine.excute("home_change_open_atrribute", 0, false)
                end
                local ship = nil
                for i, v in pairs(_ED.user_formetion_status) do
                    if zstring.tonumber(v) > 0 then
                        ship = _ED.user_ship[""..v]
                        break
                    end
                end
                local enter_type = "learn"
                if fwin:find("HeroIconListViewClass") == nil then
                    app.load("client.packs.hero.HeroIconListView")
                    state_machine.excute("hero_icon_listview_open",0,ship)
                    fwin:find("HeroIconListViewClass"):setVisible(false)
                end
                app.load("client.packs.hero.HeroDevelop")
                if fwin:find("HeroDevelopClass") ~= nil then
                    state_machine.excute("formation_set_ship",0,ship)
                    return
                    -- fwin:close(fwin:find("HeroDevelopClass"))
                end
                local heroDevelopWindow = HeroDevelop:new()
                if __lua_project_id == __lua_project_gragon_tiger_gate 
                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    ship.shengming = zstring.tonumber(ship.ship_health)
                    ship.gongji = zstring.tonumber(ship.ship_courage)
                    ship.waigong = zstring.tonumber(ship.ship_intellect)
                    ship.neigong = zstring.tonumber(ship.ship_quick)
                end
                -- print("=======11=====",enter_type)
                if enter_type ~= "learn" and enter_type ~= "pack" then
                    enter_type = "formation"
                end
                for i,v in pairs(_ED.user_formetion_status) do
                    if zstring.tonumber(v) == tonumber(ship.ship_id) then
                        enter_type = "formation"
                    end
                end
                heroDevelopWindow:init(ship.ship_id, enter_type)
                fwin:open(heroDevelopWindow, fwin._viewdialog)

                state_machine.excute("hero_develop_page_manager",0,{_datas = {next_terminal_name = "hero_develop_page_open_train_page",            
                current_button_name = "Button_peiyang",     
                but_image = "",     
                shipId = self.shipId,
                terminal_state = 0, 
                openWinId = 3,
                isPressedActionEnabled = tempIsPressedActionEnabled}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开战报统计界面
        local sm_battle_lose_go_to_report_terminal = {
            _name = "sm_battle_lose_go_to_report",
            _init = function (terminal) 
                app.load("client.battle.SmBattleReportWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params and params._datas then 
                    state_machine.excute("sm_battle_report_window_open",0,{battleType = params._datas.battle_type})
                end
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(sm_battle_lose_display_terminal)
        state_machine.add(sm_battle_lose_hide_terminal)
        state_machine.add(sm_battle_lose_drop_out_terminal)
        state_machine.add(sm_battle_lose_open_hero_shop_terminal)
        state_machine.add(sm_battle_lose_open_equipment_terminal)
        state_machine.add(sm_battle_lose_open_ship_advanced_terminal)
        state_machine.add(sm_battle_lose_open_ship_rising_star_terminal)
        state_machine.add(sm_battle_lose_go_to_report_terminal)
        
        state_machine.init()
    end
    init_sm_battle_lose_terminal()
end


function SmBattleLose:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
end

function SmBattleLose:init(_fight_type)
    self._fight_type = _fight_type
    self:onInit()
    return self
end

function SmBattleLose:onInit()
    local csbSmBattleLose = csb.createNode("battle/sm_battle_failure.csb")
    local root = csbSmBattleLose:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmBattleLose)
    local action = csb.createTimeline("battle/sm_battle_failure.csb")
    table.insert(self.actions, action)
    csbSmBattleLose:runAction(action)
    self.actions[1]:play("window_open", false)

    -- 跨服矿战结束，不用加音效
    if self._fight_type ~= _enum_fight_type._fight_type_214 then
        playEffect(formatMusicFile("effect", 9995))   
    end

    -- 跨服矿战结束，不用加音效
    

    if self._fight_type == _enum_fight_type._fight_type_219  and _ED.crossServerTotalReplay ~= true  then
        local function onScheduleOnce()
            state_machine.excute("cross_total_war_victory_reward_window_open", 0, "")
        end
        local action = cc.Sequence:create(cc.DelayTime:create(1.5),
                                            cc.CallFunc:create(onScheduleOnce))
        self:runAction(action)
    end


    
    self:onUpdateDraw()
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_black_bg"), nil, 
    {
        terminal_name = "sm_battle_lose_drop_out",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    -- 抽卡
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_1"), nil, 
    {
        terminal_name = "sm_battle_lose_open_hero_shop",
        terminal_state = 0,
        touch_black = true,
    },
    nil,0)

    -- 强化装备
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_2"), nil, 
    {
        terminal_name = "sm_battle_lose_open_equipment",
        terminal_state = 0,
        touch_black = true,
    },
    nil,0)

    --数码兽进阶
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_3"), nil, 
    {
        terminal_name = "sm_battle_lose_open_ship_advanced",
        terminal_state = 0,
        touch_black = true,
    },
    nil,0)

    --数码兽升星
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_4"), nil, 
    {
        terminal_name = "sm_battle_lose_open_ship_rising_star",
        terminal_state = 0,
        touch_black = true,
    },
    nil,0)

    -- 战报统计
    local Button_damage = ccui.Helper:seekWidgetByName(root,"Button_damage")
    if Button_damage then
        if _ED.battle_report_info ~= nil then
            Button_damage:setVisible(true)
            fwin:addTouchEventListener(Button_damage, nil, 
            {
                terminal_name = "sm_battle_lose_go_to_report", 
                battle_type = self._fight_type,
                isPressedActionEnabled = true,
            },
            nil,0)
        else
            Button_damage:setVisible(false)
        end
    end

end

function SmBattleLose:onExit()
    state_machine.remove("sm_battle_lose_display")
    state_machine.remove("sm_battle_lose_hide")
    state_machine.remove("sm_battle_lose_go_to_report")
end