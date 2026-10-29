-- ----------------------------------------------------------------------------------------------------
-- 说明：公会工会NPC出战
-------------------------------------------------------------------------------------------------------
SmUnionPveBattleWindow = class("SmUnionPveBattleWindowClass", Window)

local sm_union_pve_battle_window_open_terminal = {
    _name = "sm_union_pve_battle_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionPveBattleWindowClass")
        if nil == _homeWindow then
            local panel = SmUnionPveBattleWindow:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_pve_battle_window_close_terminal = {
    _name = "sm_union_pve_battle_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionPveBattleWindowClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionPveBattleWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_pve_battle_window_open_terminal)
state_machine.add(sm_union_pve_battle_window_close_terminal)
state_machine.init()
    
function SmUnionPveBattleWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    app.load("client.cells.utils.resources_icon_cell")
    self.reworld_sorting = {}
    local function init_sm_union_pve_battle_window_terminal()
        -- 显示界面
        local sm_union_pve_battle_window_display_terminal = {
            _name = "sm_union_pve_battle_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionPveBattleWindowWindow = fwin:find("SmUnionPveBattleWindowClass")
                if SmUnionPveBattleWindowWindow ~= nil then
                    SmUnionPveBattleWindowWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_pve_battle_window_hide_terminal = {
            _name = "sm_union_pve_battle_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionPveBattleWindowWindow = fwin:find("SmUnionPveBattleWindowClass")
                if SmUnionPveBattleWindowWindow ~= nil then
                    SmUnionPveBattleWindowWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_union_pve_battle_window_formation_change_terminal = {
            _name = "sm_union_pve_battle_window_formation_change",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local isNull = true
                for i,v in pairs(_ED.user_formetion_status) do
                    if tonumber(v) > 0 then
                        isNull = false
                        break
                    end
                end
                if isNull == true then
                    TipDlg.drawTextDailog(_string_piece_info[395])
                    return
                end
                -- app.load("client.formation.FormationChange")
                -- state_machine.excute("formation_change_window_open", 0, {"sm_union_pve_battle_window_join_battle", "sm_union_pve_battle_window_formation_change_request", "battle_ready_window_formation_change_back"})
                state_machine.excute("sm_union_pve_battle_window_formation_change_request", 0, "")
                state_machine.excute("sm_union_pve_battle_window_join_battle", 0, "")
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_union_pve_battle_window_join_battle_terminal = {
            _name = "sm_union_pve_battle_window_join_battle",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("sm_union_pve_battle_window_join_battle")

                instance:fight()
                -- -- 战斗请求
                -- local function responseBattleInitCallback(response)
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         --state_machine.excute("page_stage_fight_data_deal", 0, 0)
                    
                --         cacher.removeAllTextures()
                        
                --         fwin:cleanView(fwin._windows)
                --         cc.Director:getInstance():purgeCachedData()
                        
                --         -- 记录上次战斗是否选择的最后的NPC
                --         LDuplicateWindow._infoDatas._isLastNpc = instance.npcState == 1 and true or false
                --         LDuplicateWindow._infoDatas._isNewNPCAction = false
                        
                --         local bse = BattleStartEffect:new()
                --         bse:init(7)
                --         fwin:open(bse, fwin._windows)
                --     end
                -- end

                -- local function responseBattleStartCallback( response )
                --     state_machine.unlock("sm_union_pve_battle_window_join_battle")
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         app.load("client.battle.report.BattleReport")
                --         app.load("client.battle.BattleStartEffect")

                --         _ED.user_info.last_user_grade = _ED.user_info.user_grade
                --         _ED.user_info.last_user_experience = _ED.user_info.user_experience
                --         _ED.user_info.last_user_grade_need_experience = _ED.user_info.user_grade_need_experience
                        
                --         local resultBuffer = {}
                --         if _ED._fightModule == nil then
                --             _ED._fightModule = FightModule:new()
                --         end
                --         _ED.attackData = {
                --             roundCount = _ED._fightModule.totalRound,
                --             roundData ={}
                --         }
                --         if _ED._scene_npc_id == nil or _ED._scene_npc_id == "" or tonumber(_ED._scene_npc_id) == 0 then
                --             _ED._scene_npc_id = _ED._scene_npc_copy_net_id
                --         end
                --         local fightType = _enum_fight_type._fight_type_7
                --         _ED._fightModule:initFight(_ED._scene_npc_id, _ED._npc_difficulty_index, fightType, resultBuffer)
                --         local orderList = {}
                --         _ED._fightModule:initFightOrder(_ED.user_info, orderList)
                        
                --         responseBattleInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                --     end
                -- end

                -- _ED._current_scene_id = 7
                -- _ED._scene_npc_id = _ED.union_pve_info[tonumber(instance.data_id)].id
                -- _ED._npc_difficulty_index = 1
                -- _ED.union_attack_npc_id = instance.npc_id
                -- _ED.union_attack_data_id = instance.data_id
                -- protocol_command.union_copy_fight.param_list = tonumber(instance.data_id)-1
                -- NetworkManager:register(protocol_command.union_copy_fight.code, nil, nil, nil, nil, responseBattleStartCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_union_pve_battle_window_formation_change_request_terminal = {
            _name = "sm_union_pve_battle_window_formation_change_request",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:formationChange(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_union_pve_battle_window_battle_ranking_terminal = {
            _name = "sm_union_pve_battle_window_battle_ranking",
            _init = function (terminal) 
                app.load("client.l_digital.union.duplicate.SmUnionMemberDamage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("sm_union_member_damage_open", 0, "")
                    end
                end
                protocol_command.union_copy_look_npc_info.param_list = "1".."\r\n"..tonumber(instance.data_id)-1
                NetworkManager:register(protocol_command.union_copy_look_npc_info.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_union_pve_battle_window_npc_reword_receive_terminal = {
            _name = "sm_union_pve_battle_window_npc_reword_receive",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local npcInfo = _ED.union_pve_info[tonumber(instance.data_id)]
                if tonumber(npcInfo.reworld_status) == 0 then
                    if tonumber(npcInfo.status) == 0 then
                        TipDlg.drawTextDailog(_new_interface_text[127])
                        return
                    end
                end
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(25,nil,instance.reworld_sorting)
                        -- getRewardWnd:init(25)
                        fwin:open(getRewardWnd, fwin._ui)
                        ccui.Helper:seekWidgetByName(instance.roots[1],"Button_lq"):setVisible(false)
                        ccui.Helper:seekWidgetByName(instance.roots[1],"Image_ylg"):setVisible(true)

                        state_machine.excute("sm_union_duplicate_show_one_click_btn", 0, nil)
                    end
                end
                protocol_command.union_copy_draw_npc_reward.param_list = tonumber(instance.data_id)-1
                NetworkManager:register(protocol_command.union_copy_draw_npc_reward.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_pve_battle_window_display_terminal)
        state_machine.add(sm_union_pve_battle_window_hide_terminal)
        state_machine.add(sm_union_pve_battle_window_formation_change_terminal)
        state_machine.add(sm_union_pve_battle_window_join_battle_terminal)
        state_machine.add(sm_union_pve_battle_window_formation_change_request_terminal)
        state_machine.add(sm_union_pve_battle_window_battle_ranking_terminal)
        state_machine.add(sm_union_pve_battle_window_npc_reword_receive_terminal)


        state_machine.init()
    end
    init_sm_union_pve_battle_window_terminal()
end

function SmUnionPveBattleWindow:fight() 
    -- 战斗请求
    local function responseBattleInitCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            --state_machine.excute("page_stage_fight_data_deal", 0, 0)
            state_machine.unlock("sm_union_pve_battle_window_join_battle")
            
            fwin:cleanView(fwin._windows)
            cc.Director:getInstance():purgeCachedData()
            cacher.removeAllTextures()
            
            local bse = BattleStartEffect:new()
            bse:init(7)
            fwin:open(bse, fwin._windows)
        end
    end

    
    local function launchBattle()
        app.load("client.battle.fight.FightEnum")
        local fightType = state_machine.excute("fight_get_current_fight_type", 0, nil)
        local function responseBattleStartCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            app.load("client.battle.report.BattleReport")
            app.load("client.battle.BattleStartEffect")

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
            local fightType = 0
            fightType = _enum_fight_type._fight_type_7
            _ED.union_copy_fight_data_id = tonumber(self.data_id)
            _ED._fightModule:initUninoFight(_ED._scene_npc_id, _ED._npc_difficulty_index, fightType, resultBuffer)
            
            local orderList = {}
            _ED._fightModule:initFightOrder(_ED.user_info, orderList)
            
            responseBattleInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
        else
            _ED._current_scene_id = ""
            _ED._scene_npc_id = ""
            _ED.trial_scene_npc_id = ""
            _ED._npc_difficulty_index = ""
            _ED.trial_star_Magnification = 1
        end
    end
    -- _ED.battleData.battle_init_type = _enum_fight_type._fight_type_102
    -- protocol_command.battle_result_start.param_list = "".._enum_fight_type._fight_type_102.."\r\n".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0"
    -- print("protocol_command.battle_result_start.param_list=="..protocol_command.battle_result_start.param_list)
    -- NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, nil, responseBattleStartCallback, true, nil)
    responseBattleStartCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
    end
    
    _ED._current_scene_id = 7
    _ED._scene_npc_id = _ED.union_pve_info[tonumber(self.data_id)].id
    _ED._npc_difficulty_index = 1
    if self.npc_id then
        _ED.union_attack_npc_id = self.npc_id
    end
    _ED.union_attack_data_id = self.data_id

    launchBattle()
end

function SmUnionPveBattleWindow:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local sceneMould = dms.element(dms["pve_scene"], 155)
    self.currentSceneType = dms.atoi(sceneMould, pve_scene.scene_type)
    --背景
    local Panel_battle_bg = ccui.Helper:seekWidgetByName(root, "Panel_battle_bg")
    if self.npc_id then
        local bg_id = dms.int(dms["npc"], zstring.tonumber(self.npc_id), npc.map_index)
    end
    --暂时没图
    -- Panel_battle_bg:removeBackGroundImage()
    -- Panel_battle_bg:setBackGroundImage(string.format("images/ui/function_icon/achieve_icon_%d.png", bg_id))
    --npc形象
    local Panel_npc_bighead = ccui.Helper:seekWidgetByName(root, "Panel_npc_bighead")
    if self.npc_id then
        local npc_pic = zstring.split(dms.string(dms["npc"], zstring.tonumber(self.npc_id), npc.head_pic),",")[2]
        Panel_npc_bighead:removeBackGroundImage()
        Panel_npc_bighead:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", npc_pic))
    end
    --npc说话框
    local Image_npc_dialog_bg = ccui.Helper:seekWidgetByName(root, "Image_npc_dialog_bg") 

    --npc说的话
    local Text_npc_dialog = ccui.Helper:seekWidgetByName(root, "Text_npc_dialog") 
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        if self.npc_id then
            local word_info = dms.element(dms["word_mould"], zstring.tonumber(dms.string(dms["npc"], zstring.tonumber(self.npc_id), npc.sign_msg)))
            Text_npc_dialog:setString(word_info[3])
        end
    else
        if self.npc_id then
            Text_npc_dialog:setString(dms.string(dms["npc"], zstring.tonumber(self.npc_id), npc.sign_msg))
        end
    end
    --挑战次数
    local Text_cishu = ccui.Helper:seekWidgetByName(root, "Text_cishu") 
    local maxBattleNumber = dms.int(dms["union_config"], 21, union_config.param)
    Text_cishu:setString((maxBattleNumber-_ED.union.user_union_info.duplicate_battle_count).."/"..maxBattleNumber)
    if (maxBattleNumber-_ED.union.user_union_info.duplicate_battle_count) > 0 then
        ccui.Helper:seekWidgetByName(root,"Button_fight"):setBright(true)
        ccui.Helper:seekWidgetByName(root,"Button_fight"):setTouchEnabled(true)
    else
        ccui.Helper:seekWidgetByName(root,"Button_fight"):setBright(false)
        ccui.Helper:seekWidgetByName(root,"Button_fight"):setTouchEnabled(false)
    end
    --npc的血
    local LoadingBar_npc_hp = ccui.Helper:seekWidgetByName(root, "LoadingBar_npc_hp") 
    local Text_npc_hp = ccui.Helper:seekWidgetByName(root, "Text_npc_hp")
    local npcInfo = _ED.union_pve_info[tonumber(self.data_id)]
    if not ncpInfo then
        local _homeWindow = fwin:find("SmUnionPveBattleWindowClass")
        if nil ~= _homeWindow then
            fwin:close(fwin:find("SmUnionPveBattleWindowClass"))
        end
    end
    if tonumber(npcInfo.max_hp) == 0 then
        LoadingBar_npc_hp:setPercent(100)
        Text_npc_hp:setString("100%")
    else
        LoadingBar_npc_hp:setPercent(math.ceil(tonumber(npcInfo.current_hp)/tonumber(npcInfo.max_hp)*100*100)/100)
        Text_npc_hp:setString((math.ceil(tonumber(npcInfo.current_hp)/tonumber(npcInfo.max_hp)*100*100)/100).."%")
    end
    _ED.union_pve_info_current_hp = tonumber(npcInfo.current_hp)
    --通关显示
    local isGetFristReward = false
    local stateInfo = zstring.split(_ED.union.user_union_info.npc_frist_reward_state, "|")
    if self.npc_id then
        for k,v in pairs(stateInfo) do
            v = zstring.split(v, ":")
            if tonumber(v[1]) == zstring.tonumber(self.npc_id) then
                if tonumber(v[2]) == 2 or tonumber(v[2]) == 3 then
                    isGetFristReward = true
                end
                break
            end
        end
    end
    if isGetFristReward == true then
        ccui.Helper:seekWidgetByName(root, "Image_icon_2"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Image_icon_1"):setVisible(false)
    else
        ccui.Helper:seekWidgetByName(root, "Image_icon_2"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Image_icon_1"):setVisible(true)
    end
    local Image_wmtg = ccui.Helper:seekWidgetByName(root, "Image_wmtg") 
    if tonumber(npcInfo.status) == 0 then
        Text_npc_hp:setVisible(true)
        LoadingBar_npc_hp:setVisible(true)
        Image_wmtg:setVisible(false)
    else
        Text_npc_hp:setVisible(false)
        LoadingBar_npc_hp:setVisible(false)
        Image_wmtg:setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Button_fight"):setBright(false)
        ccui.Helper:seekWidgetByName(root,"Button_fight"):setTouchEnabled(false)
    end
    --npc的名称
    if self.npc_id then
        local Text_npc_name = ccui.Helper:seekWidgetByName(root, "Text_npc_name") 
        local name_info = ""
        local name_data = zstring.split(dms.string(dms["npc"], zstring.tonumber(self.npc_id), npc.npc_name), "|")
        for i, v in pairs(name_data) do
            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
            name_info = name_info..word_info[3]
        end
        Text_npc_name:setString(name_info)
    end
    --特性介绍
    if self.npc_id then
        local Text_tx = ccui.Helper:seekWidgetByName(root, "Text_tx")
        local mould_id = dms.string(dms["npc"], zstring.tonumber(self.npc_id), npc.by_open_npc)
        local word_info = dms.element(dms["word_mould"], mould_id)
        Text_tx:setString(word_info[3])
    end
    --Boss特殊伤害奖励进度
    local LoadingBar_sh_jindu = ccui.Helper:seekWidgetByName(root, "LoadingBar_sh_jindu") 
    if tonumber(npcInfo.max_hp) == 0 then
        LoadingBar_sh_jindu:setPercent(0)
    else
        LoadingBar_sh_jindu:setPercent(string.format("%0.2f",100-tonumber(npcInfo.current_hp)/tonumber(npcInfo.max_hp)*100))
    end
    --Boss特殊伤害奖励
    local bossReworld = zstring.split(dms.string(dms["union_config"], 23, union_config.param),"!")
    --区间
    local rewordInterval = zstring.split(bossReworld[1],",")
    --奖励内容
    local rewordDatas = zstring.split(bossReworld[2],"|")
    local Panel_shipei_1 = ccui.Helper:seekWidgetByName(root, "Panel_shipei_1")
    for i=1,5 do
        --背景
        local Sprite_jl_bg = Panel_shipei_1:getChildByName("Sprite_jl_bg_"..i)
        local Panel_box_icon = Sprite_jl_bg:getChildByName("Panel_box_icon_"..i) 
        Panel_box_icon:removeAllChildren(true)
        local rewordInfo = zstring.split(rewordDatas[i],",")
        local cell = ResourcesIconCell:createCell()
        cell:init(tonumber(rewordInfo[1]), tonumber(rewordInfo[3]), tonumber(rewordInfo[2]),nil,nil,true,true)
        -- local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewordInfo[1],rewordInfo[2],rewordInfo[3]},false,true,false,true})
        Panel_box_icon:addChild(cell)
        if LoadingBar_sh_jindu:getPercent() >= tonumber(rewordInterval[i]) then
            display:ungray(Sprite_jl_bg)
            display:ungray(cell.panel_prop)
            display:ungray(cell.panel_ditu)
        else
            display:gray(Sprite_jl_bg)
            display:gray(cell.panel_prop)
            display:gray(cell.panel_ditu)
        end
    end

    --前3工会的信息
    -- local function sortFunc( a,b )
    --     return tonumber(a.new_hp) < tonumber(b.new_hp) 
    --         or (tonumber(a.new_hp) == tonumber(b.new_hp) and tonumber(a.kill_time) < tonumber(b.kill_time))
    -- end
    -- table.sort(_ED.union_battle_rank_list, sortFunc)
    for i=1, 3 do
        local Panel_legion = ccui.Helper:seekWidgetByName(root, "Panel_legion_"..i) 
        local  Panel_dh = ccui.Helper:seekWidgetByName(root, "Panel_dh_"..i) 
        Panel_dh:removeAllChildren(true)
        --进度
        local LoadingBar_gh_jd = ccui.Helper:seekWidgetByName(root, "LoadingBar_gh_jd_"..i) 
        local Text_gh_jd_n_ = ccui.Helper:seekWidgetByName(root, "Text_gh_jd_n_"..i) 
        --工会名称
        local Text_legion_name_1 = ccui.Helper:seekWidgetByName(root, "Text_legion_name_"..i) 
        --完美通关
        local Image_wmtg_1 = ccui.Helper:seekWidgetByName(root, "Image_wmtg_"..i)
        if i <= #_ED.union_battle_rank_list then
            Panel_legion:setVisible(true)
            LoadingBar_gh_jd:setVisible(true)
            Text_gh_jd_n_:setVisible(true)
            Text_legion_name_1:setVisible(true)
            Image_wmtg_1:setVisible(false)
            if tonumber(_ED.union_battle_rank_list[i].new_hp) == 0 
                and tonumber(_ED.union_battle_rank_list[i].new_hp) > 0 
                then
                LoadingBar_gh_jd:setPercent(100)
                Text_gh_jd_n_:setVisible(false)
                Image_wmtg_1:setVisible(true)
                local jsonFile = "sprite/spirte_wmtg.json"
                local atlasFile = "sprite/spirte_wmtg.atlas"
                local animation1 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                Panel_dh:addChild(animation1)
            elseif tonumber(_ED.union_battle_rank_list[i].max_hp) == 0 then
                LoadingBar_gh_jd:setPercent(0)
                Text_gh_jd_n_:setString("0%")
                Text_gh_jd_n_:setVisible(true)
                Image_wmtg_1:setVisible(false)
            else
                LoadingBar_gh_jd:setPercent((math.floor((tonumber(_ED.union_battle_rank_list[i].max_hp) - tonumber(_ED.union_battle_rank_list[i].new_hp))/tonumber(_ED.union_battle_rank_list[i].max_hp)*100*100)/100))
                Text_gh_jd_n_:setString((math.floor((tonumber(_ED.union_battle_rank_list[i].max_hp) - tonumber(_ED.union_battle_rank_list[i].new_hp))/tonumber(_ED.union_battle_rank_list[i].max_hp)*100*100)/100).."%")
                Text_gh_jd_n_:setVisible(true)
                Image_wmtg_1:setVisible(false)
            end
            Text_legion_name_1:setString(_ED.union_battle_rank_list[i].union_name)

        else
            Panel_legion:setVisible(false)
            LoadingBar_gh_jd:setVisible(false)
            Text_gh_jd_n_:setVisible(false)
            Text_legion_name_1:setVisible(false)
            Image_wmtg_1:setVisible(false)
        end

    end

    local stateInfo = zstring.split(_ED.union.user_union_info.npc_frist_reward_state, "|")
    local my_state = -1
    if self.npc_id then
        for k,v in pairs(stateInfo) do
            v = zstring.split(v, ":")
            if tonumber(v[1]) == zstring.tonumber(self.npc_id) then
                my_state = tonumber(v[2])
                break
            end
        end
        --0未领取 (任何) 1已领取首胜奖励 2未领取（非首胜）3已领取（领取非首胜）
        
        if my_state == 0 or my_state == 2 then
            ccui.Helper:seekWidgetByName(root,"Button_lq"):setVisible(true)
            ccui.Helper:seekWidgetByName(root,"Image_ylg"):setVisible(false)
            if tonumber(npcInfo.status) == 0 then
                ccui.Helper:seekWidgetByName(root,"Button_lq"):setBright(false)
                ccui.Helper:seekWidgetByName(root,"Button_lq"):setHighlighted(false)
            else
                ccui.Helper:seekWidgetByName(root,"Button_lq"):setBright(true)
                ccui.Helper:seekWidgetByName(root,"Button_lq"):setHighlighted(true)
            end
        elseif my_state == 1 or my_state == 3 then
            ccui.Helper:seekWidgetByName(root,"Button_lq"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_ylg"):setVisible(true)
        end
    end

    self:drawReworld()
end

function SmUnionPveBattleWindow:drawReworld()
    local root = self.roots[1]
    local npcInfo = _ED.union_pve_info[tonumber(self.data_id)]
    --击杀奖励列表
    local ListView_kill_reward = ccui.Helper:seekWidgetByName(root, "ListView_kill_reward") 
    ListView_kill_reward:removeAllItems()
    --先找到npc的首胜奖励库组
    if self.npc_id then
        local rewardID = nil
        local stateInfo = zstring.split(_ED.union.user_union_info.npc_frist_reward_state, "|")
        local isGetFristReward = false
        for k,v in pairs(stateInfo) do
            v = zstring.split(v, ":")
            if tonumber(v[1]) == zstring.tonumber(self.npc_id) then
                if tonumber(v[2]) == 2 or tonumber(v[2]) == 3 then
                    isGetFristReward = true
                end
                break
            end
        end
        if isGetFristReward == true then
            local sceneMould = dms.element(dms["pve_scene"], 155)
            local reworldData = zstring.split(dms.atos(sceneMould, pve_scene.design_reward),",")
            rewardID = tonumber(reworldData[tonumber(self.data_id)])
        else
            rewardID = dms.int(dms["npc"], zstring.tonumber(self.npc_id), npc.first_reward)
        end
        local index = 1
        if rewardID > 0 then
            local rewardInfoString = dms.string(dms["scene_reward_ex"], rewardID, scene_reward_ex.show_reward)
            local rewardInfoArr = zstring.split(rewardInfoString, "|")
            local index = 1
            local rewardTotal = 1
            for i, v in pairs(rewardInfoArr) do
                local info = zstring.split(v, ",")
                local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{info[2],info[1],info[3]},false,true,false,true})
                ListView_kill_reward:addChild(cell)
                if info[2] == "6" then
                    -- local cell = ResourcesIconCell:createCell()
                    local reawrdID = tonumber(info[1])
                    local rewardNum = tonumber(info[3])
                    -- cell:init(6, rewardNum, reawrdID,nil,nil,true,true)
                    -- -- cell:hideNameAndCount()
                    -- ListView_kill_reward:addChild(cell)
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                        then
                        local rewardinfo = {}
                        rewardinfo.type = 6
                        rewardinfo.id = reawrdID
                        rewardinfo.number = rewardNum
                        self.reworld_sorting[index] = rewardinfo
                        index = index + 1
                    end
                elseif info[2] == "7" then
                    local reawrdID = tonumber(info[1])
                    local rewardNum = tonumber(info[3])
                    local tmpTable = {
                        user_equiment_template = reawrdID,
                        mould_id = reawrdID,
                        user_equiment_grade = 1
                    }
                    
                    -- local eic = ResourcesIconCell:createCell()
                    -- -- eic:init(10, tmpTable, reawrdID, nil, false, rewardNum)
                    -- eic:init(7, rewardNum, reawrdID,nil,nil,true,true)
                    -- ListView_kill_reward:addChild(reward)
                    local rewardinfo = {}
                    rewardinfo.type = 7
                    rewardinfo.id = reawrdID
                    rewardinfo.number = rewardNum
                    self.reworld_sorting[index] = rewardinfo
                    index = index + 1
               else
                    -- local cell = ResourcesIconCell:createCell()
                    -- cell:init(info[2], tonumber(info[3]), -1,nil,nil,true,true)
                    -- cell:showName(-1, tonumber(info[2]))
                    -- ListView_kill_reward:addChild(cell)
                    local rewardinfo = {}
                    rewardinfo.type = info[2]
                    rewardinfo.id = -1
                    rewardinfo.number = tonumber(info[3])
                    self.reworld_sorting[index] = rewardinfo
                    index = index + 1
                end
                rewardTotal = rewardTotal + 1
            end
    end

    -------------------------------------------------------------------
        -- local rewardTotal = 1
        -- local rewardMoney = zstring.tonumber(dms.int(dms["scene_reward_ex"], rewardID, scene_reward_ex.reward_silver))
        -- local rewardGold = zstring.tonumber(dms.int(dms["scene_reward_ex"], rewardID, scene_reward_ex.reward_gold))
        -- local rewardHonor = zstring.tonumber(dms.int(dms["scene_reward_ex"], rewardID, scene_reward_ex.reward_honor))
        -- local rewardSoul = zstring.tonumber(dms.int(dms["scene_reward_ex"], rewardID, scene_reward_ex.reward_soul))
        -- local rewardJade = zstring.tonumber(dms.int(dms["scene_reward_ex"], rewardID, scene_reward_ex.reward_jade))
        -- local rewardItemListStr = dms.string(dms["scene_reward_ex"], rewardID, scene_reward_ex.reward_prop)
        -- local rewardEquListStr = dms.string(dms["scene_reward_ex"], rewardID, scene_reward_ex.reward_equipment)
        -- local rewardShipListStr = dms.string(dms["scene_reward_ex"], rewardID, scene_reward_ex.reward_ship)
        -- local rewardMaxJade = zstring.tonumber(dms.int(dms["scene_reward_ex"], rewardID, scene_reward_ex.reward_jade_max))
        -- local rewardMaxSoul = zstring.tonumber(dms.int(dms["scene_reward_ex"], rewardID, scene_reward_ex.reward_soul_max))
        
        -- local count = 1
        -- if rewardMoney > 0 then
        --     if count <= 4 then
        --         local reward = ResourcesIconCell:createCell()
        --         reward:init(1, rewardMoney, -1,nil,nil,true,true)
        --         ListView_kill_reward:addChild(reward)
        --         count = count + 1
        --         local rewardinfo = {}
        --         rewardinfo.type = 1
        --         rewardinfo.id = -1
        --         rewardinfo.number = rewardMoney
        --         self.reworld_sorting[index] = rewardinfo
        --         index = index + 1
        --     end
        -- end
        
        -- if rewardGold > 0 then
        --     if count <= 4 then
        --         local reward = ResourcesIconCell:createCell()
        --         reward:init(2, rewardGold, -1,nil,nil,true,true)
        --         ListView_kill_reward:addChild(reward)
        --         count = count + 1
        --         local rewardinfo = {}
        --         rewardinfo.type = 2
        --         rewardinfo.id = -1
        --         rewardinfo.number = rewardGold
        --         self.reworld_sorting[index] = rewardinfo
        --         index = index + 1
        --     end 
        -- end
        
        -- if rewardHonor > 0 then
        --     if count <= 4 then
        --         local reward = ResourcesIconCell:createCell()
        --         reward:init(3, rewardHonor, -1,nil,nil,true,true)
        --         ListView_kill_reward:addChild(reward)
        --         count = count + 1
        --         local rewardinfo = {}
        --         rewardinfo.type = 3
        --         rewardinfo.id = -1
        --         rewardinfo.number = rewardHonor
        --         self.reworld_sorting[index] = rewardinfo
        --         index = index + 1
        --     end 
        -- end
        
        -- if rewardSoul > 0 then
        --     if count <= 4 then
        --         local reward = ResourcesIconCell:createCell()
        --         reward:init(4, rewardSoul, -1,nil,nil,true,true)
        --         ListView_kill_reward:addChild(reward)
        --         count = count + 1
        --         local rewardinfo = {}
        --         rewardinfo.type = 4
        --         rewardinfo.id = -1
        --         rewardinfo.number = rewardSoul
        --         self.reworld_sorting[index] = rewardinfo
        --         index = index + 1
        --     end 

        -- else
            
        -- end

        -- if rewardJade~=nil and rewardJade > 0 then
        --     if count <= 4 then
        --         local reward = ResourcesIconCell:createCell()
        --         reward:init(5, rewardJade, -1,nil,nil,true,true)
        --         ListView_kill_reward:addChild(reward)
        --         count = count + 1
        --         local rewardinfo = {}
        --         rewardinfo.type = 5
        --         rewardinfo.id = -1
        --         rewardinfo.number = rewardJade
        --         self.reworld_sorting[index] = rewardinfo
        --         index = index + 1
        --     end 
        -- end

        -- --绘制道具
        -- if rewardItemListStr ~= nil and rewardItemListStr ~= 0 and rewardItemListStr ~= "" then
        -- ------------------------------------------------------------
        --     local rewardProp = zstring.split(rewardItemListStr, "|")
        --     if table.getn(rewardProp) > 0 then
        --         for i,v in pairs(rewardProp) do
        --             local rewardPropInfo = zstring.split(v, ",")
        --             if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
        --                 if count <= 4 then
        --                     local reward = ResourcesIconCell:createCell()
        --                     local reawrdID = tonumber(rewardPropInfo[2])
        --                     local rewardNum = tonumber(rewardPropInfo[1])
        --                     reward:init(6, rewardNum, reawrdID,nil,nil,true,true)
        --                     -- reward:init(23, {user_prop_template = reawrdID, prop_number = rewardNum}, nil, false)
        --                     ListView_kill_reward:addChild(reward)
        --                     count = count + 1
        --                     local rewardinfo = {}
        --                     rewardinfo.type = 6
        --                     rewardinfo.id = reawrdID
        --                     rewardinfo.number = rewardNum
        --                     self.reworld_sorting[index] = rewardinfo
        --                     index = index + 1
        --                 end 
        --             end
        --         end
        --     end
        -- --------------------------------------------------------
        -- end
        
        -- --绘制装备
        -- if rewardEquListStr ~= nil and rewardEquListStr ~= 0 and rewardEquListStr ~= "" then
        -- ------------------------------------------------------------
        --     local rewardProp = zstring.split(rewardEquListStr, "|")
        --     if table.getn(rewardProp) > 0 then
        --         for i,v in pairs(rewardProp) do
        --             local rewardPropInfo = zstring.split(v, ",")
        --             if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
        --                 if count <= 4 then
        --                     local reawrdID = tonumber(rewardPropInfo[2])
        --                     local rewardNum = tonumber(rewardPropInfo[1])*doublePower
        --                     local tmpTable = {
        --                         user_equiment_template = reawrdID,
        --                         mould_id = reawrdID,
        --                         user_equiment_grade = 1
        --                     }
                            
        --                     local eic = ResourcesIconCell:createCell()
        --                     -- eic:init(10, tmpTable, reawrdID, nil, false, rewardNum)
        --                     eic:init(7, rewardNum, reawrdID,nil,nil,true,true)
        --                     ListView_kill_reward:addChild(reward)
        --                     count = count + 1
        --                     local rewardinfo = {}
        --                     rewardinfo.type = 7
        --                     rewardinfo.id = reawrdID
        --                     rewardinfo.number = rewardNum
        --                     self.reworld_sorting[index] = rewardinfo
        --                     index = index + 1
        --                 end 
        --             end
        --         end
        --     end
        -- --------------------------------------------------------
        -- end
        
        -- --奖励武将 rewardShipListStr
        -- if rewardShipListStr ~= nil and rewardShipListStr ~= 0 and rewardShipListStr ~= "" then
        -- ------------------------------------------------------------
        --     local rewardProp = zstring.split(rewardShipListStr, "|")
        --     if table.getn(rewardProp) > 0 then
        --         for i,v in pairs(rewardProp) do
        --             local rewardPropInfo = zstring.split(v, ",")
        --             if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
        --                 -- app.load("client.cells.prop.prop_icon_cell")
        --                 -- 等级,数量,id,概率
        --                 if count <= 4 then
        --                     local reward = ResourcesIconCell:createCell()
        --                     local reawrdID = tonumber(rewardPropInfo[3])
        --                     local rewardLv = tonumber(rewardPropInfo[1])
        --                     local rewardNums = tonumber(rewardPropInfo[2])
        --                     -- reward:init(nil,13, reawrdID,rewardNums)
        --                     reward:init(13, rewardNums, reawrdID,nil,nil,true ,true)
        --                     ListView_kill_reward:addChild(reward)
        --                     count = count + 1
        --                     local rewardinfo = {}
        --                     rewardinfo.type = 13
        --                     rewardinfo.id = reawrdID
        --                     rewardinfo.number = rewardNum
        --                     self.reworld_sorting[index] = rewardinfo
        --                     index = index + 1
        --                 end 
        --             end
        --         end
        --     end
        -- --------------------------------------------------------
        -- end
    -------------------------------------------------------------------
    end
    ListView_kill_reward:requestRefreshView()
end

function SmUnionPveBattleWindow:formationChange(params)
    cc.UserDefault:getInstance():setStringForKey(getKey("union_copy_formation_status_info"), zstring.concat(_ED.user_formetion_status, ","))
    cc.UserDefault:getInstance():setStringForKey(getKey("union_copy_formation_info"), zstring.concat(_ED.formetion, ","))
end

function SmUnionPveBattleWindow:init(params)
    if params[1] then
        self.npc_id = params[1]
    end
    self.data_id = params[2]
    self:onInit()
    return self
end

function SmUnionPveBattleWindow:onInit()
    local csbSmUnionPveBattleWindow = csb.createNode("legion/sm_legion_pve_battle_window.csb")
    local root = csbSmUnionPveBattleWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionPveBattleWindow)
    self:onUpdateDraw()
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, 
    {
        terminal_name = "sm_union_pve_battle_window_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)

    -- 战斗
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_fight"), nil, 
    {
        terminal_name = "sm_union_pve_battle_window_formation_change",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,0)

    local npcInfo = _ED.union_pve_info[tonumber(self.data_id)]
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "sm_push_notification_center_union_duplicate_challenge",
        _widget = ccui.Helper:seekWidgetByName(root,"Button_fight"),
        _invoke = nil,
        _interval = 0.5,
        npc_index = npcInfo.index,})

    -- 领取奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_lq"), nil, 
    {
        terminal_name = "sm_union_pve_battle_window_npc_reword_receive",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "sm_push_notification_center_union_duplicate_reward",
        _widget = ccui.Helper:seekWidgetByName(root,"Button_lq"),
        _invoke = nil,
        _interval = 0.5,
        npc_index = npcInfo.index})

    -- 伤害排名 
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_shpm"), nil, 
    {
        terminal_name = "sm_union_pve_battle_window_battle_ranking",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,0)
    state_machine.excute("sm_union_user_topinfo_open",0,self)
end

function SmUnionPveBattleWindow:onExit()
    state_machine.remove("sm_union_pve_battle_window_display")
    state_machine.remove("sm_union_pve_battle_window_hide")
end