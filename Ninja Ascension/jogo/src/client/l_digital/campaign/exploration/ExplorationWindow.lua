-- ----------------------------------------------------------------------------------------------------
-- 说明：空岛探索主界面
-------------------------------------------------------------------------------------------------------
ExplorationWindow = class("ExplorationWindowClass", Window)

local exploration_window_open_terminal = {
    _name = "exploration_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if params and zstring.tonumber(params) == -1 then
            if fwin:find("ExplorationWindowClass") == nil then
                fwin:open(ExplorationWindow:new():init(params), fwin._view)
            end
        else
            local function callback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    if fwin:find("ExplorationWindowClass") == nil then
                        fwin:open(ExplorationWindow:new():init(params), fwin._view)
                    end
                end
            end
            local data = {}
            data.mapId = 1
            local req = json.encode(data)
            protocol_command.pokemon_explore_enter.param_list = req
            NetworkManager:register(protocol_command.pokemon_explore_enter.code, nil, nil, nil, nil, callback, false, nil)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(exploration_window_open_terminal)
state_machine.init()

function ExplorationWindow:ctor()
    self.super:ctor()
    self.roots = {}

    -- app.load("client.l_digital.campaign.fileIsland.FileIslandBoss")
    -- app.load("client.l_digital.campaign.fileIsland.FileIslandFriends")
    -- app.load("client.l_digital.campaign.fileIsland.FileIslandHolyThing")
    -- app.load("client.l_digital.campaign.fileIsland.FileIslandRule")
    -- app.load("client.l_digital.campaign.fileIsland.FileIslandShop")
    -- app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinish")
    -- app.load("client.l_digital.campaign.fileIsland.FileIslandOneFinish")
    app.load("client.l_digital.campaign.fileIsland.FileIslandShopBuyTop")
    app.load("client.l_digital.campaign.fileIsland.FileIslandSearchPointBuy")
    app.load("client.l_digital.campaign.fileIsland.FileIslandFormation")

    app.load("client.l_digital.campaign.exploration.ExplorationMap")
    app.load("client.l_digital.campaign.exploration.ExplorationScore")
    app.load("client.l_digital.campaign.exploration.ExplorationShopWindow")
    app.load("client.l_digital.campaign.exploration.ExplorationBoss")
    app.load("client.l_digital.campaign.exploration.ExplorationAllFinish")

    app.load("client.l_digital.campaign.exploraRanking.ExploraRankWindow")
    app.load("client.l_digital.campaign.exploration.ExplorationRolePreview")
    app.load("client.l_digital.campaign.exploration.ExplorationRuleWindow")

    local function init_exploration_terminal()
        -- 关闭
		local exploration_window_close_terminal = {
            _name = "exploration_window_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.unlock("explore_window_open_fun_window")
                
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
                    state_machine.excute("menu_back_home_page", 0, "")
                    state_machine.excute("home_change_open_atrribute", 0, false)
                end

                fwin:close(fwin:find("ExplorationWindowClass"))
                fwin:close(fwin:find("ExplorationMapClass"))
                fwin:close(fwin:find("FileIslandShopBuyTopClass"))

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local exploration_window_onUpdateDraw_terminal = {
            _name = "exploration_window_onUpdateDraw",
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

        -- 刷新boss红点
        local exploration_window_updateDraw_boss_redPoint_terminal = {
            _name = "exploration_window_updateDraw_boss_redPoint",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:reqBossData()

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新好友任务红点
        local exploration_window_updateDraw_friend_redPoint_terminal = {
            _name = "exploration_window_updateDraw_friend_redPoint",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:reqFriendData()

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 一键探索
        local exploration_ten_terminal = {
            _name = "exploration_ten",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local needPoint = dms.int(dms["play_config"], 124, play_config.param)
                -- 有探索点进行请求
                if _ED.pokemonExplore.searchPoint < needPoint then
                    TipDlg.drawTextDailog(tipStringInfo_exploration_tips[12])
                    return
                end
                state_machine.excute("exploration_all_finish_window_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 刷新
        local exploration_button_refresh_terminal = {
            _name = "exploration_button_refresh",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.player_move then
                    return
                end
                local needPoint = dms.int(dms["play_config"], 124, play_config.param)
                local mapInfo = zstring.splits(dms.string(dms["play_config"], 150, play_config.param), "|", ",") 
                -- 有探索点进行请求
                if _ED.pokemonExplore.searchPoint < needPoint then
                    TipDlg.drawTextDailog(tipStringInfo_exploration_tips[12])
                    return
                end
                local mapId = cc.UserDefault:getInstance():getStringForKey(getKey("exploration_map_id"), "1")
                local cost = 10
                for i, map in ipairs(mapInfo) do
                    if tonumber(mapId) == tonumber(map[1]) then
                        cost = tonumber(map[2])
                    end
                end

                local curCost = needPoint*cost
                curCost = curCost <= _ED.pokemonExplore.searchPoint and curCost or _ED.pokemonExplore.searchPoint
                
                function showConfirmTip(instance, n)
                    if n == 0 then
                       state_machine.excute("exploration_icon_refresh", 0, curCost) 
                    end
                end
                app.load("client.utils.ConfirmTip")
                local tip = ConfirmTip:new()
                tip:init(instance, showConfirmTip, string.format(tipStringInfo_exploration_tips[13], curCost))
                fwin:open(tip, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 请求好友任务数据
        local exploration_window_friends_open_request_data_terminal = {
            _name = "exploration_window_friends_open_request_data",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseFileIslandFriendsInitCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if #_ED.pokemonExplore.taskInfo.mySingleTaskInfo ~= 0 
                            or #_ED.pokemonExplore.taskInfo.myMultiTaskInfo ~= 0 
                            or #_ED.pokemonExplore.taskInfo.myJoinTaskInfo ~= 0 
                            or #_ED.pokemonExplore.taskInfo.friendMultiTaskInfo ~= 0
                            then
                            state_machine.excute("exploration_window_friends_open", 0, "")
                        else
                            TipDlg.drawTextDailog(tipStringInfo_file_island_tips[10])
                        end
                    end
                end
                protocol_command.fileIslandTaskInfo.param_list = ""
                NetworkManager:register(protocol_command.fileIslandTaskInfo.code, nil, nil, nil, nil, responseFileIslandFriendsInitCallback, false, nil)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 请求boss数据
        local exploration_window_team_boss_open_request_data_terminal = {
            _name = "exploration_window_team_boss_open_request_data",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                
                local function responseFileIslandBossInitCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if #_ED.pokemonExplore.bossInfo.bossInfo ~= 0 then
                            state_machine.excute("exploration_window_team_boss_open", 0, "")
                        else
                            TipDlg.drawTextDailog(tipStringInfo_file_island_tips[9])
                        end
                    end
                end
                protocol_command.pokemon_explore_boss_info.param_list = ""
                NetworkManager:register(protocol_command.pokemon_explore_boss_info.code, nil, nil, nil, nil, responseFileIslandBossInitCallback, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 切换地图
        local exploration_map_tab_terminal = {
            _name = "exploration_map_tab",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local mapId = params._datas.index
                local needLevel = params._datas.needLevel
                if tonumber(_ED.user_info.user_grade) < needLevel then
                    TipDlg.drawTextDailog(string.format(tipStringInfo_exploration_tips[3], needLevel))
                    return
                end

                if _ED.player_move then
                    TipDlg.drawTextDailog(tipStringInfo_exploration_tips[14])
                    return
                end

                instance:mapTab(mapId)
                return true
            end,
            _terminal = nil,
            _terminals = nil
            }


        -- 随机事件数量统计
        local exploration_map_event_nums_terminal = {
            _name = "exploration_map_event_nums",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:drawEventNums()
                return true
            end,
            _terminal = nil,
            _terminals = nil
            }

        -- 积分红点
        local exploration_score_redot_terminal = {
        _name = "exploration_score_redot",
        _init = function (terminal) 
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            instance:scoreRedot()
            return true
        end,
        _terminal = nil,
        _terminals = nil
        }

        -- 打开图鉴  Button_exploration_book_window_open
        local Button_exploration_book_window_open_terminal = {
        _name = "Button_exploration_book_window_open",
        _init = function (terminal) 
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            app.load("client.l_digital.campaign.explorebook.ExploreBookWindow")
            state_machine.excute("explore_book_window_open",0,"")
            return true
        end,
        _terminal = nil,
        _terminals = nil
        }

        
           -- 进入探索排行榜
        local bt_explora_ranking_window_open_terminal = {
            _name = "bt_explora_ranking_window_open",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("explora_ranking_window_open",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新boss数量
        local exploration_boss_event_nums_terminal = {
            _name = "exploration_boss_event_nums",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local Text_map_boss_n = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_map_boss_n")
                if _ED.pokemonExplore.bossInfo and _ED.pokemonExplore.bossInfo.bossInfo then
                    -- 是否已挑战，1为已挑战
                    local index = 0
                    for k, info in pairs(_ED.pokemonExplore.bossInfo.bossInfo) do
                        if info.curProgress <= 0 and info.uid == tonumber(_ED.user_info.user_id) then
                            index = index + 1
                        end
                    end
                    Text_map_boss_n:setString(index)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(exploration_window_close_terminal)
        state_machine.add(exploration_window_onUpdateDraw_terminal)
        state_machine.add(exploration_window_updateDraw_boss_redPoint_terminal)
        state_machine.add(exploration_window_updateDraw_friend_redPoint_terminal)
        state_machine.add(exploration_ten_terminal)
        state_machine.add(exploration_window_friends_open_request_data_terminal)
        state_machine.add(exploration_window_team_boss_open_request_data_terminal)
        state_machine.add(exploration_window_holy_thing_open_request_data_terminal)
        state_machine.add(exploration_map_tab_terminal)
        state_machine.add(exploration_score_redot_terminal)
        state_machine.add(Button_exploration_book_window_open_terminal)
        state_machine.add(bt_explora_ranking_window_open_terminal)
        state_machine.add(exploration_button_refresh_terminal)
        state_machine.add(exploration_map_event_nums_terminal)
        state_machine.add(exploration_boss_event_nums_terminal)

        state_machine.init()
    end
    
    init_exploration_terminal()

end

function ExplorationWindow:init(params)
    self.isRefreshing = false
    self:registerOnNoteUpdate(self, 1)
    return self
end

function ExplorationWindow:onUpdate(dt)
    local root = self.roots[1]
    if root == nil then
        return
    end

    if _ED.pokemonExplore == nil then
        return
    end

    local lastCDTime = _ED.pokemonExplore.lastCDTime
    if lastCDTime and lastCDTime > 0 then
        local current = _ED.system_time + (os.time() - _ED.native_time)
        local surplus_time = lastCDTime - current

        if self.Text_explore_time_n then
            self.Text_explore_time_n:setString(getRedAlertTimeActivityFormat(surplus_time))
        end

        -- 时间到，请求探索点
        if surplus_time <= 0 then
            self:requestSearchPoint()
        end
    end
end

function ExplorationWindow:mapTab( mapId )
    local root = self.roots[1]
    if _ED.player_move then
        return
    end
    local index = 1
    for i = 1, #dms["role_explore_map"] do
        local tabBtn = ccui.Helper:seekWidgetByName(root, "Button_exploration_tab_" .. i)
        if mapId == i then
            tabBtn:setTouchEnabled(false)
            tabBtn:setHighlighted(true)
        else
            tabBtn:setTouchEnabled(true)
            tabBtn:setHighlighted(false)
        end
        index = index + 1
    end

    for i = index, 6 do
        local tabBtn = ccui.Helper:seekWidgetByName(root, "Button_exploration_tab_" .. i)
        tabBtn:setVisible(false)
    end
    state_machine.excute("exploration_map_change", 0, mapId)
end

function ExplorationWindow:requestSearchPoint()
    if self.isRefreshing == true then
        return
    end

    local function callback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then

            if self.onUpdateDraw then
                self:onUpdateDraw()
            end

            self.isRefreshing = false
        end
    end

    self.isRefreshing = true
    protocol_command.pokemon_explore_refresh_search_point.param_list = ""
    NetworkManager:register(protocol_command.pokemon_explore_refresh_search_point.code, nil, nil, nil, nil, callback, false, nil)
end

function ExplorationWindow:isOpenSearchPanel()
    if _ED.pokemonExplore.lastSearchType and tonumber(_ED.pokemonExplore.lastSearchType) == 0 then
        for i, event in ipairs(_ED.pokemonExplore.resultInfo.resultArray) do
            if tonumber(event.isTouch) == 1 and (tonumber(event.eventId) == 5 or tonumber(event.eventId) == 6) then
                state_machine.excute("exploration_one_finish_window_open", 0, event)
            end
        end
            
    elseif _ED.pokemonExplore.lastSearchType and tonumber(_ED.pokemonExplore.lastSearchType) == 1 then
        local eventId = -1
        if _ED.pokemonEventIds and table.nums(_ED.pokemonEventIds) > 0 then
            for i=1,6 do
                if _ED.pokemonEventIds[i] and table.nums(_ED.pokemonEventIds[i]) > 0 and _ED.pokemonExplore.resultInfo.curRewardIndex 
                    and ((i == 5 and tonumber(_ED.pokemonExplore.resultInfo.curRewardIndex) <= i) or (i == 6 and tonumber(_ED.pokemonExplore.resultInfo.curRewardIndex) <= i) ) then
                    eventId = i
                    break
                end
            end
        end

        if eventId > 0 and (eventId == 5 or eventId == 6) then
            state_machine.excute("exploration_all_finish_window_open", 0, tonumber(eventId))
            local curMapId = cc.UserDefault:getInstance():getStringForKey(getKey("exploration_map_id"), "1")
            local req = json.encode({mapId = curMapId,nextEventId = eventId})
            protocol_command.pokemon_explore_dispose_next_search_eventId.param_list = req
            --前端自己存进行到哪一步
            _ED.pokemonExplore.resultInfo.curRewardIndex = eventId
            NetworkManager:register(protocol_command.pokemon_explore_dispose_next_search_eventId.code, nil, nil, nil, nil, callback, false, nil)
        end
    end
end

function ExplorationWindow:drawEventNums()
    local root = self.roots[1]
    local Text_random_event_n = ccui.Helper:seekWidgetByName(root, "Text_random_event_n")
    local Text_pokemon_n = ccui.Helper:seekWidgetByName(root, "Text_pokemon_n")
    local Panel_exploration = ccui.Helper:seekWidgetByName(root, "Panel_exploration")
    Text_random_event_n:setString(0)
    Text_pokemon_n:setString(0)
    local mapId = cc.UserDefault:getInstance():getStringForKey(getKey("exploration_map_id"), "1")
    if tonumber(_ED.pokemonExplore.curSearchMap) ~= tonumber(mapId) then
        return
    end

    if _ED.pokemonExplore.lastSearchType and tonumber(_ED.pokemonExplore.lastSearchType) == 0 then
        local allNum = 0
        for i, event in pairs(_ED.pokemonExplore.resultInfo.resultArray) do
            if tonumber(event.isTouch) ~= 1 and tonumber(event.eventId) ~= 3 and tonumber(event.eventId) ~= 5 then
                allNum = allNum + 1
            end
        end

        Text_random_event_n:setString(allNum)
        Text_pokemon_n:setString(table.nums(_ED.pokemonEventIds[5]))
        
        -- Panel_exploration:setVisible(true)
    else
       -- Panel_exploration:setVisible(false) 
    end
end

function ExplorationWindow:onUpdateDraw()
    local root = self.roots[1]

    if _ED.pokemonExplore == nil then
        return
    end
    local Text_map_boss_n = ccui.Helper:seekWidgetByName(root, "Text_map_boss_n")
    Text_map_boss_n:setString(0)
    -- if _ED.pokemonExplore.bossInfo and _ED.pokemonExplore.bossInfo.bossInfo then
    --     Text_map_boss_n:setString(table.nums(_ED.pokemonExplore.bossInfo.bossInfo))
    -- end
    local maxPoint = dms.int(dms["play_config"], 116, play_config.param)
    local searchPoint = tonumber(_ED.pokemonExplore.searchPoint)
    self.Text_explore_spot_n:setString(searchPoint .. "/" .. maxPoint)

    -- 显示恢复倒计时
    if searchPoint < 20 then
        self.Text_explore_time_t:setVisible(true)
        self.Text_explore_time_n:setVisible(true)

    -- 隐藏恢复倒计时
    else
        self.Text_explore_time_t:setVisible(false)
        self.Text_explore_time_n:setVisible(false)
    end

	state_machine.excute("notification_center_update", 0, "push_notification_fileIsland_update_search_1_btn_push")
    state_machine.excute("notification_center_update", 0, "push_notification_fileIsland_update_search_all_btn_push")
end

function ExplorationWindow:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/exploration/exploration_map_ui.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    local curMapId = 1
    local mapId = cc.UserDefault:getInstance():getStringForKey(getKey("exploration_map_id"), "")
    if mapId and mapId ~= "" then
        curMapId = tonumber(mapId)
    end
    self:mapTab(curMapId)

    -- 规则
 --    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_explore_rule"), nil, 
 --    {
 --        terminal_name = "exploration_window_rule_window_open", 
 --        isPressedActionEnabled = true
 --    },
 --    nil, 0)

    -- 商城
    local Button_exploration_shop = ccui.Helper:seekWidgetByName(root, "Button_exploration_shop")
    fwin:addTouchEventListener(Button_exploration_shop, nil, 
    {
        terminal_name = "exploration_shop_window_open", 
        isPressedActionEnabled = true
    },
    nil, 0)

    -- boss
    self.bossIcon = ccui.Helper:seekWidgetByName(root, "Button_exploration_boss")
    fwin:addTouchEventListener(self.bossIcon, nil, 
    {
        terminal_name = "exploration_window_team_boss_open_request_data", 
        isPressedActionEnabled = true
    },
    nil, 0)
    self.bossIcon:setVisible(false)

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_exploration_boss_icon_push",
        _widget = self.bossIcon,
        _invoke = nil,
        _interval = 0.5,})

    -- 一键探索
    self.Button_explore_quick = ccui.Helper:seekWidgetByName(root, "Button_explore_quick")
    fwin:addTouchEventListener(self.Button_explore_quick, nil, 
    {
        terminal_name = "exploration_ten", 
        isPressedActionEnabled = true,
        node = self,
    },
    nil, 0)

    -- 刷新
    self.Button_explore_refresh = ccui.Helper:seekWidgetByName(root, "Button_explore_refresh")
    self.Button_explore_refresh:setTouchEnabled(true)
    fwin:addTouchEventListener(self.Button_explore_refresh, nil, 
    {
        terminal_name = "exploration_button_refresh", 
        isPressedActionEnabled = true,
        node = self,
    },
    nil, 0)

    local vipLevel = zstring.tonumber(_ED.vip_grade)
    local showElement = dms.element(dms["base_consume"], 69)
    local isShow = dms.atoi(showElement, base_consume.vip_0_value + vipLevel)

    if funOpenDrawTip(188, false) and isShow ~= 1 then
        self.Button_explore_refresh:setPositionX(481)
        self.Button_explore_quick:setVisible(false)
    else
        self.Button_explore_refresh:setPositionX(390)
        self.Button_explore_quick:setVisible(true)
    end

    --探索排行榜
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_exploration_rank"), nil, 
    {
        terminal_name = "bt_explora_ranking_window_open", 
        isPressedActionEnabled = true
    },
    nil, 0) 

 -- -- 购买探索点
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_explore_buy"), nil, 
    {
        terminal_name = "FileIslandSearchPointBuy_open", 
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 打开积分
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_exploration_integral"), nil, 
    {
        terminal_name = "exploration_score_open_box_window_open", 
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 打开图鉴
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_exploration_book"), nil, 
    {
        terminal_name = "Button_exploration_book_window_open", 
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 打开宝可梦预览
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_exploration_pokemon"), nil, 
    {
        terminal_name = "exploration_pokemon_preview_window_open", 
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_exploration_rule"), nil, 
    {
        terminal_name = "exploration_rule_window_open", 
        isPressedActionEnabled = true
    },
    nil, 0)

    for i = 1, #dms["role_explore_map"] do
        local tabBtn = ccui.Helper:seekWidgetByName(root, "Button_exploration_tab_" .. i)
        local Text_exploration_map = ccui.Helper:seekWidgetByName(root, "Text_exploration_map_" .. i)
        local Image_lock = ccui.Helper:seekWidgetByName(root, "Image_lock_" .. i)
        local nameIndex = dms.int(dms["role_explore_map"], i, 2)
        local word_info = dms.element(dms["word_mould"], nameIndex)
        name = word_info[3]
        local level = dms.int(dms["role_explore_map"], i, 4)
        Text_exploration_map:setString(name)
        -- if tonumber(_ED.user_info.user_grade) >= level then
            
        -- end
        Image_lock:setVisible(tonumber(_ED.user_info.user_grade) < level)
        fwin:addTouchEventListener(tabBtn, nil, 
        {
            terminal_name = "exploration_map_tab",
            index = i,
            needLevel = level
        },
        nil, 0)
    end

	-- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_phb_back"), nil, 
    {
        terminal_name = "exploration_window_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

 --    -- 探索点
    self.Text_explore_spot_n = ccui.Helper:seekWidgetByName(root, "Text_explore_spot_n")
    -- 恢复时间
    self.Text_explore_time_t = ccui.Helper:seekWidgetByName(root, "Text_explore_time_t")
    -- 恢复时间数
    self.Text_explore_time_n = ccui.Helper:seekWidgetByName(root, "Text_explore_time_n")

    self:onUpdateDraw()

 --    --一键探索未完成任务
    self:isOpenSearchPanel()

 --    -- 顶部用户信息
    app.load("client.l_digital.campaign.fileIsland.FileIslandShopBuyTop")                   
    local userinfo = FileIslandShopBuyTop:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)

    self:scoreRedot()
 --    self:reqFriendData()
    self:reqBossData()

end

function ExplorationWindow:onExit()
    state_machine.remove("exploration_window_close")
    state_machine.remove("exploration_window_onUpdateDraw")
	state_machine.remove("exploration_window_updateDraw_boss_redPoint")
    state_machine.remove("exploration_window_updateDraw_friend_redPoint")
    state_machine.remove("exploration_ten")
    state_machine.remove("exploration_window_friends_open_request_data")
    state_machine.remove("exploration_window_team_boss_open_request_data")
    state_machine.remove("exploration_window_holy_thing_open_request_data")
end

function ExplorationWindow:destroy(window)
    if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
    audioUtilUncacheAll()
    cacher.cleanSystemCacher()
end

-- 请求boss信息，刷新boss icon红点
function ExplorationWindow:reqFriendData()
    local function callback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("notification_center_update", 0, "push_notification_fileIsland_friend_icon_push")
        end
    end
    protocol_command.fileIslandTaskInfo.param_list = ""
    NetworkManager:register(protocol_command.fileIslandTaskInfo.code, nil, nil, nil, nil, callback, false, nil)
end

-- 请求好友信息，刷新好友 icon红点
function ExplorationWindow:reqBossData()
    local function callback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("notification_center_update", 0, "push_notification_exploration_boss_icon_push")
        end
    end
    protocol_command.pokemon_explore_boss_info.param_list = ""
    NetworkManager:register(protocol_command.pokemon_explore_boss_info.code, nil, nil, nil, nil, callback, false, nil)
end

function ExplorationWindow:scoreRedot()
    local function isHaveRedot()
        for i = 1, #dms["role_explore_daily_score"] do
            local needScore = dms.int(dms["role_explore_daily_score"], i, 2)
            local scoreCompelet = _ED.pokemonExplore.scoreInfo.todayScoreR
            local curScore = _ED.pokemonExplore.scoreInfo.todayScore
            if (table.containValue(scoreCompelet, "" .. i) or table.containValue(scoreCompelet, i)) then -- 已经领取
            else
                if tonumber(curScore) >= needScore then --已完成
                    return true
                end
            end
        end

        for i = 1, #dms["role_explore_gather_score"] do
            local needScore = dms.int(dms["role_explore_gather_score"], i, 2)
            local scoreCompelet = _ED.pokemonExplore.scoreInfo.totalScoreR
            local curScore = _ED.pokemonExplore.scoreInfo.totalScore
            if (table.containValue(scoreCompelet, "" .. i) or table.containValue(scoreCompelet, i)) then -- 已经领取
            else
                if tonumber(curScore) >= needScore then
                    return true
                end
            end
        end

        return false
    end

    local Image_red = ccui.Helper:seekWidgetByName(self.roots[1], "Image_red")
    Image_red:setVisible(isHaveRedot())
end
