-----------------------------
--选择运送品质
-----------------------------
ShipMilitarySelect = class("ShipMilitarySelectClass", Window)

local ship_military_select_window_open_terminal = {
    _name = "ship_military_select_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)     
        if tonumber(_ED.transport_resouce_info.is_lucky_time) == 0 then
            TipDlg.drawTextDailog(red_alert_all_str[214])
            return
        end
        if _ED.transport_resouce_info.leave_tran_times == 0 then
            TipDlg.drawTextDailog(red_alert_all_str[141])
            return
        end
        if nil == fwin:find("ShipMilitarySelectClass") then
            fwin:open(ShipMilitarySelect:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local ship_military_select_window_close_terminal = {
    _name = "ship_military_select_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ShipMilitarySelectClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(ship_military_select_window_open_terminal)
state_machine.add(ship_military_select_window_close_terminal)
state_machine.init()

function ShipMilitarySelect:ctor()
    self.super:ctor()
    self.roots = {}

    -- load lua file
    
    -- var
    
    self.old_select_index = 0
    --格式化好的本地军资信息
    self.ship_military_info = nil
    -- Initialize ship_military_select state machine.
    local function init_ship_military_select_terminal()
        --改变品质
        local ship_military_select_change_quality_terminal = {
            _name = "ship_military_select_change_quality",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.lock("ship_military_select_change_quality")
                if _ED.transport_resouce_info.resource_quality == 5 then
                    TipDlg.drawTextDailog(red_alert_all_str[109])
                    state_machine.unlock("ship_military_select_change_quality")
                    return
                end

                local need_gem = dms.int(dms["ship_military_config"],5,ship_military_config.param)
                if _ED.transport_resouce_info.free_refrush_time == 0 and zstring.tonumber(_ED.user_info.user_gold) < need_gem then
                    TipDlg.drawTextDailog(red_alert_all_str[79])
                    state_machine.unlock("ship_military_select_change_quality")
                    return
                end

                if _ED.transport_resouce_info.is_transport == 1 then
                    TipDlg.drawTextDailog(red_alert_all_str[140])
                    state_machine.unlock("ship_military_select_change_quality")
                    return
                end
                instance.old_select_index = _ED.transport_resouce_info.resource_quality

                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("ship_military_select_update_gold",0,"")
                        state_machine.excute("ship_military_select_play_update_action",0,"") 
                    end
                end
                NetworkManager:register(protocol_command.ship_military_refrush_quality.code, nil, nil, nil, instance, responseCallback, false, nil)
                
                --todo 请求
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新当前金币
        local ship_military_select_update_gold_terminal = {
            _name = "ship_military_select_update_gold",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDrawGold()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新当前选择的品质信息
        local ship_military_select_update_select_info_terminal = {
            _name = "ship_military_select_update_select_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDrawNowSelectInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --播放刷新动画
        local ship_military_select_play_update_action_terminal = {
            _name = "ship_military_select_play_update_action",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:playUpdateAction()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --开始运送
        local ship_military_select_start_transport_terminal = {
            _name = "ship_military_select_start_transport",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then    
                        state_machine.excute("ship_military_select_window_close",0,"")
                        state_machine.excute("ship_military_use_update_draw",0,"")
                        state_machine.excute("ship_military_use_update_horses",0,"")
                        state_machine.excute("campaign_updatedraw_cell",0,{3})
                    end
                end
                NetworkManager:register(protocol_command.ship_military_start_transport.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(ship_military_select_change_quality_terminal)
        state_machine.add(ship_military_select_update_gold_terminal)
        state_machine.add(ship_military_select_update_select_info_terminal)
        state_machine.add(ship_military_select_play_update_action_terminal)
        state_machine.add(ship_military_select_start_transport_terminal)
        state_machine.init()
    end
    
    -- call func ship_military_select state machine.
    init_ship_military_select_terminal()
end

function ShipMilitarySelect:playUpdateAction()
    -- print("=====old_select_index======",self.old_select_index,self.select_index)

    local play_numbers = (5 - self.old_select_index + 1) * 4 + _ED.transport_resouce_info.resource_quality - self.old_select_index
    -- print("====play_numbers",play_numbers)
    self:playUpdateActionOne(1,play_numbers,self.old_select_index,0.1)
end

function ShipMilitarySelect:playUpdateActionOne(_now_numbers,_max_numbers,_index,delay_time)
    local index = _index
    if index > 5 then
        index = self.old_select_index
        delay_time = delay_time / 2
    end
    local now_numbers = _now_numbers

    -- print("=============",now_numbers,_index)
    local function playNext()
       self:setSelectedLighted(index)
       if _now_numbers <= _max_numbers then
          self:playUpdateActionOne(now_numbers + 1,_max_numbers,index + 1,delay_time)
       elseif _now_numbers > _max_numbers then
          state_machine.excute("ship_military_select_update_select_info",0,"")
          state_machine.unlock("ship_military_select_change_quality")
       end
    end 
    -- print("=====delay_time",delay_time)
    local action = cc.Sequence:create(cc.DelayTime:create(delay_time),cc.CallFunc:create(playNext))
    self:runAction(action)  
end

function ShipMilitarySelect:onUpdateDrawNowSelectInfo()
    local root = self.roots[1]
    local Text_transport_inner = ccui.Helper:seekWidgetByName(root,"Text_transport_inner") -- 当前运送
    -- 初始化镖车等级
    local resource_quality = dms.int(dms["base_consume"],72,base_consume.vip_0_value + tonumber(_ED.vip_grade))     
    resource_quality = math.max(_ED.transport_resouce_info.resource_quality,resource_quality)
    self:setSelectedLighted(resource_quality)

    Text_transport_inner:setString(string.format(ship_military_quality_info[resource_quality],self.ship_military_info[1].level))
    Text_transport_inner:setColor(cc.c3b(color_Type[resource_quality+1][1],color_Type[resource_quality+1][2],color_Type[resource_quality+1][3]))

    -- local Text_money_v = ccui.Helper:seekWidgetByName(root,"Text_money_v") -- 预计收益
    -- local can_get_silver = 0
    -- if zstring.tonumber(_ED.transport_resouce_info.is_lucky_time) == 0 then
    --     can_get_silver = tonumber(self.ship_military_info[_ED.transport_resouce_info.resource_quality].reward_silver_numbers) 
    -- elseif zstring.tonumber(_ED.transport_resouce_info.is_lucky_time) == 1 then
    --     local persent = dms.int(dms["ship_military_config"],3,ship_military_config.param)
    --     can_get_silver = tonumber(self.ship_military_info[_ED.transport_resouce_info.resource_quality].reward_silver_numbers) * (persent+100)/100
    -- end
    -- Text_money_v:setString(can_get_silver)

    local Panel_gem = ccui.Helper:seekWidgetByName(root,"Panel_gem") -- 宝石刷新层
    local Button_free_refresh = ccui.Helper:seekWidgetByName(root,"Button_free_refresh") -- 免费刷新
    local Image_free = ccui.Helper:seekWidgetByName(root,"Image_free") -- 免费刷新次数背景
    local Text_free_time = ccui.Helper:seekWidgetByName(root,"Text_free_time") -- 免费次数
    local Text_gem = ccui.Helper:seekWidgetByName(root,"Text_gem") -- 需要宝石
    local need_gem = dms.int(dms["ship_military_config"],5,ship_military_config.param)
    Image_free:setVisible(false)
    Panel_gem:setVisible(false)
    Button_free_refresh:setVisible(false)
    Text_free_time:setString(_ED.transport_resouce_info.free_refrush_time)
    if zstring.tonumber(_ED.transport_resouce_info.free_refrush_time) > 0 then
        Image_free:setVisible(true)
        Button_free_refresh:setVisible(true)
    else
        Panel_gem:setVisible(true)
        Text_gem:setString(need_gem)
    end

    local Text_res_n_1 = ccui.Helper:seekWidgetByName(root, "Text_res_n_1")
    local Text_res_n_2 = ccui.Helper:seekWidgetByName(root, "Text_res_n_2")
    local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
    local Panel_6_0 = ccui.Helper:seekWidgetByName(root, "Panel_6_0")
    for k,v in pairs(self.ship_military_info) do
        if k == resource_quality then
            local reward_silver_numbers = zstring.split(v.reward_silver_numbers, "|")
            local index = 0
            for k1,v1 in pairs(reward_silver_numbers) do
                index = index + 1
                local info = zstring.split(v1, ",")
                if index == 2 then
                    if tonumber(info[2]) == 1 then
                        Text_res_n_1:setString(info[3])
                        Panel_6:setBackGroundImage(config_res.images.ui.props.props_4002)
                    else
                        Text_res_n_2:setString(info[3])
                        Panel_6_0:setBackGroundImage(config_res.images.ui.props.props_4019)
                    end
                else
                    if tonumber(info[2]) == 1 then
                        Text_res_n_2:setString(info[3])
                        Panel_6_0:setBackGroundImage(config_res.images.ui.props.props_4002)
                    else
                        Text_res_n_2:setString(info[3])
                        Panel_6_0:setBackGroundImage(config_res.images.ui.props.props_4019)
                    end
                end
            end
        end
    end
end

function ShipMilitarySelect:setSelectedLighted(index)
    local root = self.roots[1]

    for i,v in pairs(self.ship_military_info) do
        local Image_light = ccui.Helper:seekWidgetByName(root,"Image_light_"..i)
        Image_light:setVisible(false)
    end

    for i,v in pairs(self.ship_military_info) do
        if i == index then
            local Image_light = ccui.Helper:seekWidgetByName(root,"Image_light_"..i)
            Image_light:setVisible(true)
        end
    end
end

function ShipMilitarySelect:onUpdateDraw()
    local root = self.roots[1]

end

function ShipMilitarySelect:onUpdateDrawGold()
    local root = self.roots[1]    
    local Text_wing_number = ccui.Helper:seekWidgetByName(root,"Text_wing_number") -- 宝石数
    Text_wing_number:setString(_ED.user_info.user_gold)
end

function ShipMilitarySelect:onEnterTransitionFinish()

end

function ShipMilitarySelect:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.shipmilitaryuse.ship_military_select)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "ship_military_select_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 免费刷新
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_free_refresh"), nil, 
    {
        terminal_name = "ship_military_select_change_quality", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 宝石刷新
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_gem_refresh"), nil, 
    {
        terminal_name = "ship_military_select_change_quality", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 开始运送
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_transport"), nil, 
    {
        terminal_name = "ship_military_select_start_transport", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    
	
    self:onUpdateDrawNowSelectInfo()
    self:onUpdateDrawGold()
    self:onUpdateDraw() 
end

function ShipMilitarySelect:initData()
	-- 解析运送军资数据
    if _ED.ship_military_info == nil or table.nums(_ED.ship_military_info) == 0 then
        initShipMilitaryData()
    end
    local user_level = tonumber(_ED.user_info.user_grade)
    if user_level >= 60 then
        self.ship_military_info = _ED.ship_military_info["150"]
    elseif user_level >= 40 then
        self.ship_military_info = _ED.ship_military_info["60"]
    elseif user_level >= 20 then
        self.ship_military_info = _ED.ship_military_info["40"]
    else
        self.ship_military_info = _ED.ship_military_info["20"]
    end

    -- debug.print_r(self.ship_military_info)
end

function ShipMilitarySelect:init()
    self:initData()
	self:onInit()
    return self
end

function ShipMilitarySelect:onExit()
    state_machine.remove("ship_military_select_change_quality")
    state_machine.remove("ship_military_select_update_gold")
    state_machine.remove("ship_military_select_update_select_info")
    state_machine.remove("ship_military_select_play_update_action")
    state_machine.remove("ship_military_select_start_transport")
end
