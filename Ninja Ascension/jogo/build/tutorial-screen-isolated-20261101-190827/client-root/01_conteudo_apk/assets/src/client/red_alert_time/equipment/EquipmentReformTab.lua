--------------------------------------------------------------------------------------------------------------
--  装备改造
--------------------------------------------------------------------------------------------------------------
EquipmentReformTab = class("EquipmentReformTabClass", Window)

local equipment_reform_tab_window_open_terminal = {
    _name = "equipment_reform_tab_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = EquipmentReformTab:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_reform_tab_window_open_terminal)
state_machine.init()

function EquipmentReformTab:ctor()
    self.super:ctor()
    self.roots = {}

    self._equipment_id = 0          -- 装备实例id

    self._check_box = nil
    self._is_have_props = true     -- 是否拥有改造需求物品
    self._is_max_level = false     -- 是否已达到改造最高等级
    self._can_use_prop = false     -- 记忆芯片是否足够

    self._is_use_props = false      -- 是否消耗记忆芯片强化

    self.m_times = 0

    app.load("client.red_alert_time.cells.equipment.equipment_reform_props_cell")

    -- Initialize equipment_reform_tab state machine.
    local function init_equipment_reform_tab_terminal()
        -- 改造
        local equipment_reform_tab_reform_terminal = {
            _name = "equipment_reform_tab_reform",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._is_max_level == true then
                    TipDlg.drawTextDailog(red_alert_time_str[56])
                    return
                end
                if instance._is_have_props == false then
                    TipDlg.drawTextDailog(red_alert_time_str[57])
                    return
                end
                local use_prop_num = 0
                if instance._check_box:isSelected() == true then
                    use_prop_num = 1
                end
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                            response.node:playLevelEffect()
                        end
                        TipDlg.drawTextDailog(red_alert_time_str[198])
                        checkPlayEffect(60)
                        state_machine.excute("equipment_strengthen_reform_need_update", 0, "")
                        state_machine.excute("equipment_strengthen_tab_update_draw", 0, "")
                    end
                end
                protocol_command.equipment_rank_up.param_list = instance._equipment_id.."\r\n"..use_prop_num
                NetworkManager:register(protocol_command.equipment_rank_up.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local equipment_reform_tab_update_draw_terminal = {
            _name = "equipment_reform_tab_tab_update_draw",
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

        local equipment_reform_tab_use_prop_terminal = {
            _name = "equipment_reform_tab_use_prop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local is_selected = params
                if instance._can_use_prop == false then
                    if is_selected == true then
                        instance._check_box:setSelected(false)   
                    end
                else
                    instance._is_use_props = is_selected
                    instance:updateLevelInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新活动加层
        local equipment_reform_tab_update_activity_add_draw_terminal = {
            _name = "equipment_reform_tab_update_activity_add_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateLevelInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(equipment_reform_tab_update_activity_add_draw_terminal)
        state_machine.add(equipment_reform_tab_reform_terminal)
        state_machine.add(equipment_reform_tab_update_draw_terminal)
        state_machine.add(equipment_reform_tab_use_prop_terminal)
        state_machine.init()
    end
    
    -- call func equipment_reform_tab create state machine.
    init_equipment_reform_tab_terminal()

end

function EquipmentReformTab:playLevelEffect()
    local root = self.roots[1]
    local Panel_parts_icon = ccui.Helper:seekWidgetByName(root, "Panel_parts_icon")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_equipment_strengthen)
    local armature = ccs.Armature:create("effect_equipment_strengthen")
    armature:getAnimation():playWithIndex(0)
    armature:setPosition(cc.p(Panel_parts_icon:getContentSize().width/2,Panel_parts_icon:getContentSize().height/2))
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc) 
    Panel_parts_icon:addChild(armature)
    armature._invoke = function(armatureBack)
        armature:removeFromParent(true)
    end
end

function EquipmentReformTab:updateDraw()
    local root = self.roots[1]

    local equipment_info = _ED.user_equiment[""..self._equipment_id]
    local equipment_mould_id = equipment_info.equipment_mould_id

    -- 配件图标和名称
    local Panel_parts_icon = ccui.Helper:seekWidgetByName(root, "Panel_parts_icon")
    local Panel_reform_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_reform_props_icon")
    local Text_parts_name = ccui.Helper:seekWidgetByName(root, "Text_parts_name")
    Text_parts_name:setString(equipment_info.equipment_name)
    Panel_parts_icon:removeAllChildren(true)
    Panel_reform_props_icon:removeAllChildren(true)
    local equip_cell = state_machine.excute("props_icon_create_cell", 0, {8, 4, self._equipment_id, 7})
    Panel_parts_icon:addChild(equip_cell)
    

    local equipment_data = dms.element(dms["equipment_mould"], equipment_mould_id)

    -- 显示改造消耗品
    local reform_need_ids = zstring.split(dms.string(dms["equipment_mould"], equipment_mould_id, equipment_mould.awaken_need_resource), ",")
    local reform_max_level = dms.int(dms["equipment_mould"], equipment_mould_id, equipment_mould.star_level)
    local reform_level = tonumber(equipment_info.rank_up_level)
    local ScrollView_consume_props = ccui.Helper:seekWidgetByName(root, "ScrollView_consume_props")
    ScrollView_consume_props:removeAllChildren(true)
    local size = ScrollView_consume_props:getContentSize()
    

    if reform_level < reform_max_level then
        self._is_max_level = false
        local reform_need_id = reform_need_ids[reform_level + 1]

        -- 改造需求消耗道具
        local need_props = zstring.split(dms.string(dms["equipment_remake"], reform_need_id, equipment_remake.need_props), "|")
        for k, v in pairs(need_props) do
            local info = zstring.split(v, ",")
            local prop_id = info[1]
            local max_prop_count = info[3]
            local prop_count = 0 
            if fundPropWidthId(prop_id) ~= nil then 
                local token = fundPropWidthId(prop_id)
                prop_count = zstring.tonumber(token.prop_number)
            end

            if prop_count < tonumber(max_prop_count) then
                self._is_have_props = false
            end

            local cell = state_machine.excute("equipment_reform_props_cell_create", 0, {prop_id, prop_count, max_prop_count})
            cell:setAnchorPoint(cc.p(0, 1))
            cell:setPosition(cc.p((k - 1) * (size.width / 4), size.height))
            ScrollView_consume_props:addChild(cell)
        end

        -- 显示记忆芯片数量
        local cost_prop_info = zstring.split(dms.string(dms["equipment_remake"], reform_need_id, equipment_remake.cost_prop), ",")
        local cell = state_machine.excute("props_icon_create_cell", 0, {6, 1, tonumber(cost_prop_info[1]), 1, -1})
        Panel_reform_props_icon:addChild(cell)

        local prop_count = 0 
        if fundPropWidthId(tonumber(cost_prop_info[1])) ~= nil then 
            local token = fundPropWidthId(tonumber(cost_prop_info[1]))
            prop_count = zstring.tonumber(token.prop_number)
        end

        local Text_reform_consume_n = ccui.Helper:seekWidgetByName(root, "Text_reform_consume_n")
        Text_reform_consume_n:removeAllChildren(true)
        Text_reform_consume_n:setString("")
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)  
        local color = color_Type[6]
        if prop_count >= tonumber(cost_prop_info[3]) then
            color = color_Type[1]
            self._can_use_prop = true
        else
            self._check_box:setSelected(self._is_use_props)
            self._can_use_prop = false
        end
        local re1 = ccui.RichElementText:create(1, cc.c3b(color[1],color[2],color[3]),255, ""..exChangeNumToString(prop_count), "fonts/simhei.ttf",18)
        _richText:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "/"..exChangeNumToString(cost_prop_info[3]), "fonts/simhei.ttf",18)
        _richText:pushBackElement(re2)
        _richText:setPosition(cc.p(Text_reform_consume_n:getContentSize().width/2,Text_reform_consume_n:getContentSize().height/2))
        _richText:setContentSize(cc.size(Text_reform_consume_n:getContentSize().width,18))
        Text_reform_consume_n:addChild(_richText)
    else
        self._is_max_level = true
        local Panel_reform_list_2_box = ccui.Helper:seekWidgetByName(root, "Panel_reform_list_2_box")
        local Panel_reform_list_3 = ccui.Helper:seekWidgetByName(root, "Panel_reform_list_3")
        local Panel_reform_list_4 = ccui.Helper:seekWidgetByName(root, "Panel_reform_list_4")
        local Text_reform_prompt = ccui.Helper:seekWidgetByName(root, "Text_reform_prompt")
        Panel_reform_list_2_box:setVisible(false)
        Panel_reform_list_3:setVisible(false)
        Panel_reform_list_4:setVisible(false)
        Text_reform_prompt:setVisible(true)
    end
    self:updateLevelInfo()
end

function EquipmentStrengthenTab:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self.m_times <= 0 then
            self.m_times = 0
            self:updateLevelInfo()
        end
    end
end

function EquipmentReformTab:updateLevelInfo()
    local root = self.roots[1]

    local equipment_info = _ED.user_equiment[""..self._equipment_id]
    local equipment_mould_id = equipment_info.equipment_mould_id

    local strength_level = tonumber(equipment_info.upgrade_level)         -- 当前强化等级
    local reform_level = tonumber(equipment_info.rank_up_level)           -- 当前改造等级

    -- 属性变化箭头
    for i = 1, 5 do
        local Panel_reform_state = ccui.Helper:seekWidgetByName(root, "Panel_reform_state_" .. i)
        Panel_reform_state:removeBackGroundImage()
    end
    
    -- 降低强化等级
    local minus_level = dms.int(dms["equipment_mould"], equipment_mould_id, equipment_mould.equipment_gem_numbers)
    if self._is_use_props == true
        then
        minus_level = 0
    end
    local activity_add = false
    if _ED.activity_info["68"] ~= nil then
        local timesData = zstring.split(_ED.activity_info["68"].activity_add_state, ",")
        self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        if self.m_times > 0 then
            activity_add = true
        end
    end
    if activity_add == true then
        minus_level = 0
    end

    local next_strength_level = strength_level - minus_level
    local next_reform_level = reform_level + 1
    if next_strength_level < 0 then
        next_strength_level = 0
    end

    -- 强度和强化改造等级 
    local Text_reform_attribute_n_1 = ccui.Helper:seekWidgetByName(root, "Text_reform_attribute_n_1") -- 当前强度
    local Text_reform_attribute_n_2 = ccui.Helper:seekWidgetByName(root, "Text_reform_attribute_n_2") -- 当前强化等级
    local Text_reform_attribute_n_3 = ccui.Helper:seekWidgetByName(root, "Text_reform_attribute_n_3") -- 当前强度
    Text_reform_attribute_n_1:setString(getEquipmentStrength(equipment_mould_id, strength_level, reform_level))
    Text_reform_attribute_n_2:setString(strength_level)
    Text_reform_attribute_n_3:setString(reform_level)

    local Text_reform_attribute_change_1 = ccui.Helper:seekWidgetByName(root, "Text_reform_attribute_change_1") -- 下一级强度
    local Text_reform_attribute_change_2 = ccui.Helper:seekWidgetByName(root, "Text_reform_attribute_change_2") -- 下一级强化等级
    local Text_reform_attribute_change_3 = ccui.Helper:seekWidgetByName(root, "Text_reform_attribute_change_3") -- 下一级强度
    if self._is_max_level == false then
        Text_reform_attribute_change_1:setString(getEquipmentStrength(equipment_mould_id, next_strength_level, next_reform_level))
        Text_reform_attribute_change_2:setString(next_strength_level)
        Text_reform_attribute_change_3:setString(next_reform_level)

        local Panel_reform_state_1 = ccui.Helper:seekWidgetByName(root, "Panel_reform_state_1")
        local Panel_reform_state_2 = ccui.Helper:seekWidgetByName(root, "Panel_reform_state_2")
        local Panel_reform_state_3 = ccui.Helper:seekWidgetByName(root, "Panel_reform_state_3")
        Panel_reform_state_1:setBackGroundImage(config_res.images.ui.equipment.equipment_arrow_1)
        Panel_reform_state_3:setBackGroundImage(config_res.images.ui.equipment.equipment_arrow_1)
        if activity_add == false then
            if next_strength_level < strength_level then
                Panel_reform_state_2:setBackGroundImage(config_res.images.ui.equipment.equipment_arrow_2)
            end
        end
    else
        Text_reform_attribute_change_1:setString("")
        Text_reform_attribute_change_2:setString("")
        Text_reform_attribute_change_3:setString("")
    end

    if activity_add == true then
        ccui.Helper:seekWidgetByName(root, "Text_streng_vip_prompt_2"):setVisible(true)
    else
        ccui.Helper:seekWidgetByName(root, "Text_streng_vip_prompt_2"):setVisible(false)
    end

    -- 属性加成
    local current_equipment_attr = getEquipmentAttr(equipment_mould_id, strength_level, reform_level)
    local next_equipment_attr = nil

    local initial_value_info = zstring.split(dms.string(dms["equipment_mould"], equipment_mould_id, equipment_mould.initial_value), "|")
    local attr_ids = {}
    for k, initial_value in pairs(initial_value_info) do
        local info = zstring.split(initial_value, ",")
        local attr = tonumber(info[1])
        table.insert(attr_ids, attr)
    end

    local Text_reform_attribute_4 = ccui.Helper:seekWidgetByName(root, "Text_reform_attribute_4") -- 属性1名称
    local Text_reform_attribute_n_4 = ccui.Helper:seekWidgetByName(root, "Text_reform_attribute_n_4") -- 属性1当前值
    local Text_reform_attribute_change_4 = ccui.Helper:seekWidgetByName(root, "Text_reform_attribute_change_4") -- 属性1下一级值
    local Panel_reform_state_4 = ccui.Helper:seekWidgetByName(root, "Panel_reform_state_4")
    Text_reform_attribute_change_4:setString("")

    local attr_id = attr_ids[1]             -- 属性1类型
    Text_reform_attribute_4:setString(red_alert_time_attribute[attr_id + 1] .. red_alert_time_str[29])
    local is_hundred = false
    for k, v in pairs(attribute_hundred) do
        if v == attr_id then
            is_hundred = true
            break
        end
    end
    if is_hundred == true then
        Text_reform_attribute_n_4:setString(current_equipment_attr[""..attr_id] .. "%")
    else
        Text_reform_attribute_n_4:setString(current_equipment_attr[""..attr_id])
    end

    if self._is_max_level == false then
        next_equipment_attr = getEquipmentAttr(equipment_mould_id, next_strength_level, next_reform_level)
        if is_hundred == true then
            Text_reform_attribute_change_4:setString(next_equipment_attr[""..attr_id] .. "%")
        else
            Text_reform_attribute_change_4:setString(next_equipment_attr[""..attr_id])
        end
        Panel_reform_state_4:setBackGroundImage(config_res.images.ui.equipment.equipment_arrow_1)
    end

    local Text_reform_attribute_5 = ccui.Helper:seekWidgetByName(root, "Text_reform_attribute_5") -- 属性2名称
    local Text_reform_attribute_n_5 = ccui.Helper:seekWidgetByName(root, "Text_reform_attribute_n_5") -- 属性2当前值
    local Text_reform_attribute_change_5 = ccui.Helper:seekWidgetByName(root, "Text_reform_attribute_change_5") -- 属性2下一级值
    local Panel_reform_state_5 = ccui.Helper:seekWidgetByName(root, "Panel_reform_state_5")
    Text_reform_attribute_change_5:setString("")

    if attr_ids[2] ~= nil then
        local attr_id_2 = attr_ids[2]             -- 属性2类型
        Text_reform_attribute_5:setString(red_alert_time_attribute[attr_id_2 + 1] .. red_alert_time_str[29])
        local is_hundred = false
        for k, v in pairs(attribute_hundred) do
            if v == attr_id_2 then
                is_hundred = true
                break
            end
        end
        if is_hundred == true then
            Text_reform_attribute_n_5:setString(current_equipment_attr[""..attr_id_2] .. "%")
        else
            Text_reform_attribute_n_5:setString(current_equipment_attr[""..attr_id_2])
        end

        if self._is_max_level == false then
            if is_hundred == true then
                Text_reform_attribute_change_5:setString(next_equipment_attr[""..attr_id_2] .. "%")
            else
                Text_reform_attribute_change_5:setString(next_equipment_attr[""..attr_id_2])
            end
            Panel_reform_state_5:setBackGroundImage(config_res.images.ui.equipment.equipment_arrow_1)
        end
    else
        Text_reform_attribute_5:setString("")
        Text_reform_attribute_n_5:setString("")
        Text_reform_attribute_change_5:setString("")
    end

    for i = 1, 5 do
        local Text_reform_attribute_change =  ccui.Helper:seekWidgetByName(root, "Text_reform_attribute_change_"..i)
        local Panel_reform_state =  ccui.Helper:seekWidgetByName(root, "Panel_reform_state_"..i)
        local posX = string.len(Text_reform_attribute_change:getString()) * 10 + Text_reform_attribute_change:getPositionX()
        Panel_reform_state:setPositionX(posX + 5)
    end
end

function EquipmentReformTab:onInit()
    local csbItem = csb.createNode(config_csb.equipment.equipment_reform_tab)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local CheckBox_reform = ccui.Helper:seekWidgetByName(root, "CheckBox_reform")
    CheckBox_reform:setSelected(false)
    self._check_box = CheckBox_reform

    local ListView_reform = ccui.Helper:seekWidgetByName(root, "ListView_reform")
    if nil ~= ListView_reform.setBounceBottomBoundary then
        ListView_reform:setBounceBottomBoundary(0)
    end

    local ScrollView_consume_props = ccui.Helper:seekWidgetByName(root, "ScrollView_consume_props")
    if nil ~= ScrollView_consume_props.setBounceRightBoundary then
        ScrollView_consume_props:setBounceRightBoundary(ScrollView_consume_props:getContentSize().width)
    end

    -- 改造
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reform"), nil, 
    {
        terminal_name = "equipment_reform_tab_reform", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1) 

    local function checkTouchListener( sender, eventType )
        if eventType == ccui.CheckBoxEventType.unselected then
            state_machine.excute("equipment_reform_tab_use_prop", 0, false)
        elseif eventType == ccui.CheckBoxEventType.selected then
            state_machine.excute("equipment_reform_tab_use_prop", 0, true)
        end
    end
    CheckBox_reform:addEventListener(checkTouchListener)

    self:updateDraw()
end

function EquipmentReformTab:onEnterTransitionFinish()
    
end

function EquipmentReformTab:init(params)
    local rootWindow = params[1]
    self._equipment_id = params[2]

    self._rootWindows = rootWindow

    self:onInit()
    return self
end

function EquipmentReformTab:onExit()
    state_machine.remove("equipment_reform_tab_reform")
    state_machine.remove("equipment_reform_tab_tab_update_draw")
    state_machine.remove("equipment_reform_tab_use_prop")
    state_machine.remove("equipment_reform_tab_update_activity_add_draw")
end