-----------------------------
-- 装备洗炼
-----------------------------
EquipmentClear = class("EquipmentClearClass", Window)

local equipment_clear_window_open_terminal = {
    _name = "equipment_clear_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil ==  fwin:find("EquipmentClearClass") then
            local equip = params[1]
            if equip == nil then
                return
            end
            fwin:open(EquipmentClear:new():init(equip), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local equipment_clear_window_close_terminal = {
    _name = "equipment_clear_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EquipmentClearClass"))

        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_clear_window_open_terminal)
state_machine.add(equipment_clear_window_close_terminal)
state_machine.init()

function EquipmentClear:ctor()
    self.super:ctor()
    self.roots = {}
    self._equip = nil
    self._equip_mould_id = nil
    -- 锁定状态
    self._clear_lock_index = {}
    -- 锁定状态
    self._clear_lock_id = {}
    --load lua file 
    app.load("client.red_alert.campaign.weaponry.Weaponry")
    app.load("client.red_alert.packs.equipstorage.EquipmentClearRule")
    app.load("client.loader.formula")
    -- Initialize equipment_clear state machine.
    local function init_equipment_clear_terminal()
        -- 洗炼
        local equipment_clear_sure_terminal = {
            _name = "equipment_clear_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local iron_consume = zstring.split(dms.string(dms["equipment_config"],4,equipment_config.param), ",")
                if tonumber(_ED.user_info.user_iron) < tonumber(iron_consume[2]) then
                    TipDlg.drawTextDailog(red_alert_all_str[81])
                    return 
                end
                local lock_table = "-1"
                if #instance._clear_lock_index > 0 then
                    lock_table = ""
                    for i=1,#instance._clear_lock_index do
                        if i == 1 then
                            lock_table = instance._clear_lock_index[i]
                        else
                            lock_table = lock_table .. "," ..instance._clear_lock_index[i]
                        end
                    end
                end
                local function responseEquipmentEscalateCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                            response.node:playActions()
                        end
                    end
                end
                protocol_command.equipment_refine.param_list = instance._equip.user_equiment_id .. "\r\n".. lock_table
                NetworkManager:register(protocol_command.equipment_refine.code, nil, nil, nil, instance, responseEquipmentEscalateCallback,false)   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        -- 锁定 or 解锁
        local equipment_clear_add_or_remove_lock_terminal = {
            _name = "equipment_clear_add_or_remove_lock",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local equiment_clear_info = _ED.user_equiment_clear_info[""..instance._equip.user_equiment_id]
                local isLock = true
                for i,v in pairs(instance._clear_lock_index) do
                    if params._datas.index == v then
                        isLock = false
                        break
                    end
                end
                if isLock == true then
                    if #instance._clear_lock_index + 1 == #equiment_clear_info.first_clear_attr then
                        TipDlg.drawTextDailog(red_alert_all_str[269])
                        return
                    end

                    local gold_consume_param = zstring.split(dms.string(dms["equipment_config"],5,equipment_config.param), ",")
                    local gold_consume = 0
                    for i=1,#self._clear_lock_index + 1 do
                        gold_consume = gold_consume_param[i]
                    end
                    if tonumber(_ED.user_info.user_gold) < tonumber(gold_consume) then
                        TipDlg.drawTextDailog(red_alert_all_str[79])
                        return
                    end
                    table.insert(instance._clear_lock_index, params._datas.index)
                else
                    for i, v in pairs(instance._clear_lock_index) do
                        if v == params._datas.index then
                            table.remove(instance._clear_lock_index, i)
                        end
                    end
                end
                instance:addremoveLock(params._datas.index, isLock)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        -- 替换
        local equipment_clear_change_terminal = {
            _name = "equipment_clear_change",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseEquipmentEscalateCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            for i,v in pairs(response.node._clear_lock_index) do
                                response.node:addremoveLock(v, false)
                            end
                            response.node._clear_lock_index = {}
                            response.node:onUpdateDraw()
                            response.node:playActions()
                            state_machine.excute("equipment_update_after_awaken",0,"")
                        end
                    end
                end
                protocol_command.equipment_refine_replace.param_list = instance._equip.user_equiment_id .. "\r\n0"
                NetworkManager:register(protocol_command.equipment_refine_replace.code, nil, nil, nil, instance, responseEquipmentEscalateCallback,false) 

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        -- 关闭界面
        local equipment_clear_close_terminal = {
            _name = "equipment_clear_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local equiment_clear_info = _ED.user_equiment_clear_info[""..instance._equip.user_equiment_id]
                if #equiment_clear_info.last_clear_attr > 0 then
                    local tip = ConfirmTip:new()
                    tip:init(instance, instance.onWindowClose, red_alert_all_str[265])
                    fwin:open(tip,fwin._windows)
                else
                    state_machine.excute("equipment_clear_window_close",0,"")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        state_machine.add(equipment_clear_sure_terminal)
        state_machine.add(equipment_clear_add_or_remove_lock_terminal)
        state_machine.add(equipment_clear_change_terminal)
        state_machine.add(equipment_clear_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_equipment_clear_terminal()
end

-- 洗炼成功光效
function EquipmentClear:playActions()
    local root = self.roots[1]
    local Panel_effice = ccui.Helper:seekWidgetByName(root,"Panel_effice")
    Panel_effice:removeAllChildren(true)
    local function ActionCallback( armatureBack )
        armatureBack:removeFromParent(true)
    end
    local jsonPath = "images/ui/effice/effice_equi_strengthen_ten/effice_equi_strengthen_ten.json"
    local atlasPath = "images/ui/effice/effice_equi_strengthen_ten/effice_equi_strengthen_ten.atlas"
    local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation_event", true, nil)
    animation:setPosition(cc.p(Panel_effice:getContentSize().width/2,Panel_effice:getContentSize().height/2))
    sp.initArmature(animation, false)
    animation._invoke = ActionCallback
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    Panel_effice:addChild(animation)
end

--关闭界面
function EquipmentClear:onWindowClose(sure_number)
    local function responseEquipmentEscalateCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("equipment_clear_window_close",0,"")
        end
    end
    if sure_number == 0 then
        protocol_command.equipment_refine_replace.param_list = self._equip.user_equiment_id .. "\r\n1"
       NetworkManager:register(protocol_command.equipment_refine_replace.code, nil, nil, nil, self, responseEquipmentEscalateCallback,false) 
    end
end

-- 是否锁定
function EquipmentClear:addremoveLock(index, isLock)
    local root = self.roots[1]
    local Button_lock = ccui.Helper:seekWidgetByName(root,"Button_lock_"..index)
    if isLock == true then
        Button_lock:setHighlighted(true)
    else
        Button_lock:setHighlighted(false)
    end
    -- 锁定消耗
    local Text_consume_n = ccui.Helper:seekWidgetByName(root,"Text_consume_n")
    local gold_consume_param = zstring.split(dms.string(dms["equipment_config"],5,equipment_config.param), ",")
    local gold_consume = 0
    for i=1,#self._clear_lock_index do
        gold_consume = gold_consume_param[i]
    end
    Text_consume_n:setString(gold_consume)
end

function EquipmentClear:onUpdateDraw()
    local root = self.roots[1]
    -- 洗练装备icon
    local all_icon = dms.int(dms["equipment_mould"],self._equip_mould_id,equipment_mould.All_icon)
    local Panel_equipment_big_icon_2 = ccui.Helper:seekWidgetByName(root,"Panel_equipment_big_icon_2")
    Panel_equipment_big_icon_2:removeBackGroundImage()
    Panel_equipment_big_icon_2:setBackGroundImage(string.format(config_res.images.ui.big_props.big_props, all_icon))
    -- 洗练装备名称
    local quality = dms.int(dms["equipment_mould"],self._equip_mould_id,equipment_mould.grow_level)
    local equip_name = dms.string(dms["equipment_mould"],self._equip_mould_id,equipment_mould.equipment_name)
    local Text_equipment_name_2 = ccui.Helper:seekWidgetByName(root,"Text_equipment_name_2")
    Text_equipment_name_2:setString(equip_name)
    Text_equipment_name_2:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    -- 洗练装备战力
    local Text_equipment_fighting = ccui.Helper:seekWidgetByName(root,"Text_equipment_fighting")
    Text_equipment_fighting:setString(self._equip.equip_fight)
    -- 拥有元宝数量
    local Text_gem_n = ccui.Helper:seekWidgetByName(root,"Text_gem_n")
    if tonumber(_ED.user_info.user_gold) >= 100000 then
        local info = math.floor(tonumber(_ED.user_info.user_gold)/10000)
        Text_gem_n:setString(string.format(red_alert_all_str[122],info))
    else
        Text_gem_n:setString(_ED.user_info.user_gold)
    end
    -- 拥有银两数量
    local Text_clear_n_0 = ccui.Helper:seekWidgetByName(root,"Text_clear_n_0")
    if tonumber(_ED.user_info.user_iron) >= 100000 then
        local info = math.floor(tonumber(_ED.user_info.user_iron)/10000)
        Text_clear_n_0:setString(string.format(red_alert_all_str[122],info))
    else
        Text_clear_n_0:setString(_ED.user_info.user_iron)
    end
    -- 锁定消耗
    local Text_consume_n = ccui.Helper:seekWidgetByName(root,"Text_consume_n")
    local gold_consume_param = zstring.split(dms.string(dms["equipment_config"],5,equipment_config.param), ",")
    local gold_consume = 0
    for i=1,#self._clear_lock_index do
        gold_consume = gold_consume_param[i]
    end
    Text_consume_n:setString(gold_consume)
    -- 洗炼消耗
    local Text_con_n = ccui.Helper:seekWidgetByName(root,"Text_con_n")
    local Text_con_n_1 = ccui.Helper:seekWidgetByName(root,"Text_con_n_1")
    local iron_consume = zstring.split(dms.string(dms["equipment_config"],4,equipment_config.param), ",")
    Text_con_n:setString(iron_consume[2])
    Text_con_n_1:setString(iron_consume[2])

    local Panel_change = ccui.Helper:seekWidgetByName(root,"Panel_change")
    Panel_change:setVisible(false)
    local Panel_clear = ccui.Helper:seekWidgetByName(root,"Panel_clear")
    Panel_clear:setVisible(false)
    -- 原洗炼属性加成
    for i=1,4 do
        local Panel_clear_attribute = ccui.Helper:seekWidgetByName(root,"Panel_clear_attribute_".. i)
        Panel_clear_attribute:setVisible(false)
        local Panel_clear_attribute_1 = ccui.Helper:seekWidgetByName(root,"Panel_clear_attribute_1_".. i)
        Panel_clear_attribute_1:setVisible(false)
        local Panel_clear_arrow = ccui.Helper:seekWidgetByName(root,"Panel_clear_arrow_".. i)
        Panel_clear_arrow:removeBackGroundImage()
        local Panel_clear_arrow_1 = ccui.Helper:seekWidgetByName(root,"Panel_clear_arrow_1_".. i)
        Panel_clear_arrow_1:removeBackGroundImage()
        local Panel_attr_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_attr_icon_1_".. i)
        Panel_attr_icon_1:removeBackGroundImage()
    end
    local equiment_clear_info = _ED.user_equiment_clear_info[""..self._equip.user_equiment_id]
    if equiment_clear_info ~= nil then
        local first_attribute = {}
        for i,v in pairs(equiment_clear_info.first_clear_attr) do
            local Panel_clear_attribute = ccui.Helper:seekWidgetByName(root,"Panel_clear_attribute_".. i)
            Panel_clear_attribute:setVisible(true)
            -- 属性名
            local Text_attr_t = ccui.Helper:seekWidgetByName(root,"Text_attr_t_".. i)
            local property_type = dms.int(dms["equipment_refine_param"], v, equipment_refine_param.property_type)
            local quality = dms.int(dms["equipment_refine_param"], v, equipment_refine_param.quality)
            Text_attr_t:setString(attribute[tonumber(property_type) + 1])
            Text_attr_t:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
            -- 属性值
            local Text_attr_n = ccui.Helper:seekWidgetByName(root,"Text_attr_n_".. i)
            local property_value = dms.int(dms["equipment_refine_param"], v, equipment_refine_param.property_value)
            local is_handred = false
            for i,v in pairs(attribute_hundred) do
                if tonumber(property_type) == v then
                    is_handred = true
                end
            end
            if is_handred == true then
                Text_attr_n:setString("+"..property_value.."%")
            else
                Text_attr_n:setString("+"..property_value)
            end
            Text_attr_n:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
            table.insert(first_attribute,fight_pro_number[""..property_type]*property_value)
            -- 原属性状态
            local max_random_value = dms.int(dms["equipment_refine_param"], v, equipment_refine_param.max_random_value)
            local Panel_clear_arrow_1 = ccui.Helper:seekWidgetByName(root,"Panel_clear_arrow_1_".. i)
            if max_random_value == 10000 then
                Panel_clear_arrow_1:setBackGroundImage(config_res.images.ui.text.text_man)
            end
        end
        -- 洗炼属性
        if #equiment_clear_info.last_clear_attr > 0 then
            Panel_change:setVisible(true)
            for i,v in pairs(equiment_clear_info.last_clear_attr) do
                local Panel_clear_attribute_1 = ccui.Helper:seekWidgetByName(root,"Panel_clear_attribute_1_".. i)
                Panel_clear_attribute_1:setVisible(true)
                -- 属性icon
                local Panel_attr_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_attr_icon_1_".. i)
                local property_type = dms.int(dms["equipment_refine_param"], v, equipment_refine_param.property_type)
                Panel_attr_icon_1:setBackGroundImage(string.format(config_res.images.ui.equip_attribute.equip_attribute, property_type))
                -- 属性名
                local Text_attr_t_1 = ccui.Helper:seekWidgetByName(root,"Text_attr_t_1_".. i)
                local quality = dms.int(dms["equipment_refine_param"], v, equipment_refine_param.quality)
                Text_attr_t_1:setString(attribute[tonumber(property_type) + 1])
                Text_attr_t_1:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
                -- 属性值
                local Text_attr_n_1 = ccui.Helper:seekWidgetByName(root,"Text_attr_n_1_".. i)
                local property_value = dms.int(dms["equipment_refine_param"], v, equipment_refine_param.property_value)
                local is_handred = false
                for i,v in pairs(attribute_hundred) do
                    if tonumber(property_type) == v then
                        is_handred = true
                    end
                end
                if is_handred == true then
                    Text_attr_n_1:setString("+"..property_value.."%")
                else
                    Text_attr_n_1:setString("+"..property_value)
                end
                Text_attr_n_1:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
                -- 新属性状态
                local Panel_clear_arrow = ccui.Helper:seekWidgetByName(root,"Panel_clear_arrow_".. i)
                if nil == Panel_clear_arrow._start_pos then
                    Panel_clear_arrow._start_pos = cc.p(Panel_clear_arrow:getPosition())
                end
                local arrow_x = Panel_clear_arrow._start_pos.x
                local arrow_y = Panel_clear_arrow._start_pos.y
                local max_random_value = dms.int(dms["equipment_refine_param"], v, equipment_refine_param.max_random_value)
                if max_random_value == 10000 then
                    Panel_clear_arrow:setBackGroundImage(config_res.images.ui.text.text_man)
                    Panel_clear_arrow:stopAllActions()
                elseif fight_pro_number[""..property_type]*property_value > tonumber(first_attribute[i]) then
                    Panel_clear_arrow:setBackGroundImage(config_res.images.ui.decorative.ranking_get_up)
                    local actions = cc.RepeatForever:create(cc.Sequence:create(cc.MoveTo:create(0.3, cc.p(arrow_x, arrow_y+5)),cc.MoveTo:create(0.3, cc.p(arrow_x, arrow_y))))
                    Panel_clear_arrow:stopAllActions()
                    Panel_clear_arrow:runAction(actions)
                elseif fight_pro_number[""..property_type]*property_value < tonumber(first_attribute[i]) then
                    Panel_clear_arrow:setBackGroundImage(config_res.images.ui.decorative.ranking_get_down)
                    local actions = cc.RepeatForever:create(cc.Sequence:create(cc.MoveTo:create(0.3, cc.p(arrow_x, arrow_y+5)),cc.MoveTo:create(0.3, cc.p(arrow_x, arrow_y))))
                    Panel_clear_arrow:stopAllActions()
                    Panel_clear_arrow:runAction(actions)
                end
            end
        else
            Panel_clear:setVisible(true)
        end
    end
end

function EquipmentClear:onEnterTransitionFinish()

end

function EquipmentClear:onInit( )
    local csbItem = csb.createNode(config_csb.packs.equipstorage.equipment_clear)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equ_close"), nil, 
    {
        terminal_name = "equipment_clear_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)
   
    -- 洗炼
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_clear_up"), nil, 
    {
        terminal_name = "equipment_clear_sure", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1) 

    -- 洗炼
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_clear_up_1"), nil, 
    {
        terminal_name = "equipment_clear_sure", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1) 

    -- 替换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_change"), nil, 
    {
        terminal_name = "equipment_clear_change", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1) 

    -- 规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rule"), nil, 
    {
        terminal_name = "equipment_clear_rule_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1) 

    -- 锁定 or 解锁
    for i=1,4 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_lock_".. i), nil, 
        {
            terminal_name = "equipment_clear_add_or_remove_lock", 
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
            index = i,
        }, nil, 1) 
    end
	self:onUpdateDraw()	
end


function EquipmentClear:init(equip)
    self._equip = equip
    self._equip_mould_id = equip.user_equiment_template
	self:onInit()
    return self
end

function EquipmentClear:onExit()
    state_machine.remove("equipment_clear_sure")
    state_machine.remove("equipment_clear_add_or_remove_lock")
    state_machine.remove("equipment_clear_change")
    state_machine.remove("equipment_clear_close")
end
