--------------------------------------------------------------------------------------------------------------
--  说明：元宝大转盘宝箱奖励
--------------------------------------------------------------------------------------------------------------
ActiveCostRotaryAllCell = class("ActiveCostRotaryAllCellClass", Window)
ActiveCostRotaryAllCell.__size = nil

local activity_cost_rotary_all_create_cell_terminal = {
    _name = "activity_cost_rotary_all_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local index = params[1]
        local info_data = params[2]
        local index_data = params[3]
        local cell = ActiveCostRotaryAllCell:new()
        cell:init(index, info_data, index_data)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(activity_cost_rotary_all_create_cell_terminal)
state_machine.init()

function ActiveCostRotaryAllCell:ctor()
    self.super:ctor()
    self.roots = {}
    -- 宝箱信息
    self._info_data = nil
    -- 宝箱顺序
    self._index = 0

    local function init_activity_cost_rotary_all_cell_terminal()
        -- 领取
  		local activity_cost_rotary_all_cell_get_reward_terminal = {
            _name = "activity_cost_rotary_all_cell_get_reward",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open", 0, {1037})
                        state_machine.excute("activity_cost_rotary_all_update_draw", 0, "")
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:updateDraw()
                        end
                    end
                end
                protocol_command.draw_activity_reward.param_list = _ED.activity_info["37"].activity_id .. "\r\n37\r\n1\r\n"..(cell._index - 1)
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
  		state_machine.add(activity_cost_rotary_all_cell_get_reward_terminal)
        state_machine.init()
    end
    
    init_activity_cost_rotary_all_cell_terminal()
end

function ActiveCostRotaryAllCell:updateDraw()
    local root = self.roots[1]
    for i=1,2 do
        local Panel_reward = ccui.Helper:seekWidgetByName(root, "Panel_box_reward_"..i)
        Panel_reward:removeAllChildren(true)
    end
    local Text_lv = ccui.Helper:seekWidgetByName(root,"Text_lv")
    Text_lv:setString(string.format(red_alert_all_str[178], self._info_data.achieve_other_info))
    -- 添加光效动画,宝箱状态icon
    local ArmatureNode = ccui.Helper:seekWidgetByName(root,"Panel_activity_cost_rotary_all_cell"):getChildByName("ArmatureNode_box_effect")
    ccui.Helper:seekWidgetByName(root,"Image_box"):setVisible(false)
    ccui.Helper:seekWidgetByName(root,"Image_box_1"):setVisible(false)
    ccui.Helper:seekWidgetByName(root,"Image_box_2"):setVisible(false)
    if tonumber(self._info_data.achieve_state) == 1 then    -- 可领取时播放光效
        ArmatureNode:setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Image_box_1"):setVisible(true)
    else
        ArmatureNode:setVisible(false)
        if tonumber(self._info_data.achieve_state) == 2 then
            ccui.Helper:seekWidgetByName(root,"Image_box_2"):setVisible(true) -- 领取之后显示开箱icon
        else
            ccui.Helper:seekWidgetByName(root,"Image_box"):setVisible(true)
        end
    end
    -- 奖励绘制
    local reward_info = zstring.split(self._info_data.achieve_reward, "|")
    for k,v in pairs(reward_info) do
        local info = zstring.split(v, ",")
        local data = 
        {
            item_value = info[3],
            prop_type = info[2],
            prop_item = info[1],
        }
        local cell = nil
        if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.change_of_equipment))> 0 
            or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.use_of_ship)) > 0  then
            cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,9,0,false,true})
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
        end  
        ccui.Helper:seekWidgetByName(root, "Panel_box_reward_"..k):addChild(cell)
    end
end

function ActiveCostRotaryAllCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.wonderful.activity_cost_rotary_all_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if ActiveCostRotaryAllCell.__size == nil then
        ActiveCostRotaryAllCell.__size = root:getContentSize()
    end
    -- 领取奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_box"), nil, 
    {
        terminal_name = "activity_cost_rotary_all_cell_get_reward", 
        cell = self,
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:updateDraw()
end

function ActiveCostRotaryAllCell:onEnterTransitionFinish()

end

function ActiveCostRotaryAllCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function ActiveCostRotaryAllCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    for i=1,2 do
        local Panel_reward = ccui.Helper:seekWidgetByName(root, "Panel_box_reward_"..i)
        if Panel_reward ~= nil then
            Panel_reward:removeAllChildren(true)
        end
    end
    cacher.freeRef(config_csb.cells.activity.wonderful.activity_cost_rotary_all_cell, root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function ActiveCostRotaryAllCell:init(index, info_data, index_data)
    self._info_data = info_data
    self._index = index
    if index_data ~= nil and index_data < 6 then
        self:onInit()
    end
    self:setContentSize(ActiveCostRotaryAllCell.__size)
    return self
end

function ActiveCostRotaryAllCell:onExit()
    for i=1,2 do
        local Panel_reward = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_box_reward_"..i)
        if Panel_reward ~= nil then
            Panel_reward:removeAllChildren(true)
        end
    end
    cacher.freeRef(config_csb.cells.activity.wonderful.activity_cost_rotary_all_cell, self.roots[1])
end