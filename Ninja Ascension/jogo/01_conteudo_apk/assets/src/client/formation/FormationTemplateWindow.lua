--[[ ----------------------------------------------------------------------------
-- 阵容推荐界面
--]] ----------------------------------------------------------------------------
FormationTemplateWindow = class("FormationTemplateWindowClass", Window)

-- 打开窗口
local formation_template_window_open_terminal = {
    _name = "formation_template_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("FormationTemplateWindowClass") then
            fwin:open(FormationTemplateWindow:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local formation_template_window_close_terminal = {
    _name = "formation_template_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("FormationTemplateWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(formation_template_window_open_terminal)
state_machine.add(formation_template_window_close_terminal)
state_machine.init()

-- 构造器
function FormationTemplateWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._total_info = {} -- 所有阵容信息
    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
    -- load lua files.
    app.load("client.cells.formation.formation_template_cell")
    app.load("client.cells.formation.formation_template_icon_cell")
    app.load("client.formation.FormationTemplateDetail")
    app.load("client.cells.utils.multiple_list_view_cell")
    app.load("client.cells.ship.ship_head_new_cell")
    -- Initialize formation template window page state machine.
    local function init_formation_template_window_terminal()
    end
    -- call func init formation template window state machine.
    init_formation_template_window_terminal()
end

function FormationTemplateWindow:getAllRecommendList()
    local formData = {}
    table.merges(formData,dms["recommendation_formation_mould"])
    -- 排序(从大到小)
    table.sort(
        formData,
        function(a, b)
            local numberA = dms.atoi(a, recommendation_formation_mould.recommend_sort)
            local numberB = dms.atoi(b, recommendation_formation_mould.recommend_sort)
            if numberA > numberB then
                return true
            else
                return false
            end
        end
    )
    self._total_info = formData
end

function FormationTemplateWindow:onUpdate(dt)
    if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
        local size = self.currentListView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.currentListView:getItems()
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

function FormationTemplateWindow:onUpdateDraw()
    local root = self.roots[1]
    -- 队伍列表
    local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
    ListView_1:removeAllItems()
    local index = 1
    for k, v in pairs(self._total_info) do
        local cell = state_machine.excute("formation_template_cell_create", 0, {m_info = v, index = index})
        ListView_1:addChild(cell)
        index = index + 1
    end
    
    self.currentListView = ListView_1
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    ListView_1:requestRefreshView()
    ListView_1:jumpToTop()
end

function FormationTemplateWindow:drawBtn()
    local root = self.roots[1]
    -- 关闭
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_close"),
        nil,
        {
            terminal_name = "formation_template_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
end

function FormationTemplateWindow:onEnterTransitionFinish()
    local csbNode = csb.createNode("packs/HeroStorage/generals_team.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    self:getAllRecommendList()
    self:onUpdateDraw()
    self:drawBtn()
end

-- 对象初始化
function FormationTemplateWindow:init(params)
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function FormationTemplateWindow:onExit()
end

function FormationTemplateWindow:close()
end

function FormationTemplateWindow:destroy(window)
end
