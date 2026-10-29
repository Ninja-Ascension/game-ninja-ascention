-- ----------------------------------------------------------------------------------------------------
-- 说明：角色进化
-------------------------------------------------------------------------------------------------------
GeneralsEvoChainWindow = class("GeneralsEvoChainWindowClass", Window)

local generals_evo_chain_window_open_terminal = {
    _name = "generals_evo_chain_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("GeneralsEvoChainWindowClass")
        if nil == _homeWindow then
            local panel = GeneralsEvoChainWindow:new():init(params)
            fwin:open(panel, fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local generals_evo_chain_window_close_terminal = {
    _name = "generals_evo_chain_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("HeroIconListViewClass") ~= nil then
            fwin:find("HeroIconListViewClass"):setVisible(true)
        end
		local _homeWindow = fwin:find("GeneralsEvoChainWindowClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("GeneralsEvoChainWindowClass"))
        end
        state_machine.excute("notification_center_update",0,"push_notification_center_formation_ship_evo")
        state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_ship_evo")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(generals_evo_chain_window_open_terminal)
state_machine.add(generals_evo_chain_window_close_terminal)
state_machine.init()
    
function GeneralsEvoChainWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship = nil
    self.isEvo = false
    self.armature_hero = {}

    local function init_generals_evo_chain_window_terminal()
        -- 显示界面
        local generals_evo_chain_window_display_terminal = {
            _name = "generals_evo_chain_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local generals_evo_chain_window_hide_terminal = {
            _name = "generals_evo_chain_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 请求战斗
        local generals_evo_chain_window_battle_terminal = {
            _name = "generals_evo_chain_window_battle",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- local function responseCallback(response)
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         if response.node ~= nil and response.node.roots[1] ~= nil then
                --             response.node:onUpdateDraw()

                --         end
                --     end
                -- end    
                -- local ship_evo = zstring.split(params._datas.ship.evolution_status, "|")
                -- protocol_command.ship_evolution.param_list = "" .. params._datas.ship.ship_id.."\r\n1\r\n"..(tonumber(ship_evo[1])+1)
                -- NetworkManager:register(protocol_command.ship_evolution.code, nil, nil, nil, instance, responseCallback, true, nil)
                
                local ship_evo = zstring.split(params._datas.ship.evolution_status, "|")
                if tonumber(ship_evo[1]) >= 4 then
                    return
                end
                local evo_image = dms.string(dms["ship_mould"], params._datas.ship.ship_template_id, ship_mould.fitSkillTwo)
                local evo_pve = zstring.split(evo_image, ",")[(tonumber(ship_evo[1])+1)]
                local npc_id = dms.int(dms["ship_evo_mould"], evo_pve, ship_evo_mould.evolution_id)
                if zstring.tonumber(npc_id) < 0 then
                    return
                end
                _ED.m_activity_battle_fight_type_212_list = params._datas.ship.ship_id
                if zstring.tonumber(_ED.user_info.user_food) < dms.int(dms["npc"], npc_id, npc.attack_need_food) then
                    app.load("client.cells.prop.prop_buy_prompt")
                    
                    local config = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
                    local mid = zstring.tonumber(config[15])
                    
                    local win = PropBuyPrompt:new()
                    win:init(mid)
                    fwin:open(win, fwin._ui)
                    state_machine.unlock("generals_evo_chain_window_battle")
                    return
                end

                for i = 1, 6 do
                    _ED.formetion[i + 1] = 0
                    _ED.user_formetion_status[i] = 0
                    if i == 2 then
                        local ship = params._datas.ship
                        if nil ~= ship then
                            _ED.formetion[i + 1] = ship.ship_id
                            _ED.user_formetion_status[i] = ship.ship_id
                        end
                    end
                end
                _ED._current_scene_id = dms.int(dms["npc"], npc_id, npc.scene_id)
                _ED._scene_npc_id = npc_id
                _ED._npc_difficulty_index = "1"
                
                app.load("client.battle.fight.FightEnum")
                local function responseBattleStartCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.battle.report.BattleReport")

                        local resultBuffer = {}
                        if _ED._fightModule == nil then
                            _ED._fightModule = FightModule:new()
                        end
                        _ED.attackData = {
                            roundCount = _ED._fightModule.totalRound,
                            roundData ={}
                        }
                        if _ED._scene_npc_id == nil or _ED._scene_npc_id == "" or tonumber(_ED._scene_npc_id) == 0 then
                            _ED._scene_npc_id = _ED._scene_npc_copy_net_id
                        end

                        _ED._fightModule:initFight(_ED._scene_npc_id, _ED._npc_difficulty_index, _enum_fight_type._fight_type_212, resultBuffer)
                        local orderList = {}
                        _ED._fightModule:initFightOrder(_ED.user_info, orderList)
                        
                        cacher.removeAllTextures()
                        fwin:cleanView(fwin._windows)
                        cc.Director:getInstance():purgeCachedData()
                        
                        app.load("client.battle.BattleStartEffect")
                        local bse = BattleStartEffect:new()
                        bse:init(_enum_fight_type._fight_type_212)
                        fwin:open(bse, fwin._windows)
                        state_machine.unlock("generals_evo_chain_window_battle")
                    else
                        state_machine.unlock("generals_evo_chain_window_battle")
                        _ED._current_scene_id = ""
                        _ED._scene_npc_id = ""
                        _ED._npc_difficulty_index = ""
                    end
                end

                local formationInfo = ""
                _ED.battle_formetion_exp = {}
                for i, v in pairs(_ED.user_formetion_status) do
                    if zstring.tonumber(v) > 0 then
                        table.insert(_ED.battle_formetion_exp, _ED.user_ship[""..v].exprience)
                    else
                        table.insert(_ED.battle_formetion_exp, 0)
                    end
                    local ship = _ED.user_ship[""..v]
                    if ship ~= nil then
                        if formationInfo == "" then
                            formationInfo = ship.ship_template_id..","..ship.ship_grade..","..ship.StarRating..","..ship.Order
                        else
                            formationInfo = formationInfo.."|"..ship.ship_template_id..","..ship.ship_grade..","..ship.StarRating..","..ship.Order
                        end
                    else
                        if formationInfo == "" then
                            formationInfo = "0,0,0,0"
                        else
                            formationInfo = formationInfo.."|".."0,0,0,0"
                        end
                    end
                end
                _ED.show_reward_list_group = {}
                _ED.show_reward_list_group_ex = {}
                _ED.battle_evo_ship_info = params._datas.ship
                protocol_command.battle_result_start.param_list = "".._enum_fight_type._fight_type_212.."\r\n".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n0\r\n"..formationInfo
                NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, nil, responseBattleStartCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 请求进化
        local generals_evo_chain_window_evo_terminal = {
            _name = "generals_evo_chain_window_evo",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("generals_evo_chain_window_evo")
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots[1] ~= nil then
                            instance.newship = params._datas.ship
                            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece  then
                                instance:addMp4Draw()
                            else
                                state_machine.excute("generals_evo_chain_window_evo_mp4_over", 0, 0)
                            end
                        else
                            state_machine.unlock("generals_evo_chain_window_evo")
                        end
                        -- state_machine.excute("formation_update_ship_info", 0, {isChange = true})
                        setShipPushData(params._datas.ship.ship_id,6,-1)
                        -- state_machine.excute("sm_role_strengthen_tab_play_control_effect", 0, 0)
                        state_machine.excute("hero_icon_listview_icon_push_updata",0,"hero_icon_listview_icon_push_updata.")
                    else
                        state_machine.unlock("generals_evo_chain_window_evo")
                    end
                end
                local ship_evo = zstring.split(params._datas.ship.evolution_status, "|")
                protocol_command.ship_evolution.param_list = "" .. params._datas.ship.ship_id.."\r\n0\r\n"..(tonumber(ship_evo[1])+1)
                NetworkManager:register(protocol_command.ship_evolution.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 进化后的界面
        local generals_evo_chain_window_evo_mp4_over_terminal = {
            _name = "generals_evo_chain_window_evo_mp4_over",
            _init = function (terminal) 
                app.load("client.packs.hero.GeneralsEvoSuccessWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.roots[1]:getChildByTag(1024) ~= nil then 
                    instance.roots[1]:removeChildByTag(1024)
                end
                instance.ship.evolution_status = _ED.user_ship[""..instance.ship.ship_id].evolution_status
                instance.isEvo = false
                instance:onUpdateDraw()
                local formationWin = fwin:find("FormationTigerGateClass")
                if formationWin ~= nil then
                    formationWin.isUpdateShowShip = true
                end
                if fwin:find("HeroDevelopClass") ~= nil then
                    state_machine.excute("hero_develop_update_hero",0,"")   
                    state_machine.excute("hero_develop_page_strength_to_update_all_icon",0,instance.newship)
                    state_machine.excute("sm_role_strengthen_tab_update_ship_info",0,{instance.ship.ship_id})
                else
                    state_machine.excute("formation_set_ship", 0, _ED.user_ship[""..instance.ship.ship_id])
                    state_machine.excute("formation_update_ship_info", 0, {isChange = true})
                    state_machine.excute("hero_icon_listview_update_all_icon",0,instance.newship)
                end
                -- state_machine.excute("formation_hero_info_change",0,{instance.newship.ship_id}) 
                state_machine.excute("home_hero_refresh_draw",0,"")        
                state_machine.excute("generals_evo_success_window_open",0,{instance.newship})    
                -- state_machine.excute("hero_icon_listview_update_all_icon",0,instance.newship)   
                state_machine.unlock("generals_evo_chain_window_evo")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --播放点击后的卡牌动画
        local generals_evo_chain_window_draw_animation_terminal = {
            _name = "generals_evo_chain_window_draw_animation",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = tonumber(params._datas.index)
                -- local function changeActionCallback( armatureBack ) 
                --     csb.animationChangeToAction(instance.armature_hero[index], 0, 0, false)
                -- end
                -- instance.armature_hero[index]._invoke = changeActionCallback
                -- instance.armature_hero[index]:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                csb.animationChangeToAction(instance.armature_hero[index], 14, 0, false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local generals_evo_chain_window_evo_mp4_stop_terminal = {
            _name = "generals_evo_chain_window_evo_mp4_stop",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                againPlayBgm()
                state_machine.excute("generals_evo_chain_window_evo_mp4_over", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(generals_evo_chain_window_display_terminal)
        state_machine.add(generals_evo_chain_window_hide_terminal)
        state_machine.add(generals_evo_chain_window_battle_terminal)
        state_machine.add(generals_evo_chain_window_evo_terminal)
        state_machine.add(generals_evo_chain_window_evo_mp4_over_terminal)
        state_machine.add(generals_evo_chain_window_draw_animation_terminal)
        state_machine.add(generals_evo_chain_window_evo_mp4_stop_terminal)
        
        state_machine.init()
    end
    init_generals_evo_chain_window_terminal()
end

--添加mp4
function GeneralsEvoChainWindow:addMp4Draw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    playEffect(formatMusicFile("effect", 9978))
    local jsonFile = "images/ui/effice/effect_jinghua/effect_jinghua.json"
    local atlasFile = "images/ui/effice/effect_jinghua/effect_jinghua.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    local function changeActionCallback( armatureBack )
        armatureBack:removeFromParent(true)
        state_machine.excute("generals_evo_chain_window_evo_mp4_over", 0, 0)
    end
    animation.animationNameList = {"animation"}
    sp.initArmature(animation, false)
    animation._invoke = changeActionCallback
    self:addChild(animation)
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(animation, 0, 0, false)
    animation:setPosition(cc.p(self:getContentSize().width/2,self:getContentSize().height/2))


    -- local m_layer = cc.Layer:create()
    -- local m_size = root:getContentSize()
    -- m_layer:removeAllChildren(true)
    -- m_layer:setContentSize(cc.size(m_size.width - app.baseOffsetX, m_size.height))
    -- m_layer:setPosition(cc.p(0,0))
    -- m_layer:setTag(1024)
    -- m_layer:setTouchEnabled(true)
    -- root:addChild(m_layer)

    -- stopBgm()
    -- stopEffect()
    -- stopAllEffects()
    -- drawVideoFullPath("video/jinhua.mp4",1,m_layer,"generals_evo_chain_window_evo_mp4_over")

    -- fwin:addTouchEventListener(m_layer, nil, 
    -- {
    --     terminal_name = "generals_evo_chain_window_evo_mp4_stop"
    -- }, 
    -- nil, 0)

end

function GeneralsEvoChainWindow:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local shipInfo = self.ship
    local ship_template_id = nil
    local isMould = false
    if type(self.ship) == "number" or self.ship.ship_template_id == nil then
        isMould = true
        ship_template_id = self.ship
    else
        isMould = false
        ship_template_id = shipInfo.ship_template_id
    end
    local Panel_yagushou = ccui.Helper:seekWidgetByName(root, "Panel_yagushou")
    if Panel_yagushou ~= nil then
        Panel_yagushou:setVisible(false)
        local specialShips = zstring.split(dms.string(dms["ship_config"], 32, ship_config.param), ",")
        for k,v in pairs(specialShips) do
            if tonumber(v) == tonumber(ship_template_id) then
                Panel_yagushou:setVisible(true)
                break
            end
        end
    end

    local init_name = ""        -- 初始形态名称
    local captain_name = dms.int(dms["ship_mould"], ship_template_id, ship_mould.captain_name)
    for i=1,4 do
        local Panel_evo_icon = ccui.Helper:seekWidgetByName(root,"Panel_evo_icon_"..i)

        local quality = dms.int(dms["ship_mould"], ship_template_id, ship_mould.ship_type)
        ----------------------新的数码的形象------------------------
        --进化形象
        local evo_image = dms.string(dms["ship_mould"], ship_template_id, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        
        local evo_mould_id = evo_info[i]
        if Panel_evo_icon ~= nil then
            Panel_evo_icon:setTouchEnabled(true)
            Panel_evo_icon:removeAllChildren(true)
            --新的形象编号
            local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
            draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_evo_icon, nil, nil, cc.p(0.5, 0))
            local armature_hero = sp.spine_sprite(Panel_evo_icon, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
            armature_hero:setScaleX(-1)
            self.armature_hero[i] = armature_hero
            armature_hero.animationNameList = spineAnimations
            sp.initArmature(self.armature_hero[i], true)

            armature_hero:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
            armature_hero._actionIndex = _enum_animation_l_frame_index.animation_standby
            armature_hero._nextAction = _enum_animation_l_frame_index.animation_standby
            armature_hero:getAnimation():playWithIndex(armature_hero._actionIndex)
        end

        local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name_"..i)
        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        local word_info = dms.element(dms["word_mould"], name_mould_id)
        local getPersonName = word_info[3]
        if Text_name ~= nil then
            Text_name:setString(getPersonName)
        end

        if i == captain_name then
            init_name = getPersonName
        end
    end
    if isMould == true then
        ccui.Helper:seekWidgetByName(root,"Panel_go"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Button_evo"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_evo_tips"):setString(string.format(_new_interface_text[15],init_name))
        return
    end

    --进化模板id
    local ship_evo = zstring.split(shipInfo.evolution_status, "|")
    local demandInfo = dms.string(dms["ship_config"], 3, ship_config.param)
    local info = zstring.split(dms.string(dms["ship_config"], 14, ship_config.param), "!")
    for k,v in pairs(info) do
        local shipInfo = zstring.split(v, ":")
        if tonumber(shipInfo[1]) == tonumber(ship_template_id) then
            demandInfo = shipInfo[2]
            break    
        end
    end
    local demands = zstring.split(demandInfo, "|")
    --绘制进化需求
    for i=1,3 do
        local Panel_evo_condition = ccui.Helper:seekWidgetByName(root,"Panel_evo_condition_"..i)
        local Text_condition_1 = ccui.Helper:seekWidgetByName(root,"Text_condition_"..i.."_1")
        local Text_condition_2 = ccui.Helper:seekWidgetByName(root,"Text_condition_"..i.."_2")
        local demandData = zstring.split(demands[i+1], ",")
        if Text_condition_1 ~= nil then
            Text_condition_1:setString(string.format(_new_interface_text[1],zstring.tonumber(demandData[1])))
        end
        if Text_condition_2 ~= nil then
            Text_condition_2:setString(string.format(_new_interface_text[2],zstring.tonumber(demandData[2])))
        end
        
        if tonumber(ship_evo[1]) < 4 and tonumber(ship_evo[1]) == i then
            if Panel_evo_condition ~= nil then
                Panel_evo_condition:setVisible(true)
            end
            if Text_condition_1 ~= nil then
                if tonumber(shipInfo.ship_grade) >= zstring.tonumber(demandData[1]) then
                    Text_condition_1:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
                else
                    Text_condition_1:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
                end
            end
            if Text_condition_2 ~= nil then
                if tonumber(shipInfo.StarRating) >= zstring.tonumber(demandData[2]) then
                    Text_condition_2:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
                else
                    Text_condition_2:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
                end
            end
            if tonumber(shipInfo.ship_grade) >= zstring.tonumber(demandData[1]) and tonumber(shipInfo.StarRating) >= zstring.tonumber(demandData[2]) then
            -- if tonumber(shipInfo.ship_grade) >= 0 and tonumber(shipInfo.StarRating) >= 0 then
                self.isEvo = true
            end
        else
            if Panel_evo_condition ~= nil then
                Panel_evo_condition:setVisible(false)    
            end
        end
        local Image_arrow = ccui.Helper:seekWidgetByName(root,"Image_arrow_"..i)
        local Image_arrow_light = ccui.Helper:seekWidgetByName(root,"Image_arrow_light_"..i)
        if Image_arrow ~= nil then
            if tonumber(ship_evo[1]) < 4 and tonumber(ship_evo[1]) == i then
                Image_arrow:setVisible(false)
                Image_arrow_light:setVisible(true)
            else
                Image_arrow:setVisible(true)
                Image_arrow_light:setVisible(false)    
            end
        end
    end
    local evo_pve = zstring.split(ship_evo[2], ",")
    if self.isEvo == true and tonumber(ship_evo[1]) < 4 then
        ccui.Helper:seekWidgetByName(root,"Text_evo_tips"):setString("")
        ccui.Helper:seekWidgetByName(root,"Text_npc_name"):setString(_new_interface_text[4])
        --进化副本进度
        if tonumber(evo_pve[tonumber(ship_evo[1])+1]) > 0 then
            ccui.Helper:seekWidgetByName(root,"Text_progress"):setString("1/1")
            ccui.Helper:seekWidgetByName(root,"Panel_go"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Button_evo"):setVisible(true)
        else
            ccui.Helper:seekWidgetByName(root,"Text_progress"):setString("0/1")
            ccui.Helper:seekWidgetByName(root,"Panel_go"):setVisible(true)
            ccui.Helper:seekWidgetByName(root,"Button_evo"):setVisible(false)
            -- state_machine.excute("generals_evo_chain_window_battle",0,{_datas = {ship = self.ship}}) 
        end
    else
        ccui.Helper:seekWidgetByName(root,"Text_evo_tips"):setString(_new_interface_text[3])
        ccui.Helper:seekWidgetByName(root,"Text_npc_name"):setString("")
        ccui.Helper:seekWidgetByName(root,"Text_progress"):setString("")
        ccui.Helper:seekWidgetByName(root,"Panel_go"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Button_evo"):setVisible(false)
    end
end

function GeneralsEvoChainWindow:UpdateShowLoading()
    local root = self.roots[1]
    if root == nil then 
        return
    end

end
-- function GeneralsEvoChainWindow:showImageAnimation()
--     local root = self.roots[1]
--     if root == nil then 
--         return
--     end
--     local shipInfo = _ED.user_ship[""..self.ship_id]
--     if shipInfo == nil then
--         return
--     end

-- end

function GeneralsEvoChainWindow:init(params)
    self.ship = params[1]
    self:onInit()
    return self
end

function GeneralsEvoChainWindow:onInit()
    _ED.user_formetion_status_copy = {}
    _ED.formetion_copy = {}
    table.merge(_ED.user_formetion_status_copy, _ED.user_formetion_status)
    table.merge(_ED.formetion_copy, _ED.formetion)

    local csbGeneralsEvoChainWindow = csb.createNode("packs/HeroStorage/generals_evo_chain_window.csb")
    local root = csbGeneralsEvoChainWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbGeneralsEvoChainWindow)
	
    self:onUpdateDraw()
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_closed"), nil, 
    {
        terminal_name = "generals_evo_chain_window_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 3)


    --战斗
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_go"), nil, 
    {
        terminal_name = "generals_evo_chain_window_battle", 
        terminal_state = 0,
        ship = self.ship,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    --不战斗
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_no_go"), nil, 
    {
        terminal_name = "generals_evo_chain_window_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    --进化请求
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_evo"), nil, 
    {
        terminal_name = "generals_evo_chain_window_evo", 
        terminal_state = 0,
        ship = self.ship,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    for i=1, 4 do
        local Panel_evo_icon = ccui.Helper:seekWidgetByName(root,"Panel_evo_icon_"..i)
        if Panel_evo_icon ~= nil then
            Panel_evo_icon:setTouchEnabled(true)
            fwin:addTouchEventListener(Panel_evo_icon, nil, 
            {
                terminal_name = "generals_evo_chain_window_draw_animation", 
                terminal_state = 0,
                index = i,
                isPressedActionEnabled = true
            }, 
            nil, 0)
        end
    end
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    -- {
        -- terminal_name = "red_alert_time_mine_help_info_close",
        -- terminal_state = 0,
    -- },
    -- nil,3)
	
end

function GeneralsEvoChainWindow:onExit()
    if nil ~= _ED.user_formetion_status_copy then
        _ED.user_formetion_status = _ED.user_formetion_status_copy
        _ED.user_formetion_status_copy = nil
    end
    if nil ~= _ED.formetion_copy then
        _ED.formetion = _ED.formetion_copy
        _ED.formetion_copy = nil
    end
    state_machine.remove("generals_evo_chain_window_battle")
    state_machine.remove("generals_evo_chain_window_hide")
    state_machine.remove("generals_evo_chain_window_display")
    state_machine.remove("generals_evo_chain_window_evo")

end

function GeneralsEvoChainWindow:destroy( window )
    if nil ~= sp.SkeletonRenderer.clear then
          sp.SkeletonRenderer:clear()
    end     
    cacher.removeAllTextures()     
    audioUtilUncacheAll() 
end