--------------------------------------------------------------------------------------------------------------
--  说明：道具生产详情
--------------------------------------------------------------------------------------------------------------
BuildUpMakeProps = class("BuildUpMakePropsClass", Window)

--打开界面
local build_up_make_props_open_terminal = {
    _name = "build_up_make_props_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("BuildUpMakePropsClass") == nil then
            fwin:open(BuildUpMakeProps:new():init(params), fwin._ui)  
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local build_up_make_props_close_terminal = {
    _name = "build_up_make_props_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BuildUpMakePropsClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(build_up_make_props_open_terminal)
state_machine.add(build_up_make_props_close_terminal)
state_machine.init()

function BuildUpMakeProps:ctor()
    self.super:ctor()
    self.roots = {}

    self._info = nil
    self._select_num = 1            -- 选择生产数量
    self._max_select_num = 100      -- 可选择最大生产数量
    self._current_silder = 100      -- 选择生产数量百分比
    self._need_time = 0             -- 生产一个单位所需时间

    self._activity_type = 0

    app.load("client.red_alert_time.cells.build_up.build_up_make_production_cell")
    app.load("client.red_alert_time.cells.props.props_icon_cell")
    local function init_build_up_make_props_terminal()
        local build_up_make_props_change_num_add_terminal = {
            _name = "build_up_make_props_change_num_add",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._max_select_num == 0 then
                    return
                end
                local select_num = instance._select_num + 1
                if select_num > instance._max_select_num then
                    return
                end
                instance:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local build_up_make_props_change_num_mimus_terminal = {
            _name = "build_up_make_props_change_num_mimus",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._max_select_num == 0 then
                    return
                end
                local select_num = instance._select_num - 1
                if select_num < 0 then
                    return
                end
                instance:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 滑块选择
        local build_up_make_props_update_slider_terminal = {
            _name = "build_up_make_props_update_slider",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local select_num = math.ceil(tonumber(params[2]) * params[1]._max_select_num / 100)
                params[1]:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 确定生产
        local build_up_make_props_sure_product_terminal = {
            _name = "build_up_make_props_sure_product",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._select_num == 0 then
                    return
                end
                -- 需要宝石数量
                local info = {}
                local need_cost = zstring.split(self._info.cost,"|")
                local need_silver_cost = zstring.split(need_cost[1],",")
                need_silver_cost = need_silver_cost[3] * self._select_num - _ED.user_info.user_silver
                -- 需要技能勋章数量
                local need_skill_cost = zstring.split(need_cost[2],",")
                local prop_count = 0 
                if fundPropWidthId(need_skill_cost[1]) ~= nil then 
                    local token = fundPropWidthId(need_skill_cost[1])
                    prop_count = zstring.tonumber(token.prop_number)
                end
                need_skill_cost = (need_skill_cost[3] * self._select_num - prop_count) * 8
                -- 判断需要的资源数量是否足够,不足弹出需要金币购买提示
                local need_gold = 0
                if need_silver_cost > 0 then
                    table.insert(info,need_silver_cost)
                    need_gold = need_gold + getUpgradeCostGoldNum(info)
                    if need_skill_cost > 0 then
                        need_gold = need_gold + need_skill_cost
                    end
                elseif need_skill_cost > 0 then
                    need_gold = need_gold + need_skill_cost
                end
                if need_gold > 0 then
                    local tip = ConfirmTip:new()
                    tip:init(instance, instance.sureGoldUpgrade, string.format(red_alert_all_str[296],need_gold))
                    fwin:open(tip,fwin._windows) 
                    return
                end

                if zstring.tonumber(_ED.home_build["8"].level) <= 0 then
                    TipDlg.drawTextDailog(red_alert_time_str[19])
                    return
                end
                if instance:checkMaxProductionCount() == false then 
                    TipDlg.drawTextDailog(red_alert_all_str[306])
                    state_machine.excute("build_up_make_props_close", 0, "")
                    return
                end

                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(red_alert_all_str[286])
                        state_machine.excute("home_map_update_prodcution_state", 0, {8})
                        state_machine.excute("build_up_make_props_close",0,"")
                        state_machine.excute("build_up_make_factory_ing_production_update_draw", 0, "")
                        state_machine.excute("build_up_make_factory_production_update_draw", 0, "")
                        state_machine.excute("build_up_make_factory_change_page",0,{_datas = {index = 3}})
                        checkPlayEffect(34)
                    end
                end
                -- print(factory_type, instance._tank_info.tank_id, instance._select_num)
                protocol_command.factory_product.param_list = "3".."\r\n"..instance._info.id.."\r\n"..instance._select_num
                NetworkManager:register(protocol_command.factory_product.code, nil, nil, nil, instance, responseCallback, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新界面
        local build_up_make_props_update_draw_terminal = {
            _name = "build_up_make_props_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawProduction()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local build_up_make_props_activity_rule_infor_terminal = {
            _name = "build_up_make_props_activity_rule_infor",
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

        state_machine.add(build_up_make_props_change_num_add_terminal)
        state_machine.add(build_up_make_props_change_num_mimus_terminal)
        state_machine.add(build_up_make_props_update_slider_terminal)
        state_machine.add(build_up_make_props_sure_product_terminal)
        state_machine.add(build_up_make_props_update_draw_terminal)
        state_machine.add(build_up_make_props_activity_rule_infor_terminal)
        state_machine.init()
    end
    
    init_build_up_make_props_terminal()
end

function BuildUpMakeProps:setSelectNum(select_num)
    self._select_num = select_num
    if self._select_num > self._max_select_num then
        self._select_num = self._max_select_num
    end
    if self._select_num <= 0 then
        self._select_num = 1
    end

    local percent = math.floor(self._select_num * 100 / self._max_select_num)
    self:updateSliderInfo(percent)
    state_machine.excute("build_up_make_production_cell_update_level", 0, self._select_num)
end

function BuildUpMakeProps:checkMaxProductionCount()
    local max_count = dms.int(dms["base_consume"], 80, base_consume.vip_0_value + tonumber(_ED.vip_grade)) -- 最大生产队列长度
    local current_count = 0
    if _ED.production_info ~= nil and _ED.production_info["3"] ~= nil then
        current_count = table.nums(_ED.production_info["3"])
    end
    if current_count < max_count then
        return true
    else
        return false
    end
end

-- 金币升级
function BuildUpMakeProps:sureGoldUpgrade(sure_number)
    if self.roots == nil then
        return
    end
    local root = self.roots[1]
    if root == nil then
        return
    end
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            TipDlg.drawTextDailog(red_alert_all_str[286])
            state_machine.excute("home_map_update_prodcution_state", 0, {8})
            state_machine.excute("build_up_make_props_close",0,"")
            state_machine.excute("build_up_make_factory_ing_production_update_draw", 0, "")
            state_machine.excute("build_up_make_factory_production_update_draw", 0, "")
            state_machine.excute("build_up_make_factory_change_page",0,{_datas = {index = 3}})
            checkPlayEffect(34)
        end
    end
    if sure_number == 0 then
        protocol_command.factory_product.param_list = "3".."\r\n"..self._info.id.."\r\n"..self._select_num
        NetworkManager:register(protocol_command.factory_product.code, nil, nil, nil, self, responseCallback, false, nil)   
    end
end

function BuildUpMakeProps:updateDrawMakeProps()
    local root = self.roots[1]
    -- 道具图标
    local Panel_res_build_icon = ccui.Helper:seekWidgetByName(root,"Panel_res_build_icon")
    Panel_res_build_icon:removeAllChildren(true)
    local pic_index = dms.int(dms["prop_mould"], self._info.get_prop_id, prop_mould.pic_index)
    local cell = state_machine.excute("props_icon_create_cell",0,{4,1,self._info.get_prop_id,1})
    Panel_res_build_icon:addChild(cell) 

    -- 道具名字
    local Text_make_props_name = ccui.Helper:seekWidgetByName(root,"Text_make_props_name")
    local prop_name = dms.string(dms["prop_mould"], self._info.get_prop_id, prop_mould.prop_name)
    Text_make_props_name:setString(prop_name)

    -- 道具数量
    local Text_make_props_n_n = ccui.Helper:seekWidgetByName(root,"Text_make_props_n_n")
    local prop_count = 0 
    if fundPropWidthId(self._info.get_prop_id) ~= nil then 
        local token = fundPropWidthId(self._info.get_prop_id)
        prop_count = zstring.tonumber(token.prop_number)
    end
    Text_make_props_n_n:setString(prop_count)

    -- 道具效果描述
    local Text_make_props_effice_n = ccui.Helper:seekWidgetByName(root,"Text_make_props_effice_n")
    local remarks = dms.string(dms["prop_mould"], self._info.get_prop_id, prop_mould.remarks)
    Text_make_props_effice_n:setString(remarks)

    -- 火力驱动活动标志
    local Button_build_up_res_act = ccui.Helper:seekWidgetByName(root,"Button_build_up_res_act")    
    if Button_build_up_res_act ~= nil then
        Button_build_up_res_act:setVisible(false)
        if _ED.activity_info ~= nil and _ED.activity_info["117"] ~= nil then
            local other_info = zstring.split(_ED.activity_info["117"].activity_add_state, "!")
            local timesData = zstring.split(other_info[1], ",")
            local leave_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
            if leave_times > 0 then
                local start_time = tonumber(timesData[1]/1000)
                local current_time = os.time() + _ED.time_add_or_sub
                local open_info = zstring.split(other_info[2], "|")
                open_info = zstring.split(open_info[6], ",")        -- 制造工厂加速
                if (current_time - start_time) > (tonumber(open_info[1])) * 3600 then
                    Button_build_up_res_act:setVisible(true)
                    self._activity_type = 117
                end
            end
        end
    end
end

function BuildUpMakeProps:createPropUsedCell()
    local root = self.roots[2]
    local Panel_produciton_res_infor = ccui.Helper:seekWidgetByName(root, "Panel_produciton_res_infor")
    Panel_produciton_res_infor:removeAllChildren(true)
    local cell = state_machine.excute("build_up_make_production_cell_create", 0, {self._info,self._select_num})
    Panel_produciton_res_infor:addChild(cell)
end

function BuildUpMakeProps:updateDrawProduction()
    local root = self.roots[2]

    -- 计算可制造的最大数量
    self._max_select_num = dms.int(dms["major_city_config"], 17, major_city_config.param)

     -- 拥有宝石可生产数量
    local need_cost = zstring.split(self._info.cost,"|")
    local need_silver_cost = zstring.split(need_cost[1],",")
    local silver_make_count = math.floor(tonumber(_ED.user_info.user_silver) / tonumber(need_silver_cost[3]))
    -- 拥有技能勋章可生产数量
    local need_skill_cost = zstring.split(need_cost[2],",")
    local have_skill_cost = 0 
    if fundPropWidthId(need_skill_cost[1]) ~= nil then 
        local token = fundPropWidthId(need_skill_cost[1])
        have_skill_cost = zstring.tonumber(token.prop_number)
    end
    local skill_make_count = math.floor(have_skill_cost / tonumber(need_skill_cost[3]))
    self._max_select_num = math.min(self._max_select_num, math.min(silver_make_count, have_skill_cost))

    local Button_sure = ccui.Helper:seekWidgetByName(root, "Button_sure")
    local Slider_num = ccui.Helper:seekWidgetByName(root, "Slider_num")
    local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
    local Text_num_n = ccui.Helper:seekWidgetByName(root, "Text_num_n")
    if self._max_select_num == 0 then
        Button_sure:setTouchEnabled(false)
        Button_sure:setBright(false)

        state_machine.excute("build_up_make_production_cell_update_level", 0, 1)
        Text_time:setString(exChangeNumTimeString(self._need_time))
        Text_num_n:setString(1)
        Slider_num:setPercent(100)
    else
        Button_sure:setTouchEnabled(true)
        Button_sure:setBright(true)
    end

    self:setSelectNum(self._select_num)
end

function BuildUpMakeProps:updateSliderInfo(percent)
    local root = self.roots[2]
    local Slider_num = ccui.Helper:seekWidgetByName(root, "Slider_num")
    local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
    local Text_num_n = ccui.Helper:seekWidgetByName(root, "Text_num_n")

    Text_time:setString(exChangeNumTimeString(math.ceil(self._info.need_time * self._select_num)))
    Text_num_n:setString(self._select_num)
    Slider_num:setPercent(percent)
end

function BuildUpMakeProps:onInit()
    local csbItem = csb.createNode(config_csb.build_up.build_up_make_factory_props)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 关闭界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_make_props_close"), nil, 
    {
        terminal_name = "build_up_make_props_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "build_up_make_props_close", 
        terminal_state = 0, 
    }, nil, 3)  

    -- 活动规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_build_up_res_act"), nil, 
    {
        terminal_name = "build_up_make_props_activity_rule_infor",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1) 

    self:updateDrawMakeProps()

    local Panel_make_props_infor_box = ccui.Helper:seekWidgetByName(root, "Panel_make_props_infor_box")
    Panel_make_props_infor_box:removeAllChildren(true)

    local csbItem1 = csb.createNode(config_csb.build_up.build_up_tank_production_tab_2)
    local root1 = csbItem1:getChildByName("root")
    root1:removeFromParent(false)
    Panel_make_props_infor_box:addChild(root1)
    table.insert(self.roots, root1)

    -- 增加
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root1, "Button_add"), nil, 
    {
        terminal_name = "build_up_make_props_change_num_add", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
    }, nil, 1)

    -- 减少
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root1, "Button_minus"), nil, 
    {
        terminal_name = "build_up_make_props_change_num_mimus", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
    }, nil, 1)

    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root1, "Button_sure"), nil, 
    {
        terminal_name = "build_up_make_props_sure_product", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
    }, nil, 1)

    -- 滑动选择
    local Slider_num = ccui.Helper:seekWidgetByName(root, "Slider_num")
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            state_machine.excute("build_up_make_props_update_slider", 0, {sender._self, sender:getPercent()})
        end
    end
    Slider_num._self = self
    Slider_num:addEventListener(percentChangedEvent)

    self:createPropUsedCell()
    self:updateDrawProduction()
end

function BuildUpMakeProps:onEnterTransitionFinish()
    
end

function BuildUpMakeProps:init(params)
    self._info = params[1]
    self:onInit()
    return self
end

function BuildUpMakeProps:onExit()
    state_machine.remove("build_up_make_props_change_num_add")
    state_machine.remove("build_up_make_props_change_num_mimus")
    state_machine.remove("build_up_make_props_update_slider")
    state_machine.remove("build_up_make_props_sure_product")
    state_machine.remove("build_up_make_props_update_draw")
    state_machine.remove("build_up_make_props_activity_rule_infor")
end