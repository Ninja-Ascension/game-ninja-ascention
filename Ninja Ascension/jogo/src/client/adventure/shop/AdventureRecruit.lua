-- ----------------------------------------------------------------------------------------------------
-- 说明：招募主界面
-------------------------------------------------------------------------------------------------------
AdventureRecruit = class("AdventureRecruitClass", Window)
    
function AdventureRecruit:ctor()
    self.super:ctor()
    self.roots = {}

    self.interval = 0
    self.needUpdateSkyTempleRefreshCd = false

    -- Initialize adventure recruit state machine.
    local function init_adventure_recruit_terminal()
        -- 钻石招募
        local adventure_recruit_with_gold_terminal = {
            _name = "adventure_recruit_with_gold",
            _init = function (terminal)
                app.load("client.adventure.shop.recruit.AdventureRecruitWithGold")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:open(AdventureRecruitWithGold:new(), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 银币招募
        local adventure_recruit_with_silver_terminal = {
            _name = "adventure_recruit_with_silver",
            _init = function (terminal)
                app.load("client.adventure.shop.recruit.AdventureRecruitWithSilver")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureRecruitWithSilver:new(), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 友情招募
        local adventure_recruit_with_friendship_terminal = {
            _name = "adventure_recruit_with_friendship",
            _init = function (terminal)
                app.load("client.adventure.shop.recruit.AdventureRecruitWithFriendship")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureRecruitWithFriendship:new(), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 天空神殿
        local adventure_recruit_with_lost_temple_terminal = {
            _name = "adventure_recruit_with_lost_temple",
            _init = function (terminal)
                app.load("client.adventure.shop.recruit.AdventureRecruitOfLostTemple")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureRecruitOfLostTemple:new(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 刷新银币数
        local adventure_recruit_with_update_money_terminal = {
            _name = "adventure_recruit_with_update_money",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self:onUpdateDrawMoney()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_recruit_with_gold_terminal)
        state_machine.add(adventure_recruit_with_silver_terminal)
        state_machine.add(adventure_recruit_with_friendship_terminal)
        state_machine.add(adventure_recruit_with_lost_temple_terminal)
        state_machine.add(adventure_recruit_with_update_money_terminal)
        state_machine.init()
    end
    
    -- call func init adventure recruit state machine.
    init_adventure_recruit_terminal()
end

function AdventureRecruit:init()
	return self
end

function AdventureRecruit:onUpdateDrawMoney()
	local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Text_jinbishu"):setString(getResourceValueToStringForAdventure(_ED.recruit_silver.current_recruit_consume))
end

function AdventureRecruit:updateSkyTempleRefreshCd()
    if self.needUpdateSkyTempleRefreshCd == false then
        return
    end
    local root = self.roots[1]
    local interval = self.interval
    if interval <= 0 then
        ccui.Helper:seekWidgetByName(root, "Text_shijian_0"):setString("00:00:00")
        self.needUpdateSkyTempleRefreshCd = false
        local function responseSkyTempleInitCallBack(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil then
                    response.node.interval = (_ED.recruit_sky_temple.refresh_os_time + _ED.recruit_sky_temple.refresh_cd) - os.time()
                    response.node.needUpdateSkyTempleRefreshCd = true
                end
            end
        end
        NetworkManager:register(protocol_command.sky_temple_init.code, nil, nil, nil, self, responseSkyTempleInitCallBack, false, nil)
    else
        self.interval = math.max(0, self.interval)

        local timeTabel = formatTime(self.interval)
        local str = timeTabel.hour
        str = str .. string.format(":%02d", timeTabel.minute)
        str = str .. string.format(":%02d", timeTabel.second)

        ccui.Helper:seekWidgetByName(root, "Text_shijian_0"):setString(str)
    end
end

function AdventureRecruit:onUpdate(dt)
    if self.interval > 0 then
        local interval = (_ED.recruit_sky_temple.refresh_os_time + _ED.recruit_sky_temple.refresh_cd) - os.time()
        if self.interval ~= interval then
            self.interval = interval
            self:updateSkyTempleRefreshCd()
        end
    end
end

function AdventureRecruit:onEnterTransitionFinish()
	local csbAdventureRecruit = csb.createNode("shop/heroshop/heroshop.csb")
    local root = csbAdventureRecruit:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureRecruit)

    -- 钻石招募
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"),       nil, 
    {
        terminal_name = "adventure_recruit_with_gold",        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 银币招募
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"),       nil, 
    {
        terminal_name = "adventure_recruit_with_silver",        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 友情招募
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"),       nil, 
    {
        terminal_name = "adventure_recruit_with_friendship",        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 天空神殿
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"),       nil, 
    {
        terminal_name = "adventure_recruit_with_lost_temple",        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
	-- 绘制银币招募的消耗
	self:onUpdateDrawMoney()
    -- 绘制天空神殿招募的CD
    self.interval = (_ED.recruit_sky_temple.refresh_os_time + _ED.recruit_sky_temple.refresh_cd) - os.time()
    self.needUpdateSkyTempleRefreshCd = true
    self:updateSkyTempleRefreshCd()
    state_machine.excute("adventure_push_info_open",0,4)
end

function AdventureRecruit:onExit()
    state_machine.excute("adventure_push_info_close",0,0)
    state_machine.remove("adventure_recruit_with_gold")
    state_machine.remove("adventure_recruit_with_silver")
    state_machine.remove("adventure_recruit_with_friendship")
    state_machine.remove("adventure_recruit_with_lost_temple")
end