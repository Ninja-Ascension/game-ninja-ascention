-- ------------------------------------------------------------------------------------------------------------
--  说明：装甲升级
-- ------------------------------------------------------------------------------------------------------------
ArmorUp = class("ArmorUpClass", Window)

--打开界面
local armor_up_window_open_terminal = {
    _name = "armor_up_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("ArmorUpClass") == nil then
            local _win = ArmorUp:new()
            _win:init(params)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local armor_up_window_close_terminal = {
    _name = "armor_up_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ArmorUpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(armor_up_window_open_terminal)
state_machine.add(armor_up_window_close_terminal)
state_machine.init()

function ArmorUp:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._armor_info = nil
    self._add_exp = 0           -- 使用道具增加的经验值
    self._is_over_exp = false          -- 是否有溢出经验值

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil

    local function init_armor_up_terminal()
        --升级
        local armor_up_equipment_terminal = {
            _name = "armor_up_equipment",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._is_over_exp == true then
                    TipDlg.drawTextDailog(armor_tip_str[39])
                    return true
                end
                instance:sureUpArmor()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 装甲补给
        local armor_up_supply_duplication_terminal = {
            _name = "armor_up_supply_duplication",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("pve_manager_window_open", 0, {_datas = {_page = 3}})
                state_machine.excute("armor_window_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 装甲生产
        local armor_up_produce_terminal = {
            _name = "armor_up_produce",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("armor_up_window_close", 0, "")
                state_machine.excute("armor_change_page", 0, {_datas = {page = 1}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_up_update_get_exp_terminal = {
            _name = "armor_up_update_get_exp",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local add_exp = params
                instance:updateGetExp(add_exp)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 批量选择
        local armor_up_update_batch_choose_terminal = {
            _name = "armor_up_update_batch_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                for k, v in pairs(instance._list_view:getItems()) do
                    state_machine.excute("armor_packs_cell_set_batch_choose", 0, {v, params})
                end
                instance:checkGetExp()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local armor_up_update_draw_terminal = {
            _name = "armor_up_update_draw",
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

        state_machine.add(armor_up_equipment_terminal)
        state_machine.add(armor_up_supply_duplication_terminal)
        state_machine.add(armor_up_produce_terminal)
        state_machine.add(armor_up_update_get_exp_terminal)
        state_machine.add(armor_up_update_batch_choose_terminal)
        state_machine.add(armor_up_update_draw_terminal)
        state_machine.init()
    end
    init_armor_up_terminal()
end

function ArmorUp:playLevelEffect()
    local root = self.roots[1]
    local Panel_armor_up_ing_icon = ccui.Helper:seekWidgetByName(root, "Panel_armor_up_ing_icon")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_equipment_strengthen)
    local armature = ccs.Armature:create("effect_equipment_strengthen")
    armature:getAnimation():playWithIndex(0)
    armature:setPosition(cc.p(Panel_armor_up_ing_icon:getContentSize().width/2,Panel_armor_up_ing_icon:getContentSize().height/2))
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc) 
    Panel_armor_up_ing_icon:addChild(armature)
    armature._invoke = function(armatureBack)
        armature:removeFromParent(true)
    end
end

function ArmorUp:sureUpArmor()
    local sell_result = {}
    for k, v in pairs(self._list_view:getItems()) do
        if v:isSelected() == true then
            if sell_result[""..v._id] == nil then
                local info = {
                    prop_item = 0,
                    prop_type = 0,
                    item_value = 0,
                }
                info.prop_item = v._id
                if v._prop_type == 1 then
                    info.prop_type = 7
                elseif v._prop_type == 2 then
                    info.prop_type = 6 
                end
                sell_result[""..v._id] = info
            end
            sell_result[""..v._id].item_value = sell_result[""..v._id].item_value + 1
        end
    end

    local param_list = nil
    local is_first = true
    for k, v in pairs(sell_result) do
        local param = ""..v.prop_item..","..v.prop_type..","..v.item_value
        if is_first == true then
            is_first = false
            param_list = param
        else
            param_list = param_list.."|"..param
        end
    end

    if param_list == nil then
        TipDlg.drawTextDailog(armor_tip_str[20])
        return
    end
    local formation_type = self._armor_info.formation_type
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots ~= nil then
                response.node._armor_info = _ED.user_equiment[""..response.node._armor_info.equip_id]
                state_machine.excute("armor_up_update_draw", 0, "")
                response.node:playLevelEffect()
            end
            if formation_type > 0 then
                state_machine.excute("armor_equipment_update", 0, "")
            else
                state_machine.excute("armor_pack_update", 0, "")
            end
            TipDlg.drawTextDailog(red_alert_time_str[288])
        end
    end
    protocol_command.armor_upgrade.param_list = ""..self._armor_info.equip_id.."\r\n"..param_list
    NetworkManager:register(protocol_command.armor_upgrade.code, nil, nil, nil, self, responseCallback, false, nil)
end

-- 刷新获得经验值
function ArmorUp:updateGetExp(add_exp)
    self._add_exp = self._add_exp + add_exp
    self:updateArmorInfo()
end

function ArmorUp:checkGetExp()
    self._add_exp = 0
    for k, v in pairs(self._list_view:getItems()) do
        if v:isSelected() == true then
            self._add_exp = self._add_exp + tonumber(v._cost)
        end
    end
    self:updateArmorInfo()
end

function ArmorUp:updateArmorInfo()
    local root = self.roots[1]
    local Text_armor_up_name = ccui.Helper:seekWidgetByName(root,"Text_armor_up_name")
    local Panel_armor_up_ing_icon = ccui.Helper:seekWidgetByName(root,"Panel_armor_up_ing_icon")
    local Text_armor_up_ing_name = ccui.Helper:seekWidgetByName(root,"Text_armor_up_ing_name")
    local Text_armor_up_attribte_1 = ccui.Helper:seekWidgetByName(root,"Text_armor_up_attribte_1")
    local Text_armor_up_attribte_2 = ccui.Helper:seekWidgetByName(root,"Text_armor_up_attribte_2")
    local Text_armor_up_ing_num = ccui.Helper:seekWidgetByName(root,"Text_armor_up_ing_num")
    local Text_armor_up_ing_lv = ccui.Helper:seekWidgetByName(root,"Text_armor_up_ing_lv")
    local LoadingBar_help_arrive_bar = ccui.Helper:seekWidgetByName(root,"LoadingBar_help_arrive_bar")
    local Text_armor_up_text_effect = ccui.Helper:seekWidgetByName(root,"Text_armor_up_text_effect")
    local Text_armor_up_text_1 = ccui.Helper:seekWidgetByName(root,"Text_armor_up_text_1")

    -- 装甲属性
    local equipment_mould_id = tonumber(self._armor_info.equipment_mould_id)
    local formation_type = tonumber(self._armor_info.formation_type)
    local level = tonumber(self._armor_info.upgrade_level)
    local experience = tonumber(self._armor_info.experience)
    local quailty = tonumber(self._armor_info.grow_level)
    -- 属性
    local attr_info = zstring.split(self._armor_info.attr, ",")
    local attr_name = red_alert_time_attribute[tonumber(attr_info[1]) + 1]
    local current_attr = tonumber(attr_info[2])
    local grow_value_info = zstring.split(dms.string(dms["equipment_mould"], equipment_mould_id, equipment_mould.grow_value), ",")   -- 每级强化成长
    local grow_value = tonumber(grow_value_info[4])

    local prev_level = level                        -- 预览升级等级
    local total_exp = experience + self._add_exp        -- 总增加经验
    local leave_exp = total_exp
    local need_exp = 0
    self._is_over_exp = false
    for i = prev_level, dms.count(dms["equipment_level_requirement"]) - 1 do
        need_exp = dms.int(dms["equipment_level_requirement"], i + 1, equipment_level_requirement.need_exp_1 + quailty)
        local need_user_grade = dms.int(dms["equipment_level_requirement"], i + 1, equipment_level_requirement.ship_level)
        if need_exp == -1 or tonumber(_ED.user_info.user_grade) < need_user_grade then
            prev_level = i + 1
            need_exp = math.max(0, need_exp)
            if leave_exp > need_exp then
                self._is_over_exp = true
            end
            leave_exp = 0
            break
        end
        if leave_exp <= need_exp then
            prev_level = i + 1
            break
        end
        leave_exp = leave_exp - need_exp
    end

    -- 预览升级后属性
    local prev_attr_value = current_attr + (prev_level - level) * grow_value

    Text_armor_up_name:setString(string.format(armor_tip_str[10], formation_type))

    -- 装甲图标
    Panel_armor_up_ing_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{8, 14, equipment_mould_id, 15, nil, nil, self._armor_info})
    Panel_armor_up_ing_icon:addChild(cell)

    -- 加成属性
    Text_armor_up_ing_name:setString(attr_name)

    local font_size = Text_armor_up_attribte_1:getFontSize()
    Text_armor_up_attribte_1:setString("")
    Text_armor_up_attribte_1:removeAllChildren(true)
    local _richText1 = ccui.RichText:create()
    _richText1:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, attr_name, config_res.font.font_name,font_size)
    _richText1:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]),255, string.format(armor_tip_str[8], current_attr), config_res.font.font_name,font_size)
    _richText1:pushBackElement(re2)
    _richText1:setPosition(cc.p(Text_armor_up_attribte_1:getContentSize().width/2,Text_armor_up_attribte_1:getContentSize().height/2))
    _richText1:setContentSize(cc.size(Text_armor_up_attribte_1:getContentSize().width,font_size))
    Text_armor_up_attribte_1:addChild(_richText1)

    Text_armor_up_attribte_2:setString("")
    Text_armor_up_attribte_2:removeAllChildren(true)
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, attr_name, config_res.font.font_name,font_size)
    _richText2:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]),255, string.format(armor_tip_str[8], prev_attr_value), config_res.font.font_name,font_size)
    _richText2:pushBackElement(re2)
    _richText2:setPosition(cc.p(Text_armor_up_attribte_2:getContentSize().width/2,Text_armor_up_attribte_2:getContentSize().height/2))
    _richText2:setContentSize(cc.size(Text_armor_up_attribte_2:getContentSize().width,font_size))
    Text_armor_up_attribte_2:addChild(_richText2)

    -- 经验值
    Text_armor_up_ing_lv:setString(friends_tip_string[12]..prev_level)
    Text_armor_up_ing_num:setString(""..leave_exp.."/"..need_exp)
    local percent = leave_exp * 100 / need_exp
    LoadingBar_help_arrive_bar:setPercent(percent)

    font_size = Text_armor_up_text_effect:getFontSize()
    Text_armor_up_text_effect:setString("")
    Text_armor_up_text_effect:removeAllChildren(true)
    if self._add_exp > 0 then
        Text_armor_up_text_1:setVisible(false)
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)       
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, armor_tip_str[19], config_res.font.font_name,font_size)
        _richText:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, exChangeNumToString(self._add_exp), config_res.font.font_name,font_size)
        _richText:pushBackElement(re2)
        _richText:setPosition(cc.p(Text_armor_up_text_effect:getContentSize().width/2,Text_armor_up_text_effect:getContentSize().height/2))
        _richText:setContentSize(cc.size(Text_armor_up_text_effect:getContentSize().width,font_size))
        Text_armor_up_text_effect:addChild(_richText)
    else
        Text_armor_up_text_1:setVisible(true)
    end
end

-- 显示信息
function ArmorUp:onUpdateDraw()
    local root = self.roots[1]
    local Panel_armor_up = ccui.Helper:seekWidgetByName(root,"Panel_armor_up")
    local Panel_armor_up_empty = ccui.Helper:seekWidgetByName(root,"Panel_armor_up_empty")
    Panel_armor_up:setVisible(false)
    Panel_armor_up_empty:setVisible(false)
    local ListView_armor_up_list = ccui.Helper:seekWidgetByName(root,"ListView_armor_up_list")
    ListView_armor_up_list:jumpToTop()

    local armor_list = {}       -- 装甲
    local prop_list = {}        -- 经验
    -- 未穿戴装甲
    for k, v in pairs(getArmorList()) do
        if tonumber(v.formation_type) == 0 
            and tonumber(self._armor_info.equip_id) ~= tonumber(v.equip_id)
            then
            local armor = {
                prop_type = 1,
                info = v,
            }
            table.insert(armor_list, armor)
        end
    end
    -- 经验值道具
    for k, v in pairs(getPropPackList(26)) do
        local prop_number = tonumber(v.prop_number)
        for i = 1, prop_number do
            local prop = {
                prop_type = 2, 
                info = v,
                order = dms.int(dms["prop_mould"], tonumber(v.user_prop_template), prop_mould.trace_scene),
            }
            table.insert(prop_list, prop)
        end
    end

    local function sortArormFunction(a, b)
        if a.info.grow_level > b.info.grow_level
            or (a.info.grow_level == b.info.grow_level and tonumber(a.info.upgrade_level) > tonumber(b.info.upgrade_level))
            or (a.info.grow_level == b.info.grow_level and tonumber(a.info.upgrade_level) == tonumber(b.info.upgrade_level) and tonumber(a.info.experience) > tonumber(b.info.experience))
            then
            return true
        end
        return false
    end
    local function sortPropFunction(a, b)
        return a.order < b.order
    end
    table.sort(armor_list, sortArormFunction)
    table.sort(prop_list, sortPropFunction)

    local result = {}
    for k, v in pairs(prop_list) do
        table.insert(result, v)
    end
    for k, v in pairs(armor_list) do
        table.insert(result, v)
    end

    local items = ListView_armor_up_list:getItems()
    for k,v in pairs(items) do
        if result[k] == nil then
            state_machine.excute("armor_packs_cell_update_info", 0, {cell = v, index = k, _prop_type = 0, _info = nil})
        else
            state_machine.excute("armor_packs_cell_update_info", 0, {cell = v, index = k, _prop_type = result[k].prop_type, _info = result[k].info})
        end
    end

    if #result > 0 then
        Panel_armor_up:setVisible(true)
    else
        Panel_armor_up_empty:setVisible(true)
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            ListView_armor_up_list:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("armor_packs_cell_create",0, {i, result[i].info, result[i].prop_type, 3})
            ListView_armor_up_list:addChild(cell)
        end
    end

    ListView_armor_up_list:requestRefreshView()
    self._list_view = ListView_armor_up_list
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    self:checkGetExp()
    self:updateArmorInfo()
end

function ArmorUp:onUpdate( dt )
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

--初始化界面
function ArmorUp:onInit()
    local csbItem = csb.createNode(config_csb.armor.armor_up)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_up_close"), nil, 
    {
        terminal_name = "armor_up_window_close", 
        terminal_state = 0, 
    }, nil, 3)    

    -- 批量选择
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_up_batch_choose"), nil, 
    {
        terminal_name = "armor_batch_choose_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        from_type = 2,
    }, nil, 1)  

    -- 升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_up_equ"), nil, 
    {
        terminal_name = "armor_up_equipment", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 装甲生产
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_production"), nil, 
    {
        terminal_name = "armor_up_produce", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        page = 1,
    }, nil, 1)  

    -- 装甲补给
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_up_pve_get"), nil, 
    {
        terminal_name = "armor_up_supply_duplication", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_armor_up_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_armor_up_arrow_up")
    
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

--初始化
function ArmorUp:init(params)
    self._armor_info = params[1]
    self:setTouchEnabled(true)
    self:onInit()
end

--移除状态机
function ArmorUp:onExit()   
    state_machine.remove("armor_up_equipment")
    state_machine.remove("armor_up_supply_duplication")
    state_machine.remove("armor_up_produce")
    state_machine.remove("armor_up_update_get_exp")
    state_machine.remove("armor_up_update_batch_choose")
    state_machine.remove("armor_up_update_draw")
end
