-- ------------------------------------------------------------------------------------------------------------
--  说明：守卫战战场增益
-- ------------------------------------------------------------------------------------------------------------
GuardBattleGain = class("GuardBattleGainClass", Window)

--打开界面
local guard_battle_gain_window_open_terminal = {
    _name = "guard_battle_gain_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("GuardBattleGainClass") == nil then
            fwin:open(GuardBattleGain:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local guard_battle_gain_window_close_terminal = {
    _name = "guard_battle_gain_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("GuardBattleGainClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(guard_battle_gain_window_open_terminal)
state_machine.add(guard_battle_gain_window_close_terminal)
state_machine.init()

function GuardBattleGain:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    local function init_guard_battle_gain_terminal()
        local guard_battle_gain_show_terminal = {
            _name = "guard_battle_gain_show",
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

        local guard_battle_gain_hide_terminal = {
            _name = "guard_battle_gain_hide",
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

        local guard_battle_gain_update_draw_terminal = {
            _name = "guard_battle_gain_update_draw",
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

        state_machine.add(guard_battle_gain_show_terminal)
        state_machine.add(guard_battle_gain_hide_terminal)
        state_machine.add(guard_battle_gain_update_draw_terminal)
        state_machine.init()
    end
    init_guard_battle_gain_terminal()
end

function GuardBattleGain:onUpdateDraw()
    local root = self.roots[1]

    local ListView_guard_battle_gain = ccui.Helper:seekWidgetByName(root, "ListView_guard_battle_gain")
    self._list_view = ListView_guard_battle_gain
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    for i = 1, dms.count(dms["guard_buff"]) do
        local cell = state_machine.excute("guard_battle_gain_cell_create", 0, {i})
        self._list_view:addChild(cell)
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()
end

function GuardBattleGain:onUpdate(dt)
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

function GuardBattleGain:onInit()
    local csbItem = csb.createNode(config_csb.campaign.guard_battle_gain)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guard_battle_gain_close"), nil, 
    {
        terminal_name = "guard_battle_gain_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self:onUpdateDraw()
end

function GuardBattleGain:init()
    self:onInit()
    return self
end

function GuardBattleGain:onExit()
    state_machine.remove("guard_battle_gain_show")
    state_machine.remove("guard_battle_gain_hide")
    state_machine.remove("guard_battle_gain_update_draw")
end