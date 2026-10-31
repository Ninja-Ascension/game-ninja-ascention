--------------------------------------------------------------------------------------------------------------
--  说明：科技升级
--------------------------------------------------------------------------------------------------------------
BuildUpScientificUp = class("BuildUpScientificUpClass", Window)

--打开界面
local build_up_scientific_up_open_terminal = {
    _name = "build_up_scientific_up_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("BuildUpScientificUpClass") == nil then
            fwin:open(BuildUpScientificUp:new():init(params), fwin._ui)  
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local build_up_scientific_up_close_terminal = {
    _name = "build_up_scientific_up_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BuildUpScientificUpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(build_up_scientific_up_open_terminal)
state_machine.add(build_up_scientific_up_close_terminal)
state_machine.init()

function BuildUpScientificUp:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._barracks_info = nil
    self._base_barracks_info = nil
    self.m_times = 0
    self._can_update = false
    self._resource_type = {}

    self._activity_type = 0
    --load lua file
    app.load("client.red_alert_time.cells.build_up.build_up_resources_cell")
    app.load("client.red_alert_time.cells.props.props_icon_cell")
    local function init_build_up_scientific_up_terminal()
        local build_up_scientific_up_show_terminal = {
            _name = "build_up_scientific_up_show",
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

        -- 刷新界面
        local build_up_scientific_up_update_draw_terminal = {
            _name = "build_up_scientific_up_update_draw",
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

        local build_up_scientific_up_activity_rule_infor_terminal = {
            _name = "build_up_scientific_up_activity_rule_infor",
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

        -- 科技升级
        local build_up_scientific_up_upgrade_terminal = {
            _name = "build_up_scientific_up_upgrade",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance:checkMaxScientificCount() == false then 
                    TipDlg.drawTextDailog(red_alert_all_str[306])
                    return
                end
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("home_map_update_prodcution_state", 0, {3})
                        state_machine.excute("build_up_scientific_to_update_draw", 0, "")
                        state_machine.excute("build_up_scientific_up_close", 0, "")
                        TipDlg.drawTextDailog(red_alert_all_str[282])
                        checkPlayEffect(33)
                    end
                end     
                protocol_command.barracks_teach_update.param_list = ""..instance._base_barracks_info.id
                NetworkManager:register(protocol_command.barracks_teach_update.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local build_up_scientific_up_open_window_terminal = {
            _name = "build_up_scientific_up_open_window",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                local prop_type = instance._resource_type[index]
                if prop_type ~= nil and prop_type > 0 then
                    if prop_type == 44 then
                        state_machine.excute("player_info_prestige_open",0,"")
                    else
                        local info = _ED.base_build_shop_info["1"][""..prop_type]
                        state_machine.excute("props_use_window_open",0,{info.id, info.prop_ids, 1})
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(build_up_scientific_up_show_terminal)
        state_machine.add(build_up_scientific_up_update_draw_terminal)
        state_machine.add(build_up_scientific_up_activity_rule_infor_terminal)
        state_machine.add(build_up_scientific_up_upgrade_terminal)
        state_machine.add(build_up_scientific_up_open_window_terminal)
        state_machine.init()
    end
    
    init_build_up_scientific_up_terminal()
end

function BuildUpScientificUp:checkMaxScientificCount()
    local max_count = dms.int(dms["base_consume"], 79, base_consume.vip_0_value + tonumber(_ED.vip_grade)) -- 最大生产队列长度
    local current_count = 0
    if _ED.barracks_info ~= nil then
        for k, v in pairs(_ED.barracks_info) do
            if tonumber(v.barrack_state) ~= 0 then
                current_count = current_count + 1
            end
        end
    end

    if current_count < max_count then
        return true
    else
        return false
    end
end

function BuildUpScientificUp:updateDraw()
    local root = self.roots[1]
    -- 科技升级信息
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")
    Panel_props_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{4,3,self._base_barracks_info.id,4})
    Panel_props_icon:addChild(cell) 

    -- 名称等级
    local level = zstring.tonumber(self._barracks_info.barrack_level)
    local Text_build_scientific_up_1 = ccui.Helper:seekWidgetByName(root, "Text_build_scientific_up_1")
    Text_build_scientific_up_1:setString("")
    Text_build_scientific_up_1:removeAllChildren(true)
    local font_size = Text_build_scientific_up_1:getFontSize()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, 
        string.format(tipString_info_project_pacific_rim[21], self._base_barracks_info.name, level), config_res.font.font_name,font_size)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, string.format(red_alert_all_str[13], level + 1), config_res.font.font_name,font_size)
    _richText:pushBackElement(re2)
    _richText:setPosition(cc.p(Text_build_scientific_up_1:getContentSize().width/2,Text_build_scientific_up_1:getContentSize().height/2))
    _richText:setContentSize(cc.size(Text_build_scientific_up_1:getContentSize().width,font_size))
    Text_build_scientific_up_1:addChild(_richText)

    -- 科技描述
    local Text_build_scientific_up_2 = ccui.Helper:seekWidgetByName(root, "Text_build_scientific_up_2")
    Text_build_scientific_up_2:setString("")
    Text_build_scientific_up_2:removeAllChildren(true)

    local talent_info = zstring.split(dms.string(dms["talent_mould"], self._base_barracks_info.gift, talent_mould.base_additional), "|")
    talent_info = zstring.split(talent_info[1], ",")
    local add_attr = tonumber(talent_info[2])
    local add_attr_all = add_attr * level
    for k, v in pairs(attribute_hundred) do
        if v == tonumber(talent_info[1]) then
            add_attr = ""..add_attr.."%"
            add_attr_all = ""..add_attr_all.."%"
            break
        end
    end

    local font_size = Text_build_scientific_up_2:getFontSize()
    local dec_info = zstring.split(self._base_barracks_info.dec, "!x@")
    local _richText_1 = ccui.RichText:create()
    _richText_1:ignoreContentAdaptWithSize(false)    
    local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255,dec_info[1].." +"..add_attr_all, config_res.font.font_name,font_size)
    _richText_1:pushBackElement(re3)
    re4 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255,"+"..add_attr, config_res.font.font_name,font_size)
    _richText_1:pushBackElement(re4)
    _richText_1:setPosition(cc.p(Text_build_scientific_up_2:getContentSize().width/2,Text_build_scientific_up_2:getContentSize().height/2))
    _richText_1:setContentSize(cc.size(Text_build_scientific_up_2:getContentSize().width,font_size))
    Text_build_scientific_up_2:addChild(_richText_1)

    -- 升级需求
    self._can_update = true
    -- 科研中心等级
    local Text_build_scientific_lv = ccui.Helper:seekWidgetByName(root, "Text_build_scientific_lv")
    Text_build_scientific_lv:setString(string.format(tipString_info_project_pacific_rim[22], level + 1))
    if level < tonumber(_ED.home_build["3"].level) then
        Text_build_scientific_lv:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    else
        Text_build_scientific_lv:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        self._can_update = false
    end

    --计算科技飙升活动加层
    local activity_discount = 1
    local talentInfo = dms.string(dms["talent_mould"],self._base_barracks_info.gift, talent_mould.base_additional)
    local infoArry = zstring.split(talentInfo,"|")
    local currType = zstring.split(infoArry[1],",")
    if _ED.activity_info["85"] ~= nil and tonumber(currType[1]) == 59 then
        local timesData = zstring.split(_ED.activity_info["85"].activity_add_state, ",")
        self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        if self.m_times > 0 then
            activity_discount = tonumber(timesData[3])
        end
    end

    local barracks_level_info = _ED.base_barracks_level_info[""..level]
    local iron_factor = self._base_barracks_info.cost_iron_factor * barracks_level_info.cost_iron * activity_discount
    local oil_factor = self._base_barracks_info.cost_oil_factor * barracks_level_info.cost_oil * activity_discount
    local lead_factor = self._base_barracks_info.cost_lead_factor * barracks_level_info.cost_lead * activity_discount
    local tita_factor = self._base_barracks_info.cost_tita_factor * barracks_level_info.cost_tita * activity_discount
    local gem_factor = self._base_barracks_info.cost_gem_factor * barracks_level_info.cost_gem * activity_discount


    self._resource_type = {}
    local info = {
        {level + 1, _ED.user_info.credit_level, 44},
        {iron_factor, _ED.user_info.user_iron, 33},
        {oil_factor, _ED.user_info.oil_field, 41},
        {lead_factor, _ED.user_info.exploits, 42},
        {tita_factor, _ED.user_info.tiger_shaped, 43},
        {gem_factor, _ED.user_info.user_silver, 1}
    }

    local index = 1

    for i = 1, 4 do
        local Panel_build_quickly_icon = ccui.Helper:seekWidgetByName(root, "Panel_build_quickly_icon_"..i)
        local Text_build_quickly_gold_consume = ccui.Helper:seekWidgetByName(root, "Text_build_quickly_gold_consume_"..i)
        Panel_build_quickly_icon:removeAllChildren(true)
        Text_build_quickly_gold_consume:setString("")
    end

    for i = 1, #info do
        if info[i][1] > 0 then
            local Panel_build_quickly_icon = ccui.Helper:seekWidgetByName(root, "Panel_build_quickly_icon_"..index)
            local Text_build_quickly_gold_consume = ccui.Helper:seekWidgetByName(root, "Text_build_quickly_gold_consume_"..index)
            local prop_data = {}
            prop_data.prop_item = -1
            prop_data.prop_type = tonumber(info[i][3])
            prop_data.item_value = 0
            local cell = createPropIconCell(prop_data, false, false, false)
            Panel_build_quickly_icon:addChild(cell)

            if prop_data.prop_type == 44 then
                Text_build_quickly_gold_consume:setString(string.format(red_alert_all_str[13], info[i][1]).."/"..string.format(red_alert_all_str[13], info[i][2]))
            else
                Text_build_quickly_gold_consume:setString(exChangeNumToString(info[i][1]).."/"..exChangeNumToString(info[i][2]))
            end
            if tonumber(info[i][1]) > tonumber(info[i][2]) then
                Text_build_quickly_gold_consume:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
                self._can_update = false
            else
                Text_build_quickly_gold_consume:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            end
            table.insert(self._resource_type, prop_data.prop_type)
            index = index + 1
        end
    end

    -- 按钮状态
    local Button_gold_quickly = ccui.Helper:seekWidgetByName(root, "Button_gold_quickly")
    if self._can_update == true then
        Button_gold_quickly:setTouchEnabled(true)
        Button_gold_quickly:setBright(true)
    else
        Button_gold_quickly:setTouchEnabled(false)
        Button_gold_quickly:setBright(false)
    end

    -- 科研目标所需时间
    local Text_build_up_scientific_up_time = ccui.Helper:seekWidgetByName(root,"Text_build_up_scientific_up_time")
    local max_time = zstring.tonumber(barracks_level_info.need_time * self._base_barracks_info.upgrade_factor * activity_discount)

    -- 计算研究加速百分比
    local build_level = _ED.home_build["3"].level
    local build_produce = build_level * _ED.base_build_info["3"].add_get_speed * 100     -- 科技速度提升
    max_time = max_time / (1 + (build_produce + _ED.barracks_time_factor) / 100)

    Text_build_up_scientific_up_time:setString("")
    Text_build_up_scientific_up_time:removeAllChildren(true)
    local fontSize2 = Text_build_up_scientific_up_time:getFontSize()
    if activity_discount ~= 1 then
        local _richText_1 = ccui.RichText:create()
        _richText_1:ignoreContentAdaptWithSize(false) 
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, ""..exChangeTimeToString(max_time), config_res.font.font_name,fontSize2)
        _richText_1:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, activity_str_tip[133], config_res.font.font_name,fontSize2)
        _richText_1:pushBackElement(re2)
        _richText_1:setContentSize(cc.size(root:getContentSize().width,fontSize2))
        _richText_1:setPosition(cc.p(_richText_1:getContentSize().width / 2,0))
        Text_build_up_scientific_up_time:addChild(_richText_1) 
    else
        Text_build_up_scientific_up_time:setString(exChangeTimeToString(max_time))
    end
end

function BuildUpScientificUp:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("build_up_scientific_up_update_draw",0,"")
        end
    end
end

--初始化
function BuildUpScientificUp:onInit()
    local csbItem = csb.createNode(config_csb.build_up.build_up_scientific_up)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "build_up_scientific_up_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "build_up_scientific_up_close", 
        terminal_state = 0, 
    }, nil, 3)

    -- 升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gold_quickly"), nil, 
    {
        terminal_name = "build_up_scientific_up_upgrade",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1) 

    for i = 1, 4 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_build_quickly_icon_"..i), nil, 
        {
            terminal_name = "build_up_scientific_up_open_window",
            terminal_state = 0,
            touch_black = true,
            index = i,
        },
        nil,1) 
    end

    self:updateDraw()
end

function BuildUpScientificUp:onEnterTransitionFinish()

end

function BuildUpScientificUp:init(param)
    self._barracks_info = param[1]
    self._base_barracks_info = param[2]
    self:onInit()
    return self
end

function BuildUpScientificUp:onExit()
    state_machine.remove("build_up_scientific_up_show")
    state_machine.remove("build_up_scientific_up_update_draw")
    state_machine.remove("build_up_scientific_up_activity_rule_infor")
    state_machine.remove("build_up_scientific_up_upgrade")
    state_machine.remove("build_up_scientific_up_open_window")
end