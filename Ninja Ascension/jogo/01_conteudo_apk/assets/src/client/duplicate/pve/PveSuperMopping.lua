--[[ ----------------------------------------------------------------------------
-- Pve超级扫荡主界面
--]] ----------------------------------------------------------------------------
PveSuperMopping = class("PveSuperMoppingClass", Window)

-- 打开窗口
local pve_super_mopping_open_terminal = {
    _name = "pve_super_mopping_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("PveSuperMoppingClass") then
            fwin:open(PveSuperMopping:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local pve_super_mopping_close_terminal = {
    _name = "pve_super_mopping_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PveSuperMoppingClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pve_super_mopping_open_terminal)
state_machine.add(pve_super_mopping_close_terminal)
state_machine.init()

-- 构造器
function PveSuperMopping:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    ------------------------------------------------------------------------ var------------------------------------------------------------------------
    -- {
    --     current_chapter_id = number,
    --     npc_star = number[],
    --     npc_id = number[]
    -- }[]
    self.datas = {}

    -- {
    --     current_chapter_id = number,
    --     npc_info = {
    --         npc_star = number[],
    --         npc_id = number[]
    --                 }
    --
    -- }[]
    self.item_infos = {}

    ------------------------------------------------------------------ load lua files-------------------------------------------------------------------
    app.load("client.cells.duplicate.pve_super_mopping_cell")

    ------------------------------------------------- Initialize summer drink cell page state machine---------------------------------------------------
    local function init_pve_super_mopping_terminal()
    end

    ------------------------------------------------- call func init user return window state machine---------------------------------------------------
    init_pve_super_mopping_terminal()
end

-- 对象初始化
function PveSuperMopping:init(datas)
    if #datas > 0 then
        self.datas = datas
    end
    return self
end

function PveSuperMopping:onUpdateDraw()
    local root = self.roots[1]

    -- 关闭冲突的交互层
    self.Panel_1217 = ccui.Helper:seekWidgetByName(root, "Panel_1217")
    self.Panel_1217:setTouchEnabled(false)

    -- 创建列表
    self.item_infos = {}
    local listView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_4")
    listView:removeAllItems()
    if self.datas ~= nil and #self.datas > 0 then
        for i = 1, #self.datas do
            table.insert(self.item_infos, {current_chapter_id = self.datas[i].current_chapter_id, npc_info = {npc_stars = self.datas[i].npc_star, npc_ids = self.datas[i].npc_id}})
        end

        self:asyncCreateItem()
    end
end

function PveSuperMopping:createCell(current_chapter_id, npc_info)
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_4")
    local cell = PveSuperMoppingCell:createCell()
    cell:init(current_chapter_id, npc_info)
    listView:addChild(cell)
    listView:requestRefreshView()
end

function PveSuperMopping:asyncCreateItem()
    local temp_info_items = self.item_infos
    local length = #self.item_infos
    self:stopAllActions()
    self:runAction(
        cc.Sequence:create(
            {
                cc.DelayTime:create(0.01),
                cc.CallFunc:create(
                    function(sender)
                        if (length > 0) then
                            local cell_info = temp_info_items[1]
                            length = length - 1
                            table.remove(self.item_infos, 1)
                            self:createCell(cell_info.current_chapter_id, cell_info.npc_info)
                        end

                        if (length > 0) then
                            self:asyncCreateItem()
                        end
                    end
                )
            }
        )
    )
end

function PveSuperMopping:buttonAddClickEvent()
    -- 关闭按钮
    local root = self.roots[1]
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_tap_exit"),
        nil,
        {
            terminal_name = "pve_super_mopping_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
end

function PveSuperMopping:onEnterTransitionFinish()
    -- 加载PveSuperMopping界面资源.
    local csbNode = csb.createNode("duplicate/pve_super_mopping.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    self:onUpdateDraw()
    self:buttonAddClickEvent()
end

function PveSuperMopping:onUpdate(dt)
end

function PveSuperMopping:onExit()
end

function PveSuperMopping:close()
end

function PveSuperMopping:destroy(window)
end

-- ~END
-- ----------------------------------------------------------------------------
