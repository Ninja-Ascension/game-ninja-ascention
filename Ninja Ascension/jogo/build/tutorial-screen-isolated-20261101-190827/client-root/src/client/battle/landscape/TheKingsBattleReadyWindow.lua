-- ----------------------------------------------------------------------------------
-- 王者之战的准备窗口
-- ----------------------------------------------------------------------------------
TheKingsBattleReadyWindow= class("TheKingsBattleReadyWindowClass", Window)

local the_kings_battle_ready_window_open_terminal = {
    _name = "the_kings_battle_ready_window_open",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("the_kings_battle_ready_window_close", 0, 0)
        local window = TheKingsBattleReadyWindow:new():init(params)
        fwin:open(window, fwin._dialog)
        return window
    end,
    _terminal = nil,
    _terminals = nil
}

local the_kings_battle_ready_window_close_terminal = {
    _name = "the_kings_battle_ready_window_close",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TheKingsBattleReadyWindowClass"))
        return window
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(the_kings_battle_ready_window_open_terminal)
state_machine.add(the_kings_battle_ready_window_close_terminal)
state_machine.init()

function TheKingsBattleReadyWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
    -- load lua file

    -- var
    self._count = 1
    self._map_index = 1

    -- Initialize the kings battle window state machine.
    local function init_the_kings_battle_ready_window_terminal()

        state_machine.init()
    end

    -- call func init the kings battle window state machine.
    init_the_kings_battle_ready_window_terminal()
end

function TheKingsBattleReadyWindow:init(params)
    self._count = params
    self._map_index = 1
    if self._count > 1 then
        self._map_index = 2
    end
    return self
end

function TheKingsBattleReadyWindow:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/BattleofKings/battle_of_kings_battle_ready_" .. self._map_index .. ".csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    local action = csb.createTimeline("campaign/BattleofKings/battle_of_kings_battle_ready_" .. self._map_index .. ".csb")
    table.insert(self.actions, action)
    csbNode:runAction(action)

    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "over" then
            state_machine.excute("the_kings_battle_ready_window_close", 0, 0);
            state_machine.excute("battle_resume", 0, 0)

            -- state_machine.excute("fight_ui_visible", 0, false)
            local fightUI = fwin:find("FightUIClass")
            fightUI:setPositionX(10000)

            local fightTeamController = fwin:find("FightTeamControllerClass")
            fightTeamController:setPositionX(10000)

            local FightQTEController = fwin:find("FightQTEControllerClass")
            FightQTEController:setPositionX(10000)

            app.load("client.battle.landscape.TheKingsBattleUIWindow")
            state_machine.excute("the_kings_battle_ui_window_open", 0, 0);
        end
    end)

    action:play("in", false)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)

    if 1 == self._map_index then
        local Panel_left_digimon = ccui.Helper:seekWidgetByName(root, "Panel_left_digimon")
        for i, v in pairs(_ED.battleData._heros) do
            Panel_left_digimon:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", v._head))
            break
        end

        local Panel_right_digimon = ccui.Helper:seekWidgetByName(root, "Panel_right_digimon")
        for i, v in pairs(_ED.battleData._armys[1]._data) do
            Panel_right_digimon:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", v._head))
            break
        end
    else
        local attackers = {}
        local defenders = {}
        for i, v in pairs(_ED.battleData._heros) do
            table.insert(attackers, v)
        end

        if _ED.battleData.__heros then
            for i, v in pairs(_ED.battleData.__heros) do
                table.insert(attackers, v)
            end
        end
        
        for i, v in pairs(_ED.battleData._armys[1]._data) do
            table.insert(defenders, v)
        end

        if _ED.battleData._armys[1].__data then
            for i, v in pairs(_ED.battleData._armys[1].__data) do
                table.insert(defenders, v)
            end
        end

        local drawIndex = 1
        for i, v in pairs(attackers) do
            local Panel_left_digimon = ccui.Helper:seekWidgetByName(root, "Panel_left_digimon_" .. drawIndex)
            local cellNode = csb.createNode("campaign/BattleofKings/battle_of_kings_battle_ready_cell.csb")
            local cellRoot = cellNode:getChildByName("root")
            local Image_bg_1 = ccui.Helper:seekWidgetByName(cellRoot, "Image_bg_1")
            Image_bg_1:setVisible(true)
            local Panel_digimon_icon_1 = ccui.Helper:seekWidgetByName(cellRoot, "Panel_digimon_icon_1")
            Panel_digimon_icon_1:setBackGroundImage(string.format("images/ui/pve_sn/props_%d.png", v._head))
            Panel_left_digimon:addChild(cellNode)
            drawIndex = drawIndex + 1
            if drawIndex > 3 then
                break
            end
        end

        drawIndex = 1
        for i, v in pairs(defenders) do
            local Panel_right_digimon = ccui.Helper:seekWidgetByName(root, "Panel_right_digimon_" .. drawIndex)
            local cellNode = csb.createNode("campaign/BattleofKings/battle_of_kings_battle_ready_cell.csb")
            local cellRoot = cellNode:getChildByName("root")
            local Image_bg_2 = ccui.Helper:seekWidgetByName(cellRoot, "Image_bg_2")
            Image_bg_2:setVisible(true)
            local Panel_digimon_icon_2 = ccui.Helper:seekWidgetByName(cellRoot, "Panel_digimon_icon_2")
            Panel_digimon_icon_2:setBackGroundImage(string.format("images/ui/pve_sn/props_%d.png", v._head))
            Panel_right_digimon:addChild(cellNode)
            drawIndex = drawIndex + 1
            if drawIndex > 3 then
                break
            end
        end
    end
end

function TheKingsBattleReadyWindow:onExit()
    
end
