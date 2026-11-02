--------------------------------------------------------------------------------------------------------------
--  说明：限时宝箱积分排名cell
--------------------------------------------------------------------------------------------------------------
SmLimitedTimeEquipBoxRankCell = class("SmLimitedTimeEquipBoxRankCellClass", Window)
SmLimitedTimeEquipBoxRankCell.__size = nil

--创建cell
local sm_limited_time_equip_box_rank_cell_create_terminal = {
    _name = "sm_limited_time_equip_box_rank_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmLimitedTimeEquipBoxRankCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_limited_time_equip_box_rank_cell_create_terminal)
state_machine.init()

function SmLimitedTimeEquipBoxRankCell:ctor()
	self.super:ctor()
	self.roots = {}

    self._info = nil

	 -- Initialize sm_limited_time_equip_box_rank_cell state machine.
    local function init_sm_limited_time_equip_box_rank_cell_terminal()

    end 
    -- call func sm_limited_time_equip_box_rank_cell create state machine.
    init_sm_limited_time_equip_box_rank_cell_terminal()
end

function SmLimitedTimeEquipBoxRankCell:updateDraw()
    local root = self.roots[1]
    local Text_pm = ccui.Helper:seekWidgetByName(root, "Text_pm")
    local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
    local Text_jf = ccui.Helper:seekWidgetByName(root, "Text_jf")

    Text_pm:setString(self._info.rank)
    Text_name:setString(self._info.name)
    Text_jf:setString(self._info.integral)
end

function SmLimitedTimeEquipBoxRankCell:onInit()
    local root = cacher.createUIRef("activity/wonderful/sm_limited_time_equip_box_rank_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmLimitedTimeEquipBoxRankCell.__size == nil then
        SmLimitedTimeEquipBoxRankCell.__size = root:getContentSize()
    end

	self:updateDraw()
end

function SmLimitedTimeEquipBoxRankCell:onEnterTransitionFinish()

end

function SmLimitedTimeEquipBoxRankCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_pm = ccui.Helper:seekWidgetByName(root, "Text_pm")
    local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
    local Text_jf = ccui.Helper:seekWidgetByName(root, "Text_jf")

    if Text_pm ~= nil then
        Text_pm:setString("")
        Text_name:setString("")
        Text_jf:setString("")
    end
end

function SmLimitedTimeEquipBoxRankCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function SmLimitedTimeEquipBoxRankCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/sm_limited_time_equip_box_rank_list.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function SmLimitedTimeEquipBoxRankCell:init(params)
    self._index = params[1]
    self._info = params[2]
    -- if self._index <= 5 then
	   --  self:onInit()
    -- end

    self:onInit()
    self:setContentSize(SmLimitedTimeEquipBoxRankCell.__size)
    return self
end

function SmLimitedTimeEquipBoxRankCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/sm_limited_time_equip_box_rank_list.csb", self.roots[1])
end