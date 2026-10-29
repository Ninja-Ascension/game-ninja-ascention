--------------------------------------------------------------------------------------------------------------
--  说明：叛军出没-叛军
--------------------------------------------------------------------------------------------------------------
RebelHauntListInfo = class("RebelHauntListInfoClass", Window)

--打开界面
local rebel_haunt_list_info_open_terminal = {
	_name = "rebel_haunt_list_info_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = RebelHauntListInfo:new():init(params)
		fwin:open(panel)
        return panel
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(rebel_haunt_list_info_open_terminal)
state_machine.init()

function RebelHauntListInfo:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._page = 0

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_rebel_soldier_arrow_down = nil
    self._Image_rebel_soldier_arrow_up = nil

    local function init_rebel_haunt_list_info_terminal()
        local rebel_haunt_list_info_show_terminal = {
            _name = "rebel_haunt_list_info_show",
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

        local rebel_haunt_list_info_hide_terminal = {
            _name = "rebel_haunt_list_info_hide",
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

        local rebel_haunt_list_info_update_terminal = {
            _name = "rebel_haunt_list_info_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params ~= nil and params.roots ~= nil and params.roots[1] ~= nil then
                    local posY = params._list_view_poy
                    params:onUpdateDraw()
                    if math.abs(posY) > math.abs(params._list_view_height) then
                        posY = params._list_view_height
                    end
                    params._list_view:getInnerContainer():setPositionY(posY)   
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(rebel_haunt_list_info_show_terminal)
        state_machine.add(rebel_haunt_list_info_hide_terminal)
        state_machine.add(rebel_haunt_list_info_update_terminal)
        state_machine.init()
    end
    init_rebel_haunt_list_info_terminal()
end

function RebelHauntListInfo:onUpdateDraw()
    local root = self.roots[1]
    local ListView_rebel_soldier = ccui.Helper:seekWidgetByName(root, "ListView_rebel_soldier")
    self._list_view = ListView_rebel_soldier
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    local death = {}
    local alive = {}
    local info = _ED.user_rebel_haunt_list_info[""..(self._page - 1)]
    if info ~= nil then
        for k,v in pairs(info) do
            if tonumber(v._kill_name) == -1 then
                table.insert(alive, v)
            else
                table.insert(death, v)
            end
        end
        local function sortFunc( a, b )
            local a_times = getWorldTwopointMovementTime(_ED.world_map.position_coordinates_x,
                _ED.world_map.position_coordinates_y, a._x, a._y, true)
            local b_times = getWorldTwopointMovementTime(_ED.world_map.position_coordinates_x,
                _ED.world_map.position_coordinates_y, b._x, b._y, true)
            return a_times < b_times
        end
        table.sort(alive, sortFunc)

        local index = 0
        for k,v in pairs(alive) do
            local cell = nil
            index = index + 1
            if _ED.user_rebel_haunt_state == 1 then
                cell = state_machine.excute("rebel_soldier_attack_create_cell", 0, {index, v, self._page})
            else
                cell = state_machine.excute("rebel_soldier_create_cell", 0, {index, v, self._page})
            end
            self._list_view:addChild(cell)
        end

        for k,v in pairs(death) do
            index = index + 1
            local cell = state_machine.excute("rebel_soldier_create_cell", 0, {index, v, self._page})
            self._list_view:addChild(cell)
        end
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()
end

function RebelHauntListInfo:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_rebel_soldier_arrow_down:setVisible(true)
        else
            self._Image_rebel_soldier_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_rebel_soldier_arrow_up:setVisible(true)
        else
            self._Image_rebel_soldier_arrow_up:setVisible(false)
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

function RebelHauntListInfo:onInit()
    local csbItem = csb.createNode(config_csb.campaign.rebel_haunt_tab_1_listview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_rebel_soldier_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_rebel_soldier_arrow_down")
    self._Image_rebel_soldier_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_rebel_soldier_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_rebel_soldier_arrow_down:stopAllActions()
    self._Image_rebel_soldier_arrow_up:stopAllActions()
    playActions(self._Image_rebel_soldier_arrow_down)
    playActions(self._Image_rebel_soldier_arrow_up)
    self._Image_rebel_soldier_arrow_down:setVisible(false)
    self._Image_rebel_soldier_arrow_up:setVisible(false)

    self:onUpdateDraw()
end

function RebelHauntListInfo:init(params)
    local rootWindow = params[1]
    self._page = params[2]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function RebelHauntListInfo:onExit()
    state_machine.remove("rebel_haunt_list_info_show")
    state_machine.remove("rebel_haunt_list_info_hide")
    state_machine.remove("rebel_haunt_list_info_update")
end