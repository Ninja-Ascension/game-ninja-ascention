----------------------------------------------------------------------------------------------------
-- 说明：折扣贩售批量购买
-------------------------------------------------------------------------------------------------------
ActivityDiscountSaleBatchBuy = class("ActivityDiscountSaleBatchBuyClass", Window)

local activity_discount_sale_batch_buy_window_open_terminal = {
    _name = "activity_discount_sale_batch_buy_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ActivityDiscountSaleBatchBuyClass") then
            local selectWindow = ActivityDiscountSaleBatchBuy:new()
            selectWindow:init(params)
            fwin:open(selectWindow, fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_discount_sale_batch_buy_window_close_terminal = {
    _name = "activity_discount_sale_batch_buy_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ActivityDiscountSaleBatchBuyClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_discount_sale_batch_buy_window_open_terminal)
state_machine.add(activity_discount_sale_batch_buy_window_close_terminal)
state_machine.init()    

function ActivityDiscountSaleBatchBuy:ctor()
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
    local function init_activity_discount_sale_batch_buy_terminal()
        
        -- -- 领取物品
        local activity_discount_sale_batch_buy_request_terminal = {
            _name = "activity_discount_sale_batch_buy_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local target = params._datas.cell
                local cell = target._cell
				local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots[1] ~= nil then
							response.node._cell:rewadDraw(response.node._cell.index,response.node._selectCount)              -- 刷新兑换列表界面
                            state_machine.excute("activity_discount_sale_batch_buy_window_close",0,0)
						end	
                    end
                end
				protocol_command.activity_superchange_exchange.param_list = cell.index.."\r\n"..cell.activity_id.."\r\n".. target._selectCount .."\r\n".. 1
                NetworkManager:register(protocol_command.activity_superchange_exchange.code, nil, nil, nil, target, responseGetServerListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --选择数量
        local activity_discount_sale_batch_buy_change_terminal = {
            _name = "activity_discount_sale_batch_buy_change",
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
        state_machine.add(activity_discount_sale_batch_buy_request_terminal)
        state_machine.add(activity_discount_sale_batch_buy_change_terminal)
        state_machine.init()
    end
    
    -- call func init seven days activity for draw ship state machine.
    init_activity_discount_sale_batch_buy_terminal()
end

function ActivityDiscountSaleBatchBuy:onUpdateSecletCount(count)
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local textCount = ccui.Helper:seekWidgetByName(root, "Text_buy_12")
    textCount:setString(""..count)
end

function ActivityDiscountSaleBatchBuy:onUpdateDraw()
	local root = self.roots[1]
	local count = self._maxCount
    local Panel_401 = ccui.Helper:seekWidgetByName(root, "Panel_401")
    Panel_401:setVisible(true)
	for i, v in ipairs(self._params) do
        local propCell = VarietyShopPropIcon:createCell()
        local tmpType = propCell.enum_type.NONE
        propCell:init(tmpType, v._type, v._mould, v._count,true)
        local propPanel = ccui.Helper:seekWidgetByName(root, "Panel_dj_tx")
        if propPanel ~= nil then 
            propPanel:removeAllChildren(true)
            propPanel:addChild(propCell)
        end
        ccui.Helper:seekWidgetByName(root, "Text_buy_1"):setString(""..propCell._iconName)
        ccui.Helper:seekWidgetByName(root, "Text_buy_3"):setString(""..propCell._iconCounts)
        break
    end
    local textCount = ccui.Helper:seekWidgetByName(root, "Text_buy_12")
    textCount:setString("1")
    local tipString = ""
    if __lua_project_id == __lua_project_gragon_tiger_gate
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then 
        tipString = string.format(_string_piece_info[430],self._selectMaxCount)
    else
        tipString = string.format(_string_piece_info[388],self._selectMaxCount)
    end
    ccui.Helper:seekWidgetByName(root, "Text_buy_4"):setString(tipString)
end

function ActivityDiscountSaleBatchBuy:onEnterTransitionFinish()

    local csbActivityDiscountSaleBatchBuy = csb.createNode("shop/buy_props.csb")
    self:addChild(csbActivityDiscountSaleBatchBuy)

    local root = csbActivityDiscountSaleBatchBuy:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("shop/buy_props.csb")
    table.insert(self.actions, action)
    csbActivityDiscountSaleBatchBuy:runAction(action)
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
   
    local Panel_8 = ccui.Helper:seekWidgetByName(root, "Panel_8")
    Panel_8:setVisible(false)
    
    self:onUpdateDraw()
   -- 领取奖励的事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gmdj_2"),       nil, 
    {
        terminal_name = "activity_discount_sale_batch_buy_request",     
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 关闭窗口的事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gmdj_1"),       nil, 
    {
        terminal_name = "activity_discount_sale_batch_buy_window_close",     
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 2)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"),       nil, 
    {
        terminal_name = "activity_discount_sale_batch_buy_window_close",     
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 2)


    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_jian_1"),       nil, 
    {
        terminal_name = "activity_discount_sale_batch_buy_change",     
        terminal_state = 0, 
        _value = -10 ,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 2)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jian_2"),       nil, 
    {
        terminal_name = "activity_discount_sale_batch_buy_change",     
        terminal_state = 0, 
        _value = -1 ,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 2)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jia_1"),       nil, 
    {
        terminal_name = "activity_discount_sale_batch_buy_change",     
        terminal_state = 0, 
        _value = 1 ,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 2)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_jia_2"),       nil, 
    {
        terminal_name = "activity_discount_sale_batch_buy_change",     
        terminal_state = 0, 
        _value = 10 ,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function ActivityDiscountSaleBatchBuy:onExit()
    state_machine.remove("activity_discount_sale_batch_buy_request")
    state_machine.remove("activity_discount_sale_batch_buy_change")
end

function ActivityDiscountSaleBatchBuy:init(cell)
    self._cell = cell
    self._maxCount = cell.maxcount
    self._params = cell.need_info_arg
    self._selectMaxCount = cell.remainTimes
    return self
end

function ActivityDiscountSaleBatchBuy:createCell()
    local cell = ActivityDiscountSaleBatchBuy:new()
    cell:registerOnNodeEvent(cell)
    return cell
end