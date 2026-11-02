-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场排名赛
-------------------------------------------------------------------------------------------------------
AdventureArenaRankedGame = class("AdventureArenaRankedGameClass", Window)
AdventureArenaRankedGame.__battle_ranking = -1
function AdventureArenaRankedGame:ctor()
    self.super:ctor()
    self.roots = {}
	
    app.load("client.adventure.cells.arena.AdventureArenaManagerHeroList")
    app.load("client.adventure.system.share.AdventureShareDialog")
	self.isTouchLock = false
	self.interval = 0
    self.needUpdateRefreshCd = false

    -- Initialize adventure arena state ranked game machine.
    local function init_adventure_arena_ranked_game_terminal()
		local adventure_arena_ranked_game_open_shuoming_terminal = {
            _name = "adventure_arena_ranked_game_open_shuoming",
            _init = function (terminal)
                 app.load("client.adventure.campaign.arena.AdventureArenaQualifyingRule")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:open(AdventureArenaQualifyingRule:new(),fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_arena_ranked_game_open_world_ranking_terminal = {
            _name = "adventure_arena_ranked_game_open_world_ranking",
            _init = function (terminal)
                 app.load("client.adventure.campaign.arena.AdventureArenaWorldRanking")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:open(AdventureArenaWorldRanking:new(),fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_arena_ranked_game_open_arena_shop_terminal = {
            _name = "adventure_arena_ranked_game_open_arena_shop",
            _init = function (terminal)
                 app.load("client.adventure.campaign.arena.AdventureArenaRewardShop")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseArenaHonorShopInitCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						fwin:open(AdventureArenaRewardShop:new(),fwin._view)
					end
				end
				protocol_command.arena_shop_init.param_list = "1"
				NetworkManager:register(protocol_command.arena_shop_init.code, nil, nil, nil, nil, responseArenaHonorShopInitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_arena_ranked_game_open_shuoming_terminal)
		state_machine.add(adventure_arena_ranked_game_open_world_ranking_terminal)
		state_machine.add(adventure_arena_ranked_game_open_arena_shop_terminal)
        state_machine.init()
    end
    
    -- call func init adventure arena ranked game state machine.
    init_adventure_arena_ranked_game_terminal()
end

function AdventureArenaRankedGame:updateRefreshCd()
	if self.needUpdateRefreshCd == false then
        return
    end
    local root = self.roots[1]
    local interval = self.interval
	if interval <= 0 then
		ccui.Helper:seekWidgetByName(root, "Text_cd"):setString("00:00:00")
	else
		self.interval = math.max(0, self.interval)

        local timeTabel = formatTime(self.interval)
        local str = timeTabel.hour
        str = str .. string.format(":%02d", timeTabel.minute)
        str = str .. string.format(":%02d", timeTabel.second)

        ccui.Helper:seekWidgetByName(root, "Text_cd"):setString(str)
	end
end

function AdventureArenaRankedGame:onUpdate(dt)
    if self.interval > 0 then
        local interval = (_ED.native_arena_two_time + zstring.tonumber(_ED.arena_dekaron_cooling_time)) - os.time()
        if self.interval ~= interval then
            self.interval = interval
            self:updateRefreshCd()
        end
    end
end

function AdventureArenaRankedGame:onUpdateDraw()
	local root = self.roots[1]
	self.isTouchLock = true
	local ListView_paiming = ccui.Helper:seekWidgetByName(root, "ListView_paiming")
	local Text_paiming = ccui.Helper:seekWidgetByName(root, "Text_paiming")
	Text_paiming:setString(_ED.arena_user_rank)
	local Text_jiangli = ccui.Helper:seekWidgetByName(root, "Text_jiangli")
	Text_jiangli:setString(_ED.arena_reward_reputation)
	local Text_xiaohao = ccui.Helper:seekWidgetByName(root, "Text_xiaohao")
	Text_xiaohao:setString(_ED.arena_user_remain)
	ListView_paiming:removeAllItems()
	for i=1, zstring.tonumber(_ED.arena_challenge_number) do
		local cell = AdventureArenaManagerHeroList:createCell()
		cell:init(_ED.arena_challenge[i],i)
		ListView_paiming:addChild(cell)
		ListView_paiming:requestRefreshView()
	end
	
	self.interval = (_ED.native_time + zstring.tonumber(_ED.arena_dekaron_cooling_time)) - os.time()
	if __lua_project_id == __lua_project_adventure then
		self.interval = (_ED.native_arena_two_time + zstring.tonumber(_ED.arena_dekaron_cooling_time)) - os.time()
	end
    self.needUpdateRefreshCd = true
    self:updateRefreshCd()
    -- 刷新显示排名
    if fwin:find("AdventureArenaManagerClass") ~= nil then
        state_machine.excute("adventure_arena_manager_ranking", 0, 0)
    end
end

function AdventureArenaRankedGame:init(isGetServer)
    if isGetServer ~= nil and isGetServer == true then 
        self.isGetServer = true
    else
        self.isGetServer = false
    end

	return self
end
function AdventureArenaRankedGame:checkArenaReward()
    local shareIndex = -1
    --print("----新排名:",AdventureArenaRankedGame.__battle_ranking)
    if AdventureArenaRankedGame.__battle_ranking >= 1 and AdventureArenaRankedGame.__battle_ranking <= 3 then 
        shareIndex = 1 
    elseif AdventureArenaRankedGame.__battle_ranking >= 4 and AdventureArenaRankedGame.__battle_ranking <= 10 then 
        shareIndex = 2 
    elseif AdventureArenaRankedGame.__battle_ranking >= 11 and AdventureArenaRankedGame.__battle_ranking <= 50 then 
        shareIndex = 3 
    elseif AdventureArenaRankedGame.__battle_ranking >= 51 and AdventureArenaRankedGame.__battle_ranking <= 100 then 
        shareIndex = 4 
    else
        shareIndex = -1
    end
    if shareIndex ~= -1 then 
        local shareArea = cc.UserDefault:getInstance():getStringForKey(getKey("share_area_" .. shareIndex),"0")
        if shareArea == "0" then 
            local shareInfo = string.format(_share_text[3],"" .. AdventureArenaRankedGame.__battle_ranking )
            state_machine.excute("adventure_open_share_dialog",0,shareInfo)
            cc.UserDefault:getInstance():setStringForKey(getKey("share_area_" .. shareIndex),"1")
        end
    end
end

function AdventureArenaRankedGame:onEnterTransitionFinish()
	local csbAdventureArenaRankedGame = csb.createNode("campaign/Arena/jingjichang_paimingsai.csb")
    local root = csbAdventureArenaRankedGame:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureArenaRankedGame)
	if self.isGetServer == false then 
		self:onUpdateDraw()
    else
        local function responseArenaInitCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil then 
                    response.node:onUpdateDraw()
                end
             end
        end
        protocol_command.arena_init.param_list = "0"
        NetworkManager:register(protocol_command.arena_init.code, nil, nil, nil, self, responseArenaInitCallback, false, nil)
    end
    self:checkArenaReward()
	-- else
	-- 	local function responseArenaInitCallback(response)
	-- 		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	-- 			-- if self.isTouchLock == false then

	-- 				self:onUpdateDraw()
	-- 			-- end
	-- 		end
	-- 	end
	-- 	protocol_command.arena_init.param_list = "0"
	-- 	NetworkManager:register(protocol_command.arena_init.code, nil, nil, nil, nil, responseArenaInitCallback, false, nil)
	-- end

	--规则说明
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guize"), nil, 
    {
        terminal_name = "adventure_arena_ranked_game_open_shuoming", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	--世界排名
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sjpm"), nil, 
    {
        terminal_name = "adventure_arena_ranked_game_open_world_ranking", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	--兑换奖励
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_duihuan"), nil, 
    {
        terminal_name = "adventure_arena_ranked_game_open_arena_shop", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureArenaRankedGameClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
	
	
end

function AdventureArenaRankedGame:onExit()
     self.roots = nil
end