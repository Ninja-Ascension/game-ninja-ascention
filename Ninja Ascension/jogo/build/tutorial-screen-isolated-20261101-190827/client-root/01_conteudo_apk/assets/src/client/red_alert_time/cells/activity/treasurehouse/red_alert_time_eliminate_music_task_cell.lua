-- ------------------------------------------------------------------------------------------------------------
--  说明：消消乐任务单个列表
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeEliminateMusicTaskCell = class("RedAlertTimeEliminateMusicTaskCellClass", Window)
RedAlertTimeEliminateMusicTaskCell.__size = nil

--创建cell
local red_alert_time_eliminate_music_task_cell_create_terminal = {
    _name = "red_alert_time_eliminate_music_task_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeEliminateMusicTaskCell:new()
        local activity_data = params[1]
        local activity = params[2]
        local index = params[3]
        cell:init(activity_data,activity,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_eliminate_music_task_cell_create_terminal)
state_machine.init()

function RedAlertTimeEliminateMusicTaskCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._activity_data = nil
    self._activity_type = nil
    self._index = 0 
    local function init_red_alert_time_eliminate_music_task_cell_terminal()
		local red_alert_time_eliminate_music_task_receive_terminal = {
            _name = "red_alert_time_eliminate_music_task_receive",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                local acitvity = _ED.activity_info[""..cell._activity_type]
            	local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
						checkRewardObtainDraw()
                        state_machine.excute("notification_center_update", 0, "push_notification_treasurehouse_eliminate_music")
					end
				end		
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..cell._activity_type.."\r\n"..(1).."\r\n"..(tonumber(cell._activity_data.achieve_index)-1).."\r\n".."1"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(red_alert_time_eliminate_music_task_receive_terminal)
    end
    init_red_alert_time_eliminate_music_task_cell_terminal()
end

function RedAlertTimeEliminateMusicTaskCell:updateDraw()
    local root = self.roots[1]
    local Button_eliminate_music_task_rec = ccui.Helper:seekWidgetByName(root,"Button_eliminate_music_task_rec")
	--领取状态
    Button_eliminate_music_task_rec:setTitleText(red_alert_time_str[128])
    if tonumber(self._activity_data.achieve_state) == 1 then
        Button_eliminate_music_task_rec:setTouchEnabled(true)
        Button_eliminate_music_task_rec:setBright(true)
    else
        Button_eliminate_music_task_rec:setTouchEnabled(false)
        Button_eliminate_music_task_rec:setBright(false)
        if tonumber(self._activity_data.achieve_state) == 2 then
            Button_eliminate_music_task_rec:setTitleText(red_alert_time_str[129])
        end
    end
    --进度
    local Text_eliminate_music_task_speed_n = ccui.Helper:seekWidgetByName(root,"Text_eliminate_music_task_speed_n")
    Text_eliminate_music_task_speed_n:setString(self._activity_data.achieve_complete_count)

    --名称
    local Text_eliminate_music_task_name = ccui.Helper:seekWidgetByName(root,"Text_eliminate_music_task_name")
    Text_eliminate_music_task_name:setString(self._activity_data.achieve_mould_name)

    --奖励
    local ListView_eliminate_music_task_rew = ccui.Helper:seekWidgetByName(root,"ListView_eliminate_music_task_rew")
    ListView_eliminate_music_task_rew:removeAllItems()
    local rewarldData = zstring.split(self._activity_data.achieve_reward, "|")
    for i=1 ,#rewarldData do
        local datas = zstring.split(rewarldData[i], ",")
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
            cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), tonumber(datas[3])})
        else
            cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),nil,tonumber(datas[1])})
        end
        --ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
        --ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
        ListView_eliminate_music_task_rew:addChild(cell)
    end
    ListView_eliminate_music_task_rew:requestRefreshView()
end

function RedAlertTimeEliminateMusicTaskCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.eliminate_music_task_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)
    --领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_eliminate_music_task_rec"), nil, 
    {
        terminal_name = "red_alert_time_eliminate_music_task_receive", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self
    }, nil, 1)

    if RedAlertTimeEliminateMusicTaskCell.__size == nil then
        RedAlertTimeEliminateMusicTaskCell.__size = root:getContentSize()
    end
	
    self:updateDraw()
end

function RedAlertTimeEliminateMusicTaskCell:onEnterTransitionFinish()

end

function RedAlertTimeEliminateMusicTaskCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlertTimeEliminateMusicTaskCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.eliminate_music_task_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeEliminateMusicTaskCell:clearUIInfo()
    local root = self.roots[1]
    local Text_eliminate_music_task_name = ccui.Helper:seekWidgetByName(root, "Text_eliminate_music_task_name")
    local Text_eliminate_music_task_speed_n = ccui.Helper:seekWidgetByName(root, "Text_eliminate_music_task_speed_n")
    local ListView_eliminate_music_task_rew = ccui.Helper:seekWidgetByName(root,"ListView_eliminate_music_task_rew")
    if Text_eliminate_music_task_name ~= nil then
        Text_eliminate_music_task_name:setString("")
        Text_eliminate_music_task_speed_n:setString("")
        ListView_eliminate_music_task_rew:removeAllItems()
    end
end

function RedAlertTimeEliminateMusicTaskCell:init(activity_data,activity,index)
    self._activity_data = activity_data
    self._activity_type = activity
    self._index = index
    -- if index ~= nil and index <= 5 then
        self:onInit()
    -- end
    self:setContentSize(RedAlertTimeEliminateMusicTaskCell.__size)
    return self
end

function RedAlertTimeEliminateMusicTaskCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.eliminate_music_task_cell, self.roots[1])
end

