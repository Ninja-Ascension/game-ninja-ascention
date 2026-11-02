--------------------------------------------------------------------------------------------------------------
--  杂货铺控件
--------------------------------------------------------------------------------------------------------------
ChangePropsCell = class("ChangePropsCellClass", Window)
ChangePropsCell.__size = nil

--创建cell
local change_props_create_cell_terminal = {
    _name = "change_props_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local activity_info = params[1]
        local activity_type = params[2]
        local index = params[3]
        local cell = ChangePropsCell:new()
        cell:init(activity_info,activity_type,index,day_index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(change_props_create_cell_terminal)
state_machine.init()

function ChangePropsCell:ctor()
    self.super:ctor()
    self.roots = {}

    --活动类型
    self._activity_type = nil
    --活动信息
    self._activity_info = nil
    --下标
    self._index = nil
    --load lua file
    app.load("client.red_alert_time.cells.activity.wonderful.activiy_change")
     -- Initialize change_props_cell state machine.
    local function init_change_props_cell_terminal()
        --领取奖励
        local change_props_cell_change_items_terminal = {
        _name = "change_props_cell_change_items",
        _init = function (terminal)
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)           
            local cell = params._datas.cell
            local index = cell._index
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    state_machine.excute("reward_obtain_window_open",0,{1017})
                    if cell ~= nil and cell.updateDraw then
                        cell:updateDraw()
                    end 
                    -- 如果这一档全部兑换完了刷新超值兑换界面
                    local achieve_complete_count = zstring.split(cell._activity_info.achieve_complete_count,"/")
                    if tonumber(achieve_complete_count[1]) <= 0 then
                        state_machine.excute("change_props_set_positiony", 0, "")
                    end
                end
            end
            protocol_command.draw_activity_reward.param_list = _ED.activity_info["17"].activity_id .. "\r\n" .."17" .. "\r\n" .. "0" .."\r\n" .. (cell._achieve_index - 1)
            NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, nil, responseCallback, false, nil)  
            return true
        end,
        _terminal = nil,
        _terminals = nil
        }
        state_machine.add(change_props_cell_change_items_terminal)
        state_machine.init()
    end
    
    init_change_props_cell_terminal()
end

function ChangePropsCell:updateDraw()
    local root = self.roots[1]

    local Text_change_name = ccui.Helper:seekWidgetByName(root,"Text_change_name") -- 描述
    local Text_time_t = ccui.Helper:seekWidgetByName(root,"Text_time_t")
    local ListView_1 = ccui.Helper:seekWidgetByName(root,"ListView_1")
    self._listview = ListView_1
    ListView_1:removeAllItems()
    Text_time_t:setString("")
    Text_change_name:setString(self._activity_info.achieve_dec)
    Text_time_t:setString(self._activity_info.achieve_complete_count)
    -- 需要道具
    local need_data_str = self._activity_info.achieve_other_info
    need_data_str = zstring.split(need_data_str,",")
    local sell_price = need_data_str[#need_data_str-1]
    for i=1,(#need_data_str-2)/3 do
        local index = i - 1
        local data = 
        {
            item_value = need_data_str[3 + index * 3],
            prop_type = need_data_str[2 + index * 3],
            prop_item = need_data_str[1 + index * 3],
        }
        local cell = state_machine.excute("activiy_change_create_cell",0,{data})
        ListView_1:addChild(cell)
    end
    -- 获得道具
    local reward_data_str = self._activity_info.achieve_reward
    reward_data_str = zstring.split(reward_data_str,"|")
    for i,reward in pairs(reward_data_str) do
        local reward_tab = zstring.split(reward,",")
        local data = 
        {
            item_value = reward_tab[3],
            prop_type = reward_tab[2],
            prop_item = reward_tab[1],
        }
        local cell = state_machine.excute("activiy_change_create_cell",0,{data,i})
        ListView_1:addChild(cell)
    end

    for i=3,9 do
        local Image_sell_price = ccui.Helper:seekWidgetByName(root, "Image_sell_price_"..i)
        if Image_sell_price ~= nil then
            if i == tonumber(sell_price) then
                Image_sell_price:setVisible(true)
            else
                Image_sell_price:setVisible(false)
            end
        end
    end

    local Button_change = ccui.Helper:seekWidgetByName(root, "Button_change")
    Button_change:setBright(true)
    Button_change:setTouchEnabled(true)
    local change_count = self._activity_info.achieve_complete_count
    change_count = zstring.split(change_count,"/")
    if tonumber(change_count[1]) <= 0 then
        Button_change:setBright(false)
        Button_change:setTouchEnabled(false)
    end
end

function ChangePropsCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.wonderful.change_props_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if ChangePropsCell.__size == nil then
        ChangePropsCell.__size = root:getContentSize()
    end

    --兑换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_change"), nil, 
    {
        terminal_name = "change_props_cell_change_items", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)    

    self:updateDraw()
end

function ChangePropsCell:onEnterTransitionFinish()

end

function ChangePropsCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ChangePropsCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end

    if self._listview ~= nil then
        self._listview:removeAllItems()
    end
    cacher.freeRef(config_csb.cells.activity.wonderful.change_props_cell, root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end


function ChangePropsCell:init(activity_info,activity_type,index)
    self._activity_info = activity_info
    self._activity_type = tonumber(activity_type)
    self._index = index
    self._achieve_index = activity_info.achieve_index
    if index ~= nil and index <= 4 then
         self:onInit()
    end
    self:setContentSize(ChangePropsCell.__size)
    return self
end

function ChangePropsCell:onExit()
    if self._listview ~= nil then
        self._listview:removeAllItems()
    end
    cacher.freeRef(config_csb.cells.activity.wonderful.change_props_cell, self.roots[1])
end