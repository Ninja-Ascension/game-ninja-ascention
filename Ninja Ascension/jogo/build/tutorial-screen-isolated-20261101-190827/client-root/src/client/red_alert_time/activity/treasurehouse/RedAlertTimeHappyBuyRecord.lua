--------------------------------------------------------------------------------------------------------------
--  说明：欢乐团购记录
--------------------------------------------------------------------------------------------------------------
RedAlertTimeHappyBuyRecord = class("RedAlertTimeHappyBuyRecordClass", Window)

--打开界面
local red_alert_time_happy_buy_record_open_terminal = {
    _name = "red_alert_time_happy_buy_record_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = fwin:open(RedAlertTimeHappyBuyRecord:new():init(params), fwin._ui)  
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_happy_buy_record_open_terminal)
state_machine.init()

function RedAlertTimeHappyBuyRecord:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.listview = nil
    self.listview_poy = 0
    self.listview_height = 0
    self._Image_happy_buy_arrow_down = nil
    self._Image_happy_buy_arrow_up = nil
    self._activity_type = 0

    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_happy_buy_record_cell")

    local function init_red_alert_time_happy_buy_record_terminal()
        local red_alert_time_happy_buy_record_show_terminal = {
            _name = "red_alert_time_happy_buy_record_show",
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

        local red_alert_time_happy_buy_record_hide_terminal = {
            _name = "red_alert_time_happy_buy_record_hide",
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

        local red_alert_time_happy_buy_record_update_terminal = {
            _name = "red_alert_time_happy_buy_record_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    local posY = instance.listview_poy
                    instance:updateDraw()
                    if math.abs(posY) > math.abs(instance.listview_height) then
                        posY = instance.listview_height
                    end
                    instance.listview:getInnerContainer():setPositionY(posY)  
                    instance.listview_poy = posY + 1
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_happy_buy_record_show_terminal)
        state_machine.add(red_alert_time_happy_buy_record_hide_terminal)
        state_machine.add(red_alert_time_happy_buy_record_update_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_happy_buy_record_terminal()
end

function RedAlertTimeHappyBuyRecord:updateDraw()
    local root = self.roots[1]
    local activity_info = _ED.activity_info[""..self._activity_type]

    local ListView_happy_buy_list = ccui.Helper:seekWidgetByName(root, "ListView_happy_buy_list")
    ListView_happy_buy_list:jumpToTop()

    local result = {}
    if _ED.happy_buy_activity_info.record_list ~= nil then
        result = _ED.happy_buy_activity_info.record_list
    end

    local items = ListView_happy_buy_list:getItems()
    for k,v in pairs(items) do
        state_machine.excute("red_alert_time_happy_buy_record_cell_update_info", 0, {cell = v, info = result[k], a_type = self._activity_type, index = k})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            ListView_happy_buy_list:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("red_alert_time_happy_buy_record_cell_create", 0, {i, result[i], self._activity_type})
            ListView_happy_buy_list:addChild(cell)
        end
    end

    ListView_happy_buy_list:requestRefreshView()
    self.listview = ListView_happy_buy_list
    self.listview_poy = ListView_happy_buy_list:getInnerContainer():getPositionY()
    self.listview_height = ListView_happy_buy_list:getInnerContainer():getPositionY()
end

function RedAlertTimeHappyBuyRecord:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_happy_buy_arrow_down:setVisible(true)
        else
            self._Image_happy_buy_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_happy_buy_arrow_up:setVisible(true)
        else
            self._Image_happy_buy_arrow_up:setVisible(false)
        end
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
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

function RedAlertTimeHappyBuyRecord:onInit()
    local csbItem = csb.createNode(string.format(config_csb.treasurehouse.happy_buy_tab, 2))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_happy_buy_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_happy_buy_arrow_down")
    self._Image_happy_buy_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_happy_buy_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_happy_buy_arrow_down:stopAllActions()
    self._Image_happy_buy_arrow_up:stopAllActions()
    playActions(self._Image_happy_buy_arrow_down)
    playActions(self._Image_happy_buy_arrow_up)
    self._Image_happy_buy_arrow_down:setVisible(false)
    self._Image_happy_buy_arrow_up:setVisible(false)

    self:updateDraw()
end

function RedAlertTimeHappyBuyRecord:onEnterTransitionFinish()

end

function RedAlertTimeHappyBuyRecord:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeHappyBuyRecord:onExit()
    state_machine.remove("red_alert_time_happy_buy_record_show")
    state_machine.remove("red_alert_time_happy_buy_record_hide")
    state_machine.remove("red_alert_time_happy_buy_record_update")
end