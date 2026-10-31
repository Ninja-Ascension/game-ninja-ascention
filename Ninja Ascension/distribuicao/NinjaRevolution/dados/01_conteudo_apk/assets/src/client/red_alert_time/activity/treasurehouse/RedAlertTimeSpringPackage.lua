-- ------------------------------------------------------------------------------------------------------------
--  春天好礼
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeSpringPackage = class("RedAlertTimeSpringPackageClass", Window)

local red_alert_time_spring_package_window_open_terminal = {
    _name = "red_alert_time_spring_package_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:open(RedAlertTimeSpringPackage:new():init(params), fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_spring_package_window_close_terminal = {
    _name = "red_alert_time_spring_package_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeSpringPackageClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_spring_package_window_open_terminal)
state_machine.add(red_alert_time_spring_package_window_close_terminal)
state_machine.init()

function RedAlertTimeSpringPackage:ctor()
    self.super:ctor()
    self.roots = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil
    self._activity_type = nil

    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_spring_package_cell")

    local function init_red_alert_time_spring_package_terminal()
        -- 刷新
        local red_alert_time_spring_package_updata_terminal = {
            _name = "red_alert_time_spring_package_updata",
            _init = function (terminal) 
              
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 规则
        local red_alert_time_spring_package_rule_open_terminal = {
            _name = "red_alert_time_spring_package_rule_open",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("red_alert_time_rule_infor_window_open",0,117)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_spring_package_rule_open_terminal)
        state_machine.add(red_alert_time_spring_package_updata_terminal)
        state_machine.init()
    end
    init_red_alert_time_spring_package_terminal()
end

function RedAlertTimeSpringPackage:onUpdateDraw()
    local root = self.roots[1]

    self._activity_type = _ED.activity_info[""..self._activity_type.activity_type]
    local activity_add_state = zstring.split(self._activity_type.activity_add_state,",")

    --名称
    local Text_scientific_quicke_name = ccui.Helper:seekWidgetByName(root,"Text_scientific_quicke_name")
    Text_scientific_quicke_name:setString(self._activity_type.activity_title)
    --介绍
    local Text_scientific_quicke_infor_p_1 = ccui.Helper:seekWidgetByName(root,"Text_scientific_quicke_infor_p_1")
    Text_scientific_quicke_infor_p_1:setString(self._activity_type.activity_dec)
    
    local ListView_scientific_quicke = ccui.Helper:seekWidgetByName(root,"ListView_scientific_quicke")
    ListView_scientific_quicke:jumpToTop()
    ListView_scientific_quicke:removeAllItems()
    local result = self._activity_type.activity_data[1]

    local items = ListView_scientific_quicke:getItems()
    for k,v in pairs(items) do
        state_machine.excute("red_alert_time_spring_package_cell_update_info", 0, {cell = v, info = result[k], a_type = self._activity_type.activity_type, index = k, group = 1})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            ListView_scientific_quicke:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("red_alert_time_spring_package_cell_create", 0, {result[i], i, self._activity_type.activity_type, 1})
            ListView_scientific_quicke:addChild(cell)
        end
    end

    ListView_scientific_quicke:requestRefreshView()
    self._list_view = ListView_scientific_quicke
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    
    --关闭倒计时
    self.m_times = ((tonumber(activity_add_state[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
    local Text_scientific_quicke_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_scientific_quicke_act_time_1")
    Text_scientific_quicke_act_time_1:removeAllChildren(true)
    Text_scientific_quicke_act_time_1:setString("")
    local font_size = Text_scientific_quicke_act_time_1:getFontSize()
    local time_info = cc.Label:createWithTTF(activity_str_tip[93], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info:setName("time_info")
    time_info:setAnchorPoint(cc.p(0, 0.5))
    time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info:setPositionX(0)
    time_info:setPositionY(Text_scientific_quicke_act_time_1:getContentSize().height / 2)
    time_info:setTag(200)
    Text_scientific_quicke_act_time_1:addChild(time_info)
    local time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int:setName("time_int")
    time_int:setAnchorPoint(cc.p(0, 0.5))
    time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int:setPositionX(time_info:getContentSize().width)
    time_int:setPositionY(Text_scientific_quicke_act_time_1:getContentSize().height / 2)
    time_int:setTag(100)
    Text_scientific_quicke_act_time_1:addChild(time_int)
    self._label_close_time = time_int
end

function RedAlertTimeSpringPackage:onUpdate(dt)
    if self.m_times > 0 and self._label_close_time ~= nil then
        self.m_times = self.m_times - dt
        self._label_close_time:setString(getRedAlertTimeActivityFormat(self.m_times))
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_center_find",0,"red_alert_time_spring_package_window_close")
        end
    end

    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_arrow_down:setVisible(true)
        else
            self._Image_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_arrow_up:setVisible(true)
        else
            self._Image_arrow_up:setVisible(false)
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

function RedAlertTimeSpringPackage:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.spring_package)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_scientific_quicke_close"), nil, 
    {
        terminal_name = "red_alert_time_spring_package_window_close", 
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_spring_package_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_spring_package_rule_open", 
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_scientific_quicke_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_scientific_quicke_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_arrow_down:stopAllActions()
    self._Image_arrow_up:stopAllActions()
    playActions(self._Image_arrow_down)
    playActions(self._Image_arrow_up)
    self._Image_arrow_down:setVisible(false)
    self._Image_arrow_up:setVisible(false)

    self:onUpdateDraw()
end

function RedAlertTimeSpringPackage:init(params)
    self._activity_type = params[1]
    self:onInit()
    return self
end

function RedAlertTimeSpringPackage:onExit()
    state_machine.remove("red_alert_time_spring_package_updata")
    state_machine.remove("red_alert_time_spring_package_rule_open")
end