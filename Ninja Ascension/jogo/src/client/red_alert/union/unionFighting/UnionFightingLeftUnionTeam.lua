UnionFightingLeftUnionTeam = class("UnionFightingLeftUnionTeamClass", Window)
UnionFightingLeftUnionTeam._isShowReport = true

local union_fight_left_union_team_open_terminal = {
    _name = "union_fight_left_union_team_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        return UnionFightingLeftUnionTeam:new():init(params)
    end,
    _terminal = nil,
    _terminals = nil
}

local union_fight_left_union_team_close_terminal = {
    _name = "union_fight_left_union_team_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("UnionFightingLeftUnionTeamClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_fight_left_union_team_open_terminal)
state_machine.add(union_fight_left_union_team_close_terminal)
state_machine.init()

function UnionFightingLeftUnionTeam:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.listview = nil
    self.listview_poy = nil

    self._isShowReport = true

    local function init_union_fight_left_union_team_terminal()
        local union_fighting_left_union_team_change_state_terminal = {
            _name = "union_fighting_left_union_team_change_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                UnionFightingLeftUnionTeam._isShowReport = not UnionFightingLeftUnionTeam._isShowReport
                instance:changeReportState()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fighting_left_union_team_update_info_terminal = {
            _name = "union_fighting_left_union_team_update_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_fighting_left_union_team_change_state_terminal)
        state_machine.add(union_fighting_left_union_team_update_info_terminal)
        state_machine.init()
    end
    init_union_fight_left_union_team_terminal()
end

function UnionFightingLeftUnionTeam:changeReportState( ... )
    local action = self.actions[1]
    if UnionFightingLeftUnionTeam._isShowReport == true then
        action:play("field_out", false)
    else
        action:play("field_in", false)
    end
end

function UnionFightingLeftUnionTeam:updateDraw(params)
    local root = self.roots[1]
    local ListView_legion_number = ccui.Helper:seekWidgetByName(root, "ListView_legion_number")
    ListView_legion_number:removeAllChildren(true)

    local index = 0
    for k,v in pairs(params) do
        index = index + 1
        local count = #v
        local union_name = v[1].union_name
        local cell = state_machine.excute("union_fight_union_team_cell_create", 0, {true, count, union_name, index})
        ListView_legion_number:addChild(cell)
    end
    self.listview = ListView_legion_number
    self.listview:requestRefreshView()
    self.listview_poy = ListView_legion_number:getInnerContainer():getPositionY() 
end

function UnionFightingLeftUnionTeam:onUpdate( dt )
    local root = self.roots[1]
    if root == nil then
        return
    end
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

function UnionFightingLeftUnionTeam:onInit(params)
    local csbNode = csb.createNode(config_csb.big_map.map_legion_battle_player_1)
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    local action = csb.createTimeline(config_csb.big_map.map_legion_battle_player_1)
    table.insert(self.actions, action)

    csbNode:runAction(action)

    self:changeReportState()

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_field_2"), nil, 
    {
        terminal_name = "union_fighting_left_union_team_change_state", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, 
    nil, 0)

    self:updateDraw(params)
end

function UnionFightingLeftUnionTeam:onEnterTransitionFinish()

end

function UnionFightingLeftUnionTeam:init(params)
    self:onInit(params)
    return self
end

function UnionFightingLeftUnionTeam:onExit()
    state_machine.remove("union_fighting_left_union_team_change_state")
    state_machine.remove("union_fighting_left_union_team_update_info")
end
