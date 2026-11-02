-- ------------------------------------------------------------------------------------------------------------
--  说明：火力全开单个列表
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeFullVitalityCell = class("RedAlertTimeFullVitalityCellClass", Window)
RedAlertTimeFullVitalityCell.__size = nil

--创建cell
local red_alert_time_full_vitality_cell_create_terminal = {
    _name = "red_alert_time_full_vitality_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeFullVitalityCell:new()
        local activity_data = params[1]
        local activity_type = params[2]
        local index = params[3]
        cell:init(activity_data, activity_type,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_full_vitality_cell_create_terminal)
state_machine.init()

function RedAlertTimeFullVitalityCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_data = nil
    self._activity_type = 0
    self._index = 0

    local function init_red_alert_time_full_vitality_cell_terminal()
        -- 领取
        local red_alert_time_full_vitality_cell_receive_award_terminal = {
            _name = "red_alert_time_full_vitality_cell_receive_award",
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
                    end
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..cell._activity_type.."\r\n"..(0).."\r\n"..(tonumber(cell._activity_data.achieve_index)-1).."\r\n".."0"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 前往
        local red_alert_time_full_vitality_cell_go_to_terminal = {
            _name = "red_alert_time_full_vitality_cell_go_to",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                local changeType = cell._activity_data.achieve_other_info
                if tonumber(changeType) ~= -1 then
                    state_machine.excute("short_cut_go_to_other_window",0,{tonumber(changeType)})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 查看
        local red_alert_time_full_vitality_cell_look_infor_terminal = {
            _name = "red_alert_time_full_vitality_cell_look_infor",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                local reward_info = zstring.split(cell._activity_data.achieve_reward, "|")
                table.remove(reward_info, 1)
                state_machine.excute("red_alert_time_box_preview_window_open",0,{reward_info , activity_str_tip[113]})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_full_vitality_cell_receive_award_terminal)
        state_machine.add(red_alert_time_full_vitality_cell_go_to_terminal)
        state_machine.add(red_alert_time_full_vitality_cell_look_infor_terminal)
        state_machine.init()
    end
    init_red_alert_time_full_vitality_cell_terminal()
end

function RedAlertTimeFullVitalityCell:updateDraw()
    local root = self.roots[1]
    local Panel_full_vitality_icon = ccui.Helper:seekWidgetByName(root,"Panel_full_vitality_icon")
    Panel_full_vitality_icon:removeAllChildren(true)
    local reward_info = zstring.split(self._activity_data.achieve_reward, "|")
    local prop_info = zstring.split(reward_info[1], ",")
    local prop_data = {}
    prop_data.prop_item = tonumber(prop_info[1])
    prop_data.prop_type = tonumber(prop_info[2])
    prop_data.item_value = tonumber(prop_info[3])

    local cell = createPropIconCell(prop_data, false, false, false)
    Panel_full_vitality_icon:addChild(cell)

    local Text_full_vitality_reward_tit = ccui.Helper:seekWidgetByName(root,"Text_full_vitality_reward_tit")
    Text_full_vitality_reward_tit:setString(self._activity_data.achieve_mould_name)

    -- 进度
    local LoadingBar_full_vitality_n = ccui.Helper:seekWidgetByName(root,"LoadingBar_full_vitality_n")
    local Text_full_vitality_n = ccui.Helper:seekWidgetByName(root,"Text_full_vitality_n")
    local achieve_complete_count = zstring.split(self._activity_data.achieve_complete_count, "/")
    local current_count = tonumber(achieve_complete_count[1])
    local total_count = tonumber(achieve_complete_count[2])
    current_count = math.min(current_count, total_count)
    local percent = current_count * 100 / total_count
    LoadingBar_full_vitality_n:setPercent(percent)
    Text_full_vitality_n:setString(""..current_count.."/"..total_count)

    -- 领奖状态
    local Button_full_vitality_reward_rec_1 = ccui.Helper:seekWidgetByName(root,"Button_full_vitality_reward_rec_1")
    local Button_full_vitality_reward_rec = ccui.Helper:seekWidgetByName(root,"Button_full_vitality_reward_rec")
    Button_full_vitality_reward_rec:setBright(true)
    Button_full_vitality_reward_rec:setTouchEnabled(true)
    Button_full_vitality_reward_rec_1:setBright(true)
    Button_full_vitality_reward_rec_1:setTouchEnabled(true)

    -- 时间
    local activity_info = _ED.activity_info[""..self._activity_type]
    local activity_add_state = zstring.split(activity_info.activity_add_state,",")

    if tonumber(activity_add_state[3])/1000 < (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
        Button_full_vitality_reward_rec_1:setVisible(false)
        Button_full_vitality_reward_rec:setVisible(true)
        Button_full_vitality_reward_rec:setBright(false)
        Button_full_vitality_reward_rec:setTouchEnabled(false)
    else
        if tonumber(self._activity_data.achieve_state) <= 1 then
            Button_full_vitality_reward_rec_1:setVisible(false)
            Button_full_vitality_reward_rec:setVisible(true)
            if tonumber(self._activity_data.achieve_state) == 1 or tonumber(achieve_complete_count[1]) >= tonumber(achieve_complete_count[2]) then
                Button_full_vitality_reward_rec:setVisible(false)
                Button_full_vitality_reward_rec_1:setVisible(true)
                Button_full_vitality_reward_rec_1:setTitleText(activity_str_tip[5])
            else
                Button_full_vitality_reward_rec_1:setVisible(false)
                Button_full_vitality_reward_rec:setVisible(true)
            end
        else
            Button_full_vitality_reward_rec:setVisible(false)
            Button_full_vitality_reward_rec_1:setVisible(true)
            Button_full_vitality_reward_rec_1:setTitleText(activity_str_tip[2])
            Button_full_vitality_reward_rec_1:setBright(false)
            Button_full_vitality_reward_rec_1:setTouchEnabled(false)
        end
    end
end

function RedAlertTimeFullVitalityCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.full_vitality_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeFullVitalityCell.__size == nil then
        RedAlertTimeFullVitalityCell.__size = root:getContentSize()
    end
    --领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_full_vitality_reward_rec_1"), nil, 
    {
        terminal_name = "red_alert_time_full_vitality_cell_receive_award", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self
    }, nil, 1)

    --前往
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_full_vitality_reward_rec"), nil, 
    {
        terminal_name = "red_alert_time_full_vitality_cell_go_to", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self
    }, nil, 1)

    --查看
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_full_vitality_reward_rec_0"), nil, 
    {
        terminal_name = "red_alert_time_full_vitality_cell_look_infor", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self
    }, nil, 1)

    
    self:updateDraw()
end

function RedAlertTimeFullVitalityCell:onEnterTransitionFinish()

end

function RedAlertTimeFullVitalityCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlertTimeFullVitalityCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.full_vitality_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeFullVitalityCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_full_vitality_icon = ccui.Helper:seekWidgetByName(root,"Panel_full_vitality_icon")
    local Text_full_vitality_reward_tit = ccui.Helper:seekWidgetByName(root,"Text_full_vitality_reward_tit")
    local Text_full_vitality_n = ccui.Helper:seekWidgetByName(root,"Text_full_vitality_n")
    local LoadingBar_full_vitality_n = ccui.Helper:seekWidgetByName(root,"LoadingBar_full_vitality_n")
    if Panel_full_vitality_icon ~= nil then
        Panel_full_vitality_icon:removeAllChildren(true)
        Text_full_vitality_reward_tit:setString("")
        Text_full_vitality_n:setString("")
        LoadingBar_full_vitality_n:setPercent(0)
    end
end

function RedAlertTimeFullVitalityCell:init(activity_data,activity_type,index)
    self._activity_data = activity_data
    self._activity_type = activity_type
    self._index = index
    -- if index ~= nil and index <= 5 then
        self:onInit()
    -- end
    self:setContentSize(RedAlertTimeFullVitalityCell.__size)
    return self
end

function RedAlertTimeFullVitalityCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.full_vitality_cell, self.roots[1])
end

