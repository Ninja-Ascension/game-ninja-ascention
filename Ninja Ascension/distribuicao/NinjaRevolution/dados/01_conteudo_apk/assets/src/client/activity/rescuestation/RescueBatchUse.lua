-----------------------------
-- 宝可梦救助站批量兑换
-----------------------------
RescueBatchUse = class("RescueBatchUseClass", Window)

--打开界面
local rescue_station_batch_use_open_terminal = {
	_name = "rescue_station_batch_use_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("RescueBatchUseClass") == nil then
			fwin:open(RescueBatchUse:new():init(params), fwin._view)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local rescue_station_batch_use_close_terminal = {
	_name = "rescue_station_batch_use_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RescueBatchUseClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(rescue_station_batch_use_open_terminal)
state_machine.add(rescue_station_batch_use_close_terminal)
state_machine.init()

function RescueBatchUse:ctor()
	self.super:ctor()
	self.roots = {}
    self.prop = {}
    self._id = 0

    self.ADDOPERATIONNUM = 1            -- 增加一个
    self.REDUCEOPERATIONNUM = -1        -- 减少一个
    
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.reward.DrawRareReward")
    app.load("client.activity.rescuestation.RescueStationShop")
    local function init_rescue_station_batch_use_terminal()
        local rescue_station_batch_use_set_min_terminal = {
            _name = "rescue_station_batch_use_set_min",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setSelectNum(1)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local rescue_station_batch_use_set_max_terminal = {
            _name = "rescue_station_batch_use_set_max",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setSelectNum(self._max_select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        local rescue_station_batch_use_update_terminal = {
            _name = "rescue_station_batch_use_update",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Slider_number_xz = ccui.Helper:seekWidgetByName(instance.roots[1], "Slider_number_xz")
                local select_num = math.ceil(tonumber(Slider_number_xz:getPercent()) * instance._max_select_num / 100)
                instance:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local rescue_station_batch_is_use_terminal = {
            _name = "rescue_station_batch_is_use",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function callBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
                        fwin:open(getRewardWnd, fwin._ui)
                        state_machine.excute("rescue_station_shop_update",0,"")  
                        state_machine.excute("rescue_station_batch_use_close",0,"")  
                    end
                end
                protocol_command.activity_pockmon_rescue_exchange.param_list = instance._id.."\r\n"..instance._select_num
                NetworkManager:register(protocol_command.activity_pockmon_rescue_exchange.code, nil, nil, nil, instance, callBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(rescue_station_batch_use_set_min_terminal)
        state_machine.add(rescue_station_batch_use_set_max_terminal)
        state_machine.add(rescue_station_batch_use_update_terminal)
        state_machine.add(rescue_station_batch_is_use_terminal)
        state_machine.init()
    end
    init_rescue_station_batch_use_terminal()
end

function RescueBatchUse:init(params)
    self.prop = params[1]
    self._id = params[2]
 	self:onInit()
    return self
end

function RescueBatchUse:setSelectNum(select_num)
    self._select_num = select_num
    if self._select_num > self._max_select_num then
        self._select_num = self._max_select_num
    end
    if self._select_num <= 0 then
        self._select_num = 1
    end
    local percent = math.floor(self._select_num / self._max_select_num*100)
    self:updateSliderInfo(percent)
end

function RescueBatchUse:updateSliderInfo(percent)
    local root = self.roots[1]
    local Slider_number_xz = ccui.Helper:seekWidgetByName(root, "Slider_number_xz")
    
    self._current_silder = percent

    if self._max_select_num > 0 and self._select_num == 0 then
        self._select_num = 1
    end
    Slider_number_xz:setPercent(self._current_silder)
    --数量
    local Text_packs_use_n = ccui.Helper:seekWidgetByName(root, "Text_packs_use_n")
    Text_packs_use_n:setString(self._select_num.."/"..self._max_select_num)

end

function RescueBatchUse:updateOperationBtn()
    local maxSelectNums = self._max_select_num
    local curSelectNums = self._select_num
    local function operationCallbcak(changeNums, isLongPress, trigger)
        -- 如果选中数值有修改，刷新进度条
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

function RescueBatchUse:onInit()
    local csbItem = csb.createNode("packs/sm_warehouse_batch_use.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "rescue_station_batch_use_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    --设置最小
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_min"), nil, 
    {
        terminal_name = "rescue_station_batch_use_set_min", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)
    --设置最大
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_max"), nil, 
    {
        terminal_name = "rescue_station_batch_use_set_max", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)


    --使用道具
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_use"), nil, 
    {
        terminal_name = "rescue_station_batch_is_use", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)
    
    local Image_up_quality = ccui.Helper:seekWidgetByName(root, "Image_up_quality")  --使用
    Image_up_quality:setVisible(false)

    local Image_change = ccui.Helper:seekWidgetByName(root, "Image_change")  --兑换
    Image_change:setVisible(true)

    local Text_title = ccui.Helper:seekWidgetByName(root, "Text_title")  --标题
    Text_title:setString(tipStringInfo_rescue_station[3])
    --头像
    local Panel_packs_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_packs_props_icon")
    Panel_packs_props_icon:removeAllChildren(true)

    local rewardType = self.prop.type
    local cell = ResourcesIconCell:createCell()
    if 13 == rewardType then
        local table = {}
        -- if rewards[4] ~= nil and tonumber(rewards[4]) ~= -1 then
        --     table.shipStar = tonumber(rewards[4])
        -- end
        cell:init(rewardType,tonumber(self.prop.number),tonumber(self.prop.mould_id),nil,nil,true,true,1,table)
    else
         cell:init(rewardType,-1, tonumber(self.prop.mould_id),nil,nil,true,true,1)
    end
    Panel_packs_props_icon:addChild(cell)

     --名称
    local Text_packs_props_name = ccui.Helper:seekWidgetByName(root, "Text_packs_props_name")
     
    Text_packs_props_name:setString(self.prop.mould_name)
    local quality = self.prop.prop_quality
    Text_packs_props_name:setColor(cc.c3b(color_Type[quality+1][1], color_Type[quality+1][2], color_Type[quality+1][3]))
     
    local remaining_count = 0
    if fundPropWidthId(1468)  then
        remaining_count = math.floor(fundPropWidthId(1468).prop_number/self.prop.sale_percentage)
    end
    --计算最小值
    local max_tl = 0
    if tonumber(self.prop.prop_number) == -1 then
        max_tl = remaining_count
    else
        max_tl = ((self.prop.prop_number < remaining_count) and {self.prop.prop_number} or {remaining_count})[1]
    end
   
    self._max_select_num = max_tl
    -- 滑动选择
    local Slider_number_xz = ccui.Helper:seekWidgetByName(root, "Slider_number_xz")
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            state_machine.excute("rescue_station_batch_use_update", 0, {sender:getPercent()})
        end
    end
    Slider_number_xz:addEventListener(percentChangedEvent)
    
    self:setSelectNum(self._max_select_num)

    -- 减少按钮
    self.Button_2 = ccui.Helper:seekWidgetByName(root,"Button_2")
    -- 逐渐增加按钮
    self.Button_1 = ccui.Helper:seekWidgetByName(root,"Button_1")
    if self.Button_1 ~= nil and self.Button_2 ~= nil then
        self:updateOperationBtn()
    end
end

function RescueBatchUse:onEnterTransitionFinish()
    
end


function RescueBatchUse:onExit()
    state_machine.remove("rescue_station_batch_use_set_min")
    state_machine.remove("rescue_station_batch_use_set_max")
    state_machine.remove("rescue_station_batch_use_update")
    state_machine.remove("rescue_station_batch_is_use")
end

