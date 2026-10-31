-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场列表窗口
-------------------------------------------------------------------------------------------------------
AdventureArena = class("AdventureArenaClass", Window)
    
function AdventureArena:ctor()
    self.super:ctor()
    self.roots = {}
	self.isTouchLock = false
	self.interval = 0
    self.needUpdateRefreshCd = false
    -- 显示CD的时间
    self.strtime = nil
    self.isGetServer = false
	self._Text_cd = nil
    app.load("client.adventure.cells.arena.AdventureArenaManagerArenaTwoList")
    -- Initialize adventure arena state machine.
    local function init_adventure_arena_terminal()
		local adventure_arena_straight_explain_terminal = {
            _name = "adventure_arena_straight_explain",
            _init = function (terminal)
                 app.load("client.adventure.campaign.arena.AdventureArenaStraightExplain")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:open(AdventureArenaStraightExplain:new(),fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        --关闭竞技场场并且在列表中重新计时
        local adventure_arena_straight_request_close_arena_terminal = {
            _name = "adventure_arena_straight_request_close_arena",
            _init = function (terminal)
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("AdventureArenaClass"))
                state_machine.excute("adventure_arena_manager_back_again_time",0,0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
		local adventure_arena_straight_reset_list_terminal = {
            _name = "adventure_arena_straight_reset_list",
            _init = function (terminal)
                 app.load("client.adventure.campaign.arena.AdventureArenaResetLlist")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:open(AdventureArenaResetLlist:new():init(1,params._datas.cell.strtime),fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_arena_straight_request_update_interface_terminal = {
            _name = "adventure_arena_straight_request_update_interface",
            _init = function (terminal)
                 -- app.load("client.adventure.campaign.arena.AdventureArenaStraightExplain")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_arena_straight_request_open_arena_shop_terminal = {
            _name = "adventure_arena_straight_request_open_arena_shop",
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
		
		state_machine.add(adventure_arena_straight_explain_terminal)
		state_machine.add(adventure_arena_straight_request_update_interface_terminal)
		state_machine.add(adventure_arena_straight_reset_list_terminal)
		state_machine.add(adventure_arena_straight_request_open_arena_shop_terminal)
        state_machine.add(adventure_arena_straight_request_close_arena_terminal)
        state_machine.init()
    end
    
    -- call func init adventure arena state machine.
    init_adventure_arena_terminal()
end

function AdventureArena:init(isGetServer)
    if isGetServer ~= nil and isGetServer == true then 
        self.isGetServer = true
    else
        self.isGetServer = false
    end
	return self
end

function AdventureArena:updateRefreshCd()
	if self.needUpdateRefreshCd == false then
        return
    end
    local root = self.roots[1]
    local interval = self.interval
	if interval <= 0 then
		self._Text_cd:setString("00:00:00")
	else
		self.interval = math.max(0, self.interval)

        local timeTabel = formatTime(self.interval)
        self.strtime = timeTabel.hour
        self.strtime = self.strtime .. string.format(":%02d", timeTabel.minute)
        self.strtime = self.strtime .. string.format(":%02d", timeTabel.second)

        self._Text_cd:setString(self.strtime)
	end
	
end

function AdventureArena:onUpdate(dt)
    if self.interval > 0 then
        local interval = (_ED.native_arena_two_time + zstring.tonumber(_ED.arena_info[2].arena_challenge_lasttime)) - os.time()
        if self.interval ~= interval then
            self.interval = interval
            self:updateRefreshCd()
        end
    else
        local root = self.roots[1]
        self._Text_cd:setString("00:00:00")
    end
end

function AdventureArena:onUpdateDraw()
	local root = self.roots[1]
	local Text_cishu = ccui.Helper:seekWidgetByName(root, "Text_cishu")
    self._Text_cd = ccui.Helper:seekWidgetByName(root, "Text_cd")
	Text_cishu:setString(_ED.arena_user_remain)
	local ListView_jingji = ccui.Helper:seekWidgetByName(root, "ListView_jingji")
	ListView_jingji:removeAllItems()
	for i=1, zstring.tonumber(_ED.arena_challenge_number) do
		local cell = AdventureArenaManagerArenaTwoList:createCell()
		cell:init(_ED.arena_challenge[i],i)
		ListView_jingji:addChild(cell)
		ListView_jingji:requestRefreshView()
	end
	
	ccui.Helper:seekWidgetByName(root, "LoadingBar_1"):setPercent( zstring.tonumber(_ED.arena_user_victory)/ 9 * 100)
	
	self.interval = (_ED.native_arena_two_time + zstring.tonumber(_ED.arena_info[2].arena_challenge_lasttime)) - os.time()
    self.needUpdateRefreshCd = true
    self:updateRefreshCd()
end

function AdventureArena:onEnterTransitionFinish()
	local csbAdventureArena = csb.createNode("campaign/Arena/jingjichang_jingji.csb")
    local root = csbAdventureArena:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureArena)
	--if self.isTouchLock == true then
    if self.isGetServer == false then 
        self:onUpdateDraw()
    else
        local function responseArenaInitCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    -- if self.isTouchLock == false then
                if response.node ~= nil and response.node.roots ~= nil then 
                    response.node:onUpdateDraw()
                end
                    -- end
            end    
        end
        protocol_command.arena_init2.param_list = "1"
        NetworkManager:register(protocol_command.arena_init2.code, nil, nil, nil, self, responseArenaInitCallback, false, nil)
    end
		
	
	--说明
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guize"), nil, 
    {
        terminal_name = "adventure_arena_straight_explain", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	--重置
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cd"), nil, 
    {
        terminal_name = "adventure_arena_straight_reset_list", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	--兑换奖励
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_duihuan"), nil, 
    {
        terminal_name = "adventure_arena_straight_request_open_arena_shop", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"),       nil, 
    {
        terminal_name = "adventure_arena_straight_request_close_arena", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
	-- arena2_refush
	local reward = getSceneReward(13)
	if reward ~= nil then
		app.load("client.adventure.reward.AdventureTipReward")
		fwin:open(AdventureTipReward:new():init(reward), fwin._ui)
	end
	
end

function AdventureArena:onExit()
     self.roots = nil
     state_machine.remove("adventure_arena_straight_request_close_arena")
     state_machine.remove("adventure_arena_straight_request_open_arena_shop")
     state_machine.remove("adventure_arena_straight_reset_list")
     state_machine.remove("adventure_arena_straight_explain")
end