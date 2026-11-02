--------------------------------------------------------------------------------------------------------------
--  说明：欢乐团购礼包
--------------------------------------------------------------------------------------------------------------
RedAlertTimeHappyBuyGift = class("RedAlertTimeHappyBuyGiftClass", Window)

--打开界面
local red_alert_time_happy_buy_gift_open_terminal = {
    _name = "red_alert_time_happy_buy_gift_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = fwin:open(RedAlertTimeHappyBuyGift:new():init(params), fwin._ui)  
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_happy_buy_gift_open_terminal)
state_machine.init()

function RedAlertTimeHappyBuyGift:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.listview = nil
    self.listview_poy = 0
    self.listview_height = 0
    self._Image_military_exploit_arrow_down = nil
    self._Image_military_exploit_arrow_up = nil
    self._activity_type = 0

    self.m_times = 0
    self._label_close_text = nil
    self._is_end = false

    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_happy_buy_cell")

    local function init_red_alert_time_happy_buy_gift_terminal()
        local red_alert_time_happy_buy_gift_show_terminal = {
            _name = "red_alert_time_happy_buy_gift_show",
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

        local red_alert_time_happy_buy_gift_hide_terminal = {
            _name = "red_alert_time_happy_buy_gift_hide",
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

        local red_alert_time_happy_buy_gift_update_terminal = {
            _name = "red_alert_time_happy_buy_gift_update",
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

        local red_alert_time_happy_buy_gift_rule_infor_terminal = {
            _name = "red_alert_time_happy_buy_gift_rule_infor",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("red_alert_time_rule_infor_window_open",0,instance._activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_happy_buy_gift_show_terminal)
        state_machine.add(red_alert_time_happy_buy_gift_hide_terminal)
        state_machine.add(red_alert_time_happy_buy_gift_update_terminal)
        state_machine.add(red_alert_time_happy_buy_gift_rule_infor_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_happy_buy_gift_terminal()
end

function RedAlertTimeHappyBuyGift:updateDraw()
    local root = self.roots[1]
    local activity_info = _ED.activity_info[""..self._activity_type]
    local activity_add_state = zstring.split(activity_info.activity_add_state,"|")
    activity_add_state = zstring.split(activity_add_state[1], ",")

    local Text_military_exploit_infor_p_1 = ccui.Helper:seekWidgetByName(root, "Text_military_exploit_infor_p_1")
    Text_military_exploit_infor_p_1:setString(activity_info.activity_dec)

    local result = activity_info.activity_data[1]

    local ListView_military_exploit_list = ccui.Helper:seekWidgetByName(root, "ListView_military_exploit_list")
    ListView_military_exploit_list:jumpToTop()

    local items = ListView_military_exploit_list:getItems()
    for k,v in pairs(items) do
        state_machine.excute("red_alert_time_happy_buy_cell_update_info", 0, {cell = v, info = result[k], a_type = self._activity_type, index = k, group = 1})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            ListView_military_exploit_list:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("red_alert_time_happy_buy_cell_create", 0, {result[i], i, self._activity_type, 1})
            ListView_military_exploit_list:addChild(cell)
        end
    end

    ListView_military_exploit_list:requestRefreshView()
    self.listview = ListView_military_exploit_list
    self.listview_poy = ListView_military_exploit_list:getInnerContainer():getPositionY()
    self.listview_height = ListView_military_exploit_list:getInnerContainer():getPositionY()

    -- 结束和关闭倒计时
    self._is_end = false
    if ((tonumber(activity_add_state[3])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))) < 0 then
        self._is_end = true
    end
    local time_str = activity_str_tip[93]
    if self._is_end == false then
        self.m_times = ((tonumber(activity_add_state[3])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
    else
        self.m_times = ((tonumber(activity_add_state[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        time_str = activity_str_tip[92]
    end

    local Text_military_exploit_time_1 = ccui.Helper:seekWidgetByName(root,"Text_military_exploit_time_1")
    Text_military_exploit_time_1:removeAllChildren(true)
    Text_military_exploit_time_1:setString("")
    local font_size = Text_military_exploit_time_1:getFontSize()
    local time_info = cc.Label:createWithTTF(time_str, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info:setName("time_info")
    time_info:setAnchorPoint(cc.p(0, 0.5))
    time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info:setPositionX(0)
    time_info:setPositionY(Text_military_exploit_time_1:getContentSize().height / 2)
    time_info:setTag(200)
    Text_military_exploit_time_1:addChild(time_info)
    local time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int:setName("time_int")
    time_int:setAnchorPoint(cc.p(0, 0.5))
    time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int:setPositionX(time_info:getContentSize().width)
    time_int:setPositionY(Text_military_exploit_time_1:getContentSize().height / 2)
    time_int:setTag(100)
    Text_military_exploit_time_1:addChild(time_int)
    self._label_close_text = time_int
    self._label_close_text:setString(getRedAlertTimeActivityFormat(self.m_times))
end

function RedAlertTimeHappyBuyGift:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self._label_close_text ~= nil then
            self._label_close_text:setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            if self._is_end == false then
                self:onUpdateDraw()
            else
                state_machine.excute("red_alert_time_center_find",0,"red_alert_time_excavting_comeing_window_close")
            end
        end
    end

    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_military_exploit_arrow_down:setVisible(true)
        else
            self._Image_military_exploit_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_military_exploit_arrow_up:setVisible(true)
        else
            self._Image_military_exploit_arrow_up:setVisible(false)
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

function RedAlertTimeHappyBuyGift:onInit()
    local csbItem = csb.createNode(string.format(config_csb.treasurehouse.happy_buy_tab, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_military_exploit_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_happy_buy_gift_rule_infor", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    self._Image_military_exploit_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_military_exploit_arrow_down")
    self._Image_military_exploit_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_military_exploit_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_military_exploit_arrow_down:stopAllActions()
    self._Image_military_exploit_arrow_up:stopAllActions()
    playActions(self._Image_military_exploit_arrow_down)
    playActions(self._Image_military_exploit_arrow_up)
    self._Image_military_exploit_arrow_down:setVisible(false)
    self._Image_military_exploit_arrow_up:setVisible(false)

    self:updateDraw()
end

function RedAlertTimeHappyBuyGift:onEnterTransitionFinish()

end

function RedAlertTimeHappyBuyGift:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeHappyBuyGift:onExit()
    state_machine.remove("red_alert_time_happy_buy_gift_show")
    state_machine.remove("red_alert_time_happy_buy_gift_hide")
    state_machine.remove("red_alert_time_happy_buy_gift_update")
    state_machine.remove("red_alert_time_happy_buy_gift_rule_infor")
end