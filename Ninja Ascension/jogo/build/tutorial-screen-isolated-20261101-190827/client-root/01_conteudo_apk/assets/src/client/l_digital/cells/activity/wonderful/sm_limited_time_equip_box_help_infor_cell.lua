--------------------------------------------------------------------------------------------------------------
--  说明：限时宝箱规则说明cell
--------------------------------------------------------------------------------------------------------------
SmLimitedTimeEquipBoxHelpInforCell = class("SmLimitedTimeEquipBoxHelpInforCellClass", Window)
SmLimitedTimeEquipBoxHelpInforCell.__size = nil

--创建cell
local sm_limited_time_equip_box_help_infor_cell_create_terminal = {
    _name = "sm_limited_time_equip_box_help_infor_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmLimitedTimeEquipBoxHelpInforCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_limited_time_equip_box_help_infor_cell_create_terminal)
state_machine.init()

function SmLimitedTimeEquipBoxHelpInforCell:ctor()
	self.super:ctor()
	self.roots = {}

    self._info = nil

	 -- Initialize sm_limited_time_equip_box_help_infor_cell state machine.
    local function init_sm_limited_time_equip_box_help_infor_cell_terminal()

    end 
    -- call func sm_limited_time_equip_box_help_infor_cell create state machine.
    init_sm_limited_time_equip_box_help_infor_cell_terminal()

end

function SmLimitedTimeEquipBoxHelpInforCell:updateDraw()
    local root = self.roots[1]
    local activity_info = _ED.active_activity[89]
    local activity_params = zstring.split(activity_info.activity_params, "!")
    -- 显示排行需要积分
    local activity_rank_need_infos = zstring.split(activity_params[3], "%$")
    for i,v in ipairs(activity_rank_need_infos) do 
        local needNum = zstring.split(v,":")[3]
        local Text_tips = ccui.Helper:seekWidgetByName(root, "Text_tips_"..i) 
        if Text_tips then 
            Text_tips:setString(needNum)
        end
    end
end


function SmLimitedTimeEquipBoxHelpInforCell:onInit()
    local root = cacher.createUIRef("activity/wonderful/sm_limited_time_equip_box_help_list_1.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmLimitedTimeEquipBoxHelpInforCell.__size == nil then
        SmLimitedTimeEquipBoxHelpInforCell.__size = root:getContentSize()
    end

	self:updateDraw()
end

function SmLimitedTimeEquipBoxHelpInforCell:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function SmLimitedTimeEquipBoxHelpInforCell:clearUIInfo( ... )
    local root = self.roots[1]
end

function SmLimitedTimeEquipBoxHelpInforCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function SmLimitedTimeEquipBoxHelpInforCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/sm_limited_time_equip_box_help_list_1.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function SmLimitedTimeEquipBoxHelpInforCell:init(params)
    self._info = params[1]
	self:onInit()
    self:setContentSize(SmLimitedTimeEquipBoxHelpInforCell.__size)
    return self
end

function SmLimitedTimeEquipBoxHelpInforCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/sm_limited_time_equip_box_help_list_1.csb", self.roots[1])
end