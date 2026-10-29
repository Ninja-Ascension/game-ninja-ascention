--[[ ----------------------------------------------------------------------------
-- 战报界面列表
--]] ----------------------------------------------------------------------------
SmBattleReportCell = class("SmBattleReportCellClass", Window)
SmBattleReportCell.__size = nil

-- 创建Cell实例
local sm_battle_report_cell_create_terminal = {
    _name = "sm_battle_report_cell_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if SmBattleReportCell then
            local cell = SmBattleReportCell:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_battle_report_cell_create_terminal)
state_machine.init()

-- 构造器
function SmBattleReportCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._report_info = nil
    self._show_type = 1 -- 伤害:1 承伤:2 治疗:3
    self._show_percent = 0 -- 占比
    -- load lua files.

    -- Initialize sm battle report cell page state machine.
    local function init_sm_battle_report_cell_terminal()
    end
    -- call func init sm battle report cell state machine.
    init_sm_battle_report_cell_terminal()
end

-- 对象初始化
function SmBattleReportCell:init(params)
    self._report_info = params.report_info
    self._show_type = params.show_type
    self._show_percent = params.show_percent
    self:onInit(params)
    self:setContentSize(SmBattleReportCell.__size)
    return self
end

function SmBattleReportCell:onUpdateDraw()
    local root = self.roots[1]
    -- 角色图片容器
    local Panel_role_hero = ccui.Helper:seekWidgetByName(root, "Panel_role_hero")
    Panel_role_hero:removeAllChildren(true)
    local Panel_role_animal = ccui.Helper:seekWidgetByName(root, "Panel_role_animal")
    Panel_role_animal:removeAllChildren(true)
    if self._report_info.pos <= 6 then
        local cell = HeroIconListCell:createCell()
        cell:init(self._report_info.fightObj, nil, false, nil, false)
        Panel_role_hero:addChild(cell)
    else
        local cell = DrawHandle.drawIcon({72, self._report_info.fightObj[1], 1, self._report_info.fightObj[2]})
        Panel_role_animal:addChild(cell)
    end

    -- 数值文本
    local num = 0
    if self._show_type == SmBattleReportWindow.SHOWTYPE.DAMAGE then
        num = self._report_info.damage
    elseif self._show_type == SmBattleReportWindow.SHOWTYPE.INJURED then
        num = self._report_info.injured
    elseif self._show_type == SmBattleReportWindow.SHOWTYPE.CURE then
        num = self._report_info.cure
    end
    local Text_data = ccui.Helper:seekWidgetByName(root, "Text_data")
    Text_data:setString(num .. "")

    -- 进度条容器
    for i = 1, 3 do
        local Panel_loding = ccui.Helper:seekWidgetByName(root, "Panel_mask_" .. i)
        local Image_type = ccui.Helper:seekWidgetByName(root, "Image_type_" .. i)
        local LoadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_"..i)
        if self._show_type == i then
            Panel_loding:setVisible(true)
            Image_type:setVisible(true)
            LoadingBar:setVisible(true)
        else
            Panel_loding:setVisible(false)
            Image_type:setVisible(false)
            LoadingBar:setVisible(false)
        end
    end
	-- 进度条
    local LoadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_" .. self._show_type)
	LoadingBar:setPercent(self._show_percent)
	-- 进度占比文本
    local Text_progress = ccui.Helper:seekWidgetByName(root, "Text_progress")
    Text_progress:setString(self._show_percent .. "%")
end

function SmBattleReportCell:onEnterTransitionFinish()
end

function SmBattleReportCell:onInit(params)
    local root = cacher.createUIRef("battle/sm_battle_damage_detail_formation_cell.csb", "root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if SmBattleReportCell.__size == nil then
        SmBattleReportCell.__size = root:getContentSize()
    end
    self:clearUIInfo()
    self:onUpdateDraw()
end

function SmBattleReportCell:onExit()
    -- 释放SmBattleReportCellWindow界面资源.
    self:clearUIInfo()
    -- [[ 释放缓存
    local root = self.roots[1]
    cacher.freeRef("battle/sm_battle_damage_detail_formation_cell.csb", root)
    -- ]]
end

function SmBattleReportCell:clearUIInfo(...)
    local root = self.roots[1]
    if root ~= nil then
        local Text_progress = ccui.Helper:seekWidgetByName(root, "Text_progress")
        Text_progress:setString("")
        for i = 1, 3 do
            local Panel_loding = ccui.Helper:seekWidgetByName(root, "Panel_mask_" .. i)
            Panel_loding:setVisible(false)
            local Image_type = ccui.Helper:seekWidgetByName(root, "Image_type_" .. i)
            Image_type:setVisible(false)
            local LoadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_"..i)
            LoadingBar:setVisible(false)
            LoadingBar:setPercent(0)
        end
    end
end

-- ~END
-- ----------------------------------------------------------------------------
