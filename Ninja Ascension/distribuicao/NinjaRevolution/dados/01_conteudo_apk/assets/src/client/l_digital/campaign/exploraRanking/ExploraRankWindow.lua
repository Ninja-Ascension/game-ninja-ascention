-- ----------------------------------------------------------------------------------------------------
-- 说明：探索排行榜
-------------------------------------------------------------------------------------------------------
ExploraRankWindow = class("ExploraRankWindowClass", Window)

local explora_ranking_window_open_terminal = {
    _name = "explora_ranking_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("ExploraRankWindowClass") == nil then           
            fwin:open(ExploraRankWindow:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local explora_ranking_window_close_terminal = {
    _name = "explora_ranking_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("ExploraRankWindowClass") then
            fwin:close(fwin:find("ExploraRankWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(explora_ranking_window_open_terminal)
state_machine.add(explora_ranking_window_close_terminal)
state_machine.init()

function ExploraRankWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self._current_page = 1
    self._combat_power = nil
    self.lightList = {}

    self.isPlayOne = true
    self.isPlayTen = true
    self.allScore = 0
    self.ranktype = 1
    app.load("client.l_digital.campaign.exploraRanking.Explora_ranking_cell")
    app.load("client.l_digital.campaign.exploraRanking.Explora_ranking_reward")
    local function ExploraRankWindow_terminal()
        --探索排行榜
        local explorarank_first_enter_terminal = {
            _name = "explorarank_first_enter",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function callBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                         instance:onUpdateRgDraw()
                    end
                end
                _ED.recharge_ranking = {}
                if params then
                   instance.ranktype = params._datas.ranktype 
                end
                protocol_command.pokemon_explore_rank_info.param_list = instance.ranktype
                NetworkManager:register(protocol_command.pokemon_explore_rank_info.code, nil, nil, nil, instance, callBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
         

        --探索奖励
        local explora_reward_terminal = {
            _name = "explora_reward",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            state_machine.excute("explora_ranking_reward_open",0,params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        state_machine.add(explorarank_first_enter_terminal)
        state_machine.add(explora_reward_terminal)
        state_machine.init()
    end

    ExploraRankWindow_terminal()
end

function ExploraRankWindow:init()
    return self
end

function ExploraRankWindow:onMeRanking()
    
end

function ExploraRankWindow:drawTime(_time)
    local timeString = ""
    local _dayTime = math.floor((_time / 1000) / 86400)
    local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
    local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
    local _secondsTime = math.ceil((_time / 1000) % 60)
    if _dayTime > 0 then
        timeString = timeString .. _dayTime .._string_piece_info[231]
    end
    if _hourTime > 0 then
        if _hourTime < 10 then
            timeString = timeString .. "0".._hourTime ..":"
        else
            timeString = timeString .. _hourTime ..":"
        end
    end
    if _minutesTime > 0 then
        if _minutesTime < 10 then
            timeString = timeString .. "0".._minutesTime ..":"
        else
            timeString = timeString .. _minutesTime ..":"
        end
    end
    if _secondsTime > 0 then
        if _secondsTime < 10 then
            timeString = timeString .. "0".._secondsTime 
        else
            timeString = timeString .. _secondsTime 
        end
    end
    return timeString
end

function ExploraRankWindow:onUpdate(dt)
    if not  self.Text_rare_time or not _ED.pokemonExplore_rank_info or not _ED.pokemonExplore_ranking_time then
        return
    end
    local surplus_time = (_ED.pokemonExplore_ranking_time - ((os.time() + _ED.time_add_or_sub)))
    self.Text_rare_time:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time*1000))
    if self.Rank_listview ~= nil then
        local size = self.Rank_listview:getContentSize()
        local posY = self.Rank_listview:getInnerContainer():getPositionY()
        if self.Ra_list_view_posy == posY then
            return
        end
        self.Ra_list_view_posy = posY
        local items = self.Rank_listview:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height/2 < 0 or tempY > size.height + itemSize.height /2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end


function ExploraRankWindow:onUpdateRgDraw()    --更新排行榜
    self.Rank_listview:removeAllItems()

    if not _ED.pokemonExplore_rank_info then
        return
    end
    local Button_rank_now = ccui.Helper:seekWidgetByName(self.roots[1], "Button_rank_now") 
    local Button_rank_last = ccui.Helper:seekWidgetByName(self.roots[1], "Button_rank_last")
    if self.ranktype == 1 then
        Button_rank_now:setHighlighted(true)
        Button_rank_last:setHighlighted(false)
    else
        Button_rank_now:setHighlighted(false)
        Button_rank_last:setHighlighted(true) 
    end

    for i, v in ipairs(_ED.pokemonExplore_rank_info) do 
         local cell = state_machine.excute("explora_ranking_cell_create",0,{v,i,0})
         self.Rank_listview :addChild(cell)
    end
    self.Rank_listview :requestRefreshView()
    local Text_event_rank_me = ccui.Helper:seekWidgetByName(self.roots[1], "Text_event_rank_me")
    if tonumber(_ED.pokemonExplore_myranking) ~=-1 then
        Text_event_rank_me:setString(_ED.pokemonExplore_myranking)
    else
        Text_event_rank_me:setString(tipStringInfo_pokemon_recharge_rank_tips[5])
    end
end


function ExploraRankWindow:onEnterTransitionFinish()
  
    local csbNode = csb.createNode("campaign/exploration/exploration_event_ranking.csb")
    local root = csbNode:getChildByName("root")                         
    self.Rank_listview = ccui.Helper:seekWidgetByName(root, "ListView_jjc_ph")
    self.Text_rare_time = ccui.Helper:seekWidgetByName(root, "Text_event_rank_time")
    table.insert(self.roots, root)
    self:addChild(csbNode)
    state_machine.excute("explorarank_first_enter", 0,nil) 
     -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_event_rank_close"), nil, 
    {
        terminal_name = "explora_ranking_window_close", 
        isPressedActionEnabled = true
    },
    nil, 0)
   
     --排行奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_event_rank_reward"), nil, 
    {
        terminal_name = "explora_reward", 
        terminal_state = 0, 
    }, nil, 0)
    
    -- 本期排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rank_now"), nil, 
    {
        terminal_name = "explorarank_first_enter", 
        isPressedActionEnabled = true,
        ranktype = 1,
    },
    nil, 0)

     -- 上期排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rank_last"), nil, 
    {
        terminal_name = "explorarank_first_enter", 
        isPressedActionEnabled = true,
        ranktype = 2,
    },
    nil, 0)
    self:registerOnNoteUpdate(self, 1)
    app.load("client.l_digital.campaign.fileIsland.FileIslandShopBuyTop")                   
    local userinfo = FileIslandShopBuyTop:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)
end

function ExploraRankWindow:onExit()
   self.Rank_listview:removeAllItems()
   _ED.pokemonExplore_rank_info = nil
end 
