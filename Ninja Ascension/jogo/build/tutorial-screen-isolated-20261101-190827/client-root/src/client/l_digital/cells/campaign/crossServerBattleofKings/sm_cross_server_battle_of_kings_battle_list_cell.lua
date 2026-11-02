--------------------------------------------------------------------------------------------------------------
--  说明：王者之战战斗列表控件
--------------------------------------------------------------------------------------------------------------
SmCrossServerBattleOfKingsBattleListCell = class("SmCrossServerBattleOfKingsBattleListCellClass", Window)
SmCrossServerBattleOfKingsBattleListCell.__size = nil

--创建cell
local sm_cross_server_battle_of_kings_battle_list_cell_terminal = {
    _name = "sm_cross_server_battle_of_kings_battle_list_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmCrossServerBattleOfKingsBattleListCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(sm_cross_server_battle_of_kings_battle_list_cell_terminal)
state_machine.init()

function SmCrossServerBattleOfKingsBattleListCell:ctor()
    self.super:ctor()
    self.roots = {}
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.l_digital.campaign.crossServerBattleofKings.SmCrossServerBattleofKingsPrepareForTheGame")
    app.load("client.l_digital.campaign.crossServerBattleofKings.SmCrossServerBattleofKingsViewGeneralFormation")
    self.cd_time = 0
    self.m_overs = false
    self.isSettlement = false
    self.isAnimation = false    --倒计时动画
    self.is_attack = false
    self._other_userId = nil    --对手信息
    self._other_singletonId = nil
    self._other_server_number = nil
    self._other_info_data = nil
    self._my_info_data = nil    --我的信息
    self._update_interval = 2    
    self._update_time = self._update_interval  --刷新间隔    
    self._is_peak = false        --是否是巅峰之战 
     -- Initialize sm_cross_server_battle_of_kings_battle_list_cell state machine.
    local function init_sm_cross_server_battle_of_kings_battle_list_cell_terminal()
        --
        local sm_cross_server_battle_of_kings_battle_list_cell_look_formation_terminal = {
            _name = "sm_cross_server_battle_of_kings_battle_list_cell_look_formation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if 4 ~= _ED.cross_server_kings_battle.cross_server_kings_battle_open_type then
                    return
                end          
                local cell = params._datas.cell
                local function requesrDefendCheck(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if _ED.cross_server_kings_battle.battle_match_info ~= nil and #_ED.cross_server_kings_battle.battle_match_info > 0 then
                            state_machine.excute("sm_cross_server_battleof_kings_view_general_formation_open", 0, {cell})
                        end   
                    end
                end

                protocol_command.the_kings_battle_self_get_other_info.param_list = ""..cell._other_singletonId
                NetworkManager:register(protocol_command.the_kings_battle_self_get_other_info.code, nil, nil, nil, cell, requesrDefendCheck, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cross_server_battle_of_kings_battle_list_cell_play_back_terminal = {
            _name = "sm_cross_server_battle_of_kings_battle_list_cell_play_back",
            _init = function (terminal) 
                app.load("client.battle.BattleStartEffect")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)          
                local cell = params._datas.cell
                if cell.index > 10 then
                    state_machine.excute("sm_cross_server_battleof_kings_peak_review_play_back_battle", 0, cell)
                    return
                end
                --查看用户id,服务器id,回合
                local user_round = cell.index
                local user_id_check = cell._other_userId
                local singletonId = cell._other_singletonId
                local user_server_number_check = cell._other_server_number
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            _ED.battle_playback_arena.playback = true
                            _ED.battle_playback_arena.nType = 211
                            _ED.battle_playback_arena.time = user_round
                            _ED.cross_server_kings_battle_flag = true       -- 跨服王者标志
                            
                            if _ED.user_info.last_user_grade ~= _ED.user_info.user_grade then
                                _ED.user_is_level_up = true
                                _ED.arena_is_level_up = true
                                _ED.last_grade = _ED.user_info.last_user_grade
                                _ED.last_food = _ED.user_info.last_user_food
                                _ED.last_endurance = _ED.user_info.last_endurance           
                            end
                            -- 胜利了,记录当前.requestArenaFightDatas
                            -- if tonumber(_ED.attackData.isWin) == 1 then
                                
                            -- end
                            fwin:close(self.userInformationHeroStorage)
                            fwin:cleanView(fwin._windows)
                            fwin:freeAllMemeryPool()
                            local bse = BattleStartEffect:new()
                            bse:init(_enum_fight_type._fight_type_211)
                            fwin:open(bse, fwin._windows)
                        end 
                    end
                end
                protocol_command.the_kings_battle_self_get_battle_report.param_list = ""..singletonId.."\r\n"..user_round
                NetworkManager:register(protocol_command.the_kings_battle_self_get_battle_report.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cross_server_battleof_kings_peak_review_play_back_battle_terminal = {
            _name = "sm_cross_server_battleof_kings_peak_review_play_back_battle",
            _init = function (terminal) 
                app.load("client.battle.BattleStartEffect")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _self = params
                local user_round = _self.index
                local user_id_check = _self._other_userId
                local singletonId = _self._other_singletonId
                local user_server_number_check = _self._other_server_number
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            _ED.battle_playback_arena.playback = true
                            _ED.battle_playback_arena.nType = 211
                            _ED.battle_playback_arena.time = _self.battle_info[2]
                            _ED.cross_server_kings_battle_flag = true
                            
                            if _ED.user_info.last_user_grade ~= _ED.user_info.user_grade then
                                _ED.user_is_level_up = true
                                _ED.arena_is_level_up = true
                                _ED.last_grade = _ED.user_info.last_user_grade
                                _ED.last_food = _ED.user_info.last_user_food
                                _ED.last_endurance = _ED.user_info.last_endurance           
                            end
                            
                            _ED.cross_server_kings_battle.enterBattleFromKingsReview = true

                            fwin:close(self.userInformationHeroStorage)
                            fwin:cleanView(fwin._windows)
                            fwin:freeAllMemeryPool()
                            local bse = BattleStartEffect:new()
                            bse:init(_enum_fight_type._fight_type_211)
                            fwin:open(bse, fwin._windows)
                        end 
                    end
                end
                protocol_command.the_kings_battle_self_get_battle_report.param_list = ""..singletonId.."\r\n"..user_round
                NetworkManager:register(protocol_command.the_kings_battle_self_get_battle_report.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cross_server_battleof_kings_review_look_peak_formation_cell_terminal = {
            _name = "sm_cross_server_battleof_kings_review_look_peak_formation_cell",
            _init = function (terminal) 
                app.load("client.l_digital.campaign.crossServerBattleofKings.SmCrossServerBattleofKingsViewPeakFormation")
                app.load("client.l_digital.campaign.crossServerBattleofKings.SmCrossServerBattleofKingsMyPeakFormation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local isMy = params._datas.isMy
                local cell = params._datas.cell
                if isMy then
                    state_machine.excute("sm_cross_server_battleof_kings_my_peak_formation_open", 0, "")
                else
                    local _datas = {}
                    _datas.user_info = cell._other_info_data
                    _datas.user_server_number = cell._other_server_number
                    _datas.singletonId = cell._other_singletonId
                    state_machine.excute("sm_cross_server_battleof_kings_view_peak_formation_open", 0, {_datas, 1})
                    instance.cd_time = tonumber(_ED.cross_server_kings_battle.single_field_end_cd)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
                end
                    
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_cross_server_battle_of_kings_battle_list_cell_look_formation_terminal)
        state_machine.add(sm_cross_server_battle_of_kings_battle_list_cell_play_back_terminal)
        state_machine.add(sm_cross_server_battleof_kings_peak_review_play_back_battle_terminal)
        state_machine.add(sm_cross_server_battleof_kings_review_look_peak_formation_cell_terminal)
        state_machine.init()
    end 
    -- call func sm_cross_server_battle_of_kings_battle_list_cell create state machine.
    init_sm_cross_server_battle_of_kings_battle_list_cell_terminal()

end

function SmCrossServerBattleOfKingsBattleListCell:updateDraw()
    local root = self.roots[1]
    local battle_info = nil
    local enemy_info = nil
    local myPeakInfo_formation = nil
    local enemyPeakInfo_formation = nil
    local judgmentLose = 0
    local judgmentWin = 1

    if nil == _ED.cross_server_kings_battle.battle_match_info or nil == _ED.cross_server_kings_battle.battle_match_info[self.index] or nil == _ED.cross_server_kings_battle.battle_match_info[self.index].baseAttackerUserInfo then
        local Text_name_lv_1 = ccui.Helper:seekWidgetByName(root, "Text_name_lv_1")
        Text_name_lv_1:setString(_ED.user_info.user_name.." Lv.".._ED.user_info.user_grade)
        local Text_name_lv_2 = ccui.Helper:seekWidgetByName(root, "Text_name_lv_2")
        Text_name_lv_2:setString("??????")
        self.cd_time = tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_next_time)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
        local Panel_digimon_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_1")
        local cell = ShipIconCell:createCell()
        local datas = zstring.split(_ED.cross_server_kings_battle.cross_server_kings_battle_user_formation,",")
        cell:init(_ED.user_ship[datas[1]],12)
        Panel_digimon_icon_1:addChild(cell)
        return
    end

    if false and 4 == _ED.cross_server_kings_battle.round_status and _ED.cross_server_kings_battle.peak_list then
        self._is_peak = true
        battle_info = _ED.cross_server_kings_battle.peak_list[self.index]
        battle_info.baseAttackerUserInfo = json.decode(battle_info.baseAttackerUserInfo)
        battle_info.baseByAttackerUserInfo = json.decode(battle_info.baseByAttackerUserInfo)
    else
        battle_info = _ED.cross_server_kings_battle.battle_match_info[self.index]
    end
    
    if tonumber(_ED.user_info.user_id) == tonumber(battle_info.baseAttackerUserInfo.userId) then
        -- 攻
        self.is_attack = true
        judgmentWin = 1
        judgmentLose = 0
        enemy_info = battle_info.baseByAttackerUserInfo
        myPeakInfo_formation = battle_info.baseAttackShip
        enemyPeakInfo_formation = battle_info.baseByAttackShip

        self._my_info_data = battle_info.attackUserServerNumber
        self._other_userId = enemy_info.userId
        self._other_singletonId = battle_info.byAttackSingletonId
        self._other_server_number = battle_info.byAttackUserServerNumber
        self._other_info_data = enemy_info
    else
        -- 守
        self.is_attack = false
        judgmentWin = 0
        judgmentLose = 1
        enemy_info = battle_info.baseAttackerUserInfo
        myPeakInfo_formation = battle_info.baseByAttackShip
        enemyPeakInfo_formation = battle_info.baseAttackShip
        --我的信息
        self._my_info_data = battle_info.byAttackUserServerNumber
        --对手信息
        self._other_userId = enemy_info.userId
        self._other_singletonId = battle_info.attackSingletonId
        self._other_server_number = battle_info.attackUserServerNumber
        self._other_info_data = enemy_info
    end

    self.battle_info = battle_info

    --我的名字
    local Text_name_lv_1 = ccui.Helper:seekWidgetByName(root, "Text_name_lv_1")
    --print(SmCrossServerBattleKingsHandler.getServerName(self._my_info_data),"---------------------------myServerName")
    Text_name_lv_1:setString(_ED.user_info.user_name.."  "..SmCrossServerBattleKingsHandler.getServerName(self._my_info_data).." Lv.".._ED.user_info.user_grade)
    --对方的名字
    local Text_name_lv_2 = ccui.Helper:seekWidgetByName(root, "Text_name_lv_2")
    if tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_open_type) ~= 4 then
        Text_name_lv_2:setString("??????")
    else
        Text_name_lv_2:setString(enemy_info.nickName.."  "..SmCrossServerBattleKingsHandler.getServerName(self._other_server_number))
    end
    if self._is_peak then
        if -1 ~= battle_info.battleRes then
            self.m_overs = true
        else
            self.isSettlement = true
        end
    else
        if -1 ~= battle_info.battleRes then
            self.m_overs = true
        elseif 0 >= _ED.cross_server_kings_battle.battle_wait_time and self.index == self.max_index then
            --战斗中
            self.isSettlement = true
        else
            self.isSettlement = false
        end
    end
    
    
    --战斗cd
    local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
    if tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_open_type) ~= 4 then
        self.cd_time = tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_next_time)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
    else
        if tonumber(_ED.cross_server_kings_battle.my_lose_number) >= _ED.cross_server_kings_battle.fail_next_param then
            self.m_overs = true
        else
            if self.isSettlement == false then
                self.cd_time = (_ED.cross_server_kings_battle.battle_wait_time)/1000
                -- else
                --     self.cd_time = tonumber(_ED.cross_server_kings_battle.single_field_end_cd)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
            else
                --战斗中
                self.cd_time = 0
            end
        end
    end

    ccui.Helper:seekWidgetByName(root, "Image_list_vs"):setVisible(true)

    --宝箱名称
    local Text_box_name = ccui.Helper:seekWidgetByName(root, "Text_box_name") 
    --宝箱图标
    local Panel_box = ccui.Helper:seekWidgetByName(root, "Panel_box") 

    local Panel_time = ccui.Helper:seekWidgetByName(root, "Panel_time") 
    if tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_open_type) ~= 4 then
        Text_box_name:setVisible(false)
        Panel_box:setVisible(false)
        Panel_time:setVisible(true)
    else
        if self.m_overs == false then
            
            if self.isSettlement == true then
                --战斗中
                Text_box_name:setVisible(false)
                Panel_box:setVisible(false)
                Panel_time:setVisible(false)
            else    
                --等待战斗
                Text_box_name:setVisible(false)
                Panel_box:setVisible(false)
                Panel_time:setVisible(true)
            end
        else
            if self.isSettlement == false then
                Text_box_name:setVisible(true)
                Panel_box:setVisible(true)
                Panel_time:setVisible(false)
                if Panel_box:getChildByTag(500) ~= nil then
                    Panel_box:removeChildByTag(500)
                end
                if tonumber(self.battle_info.battleRes) == judgmentLose then
                    local jsonFile = "sprite/sprite_wzzz_bx.json"
                    local atlasFile = "sprite/sprite_wzzz_bx.atlas"
                    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "box_2", true, nil)
                    -- animation:setPosition(cc.p(Panel_icon:getContentSize().width/2,Panel_icon:getContentSize().height/2))
                    animation:setTag(500)
                    Panel_box:addChild(animation)
                    -- Panel_box:removeAllChildren(true)
                    --画宝箱银的
                    -- local cell = ResourcesIconCell:createCell()
                    local reworld = zstring.split(dms.string(dms["play_config"], 172, pirates_config.param), ",")
                    -- cell:init(reworld[1], tonumber(reworld[3]), reworld[2],nil,nil,true,true)
                    -- Panel_box:addChild(cell)
                    Text_box_name:setString(setThePropsIcon(reworld[2])[2])
                    --画宝箱金的
                else
                    local jsonFile = "sprite/sprite_wzzz_bx.json"
                    local atlasFile = "sprite/sprite_wzzz_bx.atlas"
                    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "box_1", true, nil)
                    -- animation:setPosition(cc.p(Panel_icon:getContentSize().width/2,Panel_icon:getContentSize().height/2))
                    animation:setTag(500)
                    Panel_box:addChild(animation)
                    -- Panel_box:removeAllChildren(true)
                    -- local cell = ResourcesIconCell:createCell()
                    local reworld = zstring.split(dms.string(dms["play_config"], 171, pirates_config.param), ",")
                    -- cell:init(reworld[1], tonumber(reworld[3]), reworld[2],nil,nil,true,true)
                    -- Panel_box:addChild(cell)
                    Text_box_name:setString(setThePropsIcon(reworld[2])[2])
                end
            else
                Text_box_name:setVisible(false)
                Panel_box:setVisible(false)
                Panel_time:setVisible(true)
            end
        end
    end
    --第几场
    local Panel_cc = ccui.Helper:seekWidgetByName(root, "Panel_cc") 
    Panel_cc:removeBackGroundImage()
    Panel_cc:setBackGroundImage(string.format("images/ui/text/SMZB_res/cc/cc_%d.png", tonumber(self.index)))

    --我方的战船
    local Panel_digimon_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_1") 
    if self.index > 10 then
        Panel_digimon_icon_1:setVisible(false)
        local formation = zstring.split(myPeakInfo_formation, "@")
        local index = 1
        for i = 1, #formation do
            if "" == formation[i] then
                break
            end
            local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_l_" .. index) 
            Panel_digimon_icon:removeAllChildren(true)
            index = index + 1

            local datas = zstring.split(formation[i],":")
            local cell = ShipIconCell:createCell()
            cell:init(_ED.user_ship[datas[7]],12)
            Panel_digimon_icon:addChild(cell)

            Panel_digimon_icon:setTouchEnabled(true)
            Panel_digimon_icon:setVisible(true)
            fwin:addTouchEventListener(Panel_digimon_icon, nil, 
            {
                terminal_name = "sm_cross_server_battleof_kings_review_look_peak_formation_cell", 
                terminal_state = 0, 
                isMy = true,
                cell = self,
            }, nil, 1)
        end
    else
        Panel_digimon_icon_1:setVisible(true)
        for i = 1, 3 do
            local Panel_digimon_icon_r = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_r_" .. i)
            local Panel_digimon_icon_l = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_l_" .. i)
            Panel_digimon_icon_r:setVisible(false)
            Panel_digimon_icon_l:setVisible(false)
        end
        Panel_digimon_icon_1:removeAllChildren(true)
        if tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_open_type) ~= 4 then
            local formation_info = zstring.split(myPeakInfo_formation, "@")
            local datas = zstring.split(formation_info[1],":")
            local cell = ShipIconCell:createCell()
            cell:init(_ED.user_ship[datas[7]],12)
            Panel_digimon_icon_1:addChild(cell)
        else
            local formation_info = zstring.split(myPeakInfo_formation, "@")
            local datas = zstring.split(formation_info[1],":")
            local cell = ShipIconCell:createCell()
            cell:init(_ED.user_ship[datas[7]],12)
            Panel_digimon_icon_1:addChild(cell)
        end
    end
    --我方胜利
    local Image_win_1 = ccui.Helper:seekWidgetByName(root, "Image_win_1")
    local Image_win_vs_3_1 = ccui.Helper:seekWidgetByName(root, "Image_win_vs_3_1")
    --我方失败
    local Image_lose_1 = ccui.Helper:seekWidgetByName(root, "Image_lose_1")  
    local Image_lose_vs_3_1 = ccui.Helper:seekWidgetByName(root, "Image_lose_vs_3_1")  

    local Panel_dh = ccui.Helper:seekWidgetByName(root, "Panel_dh")  
    local Panel_dh_2 = ccui.Helper:seekWidgetByName(root, "Panel_dh_2")  
    if Panel_dh_2:getChildByTag(500) ~= nil then
        Panel_dh_2:removeChildByTag(500)
    end

    if tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_open_type) ~= 4 then
        Image_win_1:setVisible(false)
        Image_lose_1:setVisible(false)
        Image_win_vs_3_1:setVisible(false)
        Image_lose_vs_3_1:setVisible(false)
    else
        if self.m_overs == false then
            Image_win_1:setVisible(false)
            Image_lose_1:setVisible(false)
            local jsonFile = "sprite/sprite_wzzz_bzz.json"
            local atlasFile = "sprite/sprite_wzzz_bzz.atlas"
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            -- animation:setPosition(cc.p(Panel_icon:getContentSize().width/2,Panel_icon:getContentSize().height/2))
            animation:setTag(500)
            Panel_dh_2:addChild(animation)
        else
            if self.isSettlement == false then
                if Panel_dh:getChildByTag(500) ~= nil then
                    Panel_dh:removeChildByTag(500)
                end
                if Panel_dh_2:getChildByTag(500) ~= nil then
                    Panel_dh_2:removeChildByTag(500)
                end
                if tonumber(self.battle_info.battleRes) == judgmentLose then
                    Image_win_1:setVisible(false)
                    Image_lose_1:setVisible(true)
                else
                    Image_win_1:setVisible(true)
                    Image_lose_1:setVisible(false)
                end
                Image_win_vs_3_1:setVisible(false)
                Image_lose_vs_3_1:setVisible(false)
                if self.index > 10 then
                    Image_win_1:setVisible(false)
                    Image_lose_1:setVisible(false)
                    if tonumber(self.battle_info.battleRes) == judgmentLose then 
                        Image_win_vs_3_1:setVisible(false)
                        Image_lose_vs_3_1:setVisible(true)
                        --_ED.cross_server_kings_battle.my_lose_number = _ED.cross_server_kings_battle.my_lose_number + 1
                    elseif tonumber(self.battle_info.battleRes) == judgmentWin then
                        Image_win_vs_3_1:setVisible(true)
                        Image_lose_vs_3_1:setVisible(false)
                        --_ED.cross_server_kings_battle.my_win_number = _ED.cross_server_kings_battle.my_win_number + 1
                    else
                        Image_win_vs_3_1:setVisible(false)
                        Image_lose_vs_3_1:setVisible(false)
                    end
                end
            else
                Image_win_1:setVisible(false)
                Image_lose_1:setVisible(false)
                Image_win_vs_3_1:setVisible(false)
                Image_lose_vs_3_1:setVisible(false)
            end
        end
     end

    --对方的战船
    local Panel_digimon_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_2")  
    --敌方胜利
    local Image_win_2 = ccui.Helper:seekWidgetByName(root, "Image_win_2")  
    local Image_win_vs_3_2 = ccui.Helper:seekWidgetByName(root, "Image_win_vs_3_2")  
    --敌方失败
    local Image_lose_2 = ccui.Helper:seekWidgetByName(root, "Image_lose_2")  
    local Image_lose_vs_3_2 = ccui.Helper:seekWidgetByName(root, "Image_lose_vs_3_2")  
    --回放按钮
    local Button_replay = ccui.Helper:seekWidgetByName(root, "Button_replay") 
    if tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_open_type) ~= 4 then
        Panel_digimon_icon_2:removeAllChildren(true)
        Image_win_2:setVisible(false)
        Image_lose_2:setVisible(false)
        Image_win_vs_3_2:setVisible(false)
        Image_lose_vs_3_2:setVisible(false)
        Button_replay:setVisible(false)
    else
        Panel_digimon_icon_2:removeAllChildren(true)
        if self.index > 10 then
            Panel_digimon_icon_2:setVisible(false)
            local formation = zstring.split(enemyPeakInfo_formation, "@")
            local index = 1
            for i = 1, #formation do
                if "" == formation[i] then
                    break
                end
                local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_r_" .. index) 
                Panel_digimon_icon:removeAllChildren(true)
                index = index + 1

                local datas = zstring.split(formation[i],":")
                local cell = ShipIconCell:createCell()
                local ships = {}
                ships.ship_template_id = datas[1]
                ships.evolution_status = datas[3]
                ships.Order = datas[5]
                ships.ship_grade = datas[2]
                ships.StarRating = datas[4]
                ships.skin_id = datas[11]
                
                cell:init(ships,12)
                Panel_digimon_icon:addChild(cell)

                Panel_digimon_icon:setVisible(true)
                Panel_digimon_icon:setTouchEnabled(true)
                fwin:addTouchEventListener(Panel_digimon_icon, nil, 
                {
                    terminal_name = "sm_cross_server_battleof_kings_review_look_peak_formation_cell", 
                    terminal_state = 0, 
                    isMy = false,
                    cell = self,
                }, nil, 1)
            end
        else
            Panel_digimon_icon_2:setVisible(true)
            local formation_info = zstring.split(enemyPeakInfo_formation, "@")
            local datas = zstring.split(formation_info[1],":")
            local cell = ShipIconCell:createCell()
            local ships = {}
            ships.ship_template_id = datas[1]
            ships.evolution_status = datas[3]
            ships.Order = datas[5]
            ships.ship_grade = datas[2]
            ships.StarRating = datas[4]
            cell:init(ships,12)
            Panel_digimon_icon_2:addChild(cell)
            Panel_digimon_icon_2:setTouchEnabled(true)
        end
        if self.isSettlement == false and self.m_overs then
            Button_replay:setVisible(true)
        else
            Button_replay:setVisible(false)
        end 
    end
end

function SmCrossServerBattleOfKingsBattleListCell:getTimeDesByInterval( timeInt )
    if timeInt <= 0 then
        timeInt = 0
    end
    local result = ""
    local oh     = math.floor(timeInt/3600)
    local om     = math.floor((timeInt - oh*3600)/60)
    local os     = math.floor(timeInt - oh*3600 - om*60)
    local hour = oh
    local day  = 0
    if(oh>=24) then
        day  = math.floor(hour/24)
        hour = oh - day*24
    end
    if(hour ~= 0) then
    end
    if(om ~= 0) then
        if(hour ~= 0) then
            om = om + hour*60
        end
        if om < 10 then
            om = "0"..om
        end
        result = result .. om .. ":"
    else
        if(hour ~= 0) then
            om = om + hour*60
            if om < 10 then
                om = "0"..om
            end
        else
            om = "00"
        end
        result = result .. om .. ":"     
    end
    if(os ~= 0) then
        if os < 10 then
            os = "0"..os
        end
        result = result .. os
    else
        result = result .. "00"
    end
    return result
end

function SmCrossServerBattleOfKingsBattleListCell:onUpdate(dt)
    if self.m_overs == true or self._is_peak then
        -- local  _panel_time = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_time")
        -- if _panel_time:isVisible() then
        --     _panel_time:setVisible(false)
        -- end
        self:unscheduleUpdate()
        return
    end

    if _ED.cross_server_kings_battle.my_lose_number and tonumber(_ED.cross_server_kings_battle.my_lose_number) >= _ED.cross_server_kings_battle.fail_next_param and self.cd_time == 0 then
        self.m_overs = true
        return
    end

    if not self.isSettlement then
        if self.cd_time > 0 then
            self.cd_time = self.cd_time - dt
            ccui.Helper:seekWidgetByName(self.roots[1], "Text_time"):setString(self:getTimeDesByInterval(self.cd_time))
    
            if tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_open_type) == 4 then
                if self.cd_time <= 60 then
                    if self.isSettlement == false and self.isAnimation == false then
                        local Panel_dh_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_dh_2")  
                        if Panel_dh_2:getChildByTag(500) ~= nil then
                            Panel_dh_2:removeChildByTag(500)
                        end
                        local Panel_dh = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_dh")
                        if Panel_dh:getChildByTag(500) ~= nil then
                            Panel_dh:removeChildByTag(500)
                        end
                        local jsonFile = "sprite/sprite_wzzz_jxz.json"
                        local atlasFile = "sprite/sprite_wzzz_jxz.atlas"
                        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                        -- animation:setPosition(cc.p(Panel_icon:getContentSize().width/2,Panel_icon:getContentSize().height/2))
                        animation:setTag(500)
                        Panel_dh:addChild(animation)
                        ccui.Helper:seekWidgetByName(self.roots[1], "Image_list_vs"):setVisible(false)
                        self.isAnimation = true
                    end
                end
            end
        else
            ccui.Helper:seekWidgetByName(self.roots[1], "Text_time"):setString("")
            local function requestOnUpdate(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    state_machine.excute("sm_cross_server_battleof_kings_prepare_for_the_game_update_draw_list", 0, "")
                end
            end
            protocol_command.the_kings_battle_self_match_info.param_list = "1".."\r\n".._ED.cross_server_kings_battle.cur_battle_round_by_server
            NetworkManager:register(protocol_command.the_kings_battle_self_match_info.code, nil, nil, nil, self, requestOnUpdate, false, nil)
        end
    else
        if self._is_peak and self.isAnimation == false then
            local Panel_dh_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_dh_2")  
            if Panel_dh_2:getChildByTag(500) ~= nil then
                Panel_dh_2:removeChildByTag(500)
            end
            local Panel_dh = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_dh")
            if Panel_dh:getChildByTag(500) ~= nil then
                Panel_dh:removeChildByTag(500)
            end
            local jsonFile = "sprite/sprite_wzzz_jxz.json"
            local atlasFile = "sprite/sprite_wzzz_jxz.atlas"
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            -- animation:setPosition(cc.p(Panel_icon:getContentSize().width/2,Panel_icon:getContentSize().height/2))
            animation:setTag(500)
            Panel_dh:addChild(animation)
            ccui.Helper:seekWidgetByName(self.roots[1], "Image_list_vs"):setVisible(false)
            self.isAnimation = true
        else
            self._update_time = self._update_time - dt
            if 0 >= self._update_time then
                self._update_time = self._update_interval
                local function requestUpdate(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("sm_cross_server_battleof_kings_prepare_for_the_game_update_draw_list", 0, "")
                    end
                end
                protocol_command.the_kings_battle_self_match_info.param_list = "1".."\r\n".._ED.cross_server_kings_battle.cur_battle_round_by_server
                NetworkManager:register(protocol_command.the_kings_battle_self_match_info.code, nil, nil, nil, self, requestUpdate, false, nil)
            end
        end
        
    end
    

end

function SmCrossServerBattleOfKingsBattleListCell:onInit()
    local root = cacher.createUIRef("campaign/BattleofKingsX/battle_of_kings_x_tab_2_list_1.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmCrossServerBattleOfKingsBattleListCell.__size == nil then
        SmCrossServerBattleOfKingsBattleListCell.__size = root:getContentSize()
    end
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_1"), nil, 
    {
        terminal_name = "sm_cross_server_battleof_kings_my_general_formation_open", 
        terminal_state = 0
    }, nil, 1)
    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_2"), nil, 
    {
        terminal_name = "sm_cross_server_battle_of_kings_battle_list_cell_look_formation", 
        terminal_state = 0, 
        cell = self
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_replay"), nil, 
    {
        terminal_name = "sm_cross_server_battle_of_kings_battle_list_cell_play_back", 
        terminal_state = 0, 
        cell = self
    }, nil, 1)

    self:updateDraw()
end

function SmCrossServerBattleOfKingsBattleListCell:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function SmCrossServerBattleOfKingsBattleListCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_dh_2 = ccui.Helper:seekWidgetByName(root, "Panel_dh_2")
    local Panel_dh = ccui.Helper:seekWidgetByName(roots, "Panel_dh")
    local Panel_box = ccui.Helper:seekWidgetByName(root, "Panel_box")
    local Panel_digimon_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_1") 
    local Panel_digimon_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_2")
    local Image_win_1 = ccui.Helper:seekWidgetByName(root, "Image_win_1")
    local Image_lose_1 = ccui.Helper:seekWidgetByName(root, "Image_lose_1")
    local Image_win_2 = ccui.Helper:seekWidgetByName(root, "Image_win_2")
    local Image_lose_2 = ccui.Helper:seekWidgetByName(root, "Image_lose_2")
    local Image_win_vs_3_1 = ccui.Helper:seekWidgetByName(root, "Image_win_vs_3_1")
    local Image_lose_vs_3_1 = ccui.Helper:seekWidgetByName(root, "Image_lose_vs_3_1")
    local Image_win_vs_3_2 = ccui.Helper:seekWidgetByName(root, "Image_win_vs_3_2")
    local Image_lose_vs_3_2 = ccui.Helper:seekWidgetByName(root, "Image_lose_vs_3_2")
    local Button_replay = ccui.Helper:seekWidgetByName(root, "Button_replay")
    local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
    if Panel_dh ~= nil then
        Panel_dh:removeAllChildren(true)
        Panel_dh_2:removeAllChildren(true)
        Panel_box:removeAllChildren(true)
        Panel_digimon_icon_1:removeAllChildren(true)
        Panel_digimon_icon_2:removeAllChildren(true)
        Panel_digimon_icon_2:setVisible(true)
        Panel_digimon_icon_1:setVisible(true)
        Image_win_1:setVisible(false)
        Image_lose_1:setVisible(false)
        Image_win_2:setVisible(false)
        Image_lose_2:setVisible(false)

        Image_win_vs_3_1:setVisible(false)
        Image_lose_vs_3_1:setVisible(false)
        Image_win_vs_3_2:setVisible(false)
        Image_lose_vs_3_2:setVisible(false)
        Button_replay:setVisible(false)
        Text_time:setString("")
    end

    for i = 1, 3 do
        local Panel_digimon_icon_r = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_r_" .. i)
        local Panel_digimon_icon_l = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_l_" .. i)
        Panel_digimon_icon_r:setVisible(false)
        Panel_digimon_icon_l:setVisible(false)
        Panel_digimon_icon_r:removeAllChildren(true)
        Panel_digimon_icon_l:removeAllChildren(true)
    end

    self.cd_time = 0
end

function SmCrossServerBattleOfKingsBattleListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmCrossServerBattleOfKingsBattleListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef("campaign/BattleofKingsX/battle_of_kings_x_tab_2_list_1.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function SmCrossServerBattleOfKingsBattleListCell:init(params)
    self.index = tonumber(params[1])
    self.max_index = tonumber(params[2])
    self:onInit()

    self:setContentSize(SmCrossServerBattleOfKingsBattleListCell.__size)
    return self
end

function SmCrossServerBattleOfKingsBattleListCell:onExit()
    self:clearUIInfo()
    cacher.freeRef("campaign/BattleofKings/battle_of_kings_tab_2_list_1.csb", self.roots[1])
end