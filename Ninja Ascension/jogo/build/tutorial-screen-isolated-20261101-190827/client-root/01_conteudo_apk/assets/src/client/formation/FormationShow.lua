--[[ ----------------------------------------------------------------------------
-- 阵容推荐角色展示
--]] ----------------------------------------------------------------------------
FormationShow = class("FormationShowClass", Window)

-- 打开窗口
local formation_show_window_open_terminal = {
    _name = "formation_show_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("FormationShowClass") then
            fwin:open(FormationShow:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local formation_show_window_close_terminal = {
    _name = "formation_show_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("FormationShowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(formation_show_window_open_terminal)
state_machine.add(formation_show_window_close_terminal)
state_machine.init()

-- 构造器
function FormationShow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._ship_list = {}
    -- load lua files.
    app.load("client.cells.formation.formation_show_cell")

    -- Initialize formation show page state machine.
    local function init_formation_show_terminal()
    end
    -- call func init formation show state machine.
    init_formation_show_terminal()
end

function FormationShow:onUpdateDraw()
    local root = self.roots[1]
    -- 角色
    for i, v in ipairs(self._ship_list) do
        local Panel_no = ccui.Helper:seekWidgetByName(root, "Panel_no_" .. v.shipPos)
        Panel_no:removeAllChildren(true)
        local cell = state_machine.excute("formation_show_cell_create", 0, {mShipData = v})
        Panel_no:addChild(cell)
    end
end

function FormationShow:drawBtn()
	local root = self.roots[1]
	fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_close"),
        nil,
        {
            terminal_name = "formation_show_window_close",
            terminal_state = 0,
            card_list = self._card_list,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
end

function FormationShow:onEnterTransitionFinish()
    local csbNode = csb.createNode("packs/HeroStorage/generals_team_formation.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

	self:onUpdateDraw()
	self:drawBtn()
end


-- 对象初始化
function FormationShow:init(params)
    self._ship_list = params.mShipList
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function FormationShow:onExit()
end

function FormationShow:close()
end

function FormationShow:destroy(window)
end
