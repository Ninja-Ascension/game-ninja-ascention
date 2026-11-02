-----------------------------
-- 居所战报ListView
-----------------------------
PersonalFightBattleFieldListView = class("PersonalFightBattleFieldListViewClass", Window)

local personal_fighting_battle_field_listview_window_open_terminal = {
    _name = "personal_fighting_battle_field_listview_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = PersonalFightBattleFieldListView:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(personal_fighting_battle_field_listview_window_open_terminal)
state_machine.init()

function PersonalFightBattleFieldListView:ctor()
	self.super:ctor()
	self.roots = {}
    
    self._list_view = nil
    self._list_view_poy = nil
end

function PersonalFightBattleFieldListView:updateDraw(listInfo, chooseState)
    local root = self.roots[1]
    local ListView_26 = ccui.Helper:seekWidgetByName(root,"ListView_26")
    ListView_26:removeAllItems()

    for k,v in pairs(listInfo) do
        local cell = state_machine.excute("personal_fight_battle_field_cell_create_cell", 0, {k, chooseState, v})
        ListView_26:addChild(cell)
    end

    ListView_26:requestRefreshView()
    self._list_view = ListView_26
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
end

function PersonalFightBattleFieldListView:onUpdate(dt)
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

function PersonalFightBattleFieldListView:onInit(listInfo, chooseState)
    local csbItem = csb.createNode(config_csb.big_map.map_rattling_battle_field_listview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:updateDraw(listInfo, chooseState)
end

function PersonalFightBattleFieldListView:onEnterTransitionFinish()
    
end

function PersonalFightBattleFieldListView:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit(params[2], params[3])
    return self
end

function PersonalFightBattleFieldListView:onExit()
   
end