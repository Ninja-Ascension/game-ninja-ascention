--------------------------------------------------------------------------------------------------------------
--  常规战令阶段按钮
--------------------------------------------------------------------------------------------------------------
CommonOrderStageTab = class("CommonOrderStageTabClass", Window)
CommonOrderStageTab.__size = nil

-- 创建cell
local common_order_stage_tab_window_tab_cell_create_terminal = {
    _name = "common_order_stage_tab_window_tab_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = CommonOrderStageTab:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(common_order_stage_tab_window_tab_cell_create_terminal)
state_machine.init()

function CommonOrderStageTab:ctor()
    self.super:ctor()
    self.roots = {}

    self.stage = 0

    -- 初始化状态机
    local function init_common_order_stage_tab_window_tab_cell_terminal()

    end 
    init_common_order_stage_tab_window_tab_cell_terminal()

end

function CommonOrderStageTab:updateDraw()
    self.Text_stage:setString(string.format(war_order_str[5], self.stage))
end

function CommonOrderStageTab:onInit()
    local root = cacher.createUIRef("activity/passport/passport_main_changgui_cell_0.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if CommonOrderStageTab.__size == nil then
        CommonOrderStageTab.__size = root:getContentSize()
    end
    -- 当前阶段文本
    self.Text_stage = ccui.Helper:seekWidgetByName(root, "Text_1")
    -- 阶段按钮
    self.Button_stage = ccui.Helper:seekWidgetByName(root, "Button_1")

    self:updateDraw()
end

function CommonOrderStageTab:onEnterTransitionFinish()
    local root = self.roots[1]
end

function CommonOrderStageTab:init(params)
    self.stage = params.stage
    self:onInit()
    self:setContentSize(CommonOrderStageTab.__size)
    return self
end

function CommonOrderStageTab:onExit()
    cacher.freeRef("activity/passport/passport_main_changgui_cell_0.csb", self.roots[1])
end