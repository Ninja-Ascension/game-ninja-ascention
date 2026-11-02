-- ----------------------------------------------------------------------------------------------------
-- 说明：战地争霸幸运奖励界面
-------------------------------------------------------------------------------------------------------
ArenaRewardLuckyTab = class("ArenaRewardLuckyTabClass", Window)

local arena_reward_lucky_tab_open_terminal = {
    _name = "arena_reward_lucky_tab_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaRewardLuckyTabClass")
        if nil == _homeWindow then
    		fwin:open(ArenaRewardLuckyTab:new():init(params[1]), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local arena_reward_lucky_tab_close_terminal = {
    _name = "arena_reward_lucky_tab_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaRewardLuckyTabClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("ArenaRewardLuckyTabClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_reward_lucky_tab_open_terminal)
state_machine.add(arena_reward_lucky_tab_close_terminal)
state_machine.init()
    
function ArenaRewardLuckyTab:ctor()
    self.super:ctor()
    self.roots = {}
	self._current_page = 0

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil
	
	app.load("client.red_alert_time.cells.arena.arena_reward_lucky_cell")
	
	local function init_arena_reward_lucky_tab_terminal()
		local arena_reward_lucky_tab_show_terminal = {
            _name = "arena_reward_lucky_tab_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local arena_reward_lucky_tab_hide_terminal = {
            _name = "arena_reward_lucky_tab_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local arena_reward_lucky_tab_receive_terminal = {
            _name = "arena_reward_lucky_tab_receive",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
						checkRewardObtainDraw()
                        state_machine.excute("notification_center_update", 0, "push_notification_arena_all_reward")
                        state_machine.excute("notification_center_update", 0, "push_notification_arena_lucky_reward")
					end
				end
				NetworkManager:register(protocol_command.draw_arena_lucky_reward.code, nil, nil, nil, instance, responseCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(arena_reward_lucky_tab_show_terminal)
        state_machine.add(arena_reward_lucky_tab_hide_terminal) 
        state_machine.add(arena_reward_lucky_tab_receive_terminal) 
		state_machine.init()
	end
	init_arena_reward_lucky_tab_terminal()
end

function ArenaRewardLuckyTab:onUpdateDraw()
	local root = self.roots[1]

	local ListView_rank_lucky_reward = ccui.Helper:seekWidgetByName(root, "ListView_rank_lucky_reward")
    ListView_rank_lucky_reward:jumpToTop()
	ListView_rank_lucky_reward:removeAllItems()
	local onTheList = 0
    local index = 1
	for i,v in pairs(_ED.arena_lucky_ranking) do
        if tonumber(v.previous_period_lucky_rank_id) > 0 then
    		local cells = state_machine.excute("arena_reward_lucky_cell", 0, {v, index}) 
            index = index + 1
    		ListView_rank_lucky_reward:addChild(cells)
    		if tonumber(v.previous_period_lucky_rank_id) == tonumber(_ED.user_info.user_id) then
    			onTheList = tonumber(v.previous_period_lucky_rand)
    		end
        end
	end
	ListView_rank_lucky_reward:requestRefreshView()
    self._list_view = ListView_rank_lucky_reward
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
	
	local Text_rank_last_time_n = ccui.Helper:seekWidgetByName(root, "Text_rank_last_time_n")
	local Button_lucky_reward_receive = ccui.Helper:seekWidgetByName(root, "Button_lucky_reward_receive")
	if onTheList > 0 then
		Text_rank_last_time_n:setString(onTheList)
        if tonumber(_ED.arena_info.lucky_state) == 0 then
            Button_lucky_reward_receive:setTitleText(red_alert_time_str[128])
    		Button_lucky_reward_receive:setTouchEnabled(true)
    		Button_lucky_reward_receive:setBright(true)
        else
            Button_lucky_reward_receive:setTitleText(arena_tip_text[22])
            Button_lucky_reward_receive:setTouchEnabled(false)
            Button_lucky_reward_receive:setBright(false)
        end
	else
		Text_rank_last_time_n:setString(arena_tip_text[23])
        Button_lucky_reward_receive:setTitleText(arena_tip_text[21])
		Button_lucky_reward_receive:setTouchEnabled(false)
		Button_lucky_reward_receive:setBright(false)
	end
    local Button_text_lucky_reward_receive = ccui.Helper:seekWidgetByName(root, "Button_text_lucky_reward_receive")
    if Button_text_lucky_reward_receive ~= nil then
        Button_text_lucky_reward_receive:setString(Button_lucky_reward_receive:getTitleText())
        Button_lucky_reward_receive:setTitleText("")
    end
end

function ArenaRewardLuckyTab:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_arrow_down:setVisible(true)
        else
            self._Image_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_arrow_up:setVisible(true)
        else
            self._Image_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end


function ArenaRewardLuckyTab:init(params1)
	self._rootWindows = params1
    self:onInit()
    return self
end

function ArenaRewardLuckyTab:onInit()
    local csbArenaRewardLuckyTab = csb.createNode(config_csb.arena.arena_reward_tab_4)
    local root = csbArenaRewardLuckyTab:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbArenaRewardLuckyTab)
	
    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_lucky_reward_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_lucky_reward_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_arrow_down:stopAllActions()
    self._Image_arrow_up:stopAllActions()
    playActions(self._Image_arrow_down)
    playActions(self._Image_arrow_up)
    self._Image_arrow_down:setVisible(false)
    self._Image_arrow_up:setVisible(false)
	
	--领取
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lucky_reward_receive"), nil, 
    {
        terminal_name = "arena_reward_lucky_tab_receive", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	self:onUpdateDraw()
end

function ArenaRewardLuckyTab:onExit()
	state_machine.remove("arena_reward_lucky_tab_show")
    state_machine.remove("arena_reward_lucky_tab_hide")
    state_machine.remove("arena_reward_lucky_tab_receive")
end
