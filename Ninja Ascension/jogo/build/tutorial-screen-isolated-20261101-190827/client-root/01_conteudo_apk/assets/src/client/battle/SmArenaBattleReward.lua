-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场规则
-------------------------------------------------------------------------------------------------------
SmArenaBattleReward = class("SmArenaBattleRewardClass", Window)

local sm_arena_battle_reward_open_terminal = {
    _name = "sm_arena_battle_reward_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmArenaBattleRewardClass")
        if nil == _homeWindow then
            local panel = SmArenaBattleReward:new():init(params)
            fwin:open(panel,fwin._window)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_arena_battle_reward_close_terminal = {
    _name = "sm_arena_battle_reward_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmArenaBattleRewardClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmArenaBattleRewardClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_arena_battle_reward_open_terminal)
state_machine.add(sm_arena_battle_reward_close_terminal)
state_machine.init()
    
function SmArenaBattleReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    self.battle_type = 0

    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.ship.hero_icon_list_cell")
    app.load("client.cells.ship.ship_icon_cell")

    local function init_sm_arena_battle_reward_terminal()
        -- 显示界面
        local sm_arena_battle_reward_display_terminal = {
            _name = "sm_arena_battle_reward_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmArenaBattleRewardWindow = fwin:find("SmArenaBattleRewardClass")
                if SmArenaBattleRewardWindow ~= nil then
                    SmArenaBattleRewardWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_arena_battle_reward_hide_terminal = {
            _name = "sm_arena_battle_reward_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmArenaBattleRewardWindow = fwin:find("SmArenaBattleRewardClass")
                if SmArenaBattleRewardWindow ~= nil then
                    SmArenaBattleRewardWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --退出
        local sm_arena_battle_reward_drop_out_terminal = {
            _name = "sm_arena_battle_reward_drop_out",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 战报数据清空
                _ED.battle_report_info = nil

                local fightType = instance.battle_type
                _ED.battle_playback_arena = {}
                _ED._current_scene_id = 0
				_ED._scene_npc_id = 0
				_ED._current_seat_index = -1
				_ED._npc_difficulty_index = 0
				_ED._npc_addition_params = ""
				fwin:close(instance)
				fwin:close(fwin:find("BattleSceneClass"))

				cacher.cleanSystemCacher()
				cacher.destoryRefPools()
				cacher.cleanActionTimeline()
				if __lua_project_id == __lua_project_gragon_tiger_gate
                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
					checkTipBeLeave()
				end				
				cacher.removeAllTextures()
				fwin:reset(nil)

				app.load("client.home.Menu")
				if fwin:find("MenuClass") == nil then
					fwin:open(Menu:new(), fwin._taskbar)
				end

                if fightType == _enum_fight_type._fight_type_13 then
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
                elseif fightType == _enum_fight_type._fight_type_213 then
                    state_machine.excute("union_fighting_main_open", 0, {notReqeust = true})
                else
    				app.load("client.l_digital.campaign.Campaign")
    				state_machine.excute("campaign_window_open", 0, nil)
    				app.load("client.l_digital.campaign.arena.Arena")
    				state_machine.excute("arena_window_open", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 再看一次
        local sm_arena_battle_reward_play_again_terminal = {
            _name = "sm_arena_battle_reward_play_again",
            _init = function (terminal) 
                app.load("client.battle.BattleStartEffect")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local fightType = instance.battle_type
                _ED._current_scene_id = 0
                _ED._scene_npc_id = 0
                _ED._current_seat_index = -1
                _ED._npc_difficulty_index = 0
                _ED._npc_addition_params = ""
                fwin:close(instance)
                fwin:close(fwin:find("BattleSceneClass"))

                cacher.cleanSystemCacher()
                cacher.destoryRefPools()
                cacher.cleanActionTimeline()
                if __lua_project_id == __lua_project_gragon_tiger_gate
                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    checkTipBeLeave()
                end             
                cacher.removeAllTextures()
                fwin:reset(nil)

                app.load("client.home.Menu")
                if fwin:find("MenuClass") == nil then
                    fwin:open(Menu:new(), fwin._taskbar)
                end
                if fightType == _enum_fight_type._fight_type_13 then
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
                elseif fightType == _enum_fight_type._fight_type_213 then
                    state_machine.excute("union_fighting_main_open", 0, {notReqeust = true})
                else
                    app.load("client.l_digital.campaign.Campaign")
                    state_machine.excute("campaign_window_open", 0, nil)
                    app.load("client.l_digital.campaign.arena.Arena")
                    state_machine.excute("arena_window_open", 0, nil)
                    state_machine.excute("arena_once_again_ladder_seat_playback", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --facebook分享
        local share_click_on_terminal = {
            _name = "share_click_on",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_naruto then
                    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
                        handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_share[2])
                    else
                        handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_share[1])
                    end
                end

                if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
                    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
                        handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_lz_share[2])
                    else
                        handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_lz_share[1])
                    end
                end

                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and app.configJson.ReleaseLanguage == "en" then
                    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
                        handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_share[2])
                    else
                        handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_share[1])
                    end
                end
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开战报统计界面
        local sm_arena_battle_go_to_report_terminal = {
            _name = "sm_arena_battle_go_to_report",
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
        state_machine.add(sm_arena_battle_reward_display_terminal)
        state_machine.add(sm_arena_battle_reward_hide_terminal)
        state_machine.add(sm_arena_battle_reward_drop_out_terminal)
        state_machine.add(sm_arena_battle_reward_play_again_terminal)
        state_machine.add(sm_arena_battle_go_to_report_terminal)
        state_machine.add(share_click_on_terminal)
        
        state_machine.init()
    end
    init_sm_arena_battle_reward_terminal()
end

function SmArenaBattleReward:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    if tonumber(self.battle_type) ~= 213 then
        --胜利动画
        local Panel_win_dh = ccui.Helper:seekWidgetByName(root,"Panel_win_dh")

        local jsonFile = "sprite/spirte_shengli.json"
        local atlasFile = "sprite/spirte_shengli.atlas"
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "chuxian", true, nil)
        animation.animationNameList = {"chuxian","xunhuan"}
        sp.initArmature(animation, false)
        local function changeActionCallback( armatureBack )
        end
        animation._invoke = changeActionCallback
        animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        -- Intro once, then the loop (the chained switch fails on the PC spine bridge).
        if animation.setAnimation and animation.addAnimation then
            animation:setAnimation(0, "chuxian", false)
            animation:addAnimation(0, "xunhuan", true, 0)
        else
            csb.animationChangeToAction(animation, 0, 1, false)
        end
        Panel_win_dh:addChild(animation)

        --星级
        local Panel_star_dh = ccui.Helper:seekWidgetByName(root,"Panel_star_dh") 
        -- local npcData = dms.element(dms["npc"], _ED._scene_npc_id)  
        -- local npcCurStar = tonumber(_ED.npc_state[dms.atoi(npcData, npc.id)])
        local a_name = ""
        local cx_name = ""
        a_name = "3star"
        cx_name = "3star_cx"
        local jsonFile = "sprite/spirte_zaxing.json"
        local atlasFile = "sprite/spirte_zaxing.atlas"
        local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, a_name, true, nil)
        animation2.animationNameList = {a_name,cx_name}
        sp.initArmature(animation2, false)

        local function onFrameEventBullet(bone,evt,originFrameIndex,currentFrameIndex)
            if evt ~= nil and #evt > 0 then
                if evt == "ding" then
                    playEffect(formatMusicFile("effect", 9989))
                end
            end
        end
        local function changeActionCallback( armatureBack )
        end
        animation2._invoke = changeActionCallback
        animation2:getAnimation():setFrameEventCallFunc(onFrameEventBullet)
        animation2:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        if animation2.setAnimation and animation2.addAnimation then
            animation2:setAnimation(0, a_name, false)
            animation2:addAnimation(0, cx_name, true, 0)
        else
            csb.animationChangeToAction(animation2, 0, 1, false)
        end
        Panel_star_dh:addChild(animation2)
    end

    local Text_name_1 = ccui.Helper:seekWidgetByName(root,"Text_name_1")
    local Text_paiming_1 = ccui.Helper:seekWidgetByName(root,"Text_paiming_1")
    local Text_name_2 = ccui.Helper:seekWidgetByName(root,"Text_name_2")
    local Text_paiming_2 = ccui.Helper:seekWidgetByName(root,"Text_paiming_2")
    local ListView_digimon_icon_1 = ccui.Helper:seekWidgetByName(root,"ListView_digimon_icon_1")
    local ListView_digimon_icon_2 = ccui.Helper:seekWidgetByName(root,"ListView_digimon_icon_2")
    ListView_digimon_icon_1:removeAllItems()
    ListView_digimon_icon_2:removeAllItems()
    local Text_paiming_1_0_0 = ccui.Helper:seekWidgetByName(root,"Text_paiming_1_0_0")
    local Text_paiming_1_0 = ccui.Helper:seekWidgetByName(root,"Text_paiming_1_0")
    if Text_paiming_1_0_0 ~= nil then
        Text_paiming_1_0_0:setVisible(true)
    end
    if Text_paiming_1_0 ~= nil then
        Text_paiming_1_0:setVisible(true)
    end

    local ship_list = {}
    local cell_list = {}
    if tonumber(self.battle_type) == 11 then --竞技场来的
        --我的名字
        Text_name_1:setString(_ED.arena_battle_data[1].name)
        --我的排名
        Text_paiming_1:setString(_ED.arena_battle_data[1].rank)
        --对方的名称
        Text_name_2:setString(_ED.arena_battle_data[2].name)

        --对方的排名
        Text_paiming_2:setString(_ED.arena_battle_data[2].rank)

        --我的阵容
        local shipAllData = zstring.split(_ED.arena_battle_data[1].battle_object, "!")
        if  __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            for i, v in pairs(shipAllData) do
                local panel_wujiang = ccui.Helper:seekWidgetByName(root,string.format("Panel_digimon_icon_%d", i))
                local shipData = zstring.split(v, ":")
                local ship = {}
                ship.ship_template_id = shipData[1]
                ship.evolution_status = shipData[3]
                ship.Order = shipData[5]
                ship.StarRating = shipData[4]
                ship.ship_grade = shipData[2]
                ship.ship_id = -1
                ship.skin_id = shipData[7]
                local cell = ShipIconCell:createCell()
                cell:init(ship,10)
                panel_wujiang:addChild(cell)
                table.insert(cell_list, cell)
                neWshowShipStar(ccui.Helper:seekWidgetByName(cell.roots[1],"Panel_star"),tonumber(ship.StarRating))
                cell:setVisible(false)
            end
        else
            for i, v in pairs(shipAllData) do
                local shipData = zstring.split(v, ":")
                local ship = {}
                ship.ship_template_id = shipData[1]
                ship.evolution_status = shipData[3]
                ship.Order = shipData[5]
                ship.StarRating = shipData[4]
                ship.ship_grade = shipData[2]
                ship.ship_id = -1
                ship.skin_id = shipData[7]
                local cell = ShipIconCell:createCell()
                cell:init(ship,10)
                ListView_digimon_icon_1:addChild(cell)
                table.insert(ship_list, cell)
                neWshowShipStar(ccui.Helper:seekWidgetByName(cell.roots[1],"Panel_star"),tonumber(ship.StarRating))
                cell:setVisible(false)
            end
        end
        

        --对方de阵容
        local shipAllData = zstring.split(_ED.arena_battle_data[2].battle_object, "!")
        if  __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            for i, v in pairs(shipAllData) do
                local panel_wujiang = ccui.Helper:seekWidgetByName(root,string.format("Panel_digimon_icon_0_%d", i))
                local shipData = zstring.split(v, ":")
                local ship = {}
                ship.ship_template_id = shipData[1]
                ship.evolution_status = shipData[3]
                ship.Order = shipData[5]
                ship.StarRating = shipData[4]
                ship.ship_grade = shipData[2]
                ship.ship_id = -1
                ship.skin_id = shipData[7]
                local cell = ShipIconCell:createCell()
                cell:init(ship,10)
                panel_wujiang:addChild(cell)
                table.insert(cell_list, cell)
                neWshowShipStar(ccui.Helper:seekWidgetByName(cell.roots[1],"Panel_star"),tonumber(ship.StarRating))
                cell:setVisible(false)
            end
        else
            for i, v in pairs(shipAllData) do
                local shipData = zstring.split(v, ":")
                local ship = {}
                ship.ship_template_id = shipData[1]
                ship.evolution_status = shipData[3]
                ship.Order = shipData[5]
                ship.StarRating = shipData[4]
                ship.ship_grade = shipData[2]
                ship.ship_id = -1
                ship.skin_id = shipData[7]
                local cell = ShipIconCell:createCell()
                cell:init(ship,10)
                ListView_digimon_icon_2:addChild(cell)
                table.insert(cell_list, cell)
                neWshowShipStar(ccui.Helper:seekWidgetByName(cell.roots[1],"Panel_star"),tonumber(ship.StarRating))
                cell:setVisible(false)
            end
        end
        
    elseif tonumber(self.battle_type) == 13 then --好友切磋来的
        if Text_paiming_1_0_0 ~= nil then
            Text_paiming_1_0_0:setVisible(false)
        end
        if Text_paiming_1_0 ~= nil then
            Text_paiming_1_0:setVisible(false)
        end
        --我的名字
        Text_name_1:setString(_ED.user_info.user_name)
        --我的排名
        Text_paiming_1:setString("")
        --对方的名称
        Text_name_2:setString(_ED.chat_user_info.name)
        --对方的排名
        Text_paiming_2:setString("")
        --我的阵容
        if  __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            for i= 1,6 do
                local panel_wujiang = ccui.Helper:seekWidgetByName(root,string.format("Panel_digimon_icon_%d", i))
                local ship = _ED.user_ship["".._ED.user_formetion_status[i]]
                if ship ~= nil then
                    local cell = HeroIconListCell:createCell()
                    cell:init(ship, i,false,nil,false)
                    panel_wujiang:addChild(cell)
                end 
            end
        else
            for i= 1,6 do
                local ship = _ED.user_ship["".._ED.user_formetion_status[i]]
                if ship ~= nil then
                    local cell = HeroIconListCell:createCell()
                    cell:init(ship, i,false,nil,false)
                    ListView_digimon_icon_1:addChild(cell)
                end 
            end
        end
        
        --对方阵容
        local shipAllData = zstring.split(_ED.chat_user_info.formation, "!")
        if  __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            for i, v in pairs(shipAllData) do
                local panel_wujiang = ccui.Helper:seekWidgetByName(root,string.format("Panel_digimon_icon_0_%d", i))
                local shipData = zstring.split(v, ":")
                local ship = {}
                ship.ship_template_id = shipData[1]
                ship.evolution_status = shipData[3]
                ship.Order = shipData[5]
                ship.StarRating = shipData[4]
                ship.ship_grade = shipData[2]
                ship.ship_id = -1
                ship.skin_id = shipData[7]
                local cell = HeroIconListCell:createCell()
                cell:init(ship, i,true)
                panel_wujiang:addChild(cell)
                table.insert(cell_list, cell)
                cell:setVisible(false)
            end
        else
            for i, v in pairs(shipAllData) do
                --模板id:等级:进阶数据:星级:品阶:战力:皮肤
                local shipData = zstring.split(v, ":")
                local cell = HeroIconListCell:createCell()
                local ship = {}
                ship.ship_template_id = shipData[1]
                ship.evolution_status = shipData[3]
                ship.Order = shipData[5]
                ship.StarRating = shipData[4]
                ship.ship_grade = shipData[2]
                ship.ship_id = -1
                ship.skin_id = shipData[7]
                cell:init(ship, i,true)
                ListView_digimon_icon_2:addChild(cell)
            end
        end
        
    elseif tonumber(self.battle_type) == 213 then
        local info = zstring.split(_ED.battle_playback_213_info, "@")
        local result = zstring.split(info[1], ",")
        local leftInfo = zstring.split(info[2], ",")
        local rightInfo = zstring.split(info[3], ",")
        if tonumber(result[1]) == 1 then
            ccui.Helper:seekWidgetByName(root,"Panel_jiesuan_t_1"):setBackGroundImage("images/ui/text/GHZ_res/jiesuan_win.png")
            ccui.Helper:seekWidgetByName(root,"Panel_jiesuan_t_2"):setBackGroundImage("images/ui/text/GHZ_res/jiesuan_los.png")
        else
            ccui.Helper:seekWidgetByName(root,"Panel_jiesuan_t_1"):setBackGroundImage("images/ui/text/GHZ_res/jiesuan_los.png")
            ccui.Helper:seekWidgetByName(root,"Panel_jiesuan_t_2"):setBackGroundImage("images/ui/text/GHZ_res/jiesuan_win.png")
        end
        if Text_paiming_1_0_0 ~= nil then
            Text_paiming_1_0_0:setVisible(false)
        end
        if Text_paiming_1_0 ~= nil then
            Text_paiming_1_0:setVisible(false)
        end
        Text_name_1:setString(leftInfo[2])
        Text_paiming_1:setString("")
        Text_name_2:setString(rightInfo[2])
        Text_paiming_2:setString("")

        local formationInfo = nil
        if _ED.city_resource_battle_report ~= nil and _ED.city_resource_battle_report[10007] ~= nil then
            for k,v in pairs(_ED.city_resource_battle_report[10007]) do
                if tonumber(v.time) == tonumber(result[2]) then
                    formationInfo = v
                    break
                end
            end
        end

        if formationInfo ~= nil then
            formationInfo = zstring.split(formationInfo.param, "@")
            if formationInfo[1] ~= nil then
                local leftInfo = zstring.split(formationInfo[1], "!")
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                    for i, v in pairs(leftInfo) do
                        local panel_wujiang = ccui.Helper:seekWidgetByName(root,string.format("Panel_digimon_icon_%d", i))
                        local shipData = zstring.split(v, ":")
                        local ship = {}
                        ship.ship_template_id = shipData[1]
                        ship.evolution_status = shipData[3]
                        ship.Order = shipData[5]
                        ship.StarRating = shipData[4]
                        ship.ship_grade = shipData[2]
                        ship.ship_id = -1
                        ship.skin_id = shipData[11]
                        local cell = ShipIconCell:createCell()
                        cell:init(ship,10)
                        panel_wujiang:addChild(cell)
                        table.insert(cell_list, cell)
                        neWshowShipStar(ccui.Helper:seekWidgetByName(cell.roots[1],"Panel_star"),tonumber(ship.StarRating))
                        cell:setVisible(false)
                    end
                else
                   for i, v in pairs(leftInfo) do
                        local shipData = zstring.split(v, ":")
                        local ship = {}
                        ship.ship_template_id = shipData[1]
                        ship.evolution_status = shipData[3]
                        ship.Order = shipData[5]
                        ship.StarRating = shipData[4]
                        ship.ship_grade = shipData[2]
                        ship.ship_id = -1
                        ship.skin_id = shipData[11]
                        local cell = ShipIconCell:createCell()
                        cell:init(ship, 10)
                        ListView_digimon_icon_1:addChild(cell)
                        table.insert(ship_list, cell)
                        neWshowShipStar(ccui.Helper:seekWidgetByName(cell.roots[1],"Panel_star"),tonumber(ship.StarRating))
                        cell:setVisible(false)
                    end 
                end
                
            end

            --对方de阵容
            if formationInfo[2] ~= nil then
                local rightInfo = zstring.split(formationInfo[2], "!")
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                    for i, v in pairs(rightInfo) do
                        local panel_wujiang = ccui.Helper:seekWidgetByName(root,string.format("Panel_digimon_icon_0_%d", i))
                        local shipData = zstring.split(v, ":")
                        local ship = {}
                        ship.ship_template_id = shipData[1]
                        ship.evolution_status = shipData[3]
                        ship.Order = shipData[5]
                        ship.StarRating = shipData[4]
                        ship.ship_grade = shipData[2]
                        ship.ship_id = -1
                        ship.skin_id = shipData[11]
                        local cell = ShipIconCell:createCell()
                        cell:init(ship,10)
                        panel_wujiang:addChild(cell)
                        table.insert(cell_list, cell)
                        neWshowShipStar(ccui.Helper:seekWidgetByName(cell.roots[1],"Panel_star"),tonumber(ship.StarRating))
                        cell:setVisible(false)
                    end
                else
                    for i, v in pairs(rightInfo) do
                        local shipData = zstring.split(v, ":")
                        local ship = {}
                        ship.ship_template_id = shipData[1]
                        ship.evolution_status = shipData[3]
                        ship.Order = shipData[5]
                        ship.StarRating = shipData[4]
                        ship.ship_grade = shipData[2]
                        ship.ship_id = -1
                        ship.skin_id = shipData[11]
                        local cell = ShipIconCell:createCell()
                        cell:init(ship,10)
                        ListView_digimon_icon_2:addChild(cell)
                        table.insert(cell_list, cell)
                        neWshowShipStar(ccui.Helper:seekWidgetByName(cell.roots[1],"Panel_star"),tonumber(ship.StarRating))
                        cell:setVisible(false)
                    end
                end
            end
        end
    end
    self.actions[1]:play("text_open", false)
    self.actions[1]:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "icon_open" then
            --开始绘制角色头像和奖励图标依次出现的动画
            for i, v in pairs(ship_list) do
                if #ship_list >= 1 then
                    local t = 0.1 + 0.5 * (i - 1)
                    v:runAction(cc.Sequence:create({cc.DelayTime:create(t/2), cc.ScaleTo:create(0.01, 1.05), cc.CallFunc:create(function ( sender )
                        sender:setVisible(true)
                    end), cc.ScaleTo:create(0.1, 1)}))
                end
            end
            ListView_digimon_icon_1:requestRefreshView()

            for i, v in pairs(cell_list) do
                if #cell_list >= 1 then
                    local t = 0.3 + 0.5 * (i - 1)
                    v:runAction(cc.Sequence:create({cc.DelayTime:create(t/2), cc.ScaleTo:create(0.01, 1.05), cc.CallFunc:create(function ( sender )
                        sender:setVisible(true)
                    end), cc.ScaleTo:create(0.1, 1)}))
                end
            end
            ListView_digimon_icon_2:requestRefreshView()
        end
        
    end)
    if _ED.battle_playback_arena.playback == true then
        ccui.Helper:seekWidgetByName(root,"Button_playback"):setVisible(true)
    else
        ccui.Helper:seekWidgetByName(root,"Button_playback"):setVisible(false)   
    end
    
end

function SmArenaBattleReward:init(params)
    self.battle_type = params
    self:onInit()
    return self
end

function SmArenaBattleReward:onInit()
    local csbSmArenaBattleReward = csb.createNode("battle/sm_battle_victory_in_arena.csb")
    local root = csbSmArenaBattleReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmArenaBattleReward)
    local action = csb.createTimeline("battle/sm_battle_victory_in_arena.csb")
    table.insert(self.actions, action)
    csbSmArenaBattleReward:runAction(action)
    playEffect(formatMusicFile("effect", 9996))
    self:onUpdateDraw()
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_exit"), nil, 
    {
        terminal_name = "sm_arena_battle_reward_drop_out",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)

    --再看一次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_playback"), nil, 
    {
        terminal_name = "sm_arena_battle_reward_play_again",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)

    -- 战报统计
    local Button_damage = ccui.Helper:seekWidgetByName(root,"Button_damage")
    if Button_damage then
        if _ED.battle_report_info ~= nil then
            Button_damage:setVisible(true)
            fwin:addTouchEventListener(Button_damage, nil, 
            {
                terminal_name = "sm_arena_battle_go_to_report", 
                battle_type = self.battle_type,
                isPressedActionEnabled = true,
            },
            nil,0)
        else
            Button_damage:setVisible(false)
        end
    end

    if ccui.Helper:seekWidgetByName(root, "Button_show") ~= nil then
        ccui.Helper:seekWidgetByName(root, "Button_show"):setTouchEnabled(true)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_show"), nil, 
        {
            terminal_name = "share_click_on", 
            isPressedActionEnabled = true
        },
        nil,0)
    end

    if ccui.Helper:seekWidgetByName(root, "Button_show") ~= nil then
            ccui.Helper:seekWidgetByName(root, "Button_show"):setVisible(false)

    end
end

function SmArenaBattleReward:onExit()
    state_machine.remove("sm_arena_battle_reward_display")
    state_machine.remove("sm_arena_battle_reward_hide")
    state_machine.remove("sm_arena_battle_go_to_report")
    
    _ED.chat_user_info = {}
end