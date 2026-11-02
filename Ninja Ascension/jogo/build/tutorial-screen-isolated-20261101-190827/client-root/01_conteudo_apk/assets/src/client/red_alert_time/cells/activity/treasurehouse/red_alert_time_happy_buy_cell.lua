--------------------------------------------------------------------------------------------------------------
--  说明：欢乐团购cell
--------------------------------------------------------------------------------------------------------------
RedAlertTimeHappyBuyCell = class("RedAlertTimeHappyBuyCellClass", Window)
RedAlertTimeHappyBuyCell.__size = nil

--创建cell
local red_alert_time_happy_buy_cell_create_terminal = {
    _name = "red_alert_time_happy_buy_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeHappyBuyCell:new()
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
state_machine.add(red_alert_time_happy_buy_cell_create_terminal)
state_machine.init()

function RedAlertTimeHappyBuyCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_type = nil
    self.a_type = 0
    self.index = 0
    self.group = 0

    self._cost_gold = 0
    self._max_select_num = 0
    self._prop_id = 0

    app.load("client.red_alert_time.props.PropsBatchBuy")

    local function init_red_alert_time_happy_buy_cell_terminal()
        local red_alert_time_happy_buy_cell_receive_award_terminal = {
            _name = "red_alert_time_happy_buy_cell_receive_award",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                if cell._max_select_num <= 0 then
                    TipDlg.drawTextDailog(activity_str_tip[139])
                    return
                end
                local shop_info = { cost_gold = cell._cost_gold, cell = cell , fromType = 2, max_select_num = cell._max_select_num}
                state_machine.excute("props_batch_buy_window_open", 0, {cell._prop_id, shop_info})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_happy_buy_cell_update_info_terminal = {
            _name = "red_alert_time_happy_buy_cell_update_info",
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
                    -- if cell.index <= 4 then
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

        local red_alert_time_happy_buy_cell_sure_buy_terminal = {
            _name = "red_alert_time_happy_buy_cell_sure_buy",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[1]
                local prop_id = cell._prop_id
                local select_num = params[2]
                local acitvity = _ED.activity_info[""..cell.a_type]

                local function userProp(prop_id, number)
                    local prop = fundPropWidthId(prop_id)
                    if prop == nil then
                        return
                    end

                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            checkRewardObtainDraw()
                        end
                    end
                    protocol_command.prop_use.param_list = prop.user_prop_id.."\r\n"..number.."\r\n".."-1".."\r\n".."-1"
                    NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, nil, responseCallback, false, nil)
                end

                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
                        _ED.show_reward_list_group_ex = {}
                        state_machine.excute("red_alert_time_happy_buy_record_update", 0, "")
                        userProp(prop_id, select_num)
                    end
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..cell.a_type.."\r\n"..(tonumber(cell.group)-1).."\r\n"..(tonumber(cell._activity_type.achieve_index)-1).."\r\n0\r\n"..select_num
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                state_machine.excute("props_batch_buy_window_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_happy_buy_cell_receive_award_terminal)
        state_machine.add(red_alert_time_happy_buy_cell_update_info_terminal)
        state_machine.add(red_alert_time_happy_buy_cell_sure_buy_terminal)
        state_machine.init()
    end 
    -- call func red_alert_time_act_share_cell create state machine.
    init_red_alert_time_happy_buy_cell_terminal()

end

function RedAlertTimeHappyBuyCell:updateDraw()
    local root = self.roots[1]

    local Panel_happy_buy_icon = ccui.Helper:seekWidgetByName(root,"Panel_happy_buy_icon")             -- 图标
    local Text_happy_buy_name = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_name")                    -- 名字
    local Text_happy_buy_all_number_n = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_all_number_n")    -- 全服购买数量
    local Text_happy_buy_one_number_n = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_one_number_n")    -- 个人购买数量
    local Text_happy_buy_gold_n = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_gold_n")                -- 当前价格
    local Text_happy_buy_old_gold_n = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_old_gold_n")        -- 原价
    local Text_happy_buy_discount_n = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_discount_n")        -- 折扣
    local LoadingBar_happy_buy_prass = ccui.Helper:seekWidgetByName(root,"LoadingBar_happy_buy_prass")        -- 购买进度
    local Image_happy_buy_prass_ing = ccui.Helper:seekWidgetByName(root,"Image_happy_buy_prass_ing")

    local activity_info = _ED.activity_info[""..self.a_type]

    -- activity_add_state = "活动起始时间,活动关闭时间,领奖时间|第一件商品第一档折扣数,需要购买次数,第二档折扣数,需要购买次数,第三档折扣数,需要购买次数,全服限购次数|第二件商品...."
    local activity_add_state_attr = zstring.split(activity_info.activity_add_state,"|")
    local activity_add_state = zstring.split(activity_add_state_attr[1], ",")

    local goods_info = zstring.split(activity_add_state_attr[self.index + 1], ",")

    Panel_happy_buy_icon:removeAllChildren(true)
    local prop_info = zstring.split(self._activity_type.achieve_reward, ",")
    local prop_data = {}
    prop_data.prop_item = tonumber(prop_info[1])
    prop_data.prop_type = tonumber(prop_info[2])
    prop_data.item_value = tonumber(prop_info[3])
    local cell = createPropIconCell(prop_data, false, false, true)
    Panel_happy_buy_icon:addChild(cell)
    self._prop_id = prop_data.prop_item

    Text_happy_buy_name:setString(self._activity_type.achieve_mould_name)

    -- 全服购买数量
    local all_current_count = tonumber(_ED.happy_buy_activity_info.all_count[self.index].leave_count)
    local all_total_count = tonumber(goods_info[7])
    Text_happy_buy_all_number_n:setString(""..all_current_count.."/"..all_total_count)

    -- 个人购买数量
    local achieve_complete_count = zstring.split(self._activity_type.achieve_complete_count, "/")
    local current_count = tonumber(achieve_complete_count[1])
    local total_count = tonumber(achieve_complete_count[2])
    Text_happy_buy_one_number_n:setString(self._activity_type.achieve_complete_count)

    self._max_select_num = math.min(all_current_count, current_count)

    -- 折扣
    local max_count = 0
    local count = all_total_count - all_current_count
    for i = 1, 3 do
        local Text_happy_buy_prass_dis = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_prass_dis_"..i)
        local Text_happy_buy_prass_state = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_prass_state_"..i)
        max_count = tonumber(goods_info[2 * i])
        local curr_discount = tonumber(goods_info[2 * i - 1])
        if verifySupportLanguage(_lua_release_language_en) == true then
            curr_discount = (10 - curr_discount) * 10
        end
        if count >= max_count then
            local discount_str = string.format(activity_str_tip[22], ""..curr_discount)
            Text_happy_buy_prass_dis:setString(string.format(activity_str_tip[180], discount_str))
            Text_happy_buy_prass_state:setString(string.format(activity_str_tip[182], count))
            Text_happy_buy_prass_dis:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
            Text_happy_buy_prass_state:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
        else
            Text_happy_buy_prass_dis:setString(string.format(activity_str_tip[181], ""..curr_discount))
            Text_happy_buy_prass_state:setString(string.format(activity_str_tip[183], ""..max_count))
            Text_happy_buy_prass_dis:setColor(Text_happy_buy_prass_dis.__color)
            Text_happy_buy_prass_state:setColor(Text_happy_buy_prass_state.__color)
        end
    end
    local discount = tonumber(_ED.happy_buy_activity_info.all_count[self.index].discount)
    local percent = (all_total_count - all_current_count) * 100 / max_count
    percent = math.min(percent, 100)
    LoadingBar_happy_buy_prass:setPercent(percent)
    local posX = LoadingBar_happy_buy_prass:getPositionX() + LoadingBar_happy_buy_prass:getContentSize().width * (percent / 100 - 0.5)
    Image_happy_buy_prass_ing:setPositionX(posX)

    local cost_info = zstring.split(self._activity_type.achieve_other_info, ",")
    local old_cost = cost_info[3]
    local cost = math.ceil(old_cost * discount / 10)
    Text_happy_buy_gold_n:setString(cost)
    Text_happy_buy_old_gold_n:setString(old_cost)

    self._cost_gold = cost

    if verifySupportLanguage(_lua_release_language_en) == true then
        discount = (10 - discount) * 10
    end
    Text_happy_buy_discount_n:setString(string.format(activity_str_tip[22], ""..discount))

    -- 按钮状态
    local Button_happy_buy_and_discount = ccui.Helper:seekWidgetByName(root,"Button_happy_buy_and_discount")
    if all_current_count == 0 or current_count == 0 then
        Button_happy_buy_and_discount:setTitleText(red_alert_time_str[231])
        Button_happy_buy_and_discount:setTouchEnabled(false)
        Button_happy_buy_and_discount:setBright(false)
    else
        Button_happy_buy_and_discount:setTitleText(activity_str_tip[168])
        Button_happy_buy_and_discount:setTouchEnabled(true)
        Button_happy_buy_and_discount:setBright(true)
    end

    if ((tonumber(activity_add_state[3])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))) < 0 then
        -- 活动结束
        Button_happy_buy_and_discount:setTouchEnabled(false)
        Button_happy_buy_and_discount:setBright(false)
    end
end 

function RedAlertTimeHappyBuyCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.happy_buy_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeHappyBuyCell.__size == nil then
        RedAlertTimeHappyBuyCell.__size = root:getContentSize()
    end

    for i = 1, 3 do
        local Text_happy_buy_prass_dis = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_prass_dis_"..i)
        local Text_happy_buy_prass_state = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_prass_state_"..i)
        if Text_happy_buy_prass_dis.__color == nil then
            Text_happy_buy_prass_dis.__color = Text_happy_buy_prass_dis:getColor()
        end
        if Text_happy_buy_prass_state.__color == nil then
            Text_happy_buy_prass_state.__color = Text_happy_buy_prass_state:getColor()
        end
        Text_happy_buy_prass_dis:setColor(Text_happy_buy_prass_dis.__color)
        Text_happy_buy_prass_state:setColor(Text_happy_buy_prass_state.__color)
    end

    --领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_happy_buy_and_discount"), nil, 
    {
        terminal_name = "red_alert_time_happy_buy_cell_receive_award", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self
    }, nil, 1)

    self:updateDraw()
end

function RedAlertTimeHappyBuyCell:onEnterTransitionFinish()
    local root = self.roots[1]
    
end

function RedAlertTimeHappyBuyCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_happy_buy_icon = ccui.Helper:seekWidgetByName(root,"Panel_happy_buy_icon")             -- 图标
    local Text_happy_buy_name = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_name")                    -- 名字
    local Text_happy_buy_all_number_n = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_all_number_n")    -- 全服购买数量
    local Text_happy_buy_one_number_n = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_one_number_n")    -- 个人购买数量
    local Text_happy_buy_gold_n = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_gold_n")                -- 当前价格
    local Text_happy_buy_old_gold_n = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_old_gold_n")        -- 原价
    local Text_happy_buy_discount_n = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_discount_n")        -- 折扣
    local LoadingBar_happy_buy_prass = ccui.Helper:seekWidgetByName(root,"LoadingBar_happy_buy_prass")        -- 购买进度
    if Panel_happy_buy_icon ~= nil then
        Panel_happy_buy_icon:removeAllChildren(true)
        Text_happy_buy_name:setString("")
        Text_happy_buy_all_number_n:setString("")
        Text_happy_buy_one_number_n:setString("")
        Text_happy_buy_gold_n:setString("")
        Text_happy_buy_old_gold_n:setString("")
        LoadingBar_happy_buy_prass:setPercent(0)

        for i = 1, 3 do
            local Text_happy_buy_prass_dis = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_prass_dis_"..i)
            local Text_happy_buy_prass_state = ccui.Helper:seekWidgetByName(root,"Text_happy_buy_prass_state_"..i)
            Text_happy_buy_prass_dis:setString("")
            Text_happy_buy_prass_state:setString("")
            Text_happy_buy_prass_dis:setColor(Text_happy_buy_prass_dis.__color)
            Text_happy_buy_prass_state:setColor(Text_happy_buy_prass_state.__color)
        end
    end
end

function RedAlertTimeHappyBuyCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlertTimeHappyBuyCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.happy_buy_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeHappyBuyCell:init(activity_type,index,a_type,group)
    self._activity_type = activity_type
    self.index = index
    self.a_type = a_type
    self.group = group
    -- if index ~= nil and index <= 4 then
       self:onInit()
    -- end
    self:setContentSize(RedAlertTimeHappyBuyCell.__size)
    return self
end

function RedAlertTimeHappyBuyCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.happy_buy_cell, self.roots[1])
end