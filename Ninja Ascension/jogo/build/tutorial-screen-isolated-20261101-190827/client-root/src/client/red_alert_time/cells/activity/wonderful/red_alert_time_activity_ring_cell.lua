--------------------------------------------------------------------------------------------------------------
--  说明：活动排行的cell
--------------------------------------------------------------------------------------------------------------
RedAlerTimeActivityRingCell = class("RedAlerTimeActivityRingCellClass", Window)
RedAlerTimeActivityRingCell.__size = nil

--创建cell
local red_alert_time_activity_ring_cell_terminal = {
    _name = "red_alert_time_activity_ring_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlerTimeActivityRingCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_activity_ring_cell_terminal)
state_machine.init()

function RedAlerTimeActivityRingCell:ctor()
	self.super:ctor()
	self.roots = {}
	self._activity_type = nil
	self.a_type = 0
end

function RedAlerTimeActivityRingCell:updateDraw()
    local root = self.roots[1]
    local Text_act_rank_n = ccui.Helper:seekWidgetByName(root,"Text_act_rank_n")
    local Text_act_rank_type_n_1 = ccui.Helper:seekWidgetByName(root,"Text_act_rank_type_n_1")
    local Text_act_rank_type_n_2 = ccui.Helper:seekWidgetByName(root,"Text_act_rank_type_n_2")
    if self.data_id == 52 then
        Text_act_rank_n:setString(self._datas.user_rank)
        Text_act_rank_type_n_1:setString(self._datas.user_name)
        Text_act_rank_type_n_2:setString(exChangeNumToString(self._datas.user_fight))
    elseif self.data_id == 53 then
        Text_act_rank_n:setString(self._datas.user_rank)
        Text_act_rank_type_n_1:setString(self._datas.user_name)
        Text_act_rank_type_n_2:setString(self._datas.npc_count)
    elseif self.data_id == 51 then        -- 军团等级
        Text_act_rank_n:setString(self._datas.union_rank)
        Text_act_rank_type_n_1:setString(self._datas.union_name)
        Text_act_rank_type_n_2:setString(self._datas.union_level)
    elseif self.data_id == 69 then        -- 军团贡献
        Text_act_rank_n:setString(self._datas.union_rank)
        Text_act_rank_type_n_1:setString(self._datas.union_name)
        Text_act_rank_type_n_2:setString(exChangeNumToString(self._datas.union_contribution))
    elseif self.data_id == 66 then        -- 军团战力
        Text_act_rank_n:setString(self._datas.union_rank)
        Text_act_rank_type_n_1:setString(self._datas.union_name)
        Text_act_rank_type_n_2:setString(exChangeNumToString(self._datas.union_fight))
    elseif self.data_id == 73 then    
        Text_act_rank_n:setString(self._datas.index)
        Text_act_rank_type_n_1:setString(self._datas.name)
        Text_act_rank_type_n_2:setString(exChangeNumToString(self._datas.c_break))
    elseif self.data_id == 93 then    
        Text_act_rank_n:setString(self._datas.union_rank)
        Text_act_rank_type_n_1:setString(self._datas.union_name)
        Text_act_rank_type_n_2:setString(exChangeNumToString(self._datas.union_fight))
    elseif self.data_id == 120 
        or self.data_id == 123
        then    
        Text_act_rank_n:setString(self._datas.rank)
        Text_act_rank_type_n_1:setString(self._datas.name)
        Text_act_rank_type_n_2:setString(exChangeNumToString(self._datas.gold))
    end
end

function RedAlerTimeActivityRingCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.wonderful.act_rank_window_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlerTimeActivityRingCell.__size == nil then
        RedAlerTimeActivityRingCell.__size = root:getContentSize()
    end

	--领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_act_share_buy"), nil, 
    {
        terminal_name = "red_alert_time_activity_ring_cell_receive_award", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
		cells = self
    }, nil, 1)

	self:updateDraw()

end

function RedAlerTimeActivityRingCell:onEnterTransitionFinish()

end

function RedAlerTimeActivityRingCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_act_rank_n = ccui.Helper:seekWidgetByName(root,"Text_act_rank_n")
    local Text_act_rank_type_n_1 = ccui.Helper:seekWidgetByName(root,"Text_act_rank_type_n_1")
    local Text_act_rank_type_n_2 = ccui.Helper:seekWidgetByName(root,"Text_act_rank_type_n_2")
    if self.Text_act_rank_n ~= nil then
        Text_act_rank_n:setString("")
        Text_act_rank_type_n_1:setString("")
        Text_act_rank_type_n_2:setString("")
    end
end

function RedAlerTimeActivityRingCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function RedAlerTimeActivityRingCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.wonderful.act_rank_window_cell, root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlerTimeActivityRingCell:init(params)
    self._datas = params[1]
    self.data_id = tonumber(params[2])
    local index = params[3]
    if index ~= nil and index <= 10 then
        self:onInit()
    end
    self:setContentSize(RedAlerTimeActivityRingCell.__size)
    return self
end

function RedAlerTimeActivityRingCell:onExit()
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.wonderful.act_rank_window_cell, self.roots[1])
end