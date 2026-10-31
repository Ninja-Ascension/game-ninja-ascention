--------------------------------------------------------------------------------------------------------------
--  说明：愚你同乐兑换的cell
--------------------------------------------------------------------------------------------------------------
RedAlerTimeAprilFoolsHappyChangeCell = class("RedAlerTimeAprilFoolsHappyChangeCellClass", Window)
RedAlerTimeAprilFoolsHappyChangeCell.__size = nil

--创建cell
local red_alert_time_april_fools_happy_change_cell_create_terminal = {
    _name = "red_alert_time_april_fools_happy_change_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlerTimeAprilFoolsHappyChangeCell:new()
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
state_machine.add(red_alert_time_april_fools_happy_change_cell_create_terminal)
state_machine.init()

function RedAlerTimeAprilFoolsHappyChangeCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_type = nil
    self.a_type = 0
    self.index = 0
    self.group = 0

     -- Initialize red_alert_time_act_share_cell state machine.
     app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_discount_label")
     
    local function init_red_alert_time_april_fools_happy_change_cell_terminal()
        local red_alert_time_april_fools_happy_change_cell_update_info_terminal = {
            _name = "red_alert_time_april_fools_happy_change_cell_update_info",
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
                    -- if cell.index ~= nil and cell.index < 4 then
                        cell:reload()
                        cell:updateDraw()
                    -- else
                    --     cell:unload()
                    -- end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_april_fools_happy_change_cell_receive_award_terminal = {
            _name = "red_alert_time_april_fools_happy_change_cell_receive_award",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                local acitvity = _ED.activity_info[""..cell.a_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
                        checkRewardObtainDraw()
                        state_machine.excute("red_alert_time_april_fools_happy_collection_update_draw", 0, "")
                        state_machine.excute("red_alert_time_april_fools_happy_exchange_update_draw", 0, "")
                    end
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..cell.a_type.."\r\n"..(tonumber(cell.group)-1).."\r\n"..(tonumber(cell._activity_type.achieve_index)-1).."\r\n".."0"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_april_fools_happy_change_cell_update_info_terminal)
        state_machine.add(red_alert_time_april_fools_happy_change_cell_receive_award_terminal)
        state_machine.init()
    end 
    -- call func red_alert_time_act_share_cell create state machine.
    init_red_alert_time_april_fools_happy_change_cell_terminal()

end

function RedAlerTimeAprilFoolsHappyChangeCell:updateDraw()
    local root = self.roots[1]
    local Panel_fools_happy_change_icon = ccui.Helper:seekWidgetByName(root, "Panel_fools_happy_change_icon")
    local Text_fools_happy_change_tit = ccui.Helper:seekWidgetByName(root, "Text_fools_happy_change_tit")
    local Text_fools_happy_change_infor = ccui.Helper:seekWidgetByName(root, "Text_fools_happy_change_infor")
    local Text_fools_happy_change_gold_n = ccui.Helper:seekWidgetByName(root, "Text_fools_happy_change_gold_n")
    local Image_fools_happy_change_gold = ccui.Helper:seekWidgetByName(root, "Image_fools_happy_change_gold")
    local Button_fools_happy_change = ccui.Helper:seekWidgetByName(root, "Button_fools_happy_change")

    local complete_count_info = zstring.split(self._activity_type.achieve_complete_count, "/")
    local currnet_count = tonumber(complete_count_info[2]) - tonumber(complete_count_info[1])
    local total_count = tonumber(complete_count_info[2])
    Text_fools_happy_change_tit:setString(self._activity_type.achieve_mould_name.."("..currnet_count.."/"..total_count..")")
    Text_fools_happy_change_infor:setString(self._activity_type.achieve_mould_dec)

    -- 兑换材料
    local prop_info = zstring.split(self._activity_type.achieve_other_info, ",")
    local prop_pic_index = dms.string(dms["prop_mould"], prop_info[1], prop_mould.pic_index)
    prop_pic_index = zstring.split(prop_pic_index, ",")
    -- Image_fools_happy_change_gold:loadTexture(string.format(config_res.images.ui.props.props, prop_pic_index[1]))
    Text_fools_happy_change_gold_n:setString(prop_info[3])

    -- 兑换奖励
    Panel_fools_happy_change_icon:removeAllChildren(true)
    local exchange_info = zstring.split(self._activity_type.achieve_reward, ",")
    local prop_data = {}
    prop_data.prop_item = tonumber(exchange_info[1])
    prop_data.prop_type = tonumber(exchange_info[2])
    prop_data.item_value = tonumber(exchange_info[3])
    local cell = createPropIconCell(prop_data, true, false, true)
    Panel_fools_happy_change_icon:addChild(cell)

    -- 按钮状态
    local count = 0
    local prop = fundPropWidthId(prop_info[1])
    if prop ~= nil then
        count = tonumber(prop.prop_number)
    end
    count = 100
    if count < tonumber(prop_info[3]) then
        Button_fools_happy_change:setTouchEnabled(false)
        Button_fools_happy_change:setBright(false)
    else
        Button_fools_happy_change:setTouchEnabled(true)
        Button_fools_happy_change:setBright(true)
    end
end

function RedAlerTimeAprilFoolsHappyChangeCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.april_fools_happy_change_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlerTimeAprilFoolsHappyChangeCell.__size == nil then
        RedAlerTimeAprilFoolsHappyChangeCell.__size = root:getContentSize()
    end

    --领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_fools_happy_change"), nil, 
    {
        terminal_name = "red_alert_time_april_fools_happy_change_cell_receive_award", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self
    }, nil, 1)

    self:updateDraw()

end

function RedAlerTimeAprilFoolsHappyChangeCell:onEnterTransitionFinish()
    
end

function RedAlerTimeAprilFoolsHappyChangeCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_fools_happy_change_icon = ccui.Helper:seekWidgetByName(root, "Panel_fools_happy_change_icon")
    local Text_fools_happy_change_tit = ccui.Helper:seekWidgetByName(root, "Text_fools_happy_change_tit")
    local Text_fools_happy_change_infor = ccui.Helper:seekWidgetByName(root, "Text_fools_happy_change_infor")
    local Text_fools_happy_change_gold_n = ccui.Helper:seekWidgetByName(root, "Text_fools_happy_change_gold_n")

    if Panel_fools_happy_change_icon ~= nil then
        Panel_fools_happy_change_icon:removeAllChildren(true)
        Text_fools_happy_change_tit:setString("")
        Text_fools_happy_change_infor:setString("")
        Text_fools_happy_change_gold_n:setString("")
    end
end

function RedAlerTimeAprilFoolsHappyChangeCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlerTimeAprilFoolsHappyChangeCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.april_fools_happy_change_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlerTimeAprilFoolsHappyChangeCell:init(activity_type,index,a_type,group)
    self._activity_type = activity_type
    self.index = index
    self.a_type = a_type
    self.group = group
    -- if index ~= nil and index < 4 then
       self:onInit()
    -- end

    self:setContentSize(RedAlerTimeAprilFoolsHappyChangeCell.__size)
    return self
end

function RedAlerTimeAprilFoolsHappyChangeCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.april_fools_happy_change_cell, self.roots[1])
end