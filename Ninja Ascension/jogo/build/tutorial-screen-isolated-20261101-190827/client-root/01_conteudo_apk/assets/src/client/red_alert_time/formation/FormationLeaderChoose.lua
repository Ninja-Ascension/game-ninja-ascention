--------------------------------------------------------------------------------------------------------------
--  将领选择
--------------------------------------------------------------------------------------------------------------
FormationLeaderChoose = class("FormationLeaderChooseClass", Window)

local formation_leader_choose_window_open_terminal = {
    _name = "formation_leader_choose_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("FormationLeaderChooseClass") == nil then
            fwin:open(FormationLeaderChoose:new():init(params), fwin._ui)  
        end
    end,
    _terminal = nil,
    _terminals = nil
}

local formation_leader_choose_window_close_terminal = {
    _name = "formation_leader_choose_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("FormationLeaderChooseClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(formation_leader_choose_window_open_terminal)
state_machine.add(formation_leader_choose_window_close_terminal)
state_machine.init()

function FormationLeaderChoose:ctor()
    self.super:ctor()
    self.roots = {}

    self.listview = nil
    self.listview_poy = 0
    self.listview_height = 0

    self._choose_leader_index = 0
    self._choose_leader_list = {}
    
end

function FormationLeaderChoose:updateDraw()
    local root = self.roots[1]
    local ListView_choose_leader = ccui.Helper:seekWidgetByName(root, "ListView_choose_leader")
    ListView_choose_leader:jumpToTop()
    ListView_choose_leader:removeAllItems()

    local result = {}
    for k, v in pairs(_ED.user_ship) do
        if tonumber(v.camp_preference) == 0 then
            local count = zstring.tonumber(v.current_count)
            if self._from_type == 14 then
                count = count + zstring.tonumber(v.union_fight_count)
            end
            if count > 0 then
                local isNeedPush = true
                for k1,v1 in pairs(self._choose_leader_list) do
                    if v1.ship ~= nil then
                        if zstring.tonumber(v.ship_id) == zstring.tonumber(v1.ship.ship_id) then
                            isNeedPush = false
                        end
                    end
                end
                if isNeedPush == true then
                    table.insert(result, v)
                end
            end
        end
    end

    local function sortFunction(a, b)
        if tonumber(a.ship_type) > tonumber(b.ship_type)
            or tonumber(a.ship_type) == tonumber(b.ship_type) and tonumber(a.ship_level) > tonumber(b.ship_level) 
            or tonumber(a.ship_type) == tonumber(b.ship_type) and tonumber(a.ship_level) == tonumber(b.ship_level) and tonumber(a.ship_template_id) < tonumber(b.ship_template_id)
            then
            return true
        end
        return false
    end
    table.sort(result, sortFunction)

    for k, v in pairs(result) do
        local cell = state_machine.excute("formation_choose_leader_cell_create", 0, {k, self._choose_leader_index, v})
        ListView_choose_leader:addChild(cell)
    end

    ListView_choose_leader:requestRefreshView()
    self.listview = ListView_choose_leader
    self.listview_poy = ListView_choose_leader:getInnerContainer():getPositionY()
    self.listview_height = ListView_choose_leader:getInnerContainer():getPositionY()
end

function FormationLeaderChoose:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
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

function FormationLeaderChoose:onInit()
    local csbItem = csb.createNode(config_csb.formation.formation_choose_leader)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_choose_troops_close"), nil, 
    {
        terminal_name = "formation_leader_choose_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self:updateDraw()
end

function FormationLeaderChoose:onEnterTransitionFinish()
    
end

function FormationLeaderChoose:init(params)
    self._choose_leader_index = params[1]
    self._choose_leader_list = params[2]
    self:setTouchEnabled(true)
    self:onInit()
    return self
end

function FormationLeaderChoose:onExit()
    state_machine.remove("formation_leader_choose_ok")
end