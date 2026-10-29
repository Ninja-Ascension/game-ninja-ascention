--------------------------------------------------------------------------------------------------------------
--  说明：挖掘机来袭 零件兑换
--------------------------------------------------------------------------------------------------------------
RedAlertTimeExcavtingComeingExchange = class("RedAlertTimeExcavtingComeingExchangeClass", Window)

--打开界面
local red_alert_time_excavting_comeing_exchange_open_terminal = {
    _name = "red_alert_time_excavting_comeing_exchange_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = fwin:open(RedAlertTimeExcavtingComeingExchange:new():init(params), fwin._ui)  
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_excavting_comeing_exchange_open_terminal)
state_machine.init()

function RedAlertTimeExcavtingComeingExchange:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._activity_type = 0

    self._max_select_num = 0
    self._min_select_num = 0
    self._selct_num = 0

    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_snatch_rebel_haunt_pack_cell")
    
    local function init_red_alert_time_excavting_comeing_exchange_terminal()
        local red_alert_time_excavting_comeing_exchange_show_terminal = {
            _name = "red_alert_time_excavting_comeing_exchange_show",
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

        local red_alert_time_excavting_comeing_exchange_hide_terminal = {
            _name = "red_alert_time_excavting_comeing_exchange_hide",
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
        local red_alert_time_excavting_comeing_exchange_updata_terminal = {
            _name = "red_alert_time_excavting_comeing_exchange_updata",
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

        local red_alert_time_excavting_comeing_exchange_num_change_terminal = {
            _name = "red_alert_time_excavting_comeing_exchange_num_change",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._max_select_num < self._min_select_num then
                    return
                end
                local select_num = instance._select_num + params._datas.num
                instance:updateSelectedNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_excavting_comeing_exchange_update_slider_terminal = {
            _name = "red_alert_time_excavting_comeing_exchange_update_slider",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local select_num = math.ceil(tonumber(params[2]) * params[1]._max_select_num / 100)
                instance:updateSelectedNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 兑换
        local red_alert_time_excavting_comeing_exchange_get_reward_terminal = {
            _name = "red_alert_time_excavting_comeing_exchange_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local acitvity = _ED.activity_info[""..instance._activity_type]
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                        state_machine.excute("red_alert_time_excavting_comeing_collection_updata", 0, "")
                        state_machine.excute("home_map_update_tanke_info", 0, "")
                    end
                end
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..acitvity.activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."3"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_excavting_comeing_exchange_updata_terminal)
        state_machine.add(red_alert_time_excavting_comeing_exchange_hide_terminal)
        state_machine.add(red_alert_time_excavting_comeing_exchange_show_terminal)
        state_machine.add(red_alert_time_excavting_comeing_exchange_num_change_terminal)
        state_machine.add(red_alert_time_excavting_comeing_exchange_update_slider_terminal)
        state_machine.add(red_alert_time_excavting_comeing_exchange_get_reward_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_excavting_comeing_exchange_terminal()
end

function RedAlertTimeExcavtingComeingExchange:updateSelectedNum(select_num)
    local root = self.roots[1]
    local Slider_excavting_comeing_exchange = ccui.Helper:seekWidgetByName(root,"Slider_excavting_comeing_exchange")
    local Text_excavting_comeing_exchange_car_n = ccui.Helper:seekWidgetByName(root,"Text_excavting_comeing_exchange_car_n")

    self._select_num = select_num
    if self._select_num < self._min_select_num then
        self._select_num = self._min_select_num
    end
    if self._select_num > self._max_select_num then
        self._select_num = self._max_select_num
    end
    if self._max_select_num < self._min_select_num then
        self._select_num = 0
    end

    Text_excavting_comeing_exchange_car_n:setString(self._select_num)
    if self._max_select_num < self._min_select_num then
        Slider_excavting_comeing_exchange:setPercent(0)
    else
        local percent = math.floor(self._select_num * 100 / self._max_select_num)
        Slider_excavting_comeing_exchange:setPercent(percent)
    end
end

function RedAlertTimeExcavtingComeingExchange:updateDraw()
    local root = self.roots[1]
    local activity_info = _ED.activity_info[""..self._activity_type]
    local activity_add_state = zstring.split(activity_info.activity_add_state, ",")

    -- activity_add_state = "开始时间,结束时间,领奖时间,免费次数,最大免费次数,单次收集花费,10次收集花费,10次收集花费原价,折扣,零件数量,奖励预览掉落id,"
    --                      "兑换比例,最低兑换个数,个人已兑换数量,个人最大兑换数量,全服已兑换数量,全服最大兑换数量"   
    activity_add_state = zstring.split("11,22,33,1,1,48,432,480,9,90,1012,10,10,100,1000,200,10000", ",")

    local Text_excavting_comeing_exchange_n_1 = ccui.Helper:seekWidgetByName(root,"Text_excavting_comeing_exchange_n_1")
    local Text_excavting_comeing_exchange_n_2 = ccui.Helper:seekWidgetByName(root,"Text_excavting_comeing_exchange_n_2")
    local Text_excavting_comeing_equ_n = ccui.Helper:seekWidgetByName(root,"Text_excavting_comeing_equ_n")
    local Button_excavting_comeing_exchage = ccui.Helper:seekWidgetByName(root,"Button_excavting_comeing_exchage")

    Text_excavting_comeing_equ_n:setString(activity_add_state[10])

    -- 全服数量
    Text_excavting_comeing_exchange_n_1:setString("")
    Text_excavting_comeing_exchange_n_1:removeAllChildren(true)
    local font_size = Text_excavting_comeing_exchange_n_1:getFontSize()
    local _richText1 = ccui.RichText:create()
    _richText1:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]),255, ""..(tonumber(activity_add_state[17]) - tonumber(activity_add_state[16])), config_res.font.font_name,font_size)
    _richText1:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "/"..activity_add_state[17], config_res.font.font_name,font_size)
    _richText1:pushBackElement(re2)
    _richText1:setPosition(cc.p(Text_excavting_comeing_exchange_n_1:getContentSize().width/2,Text_excavting_comeing_exchange_n_1:getContentSize().height/2))
    _richText1:setContentSize(cc.size(Text_excavting_comeing_exchange_n_1:getContentSize().width,font_size))
    Text_excavting_comeing_exchange_n_1:addChild(_richText1)

    -- 个人数量
    Text_excavting_comeing_exchange_n_2:setString("")
    Text_excavting_comeing_exchange_n_2:removeAllChildren(true)
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)       
    local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]),255, ""..(tonumber(activity_add_state[15]) - tonumber(activity_add_state[14])), config_res.font.font_name,font_size)
    _richText2:pushBackElement(re3)  
    local re4 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "/"..activity_add_state[15], config_res.font.font_name,font_size)
    _richText2:pushBackElement(re4)
    _richText2:setPosition(cc.p(Text_excavting_comeing_exchange_n_2:getContentSize().width/2,Text_excavting_comeing_exchange_n_2:getContentSize().height/2))
    _richText2:setContentSize(cc.size(Text_excavting_comeing_exchange_n_2:getContentSize().width,font_size))
    Text_excavting_comeing_exchange_n_2:addChild(_richText2)

    self._max_select_num = tonumber(activity_add_state[14]) - tonumber(activity_add_state[13])
    self._max_select_num = math.min(self._max_select_num, math.floor(tonumber(activity_add_state[10]) / tonumber(activity_add_state[12])))
    self._min_select_num = tonumber(activity_add_state[13])
    self._select_num = self._max_select_num

    if self._max_select_num >= self._min_select_num then
        Button_excavting_comeing_exchage:setTouchEnabled(true)
        Button_excavting_comeing_exchage:setBright(true)
    else
        self._select_num = 0
        Button_excavting_comeing_exchage:setTouchEnabled(false)
        Button_excavting_comeing_exchage:setBright(false)
    end

    self:updateSelectedNum(self._select_num)
end

--初始化
function RedAlertTimeExcavtingComeingExchange:onInit()
    local csbItem = csb.createNode(string.format(config_csb.treasurehouse.excavting_comeing_tab, 2))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_excavting_comeing_exchange_add"), nil, 
    {
        terminal_name = "red_alert_time_excavting_comeing_exchange_num_change", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        num = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_excavting_comeing_exchange_minus"), nil, 
    {
        terminal_name = "red_alert_time_excavting_comeing_exchange_num_change", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        num = -1
    }, nil, 1)   

    -- 兑换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_excavting_comeing_exchage"), nil, 
    {
        terminal_name = "red_alert_time_excavting_comeing_exchange_get_reward", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)   

    local Slider_excavting_comeing_exchange = ccui.Helper:seekWidgetByName(root, "Slider_excavting_comeing_exchange")
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            state_machine.excute("red_alert_time_excavting_comeing_exchange_update_slider", 0, {sender._self, sender:getPercent()})
        end
    end
    Slider_excavting_comeing_exchange._self = self
    Slider_excavting_comeing_exchange:addEventListener(percentChangedEvent)

    self:updateDraw()
end

function RedAlertTimeExcavtingComeingExchange:onEnterTransitionFinish()

end

function RedAlertTimeExcavtingComeingExchange:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeExcavtingComeingExchange:onExit()
    state_machine.remove("red_alert_time_excavting_comeing_exchange_show")
    state_machine.remove("red_alert_time_excavting_comeing_exchange_hide")
    state_machine.remove("red_alert_time_excavting_comeing_exchange_updata")
    state_machine.remove("red_alert_time_excavting_comeing_exchange_num_change")
    state_machine.remove("red_alert_time_excavting_comeing_exchange_update_slider")
    state_machine.remove("red_alert_time_excavting_comeing_exchange_get_reward")
end