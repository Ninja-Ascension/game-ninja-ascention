--------------------------------------------------------------------------------------------------------------
--  说明：愚你同乐 收集
--------------------------------------------------------------------------------------------------------------
RedAlertTimeAprilFoolsHappyCollection = class("RedAlertTimeAprilFoolsHappyCollectionClass", Window)

--打开界面
local red_alert_time_april_fools_happy_collection_open_terminal = {
    _name = "red_alert_time_april_fools_happy_collection_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = fwin:open(RedAlertTimeAprilFoolsHappyCollection:new():init(params), fwin._ui)  
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_april_fools_happy_collection_open_terminal)
state_machine.init()

function RedAlertTimeAprilFoolsHappyCollection:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._activity_type = 0

    self._is_end = false
    self.m_times = 0
    self._label_close_text = nil
    
    local function init_red_alert_time_april_fools_happy_collection_terminal()
        local red_alert_time_april_fools_happy_collection_show_terminal = {
            _name = "red_alert_time_april_fools_happy_collection_show",
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

        local red_alert_time_april_fools_happy_collection_hide_terminal = {
            _name = "red_alert_time_april_fools_happy_collection_hide",
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
        local red_alert_time_april_fools_happy_collection_update_draw_terminal = {
            _name = "red_alert_time_april_fools_happy_collection_update_draw",
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

        -- 合成
        local red_alert_time_april_fools_happy_collection_compose_terminal = {
            _name = "red_alert_time_april_fools_happy_collection_compose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local acitvity = _ED.activity_info[""..instance._activity_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
                        checkRewardObtainDraw()
                        state_machine.excute("red_alert_time_april_fools_happy_exchange_update_draw", 0, "")
                    end
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..instance._activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."1"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 收集
        local red_alert_time_april_fools_happy_collection_mine_terminal = {
            _name = "red_alert_time_april_fools_happy_collection_mine",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 未确定
                -- state_machine.excute("red_alert_time_april_fools_happy_window_close", 0, "")
                -- state_machine.excute("red_alert_time_center_window_close", 0, "")
                -- state_machine.excute("short_cut_go_to_other_window",0,{16})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 规则
        local red_alert_time_april_fools_happy_collection_rule_open_terminal = {
            _name = "red_alert_time_april_fools_happy_collection_rule_open",
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

        state_machine.add(red_alert_time_april_fools_happy_collection_show_terminal)
        state_machine.add(red_alert_time_april_fools_happy_collection_hide_terminal)
        state_machine.add(red_alert_time_april_fools_happy_collection_update_draw_terminal)
        state_machine.add(red_alert_time_april_fools_happy_collection_compose_terminal)
        state_machine.add(red_alert_time_april_fools_happy_collection_mine_terminal)
        state_machine.add(red_alert_time_april_fools_happy_collection_rule_open_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_april_fools_happy_collection_terminal()
end

function RedAlertTimeAprilFoolsHappyCollection:updateDraw()
    local root = self.roots[1]
    local activity_info = _ED.activity_info[""..self._activity_type]
    local activity_add_state = zstring.split(activity_info.activity_add_state, ",")

    -- activity_add_state = "开始时间,结束时间,领奖时间,道具1id,道具2id,道具3id,道具4id,道具5id,兑换比例"
    activity_add_state = zstring.split("1497628800000,1503158400000,1501237478375,197,207,217,227,228,1", ",")

    -- 活动描述,时间
    local Text_april_fools_happy_p = ccui.Helper:seekWidgetByName(root, "Text_april_fools_happy_p")
    Text_april_fools_happy_p:setString(activity_info.activity_dec)

    self._is_end = false
    local time_str = activity_str_tip[93]
    if (tonumber(activity_add_state[3]) / 1000) >= (os.time() + _ED.time_add_or_sub) then   
        self.m_times = (tonumber(activity_add_state[3]) / 1000) - (os.time() + _ED.time_add_or_sub)
    else 
        self._is_end = true
        time_str = activity_str_tip[179]
        self.m_times = (tonumber(activity_add_state[2]) / 1000) - (os.time() + _ED.time_add_or_sub)
    end

    local Text_april_fools_happy_time_1 = ccui.Helper:seekWidgetByName(root,"Text_april_fools_happy_time_1")
    Text_april_fools_happy_time_1:removeAllChildren(true)
    Text_april_fools_happy_time_1:setString("")
    local font_size = Text_april_fools_happy_time_1:getFontSize()
    local time_info = cc.Label:createWithTTF(time_str, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info:setName("time_info")
    time_info:setAnchorPoint(cc.p(0, 0.5))
    time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info:setPositionX(0)
    time_info:setPositionY(Text_april_fools_happy_time_1:getContentSize().height / 2)
    time_info:setTag(200)
    Text_april_fools_happy_time_1:addChild(time_info)
    local time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int:setName("time_int")
    time_int:setAnchorPoint(cc.p(0, 0.5))
    time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int:setPositionX(time_info:getContentSize().width)
    time_int:setPositionY(Text_april_fools_happy_time_1:getContentSize().height / 2)
    time_int:setTag(100)
    Text_april_fools_happy_time_1:addChild(time_int)
    self._label_close_text = time_int
    self._label_close_text:setString(getRedAlertTimeActivityFormat(self.m_times))

    -- 图章显示
    local prop_count_tables = {0, 0, 0, 0, 0}
    for i = 1, 5 do
        local Panel_april_fools_happy_icon = ccui.Helper:seekWidgetByName(root,"Panel_april_fools_happy_icon_"..i)
        Panel_april_fools_happy_icon:removeAllChildren(true)
        local prop_id = tonumber(activity_add_state[3 + i])
        local prop = fundPropWidthId(prop_id)
        if prop ~= nil then
            prop_count_tables[i] = tonumber(prop.prop_number)
        end
        local cell = state_machine.excute("props_icon_create_cell", 0, {6, 1, prop_id, 1})
        Panel_april_fools_happy_icon:addChild(cell)
    end

    -- 按钮状态
    local need_count = tonumber(activity_add_state[9])
    local Button_april_fools_happy_synthesis = ccui.Helper:seekWidgetByName(root,"Button_april_fools_happy_synthesis")
    local can_compose = true
    for i = 1, 4 do
        if prop_count_tables[i] < need_count then
            can_compose = false
            break
        end
    end
    if can_compose == false then
        Button_april_fools_happy_synthesis:setTouchEnabled(false)
        Button_april_fools_happy_synthesis:setBright(false)
    else
        Button_april_fools_happy_synthesis:setTouchEnabled(true)
        Button_april_fools_happy_synthesis:setBright(true)
    end
end

function RedAlertTimeAprilFoolsHappyCollection:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self._label_close_text ~= nil then
            self._label_close_text:setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times < 0 then
            self.m_times = 0
            if self._is_end == false then
                self:updateDraw()
            end
        end
    end
end

--初始化
function RedAlertTimeAprilFoolsHappyCollection:onInit()
    local csbItem = csb.createNode(string.format(config_csb.treasurehouse.april_fools_happy_tab, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)  

    --合成
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_april_fools_happy_synthesis"), nil, 
    {
        terminal_name = "red_alert_time_april_fools_happy_collection_compose", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    --收集
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_april_fools_happy_collect"), nil, 
    {
        terminal_name = "red_alert_time_april_fools_happy_collection_mine", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    --规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_april_fools_happy_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_april_fools_happy_collection_rule_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    self:updateDraw()
end

function RedAlertTimeAprilFoolsHappyCollection:onEnterTransitionFinish()

end

function RedAlertTimeAprilFoolsHappyCollection:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeAprilFoolsHappyCollection:onExit()
    state_machine.remove("red_alert_time_april_fools_happy_collection_show")
    state_machine.remove("red_alert_time_april_fools_happy_collection_hide")
    state_machine.remove("red_alert_time_april_fools_happy_collection_update_draw")
    state_machine.remove("red_alert_time_april_fools_happy_collection_compose")
    state_machine.remove("red_alert_time_april_fools_happy_collection_mine")
    state_machine.remove("red_alert_time_april_fools_happy_collection_rule_open")
end