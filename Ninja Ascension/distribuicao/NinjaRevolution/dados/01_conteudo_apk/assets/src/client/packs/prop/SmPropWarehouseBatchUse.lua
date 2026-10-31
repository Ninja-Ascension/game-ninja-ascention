-----------------------------
-- 仓库批量使用
-----------------------------
SmPropWarehouseBatchUse = class("SmPropWarehouseBatchUseClass", Window)

--打开界面
local prop_warehouse_batch_use_open_terminal = {
	_name = "prop_warehouse_batch_use_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmPropWarehouseBatchUseClass") == nil then
			fwin:open(SmPropWarehouseBatchUse:new():init(params), fwin._background)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local prop_warehouse_batch_use_close_terminal = {
	_name = "prop_warehouse_batch_use_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmPropWarehouseBatchUseClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(prop_warehouse_batch_use_open_terminal)
state_machine.add(prop_warehouse_batch_use_close_terminal)
state_machine.init()

function SmPropWarehouseBatchUse:ctor()
	self.super:ctor()
	self.roots = {}

    self.ADDOPERATIONNUM = 1             -- 增加一个
    self.REDUCEOPERATIONNUM = -1          -- 减少一个

    app.load("client.cells.prop.sm_packs_cell")


    local function init_prop_warehouse_batch_use_terminal()
        local prop_warehouse_batch_use_set_min_terminal = {
            _name = "prop_warehouse_batch_use_set_min",
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

        local prop_warehouse_batch_use_set_max_terminal = {
            _name = "prop_warehouse_batch_use_set_max",
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


        local prop_warehouse_batch_use_update_terminal = {
            _name = "prop_warehouse_batch_use_update",
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

        local prop_warehouse_batch_is_use_terminal = {
            _name = "prop_warehouse_batch_is_use",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("prop_warehouse_use_prop_update",0,tonumber(self._select_num))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(prop_warehouse_batch_use_set_min_terminal)
        state_machine.add(prop_warehouse_batch_use_set_max_terminal)
        state_machine.add(prop_warehouse_batch_use_update_terminal)
        state_machine.add(prop_warehouse_batch_is_use_terminal)
        state_machine.init()
    end
    init_prop_warehouse_batch_use_terminal()
end

function SmPropWarehouseBatchUse:init(params)
    self.prop = params
	self:onInit()
    return self
end

function SmPropWarehouseBatchUse:setSelectNum(select_num)
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

function SmPropWarehouseBatchUse:updateSliderInfo(percent)
    local root = self.roots[1]
    local Slider_number_xz = ccui.Helper:seekWidgetByName(root, "Slider_number_xz")
    
    self._current_silder = percent

    if self._max_select_num > 0 and self._select_num == 0 then
        self._select_num = 1
    end
    Slider_number_xz:setPercent(self._current_silder)
    --数量
    local Text_packs_use_n = ccui.Helper:seekWidgetByName(root, "Text_packs_use_n")
    Text_packs_use_n:setString(self._select_num.."/"..self.prop.prop_number)

end

function SmPropWarehouseBatchUse:updateOperationBtn()
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

function SmPropWarehouseBatchUse:onInit()
    local csbItem = csb.createNode("packs/sm_warehouse_batch_use.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "prop_warehouse_batch_use_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    --设置最小
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_min"), nil, 
    {
        terminal_name = "prop_warehouse_batch_use_set_min", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)
    --设置最大
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_max"), nil, 
    {
        terminal_name = "prop_warehouse_batch_use_set_max", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)

    --使用道具
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_use"), nil, 
    {
        terminal_name = "prop_warehouse_batch_is_use", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)

    --头像
    local Panel_packs_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_packs_props_icon")
    Panel_packs_props_icon:removeAllChildren(true)
    local cell = state_machine.excute("sm_packs_cell",0,{self.prop,1})
    Panel_packs_props_icon:addChild(cell)
     --名称
    local Text_packs_props_name = ccui.Helper:seekWidgetByName(root, "Text_packs_props_name")
    local name = dms.string(dms["prop_mould"], self.prop.user_prop_template, prop_mould.prop_name)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        name = setThePropsIcon(self.prop.user_prop_template)[2]
    end
    Text_packs_props_name:setString(name)
    local quality = dms.int(dms["prop_mould"], self.prop.user_prop_template, prop_mould.prop_quality)+1
    Text_packs_props_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))     


    --计算最大值
    local max_tl = zstring.split(dms.string(dms["user_config"], 1 ,user_config.param), ",", function ( value ) return tonumber(value) end)
    local add_num = dms.int(dms["prop_mould"], self.prop.user_prop_template, prop_mould.use_of_combat_food)
    local RemainingNum = max_tl[2] - _ED.user_info.user_food
    local max_count = math.ceil(RemainingNum/add_num)
    if add_num == 0 then
        self._max_select_num = tonumber(self.prop.prop_number)
    else
        if max_count >= tonumber(self.prop.prop_number) then
            self._max_select_num = tonumber(self.prop.prop_number)
        else
            self._max_select_num = max_count
        end
    end
    
    -- local Slider_buy_num
    -- 滑动选择
    local Slider_number_xz = ccui.Helper:seekWidgetByName(root, "Slider_number_xz")
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            state_machine.excute("prop_warehouse_batch_use_update", 0, {sender:getPercent()})
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

function SmPropWarehouseBatchUse:onEnterTransitionFinish()
    
end


function SmPropWarehouseBatchUse:onExit()
	-- state_machine.remove("prop_warehouse_change_page")
end

