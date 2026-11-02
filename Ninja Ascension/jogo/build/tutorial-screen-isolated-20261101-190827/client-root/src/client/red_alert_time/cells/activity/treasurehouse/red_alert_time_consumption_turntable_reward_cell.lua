-- ------------------------------------------------------------------------------------------------------------
--  消费转盘积分奖励cell
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeConsumptionTurntableRewardCell = class("RedAlertTimeConsumptionTurntableRewardCellClass", Window)
RedAlertTimeConsumptionTurntableRewardCell.__size = nil

--创建cell
local red_alert_time_consumption_turntable_reward_cell_create_terminal = {
    _name = "red_alert_time_consumption_turntable_reward_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeConsumptionTurntableRewardCell:new()
        local index = params[1]
        local achieve_name = params[2]
        local achieve_reward = params[3]
        cell:init(index, achieve_name, achieve_reward)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_consumption_turntable_reward_cell_create_terminal)
state_machine.init()

function RedAlertTimeConsumptionTurntableRewardCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._achieve_name = nil
    self._index = 0 
    self._achieve_reward = nil 
    local function init_red_alert_time_consumption_turntable_reward_cell_terminal()

    end
    init_red_alert_time_consumption_turntable_reward_cell_terminal()
end

function RedAlertTimeConsumptionTurntableRewardCell:updateDraw()
    local root = self.roots[1]
    local Text_limit_dekarona_reward_rank = ccui.Helper:seekWidgetByName(root, "Text_limit_dekarona_reward_rank")
    local ListView_limit_dekarona_reward = ccui.Helper:seekWidgetByName(root, "ListView_limit_dekarona_reward")
    ListView_limit_dekarona_reward:removeAllItems()
    Text_limit_dekarona_reward_rank:setString(self._achieve_name)

    local reward_info = zstring.split(self._achieve_reward, "|")
    for k, v in pairs(reward_info) do
        local datas = zstring.split(v, ",")
        if tonumber(datas[1]) == -1 then
            datas[1] = resource_prop_id[tonumber(datas[2])]
            datas[2] = 1
        end
        local prop_type = tonumber(datas[2])
        local show_type = 9
        local prop_from_type = 3
        if tonumber(datas[2]) == 13 then --坦克
            prop_type = 3
            prop_from_type = 10
        elseif tonumber(datas[2]) == 6 then --道具    
            prop_type = 1
            prop_from_type = 1
            local pic_index = dms.string(dms["prop_mould"], tonumber(datas[1]), prop_mould.pic_index)
            pic_index = zstring.split(pic_index, ",")
            local prop_name = dms.string(dms["prop_mould"], tonumber(datas[1]), prop_mould.prop_name)
            if tonumber(pic_index[3]) == nil then
                show_type = 6
            end
        elseif tonumber(datas[2]) == 7 then --配件    
            prop_type = 7
            prop_from_type = 4
        else
            prop_type = 1
            prop_from_type = 1
        end
        local cell = nil
        if prop_type == 7 then
            local equip_datas = {}
            equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
            equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
            cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3])})
        else
            cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3])})
        end
		cell.roots[1]:setPositionX(10)
        ListView_limit_dekarona_reward:addChild(cell)
    end
    ListView_limit_dekarona_reward:requestRefreshView()
end

function RedAlertTimeConsumptionTurntableRewardCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.campaign.super_scholar_reward_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeConsumptionTurntableRewardCell.__size == nil then
        RedAlertTimeConsumptionTurntableRewardCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function RedAlertTimeConsumptionTurntableRewardCell:onEnterTransitionFinish()

end

function RedAlertTimeConsumptionTurntableRewardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlertTimeConsumptionTurntableRewardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.super_scholar_reward_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeConsumptionTurntableRewardCell:clearUIInfo( ... )
    local root = self.roots[1]
    local ListView_limit_dekarona_reward = ccui.Helper:seekWidgetByName(root, "ListView_limit_dekarona_reward")
    local Text_limit_dekarona_reward_rank = ccui.Helper:seekWidgetByName(root, "Text_limit_dekarona_reward_rank")
    
    if ListView_limit_dekarona_reward ~=nil then
        ListView_limit_dekarona_reward:removeAllItems()
        Text_limit_dekarona_reward_rank:setString("")
    end
end

function RedAlertTimeConsumptionTurntableRewardCell:init(index, achieve_name, achieve_reward)
    self._index = index 
    self._achieve_name = achieve_name
    self._achieve_reward = achieve_reward 
    if index ~= nil and index <= 5 then
        self:onInit()
    end
    self:setContentSize(RedAlertTimeConsumptionTurntableRewardCell.__size)
    return self
end

function RedAlertTimeConsumptionTurntableRewardCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.super_scholar_reward_cell, self.roots[1])
end

