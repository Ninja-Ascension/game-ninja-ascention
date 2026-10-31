-- ----------------------------------------------------------------------------------------------------
-- 说明：排位赛列表界面
-------------------------------------------------------------------------------------------------------
AdventureArenaWarcraftList = class("AdventureArenaWarcraftListClass", Window)

function AdventureArenaWarcraftList:ctor()
    self.super:ctor()
    self.roots = {}
    self.isTouchLock = false
    self.interval = 0
    self.remain_times = 0 
    self.current_times = 0
    self.totallimit = 0
    self.needUpdateRefreshCd = false
    --控制倒计时到了之后请求刷新次数
    self.isTimeCommander = false
    -- 显示CD的时间
    self.strtime = nil
    self.isGetServer = false
    self.remainCounts = 0
    self.ArmatureNode_tip = nil --晋级动画
    self.ArmatureNode_success = nil -- 成功动画
    self.ArmatureNode_fail = nil --失败动画
    self.result_tip_type = 0
    app.load("client.adventure.cells.arena.AdventureArenaWarcraftListCell")
    app.load("client.utils.TimeUtil")
    -- Initialize adventure arena state machine.
    local function init_adventure_arena_warcraft_list_terminal()
        --刷新对手
        local adventure_arena_warcraft_list_refresh_terminal = {
            _name = "adventure_arena_warcraft_list_refresh",
            _init = function (terminal)
                app.load("client.adventure.campaign.arena.warcraft.AdventureArenaWarcraftRefreshRival")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            
                local function responseRefreshFighterCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        instance:onUpdateDrawList()
                    end
                end

                NetworkManager:register(protocol_command.warcraft_rush_fighter.code, nil, nil, nil, instance, responseRefreshFighterCallback, true, nil)    
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local adventure_arena_warcraft_list_refresh_info_terminal = {
            _name = "adventure_arena_warcraft_list_refresh_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots[1] ~= nil then 
                    instance:onUpdateDrawList()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local adventure_arena_warcraft_list_refresh_fight_counts_terminal = {
            _name = "adventure_arena_warcraft_list_refresh_fight_counts",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots[1] ~= nil then 
                    instance:checkFightCounts()
                    instance:onUpdateDrawFigthCounts()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local adventure_arena_warcraft_list_refresh_win_counts_terminal = {
            _name = "adventure_arena_warcraft_list_refresh_win_counts",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots[1] ~= nil then 
                    instance:onUpdateWinCount()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local adventure_arena_warcraft_list_reward_terminal = {
            _name = "adventure_arena_warcraft_list_reward",
            _init = function (terminal)
                app.load("client.adventure.campaign.arena.warcraft.AdventureArenaWarcraftMoreReward")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureArenaWarcraftMoreReward:new(),fwin._windows)    
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --增加次数
        local adventure_arena_warcraft_list_add_fight_counts_terminal = {
            _name = "adventure_arena_warcraft_list_add_fight_counts",
            _init = function (terminal)
                app.load("client.adventure.campaign.arena.warcraft.AdventureArenaWarcraftRefreshRival")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                fwin:open(AdventureArenaWarcraftRefreshRival:new():init(2), fwin._windows)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --返回
        local adventure_arena_warcraft_list_close_terminal = {
            _name = "adventure_arena_warcraft_list_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("AdventureArenaWarcraftListClass"))
                if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
                    or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge
                    or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                    or __lua_project_id == __lua_project_warship_girl_b 
                    then 
                    fwin:open(AdventureArenaWarcraft:new(), fwin._view)
                else    
                    fwin:open(AdventureArenaWarcraft:new(), fwin._windows)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --有奖励刷新
        local adventure_arena_warcraft_reward_tip_update_terminal = {
            _name = "adventure_arena_warcraft_reward_tip_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDrawRewardTip()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --播放战斗结果晋级等动画
        local adventure_arena_warcraft_reward_tip_action_update_terminal = {
            _name = "adventure_arena_warcraft_reward_tip_action_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onPlayAction(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        
        --规则
        local adventure_arena_warcraft_list_rule_terminal = {
            _name = "adventure_arena_warcraft_list_rule",
            _init = function (terminal)
                app.load("client.adventure.campaign.arena.warcraft.AdventureArenaWarcraftRule")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureArenaWarcraftRule:new():init(1),fwin._windows)    
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --排行
        local adventure_arena_warcraft_list_rank_terminal = {
            _name = "adventure_arena_warcraft_list_rank",
            _init = function (terminal)
               app.load("client.adventure.campaign.arena.warcraft.AdventureArenaWarcraftRankList")     
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseRankCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        fwin:open(AdventureArenaWarcraftRankList:new(),fwin._windows)        
                    end
                end
                if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
                    or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge 
                    or __lua_project_id == __lua_project_yugioh 
                    or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                    or __lua_project_id == __lua_project_warship_girl_b 
                    then 
                    local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
                    protocol_command.warcraft_show_rank_list.param_list = currentServerNumber
                    NetworkManager:register(protocol_command.warcraft_show_rank_list.code, _ED.union_fight_url, nil, nil, nil, responseRankCallBack, false, nil)
                else
                    NetworkManager:register(protocol_command.warcraft_show_rank_list.code, nil, nil, nil, nil, responseRankCallBack, false, nil)
                end
        
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
    
        state_machine.add(adventure_arena_warcraft_list_refresh_terminal)
        state_machine.add(adventure_arena_warcraft_list_reward_terminal)
        state_machine.add(adventure_arena_warcraft_list_close_terminal)
        state_machine.add(adventure_arena_warcraft_list_rank_terminal)
        state_machine.add(adventure_arena_warcraft_list_rule_terminal)
        state_machine.add(adventure_arena_warcraft_list_refresh_info_terminal)
        state_machine.add(adventure_arena_warcraft_list_add_fight_counts_terminal)
        state_machine.add(adventure_arena_warcraft_list_refresh_fight_counts_terminal)
        state_machine.add(adventure_arena_warcraft_reward_tip_action_update_terminal)
        state_machine.add(adventure_arena_warcraft_reward_tip_update_terminal)
        state_machine.add(adventure_arena_warcraft_list_refresh_win_counts_terminal)
        state_machine.init()
    end
    
    -- call func init adventure arena state machine.
    init_adventure_arena_warcraft_list_terminal()
end

function AdventureArenaWarcraftList:init(isGetServer)
    if isGetServer ~= nil and isGetServer == true then 
        self.isGetServer = true
    else
        self.isGetServer = false
    end
    return self
end

function AdventureArenaWarcraftList:updateRefreshCd()
    local root = self.roots[1]
    self.interval = math.max(0, self.interval)
    local timeTabel = formatTime(self.interval)
    self.strtime = timeTabel.hour
    self.strtime = self.strtime .. string.format(":%02d", timeTabel.minute)
    self.strtime = self.strtime .. string.format(":%02d", timeTabel.second)

   ccui.Helper:seekWidgetByName(root, "Text_cd"):setString(self.strtime)
    
end

function AdventureArenaWarcraftList:onUpdate(dt)
    if zstring.tonumber(self.remainCounts) >= zstring.tonumber(self.totallimit) then 
        local root = self.roots[1]
        ccui.Helper:seekWidgetByName(root,"Text_cd"):setString("00:00:00")
        return
    end
    local current_time = os.time() 
    local interval = self.remain_times + self.current_times - current_time +1
    if interval ~= self.interval and interval > 0 then
        self.interval = math.floor(interval)
        self:updateRefreshCd()
    end
    if self.interval > 0 then
        self.isTimeCommander = false
    else
        local root = self.roots[1]
        ccui.Helper:seekWidgetByName(root,"Text_cd"):setString("00:00:00") 
        local function responseRankCallBack(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots[1] ~= nil then
                    self:checkFightCounts()
                    self:onUpdateDrawFigthCounts()
                    self.isTimeCommander = true
                end
            end
        end
        --倒计时结束后 次数加1
        if self.isTimeCommander == false then
            local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
            protocol_command.rush_fight_times.param_list = currentServerNumber
            NetworkManager:register(protocol_command.rush_fight_times.code, _ED.union_fight_url, nil, nil, self, responseRankCallBack, false, nil)
        end
    end
end

--有奖励刷新提示
function AdventureArenaWarcraftList:onUpdateDrawRewardTip()
    local root = self.roots[1]
    local rewardButton = ccui.Helper:seekWidgetByName(root, "Button_level_reward")
    
    local states = zstring.split("" .. _ED.warcraft_info.get_reward_states, ",")
    local isNeedTip = false
    for i=1,26 do
        local current_state = states[i]
        if i <= zstring.tonumber(_ED.warcraft_info.current_history_best_title) then 
        --可以领取
            if zstring.tonumber(current_state) == 0  then  -- 0 未领取 1 已经领取
                --未领取的
                isNeedTip = true
            end
        end
    end
    local states_1 = zstring.split("" .. _ED.warcraft_info.current_win_reward_buy_states, ",")
    for i=1,12 do
        local current_state = states_1[i]
        local current_win = dms.int(dms["warcraft_win_reward"],i, warcraft_win_reward.win_count)
        if current_win <= zstring.tonumber(_ED.warcraft_info.current_win_max_count) then 
        --可以领取
            if zstring.tonumber(current_state) == 0  then  -- 0 未领取 1 已经领取
                --未领取的
                isNeedTip = true
            end
        end
    end
    local tipBall = rewardButton:getChildByName("ball")
    if isNeedTip == true then 
        
        if tipBall ~= nil then 
        else
            local ball = nil
            if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
                or __lua_project_id == __lua_project_pokemon 
                or __lua_project_id == __lua_project_rouge 
                or __lua_project_id == __lua_project_yugioh 
                or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                or __lua_project_id == __lua_project_warship_girl_b 
                then 
                ball = cc.Sprite:create("images/ui/bar/tips.png")
            else
                ball = cc.Sprite:create("images/ui/icon/bg_reward_tag.png")
            end
            
            ball:setName("ball")
            ball:setAnchorPoint(cc.p(1, 1))
            ball:setPosition(cc.p(rewardButton:getContentSize().width + 5 , rewardButton:getContentSize().height))
            rewardButton:addChild(ball)
        end
    else
        if tipBall ~= nil then 
            rewardButton:removeChildByName("ball")
        end
    end
end

function AdventureArenaWarcraftList:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local currentState = zstring.tonumber(_ED.warcraft_info.current_state) -- 当前状态 (0普通比赛1晋级赛2定段赛)
    local putongPanel = ccui.Helper:seekWidgetByName(root, "Panel_putong")
    local jingjiPanel = ccui.Helper:seekWidgetByName(root, "Panel_jinji")
    local duanweiPanel = ccui.Helper:seekWidgetByName(root, "Panel_dingduan")
    local is_digimon = false
    ccui.Helper:seekWidgetByName(root, "Text_duanwei"):setString(dms.string(dms["warcraft_mould"], _ED.warcraft_info.current_title_id, warcraft_mould.title_name))
    ccui.Helper:seekWidgetByName(root, "Text_19"):setString("" .._ED.warcraft_info.current_win_count)
    ccui.Helper:seekWidgetByName(root, "Text_18"):setString("" .._ED.warcraft_info.current_integral)
    local Text_17_1 = ccui.Helper:seekWidgetByName(root, "Text_17_1")
    Text_17_1:setString("".. _ED.user_info.user_name)
    if ___is_open_leadname == true then
        Text_17_1:setFontName("")
        Text_17_1:setFontSize(Text_17_1:getFontSize())
    end
    if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh 
        or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
        or __lua_project_id == __lua_project_warship_girl_b 
        then 
        ccui.Helper:seekWidgetByName(root, "Text_bslx"):setString(warcraft_tip[21 + currentState])
        is_digimon = true
    else    
        ccui.Helper:seekWidgetByName(root, "Text_bslx"):setString(_string_piece_info[461 + currentState])
        is_digimon = false
    end
    
    ccui.Helper:seekWidgetByName(root, "AtlasLabel_liansheng"):setString("".._ED.warcraft_info.current_win_counts)
   
    local rore_panel = ccui.Helper:seekWidgetByName(root, "Panel_role")
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then 
    else
        rore_panel:removeAllChildren(true)
        rore_panel:removeBackGroundImage()
        if is_digimon == true then 
            
            local ship = fundShipWidthId(_ED.user_formetion_status[1])
        
            local playerIconStr = ""
            if ship ~= nil then
                local map = _user_information_head_index
                local ptype = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.capacity)--角色头像类型
                local level = zstring.tonumber(ship.ship_type) -- 品质等级
                playerIconStr = string.format("images/ui/home/head_%s.png", map[ptype][level])
            else 
                playerIconStr = string.format("images/ui/home/head_%s.png", _ED.user_info.user_head)
            end
           rore_panel:setBackGroundImage(playerIconStr)
        else
            local armature1 = AdventureSpriteRole:create(500 + zstring.tonumber(_ED.user_info.user_head))
            armature1:setPosition(cc.p(rore_panel:getContentSize().width/2,-rore_panel:getContentSize().height/2))
            rore_panel:addChild(armature1)
        end
    end
    -- 排名
    if zstring.tonumber(_ED.warcraft_info.current_rank) == 0 then 
        if is_digimon == true then 
            ccui.Helper:seekWidgetByName(root, "Text_17_paiming"):setString(warcraft_tip[1])
        else
            ccui.Helper:seekWidgetByName(root, "Text_17_paiming"):setString(_string_piece_info[440])
        end
        
    else
        ccui.Helper:seekWidgetByName(root, "Text_17_paiming"):setString("" .._ED.warcraft_info.current_rank )
    end
    self:onUpdateDrawRewardTip()
    ccui.Helper:seekWidgetByName(root, "Text_cd") --CD 时间
    self:onUpdateDrawFigthCounts()
    putongPanel:setVisible(currentState == 0)
    jingjiPanel:setVisible(currentState == 1)
    duanweiPanel:setVisible(currentState == 2)
    if currentState == 0 then  

        local totallimit1 = dms.int(dms["warcraft_mould"], _ED.warcraft_info.current_title_id, warcraft_mould.rank_score_limit)
        local totallimit2 = dms.int(dms["warcraft_mould"], _ED.warcraft_info.current_title_id, warcraft_mould.rank_win_score_limit)
        
        local percent = zstring.tonumber(_ED.warcraft_info.current_match_integral)/ totallimit1 * 100
        if percent >= 100 then 
            percent = 100 
        end
        if percent<=0 then 
            percent = 0
        end
        ccui.Helper:seekWidgetByName(root, "LoadingBar_1"):setPercent(percent)
        if totallimit1 == -1 then 
            totallimit1 = "∞"
        end
        ccui.Helper:seekWidgetByName(root, "Text_41_jifen"):setString("".._ED.warcraft_info.current_match_integral.. "/" ..totallimit1)

        local percent2 = zstring.tonumber(_ED.warcraft_info.current_win_count)/ totallimit2 * 100
        if percent2 >= 100 then 
            percent2 = 100 
        end
        if percent2<=0 then 
            percent2 = 0
        end
        ccui.Helper:seekWidgetByName(root, "LoadingBar_2"):setPercent(percent2)
        if totallimit2 == -1 then 
            totallimit2 = "∞"
        end
        ccui.Helper:seekWidgetByName(root, "Text_41_shengdian"):setString("".._ED.warcraft_info.current_win_count.. "/" ..totallimit2)
        
    elseif currentState == 1 then 
        local states = zstring.split("" .. _ED.warcraft_info.fight_states,",")
        for i=1,3 do
            local statePanel = ccui.Helper:seekWidgetByName(root, "Panel_jj_".. i)
            statePanel:removeAllChildren(true)
            statePanel:removeBackGroundImage()
            if i <= #states then 
                if zstring.tonumber(states[i]) == 1 then
                    --胜利
                    if is_digimon == true then 
                        statePanel:setBackGroundImage("images/ui/slots/duigou.png")   
                    else
                        statePanel:setBackGroundImage("images/ui/icon/button_decide_yes.png")   
                    end
                    
                elseif zstring.tonumber(states[i]) == 2 then 
                    --失败
                    if is_digimon == true then 
                        statePanel:setBackGroundImage("images/ui/slots/xshibai.png")        
                    else
                        statePanel:setBackGroundImage("images/ui/icon/button_decide_no.png")        
                    end
                end
            end 
        end  
    elseif currentState == 2 then 
        local states = zstring.split("" .. _ED.warcraft_info.fight_states,",")
        for i=1,5 do
            local statePanel = ccui.Helper:seekWidgetByName(root, "Panel_dd_".. i)
            statePanel:removeAllChildren(true)
            statePanel:removeBackGroundImage()
            if i <= #states then 
                if zstring.tonumber(states[i]) == 1 then
                    --胜利
                    if is_digimon == true then 
                        statePanel:setBackGroundImage("images/ui/slots/duigou.png")   
                    else
                        statePanel:setBackGroundImage("images/ui/icon/button_decide_yes.png")   
                    end
                elseif zstring.tonumber(states[i]) == 2 then 
                    --失败
                    if is_digimon == true then 
                        statePanel:setBackGroundImage("images/ui/slots/xshibai.png")        
                    else
                        statePanel:setBackGroundImage("images/ui/icon/button_decide_no.png")        
                    end
                    
                end
            end 
        end
    end
    self:onUpdateDrawList()
end

function AdventureArenaWarcraftList:onUpdateDrawFigthCounts()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local warcraftArr = nil 
    if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh 
        or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
        or __lua_project_id == __lua_project_warship_girl_b 
        then 
        warcraftArr = zstring.split(dms.string(dms["pirates_config"], 307, pirates_config.param), ",")
    else
        warcraftArr = zstring.split(dms.string(dms["pirates_config"], 333, pirates_config.param), ",")
    end
    
    local totalCounts = zstring.tonumber(warcraftArr[2])
    ccui.Helper:seekWidgetByName(root, "Text_cishu"):setString(""..self.remainCounts.. "/".. totalCounts)
    local addButton = ccui.Helper:seekWidgetByName(root, "Button_1")
    if zstring.tonumber(self.remainCounts) >= zstring.tonumber(totalCounts) then 
        addButton:setTouchEnabled(false)
        addButton:setColor(cc.c3b(150, 150, 150))
    else
        addButton:setTouchEnabled(true)
        addButton:setColor(cc.c3b(255, 255, 255))
    end
end

function AdventureArenaWarcraftList:onUpdateDrawList( ... )
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
    listView:removeAllItems()

    --if _ED.warcraft_info.rival_list == nil or #_ED.warcraft_info.rival_list ~= 4 then 
    if _ED.warcraft_info.rival_list == nil then 
        return
    end
    for i=1,4 do
        if i <= #_ED.warcraft_info.rival_list then 
            local cell = AdventureArenaWarcraftListCell:createCell()
            cell:init(_ED.warcraft_info.rival_list[i],i,self.result_tip_type)
            listView:addChild(cell)
        end
    end
    
    self.currentListView = listView
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    ---config 次数 -- _ED.warcraft_info.rival_info.refresh_tims
   -- counts_text:setString()

    local is_digimon = true --数码宝贝
    if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh 
        or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
        or __lua_project_id == __lua_project_warship_girl_b 
        then 
        is_digimon = true
    else
        is_digimon = false
    end
    local consumesText = ccui.Helper:seekWidgetByName(root, "Text_14")
    if _ED.warcraft_info.rival_info.refresh_times == 0 then
        local consumes = nil 
        if is_digimon == true then 
            consumes = zstring.split(dms.string(dms["pirates_config"], 311, pirates_config.param), ",")
        else
            consumes = zstring.split(dms.string(dms["pirates_config"], 337, pirates_config.param), ",")
        end
        
        local current_buy_times = zstring.tonumber(_ED.warcraft_info.rival_info.buy_times)
        if current_buy_times >= #consumes then 
            consume = consumes[#consumes]
        else
            consume = consumes[current_buy_times + 1]
        end
        ccui.Helper:seekWidgetByName(root, "Text_14_cishu"):setString("")
        if is_digimon == true then 
            if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then 
                consumesText:setString(string.format(warcraft_tip[20],consume))
                consumesText:setColor(cc.c3b(124, 194, 64))    
            else
                local xiaohaoText = ccui.Helper:seekWidgetByName(root, "Text_xiaohao_15")
                xiaohaoText:setString(consume .. _string_piece_info[207])
                xiaohaoText:setColor(cc.c3b(124, 194, 64))
            end
        else
            consumesText:setString(string.format(_string_piece_info[460],consume))
            consumesText:setColor(cc.c3b(124, 194, 64))
        end

        
    else
        --有免费次数
        ccui.Helper:seekWidgetByName(root, "Text_14_cishu"):setString("" .. _ED.warcraft_info.rival_info.refresh_times)
        
        if is_digimon == true then 
            if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then 
                consumesText:setString(warcraft_tip[24])
                consumesText:setColor(cc.c3b(255, 255, 255))
                ccui.Helper:seekWidgetByName(root, "Text_14_cishu"):setColor(cc.c3b(255, 255, 255))
                ccui.Helper:seekWidgetByName(root, "Text_14_cishu"):setVisible(true)
            else
                consumesText:setString(warcraft_tip[24])
                ccui.Helper:seekWidgetByName(root, "Text_xiaohao_15"):setString(warcraft_tip[24])    
            end
            
        else
            consumesText:setString(_string_piece_info[464])
            consumesText:setColor(cc.c3b(255, 255, 255))
            ccui.Helper:seekWidgetByName(root, "Text_14_cishu"):setColor(cc.c3b(255, 255, 255))
        end
        
    end
    
end

--计算挑战次数  !!每次都需要通过剩余时间重新计算
function AdventureArenaWarcraftList:checkFightCounts()
    -- body
    local current_time = os.time()
    local difference = current_time - _ED.warcraft_info.fight_remain_current_time -- 计算客户端已经过去了多长时间
    local current_remain_time = zstring.tonumber(_ED.warcraft_info.fight_remain_time)/1000 - difference  --还剩多久 秒
    --current_remain_time = -600
    self.remain_times = current_remain_time
    local warcraftArr = nil
    if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh 
        or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
        or __lua_project_id == __lua_project_warship_girl_b 
        then 
        warcraftArr = zstring.split(dms.string(dms["pirates_config"], 307, pirates_config.param), ",")    
    else
        warcraftArr = zstring.split(dms.string(dms["pirates_config"], 333, pirates_config.param), ",")    
    end
    
    local totalCounts = zstring.tonumber(warcraftArr[2])
    local countDown = zstring.tonumber(warcraftArr[3])
    self.totallimit = totalCounts
    self.current_times = current_time
    self.remainCounts = _ED.warcraft_info.fight_times
    if current_remain_time < 0  then 
        if self.remainCounts < totalCounts then
            self.remainCounts =  math.floor(math.abs(current_remain_time )/ (countDown * 60)) + 1 + _ED.warcraft_info.fight_times -->= totalCounts  
        end
        self.remain_times = math.abs(current_remain_time) %(countDown * 60)
        self.interval = self.remain_times + current_time
    else
        -- 还在当前次数里面
        self.interval = current_remain_time + current_time
        self.remain_times = current_remain_time
    end
    if _ED.warcraft_info.fight_times >= totalCounts then 
        self.interval = 0
    end
end

--播放晋级动画
function AdventureArenaWarcraftList:onPlayAction(actionIndex)
    local root = self.roots[1]
    if root == nil then 
        return
    end
    if actionIndex == 4 then 
        self.ArmatureNode_tip:setVisible(true)
        csb.animationChangeToAction(self.ArmatureNode_tip, 0, 0, false)
        self.ArmatureNode_tip._invoke = function(armatureBack)
        self.ArmatureNode_tip:setVisible(false)
            checkResultTip()
        end
    elseif actionIndex == 1 then 
        self.ArmatureNode_success:setVisible(true)
        csb.animationChangeToAction(self.ArmatureNode_success, 0, 0, false)
        self.ArmatureNode_success._invoke = function(armatureBack)
        self.ArmatureNode_success:setVisible(false)
            checkResultTip()
        end
    elseif actionIndex == 2 then 
        self.ArmatureNode_fail:setVisible(true)
        csb.animationChangeToAction(self.ArmatureNode_fail, 0, 0, false)
        self.ArmatureNode_fail._invoke = function(armatureBack)
        self.ArmatureNode_fail:setVisible(false)
            checkResultTip()
        end
    end
end

function AdventureArenaWarcraftList:onUpdateWinCount()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    ccui.Helper:seekWidgetByName(root, "Text_19"):setString("" .._ED.warcraft_info.current_win_count)
    ccui.Helper:seekWidgetByName(root, "Text_18"):setString("" .._ED.warcraft_info.current_integral)
    local totallimit1 = dms.int(dms["warcraft_mould"], _ED.warcraft_info.current_title_id, warcraft_mould.rank_score_limit)
    local totallimit2 = dms.int(dms["warcraft_mould"], _ED.warcraft_info.current_title_id, warcraft_mould.rank_win_score_limit)
    
    local percent = zstring.tonumber(_ED.warcraft_info.current_match_integral)/ totallimit1 * 100
    if percent >= 100 then 
        percent = 100 
    end
    if percent<=0 then 
        percent = 0
    end
    ccui.Helper:seekWidgetByName(root, "LoadingBar_1"):setPercent(percent)
    if totallimit1 == -1 then 
        totallimit1 = "∞"
    end
    ccui.Helper:seekWidgetByName(root, "Text_41_jifen"):setString("".._ED.warcraft_info.current_match_integral.. "/" ..totallimit1)

    local percent2 = zstring.tonumber(_ED.warcraft_info.current_win_count)/ totallimit2 * 100
    if percent2 >= 100 then 
        percent2 = 100 
    end
    if percent2<=0 then 
        percent2 = 0
    end
    ccui.Helper:seekWidgetByName(root, "LoadingBar_2"):setPercent(percent2)
    if totallimit2 == -1 then 
        totallimit2 = "∞"
    end
    ccui.Helper:seekWidgetByName(root, "Text_41_shengdian"):setString("".._ED.warcraft_info.current_win_count.. "/" ..totallimit2)
    
end

function AdventureArenaWarcraftList:onEnterTransitionFinish()
    local csbAdventureArena = csb.createNode("campaign/Arena/jingji_pws_1.csb")
    local root = csbAdventureArena:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureArena)
    self.result_tip_type = getResultTipType()

    local window_bg = ccui.Helper:seekWidgetByName(root, "Panel_bg")
    window_bg:removeAllChildren(true)
    window_bg:removeBackGroundImage()
    if zstring.tonumber(_ED.warcraft_info.current_state) == 1 or zstring.tonumber(_ED.warcraft_info.current_state) == 2 then 
        window_bg:setBackGroundImage("images/ui/bg/bg_ditu_5.png")
    else
        window_bg:setBackGroundImage("images/ui/bg/bg_ditu_4.png")
        
    end
    window_bg:setVisible(true)
    local armaturePanel = ccui.Helper:seekWidgetByName(root, "Panel_zhezhao_bg")
    self.ArmatureNode_tip = armaturePanel:getChildByName("ArmatureNode_kaiqi") -- 动画
    draw.initArmature(self.ArmatureNode_tip, nil, -1, 0, 1)
    csb.animationChangeToAction(self.ArmatureNode_tip, 0, 0, false)
    self.ArmatureNode_tip:setVisible(false)

    self.ArmatureNode_success = armaturePanel:getChildByName("ArmatureNode_chengg") -- 动画
    draw.initArmature(self.ArmatureNode_success, nil, -1, 0, 1)
    csb.animationChangeToAction(self.ArmatureNode_success, 0, 0, false)
    self.ArmatureNode_success:setVisible(false)
    
    self.ArmatureNode_fail = armaturePanel:getChildByName("ArmatureNode_shibai") -- 动画
    draw.initArmature(self.ArmatureNode_fail, nil, -1, 0, 1)
    csb.animationChangeToAction(self.ArmatureNode_fail, 0, 0, false)
    self.ArmatureNode_fail:setVisible(false)

    self:checkFightCounts()
    
    local reward = getSceneReward(62)
    if reward ~= nil then 
        app.load("client.adventure.campaign.arena.warcraft.AdventureArenaWarcraftFightResult")
        fwin:open(AdventureArenaWarcraftFightResult:new():init(reward), fwin._windows)
    else
        if self.result_tip_type == 3 or self.result_tip_type == 0 then 
            checkResultTip()
        else
            self:onPlayAction(self.result_tip_type)
        end
    end
    self:onUpdateDraw()
    
    --段位奖励        
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_level_reward"),       nil, 
    {
        terminal_name = "adventure_arena_warcraft_list_reward", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
    -- -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        terminal_name = "adventure_arena_warcraft_list_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
    --增加次数
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"),       nil, 
    {
        terminal_name = "adventure_arena_warcraft_list_add_fight_counts", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)


    --规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12"),       nil, 
    {
        terminal_name = "adventure_arena_warcraft_list_rule", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    --排名
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_13"),       nil, 
    {
        terminal_name = "adventure_arena_warcraft_list_rank", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)    
    
    --刷新
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_refresh"),       nil, 
    {
        terminal_name = "adventure_arena_warcraft_list_refresh", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
    if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh 
        or __lua_project_id == __lua_project_warship_girl_b 
        then 
        -- app.load("client.player.UserTopInfoA") 
        -- local userinfo = UserTopInfoA:new()
        -- local info = fwin:open(userinfo,fwin._view)
        app.load("client.player.UserInformationShop")                   --顶部用户信息
        self.userinfo = UserInformationShop:new()
        fwin:open(self.userinfo,fwin._view)
    end
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then 
        fwin:close(fwin:find("UserTopInfoAClass"))
        app.load("client.player.UserTopInfoA")
        fwin:open(UserTopInfoA:new(), fwin._view)
    end

end

function AdventureArenaWarcraftList:close( ... )
    fwin:close(fwin:find("UserInformationShopClass"))
    fwin:close(fwin:find("UserTopInfoAClass"))    
end

function AdventureArenaWarcraftList:onExit()
    state_machine.remove("adventure_arena_warcraft_list_refresh")
    state_machine.remove("adventure_arena_warcraft_list_reward")
    state_machine.remove("adventure_arena_warcraft_list_rank")
    state_machine.remove("adventure_arena_warcraft_list_rule")
    state_machine.remove("adventure_arena_warcraft_list_close") 
    state_machine.remove("adventure_arena_warcraft_list_add_fight_counts") 
end