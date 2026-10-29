--------------------------------------------------------------------------------------------------------------
--  说明：节日祝福鲜花祝福
--------------------------------------------------------------------------------------------------------------
RedAlertTimeFestivalEachChildBless = class("RedAlertTimeFestivalEachChildBlessClass", Window)

--打开界面
local red_alert_time_festival_each_child_bless_open_terminal = {
    _name = "red_alert_time_festival_each_child_bless_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = fwin:open(RedAlertTimeFestivalEachChildBless:new():init(params), fwin._ui)  
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_festival_each_child_bless_open_terminal)
state_machine.init()

function RedAlertTimeFestivalEachChildBless:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._activity_type = 0

    local function init_red_alert_time_festival_each_child_bless_terminal()
        local red_alert_time_festival_each_child_bless_show_terminal = {
            _name = "red_alert_time_festival_each_child_bless_show",
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

        local red_alert_time_festival_each_child_bless_hide_terminal = {
            _name = "red_alert_time_festival_each_child_bless_hide",
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

        local red_alert_time_festival_each_child_bless_update_terminal = {
            _name = "red_alert_time_festival_each_child_bless_update",
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

        local red_alert_time_festival_each_child_bless_get_reward_terminal = {
            _name = "red_alert_time_festival_each_child_bless_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                local group = 1
                local activity_info = _ED.activity_info[""..instance._activity_type]
                local achieve_index = tonumber(activity_info.activity_data[1][index].achieve_index)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                        checkRewardObtainDraw()
                    end
                end
                -- 请求祝福
                protocol_command.draw_activity_reward.param_list = activity_info.activity_id .. "\r\n"..activity_info.activity_type.."\r\n"..(group - 1).."\r\n"..(achieve_index - 1).."\r\n".."1"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_festival_each_child_bless_show_terminal)
        state_machine.add(red_alert_time_festival_each_child_bless_hide_terminal)
        state_machine.add(red_alert_time_festival_each_child_bless_update_terminal)
        state_machine.add(red_alert_time_festival_each_child_bless_get_reward_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_festival_each_child_bless_terminal()
end

function RedAlertTimeFestivalEachChildBless:onUpdateDraw()
    local root = self.roots[1]
    local activity_info = _ED.activity_info[""..self._activity_type]

    local activity_add_state_arr = zstring.split(activity_info.activity_add_state, "|")
    -- activity_add_state = "活动起始时间,活动关闭时间,兑换时间,当前时间,可集福次数,第一档已祝福次数,第二档已祝福次数,第三档祝福次数
    --                      |鲜花id
    --                      |第一次集福消耗金币,获得最小金币,获得最大金币|。。。。
    --                      |配件祝福需要鲜花数量,掉落库组,次数限制....(3个)

    local activity_add_state = zstring.split(activity_add_state_arr[1], ",")
    -- 鲜花数量
    local Text_festival_blessing_flw_h_n = ccui.Helper:seekWidgetByName(root, "Text_festival_blessing_flw_h_n")
    local prop_id = tonumber(activity_add_state_arr[2])
    local prop = fundPropWidthId(prop_id)
    local count = 0
    if prop ~= nil then
        count = tonumber(prop.prop_number)
    end
    local activity_data = activity_info.activity_data[1]
    Text_festival_blessing_flw_h_n:setString(count)
    -- 兑换状态
    for i = 1, 3 do
        local Text_festival_blessing_title = ccui.Helper:seekWidgetByName(root, "Text_festival_blessing_title_"..i)
        local Panel_festival_blessing_icon = ccui.Helper:seekWidgetByName(root, "Panel_festival_blessing_icon_"..i)
        local Text_festival_blessing_p = ccui.Helper:seekWidgetByName(root, "Text_festival_blessing_p_"..i)
        local Text_festival_blessing_times = ccui.Helper:seekWidgetByName(root, "Text_festival_blessing_times_"..i)
        local Text_festival_blessing_times_n = ccui.Helper:seekWidgetByName(root, "Text_festival_blessing_times_n_"..i)
        local Text_festival_blessing_folw_n = ccui.Helper:seekWidgetByName(root, "Text_festival_blessing_folw_n_"..i)
        local Button_festival_blessing = ccui.Helper:seekWidgetByName(root, "Button_festival_blessing_"..i)

        Panel_festival_blessing_icon:removeAllChildren(true)
        Text_festival_blessing_times_n:ignoreContentAdaptWithSize(false)
        Text_festival_blessing_times_n:removeAllChildren(true)
        Text_festival_blessing_times_n:setString("")

        local reward_info = zstring.split(activity_data[i].achieve_reward, ",")
        local exchange_info = zstring.split(activity_add_state_arr[#activity_add_state_arr - 3 + i], ",")
        local current_count = tonumber(activity_add_state[5 + i])
        local total_count = tonumber(exchange_info[3])

        local prop_data = {}
        prop_data.prop_item = tonumber(reward_info[1])
        prop_data.prop_type = tonumber(reward_info[2])
        prop_data.item_value = tonumber(reward_info[3])
        local cell = createPropIconCell(prop_data, false, false, false)
        Panel_festival_blessing_icon:addChild(cell)

        Text_festival_blessing_title:setString(activity_data[i].achieve_mould_name)
        Text_festival_blessing_p:setString(activity_data[i].achieve_mould_dec)
        Text_festival_blessing_folw_n:setString(exchange_info[1])


        local can_bless = true
        if i ~= 3 then
            Text_festival_blessing_times:setVisible(true)
            local font_size = Text_festival_blessing_times_n:getFontSize()
            local _richText = ccui.RichText:create()
            _richText:ignoreContentAdaptWithSize(false)       
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, ""..current_count, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
            _richText:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "/"..total_count, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
            _richText:pushBackElement(re2)
            _richText:setPosition(cc.p(Text_festival_blessing_times_n:getContentSize().width/2,Text_festival_blessing_times_n:getContentSize().height/2))
            _richText:setContentSize(cc.size(Text_festival_blessing_times_n:getContentSize().width,Text_festival_blessing_times_n:getContentSize().height))
            Text_festival_blessing_times_n:addChild(_richText)

            if current_count == total_count then
                can_bless = false
            end
        else
            Text_festival_blessing_times:setVisible(false)
        end

        if count < tonumber(exchange_info[1]) then
            can_bless = false
        end
        if can_bless == true then
            Button_festival_blessing:setTouchEnabled(true)
            Button_festival_blessing:setBright(true)
        else
            Button_festival_blessing:setTouchEnabled(false)
            Button_festival_blessing:setBright(false)
        end
    end
end

function RedAlertTimeFestivalEachChildBless:onInit()
    local csbItem = csb.createNode(string.format(config_csb.treasurehouse.festival_each_child_tab, 2))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 祝福
    for i = 1, 3 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_festival_blessing_"..i), nil, 
        {
            terminal_name = "red_alert_time_festival_each_child_bless_get_reward", 
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95,
            index = i,
        }, nil, 1)
    end

    self:onUpdateDraw()
end

function RedAlertTimeFestivalEachChildBless:onEnterTransitionFinish()

end

function RedAlertTimeFestivalEachChildBless:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeFestivalEachChildBless:onExit()
    state_machine.remove("red_alert_time_festival_each_child_bless_show")
    state_machine.remove("red_alert_time_festival_each_child_bless_hide")
    state_machine.remove("red_alert_time_festival_each_child_bless_update")
    state_machine.remove("red_alert_time_festival_each_child_bless_get_reward")
end