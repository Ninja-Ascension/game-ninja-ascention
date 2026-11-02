-- ------------------------------------------------------------------------------------------------------------
--  说明：坦克拉霸奖励详情cell
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeTankDrawRewardCell = class("RedAlertTimeTankDrawRewardCellClass", Window)
RedAlertTimeTankDrawRewardCell.__size = nil

--创建cell
local red_alert_time_tank_draw_reward_cell_create_terminal = {
    _name = "red_alert_time_tank_draw_reward_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeTankDrawRewardCell:new()
        local index = params[1]
        local activity_data = params[2]
        cell:init(index, activity_data)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_tank_draw_reward_cell_create_terminal)
state_machine.init()

function RedAlertTimeTankDrawRewardCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._activity_data = nil
    self._index = 0 
    local function init_red_alert_time_tank_draw_reward_cell_terminal()

    end
    init_red_alert_time_tank_draw_reward_cell_terminal()
end

function RedAlertTimeTankDrawRewardCell:updateDraw()
    local root = self.roots[1]
    local Panel_tank_draw_reward_4 = ccui.Helper:seekWidgetByName(root, "Panel_tank_draw_reward_4")
    Panel_tank_draw_reward_4:removeAllChildren(true)
    local info = zstring.split(self._activity_data.achieve_reward, ",")
    local prop_id = tonumber(info[1])
    local prop_count = tonumber(info[3])
    local cell = state_machine.excute("props_icon_create_cell",0,{3, 10, prop_id, 3, prop_count})
    Panel_tank_draw_reward_4:addChild(cell)

    local other_info = zstring.split(self._activity_data.achieve_other_info,",")
    for i=1,#other_info do
        local Panel_tank_draw_reward = ccui.Helper:seekWidgetByName(root, "Panel_tank_draw_reward_"..i)
        Panel_tank_draw_reward:removeAllChildren(true)
        local cell = state_machine.excute("props_icon_create_cell",0,{1, 3, other_info[i], 3})
        Panel_tank_draw_reward:addChild(cell)
    end
end

function RedAlertTimeTankDrawRewardCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.tank_draw_reward_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeTankDrawRewardCell.__size == nil then
        RedAlertTimeTankDrawRewardCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function RedAlertTimeTankDrawRewardCell:onEnterTransitionFinish()

end

function RedAlertTimeTankDrawRewardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlertTimeTankDrawRewardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.tank_draw_reward_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeTankDrawRewardCell:clearUIInfo()
    local root = self.roots[1]
    for i=1,4 do
        local Panel_tank_draw_reward = ccui.Helper:seekWidgetByName(root, "Panel_tank_draw_reward_"..i)
        if Panel_tank_draw_reward ~=nil then
            Panel_tank_draw_reward:removeAllChildren(true)
        end
    end
end

function RedAlertTimeTankDrawRewardCell:init(index, activity_data)
    self._index = index 
    self._activity_data = activity_data
    if index ~= nil and index <= 5 then
        self:onInit()
    end
    self:setContentSize(RedAlertTimeTankDrawRewardCell.__size)
    return self
end

function RedAlertTimeTankDrawRewardCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.tank_draw_reward_cell, self.roots[1])
end

