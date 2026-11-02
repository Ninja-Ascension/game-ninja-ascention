-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场主界面
-------------------------------------------------------------------------------------------------------
AdventureArenaManager = class("AdventureArenaManagerClass", Window)
    
function AdventureArenaManager:ctor()
    self.super:ctor()
    self.roots = {}
	
	self.interval = 0
    self.needUpdateRefreshCd = false
    self.needUpdateRefreshWarcraft = false
    self.intervalWarcraft = 0 
    self.diffTimes = 0
	
    -- Initialize adventure arena manager state machine.
    local function init_adventure_arena_manager_terminal()
        -- 排名赛
        local adventure_arena_manager_ranked_game_terminal = {
            _name = "adventure_arena_manager_ranked_game",
            _init = function (terminal)
                app.load("client.adventure.campaign.arena.AdventureArenaRankedGame")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseArenaInitCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        fwin:open(AdventureArenaRankedGame:new():init(), fwin._view)
                    end
                end
                protocol_command.arena_init.param_list = "0"
                NetworkManager:register(protocol_command.arena_init.code, nil, nil, nil, nil, responseArenaInitCallback, true, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 竞技场
        local adventure_arena_manager_arena_terminal = {
            _name = "adventure_arena_manager_arena",
            _init = function (terminal)
                app.load("client.adventure.campaign.arena.AdventureArena")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseArenaInitCallback(response)
                    fwin:open(AdventureArena:new():init(false), fwin._view)
                end
                protocol_command.arena_init2.param_list = "1"
                NetworkManager:register(protocol_command.arena_init2.code, nil, nil, nil, nil, responseArenaInitCallback, true, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --排位赛
        local adventure_arena_manager_warcraft_terminal = {
            _name = "adventure_arena_manager_warcraft",
            _init = function (terminal)
                app.load("client.adventure.campaign.arena.warcraft.AdventureArenaWarcraft")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if funOpenConditionJudge(63) == false then
                        TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 63, fun_open_condition.tip_info))
                     return
                end
                local function responseWarcraftInitCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        fwin:open(AdventureArenaWarcraft:new(), fwin._windows)
                    end
                end
                NetworkManager:register(protocol_command.warcraft_info_init.code, nil, nil, nil, nil, responseWarcraftInitCallback, true, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         -- 刷新排位名次
        local adventure_arena_manager_ranking_terminal = {
            _name = "adventure_arena_manager_ranking",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if fwin:find("AdventureArenaManagerClass") ~= nil then
                    local arena_manager = fwin:find("AdventureArenaManagerClass")
                    arena_manager:onUpdateRanking()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
         --进入九层妖塔
        local adventure_arena_manager_tower_terminal = {
            _name = "adventure_arena_manager_tower",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
               -- app.load("client.adventure.campaign.arena.tower.AdventureArenaTower")
               -- fwin:open(AdventureArenaTower:new():init(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         --返回后重新计时
        local adventure_arena_manager_back_again_time_terminal = {
            _name = "adventure_arena_manager_back_again_time",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if fwin:find("AdventureArenaManagerClass") ~= nil then
                    local arena_manager = fwin:find("AdventureArenaManagerClass")
                    arena_manager:onUpdateBackAgainTime()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_arena_manager_ranked_game_terminal)
        state_machine.add(adventure_arena_manager_arena_terminal)
        state_machine.add(adventure_arena_manager_ranking_terminal)
        state_machine.add(adventure_arena_manager_back_again_time_terminal)
        state_machine.add(adventure_arena_manager_warcraft_terminal)
        state_machine.add(adventure_arena_manager_tower_terminal)
        state_machine.init()
    end
    
    -- call func init adventure arena manager state machine.
    init_adventure_arena_manager_terminal()
end

function AdventureArenaManager:init()
	return self
end

function AdventureArenaManager:updateRefreshCd()
	if self.needUpdateRefreshCd == false then
        return
    end
    local root = self.roots[1]
    local interval = self.interval
	if interval <= 0 then
		ccui.Helper:seekWidgetByName(root, "Text_shijian"):setString("00:00:00")
	else
		self.interval = math.max(0, self.interval)

        local timeTabel = formatTime(self.interval)
        local str = timeTabel.hour
        str = str .. string.format(":%02d", timeTabel.minute)
        str = str .. string.format(":%02d", timeTabel.second)

        ccui.Helper:seekWidgetByName(root, "Text_shijian"):setString(str)
	end
end

function AdventureArenaManager:updateRefreshWarcraft()
    if self.needUpdateRefreshWarcraft == false then
        return
    end
    local root = self.roots[1]
    local interval = self.intervalWarcraft
    if interval <= 0 then
        ccui.Helper:seekWidgetByName(root, "Text_6_time"):setString("00:00:00")
    else
        self.intervalWarcraft = math.max(0, self.intervalWarcraft)

        local timeTabel = formatTime(self.intervalWarcraft)
        local str = timeTabel.hour
        str = str .. string.format(":%02d", timeTabel.minute)
        str = str .. string.format(":%02d", timeTabel.second)

        ccui.Helper:seekWidgetByName(root, "Text_6_time"):setString(str)
    end
    
end

function AdventureArenaManager:onUpdate(dt)
    local current_time = os.time()
    if self.interval > 0 then

        local interval = (_ED.native_arena_two_time + zstring.tonumber(_ED.arena_info[2].arena_challenge_lasttime)) - current_time
        if self.interval ~= interval then
            self.interval = interval
            self:updateRefreshCd()
        end
    else
        local root = self.roots[1]
        ccui.Helper:seekWidgetByName(root, "Text_shijian"):setString("00:00:00")
    end
    if self.intervalWarcraft > 0 then 
        -- local interval2 =  zstring.tonumber(_ED.active_activity[72].activity_end_day) - 
        local interval2 = (_ED.native_arena_two_time + zstring.tonumber(_ED.active_activity[72].activity_login_day2)) - current_time
        -- _ED.system_time  - self.diffTimes + _ED.native_arena_two_time - current_time
        if self.intervalWarcraft ~= interval2 then 
            self.intervalWarcraft = interval2
            self:updateRefreshWarcraft()
        end
    end
end

function AdventureArenaManager:onUpdateBackAgainTime()
    local current_time = os.time()
    self.interval = (_ED.native_arena_two_time + zstring.tonumber(_ED.arena_info[2].arena_challenge_lasttime)) - current_time

    if _ED.active_activity[72] ~= nil then 
        --可以显示排位赛倒计时
        
        local remainTimes =  zstring.tonumber(_ED.active_activity[72].activity_login_day2)
        --print("-----shengyussdfasdfhij:",remainTimes)
        local root = self.roots[1]
        if remainTimes > 24 * 60 *60 then 
            --大于一天
            self.needUpdateRefreshWarcraft = false
            ccui.Helper:seekWidgetByName(root, "Text_lts_tips"):setString(_string_piece_info[447])
            ccui.Helper:seekWidgetByName(root, "Text_6_time"):setVisible(true)
            ccui.Helper:seekWidgetByName(root, "Text_6_time"):setString("" .. math.floor(remainTimes/(24 * 60 *60)) ..tipStringInfo_time_info[4] )
            self.intervalWarcraft = 0
        else
            self.needUpdateRefreshWarcraft = true
            self.intervalWarcraft = (_ED.native_arena_two_time + remainTimes) - current_time
        end
        ccui.Helper:seekWidgetByName(root, "Text_lts_tips"):setString(_string_piece_info[447])
        ccui.Helper:seekWidgetByName(root, "Text_6_time"):setVisible(true)
    else
        --已经结束
        self.needUpdateRefreshWarcraft = false
        self.intervalWarcraft = 0
        local root = self.roots[1]
        ccui.Helper:seekWidgetByName(root, "Text_lts_tips"):setString(_string_piece_info[448])
        ccui.Helper:seekWidgetByName(root, "Text_6_time"):setVisible(false)
    end

end

-- 显示排名的函数
function AdventureArenaManager:onUpdateRanking()
    local Text_paiming = ccui.Helper:seekWidgetByName(self.roots[1], "Text_paiming")
    Text_paiming:setString(_ED.arena_info[1].arena_buy_number)
end

function AdventureArenaManager:onEnterTransitionFinish()
	local csbAdventureArenaManager = csb.createNode("campaign/Arena/jingjichang.csb")
    local root = csbAdventureArenaManager:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureArenaManager)
        
    -- 排名赛
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_paiming"), nil, 
    {
        terminal_name = "adventure_arena_manager_ranked_game", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 竞技场
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jingjichang"), nil, 
    {
        terminal_name = "adventure_arena_manager_arena", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --九层妖塔
    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pata"), nil, 
    -- {
    --     terminal_name = "adventure_arena_manager_tower", 
    --     terminal_state = 0,
    --     cell = self,
    --     isPressedActionEnabled = true
    -- }, 
    -- nil, 0)

    -- 排位赛
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lts"), nil, 
    {
        terminal_name = "adventure_arena_manager_warcraft", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    -- 显示排名
    self:onUpdateRanking()
	-- local Text_paiming = ccui.Helper:seekWidgetByName(root, "Text_paiming")
	-- Text_paiming:setString(_ED.arena_info[1].arena_buy_number)
	
	self:onUpdateBackAgainTime()
    self.needUpdateRefreshCd = true
    
    self:updateRefreshCd()
    self:updateRefreshWarcraft()
    state_machine.excute("adventure_push_info_open",0,3)
end

function AdventureArenaManager:onExit()
    state_machine.excute("adventure_push_info_close",0,0)
    state_machine.remove("adventure_arena_manager_ranked_game")
    state_machine.remove("adventure_arena_manager_arena")
    state_machine.remove("adventure_arena_manager_ranking")
end