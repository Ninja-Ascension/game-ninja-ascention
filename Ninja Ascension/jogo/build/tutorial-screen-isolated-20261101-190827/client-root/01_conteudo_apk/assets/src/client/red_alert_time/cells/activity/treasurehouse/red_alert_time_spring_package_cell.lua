--------------------------------------------------------------------------------------------------------------
--  说明：春天好礼cell
--------------------------------------------------------------------------------------------------------------
RedAlertTimeSpringPackageCell = class("RedAlertTimeSpringPackageCellClass", Window)
RedAlertTimeSpringPackageCell.__size = nil

--创建cell
local red_alert_time_spring_package_cell_create_terminal = {
    _name = "red_alert_time_spring_package_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeSpringPackageCell:new()
        local activity_type = params[1]
        local index = tonumber(params[2])
        local a_type = tonumber(params[3]) or 0
        local group = tonumber(params[4]) or 0
        cell:init(activity_type,index,a_type,group)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_spring_package_cell_create_terminal)
state_machine.init()

function RedAlertTimeSpringPackageCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_type = nil
    self.a_type = 0
    self.index = 0
    self.group = 0
     
    local function init_red_alert_time_spring_package_cell_terminal()
        local red_alert_time_spring_package_cell_receive_award_terminal = {
            _name = "red_alert_time_spring_package_cell_receive_award",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- print("活动领取接口")
                local cell = params._datas.cells
                local acitvity = _ED.activity_info[""..cell.a_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
                        checkRewardObtainDraw()
                    end
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..cell.a_type.."\r\n"..(tonumber(cell.group)-1).."\r\n"..tonumber(cell._activity_type.achieve_index)-1
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_spring_package_cell_update_info_terminal = {
            _name = "red_alert_time_spring_package_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params.cell
                cell._activity_type = params.info
                cell.a_type = params.a_type
                cell.index = params.index
                cell.group = params.group
                if cell._activity_type ~= nil then
                    if cell._index <= 3 then
                        cell:reload()
                        cell:updateDraw()
                    else
                        cell:unload()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_spring_package_cell_receive_award_terminal)
        state_machine.add(red_alert_time_spring_package_cell_update_info_terminal)
        state_machine.init()
    end 
    -- call func red_alert_time_act_share_cell create state machine.
    init_red_alert_time_spring_package_cell_terminal()

end

function RedAlertTimeSpringPackageCell:updateDraw()
    self._activity_type = {
        achieve_index = self.index,
        achieve_complete_count = "1/1",
        achieve_state = "1",
        achieve_mould_name = "大型资源箱",
        achieve_other_info = "-1,2,840,2800,3,1",
        achieve_mould_dec = "——",
        achieve_reward = "247,6,1",
    }
    local root = self.roots[1]

    local Panel_spring_package_icon = ccui.Helper:seekWidgetByName(root,"Panel_spring_package_icon")            -- 图标
    local Text_spring_package_infor = ccui.Helper:seekWidgetByName(root,"Text_spring_package_infor")            -- 说明
    local Text_spring_package_name = ccui.Helper:seekWidgetByName(root,"Text_spring_package_name")              -- 名字
    local Text_spring_package_gold_old_n = ccui.Helper:seekWidgetByName(root,"Text_spring_package_gold_old_n")  -- 原价
    local Text_spring_package_gold_n = ccui.Helper:seekWidgetByName(root,"Text_spring_package_gold_n")          -- 现价
    local Text_seek_treasure_discount_n = ccui.Helper:seekWidgetByName(root,"Text_seek_treasure_discount_n")          -- 折扣
    local ListView_spring_package_reward = ccui.Helper:seekWidgetByName(root,"ListView_spring_package_reward")  -- 礼包道具
    local Button_spring_package_buy = ccui.Helper:seekWidgetByName(root,"Button_spring_package_buy") 

    Panel_spring_package_icon:removeAllChildren(true)
    local prop_info = zstring.split(self._activity_type.achieve_reward, ",")
    local prop_data = {}
    prop_data.prop_item = tonumber(prop_info[1])
    prop_data.prop_type = tonumber(prop_info[2])
    prop_data.item_value = tonumber(prop_info[3])
    local cell = createPropIconCell(prop_data, false, false, true)
    Panel_spring_package_icon:addChild(cell)

    local achieve_complete_count = zstring.split(self._activity_type.achieve_complete_count, "/")
    local current_count = tonumber(achieve_complete_count[2]) - tonumber(achieve_complete_count[1])
    local total_count = tonumber(achieve_complete_count[2])
    Text_spring_package_name:setString(self._activity_type.achieve_mould_name.."("..current_count.."/"..total_count..")")
    local remarks = dms.string(dms["prop_mould"], prop_data.prop_item, prop_mould.remarks)
    Text_spring_package_infor:setString(remarks)

    if current_count >= total_count then
        Button_spring_package_buy:setTitleText(red_alert_time_str[231])
        Button_spring_package_buy:setTouchEnabled(false)
        Button_spring_package_buy:setBright(false)
    else
        Button_spring_package_buy:setTitleText(activity_str_tip[168])
        Button_spring_package_buy:setTouchEnabled(true)
        Button_spring_package_buy:setBright(true)
    end

    local cost_info = zstring.split(self._activity_type.achieve_other_info, ",")
    Text_spring_package_gold_n:setString(cost_info[3])
    Text_spring_package_gold_old_n:setString(cost_info[4])
    local curr_discount = tonumber(cost_info[5])
    if verifySupportLanguage(_lua_release_language_en) == true then
        curr_discount = (10 - self.discount) * 10
    end
    Text_seek_treasure_discount_n:setString(string.format(activity_str_tip[22], ""..curr_discount))

    -- 礼包道具
    local addition_group_index = dms.int(dms["prop_mould"], prop_data.prop_item, prop_mould.addition_group_index)
    local reward_info = zstring.split(dms.string(dms["scene_reward"], addition_group_index, scene_reward.reward_items), "|")
    ListView_spring_package_reward:removeAllItems()

    for k, v in pairs(reward_info) do
        local info = zstring.split(v, ",")
        local prop_data = {}
        prop_data.prop_item = tonumber(info[1])
        prop_data.prop_type = tonumber(info[2])
        prop_data.item_value = tonumber(info[3])
        local cell = createPropIconCell(prop_data, true, true, true)
        ListView_spring_package_reward:addChild(cell)
    end

    ListView_spring_package_reward:requestRefreshView()
end 

function RedAlertTimeSpringPackageCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.spring_package_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeSpringPackageCell.__size == nil then
        RedAlertTimeSpringPackageCell.__size = root:getContentSize()
    end

    --领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_spring_package_buy"), nil, 
    {
        terminal_name = "red_alert_time_spring_package_cell_receive_award", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self
    }, nil, 1)

    self:updateDraw()
end

function RedAlertTimeSpringPackageCell:onEnterTransitionFinish()
    local root = self.roots[1]
    
end

function RedAlertTimeSpringPackageCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_spring_package_icon = ccui.Helper:seekWidgetByName(root,"Panel_spring_package_icon")            -- 图标
    local Text_spring_package_infor = ccui.Helper:seekWidgetByName(root,"Text_spring_package_infor")            -- 说明
    local Text_spring_package_name = ccui.Helper:seekWidgetByName(root,"Text_spring_package_name")              -- 名字
    local Text_spring_package_gold_old_n = ccui.Helper:seekWidgetByName(root,"Text_spring_package_gold_old_n")  -- 原价
    local Text_spring_package_gold_n = ccui.Helper:seekWidgetByName(root,"Text_spring_package_gold_n")          -- 现价
    local ListView_spring_package_reward = ccui.Helper:seekWidgetByName(root,"ListView_spring_package_reward")  -- 礼包道具
    if Panel_spring_package_icon ~= nil then
        Panel_spring_package_icon:removeAllChildren(true)
        Text_spring_package_infor:setString("")
        Text_spring_package_name:setString("")
        Text_spring_package_gold_old_n:setString("")
        Text_spring_package_gold_n:setString("")
        ListView_spring_package_reward:removeAllChildren(true)
    end
end

function RedAlertTimeSpringPackageCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlertTimeSpringPackageCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.spring_package_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeSpringPackageCell:init(activity_type,index,a_type,group)
    self._activity_type = activity_type
    self.index = index
    self.a_type = a_type
    self.group = group
    if index ~= nil and index <= 3 then
       self:onInit()
    end
    self:setContentSize(RedAlertTimeSpringPackageCell.__size)
    return self
end

function RedAlertTimeSpringPackageCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.spring_package_cell, self.roots[1])
end