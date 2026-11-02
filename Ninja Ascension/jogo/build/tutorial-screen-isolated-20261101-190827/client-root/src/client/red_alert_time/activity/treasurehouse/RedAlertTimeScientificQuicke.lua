-- ------------------------------------------------------------------------------------------------------------
--  活力驱动
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeScientificQuicke = class("RedAlertTimeScientificQuickeClass", Window)

local red_alert_time_scientific_quicke_window_open_terminal = {
	_name = "red_alert_time_scientific_quicke_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("RedAlertTimeScientificQuickeClass") == nil then
            fwin:open(RedAlertTimeScientificQuicke:new():init(params), fwin._ui)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local red_alert_time_scientific_quicke_window_close_terminal = {
	_name = "red_alert_time_scientific_quicke_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeScientificQuickeClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(red_alert_time_scientific_quicke_window_open_terminal)
state_machine.add(red_alert_time_scientific_quicke_window_close_terminal)
state_machine.init()

function RedAlertTimeScientificQuicke:ctor()
	self.super:ctor()
	self.roots = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil
    self._activity_type = {}
    self._count = 0    --加速开启数

    self._label_close_time = nil

	app.load("client.red_alert_time.cells.activity.treasurehouse.activity_scientific_quicke_cell")
    local function init_red_alert_time_scientific_quicke_terminal()
        -- 刷新
        local red_alert_time_scientific_quicke_updata_terminal = {
            _name = "red_alert_time_scientific_quicke_updata",
            _init = function (terminal) 
              
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 规则
        local red_alert_time_scientific_quicke_rule_open_terminal = {
            _name = "red_alert_time_scientific_quicke_rule_open",
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
        state_machine.add(red_alert_time_scientific_quicke_rule_open_terminal)
        state_machine.add(red_alert_time_scientific_quicke_updata_terminal)
        state_machine.init()
    end
    init_red_alert_time_scientific_quicke_terminal()
end

function RedAlertTimeScientificQuicke:onUpdateDraw()
    local root = self.roots[1]
	local ListView_scientific_quicke = ccui.Helper:seekWidgetByName(root,"ListView_scientific_quicke")
    ListView_scientific_quicke:jumpToTop()
    ListView_scientific_quicke:removeAllItems()
    
    local result = _ED.activity_info[""..self._activity_type.activity_type].activity_data[1]

    for k, v in pairs(result) do
        local cell = state_machine.excute("activity_scientific_quicke_create_cell", 0, {k, v, self._activity_type.activity_type})
        ListView_scientific_quicke:addChild(cell)
    end

    ListView_scientific_quicke:requestRefreshView()
    self._list_view = ListView_scientific_quicke
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()


    self._activity_type = _ED.activity_info[""..self._activity_type.activity_type]
    local activity_info = zstring.split(self._activity_type.activity_add_state,"!")
    local activity_add_state = zstring.split(activity_info[1],",")
    --名称
    local Text_scientific_quicke_name = ccui.Helper:seekWidgetByName(root,"Text_scientific_quicke_name")
    Text_scientific_quicke_name:setString(self._activity_type.activity_title)
    --介绍
    local Text_scientific_quicke_infor_p_1 = ccui.Helper:seekWidgetByName(root,"Text_scientific_quicke_infor_p_1")
    Text_scientific_quicke_infor_p_1:setString(self._activity_type.activity_dec)
    
    --关闭倒计时
    self.m_times = ((tonumber(activity_add_state[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
    local Text_scientific_quicke_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_scientific_quicke_act_time_1")
    Text_scientific_quicke_act_time_1:removeAllChildren(true)
    Text_scientific_quicke_act_time_1:setString("")
    Text_scientific_quicke_act_time_1:setVisible(true)
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
    --正在加速
    local Text_scientific_quicke_n = ccui.Helper:seekWidgetByName(root,"Text_scientific_quicke_n")
    local other_info = zstring.split(self._activity_type.activity_add_state, "!")
    local time_info = zstring.split(other_info[1], ",")
    local start_time = tonumber(time_info[1]/1000)
    local open_info = zstring.split(other_info[2], "|")
    for k,v in pairs(open_info) do
        local _open_info = zstring.split(v, ",")
        local current_time = os.time() + _ED.time_add_or_sub
        self._tick_time = (tonumber(_open_info[1])) * 3600-(current_time - start_time)      
        if self._tick_time <= 0 then
            self._count = self._count + 1
        end
    end
    Text_scientific_quicke_n:setString(self._count.."/"..#open_info) 
end

function RedAlertTimeScientificQuicke:onUpdate(dt)
    if self.m_times > 0 and self._label_close_time ~= nil then
        self.m_times = self.m_times - dt
        self._label_close_time:setString(getRedAlertTimeActivityFormat(self.m_times))
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("red_alert_time_center_find",0,"red_alert_time_scientific_quicke_window_close")
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

function RedAlertTimeScientificQuicke:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.scientific_quicke)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_scientific_quicke_close"), nil, 
    {
        terminal_name = "red_alert_time_scientific_quicke_window_close", 
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_scientific_quicke_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_scientific_quicke_rule_open", 
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

function RedAlertTimeScientificQuicke:init(params)
    self._activity_type = params[1]
	self:onInit()
    return self
end

function RedAlertTimeScientificQuicke:onExit()
    state_machine.remove("red_alert_time_scientific_quicke_updata")
    state_machine.remove("red_alert_time_scientific_quicke_rule_open")
end