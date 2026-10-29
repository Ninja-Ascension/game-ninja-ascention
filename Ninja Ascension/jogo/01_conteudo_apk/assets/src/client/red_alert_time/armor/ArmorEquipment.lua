--------------------------------------------------------------------------------------------------------------
--  说明：装甲
--------------------------------------------------------------------------------------------------------------
ArmorEquipment = class("ArmorEquipmentClass", Window)

--打开界面
local armor_equipment_window_open_terminal = {
    _name = "armor_equipment_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = ArmorEquipment:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(armor_equipment_window_open_terminal)
state_machine.init()

function ArmorEquipment:ctor()
    self.super:ctor()
    self.roots = {}

    self._cell_tables = {}
    self._panel_tables = {}
    self.last_choose_cell = nil

    self.current_formation = 0
    self.armor_cell_tables = {}

    self.armor_info_list = {}
    self._install_state = 1    -- 0：一键安装，1：一键卸下

    self._is_init = true

    local function init_armor_equipment_terminal()
        local armor_equipment_show_terminal = {
            _name = "armor_equipment_show",
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

        local armor_equipment_hide_terminal = {
            _name = "armor_equipment_hide",
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

        local armor_equipment_update_terminal = {
            _name = "armor_equipment_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateArmorInfo()
                instance:updateFormationState()
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_equipment_load_all_terminal = {
            _name = "armor_equipment_load_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local state = instance._install_state
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("armor_equipment_update", 0, "")
                        end
                        state_machine.excute("armor_pack_update", 0, "")
                        if state == 0 then
                            TipDlg.drawTextDailog(armor_tip_str[30])
                        else
                            TipDlg.drawTextDailog(armor_tip_str[31])
                        end
                    end
                end
                protocol_command.armor_quick_wear.param_list = ""..instance.current_formation.."\r\n"..instance._install_state
                NetworkManager:register(protocol_command.armor_quick_wear.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 选择查看阵位
        local armor_equipment_choose_formation_terminal = {
            _name = "armor_equipment_choose_formation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:chooseFormation(params)
                state_machine.excute("notification_center_update", 0, "push_notification_armor_icon")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 交换两个阵位
        local armor_equipment_change_formation_terminal = {
            _name = "armor_equipment_change_formation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local new_formation_type = params
                instance:changeFormation(new_formation_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 查看套装属性
        local armor_equipment_look_up_suit_info_terminal = {
            _name = "armor_equipment_look_up_suit_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("armor_suit_effect_look_window_open", 0, {instance.current_formation})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_equipment_update_one_click_setup_terminal = {
            _name = "armor_equipment_update_one_click_setup",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateOneClickSetup()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(armor_equipment_show_terminal)   
        state_machine.add(armor_equipment_hide_terminal)
        state_machine.add(armor_equipment_update_terminal)
        state_machine.add(armor_equipment_load_all_terminal)
        state_machine.add(armor_equipment_choose_formation_terminal)
        state_machine.add(armor_equipment_change_formation_terminal)
        state_machine.add(armor_equipment_look_up_suit_info_terminal)
        state_machine.add(armor_equipment_update_one_click_setup_terminal)
        state_machine.init()
    end
    init_armor_equipment_terminal()
end

-- 切换阵位时逐个显示图标动画
function ArmorEquipment:playShowArmorIcon()
    if self._is_init == true then
        self._is_init = false
        return
    end

    local root = self.roots[1]

    local function playShowIcon(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            sender:setVisible(true)
        end
    end

    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            sender:setVisible(false)
            sender:runAction(cc.Sequence:create(
                    cc.DelayTime:create((sender._index + 1) * 0.03),
                    cc.CallFunc:create(playShowIcon)
                    ))
        end
    end

    for i = 1, 6 do
        local Panel_armor_suit_icon = ccui.Helper:seekWidgetByName(root, "Panel_armor_suit_icon_"..i)
        local Image_armor_attribute_line = ccui.Helper:seekWidgetByName(root, "Image_armor_attribute_line_"..i)

        Panel_armor_suit_icon:setVisible(true)
        Panel_armor_suit_icon._index = i
        Panel_armor_suit_icon:stopAllActions()
        Panel_armor_suit_icon:runAction(cc.Sequence:create(
                    cc.DelayTime:create(i * 0.03),
                    cc.CallFunc:create(playActions)
                    ))

        Image_armor_attribute_line:setVisible(false)
    end

    local line_index = 0

    local function playShowLine(sender)
        if sender.roots ~= nil and sender.roots[1] ~= nil and line_index <= 6 then
            local root = sender.roots[1]

            if line_index > 0 then
                local Image_armor_attribute_line = ccui.Helper:seekWidgetByName(root, "Image_armor_attribute_line_"..line_index)
                Image_armor_attribute_line:setVisible(true)
            end
            line_index = line_index + 1

            sender:runAction(cc.Sequence:create(
                    cc.DelayTime:create(0.06),
                    cc.CallFunc:create(playShowLine)
                    ))
        end
    end

    playShowLine(self)
end

-- 刷新阵位按钮状态
function ArmorEquipment:updateFormationState()
    for i = 1, 6 do
        local panel = self._panel_tables[i]
        local cell = panel:getChildByTag(i)

        local selected = false
        if i == self.current_formation then
            selected = true
        end
        state_machine.excute("armor_formation_cell_set_selected", 0, {cell, selected})

        local armor_list = {}
        if self.armor_info_list[""..i] ~= nil then
            armor_list = self.armor_info_list[""..i]
        end
        -- 加成属性
        local max_attr_index = 0
        local max_attr = 0                      -- 加成最高的属性
        for i = 1, 6 do
            local armor_info = armor_list[""..i]
            if armor_info ~= nil then
                local attr_info = zstring.split(armor_info.attr, ",")
                if tonumber(attr_info[2]) > max_attr then
                    max_attr = tonumber(attr_info[2])
                    max_attr_index = tonumber(armor_info.armor_type)
                end
            end
        end
        state_machine.excute("armor_formation_cell_update_draw", 0, {cell, max_attr_index})
    end
end

function ArmorEquipment:changeFormation(new_formation_type)
    if self.current_formation == new_formation_type then
        return
    end
    local old_formation_type = self.current_formation

    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node.current_formation = new_formation_type
                state_machine.excute("armor_equipment_update", 0, "")
                response.node:playShowArmorIcon()
            end
        end
    end
    protocol_command.armor_formation_change.param_list = ""..old_formation_type.."\r\n"..new_formation_type
    NetworkManager:register(protocol_command.armor_formation_change.code, nil, nil, nil, self, responseCallback, false, nil)
end

-- 选择查看阵位
function ArmorEquipment:chooseFormation(formation_type)
    if self.current_formation == formation_type then
        return
    end
    if self.current_formation > 0 then
        local panel = self._panel_tables[self.current_formation]
        local cell = panel:getChildByTag(self.current_formation)
        state_machine.excute("armor_formation_cell_set_selected", 0, {cell, false})
    end
    if formation_type > 0 then
        local panel = self._panel_tables[formation_type]
        local cell = panel:getChildByTag(formation_type)
        state_machine.excute("armor_formation_cell_set_selected", 0, {cell, true})
    end
    self.current_formation = formation_type
    self:playShowArmorIcon()
    self:onUpdateDraw()
end

function ArmorEquipment:onUpdateDraw()
    local root = self.roots[1]

    -- 装备装甲
    local armor_list = {}
    if self.armor_info_list[""..self.current_formation] ~= nil then
        armor_list = self.armor_info_list[""..self.current_formation]
    end
    -- 加成属性
    local max_attr_index = 0
    local max_attr = 0                      -- 加成最高的属性
    local addition_info = _ED.armor_attributes_addition[self.current_formation]         -- 装甲加成属性
    local attr_info = addition_info.attr_info
    local suit_attr_info = addition_info.suit_attr_info
    for i = 1, 6 do
        if attr_info[i] > max_attr then
            max_attr = attr_info[i]
            max_attr_index = i
        end
    end

    for i = 1, 6 do
        local Text_armor_suit_attribute = ccui.Helper:seekWidgetByName(root, "Text_armor_suit_attribute_"..i)
        local armor = armor_list[""..i]

        -- 刷新装甲图标cell
        local cell = self.armor_cell_tables[i]
        if max_attr_index == i then
            state_machine.excute("armor_suit_icon_cell_update_info",0,{cell, armor, true, self.current_formation})
        else
            state_machine.excute("armor_suit_icon_cell_update_info",0,{cell, armor, false, self.current_formation})
        end

        -- 显示装甲加成属性
        local armor_attr = attr_info[i] + suit_attr_info[i]
        Text_armor_suit_attribute:setString(armor_attr_tip_str[i]..string.format(armor_tip_str[8], armor_attr))
        if max_attr_index == i then
            Text_armor_suit_attribute:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
        else
            Text_armor_suit_attribute:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        end
    end

    -- 显示套装加成属性
    local suit_id = 0               -- 套装id
    local add_suit_count = 0        -- 拥有套装数量
    if addition_info.suit_id > 0 then
        suit_id = addition_info.suit_id
        add_suit_count = 6
    else
        local suit_armor_count = {0, 0, 0}
        for k, v in pairs(armor_list) do
            if suit_armor_count[v.suit_id] == nil then
                suit_armor_count[v.suit_id] = 0
            end
            suit_armor_count[v.suit_id] = suit_armor_count[v.suit_id] + 1
        end
        if suit_armor_count[1] > suit_armor_count[2] then
            suit_id = 1
        else
            suit_id = 2
        end
        add_suit_count = suit_armor_count[suit_id]
    end

    local Text_armor_suit_attribute_six = ccui.Helper:seekWidgetByName(root,"Text_armor_suit_attribute_six")
    Text_armor_suit_attribute_six:setString("")
    Text_armor_suit_attribute_six:removeAllChildren(true)
    local str = zstring.split(armor_tip_str[suit_id + 3], ",")
    local color_1 = chat_rich_text_color[1]
    local color_2 = cc.c3b(color_Type[suit_id + 2][1],color_Type[suit_id + 2][2],color_Type[suit_id + 2][3])
    local color_3 = cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3])
    if addition_info.suit_id == 0 then
        color_2 = color_1
        color_3 = color_1
    end
    local fontSize = Text_armor_suit_attribute_six:getFontSize()
    local _richText_1 = ccui.RichText:create()
    _richText_1:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, color_1,255, str[1], config_res.font.font_name,fontSize)
    _richText_1:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, color_2,255, str[2], config_res.font.font_name,fontSize)
    _richText_1:pushBackElement(re2)
    local re3 = ccui.RichElementText:create(1, color_1,255, str[3], config_res.font.font_name,fontSize)
    _richText_1:pushBackElement(re3)
    local re4 = ccui.RichElementText:create(1, color_3,255, str[4], config_res.font.font_name,fontSize)
    _richText_1:pushBackElement(re4)
    local re5 = ccui.RichElementText:create(1, color_1,255, string.format(str[5],add_suit_count), config_res.font.font_name,fontSize)
    _richText_1:pushBackElement(re5)
    _richText_1:setPosition(cc.p(Text_armor_suit_attribute_six:getContentSize().width/2,Text_armor_suit_attribute_six:getContentSize().height/2))
    _richText_1:setContentSize(cc.size(Text_armor_suit_attribute_six:getContentSize().width,fontSize))
    Text_armor_suit_attribute_six:addChild(_richText_1)

    self:updateOneClickSetup()
end

function ArmorEquipment:updateOneClickSetup()
    local root = self.roots[1]
    -- 装备装甲
    local armor_list = {}
    if self.armor_info_list[""..self.current_formation] ~= nil then
        armor_list = self.armor_info_list[""..self.current_formation]
    end

    local Button_armor_one_click_setup = ccui.Helper:seekWidgetByName(root,"Button_armor_one_click_setup")
    self._install_state = 1    -- 0：一键安装，1：一键卸下
    local have_install = false -- 是否有穿戴装备
    if armor_list ~= nil then
        for i = 1, 6 do
            local armor_info = armor_list[""..i]
            if armor_info ~= nil then
                have_install = true
            end
            if getArmorIconTip(self.current_formation, i, true) == true then
                self._install_state = 0
                break
            end
        end
    end
    if have_install == false then
        self._install_state = 0
    end
    if self._install_state == 0 then
        Button_armor_one_click_setup:setTitleText(armor_tip_str[22])
    else
        Button_armor_one_click_setup:setTitleText(armor_tip_str[23])
    end
end

-- 保存当前装备的装甲数据
function ArmorEquipment:updateArmorInfo()
    getArmorAddAttrInfo()
    self.armor_info_list = _ED.push_user_armor_equip_table
end

function ArmorEquipment:initFormation()
    local root = self.roots[1]
    self._cell_tables = {}
    self._panel_tables = {}
    local began_sprite = nil
    local began_position = nil
    local began_ZOrder = nil
    local change_sprite = nil
    local change_position = nil

    local began_panel = nil
    local change_panel = nil

    local began_pos = nil
    local end_pos = nil

    local last_hook_cell_pos = 0
    local function moveFormationSprite(heroSprite, changedPad, pos)
        if heroSprite == nil then
            return
        end
        local xx, yy = heroSprite:getPosition()
        local e_position = fwin:convertToWorldSpace(heroSprite, cc.p(0, 0)) -- heroSprite:convertToWorldSpace(cc.p(0, 0))
        e_position = changedPad:convertToNodeSpace(cc.p(e_position.x, e_position.y))
        heroSprite:setPosition(cc.p(e_position.x, e_position.y))
        
        heroSprite:retain()
        heroSprite:removeFromParent(false)
        changedPad:addChild(heroSprite)
        heroSprite:release()
        heroSprite:setTag(changedPad:getTag())
        
        began_position = cc.p(0, 0)
        heroSprite:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, began_position)))
        state_machine.excute("armor_formation_cell_update_info", 0, {heroSprite, pos})
    end
    
    local function formationTouchListener(sender, eventType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        if eventType == ccui.TouchEventType.began then
            local formation_type = sender:getTag()
            state_machine.excute("armor_equipment_choose_formation", 0, formation_type)
            for pos, heroCard in pairs(self._cell_tables) do
                local bPosition = heroCard:convertToNodeSpace(cc.p(__spoint.x, __spoint.y))
                if (bPosition.x > 0 and bPosition.x < heroCard:getContentSize().width and bPosition.y > 0 and bPosition.y < heroCard:getContentSize().height) then
                    began_sprite = heroCard
                    began_pos = began_sprite:getTag()
                    local tempX, tempY  = heroCard:getPosition()
                    began_position = cc.p(tempX, tempY)
                    began_ZOrder = heroCard:getLocalZOrder()
                    local parent_node = began_sprite:getParent()
                    began_panel = parent_node 
                    parent_node:reorderChild(began_sprite, 100)
                    parent_node:getParent():reorderChild(parent_node, 100)
                end
            end
        elseif eventType == ccui.TouchEventType.moved then 
            if began_pos == nil then
                return
            end
            if nil ~= began_sprite then
                began_sprite:setPosition(cc.p((__mpoint.x - __spoint.x) / app.scaleFactor + began_position.x , (__mpoint.y - __spoint.y) / app.scaleFactor + began_position.y))

                local temp = cc.p(began_sprite:getContentSize().width/2, began_sprite:getContentSize().height/2)
                local e_position = fwin:convertToWorldSpaceAR(began_sprite, cc.p(temp.x,temp.y))
                local index = 0

                for pos, card_hero in pairs(self._cell_tables) do
                    if card_hero:getTag() ~= began_sprite:getTag() then
                        local bPosition = card_hero:convertToNodeSpaceAR(e_position)
                        if (bPosition.x > 0 and bPosition.x < card_hero:getContentSize().width and bPosition.y > 0 and bPosition.y < card_hero:getContentSize().height) then
                            index = card_hero:getTag()
                        end
                    end
                end
                if index ~= last_hook_cell_pos then
                    if last_hook_cell_pos > 0 then
                        local panel = self._panel_tables[last_hook_cell_pos]
                        local cell = panel:getChildByTag(last_hook_cell_pos)
                        state_machine.excute("armor_formation_cell_set_hook", 0, {cell, false})
                    end
                    if index > 0 then
                        local panel = self._panel_tables[index]
                        local cell = panel:getChildByTag(index)
                        state_machine.excute("armor_formation_cell_set_hook", 0, {cell, true})
                    end
                    last_hook_cell_pos = index
                end
            end
        elseif eventType == ccui.TouchEventType.canceled then
            state_machine.excute("armor_formation_cell_set_selected", 0, {sender, true})
            if began_pos == nil then
                return
            end
            if nil ~= began_sprite then
                began_sprite:setPosition(cc.p(began_position.x, began_position.y))
            end
        elseif eventType == ccui.TouchEventType.ended
            or eventType == ccui.TouchEventType.canceled then
            if began_pos == nil then
                return
            end
            if last_hook_cell_pos > 0 then
                local panel = self._panel_tables[last_hook_cell_pos]
                local cell = panel:getChildByTag(last_hook_cell_pos)
                state_machine.excute("armor_formation_cell_set_hook", 0, {cell, false})
            end

            local isChanged = false
            local temp = cc.p(began_sprite:getContentSize().width/2, began_sprite:getContentSize().height/2)
            local e_position = fwin:convertToWorldSpaceAR(began_sprite, cc.p(temp.x,temp.y))
            for pos, card_hero in pairs(self._cell_tables) do
                if card_hero:getTag() ~= began_sprite:getTag() then
                    local bPosition = card_hero:convertToNodeSpaceAR(e_position)
                    if (bPosition.x > 0 and bPosition.x < card_hero:getContentSize().width and bPosition.y > 0 and bPosition.y < card_hero:getContentSize().height) then
                        isChanged = true
                        change_sprite = card_hero
                        end_pos = card_hero:getTag()
                        change_panel = change_sprite:getParent()
                        break
                    end
                end
            end

            if isChanged == false then
                began_position = cc.p(0, 0)
                began_sprite:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, began_position)))
                local parent_node = began_sprite:getParent() 
                parent_node:reorderChild(began_sprite, began_ZOrder)
            else
                moveFormationSprite(began_sprite, change_panel, end_pos)
                moveFormationSprite(change_sprite, began_panel, began_pos)
                state_machine.excute("armor_equipment_change_formation", 0, end_pos)
            end
        end
    end

    for i = 1, 6 do
        local Panel_armor_fomation = ccui.Helper:seekWidgetByName(root, "Panel_armor_fomation_"..i)
        local cell = state_machine.excute("armor_formation_cell_create", 0, {i})
        Panel_armor_fomation:addChild(cell)
        Panel_armor_fomation:setTag(i)
        cell:setTag(i)
        table.insert(self._panel_tables, Panel_armor_fomation)
        table.insert(self._cell_tables, cell)

        cell:addTouchEventListener(formationTouchListener)
    end
end

function ArmorEquipment:initArmorIconCell()
    local root = self.roots[1]
    for i = 1, 6 do
        local Panel_armor_suit_icon = ccui.Helper:seekWidgetByName(root, "Panel_armor_suit_icon_"..i)
        Panel_armor_suit_icon:removeAllChildren(true)
        local cell = state_machine.excute("armor_suit_icon_cell_create",0,{i, nil, false, self.current_formation})
        Panel_armor_suit_icon:addChild(cell)

        table.insert(self.armor_cell_tables, cell)
    end
end

function ArmorEquipment:onInit()
    local csbItem = csb.createNode(config_csb.armor.armor_tab_2)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    state_machine.excute("notification_center_remove", 0, "push_notification_armor_icon")
    state_machine.excute("notification_center_remove", 0, "push_notification_armor_formation")

    self:initFormation()
    self:initArmorIconCell()

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_suit_infor"), nil, 
    {
        terminal_name = "armor_equipment_look_up_suit_info", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 一键安装卸下
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_one_click_setup"), nil, 
    {
        terminal_name = "armor_equipment_load_all", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  
    
    self:updateArmorInfo()
    self:updateFormationState()
    self:chooseFormation(1)
end

function ArmorEquipment:onEnterTransitionFinish()

end

function ArmorEquipment:init(params)
    self._rootWindows = params[1]
    self:onInit()
    return self
end

function ArmorEquipment:onExit()
    state_machine.remove("armor_equipment_show")
    state_machine.remove("armor_equipment_hide")
    state_machine.remove("armor_equipment_update")
    state_machine.remove("armor_equipment_load_all")
    state_machine.remove("armor_equipment_choose_formation")
    state_machine.remove("armor_equipment_change_formation")
    state_machine.remove("armor_equipment_look_up_suit_info")
    state_machine.remove("armor_equipment_update_one_click_setup")
end