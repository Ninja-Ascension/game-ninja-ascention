--------------------------------------------------------------------------------------------------------------
--  说明：火力全开界面1
--------------------------------------------------------------------------------------------------------------
RedAlertTimeFullVitalityTransfer = class("RedAlertTimeFullVitalityTransferClass", Window)

--打开界面
local red_alert_time_full_vitality_transfer_open_terminal = {
    _name = "red_alert_time_full_vitality_transfer_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = fwin:open(RedAlertTimeFullVitalityTransfer:new():init(params), fwin._ui)  
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_full_vitality_transfer_open_terminal)
state_machine.init()

function RedAlertTimeFullVitalityTransfer:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._m_type = 0
    self.m_times = 0
    self.m_reset_times = 0
    self.accept_the_prize = false
    self._Image_full_vitality_arrow_down = nil
    self._Image_full_vitality_arrow_up = nil

    self._label_close_text = nil
    self._label_reset_text = nil

    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_full_vitality_cell")
    
    local function init_red_alert_time_full_vitality_transfer_terminal()
        local red_alert_time_full_vitality_transfer_show_terminal = {
            _name = "red_alert_time_full_vitality_transfer_show",
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

        local red_alert_time_full_vitality_transfer_hide_terminal = {
            _name = "red_alert_time_full_vitality_transfer_hide",
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
        local red_alert_time_full_vitality_transfer_updata_terminal = {
            _name = "red_alert_time_full_vitality_transfer_updata",
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

        state_machine.add(red_alert_time_full_vitality_transfer_updata_terminal)
        state_machine.add(red_alert_time_full_vitality_transfer_hide_terminal)
        state_machine.add(red_alert_time_full_vitality_transfer_show_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_full_vitality_transfer_terminal()
end

function RedAlertTimeFullVitalityTransfer:updateDraw()
    local root = self.roots[1]
    self._activity_type = _ED.activity_info[""..self._activity_type.activity_type]
    local Text_full_vitality_infor_p_1 = ccui.Helper:seekWidgetByName(root,"Text_full_vitality_infor_p_1")
    Text_full_vitality_infor_p_1:setString(self._activity_type.activity_dec)
    
    -- 时间
    local activity_add_state = zstring.split(self._activity_type.activity_add_state,",")
    local isEnd = false
    if tonumber(activity_add_state[3])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
        isEnd = false
    else
        isEnd = true
    end
    self.accept_the_prize = isEnd
    local time_str = ""
    if isEnd == true then
        self.m_times = ((tonumber(activity_add_state[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        time_str = activity_str_tip[92]
    else
        self.m_times = ((tonumber(activity_add_state[3])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        time_str = activity_str_tip[93]
    end

    -- 结束和关闭倒计时
    local Text_full_vitality_time_1 = ccui.Helper:seekWidgetByName(root,"Text_full_vitality_time_1")
    Text_full_vitality_time_1:removeAllChildren(true)
    Text_full_vitality_time_1:setString("")
    local font_size = Text_full_vitality_time_1:getFontSize()
    local time_info = cc.Label:createWithTTF(time_str, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info:setName("time_info")
    time_info:setAnchorPoint(cc.p(0, 0.5))
    time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info:setPositionX(0)
    time_info:setPositionY(Text_full_vitality_time_1:getContentSize().height / 2)
    time_info:setTag(200)
    Text_full_vitality_time_1:addChild(time_info)
    local time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int:setName("time_int")
    time_int:setAnchorPoint(cc.p(0, 0.5))
    time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int:setPositionX(time_info:getContentSize().width)
    time_int:setPositionY(Text_full_vitality_time_1:getContentSize().height / 2)
    time_int:setTag(100)
    Text_full_vitality_time_1:addChild(time_int)
    self._label_close_text = time_int
    self._label_close_text:setString(getRedAlertTimeActivityFormat(self.m_times))

    -- 重置时间
    local Text_full_vitality_time_2 = ccui.Helper:seekWidgetByName(root,"Text_full_vitality_time_2")
    Text_full_vitality_time_2:removeAllChildren(true)
    Text_full_vitality_time_2:setString("")
    local server_time = getCurrentGTM8Time()
    self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1
    local time_info_2 = cc.Label:createWithTTF(activity_str_tip[94], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info_2:setName("time_info_2")
    time_info_2:setAnchorPoint(cc.p(1, 0.5))
    time_info_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info_2:setPositionX(Text_full_vitality_time_2:getContentSize().width - 80)
    time_info_2:setPositionY(Text_full_vitality_time_2:getContentSize().height / 2)
    time_info_2:setTag(200)
    Text_full_vitality_time_2:addChild(time_info_2)
    local time_int_2 = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int_2:setName("time_int_2")
    time_int_2:setAnchorPoint(cc.p(0, 0.5))
    time_int_2:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int_2:setPositionX(Text_full_vitality_time_2:getContentSize().width - 80)
    time_int_2:setPositionY(Text_full_vitality_time_2:getContentSize().height / 2)
    time_int_2:setTag(100)
    Text_full_vitality_time_2:addChild(time_int_2)
    self._label_reset_text = time_int_2
    self._label_reset_text:setString(getRedAlertTimeActivityFormat(self.m_reset_times))

    local ListView_full_vitalitylist = ccui.Helper:seekWidgetByName(root,"ListView_full_vitalitylist")
    ListView_full_vitalitylist:removeAllItems()

    local index = 1
    for i=1, #self._activity_type.activity_data[1] do
        local cell = state_machine.excute("red_alert_time_full_vitality_cell_create",0,{self._activity_type.activity_data[1][i] ,self._activity_type.activity_type,i })
        ListView_full_vitalitylist:addChild(cell)
        index = index + 1 
    end
    ListView_full_vitalitylist:requestRefreshView()
    self._list_view = ListView_full_vitalitylist
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

--初始化
function RedAlertTimeFullVitalityTransfer:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.full_vitality_tab_1)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_military_exploit_plunder"), nil, 
    {
        terminal_name = "red_alert_time_full_vitality_transfer_explore", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    self._Image_full_vitality_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_full_vitality_arrow_down")
    self._Image_full_vitality_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_full_vitality_arrow_up")
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_full_vitality_arrow_down:stopAllActions()
    self._Image_full_vitality_arrow_up:stopAllActions()
    playActions(self._Image_full_vitality_arrow_down)
    playActions(self._Image_full_vitality_arrow_up)
    self._Image_full_vitality_arrow_down:setVisible(false)
    self._Image_full_vitality_arrow_up:setVisible(false)

    self:updateDraw()
end

function RedAlertTimeFullVitalityTransfer:onUpdate(dt)
    if self.m_reset_times > 0 then
        self.m_reset_times = self.m_reset_times - dt
        if self._label_reset_text ~= nil then
            self._label_reset_text:setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        end
        if self.m_reset_times <= 0 then
            self.m_reset_times = 0
            self:onUpdateDraw()
        end
    end

    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self._label_close_text ~= nil then
            self._label_close_text:setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            if self.accept_the_prize == true then
                state_machine.excute("red_alert_time_center_find",0,"red_alert_time_full_vitality_window_close")
            else
                self:updateDraw()
                state_machine.excute("notification_center_update", 0, "push_notification_treasurehouse_full_vitality_rank")
            end
        end
    end
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_full_vitality_arrow_down:setVisible(true)
        else
            self._Image_full_vitality_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_full_vitality_arrow_up:setVisible(true)
        else
            self._Image_full_vitality_arrow_up:setVisible(false)
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

function RedAlertTimeFullVitalityTransfer:onEnterTransitionFinish()

end

function RedAlertTimeFullVitalityTransfer:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeFullVitalityTransfer:onExit()
    state_machine.remove("red_alert_time_full_vitality_transfer_show")
    state_machine.remove("red_alert_time_full_vitality_transfer_hide")
    state_machine.remove("red_alert_time_full_vitality_transfer_updata")
end