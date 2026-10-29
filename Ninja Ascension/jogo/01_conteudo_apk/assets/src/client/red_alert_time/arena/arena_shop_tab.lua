-- ----------------------------------------------------------------------------------------------------
-- 说明：战地争霸商店界面
-------------------------------------------------------------------------------------------------------
ArenaShopTab = class("ArenaShopTabClass", Window)

local arena_shop_tab_open_terminal = {
    _name = "arena_shop_tab_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaShopTabClass")
        if nil == _homeWindow then
    		fwin:open(ArenaShopTab:new():init(params[1]), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local arena_shop_tab_close_terminal = {
    _name = "arena_shop_tab_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaShopTabClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("ArenaShopTabClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_shop_tab_open_terminal)
state_machine.add(arena_shop_tab_close_terminal)
state_machine.init()
    
function ArenaShopTab:ctor()
    self.super:ctor()
    self.roots = {}
	self._current_page = 0

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._refresh_cost = 0
	
	app.load("client.red_alert_time.cells.arena.arena_shop_cell")
    app.load("client.red_alert_time.worldMap.redAlertTimeMineWarmTips")
	
	local function init_arena_shop_tab_terminal()
		local arena_shop_tab_show_terminal = {
            _name = "arena_shop_tab_show",
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

        local arena_shop_tab_hide_terminal = {
            _name = "arena_shop_tab_hide",
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

		local arena_shop_tab_update_honour_terminal = {
            _name = "arena_shop_tab_update_honour",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                ccui.Helper:seekWidgetByName(instance.roots[1], "Text_medal_n"):setString(_ED.user_info.user_honour)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local arena_shop_tab_refresh_list_terminal = {
            _name = "arena_shop_tab_refresh_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._refresh_cost == 0 then
                    state_machine.excute("arena_shop_tab_refresh_list_confirmation", 0, 0)
                else
                    state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = instance, m_type = 19}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local arena_shop_tab_refresh_list_confirmation_terminal = {
            _name = "arena_shop_tab_refresh_list_confirmation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:sureRefresh(0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
        state_machine.add(arena_shop_tab_show_terminal)
        state_machine.add(arena_shop_tab_hide_terminal) 
        state_machine.add(arena_shop_tab_update_honour_terminal) 
        state_machine.add(arena_shop_tab_refresh_list_terminal) 
        state_machine.add(arena_shop_tab_refresh_list_confirmation_terminal) 
		state_machine.init()
	end
	
	init_arena_shop_tab_terminal()
end

function ArenaShopTab:sureRefresh(sure_number)
    if self.roots == nil then
        return
    end
    local root = self.roots[1]
    if root == nil then
        return
    end
    local function responseCallBack(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            TipDlg.drawTextDailog(arena_tip_text[38])
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:onUpdateDraw()
            end
        end
    end
    if sure_number == 0 then
        NetworkManager:register(protocol_command.arena_shop_refresh.code, nil, nil, nil, self, responseCallBack, false, nil)
    end
end

function ArenaShopTab:onUpdateDraw()
	local root = self.roots[1]
	local ListView_arena_shop = ccui.Helper:seekWidgetByName(root, "ListView_arena_shop")
    ListView_arena_shop:jumpToTop()
	ListView_arena_shop:removeAllItems()
	local shop_info = zstring.split(_ED.arena_info.shop_id_clump, ",")
	for i=1,#shop_info do
		local cell = state_machine.excute("arena_shop_cell", 0, {shop_info[i],i}) 
		ListView_arena_shop:addChild(cell)
	end
	ListView_arena_shop:requestRefreshView()
    self._list_view = ListView_arena_shop
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

	local Text_medal_n = ccui.Helper:seekWidgetByName(root, "Text_medal_n")
	Text_medal_n:setString(_ED.user_info.user_honour)
	
	if tonumber(_ED.arena_info.refresh_times) > 0  then
		ccui.Helper:seekWidgetByName(root, "Button_arena_shop_refresh"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_arena_shop_gold_icon"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_arena_shop_refresh_gold_n"):setVisible(true)
		local consumption = dms.string(dms["arena_config"],17,arena_config.param)
		local params = zstring.split(consumption, ",")
		if #params < tonumber(_ED.arena_info.refresh_times)+1 then
			ccui.Helper:seekWidgetByName(root, "Text_arena_shop_refresh_gold_n"):setString(params[#params])
            self._refresh_cost = tonumber(params[#params])
		else
			ccui.Helper:seekWidgetByName(root, "Text_arena_shop_refresh_gold_n"):setString(params[tonumber(_ED.arena_info.refresh_times)+1])
            self._refresh_cost = tonumber(params[tonumber(_ED.arena_info.refresh_times)+1])
		end
	else
		ccui.Helper:seekWidgetByName(root, "Button_arena_shop_refresh"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_arena_shop_gold_icon"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Text_arena_shop_refresh_gold_n"):setVisible(false)
        self._refresh_cost = 0
	end
end

function ArenaShopTab:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
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

function ArenaShopTab:init(params1)
	self._rootWindows = params1
    self:onInit()
    return self
end

function ArenaShopTab:onInit()
    local csbArenaShopTab = csb.createNode(config_csb.arena.arena_shop_tab)
    local root = csbArenaShopTab:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbArenaShopTab)
	
	--刷新
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_free_refresh"), nil, 
    {
        terminal_name = "arena_shop_tab_refresh_list", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self,
    }, nil, 1)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arena_shop_refresh"), nil, 
    {
        terminal_name = "arena_shop_tab_refresh_list", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self,
    }, nil, 1)
	
	self:onUpdateDraw()
end

function ArenaShopTab:onExit()
    state_machine.remove("arena_shop_tab_show")
    state_machine.remove("arena_shop_tab_hide")
    state_machine.remove("arena_shop_tab_update_honour")
    state_machine.remove("arena_shop_tab_refresh_list")
    state_machine.remove("arena_shop_tab_refresh_list_confirmation")
end