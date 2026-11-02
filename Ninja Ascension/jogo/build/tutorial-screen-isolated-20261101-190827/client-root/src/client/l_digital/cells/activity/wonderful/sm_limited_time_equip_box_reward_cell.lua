--------------------------------------------------------------------------------------------------------------
--  说明：限时宝箱奖励cell
--------------------------------------------------------------------------------------------------------------
SmLimitedTimeEquipBoxRewardCell = class("SmLimitedTimeEquipBoxRewardCellClass", Window)
SmLimitedTimeEquipBoxRewardCell.__size = nil

--创建cell
local sm_limited_time_equip_box_reward_cell_create_terminal = {
    _name = "sm_limited_time_equip_box_reward_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmLimitedTimeEquipBoxRewardCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_limited_time_equip_box_reward_cell_create_terminal)
state_machine.init()

function SmLimitedTimeEquipBoxRewardCell:ctor()
	self.super:ctor()
	self.roots = {}

    self._info = nil
    self._activity_type = 0

	 -- Initialize sm_limited_time_equip_box_reward_cell state machine.
    local function init_sm_limited_time_equip_box_reward_cell_terminal()
        local sm_limited_time_equip_box_reward_cell_look_reward_terminal = {
            _name = "sm_limited_time_equip_box_reward_cell_look_reward",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                state_machine.excute("sm_limited_time_equip_box_window_open", 0, {cell._activity_type, cell._info})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_limited_time_equip_box_reward_cell_look_reward_terminal)
        state_machine.init()
    end 
    -- call func sm_limited_time_equip_box_reward_cell create state machine.
    init_sm_limited_time_equip_box_reward_cell_terminal()

end

function SmLimitedTimeEquipBoxRewardCell:updateDraw()
    local root = self.roots[1]

    local activity_info = _ED.active_activity[self._activity_type]
    local activity_params = zstring.split(activity_info.activity_params, "!")

    local Text_jf = ccui.Helper:seekWidgetByName(root, "Text_jf")
    Text_jf:setString(self._info.activityInfo_need_day)

    local Panel_o_3 = ccui.Helper:seekWidgetByName(root, "Panel_o_3")
    local Panel_r_3 = ccui.Helper:seekWidgetByName(root, "Panel_r_3")
    local Panel_c_3 = ccui.Helper:seekWidgetByName(root, "Panel_c_3")

    Panel_o_3:setVisible(false)
    Panel_r_3:setVisible(false)
    Panel_c_3:setVisible(false)

    local current_score = tonumber(zstring.split(activity_params[1], ",")[2])             -- 当前积分
    local need_score = tonumber(self._info.activityInfo_need_day)

    if current_score < need_score then
        Panel_c_3:setVisible(true)
    elseif tonumber(self._info.activityInfo_isReward) == 0 then
        Panel_r_3:setVisible(true)
    else
        Panel_o_3:setVisible(true)
    end
end


function SmLimitedTimeEquipBoxRewardCell:onInit()
    local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_reward.csb")
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 
    self:addChild(csbItem)
    -- local root = cacher.createUIRef("activity/wonderful/sm_limited_time_equip_box_reward.csb", "root")
    -- table.insert(self.roots, root)
    -- self:addChild(root)

    if SmLimitedTimeEquipBoxRewardCell.__size == nil then
        SmLimitedTimeEquipBoxRewardCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_15612"), nil, 
    {
        terminal_name = "sm_limited_time_equip_box_reward_cell_look_reward", 
        terminal_state = 0, 
        cell = self,
    }, nil, 1)

	self:updateDraw()
end

function SmLimitedTimeEquipBoxRewardCell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function SmLimitedTimeEquipBoxRewardCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_jf = ccui.Helper:seekWidgetByName(root, "Text_jf")
    if Text_jf ~= nil then
        Text_jf:setString("")
    end
end

function SmLimitedTimeEquipBoxRewardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function SmLimitedTimeEquipBoxRewardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/sm_limited_time_equip_box_reward.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function SmLimitedTimeEquipBoxRewardCell:init(params)
    self._activity_type = params[1]
    self._info = params[2]
	self:onInit()
    self:setContentSize(SmLimitedTimeEquipBoxRewardCell.__size)
    return self
end

function SmLimitedTimeEquipBoxRewardCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/sm_limited_time_equip_box_reward.csb", self.roots[1])
end