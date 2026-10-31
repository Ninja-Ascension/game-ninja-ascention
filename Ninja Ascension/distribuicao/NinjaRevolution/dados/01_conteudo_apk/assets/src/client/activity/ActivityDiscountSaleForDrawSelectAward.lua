 ----------------------------------------------------------------------------------------------------
-- 说明：折扣贩售选择
-- 注：只会有2个和4个的状态
-------------------------------------------------------------------------------------------------------
ActivityDiscountSaleForDrawSelectAward = class("ActivityDiscountSaleForDrawSelectAwardClass", Window)

local activity_discount_sale_for_draw_select_award_window_open_terminal = {
    _name = "activity_discount_sale_for_draw_select_award_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ActivityDiscountSaleForDrawSelectAwardClass") then
            local selectWindow = ActivityDiscountSaleForDrawSelectAward:new()
            selectWindow:init(params)
            fwin:open(selectWindow, fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_discount_sale_for_draw_select_award_window_close_terminal = {
    _name = "activity_discount_sale_for_draw_select_award_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ActivityDiscountSaleForDrawSelectAwardClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_discount_sale_for_draw_select_award_window_open_terminal)
state_machine.add(activity_discount_sale_for_draw_select_award_window_close_terminal)
state_machine.init()    

function ActivityDiscountSaleForDrawSelectAward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.params = 0
    self.selectIndex = -1
    self._maxCount = 0 --显示的个数
    self._selectCount = 1 --选择的数量
    self._selectMaxCount = 0 --选择的最大个数
    self._cell = nil

    app.load("client.cells.ship.ship_head_cell")
    app.load("client.cells.activity.variety_shop_prop_icon")

    -- Initialize seven days activity for draw ship page state machine.
    local function init_activity_discount_sale_for_draw_select_award_terminal()
        -- -- 选择要领取的物品
        local activity_discount_sale_for_draw_select_award_select_terminal = {
            _name = "activity_discount_sale_for_draw_select_award_select",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.selectIndex = params._datas.selectIndex

                local but_bgImage = nil
                if terminal.page_name ~= nil then
                    but_bgImage = ccui.Helper:seekWidgetByName(instance.roots[1], terminal.page_name)
                    if but_bgImage ~= nil then
                        but_bgImage:setVisible(false)
                    end
                end
                terminal.page_name = params._datas.but_image
                but_bgImage = ccui.Helper:seekWidgetByName(instance.roots[1], terminal.page_name)
                if but_bgImage ~= nil then
                    but_bgImage:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- -- 领取物品
        local activity_discount_sale_for_draw_select_award_request_terminal = {
            _name = "activity_discount_sale_for_draw_select_award_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local target = params._datas.cell
                local cell = target._cell
                if target.selectIndex < 1 then
                    TipDlg.drawTextDailog(_string_piece_info[304])
                    return
                end
				local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots[1] ~= nil then
							response.node._cell:rewadDraw(response.node._cell.index,response.node._selectCount)              -- 刷新兑换列表界面
                            
                            state_machine.excute("activity_discount_sale_for_draw_select_award_window_close",0,0)
                            
						end	
                    end
                end
				protocol_command.activity_superchange_exchange.param_list = cell.index.."\r\n"..cell.activity_id.."\r\n".. target._selectCount .."\r\n".. target.selectIndex
                NetworkManager:register(protocol_command.activity_superchange_exchange.code, nil, nil, nil, target, responseGetServerListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --选择数量
        local activity_discount_sale_for_draw_select_award_change_terminal = {
            _name = "activity_discount_sale_for_draw_select_award_change",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local mCell = params._datas.cell
                local showCount = mCell._selectCount
                local maxCount = mCell._selectMaxCount
                local addValue = params._datas._value
                showCount = showCount + addValue
                if showCount >= maxCount then 
                    showCount = maxCount
                end
                if showCount <=1 then 
                    showCount = 1
                end
                mCell._selectCount = showCount
                mCell:onUpdateSecletCount(showCount)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(activity_discount_sale_for_draw_select_award_select_terminal)
        state_machine.add(activity_discount_sale_for_draw_select_award_request_terminal)
        state_machine.add(activity_discount_sale_for_draw_select_award_change_terminal)
        state_machine.init()
    end
    
    -- call func init seven days activity for draw ship state machine.
    init_activity_discount_sale_for_draw_select_award_terminal()
end


function ActivityDiscountSaleForDrawSelectAward:onUpdateSecletCount(count)
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local textCount = ccui.Helper:seekWidgetByName(root, "Text_buy_12")
    textCount:setString(""..count)
end

function ActivityDiscountSaleForDrawSelectAward:onUpdateDraw()
	local root = self.roots[1]
	local count = self._maxCount
    local startIndex = 0
    if count == 2 then 
        startIndex = 1
        for i = 2, 3 do                     --根据可选择数量显示选择框
            local rewardPad = ccui.Helper:seekWidgetByName(root, "Panel_1"..(i + 1))
            rewardPad:setVisible(true)
        end
    else
        startIndex = 0
        for i = 1, count do                     --根据可选择数量显示选择框
            local rewardPad = ccui.Helper:seekWidgetByName(root, "Panel_1"..(i + 1))
            rewardPad:setVisible(true)
        end
        
    end
	for i, v in ipairs(self._params) do
        local propCell = VarietyShopPropIcon:createCell()
        local tmpType = propCell.enum_type.NONE
        
        propCell:init(tmpType, v._type, v._mould, v._count)
        local propPanel = ccui.Helper:seekWidgetByName(root, "Panel_2" .. startIndex + i - 1)
        if propPanel ~= nil then 
            propPanel:removeAllChildren(true)
            propPanel:addChild(propCell)
        end
    end
    local textCount = ccui.Helper:seekWidgetByName(root, "Text_buy_12")
    if textCount ~= nil then 
        textCount:setString("1")
    end
end

function ActivityDiscountSaleForDrawSelectAward:onEnterTransitionFinish()

    local csbActivityDiscountSaleForDrawSelectAward = csb.createNode("utils/select_award.csb")
    self:addChild(csbActivityDiscountSaleForDrawSelectAward)

    local root = csbActivityDiscountSaleForDrawSelectAward:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("utils/select_award.csb")
    table.insert(self.actions, action)
    csbActivityDiscountSaleForDrawSelectAward:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:play("window_open", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
        elseif str == "close" then
            fwin:close(self)
        end
        
    end)
    for i = 1, 4 do          ---先隐藏4个选择位置
        local rewardPad = ccui.Helper:seekWidgetByName(root, "Panel_1"..(i + 1))
        rewardPad:setVisible(false)
    end
	
    local pl = ccui.Helper:seekWidgetByName(root, "Panel_pl")
    if pl ~= nil then 
        pl:setVisible(true)
    end
	self:onUpdateDraw()
    
	local count = self._maxCount
    if count == 2 then 
        for i = 2, 3 do          -- 根据物品数量添加响应
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_xy_0"..i),       nil, 
            {
                terminal_name = "activity_discount_sale_for_draw_select_award_select",     
                but_image = "Image_"..(37 + i),
                terminal_state = 0, 
                cell = self,
                selectIndex = i - 1,
                isPressedActionEnabled = false
            }, 
            nil, 0)
        end
    else
        for i = 1, count do          -- 根据物品数量添加响应
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_xy_0"..i),       nil, 
            {
                terminal_name = "activity_discount_sale_for_draw_select_award_select",     
                but_image = "Image_"..(37 + i),
                terminal_state = 0, 
                cell = self,
                selectIndex = i,
                isPressedActionEnabled = false
            }, 
            nil, 0)
        end
    end

   -- 领取奖励的事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_10"),       nil, 
    {
        terminal_name = "activity_discount_sale_for_draw_select_award_request",     
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 关闭窗口的事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_11"),       nil, 
    {
        terminal_name = "activity_discount_sale_for_draw_select_award_window_close",     
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 2)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_jian_1"),       nil, 
    {
        terminal_name = "activity_discount_sale_for_draw_select_award_change",     
        terminal_state = 0, 
        _value = -10 ,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 2)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jian_2"),       nil, 
    {
        terminal_name = "activity_discount_sale_for_draw_select_award_change",     
        terminal_state = 0, 
        _value = -1 ,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 2)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jia_1"),       nil, 
    {
        terminal_name = "activity_discount_sale_for_draw_select_award_change",     
        terminal_state = 0, 
        _value = 1 ,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 2)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_jia_2"),       nil, 
    {
        terminal_name = "activity_discount_sale_for_draw_select_award_change",     
        terminal_state = 0, 
        _value = 10000 ,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function ActivityDiscountSaleForDrawSelectAward:onExit()
    state_machine.remove("activity_discount_sale_for_draw_select_award_select")
    state_machine.remove("activity_discount_sale_for_draw_select_award_request")
    state_machine.remove("activity_discount_sale_for_draw_select_award_change")
end

function ActivityDiscountSaleForDrawSelectAward:init(cell)
    self._cell = cell
    self._maxCount = cell.maxcount
    self._params = cell.get_info_arg
    self._selectMaxCount = cell.remainTimes
    return self
end

function ActivityDiscountSaleForDrawSelectAward:createCell()
    local cell = ActivityDiscountSaleForDrawSelectAward:new()
    cell:registerOnNodeEvent(cell)
    return cell
end