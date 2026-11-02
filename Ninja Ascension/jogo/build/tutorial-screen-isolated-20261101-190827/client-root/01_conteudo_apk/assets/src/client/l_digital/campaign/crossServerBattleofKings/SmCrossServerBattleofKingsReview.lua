-----------------------------
--王者之战赛程回顾界面
-----------------------------
SmCrossServerBattleofKingsReview = class("SmCrossServerBattleofKingsReviewClass", Window)
SmCrossServerBattleofKingsReview.__size = nil

local sm_cross_server_battleof_kings_review_window_open_terminal = {
    _name = "sm_cross_server_battleof_kings_review_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = SmCrossServerBattleofKingsReview:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_cross_server_battleof_kings_review_window_open_terminal)
state_machine.init()

function SmCrossServerBattleofKingsReview:ctor()
    self.super:ctor()
    self.roots = {}

    self.prop_list = {}
    self.cd_time = 0
    self.list_object = {}   --图标对象列表
    self.battle_times = {}  --战斗轮数
    self.battle_id = {}     --战斗ID
    self.battle_singletonId = {} -- 战斗唯一ID
    self.battle_server_number = {} --战斗服务器ID
    self.battle_win_userId = {}   --赢得用户ID
    
    local function init_sm_cross_server_battleof_kings_review_terminal()
        --显示界面
        local sm_cross_server_battleof_kings_review_show_terminal = {
            _name = "sm_cross_server_battleof_kings_review_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                if tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_open_type) == 4 then
                    local function requesrDefendCheck(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots[1] ~= nil then
                                instance:onUpdateDraw()
                                instance.cd_time = tonumber(_ED.cross_server_kings_battle.single_field_end_cd)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
                            end
                        end
                    end
                    protocol_command.the_kings_battle_self_battle_peakedness_duel_info.param_list = ""
                    NetworkManager:register(protocol_command.the_kings_battle_self_battle_peakedness_duel_info.code, nil, nil, nil, self, requesrDefendCheck, false, nil)  
                else
                    instance:onUpdateDraw()
                    instance.cd_time = 0
                end

                local h_times,m_times,s_times = instance:getTimeDesByInterval(instance.cd_time)
                ccui.Helper:seekWidgetByName(instance.roots[1],"AtlasLabel_djs_m"):setString(m_times)
                ccui.Helper:seekWidgetByName(instance.roots[1],"AtlasLabel_djs_s"):setString(s_times)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --隐藏界面
        local sm_cross_server_battleof_kings_review_hide_terminal = {
            _name = "sm_cross_server_battleof_kings_review_hide",
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

        local sm_cross_server_battleof_kings_review_update_draw_terminal = {
            _name = "sm_cross_server_battleof_kings_review_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 巅峰阵型
        local sm_cross_server_battleof_kings_review_look_peak_formation_terminal = {
            _name = "sm_cross_server_battleof_kings_review_look_peak_formation",
            _init = function (terminal) 
                app.load("client.l_digital.campaign.crossServerBattleofKings.SmCrossServerBattleofKingsViewPeakFormation")
                app.load("client.l_digital.campaign.crossServerBattleofKings.SmCrossServerBattleofKingsMyPeakFormation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                if nil == instance.list_object[tonumber(index)] then
                    return
                end

                if self.cd_time > 0 and tonumber(instance.list_object[tonumber(index)].user_info.userId) == tonumber(_ED.user_info.user_id) and tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_type) ~= 0 and _ED.cross_server_kings_battle.cross_server_kings_battle_type ~= 3 then
                    state_machine.excute("sm_cross_server_battleof_kings_my_peak_formation_open", 0, "")
                else
                    state_machine.excute("sm_cross_server_battleof_kings_view_peak_formation_open", 0, {instance.list_object[tonumber(index)], 1})
                    instance.cd_time = tonumber(_ED.cross_server_kings_battle.single_field_end_cd)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
                end
                    
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cross_server_battleof_kings_review_play_back_battle_terminal = {
            _name = "sm_cross_server_battleof_kings_review_play_back_battle",
            _init = function (terminal) 
                app.load("client.battle.BattleStartEffect")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                local _cell = params._datas.cell
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            _ED.battle_playback_arena.playback = true
                            _ED.battle_playback_arena.nType = 211
                            _ED.battle_playback_arena.time = self.battle_times[tonumber(index)]
                            _ED.cross_server_kings_battle_flag = true       -- 跨服王者标志
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
                local user_id_check = _cell.battle_id[index]
                local singletonId = _cell.battle_singletonId[index]
                local user_server_number_check = _cell.battle_server_number[index]
                local user_round = _cell.battle_times[index]
                protocol_command.the_kings_battle_self_get_battle_report.param_list = ""..singletonId.."\r\n"..user_round
                NetworkManager:register(protocol_command.the_kings_battle_self_get_battle_report.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_cross_server_battleof_kings_review_show_terminal)   
        state_machine.add(sm_cross_server_battleof_kings_review_hide_terminal)
        state_machine.add(sm_cross_server_battleof_kings_review_update_draw_terminal)
        state_machine.add(sm_cross_server_battleof_kings_review_look_peak_formation_terminal)
        state_machine.add(sm_cross_server_battleof_kings_review_play_back_battle_terminal)

        state_machine.init()
    end
    init_sm_cross_server_battleof_kings_review_terminal()
end

function SmCrossServerBattleofKingsReview:onHide()
    self:setVisible(false)
end

function SmCrossServerBattleofKingsReview:onShow()
    self:setVisible(true)
end

function SmCrossServerBattleofKingsReview:getTimeDesByInterval( timeInt )
    local result = {}
    local oh     = math.floor(timeInt/3600)
    local om     = math.floor((timeInt - oh*3600)/60)
    local os     = math.floor(timeInt - oh*3600 - om*60)
    local hour = oh
    local day  = 0
    if(oh>=24) then
        day  = math.floor(hour/24)
        hour = oh - day*24
    end
    if hour > 0 then
        if hour < 10 then
            hour = "0"..hour
        end
    else
        hour = "00"
    end
    if om > 0 then
        if om < 10 then
            om = "0"..om
        end
    else
        om = "00"
    end
    if os > 0 then
        if os < 10 then
            os = "0"..os
        end
    else
        os = "00"
    end
    return hour,om,os
end

function SmCrossServerBattleofKingsReview:onUpdateDraw()
    local root = self.roots[1]
    self.battle_win_userId = {}
    local Image_djs_bg = ccui.Helper:seekWidgetByName(root,"Image_djs_bg")
    if tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_open_type) == 4 then
        Image_djs_bg:setVisible(true)      
    else
        Image_djs_bg:setVisible(false)
    end
    
    for i=1,11 do
        local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root,"Panel_digimon_icon_"..i)
        Panel_digimon_icon:removeAllChildren(true)
        local Image_lose = ccui.Helper:seekWidgetByName(root,"Image_lose_"..i)
        if Image_lose ~= nil then
            Image_lose:setVisible(false)
        end
        local Image_win = ccui.Helper:seekWidgetByName(root,"Image_win_"..i)
        if Image_win ~= nil then
            Image_win:setVisible(false)
        end
    end

    for i=1, 7 do
        ccui.Helper:seekWidgetByName(root,"Panel_vs_"..i):setVisible(false)
    end  
   
    if nil == _ED.cross_server_kings_battle.peak_list then
        return
    end
    --画第一轮数据(服务器传来的数据3和4 颠倒了)
    for i = 1, (#_ED.cross_server_kings_battle.peak_list) do
        if 4 < i then
            break
        end
        local index = i
        if 3 == i then
            index = 4
        elseif 4 == i then
            index = 3
        end

        local v = _ED.cross_server_kings_battle.peak_list[index]
        --攻
        local attack_user_info = json.decode(v.baseAttackerUserInfo)

        --图标名字
        self:DrawInterface((2*i-1),v.baseAttackShip,(2*i-1),attack_user_info.nickName,v.attackUserServerNumber)
        
        -- 保存对象
        self.list_object[(#self.list_object)+1] = {}
        self.list_object[(#self.list_object)].user_info = attack_user_info
        self.list_object[(#self.list_object)].singletonId = v.attackSingletonId 
        self.list_object[(#self.list_object)].user_server_number = v.attackUserServerNumber 
        -- 守
        local by_attack_user_info = json.decode(v.baseByAttackerUserInfo)

        --图标名字
        self:DrawInterface((2*i),v.baseByAttackShip,(2*i),by_attack_user_info.nickName,v.byAttackUserServerNumber)
        
        -- 保存对象
        self.list_object[(#self.list_object)+1] = {}
        self.list_object[(#self.list_object)].user_info = by_attack_user_info
        self.list_object[(#self.list_object)].singletonId = v.byAttackSingletonId
        self.list_object[(#self.list_object)].user_server_number = v.byAttackUserServerNumber

        -- 攻击轮次.用户ID,服务器ID
        self.battle_times[i] = v.attackUserBattleCount
        self.battle_id[i] = v.attackUserId
        self.battle_singletonId[i] = v.attackSingletonId
        
        self.battle_server_number[i] = v.attackUserServerNumber
        if tonumber(v.battleRes) == 0 then
            --守胜利
            self.battle_win_userId[i] = v.byAttackUserId
            ccui.Helper:seekWidgetByName(root,"Image_win_"..(2*i)):setVisible(true)
            ccui.Helper:seekWidgetByName(root,"Image_line_win_"..(2*i)):setVisible(true)
            ccui.Helper:seekWidgetByName(root,"Image_lose_"..(2*i)):setVisible(false)

            ccui.Helper:seekWidgetByName(root,"Image_win_"..(2*i-1)):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_line_win_"..(2*i-1)):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_lose_"..(2*i-1)):setVisible(true)
            --结果
            local Panel_vs = ccui.Helper:seekWidgetByName(root,"Panel_vs_"..i)
            if Panel_vs:isVisible() == false then
                Panel_vs:setVisible(true)
            end
        elseif tonumber(v.battleRes) == 1 then
            --攻胜利
            self.battle_win_userId[i] = v.attackUserId 
            ccui.Helper:seekWidgetByName(root,"Image_win_"..(2*i)):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_line_win_"..(2*i)):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_lose_"..(2*i)):setVisible(true)
            ccui.Helper:seekWidgetByName(root,"Image_win_"..(2*i-1)):setVisible(true)
            ccui.Helper:seekWidgetByName(root,"Image_line_win_"..(2*i-1)):setVisible(true)
            ccui.Helper:seekWidgetByName(root,"Image_lose_"..(2*i-1)):setVisible(false)
            --结果
            local Panel_vs = ccui.Helper:seekWidgetByName(root,"Panel_vs_"..i)
            if Panel_vs:isVisible() == false then
                Panel_vs:setVisible(true)
            end
        else
            ccui.Helper:seekWidgetByName(root,"Image_win_"..(2*i)):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_line_win_"..(2*i)):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_lose_"..(2*i)):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_win_"..(2*i-1)):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_line_win_"..(2*i-1)):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_lose_"..(2*i-1)):setVisible(false)
        end
    end 
    --画第二轮数据
    --第一轮未打完
    local _peak_win_datas = {}
    local peak_len = #_ED.cross_server_kings_battle.peak_list

    if {} == self.battle_win_userId then  --第一轮 还无结果
        
    elseif 4 < peak_len then  -- 第二轮 开始
        local _peak_index = 1
        for i = 5,6 do
            local peak_value = _ED.cross_server_kings_battle.peak_list[i]
            if self.battle_win_userId[(_peak_index*2-1)] == peak_value.byAttackUserId or self.battle_win_userId[(_peak_index*2-1)] == peak_value.attackUserId or
                self.battle_win_userId[(_peak_index*2)] == peak_value.byAttackUserId or self.battle_win_userId[(_peak_index*2)] == peak_value.attackUserId
            then

                _peak_win_datas[_peak_index] = {}
                -- 第二轮打完
                if 1 == peak_value.battleRes then                   --攻 赢了
                    _peak_win_datas[_peak_index].UserInfo = peak_value.baseAttackerUserInfo
                    _peak_win_datas[_peak_index].ship = peak_value.baseAttackShip
                    _peak_win_datas[_peak_index].userId = peak_value.attackUserId
                    _peak_win_datas[_peak_index].serverNumber = peak_value.attackUserServerNumber
                    _peak_win_datas[_peak_index].battleCount = peak_value.attackUserBattleCount
                    _peak_win_datas[_peak_index].singletonId = peak_value.attackSingletonId
                    _peak_index = _peak_index + 1
                elseif 0 == peak_value.battleRes then               --守 赢了
                    _peak_win_datas[_peak_index].UserInfo = peak_value.baseByAttackerUserInfo
                    _peak_win_datas[_peak_index].ship = peak_value.baseByAttackShip
                    _peak_win_datas[_peak_index].userId = peak_value.byAttackUserId
                    _peak_win_datas[_peak_index].serverNumber = peak_value.byAttackUserServerNumber
                    _peak_win_datas[_peak_index].battleCount = peak_value.byAttackUserBattleCount
                    _peak_win_datas[_peak_index].singletonId = peak_value.byAttackSingletonId
                    
                    _peak_index = _peak_index + 1
                else
                    --第一轮打完 第二轮 未出结果
                    _peak_win_datas[_peak_index] = nil
                end
            end  
        end
    else

    end
    
    if {} ~= _peak_win_datas or 0 ~= (#_peak_win_datas) then
        for i= 1,#_peak_win_datas do
            --攻
            local attack_user_info = json.decode(_peak_win_datas[i].UserInfo)
            --图标
            self:DrawInterface((8+i),_peak_win_datas[i].ship,(8+i),attack_user_info.nickName,_peak_win_datas[i].serverNumber)
            -- 保存对象
            self.list_object[(#self.list_object)+1] = {}
            self.list_object[(#self.list_object)].user_info = attack_user_info
            self.list_object[(#self.list_object)].user_server_number = _peak_win_datas[i].serverNumber
            self.list_object[(#self.list_object)].singletonId = _peak_win_datas[i].singletonId
            self.battle_times[#self.battle_times+1] = _peak_win_datas[i].battleCount
            self.battle_id[#self.battle_id+1] = attack_user_info.userId
            self.battle_singletonId[(#self.battle_singletonId)+1] = _peak_win_datas[i].singletonId

            self.battle_server_number[#self.battle_server_number+1] = _peak_win_datas[i].serverNumber
            ccui.Helper:seekWidgetByName(root,"Panel_vs_"..(i+4)):setVisible(true)

            ccui.Helper:seekWidgetByName(root,"Image_line_l_"..(4+i)):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_line_r_"..(4+i)):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_line_win_"..(8+(i*2-1))):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_line_win_"..(9+(i*2-1))):setVisible(false)

            if tonumber(self.battle_win_userId[i]) == tonumber(attack_user_info.userId) then
                ccui.Helper:seekWidgetByName(root,"Image_line_l_"..(4+i)):setVisible(true)
                ccui.Helper:seekWidgetByName(root,"Image_line_win_"..(8+(i*2-1))):setVisible(true)
            else
                ccui.Helper:seekWidgetByName(root,"Image_line_r_"..(4+i)):setVisible(true)
                ccui.Helper:seekWidgetByName(root,"Image_line_win_"..(9+(i*2-1))):setVisible(true)
            end
        end
    end
    -- 画第三轮数据
    if _ED.cross_server_kings_battle.peak_list[7] then
        local _peak_datas_last = _ED.cross_server_kings_battle.peak_list[7]
        --攻
        local attack_user_info = json.decode(_peak_datas_last.baseAttackerUserInfo)
        --图标
        self:DrawInterface(9,_peak_datas_last.baseAttackShip,9,attack_user_info.nickName,_peak_datas_last.attackUserServerNumber)

        self.battle_times[#self.battle_times+1] = _peak_datas_last.attackUserBattleCount
        self.battle_id[#self.battle_id+1] = _peak_datas_last.attackUserId
        self.battle_singletonId[#self.battle_singletonId+1] = _peak_datas_last.attackSingletonId
        
        self.battle_server_number[#self.battle_server_number+1] = _peak_datas_last.attackUserServerNumber

        -- 守
        local by_attack_user_info = json.decode(_peak_datas_last.baseByAttackerUserInfo)

        
        --图标
        self:DrawInterface(10,_peak_datas_last.baseByAttackShip,10,by_attack_user_info.nickName,_peak_datas_last.byAttackUserServerNumber)

        --攻击轮次.用户ID,服务器ID
        self.battle_times[7] = _peak_datas_last.attackUserBattleCount
        self.battle_id[7] = _peak_datas_last.attackUserId
        self.battle_singletonId[7] = _peak_datas_last.attackSingletonId
        
        self.battle_server_number[7] = _peak_datas_last.attackUserServerNumber
        if tonumber(_peak_datas_last.battleRes) == 0 then
            --结果
            local Panel_vs = ccui.Helper:seekWidgetByName(root,"Panel_vs_"..7)

            if Panel_vs:isVisible() == false then
                Panel_vs:setVisible(true)
            end
            --守胜利
            ccui.Helper:seekWidgetByName(root,"Image_win_"..10):setVisible(true)
            ccui.Helper:seekWidgetByName(root,"Image_line_win_"..14):setVisible(true)
            ccui.Helper:seekWidgetByName(root,"Image_lose_"..10):setVisible(false)

            ccui.Helper:seekWidgetByName(root,"Image_win_"..9):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_line_win_"..13):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_lose_"..9):setVisible(true)
            
            self:DrawInterface(11,_peak_datas_last.baseByAttackShip,11,by_attack_user_info.nickName,_peak_datas_last.byAttackUserServerNumber)
            -- 保存对象
            self.list_object[(#self.list_object)+1] = {}
            self.list_object[(#self.list_object)].user_info = by_attack_user_info
            self.list_object[(#self.list_object)].user_server_number = _peak_datas_last.byAttackUserServerNumber
            self.list_object[(#self.list_object)].singletonId = _peak_datas_last.byAttackSingletonId
             
        elseif tonumber(_peak_datas_last.battleRes) == 1 then
            --结果
            local Panel_vs = ccui.Helper:seekWidgetByName(root,"Panel_vs_"..7)
            if Panel_vs:isVisible() == false then
                Panel_vs:setVisible(true)
            end
            --攻胜利
            ccui.Helper:seekWidgetByName(root,"Image_win_"..10):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_line_win_"..14):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_lose_"..10):setVisible(true)
            ccui.Helper:seekWidgetByName(root,"Image_win_"..9):setVisible(true)
            ccui.Helper:seekWidgetByName(root,"Image_line_win_"..13):setVisible(true)
            ccui.Helper:seekWidgetByName(root,"Image_lose_"..9):setVisible(false)
            
            self:DrawInterface(11,_peak_datas_last.baseAttackShip,11,attack_user_info.nickName,_peak_datas_last.attackUserServerNumber)
            -- 保存对象
            self.list_object[(#self.list_object)+1] = {}
            self.list_object[(#self.list_object)].user_info = attack_user_info
            self.list_object[(#self.list_object)].user_server_number = _peak_datas_last.attackUserServerNumber
            self.list_object[(#self.list_object)].singletonId = _peak_datas_last.attackSingletonId
        else
            ccui.Helper:seekWidgetByName(root,"Image_win_"..10):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_line_win_"..14):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_lose_"..10):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_win_"..9):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_line_win_"..13):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_lose_"..9):setVisible(false)
        end
    end
end

-- 画图标和名字
function SmCrossServerBattleofKingsReview:DrawInterface( icon_index, ship, name_index, name , serverNum)
    local root = self.roots[1]
    --图标
    local Panel_digimon_icon_by = ccui.Helper:seekWidgetByName(root,"Panel_digimon_icon_"..icon_index)
    Panel_digimon_icon_by:removeAllChildren(true)
    local formation_by = zstring.split(ship, "@")[1]
    local datas_by = zstring.split(formation_by,":")
    local cell_by = ShipIconCell:createCell()
    local ships_by = {}
    ships_by.ship_template_id = datas_by[1]
    ships_by.evolution_status = datas_by[3]
    ships_by.Order = datas_by[5]
    ships_by.ship_grade = datas_by[2]
    ships_by.StarRating = datas_by[4]
    ships_by.skin_id = datas_by[11]
    cell_by:init(ships_by,cell_by.enum_type._BATTLE_OF_KINGS_ARRANGE_FORMATION)
    Panel_digimon_icon_by:addChild(cell_by)
    --名字
    local Text_player_name_by = ccui.Helper:seekWidgetByName(root,"Text_player_name_"..name_index)
    Text_player_name_by:setString(name.." "..SmCrossServerBattleKingsHandler.getServerName(serverNum))
end

function SmCrossServerBattleofKingsReview:onUpdate(dt)
    if self.cd_time > 0 then
        self.cd_time = self.cd_time - dt
        local h_times,m_times,s_times = self:getTimeDesByInterval(self.cd_time)
        ccui.Helper:seekWidgetByName(self.roots[1],"AtlasLabel_djs_m"):setString(m_times)
        ccui.Helper:seekWidgetByName(self.roots[1],"AtlasLabel_djs_s"):setString(s_times)
        if tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_open_type) == 4 then
            if self.cd_time <= 0 then
                local function requesrDefendCheck(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots[1] ~= nil then
                            self.cd_time = tonumber(_ED.cross_server_kings_battle.single_field_end_cd)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
                            self:onUpdateDraw()
                        end
                    else
                        fwin:addService({
                            callback = function ( params )
                                if params ~= nil and params.roots[1] ~= nil then
                                    protocol_command.the_kings_battle_self_battle_peakedness_duel_info.param_list = ""
                                    NetworkManager:register(protocol_command.the_kings_battle_self_battle_peakedness_duel_info.code, nil, nil, nil, params, requesrDefendCheck, false, nil) 
                                end 
                            end,
                            delay = 1,
                            params = response.node
                        })
                    end
                end
                protocol_command.the_kings_battle_self_battle_peakedness_duel_info.param_list = ""
                NetworkManager:register(protocol_command.the_kings_battle_self_battle_peakedness_duel_info.code, nil, nil, nil, self, requesrDefendCheck, false, nil)  
            end
        end
    else
        local _time_img = ccui.Helper:seekWidgetByName(self.roots[1],"Image_djs_bg")
        if _time_img:isVisible() then
            _time_img:setVisible(false)
        end
    end
end

function SmCrossServerBattleofKingsReview:onEnterTransitionFinish()
    
end

function SmCrossServerBattleofKingsReview:onInit( )
    local csbItem = csb.createNode("campaign/BattleofKingsX/battle_of_kings_x_tab_1_3.csb")
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    if SmCrossServerBattleofKingsReview.__size == nil then
        SmCrossServerBattleofKingsReview.__size = root:getContentSize()
    end
    self:setContentSize(SmCrossServerBattleofKingsReview.__size)

    for i=1, 11 do
        local Panel_head = ccui.Helper:seekWidgetByName(root,"Panel_head_"..i)
        fwin:addTouchEventListener(Panel_head, nil, 
        {
            terminal_name = "sm_cross_server_battleof_kings_review_look_peak_formation", 
            terminal_state = 0, 
            index = i
        }, nil, 0)
    end

    for i=1, 7 do
        local Button_chakan = ccui.Helper:seekWidgetByName(root,"Button_chakan_"..i)
        fwin:addTouchEventListener(Button_chakan, nil, 
        {
            terminal_name = "sm_cross_server_battleof_kings_review_play_back_battle", 
            terminal_state = 0, 
            index = i,
            cell = self
        }, nil, 0)
    end
    -- 中间巅峰之战图标控件
    local Panel_dfdj_cc = ccui.Helper:seekWidgetByName(root,"Panel_dfdj_cc")
    Panel_dfdj_cc:removeBackGroundImage()
    Panel_dfdj_cc:setBackGroundImage(string.format("images/ui/text/SMZB_res/dfdj_cc/dfdj_cc_%d.png", 1))

    if tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_open_type) == 4 then
        local function requesrDefendCheck(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                    self:onUpdateDraw()
                    --self.cd_time = tonumber(_ED.cross_server_kings_battle.single_field_end_cd)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
                    self.cd_time = _ED.cross_server_kings_battle.cross_server_kings_battle_next_time/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
                end
            end
        end
        protocol_command.the_kings_battle_self_battle_peakedness_duel_info.param_list = ""
        NetworkManager:register(protocol_command.the_kings_battle_self_battle_peakedness_duel_info.code, nil, nil, nil, self, requesrDefendCheck, false, nil)  
    else
        local function requesrDefendCheck(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                    self:onUpdateDraw()
                    self.cd_time = tonumber(_ED.cross_server_kings_battle.single_field_end_cd)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
                end
            end
        end
        protocol_command.the_kings_battle_self_battle_peakedness_duel_info.param_list = ""
        NetworkManager:register(protocol_command.the_kings_battle_self_battle_peakedness_duel_info.code, nil, nil, nil, self, requesrDefendCheck, false, nil)  
        self.cd_time = 0
    end

    local h_times,m_times,s_times = self:getTimeDesByInterval(self.cd_time)
    ccui.Helper:seekWidgetByName(self.roots[1],"AtlasLabel_djs_m"):setString(m_times)
    ccui.Helper:seekWidgetByName(self.roots[1],"AtlasLabel_djs_s"):setString(s_times)
end

function SmCrossServerBattleofKingsReview:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
    self:onInit()
    return self
end

function SmCrossServerBattleofKingsReview:onExit()
    state_machine.remove("sm_cross_server_battleof_kings_review_show")    
    state_machine.remove("sm_cross_server_battleof_kings_review_hide")
    state_machine.remove("sm_cross_server_battleof_kings_review_update_draw")
end
