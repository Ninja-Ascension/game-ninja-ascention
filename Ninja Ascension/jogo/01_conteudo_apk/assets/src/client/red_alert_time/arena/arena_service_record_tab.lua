-- ----------------------------------------------------------------------------------------------------
-- 说明：战地争霸全服战报
-------------------------------------------------------------------------------------------------------
ArenaServiceRecordTab = class("ArenaServiceRecordTabClass", Window)

local arena_service_record_tab_open_terminal = {
    _name = "arena_service_record_tab_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaServiceRecordTabClass")
        if nil == _homeWindow then
    		fwin:open(ArenaServiceRecordTab:new():init(params[1]), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local arena_service_record_tab_close_terminal = {
    _name = "arena_service_record_tab_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaServiceRecordTabClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("ArenaServiceRecordTabClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_service_record_tab_open_terminal)
state_machine.add(arena_service_record_tab_close_terminal)
state_machine.init()
    
function ArenaServiceRecordTab:ctor()
    self.super:ctor()
    self.roots = {}
	self._current_page = 0

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil
	
	local function init_arena_service_record_tab_terminal()
		local arena_service_record_tab_show_terminal = {
            _name = "arena_service_record_tab_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local arena_service_record_tab_hide_terminal = {
            _name = "arena_service_record_tab_hide",
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

        local arena_service_record_tab_update_draw_terminal = {
            _name = "arena_service_record_tab_update_draw",
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

	
        state_machine.add(arena_service_record_tab_show_terminal)
        state_machine.add(arena_service_record_tab_hide_terminal) 
        state_machine.add(arena_service_record_tab_update_draw_terminal)
		state_machine.init()
	end
	
	init_arena_service_record_tab_terminal()
end

function ArenaServiceRecordTab:onUpdateDraw()
	local root = self.roots[1]
	local root = self.roots[1]
	local max_number = dms.string(dms["arena_config"],12,arena_config.param)
	local max_numberInfo = zstring.split(max_number, ",")
	--排序，最新的显示在最上面
	if _ED.city_resource_battle_report~= nil and _ED.city_resource_battle_report[10000] ~= nil then
		table.sort(_ED.city_resource_battle_report[10000], function(c1, c2)
			if zstring.tonumber(c1.time) > zstring.tonumber(c2.time) then
				return true
			end
			return false
		end)
		local ListView_arena_record = ccui.Helper:seekWidgetByName(root, "ListView_arena_record")
        ListView_arena_record:jumpToTop()
		ListView_arena_record:removeAllItems()
		for i, v in pairs(_ED.city_resource_battle_report[10000]) do
			if i <= tonumber(max_numberInfo[2]) then
				local cells = state_machine.excute("arena_record_cell", 0, {v, i}) 
				ListView_arena_record:addChild(cells)
			end
		end
		ListView_arena_record:requestRefreshView()
        self._list_view = ListView_arena_record
        self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
        self._list_view_height = self._list_view:getInnerContainer():getPositionY()
	end
end

function ArenaServiceRecordTab:onUpdate(dt)
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


function ArenaServiceRecordTab:init(params1)
	self._rootWindows = params1
    self:onInit()
    return self
end

function ArenaServiceRecordTab:onInit()
    local csbArenaServiceRecordTab = csb.createNode(config_csb.arena.arena_record_listview)
    local root = csbArenaServiceRecordTab:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbArenaServiceRecordTab)

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_record_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_record_arrow_up")
    
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

function ArenaServiceRecordTab:onExit()
	state_machine.remove("arena_service_record_tab_show")
    state_machine.remove("arena_service_record_tab_hide")
    state_machine.remove("arena_service_record_tab_update_draw")
end