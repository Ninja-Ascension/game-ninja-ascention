--------------------------------------------------------------------------------------------------------------
--  愚你同乐 兑换
--------------------------------------------------------------------------------------------------------------
RedAlertTimeAprilFoolsHappyExchange = class("RedAlertTimeAprilFoolsHappyExchangeClass", Window)

--打开界面
local red_alert_time_april_fools_happy_exchange_open_terminal = {
    _name = "red_alert_time_april_fools_happy_exchange_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = fwin:open(RedAlertTimeAprilFoolsHappyExchange:new():init(params), fwin._ui)  
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_april_fools_happy_exchange_open_terminal)
state_machine.init()

function RedAlertTimeAprilFoolsHappyExchange:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._activity_type = 0

    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_april_fools_happy_change_cell")
    
    local function init_red_alert_time_april_fools_happy_exchange_terminal()
        local red_alert_time_april_fools_happy_exchange_show_terminal = {
            _name = "red_alert_time_april_fools_happy_exchange_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_april_fools_happy_exchange_hide_terminal = {
            _name = "red_alert_time_april_fools_happy_exchange_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local red_alert_time_april_fools_happy_exchange_update_draw_terminal = {
            _name = "red_alert_time_april_fools_happy_exchange_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_april_fools_happy_exchange_show_terminal)
        state_machine.add(red_alert_time_april_fools_happy_exchange_hide_terminal)
        state_machine.add(red_alert_time_april_fools_happy_exchange_update_draw_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_april_fools_happy_exchange_terminal()
end

function RedAlertTimeAprilFoolsHappyExchange:updateDraw()
    local root = self.roots[1]
    -- local activity_info = _ED.activity_info[""..self._activity_type]
    local activity_info = _ED.activity_info[""..111]
    local activity_add_state = zstring.split(activity_info.activity_add_state, ",")

    -- activity_add_state = "开始时间,结束时间,领奖时间,道具1id,道具2id,道具3id,道具4id,道具5id,兑换比例"
    activity_add_state = zstring.split("1497628800000,1503158400000,1501237478375,197,207,217,227,228,1", ",")

    -- 道具数量
    for i = 1, 5 do
        local Text_april_fools_happy_card = ccui.Helper:seekWidgetByName(root,"Text_april_fools_happy_card_"..i)
        local Panel_april_fools_happy_card = ccui.Helper:seekWidgetByName(root,"Panel_april_fools_happy_card_"..i)
        Panel_april_fools_happy_card:removeBackGroundImage()

        local prop_id = tonumber(activity_add_state[3 + i])
        local prop = fundPropWidthId(prop_id)
        local count = 0
        if prop ~= nil then
            count = tonumber(prop.prop_number)
        end
        Text_april_fools_happy_card:setString(count)

        local pic_index = dms.string(dms["prop_mould"], prop_id, prop_mould.pic_index)
        pic_index = zstring.split(pic_index, ",")
        Panel_april_fools_happy_card:setBackGroundImage(string.format(config_res.images.ui.props.props, pic_index[1]))
    end

    -- 兑换列表
    local ListView_largesse_give = ccui.Helper:seekWidgetByName(root,"ListView_largesse_give")
    ListView_largesse_give:removeAllItems()

    local result = activity_info.activity_data[1]

    local items = ListView_largesse_give:getItems()
    for k,v in pairs(items) do
        state_machine.excute("red_alert_time_april_fools_happy_change_cell_update_info", 0, {cell = v, info = result[k], a_type = self._activity_type, index = k, group = 1})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            ListView_largesse_give:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("red_alert_time_april_fools_happy_change_cell_create", 0, {result[i], i, self._activity_type, 1})
            ListView_largesse_give:addChild(cell)
        end
    end
    ListView_largesse_give:requestRefreshView()
    self._list_view = ListView_largesse_give
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

--初始化
function RedAlertTimeAprilFoolsHappyExchange:onInit()
    local csbItem = csb.createNode(string.format(config_csb.treasurehouse.april_fools_happy_tab, 2))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    self:updateDraw()
end

function RedAlertTimeAprilFoolsHappyExchange:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function RedAlertTimeAprilFoolsHappyExchange:onEnterTransitionFinish()

end

function RedAlertTimeAprilFoolsHappyExchange:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeAprilFoolsHappyExchange:onExit()
    state_machine.remove("red_alert_time_april_fools_happy_exchange_show")
    state_machine.remove("red_alert_time_april_fools_happy_exchange_hide")
    state_machine.remove("red_alert_time_april_fools_happy_exchange_update_draw")
end