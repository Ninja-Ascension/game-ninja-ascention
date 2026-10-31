-- ----------------------------------------------------------------------------------------------------
-- 说明：战地争霸排行榜全部排行
-------------------------------------------------------------------------------------------------------
ArenaRankAllTab = class("ArenaRankAllTabClass", Window)

local arena_rank_all_tab_open_terminal = {
    _name = "arena_rank_all_tab_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaRankAllTabClass")
        if nil == _homeWindow then
    		fwin:open(ArenaRankAllTab:new():init(params[1]), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local arena_rank_all_tab_close_terminal = {
    _name = "arena_rank_all_tab_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaRankAllTabClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("ArenaRankAllTabClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_rank_all_tab_open_terminal)
state_machine.add(arena_rank_all_tab_close_terminal)
state_machine.init()
    
function ArenaRankAllTab:ctor()
    self.super:ctor()
    self.roots = {}
	self._current_page = 0

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil
	
	app.load("client.red_alert_time.cells.arena.arena_rank_all_cell")
    app.load("client.red_alert_time.cells.arena.arena_rank_more_cell")
	
	local function init_arena_rank_all_tab_terminal()
		local arena_rank_all_tab_show_terminal = {
            _name = "arena_rank_all_tab_show",
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

        local arena_rank_all_tab_hide_terminal = {
            _name = "arena_rank_all_tab_hide",
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

        local arena_rank_all_tab_update_draw_terminal = {
            _name = "arena_rank_all_tab_update_draw",
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

	
        state_machine.add(arena_rank_all_tab_show_terminal)
        state_machine.add(arena_rank_all_tab_hide_terminal) 
        state_machine.add(arena_rank_all_tab_update_draw_terminal) 
		state_machine.init()
	end
	
	init_arena_rank_all_tab_terminal()
	
end

function ArenaRankAllTab:onUpdateDraw()
	local root = self.roots[1]
	--我的排名
	local Text_arena_rank_me_n = ccui.Helper:seekWidgetByName(root, "Text_arena_rank_me_n")
	Text_arena_rank_me_n:setString(_ED.arena_info.rank)
	--列表
	local ListView_arena_rank = ccui.Helper:seekWidgetByName(root, "ListView_arena_rank")
    ListView_arena_rank:jumpToTop()
	ListView_arena_rank:removeAllItems()
    local width = ListView_arena_rank:getContentSize().width
	for i,v in pairs(_ED.city_rank.other_user[1]) do
		local cells = state_machine.excute("arena_rank_all_cell", 0, {v, i}) 
		ListView_arena_rank:addChild(cells)
	end

    if #_ED.city_rank.other_user[1] < 100 and #_ED.city_rank.other_user[1] > 0 and (#_ED.city_rank.other_user[1] % 20) == 0 then
        local cell = state_machine.excute("arena_rank_more_cell_create", 0, {#_ED.city_rank.other_user[1] + 1, 5, 1})
        ListView_arena_rank:addChild(cell)
    end

	ListView_arena_rank:requestRefreshView()
    self._list_view = ListView_arena_rank
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function ArenaRankAllTab:onUpdate(dt)
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

function ArenaRankAllTab:init(params1)
	self._rootWindows = params1
    self:onInit()
    return self
end

function ArenaRankAllTab:onInit()
    local csbArenaRankAllTab = csb.createNode(config_csb.arena.arena_rank_tab_1)
    local root = csbArenaRankAllTab:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbArenaRankAllTab)

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_rank_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_rank_arrow_up")
    
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
	
	local function responseArenaRankingPanelInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:onUpdateDraw()
            end
		end
	end
	protocol_command.arena_order.param_list = "0".. "\r\n" .."1".. "\r\n" .."20"
	NetworkManager:register(protocol_command.arena_order.code, nil, nil, nil, self, responseArenaRankingPanelInitCallback, false, nil)
			
	-- self:onUpdateDraw()
end

function ArenaRankAllTab:onExit()
	state_machine.remove("arena_rank_all_tab_show")
    state_machine.remove("arena_rank_all_tab_hide")
    state_machine.remove("arena_rank_all_tab_update_draw")
end