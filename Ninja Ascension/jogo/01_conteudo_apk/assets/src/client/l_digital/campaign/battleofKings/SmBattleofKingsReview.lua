-----------------------------
--王者之战赛程回顾界面
-----------------------------
SmBattleofKingsReview = class("SmBattleofKingsReviewClass", Window)
SmBattleofKingsReview.__size = nil

local sm_battleof_kings_review_window_open_terminal = {
    _name = "sm_battleof_kings_review_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = SmBattleofKingsReview:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_battleof_kings_review_window_open_terminal)
state_machine.init()

function SmBattleofKingsReview:ctor()
    self.super:ctor()
    self.roots = {}

    self.prop_list = {}
    self.list_object = {}
    self.cd_time = 0
    self.battle_times = {}
    self.battle_id = {}
    self.result_win = {}

    local function init_sm_battleof_kings_review_terminal()
        --显示界面
        local sm_battleof_kings_review_show_terminal = {
            _name = "sm_battleof_kings_review_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                if tonumber(_ED.kings_battle.kings_battle_open_type) == 4 then
                    local function requesrDefendCheck(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots[1] ~= nil then
                                instance:onUpdateDraw()
                                instance.cd_time = tonumber(_ED.kings_battle.single_field_end_cd)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
                            end
                        end
                    end
                    protocol_command.the_kings_battle_manager.param_list = "5"
                    NetworkManager:register(protocol_command.the_kings_battle_manager.code, nil, nil, nil, self, requesrDefendCheck, false, nil)  
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
        local sm_battleof_kings_review_hide_terminal = {
            _name = "sm_battleof_kings_review_hide",
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

        local sm_battleof_kings_review_update_draw_terminal = {
            _name = "sm_battleof_kings_review_update_draw",
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

        local sm_battleof_kings_review_look_peak_formation_terminal = {
            _name = "sm_battleof_kings_review_look_peak_formation",
            _init = function (terminal) 
                app.load("client.l_digital.campaign.battleofKings.SmBattleofKingsViewPeakFormation")
                app.load("client.l_digital.campaign.battleofKings.SmBattleofKingsMyPeakFormation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance == nil or instance.list_object == nil then
				    return
                end
                local index = params._datas.index
                if tonumber(instance.list_object[""..tonumber(index)].id) == tonumber(_ED.user_info.user_id) and tonumber(_ED.kings_battle.kings_battle_type) ~= 0 and _ED.kings_battle.kings_battle_type ~= 3 then
                    state_machine.excute("sm_battleof_kings_my_peak_formation_open", 0, {instance.list_object[""..tonumber(index)]})
                else
                    local function requesrDefendCheck(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots[1] ~= nil then
                                -- 加一个参数区分是巅峰对决的数据
                                state_machine.excute("sm_battleof_kings_view_peak_formation_open", 0, {instance.list_object[""..tonumber(index)], 1})
                                instance.cd_time = tonumber(_ED.kings_battle.single_field_end_cd)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
                            end
                        end
                    end
                    protocol_command.the_kings_battle_manager.param_list = "5"
                    NetworkManager:register(protocol_command.the_kings_battle_manager.code, nil, nil, nil, instance, requesrDefendCheck, false, nil)
                end
                    
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_battleof_kings_review_play_back_battle_terminal = {
            _name = "sm_battleof_kings_review_play_back_battle",
            _init = function (terminal) 
                app.load("client.battle.BattleStartEffect")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            _ED.battle_playback_arena.playback = true
                            _ED.battle_playback_arena.nType = 211
                            _ED.battle_playback_arena.time = self.battle_times[tonumber(index)]
                            
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

                            _ED.kings_battle.enterBattleFromKingsReview = true

                            fwin:close(self.userInformationHeroStorage)
                            fwin:cleanView(fwin._windows)
                            fwin:freeAllMemeryPool()
                            local bse = BattleStartEffect:new()
                            bse:init(_enum_fight_type._fight_type_211)
                            fwin:open(bse, fwin._windows)
                        end 
                    end
                end
                protocol_command.get_share_message.param_list = instance.battle_id[tonumber(index)].."\r\n".."211".."\r\n"..instance.battle_times[tonumber(index)].."\r\n".."1"
                NetworkManager:register(protocol_command.get_share_message.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_battleof_kings_review_show_terminal)   
        state_machine.add(sm_battleof_kings_review_hide_terminal)
        state_machine.add(sm_battleof_kings_review_update_draw_terminal)
        state_machine.add(sm_battleof_kings_review_look_peak_formation_terminal)
        state_machine.add(sm_battleof_kings_review_play_back_battle_terminal)

        state_machine.init()
    end
    init_sm_battleof_kings_review_terminal()
end

function SmBattleofKingsReview:onHide()
    self:setVisible(false)
end

function SmBattleofKingsReview:onShow()
    self:setVisible(true)
end

function SmBattleofKingsReview:getTimeDesByInterval( timeInt )

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

function SmBattleofKingsReview:onUpdateDraw()
    local root = self.roots[1]
    local Image_djs_bg = ccui.Helper:seekWidgetByName(root,"Image_djs_bg")
    if tonumber(_ED.kings_battle.kings_battle_open_type) == 4 then
        Image_djs_bg:setVisible(true)      
    else
        Image_djs_bg:setVisible(false)
    end
    
    local Panel_dfdj_cc = ccui.Helper:seekWidgetByName(root,"Panel_dfdj_cc")
    Panel_dfdj_cc:removeBackGroundImage()
    Panel_dfdj_cc:setBackGroundImage(string.format("images/ui/text/SMZB_res/dfdj_cc/dfdj_cc_%d.png", 1))
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
    -- self.list_object = _ED.kings_battle.peak_list
    -- local function fightingCapacity(a,b)
    --     local a2 = zstring.split(a.result, "|")[11]
    --     local b2 = zstring.split(b.result, "|")[11]
    --     local al = tonumber(zstring.split(a2, ",")[4])
    --     local bl = tonumber(zstring.split(b2, ",")[4])
    --     local result = false
    --     if al < bl then
    --         result = true
    --     end
    --     return result 
    -- end
    -- table.sort(self.list_object, fightingCapacity)
    
    --画第一轮数据
    for i,v in pairs(_ED.kings_battle.peak_list) do
        local result = zstring.split(v.result, "|")[11]
        if result ~= nil then
            local result_info = zstring.split(result, ",")
            if tonumber(result_info[4]) ~= 0 then
                local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root,"Panel_digimon_icon_"..tonumber(result_info[4]))
                
                Panel_digimon_icon:removeAllChildren(true)
                local formation = zstring.split(v.formation, "!")[1]
                local datas = zstring.split(formation,":")
                local cell = ShipIconCell:createCell()
                local ships = {}
                ships.ship_template_id = datas[1]
                ships.evolution_status = datas[3]
                ships.Order = datas[5]
                ships.ship_grade = datas[2]
                ships.StarRating = datas[4]
                ships.skin_id = datas[11]
                cell:init(ships,cell.enum_type._BATTLE_OF_KINGS_ARRANGE_FORMATION)
                Panel_digimon_icon:addChild(cell)

                local Text_player_name = ccui.Helper:seekWidgetByName(root,"Text_player_name_"..tonumber(result_info[4]))
                Text_player_name:setString(v.name)
                local index = 0 
                if tonumber(result_info[4]) == 1 or tonumber(result_info[4]) == 2 then
                    index = 1
                    -- table.insert(self.list_object, v)
                elseif tonumber(result_info[4])  == 3 or tonumber(result_info[4])  == 4 then
                    index = 2 
                    -- table.insert(self.list_object, v)
                elseif tonumber(result_info[4])  == 5 or tonumber(result_info[4])  == 6 then
                    index = 3
                    -- table.insert(self.list_object, v)
                elseif tonumber(result_info[4])  == 7 or tonumber(result_info[4])  == 8 then
                    index = 4
                    -- table.insert(self.list_object, v)
                end
                self.list_object[""..result_info[4]] = v
                local Panel_vs = ccui.Helper:seekWidgetByName(root,"Panel_vs_"..index)
                -- if tonumber(_ED.kings_battle.kings_battle_open_type) == 4 then

                -- else
                    if Panel_vs:isVisible() == false then
                        Panel_vs:setVisible(true)
                    end
                -- end

                if tonumber(result_info[1]) == 1 then
                    --胜利
                    self.battle_times[index] = result_info[2]
                    self.battle_id[index] = v.id
                    ccui.Helper:seekWidgetByName(root,"Image_win_"..tonumber(result_info[4])):setVisible(true)
                    ccui.Helper:seekWidgetByName(root,"Image_line_win_"..tonumber(result_info[4])):setVisible(true)
                    ccui.Helper:seekWidgetByName(root,"Image_lose_"..tonumber(result_info[4])):setVisible(false)
                    self.result_win[i] = 1
                elseif tonumber(result_info[1]) == 0 then
                    --失败
                    ccui.Helper:seekWidgetByName(root,"Image_win_"..tonumber(result_info[4])):setVisible(false)
                    ccui.Helper:seekWidgetByName(root,"Image_line_win_"..tonumber(result_info[4])):setVisible(false)
                    ccui.Helper:seekWidgetByName(root,"Image_lose_"..tonumber(result_info[4])):setVisible(true)
                    self.result_win[i] = -1
                else
                    ccui.Helper:seekWidgetByName(root,"Image_win_"..tonumber(result_info[4])):setVisible(false)
                    ccui.Helper:seekWidgetByName(root,"Image_line_win_"..tonumber(result_info[4])):setVisible(false)
                    ccui.Helper:seekWidgetByName(root,"Image_lose_"..tonumber(result_info[4])):setVisible(false)
                    self.result_win[i] = 0
                end
            end
        end
    end 
    --画第二轮数据
    for i = 9, 10 do
        for j,w in pairs(_ED.kings_battle.peak_list) do
            local result = zstring.split(w.result, "|")
            if result[12] ~= nil then
                local result_info = zstring.split(result[12], ",")
                if tonumber(result_info[4]) == i then
                    if tonumber(result_info[1]) ~= -1 then
                        local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root,"Panel_digimon_icon_"..tonumber(result_info[4]))
                        Panel_digimon_icon:removeAllChildren(true)
                        local formation = zstring.split(w.formation, "!")[4]
                        local datas = zstring.split(formation,":")
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
                    end
                    local Text_player_name2 = ccui.Helper:seekWidgetByName(root,"Text_player_name_"..i)
                    Text_player_name2:setString("????")
                    local index = 0 
                    if tonumber(result_info[4]) == 9 then
                        index = 5
                        -- table.insert(self.list_object, w)
                    elseif tonumber(result_info[4])  == 10 then
                        index = 6
                        -- table.insert(self.list_object, w)
                    end
                    self.list_object[""..result_info[4]] = w
                    local Panel_vs = ccui.Helper:seekWidgetByName(root,"Panel_vs_"..index)
                    if tonumber(_ED.kings_battle.kings_battle_open_type) == 4 then
                        if tonumber(result_info[1]) ~= -1 then
                            Panel_vs:setVisible(true)
                            Text_player_name2:setString(w.name)
                        else
                            Panel_vs:setVisible(false)
                            Text_player_name2:setString("????")
                        end
                        
                    else
                        if Panel_vs:isVisible() == false then
                            Panel_vs:setVisible(true)
                        end
                        Text_player_name2:setString(w.name)
                    end
                    if tonumber(result_info[1]) == 1 then
                        local pos = zstring.split(result[11], ",")[4]
                        if tonumber(pos) == 1 or tonumber(pos) == 2 then
                            ccui.Helper:seekWidgetByName(root,"Image_line_win_9"):setVisible(true)
                            ccui.Helper:seekWidgetByName(root,"Image_line_win_10"):setVisible(false)
                        elseif tonumber(pos) == 3 or tonumber(pos) == 4 then
                            ccui.Helper:seekWidgetByName(root,"Image_line_win_11"):setVisible(true)
                            ccui.Helper:seekWidgetByName(root,"Image_line_win_12"):setVisible(false)
                        elseif tonumber(pos) == 5 or tonumber(pos) == 6 then
                            ccui.Helper:seekWidgetByName(root,"Image_line_win_9"):setVisible(false)
                            ccui.Helper:seekWidgetByName(root,"Image_line_win_10"):setVisible(true)
                        elseif tonumber(pos) == 7 or tonumber(pos) == 8 then
                            ccui.Helper:seekWidgetByName(root,"Image_line_win_11"):setVisible(false)
                            ccui.Helper:seekWidgetByName(root,"Image_line_win_12"):setVisible(true)
                        end
                        self.battle_times[index] = result_info[2]
                        self.battle_id[index] = w.id
                    end
                    if result[13] ~= nil then
                        if tonumber(result_info[1]) == 1 then
                            --胜利
                            ccui.Helper:seekWidgetByName(root,"Image_win_"..tonumber(result_info[4])):setVisible(true)
                            ccui.Helper:seekWidgetByName(root,"Image_lose_"..tonumber(result_info[4])):setVisible(false)
                            self.result_win[i] = 1
                        elseif tonumber(result_info[1]) == 0 then
                            --失败
                            ccui.Helper:seekWidgetByName(root,"Image_win_"..tonumber(result_info[4])):setVisible(false)
                            ccui.Helper:seekWidgetByName(root,"Image_lose_"..tonumber(result_info[4])):setVisible(true)
                            self.result_win[i] = -1
                        else
                            ccui.Helper:seekWidgetByName(root,"Image_win_"..tonumber(result_info[4])):setVisible(false)
                            ccui.Helper:seekWidgetByName(root,"Image_lose_"..tonumber(result_info[4])):setVisible(false)
                            self.result_win[i] = 0
                        end
                    end
                end
            end  
        end
    end
    --画第三轮数据
    for j,w in pairs(_ED.kings_battle.peak_list) do
        local result = zstring.split(w.result, "|")
        if result[13] ~= nil then
            local result_info = zstring.split(result[13], ",")
            if tonumber(result_info[4]) == 11 then
                if tonumber(result_info[1]) ~= -1 then
                    local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root,"Panel_digimon_icon_"..tonumber(result_info[4]))
                    Panel_digimon_icon:removeAllChildren(true)
                    local formation = zstring.split(w.formation, "!")[7]
                    local datas = zstring.split(formation,":")
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
                end
                local Text_player_name3 = ccui.Helper:seekWidgetByName(root,"Text_player_name_11")
                Text_player_name3:setString("")
                local Panel_vs = ccui.Helper:seekWidgetByName(root,"Panel_vs_7")
                if tonumber(_ED.kings_battle.kings_battle_open_type) == 4 then
                    if tonumber(result_info[1]) ~= -1 then
                        Panel_vs:setVisible(true)
                        Text_player_name3:setString(w.name)
                    else
                        Panel_vs:setVisible(false)
                        Text_player_name3:setString("????")
                    end
                else
                    if Panel_vs:isVisible() == false then
                        Panel_vs:setVisible(true)
                    end
                    Text_player_name3:setString(w.name)
                end
                local pos = zstring.split(result[11], ",")[4]
                if tonumber(pos) == 1 or tonumber(pos) == 2 or tonumber(pos) == 5 or tonumber(pos) == 6 then
                    ccui.Helper:seekWidgetByName(root,"Image_line_win_13"):setVisible(true)
                    ccui.Helper:seekWidgetByName(root,"Image_line_win_14"):setVisible(false)
                else
                    ccui.Helper:seekWidgetByName(root,"Image_line_win_13"):setVisible(false)
                    ccui.Helper:seekWidgetByName(root,"Image_line_win_14"):setVisible(true)
                end
                self.battle_times[7] = result_info[2]
                self.battle_id[7] = w.id
                -- table.insert(self.list_object, w)
                self.list_object[""..result_info[4]] = w

                self.result_win[11] = 1
            end
        end
    end

    -- if tonumber(_ED.kings_battle.kings_battle_open_type) == 4 then
    --     local isOver = 0
    --     for i,v in pairs(_ED.kings_battle.peak_list) do
    --         if zstring.split(v.result, "|")[13] ~= nil then
    --             if self.cd_time == 0 then
    --                 isOver = 3
    --             else
    --                 isOver = 2
    --             end
    --             break
    --         end
    --         if zstring.split(v.result, "|")[12] ~= nil then
    --             isOver = 1
    --             break
    --         end
    --     end     
    --     if isOver == 3 then  
    --         for i=1, 7 do
    --             ccui.Helper:seekWidgetByName(root,"Panel_vs_"..i):setVisible(true)
    --         end   
    --     elseif isOver == 2 then
    --         for i=1, 6 do
    --             ccui.Helper:seekWidgetByName(root,"Panel_vs_"..i):setVisible(true)
    --         end
    --     elseif isOver == 1 then
    --         for i=1, 4 do
    --             ccui.Helper:seekWidgetByName(root,"Panel_vs_"..i):setVisible(true)
    --         end
    --     end
    -- end
end

function SmBattleofKingsReview:onUpdate(dt)
    if self.cd_time > 0 then
        self.cd_time = self.cd_time - dt
        local h_times,m_times,s_times = self:getTimeDesByInterval(self.cd_time)
        ccui.Helper:seekWidgetByName(self.roots[1],"AtlasLabel_djs_m"):setString(m_times)
        ccui.Helper:seekWidgetByName(self.roots[1],"AtlasLabel_djs_s"):setString(s_times)
        if tonumber(_ED.kings_battle.kings_battle_open_type) == 4 then
            if self.cd_time <= 0 then
                local function requesrDefendCheck(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots[1] ~= nil then
                            self.cd_time = tonumber(_ED.kings_battle.single_field_end_cd)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
                            self:onUpdateDraw()
                        end
                    else
                        fwin:addService({
                            callback = function ( params )
                                if params ~= nil and params.roots[1] ~= nil then
                                    protocol_command.the_kings_battle_manager.param_list = "5"
                                    NetworkManager:register(protocol_command.the_kings_battle_manager.code, nil, nil, nil, params, requesrDefendCheck, false, nil) 
                                end 
                            end,
                            delay = 1,
                            params = response.node
                        })
                    end
                end
                protocol_command.the_kings_battle_manager.param_list = "5"
                NetworkManager:register(protocol_command.the_kings_battle_manager.code, nil, nil, nil, self, requesrDefendCheck, false, nil)  
            end
        end
    end
end

function SmBattleofKingsReview:onEnterTransitionFinish()

end

function SmBattleofKingsReview:onInit( )
    local csbItem = csb.createNode("campaign/BattleofKings/battle_of_kings_tab_1_3.csb")
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    if SmBattleofKingsReview.__size == nil then
        SmBattleofKingsReview.__size = root:getContentSize()
    end
    self:setContentSize(SmBattleofKingsReview.__size)

    for i=1, 11 do
        local Panel_head = ccui.Helper:seekWidgetByName(root,"Panel_head_"..i)
        fwin:addTouchEventListener(Panel_head, nil, 
        {
            terminal_name = "sm_battleof_kings_review_look_peak_formation", 
            terminal_state = 0, 
            index = i
        }, nil, 0)
    end

    for i=1, 7 do
        local Button_chakan = ccui.Helper:seekWidgetByName(root,"Button_chakan_"..i)
        fwin:addTouchEventListener(Button_chakan, nil, 
        {
            terminal_name = "sm_battleof_kings_review_play_back_battle", 
            terminal_state = 0, 
            index = i
        }, nil, 0)
    end

    if tonumber(_ED.kings_battle.kings_battle_open_type) == 4 then
        local function requesrDefendCheck(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                    self:onUpdateDraw()
                    self.cd_time = tonumber(_ED.kings_battle.single_field_end_cd)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
                end
            end
        end
        protocol_command.the_kings_battle_manager.param_list = "5"
        NetworkManager:register(protocol_command.the_kings_battle_manager.code, nil, nil, nil, self, requesrDefendCheck, false, nil)  
    else
        self:onUpdateDraw()
        self.cd_time = 0
    end

    local h_times,m_times,s_times = self:getTimeDesByInterval(self.cd_time)
    ccui.Helper:seekWidgetByName(self.roots[1],"AtlasLabel_djs_m"):setString(m_times)
    ccui.Helper:seekWidgetByName(self.roots[1],"AtlasLabel_djs_s"):setString(s_times)
end

function SmBattleofKingsReview:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
    self:onInit()
    return self
end

function SmBattleofKingsReview:onExit()
    state_machine.remove("sm_battleof_kings_review_show")    
    state_machine.remove("sm_battleof_kings_review_hide")
    state_machine.remove("sm_battleof_kings_review_update_draw")
end
