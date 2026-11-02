-- ----------------------------------------------------------------------------------------------------
-- 说明：战地争霸积分奖励界面
-------------------------------------------------------------------------------------------------------
ArenaRewardIntegralTab = class("ArenaRewardIntegralTabClass", Window)

local arena_reward_integral_tab_open_terminal = {
    _name = "arena_reward_integral_tab_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaRewardIntegralTabClass")
        if nil == _homeWindow then
    		fwin:open(ArenaRewardIntegralTab:new():init(params[1]), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local arena_reward_integral_tab_close_terminal = {
    _name = "arena_reward_integral_tab_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaRewardIntegralTabClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("ArenaRewardIntegralTabClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_reward_integral_tab_open_terminal)
state_machine.add(arena_reward_integral_tab_close_terminal)
state_machine.init()
    
function ArenaRewardIntegralTab:ctor()
    self.super:ctor()
    self.roots = {}
	self._current_page = 0

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil
	
	app.load("client.red_alert_time.cells.arena.arena_integral_cell")
	
	local function init_arena_reward_integral_tab_terminal()
		local arena_reward_integral_tab_show_terminal = {
            _name = "arena_reward_integral_tab_show",
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

        local arena_reward_integral_tab_hide_terminal = {
            _name = "arena_reward_integral_tab_hide",
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

        local arena_reward_integral_tab_update_draw_terminal = {
            _name = "arena_reward_integral_tab_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local posY = instance._list_view_poy
                instance:onUpdateDraw()
                if math.abs(posY) > math.abs(instance._list_view_height) then
                    posY = instance._list_view_height
                end
                instance._list_view:getInnerContainer():setPositionY(posY)   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

	
        state_machine.add(arena_reward_integral_tab_show_terminal)
        state_machine.add(arena_reward_integral_tab_hide_terminal) 
        state_machine.add(arena_reward_integral_tab_update_draw_terminal) 
		state_machine.init()
	end
	
	init_arena_reward_integral_tab_terminal()
	
end

function ArenaRewardIntegralTab:onUpdateDraw()
	local root = self.roots[1]
	-- arena_integral_cell
	local count = table.nums(dms["arena_score"])
	local ListView_arena_integral = ccui.Helper:seekWidgetByName(root, "ListView_arena_integral")
    ListView_arena_integral:jumpToTop()
	ListView_arena_integral:removeAllItems()
    local state_group = zstring.split(_ED.arena_info.state_group, ",")
    local index = 0
    local state = false
	for i=1, count do
        if tonumber(_ED.arena_info.integral) >= i*2 then
            if tonumber(state_group[i]) == 0 
                and state == false then
                index = i
                state = true
            end
        end
		local cell =  state_machine.excute("arena_integral_cell", 0, i) 
		ListView_arena_integral:addChild(cell)
	end
    ListView_arena_integral:refreshView()
    ListView_arena_integral:getInnerContainer():setPosition(cc.p(0,(index+6) * ArenaIntegralCell.__size.height - ListView_arena_integral:getInnerContainer():getContentSize().height))
    self._list_view = ListView_arena_integral
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
	
	--我的积分
	local Text_integral_me_n = ccui.Helper:seekWidgetByName(root, "Text_integral_me_n")
	Text_integral_me_n:setString(_ED.arena_info.integral)
	
	--
	local Text_arena_integral_vic_n = ccui.Helper:seekWidgetByName(root, "Text_arena_integral_vic_n")
	Text_arena_integral_vic_n:setString(string.format(red_alert_time_str[186], 2))
	local Text_arena_integral_fail_n = ccui.Helper:seekWidgetByName(root, "Text_arena_integral_fail_n")
	Text_arena_integral_fail_n:setString(string.format(red_alert_time_str[186], 1))
end

function ArenaRewardIntegralTab:onUpdate(dt)
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

function ArenaRewardIntegralTab:init(params1)
	self._rootWindows = params1
    self:onInit()
    return self
end

function ArenaRewardIntegralTab:onInit()
    local csbArenaRewardIntegralTab = csb.createNode(config_csb.arena.arena_reward_tab_1)
    local root = csbArenaRewardIntegralTab:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbArenaRewardIntegralTab)
	
    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_arena_integra_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_arena_integra_arrow_up")
    
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
	
	self:onUpdateDraw()
end

function ArenaRewardIntegralTab:onExit()
	state_machine.remove("arena_reward_integral_tab_show")
    state_machine.remove("arena_reward_integral_tab_hide")
    state_machine.remove("arena_reward_integral_tab_update_draw")
end