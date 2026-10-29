-----------------------------
--多选一
-----------------------------
SmPropChoose = class("SmPropChooseClass", Window)

local sm_prop_choose_window_open_terminal = {
    _name = "sm_prop_choose_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		fwin:open(SmPropChoose:new():init(params))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_prop_choose_window_close_terminal = {
    _name = "sm_prop_choose_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SmPropChooseClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_prop_choose_window_open_terminal)
state_machine.add(sm_prop_choose_window_close_terminal)
state_machine.init()

function SmPropChoose:ctor()
    self.super:ctor()
    self.roots = {}

    self._chooseIndex = 1
    self._baseProp = nil
    self._select_num = 1
    self._max_select_num = 0

    self.ADDOPERATIONNUM = 1            -- 增加一个
    self.REDUCEOPERATIONNUM = -1        -- 减少一个

    app.load("client.l_digital.cultivate.silkbag.SilkBagHold")
    local function init_sm_prop_choose_terminal()
        local sm_prop_choose_update_draw_terminal = {
            _name = "sm_prop_choose_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance == nil or instance.roots == nil or instance.roots[1] == nil then
                    return
                end
                instance:clearAllChooseState(params._datas.cell)
                if nil ~= params and nil ~= params._datas._type and 71 == tonumber(params._datas._type) then
                    if fwin:find("SilkBagHoldClass") ~= nil then
                        fwin:close(fwin:find("SilkBagHoldClass"))
                    end
                    local cell = SilkBagHold:new()
      				cell:init(71,params._datas._id, params._datas._table, params._datas.cell)
                    fwin:open(cell, fwin._windows)
                    params._datas.cell:runAction(cc.Sequence:create(cc.DelayTime:create(0.8), 
                        cc.CallFunc:create(function ()
				            if fwin:find("SilkBagHoldClass") ~= nil then
                                fwin:close(fwin:find("SilkBagHoldClass"))
                            end
	                    end
    	            )))
                    
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_prop_choose_update_slider_terminal = {
            _name = "sm_prop_choose_update_slider",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local select_num = math.ceil(tonumber(params[2]) * params[1]._max_select_num / 100)
                params[1]:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_prop_choose_change_num_min_terminal = {
            _name = "sm_prop_choose_change_num_min",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._max_select_num == 0 then
                    return
                end
                instance:setSelectNum(1)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_prop_choose_change_num_max_terminal = {
            _name = "sm_prop_choose_change_num_max",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._max_select_num == 0 then
                    return
                end
                instance:setSelectNum(instance._max_select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_prop_choose_sure_terminal = {
            _name = "sm_prop_choose_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseUsePropCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if fwin:find("SmPropWarehouseBatchUseClass")~= nil then
                            state_machine.excute("prop_warehouse_batch_use_close",0,"")
                        end
                        local rewardList = getSceneReward(4)
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(nil, rewardList)
                        fwin:open(getRewardWnd, fwin._ui)
                        state_machine.excute("sm_all_warehouse_update_draw",0,"")
                        state_machine.excute("sm_consumables_warehouse_update_draw",0,"")
                        state_machine.excute("sm_prop_choose_window_close", 0, nil)
                    end
                end
                protocol_command.prop_use.param_list = instance._baseProp.user_prop_id.."\r\n"..instance._select_num.."\r\n"..instance._chooseIndex
                NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, instance, responseUsePropCallback,false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_prop_choose_update_draw_terminal)
        state_machine.add(sm_prop_choose_update_slider_terminal)
        state_machine.add(sm_prop_choose_change_num_min_terminal)
        state_machine.add(sm_prop_choose_change_num_max_terminal)
        state_machine.add(sm_prop_choose_sure_terminal)
        state_machine.init()
    end
    init_sm_prop_choose_terminal()
end

function SmPropChoose:clearAllChooseState( chooseCell )
    local root = self.roots[1]
    local ListView_2 = ccui.Helper:seekWidgetByName(root, "ListView_2")
    local items = ListView_2:getItems()
    local isSame = false
    for k,v in pairs(items) do
        if v == chooseCell and self._chooseIndex == k then
            isSame = true
        end
    end
    if isSame == true then
        return
    end
    for k,v in pairs(items) do
        if v == chooseCell then
            self._chooseIndex = k
            v:setChooseSelectState(true)
        else
            v:setChooseSelectState(false)
        end
    end
    self._select_num = 1
    self:setSelectNum(self._select_num)
end

function SmPropChoose:setSelectNum(select_num)
    self._select_num = select_num
    if self._select_num > self._max_select_num then
        self._select_num = self._max_select_num
    end
    if self._select_num <= 1 then
        self._select_num = 1
    end

    local percent = math.floor(self._select_num * 100 / self._max_select_num)
    self:updateSliderInfo(percent)
end

function SmPropChoose:updateSliderInfo(percent)
    local root = self.roots[1]
    local Slider_1 = ccui.Helper:seekWidgetByName(root, "Slider_1")
    local Text_shuliang = ccui.Helper:seekWidgetByName(root, "Text_shuliang")
    local Button_max = ccui.Helper:seekWidgetByName(root, "Button_max")
    local Button_min = ccui.Helper:seekWidgetByName(root, "Button_min")

    if self._select_num == self._max_select_num then
        Button_max:setTouchEnabled(false)
        Button_max:setBright(false)
    else
        Button_max:setTouchEnabled(true)
        Button_max:setBright(true)
    end
    if self._select_num == 1 then
        Button_min:setTouchEnabled(false)
        Button_min:setBright(false)
    else
        Button_min:setTouchEnabled(true)
        Button_min:setBright(true)
    end

    Text_shuliang:setString(self._select_num.."/"..self._max_select_num)
    Slider_1:setPercent(percent)
end

function SmPropChoose:onUpdateDraw()
    self._select_num = 1
    local root = self.roots[1]
    local ListView_2 = ccui.Helper:seekWidgetByName(root, "ListView_2")
    ListView_2:removeAllItems()

    local addition_group_index = dms.int(dms["prop_mould"], self._baseProp.user_prop_template, prop_mould.addition_group_index)
    local rewardInfoString = dms.string(dms["scene_reward_ex"], addition_group_index, scene_reward_ex.show_reward)
    local rewardInfoArr = zstring.split(rewardInfoString, "|")
    for i, v in pairs(rewardInfoArr) do
        local info = zstring.split(v, ",")
        local cell = nil
        if info[2] == "6" then
            local reawrdID = tonumber(info[1])
            local rewardNum = tonumber(info[3])
            cell = PropIconCell:createCell()
            cell:hideNameAndCount(false)
            cell:init(39, {user_prop_template = reawrdID, prop_number = rewardNum}, true, nil)
            cell.roots[1]:setPositionY(cell.roots[1]._y+10)
            ListView_2:addChild(cell)
        elseif info[2] == "7" then
            local reawrdID = tonumber(info[1])
            local rewardNum = tonumber(info[3])
            local tmpTable = {
                user_equiment_template = reawrdID,
                mould_id = reawrdID,
                user_equiment_grade = 1
            }
            cell = EquipIconCell:createCell()
            -- cell:hideNameAndCount()
            cell:init(20, tmpTable, reawrdID, nil, true, rewardNum)
            cell.roots[1]:setPositionY(cell.roots[1]._y+10)
            ListView_2:addChild(cell)
            ccui.Helper:seekWidgetByName(cell.roots[1], "Label_name"):setVisible(true)
        elseif info[2] == "13" then
            local star = tonumber(info[4])
            cell = ResourcesIconCell:createCell()
            cell:init(info[2], tonumber(info[3]), tonumber(info[1]), nil, nil, true, true , nil ,{shipStar = star})
            cell:hideCount(true)
            -- cell:showName(-1, tonumber(info[2]))
            cell.roots[1]:setPositionY(cell.roots[1]._y+10)
            ListView_2:addChild(cell)
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop"), nil, 
            {
                terminal_name = "sm_prop_choose_update_draw", 
                terminal_state = 0, 
                cell = cell,
            },
            nil,0)
        elseif info[2] == "71" then
            local property_info = dms.string(dms["ship_silk_bag_mould"],tonumber(info[1]),ship_silk_bag_mould.base_property)
            local basePropertyList = {}
            if nil ~= property_info then
                local add_property_info = zstring.split(property_info,"|")
                for i = 1,table.nums(add_property_info) do
                    local add_property_per = zstring.split(add_property_info[i],",")
                    if nil ~= add_property_per then
                        local a = tipStringInfo_rescue_silkbag_property["0"]
                        local baseProperty ={}
                        baseProperty.property_name = tipStringInfo_rescue_silkbag_property[tostring(add_property_per[1])]
                        baseProperty.property_value = add_property_per[2]
                        basePropertyList[i] = baseProperty
                    end
                end
            end
            cell = ResourcesIconCell:createCell()
            cell:init(info[2], tonumber(info[3]), tonumber(info[1]), nil, nil, true, true , nil ,{basePropertyList,0})
            cell:hideCount(true)
            -- cell:showName(-1, tonumber(info[2]))
            cell.roots[1]:setPositionY(cell.roots[1]._y+10)
            ListView_2:addChild(cell)
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop"), nil, 
            {
                terminal_name = "sm_prop_choose_update_draw", 
                _type = 71,
                _id = tonumber(info[1]),
                _table = {basePropertyList,0},
                cell = cell,
            },
            nil,0)
        elseif info[2] == "73" then

            cell = ResourcesIconCell:createCell()
            cell:init(info[2], tonumber(info[3]), tonumber(info[1]), nil, nil, true, true)
            cell:hideCount(true)
            -- cell:showName(-1, tonumber(info[2]))
            cell.roots[1]:setPositionY(cell.roots[1]._y+10)
            ListView_2:addChild(cell)
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop"), nil, 
            {
                terminal_name = "sm_prop_choose_update_draw", 
                terminal_state = 0,
                _type = 73,
                cell = cell,
            },
            nil,0)
        else
            cell = ResourcesIconCell:createCell()
            cell:init(info[2], tonumber(info[3]), tonumber(info[1]), nil, true, true, true)
            cell:hideCount(true)
            -- cell:showName(-1, tonumber(info[2]))
            cell.roots[1]:setPositionY(cell.roots[1]._y+10)
            ListView_2:addChild(cell)
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop"), nil, 
            {
                terminal_name = "sm_prop_choose_update_draw", 
                terminal_state = 0,
                cell = cell,
            },
            nil,0)
        end
        if i == 1 then
            cell:setChooseSelectState(true)
        end
    end
    self:setSelectNum(self._select_num)
end

function SmPropChoose:updateOperationBtn()
    local maxSelectNums = self._max_select_num
    local curSelectNums = self._select_num
    local function operationCallbcak(changeNums, isLongPress, trigger)
        -- 如果选中数值有修改
        if changeNums ~= nil then
            local haveCount = self._select_num + changeNums
            if haveCount >= 1 and haveCount <= maxSelectNums then
                -- 刷新进度条
                self._select_num = haveCount
                local percent = math.floor(self._select_num / maxSelectNums*100)
                self:updateSliderInfo(percent)
            end
            if isLongPress then
                if self._select_num <= 1 or self._select_num >= maxSelectNums then
                    trigger:stopAllActions()
                end
            end
        else
            -- 如果没修改则返回当前选择的数量和最大选择数量
            return self._select_num, self._max_select_num
        end
    end
    BatchUseBtnRegisterTouchEvent(self.Button_1, self.ADDOPERATIONNUM, operationCallbcak)
    BatchUseBtnRegisterTouchEvent(self.Button_2, self.REDUCEOPERATIONNUM, operationCallbcak)
end

function SmPropChoose:onEnterTransitionFinish()

end

function SmPropChoose:onInit( )
    local csbItem = csb.createNode("utils/prompt_select.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    
    local action = csb.createTimeline("utils/prompt_select.csb")
    csbItem:runAction(action)
    action:play("window_open", false)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4_8"), nil, 
    {
        terminal_name = "sm_prop_choose_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_max"), nil, 
    {
        terminal_name = "sm_prop_choose_change_num_max", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_min"), nil, 
    {
        terminal_name = "sm_prop_choose_change_num_min", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3_6_2"), nil, 
    {
        terminal_name = "sm_prop_choose_sure", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
    }, nil, 1)
    
    local Slider_1 = ccui.Helper:seekWidgetByName(root, "Slider_1")
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            state_machine.excute("sm_prop_choose_update_slider", 0, {sender._self, sender:getPercent()})
        end
    end
    Slider_1._self = self
    Slider_1:addEventListener(percentChangedEvent)

    self:onUpdateDraw()

    -- 减少按钮
    self.Button_2 = ccui.Helper:seekWidgetByName(root,"Button_2")
    -- 逐渐增加按钮
    self.Button_1 = ccui.Helper:seekWidgetByName(root,"Button_1")

    if self.Button_1 ~= nil and self.Button_2 ~= nil then
        self:updateOperationBtn()
    end
end

function SmPropChoose:init(params)
    self._baseProp = params
    self._max_select_num = tonumber(self._baseProp.prop_number)
	self:onInit()
    return self
end

function SmPropChoose:onExit()
    if fwin:find("SilkBagHoldClass") ~= nil then
        fwin:close(fwin:find("SilkBagHoldClass"))
    end
    -- state_machine.remove("sm_all_warehouse_update_draw")
    state_machine.remove("sm_prop_choose_update_slider")
    state_machine.remove("sm_prop_choose_change_num_min")
    state_machine.remove("sm_prop_choose_change_num_max")
    state_machine.remove("sm_prop_choose_sure")
end
