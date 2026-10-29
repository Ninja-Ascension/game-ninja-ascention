--------------------------------------------------------------------------------------------------------------
--  说明：称号
--------------------------------------------------------------------------------------------------------------
PlayerTitleSet = class("PlayerTitleSetClass", Window)

--打开界面
local player_title_set_open_terminal = {
	_name = "player_title_set_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("PlayerTitleSetClass") == nil then
    		fwin:open(PlayerTitleSet:new():init(params), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local player_title_set_close_terminal = {
	_name = "player_title_set_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PlayerTitleSetClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local player_title_set_check_time_terminal = {
    _name = "player_title_set_check_time",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local current_time = params
        if _ED.user_title_info ~= nil and table.nums(_ED.user_title_info) > 0 then
            for k,v in pairs(_ED.user_title_info) do
                if (_ED.system_time + current_time - _ED.native_time) > v then
                    NetworkManager:register(protocol_command.check_title_state.code, nil, nil, nil, nil, nil, false, nil)
                    break
                end
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(player_title_set_open_terminal)
state_machine.add(player_title_set_close_terminal)
state_machine.add(player_title_set_check_time_terminal)
state_machine.init()

function PlayerTitleSet:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil

    app.load("client.red_alert_time.cells.player.player_title_cell")

    local function init_play_infomation_terminal()
        local player_title_set_show_terminal = {
            _name = "player_title_set_show",
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

        local player_title_set_hide_terminal = {
            _name = "player_title_set_hide",
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

        local player_title_update_list_info_terminal = {
            _name = "player_title_update_list_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local posY = instance._list_view_poy
                instance:updateListInfo()
                -- if math.abs(posY) > math.abs(instance._list_view_height) then
                --     posY = instance._list_view_height
                -- end
                -- instance._list_view:getInnerContainer():setPositionY(posY)    
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(player_title_set_show_terminal)
        state_machine.add(player_title_set_hide_terminal)
        state_machine.add(player_title_update_list_info_terminal)
        state_machine.init()
    end
    
    init_play_infomation_terminal()
end

function PlayerTitleSet:updateListInfo( ... )
    local root = self.roots[1]
    self._list_view:jumpToTop()

    local useTitleId = zstring.tonumber(zstring.split(_ED.user_info.user_head_id, ",")[3])
    local result = {}
    local activeList = {}
    local unActiveList = {}
    local user_head_avatar_state = zstring.split(_ED.user_head_activation, ",")
    for i = 1, dms.count(dms["avatar_head"]) do
        local paging = dms.int(dms["avatar_head"], i, avatar_head.paging)
        if paging == 2 then
            if i == useTitleId then
                table.insert(result, {i, 0})
            else
                if tonumber(user_head_avatar_state[i]) == 0 then
                    table.insert(activeList, {i, 1})
                else
                    table.insert(unActiveList, {i, 2})
                end
            end
        end
    end
    for k,v in pairs(activeList) do
        table.insert(result, v)
    end
    for k,v in pairs(unActiveList) do
        table.insert(result, v)
    end

    local items = self._list_view:getItems()
    for k,v in pairs(items) do
        state_machine.excute("player_title_cell_update_info", 0, {cell = v, index = k, title_id = result[k][1], state = result[k][2]})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            self._list_view:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("player_title_cell_create",0, {i, result[i][1], result[i][2]})
            self._list_view:addChild(cell)
        end
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function PlayerTitleSet:updateDraw()
    local root = self.roots[1]
    local ListView_player_title = ccui.Helper:seekWidgetByName(root, "ListView_player_title")
    self._list_view = ListView_player_title
    ListView_player_title:jumpToTop()
    ListView_player_title:removeAllItems()

    self:updateListInfo()
end

function PlayerTitleSet:onUpdate(dt)
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


--初始化
function PlayerTitleSet:onInit()
    local csbItem = csb.createNode(string.format(config_csb.player.player_head_change_tab, "3"))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_prestige_up"), nil, 
    {
        terminal_name = "player_info_prestige_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_player_title_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_player_title_arrow_up")
    
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

    self:updateDraw()
end

function PlayerTitleSet:onEnterTransitionFinish()

end

function PlayerTitleSet:init(param)
    self._rootWindows = param[1]
	self:onInit()
    return self
end

function PlayerTitleSet:onExit()
    state_machine.remove("player_title_set_show")
    state_machine.remove("player_title_set_hide")
    state_machine.remove("player_title_update_list_info")
end