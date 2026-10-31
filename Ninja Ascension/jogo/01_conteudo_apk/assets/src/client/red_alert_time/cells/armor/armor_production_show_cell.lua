----------------------------------------------------------------------------------------------------
-- 说明：装甲生产
-------------------------------------------------------------------------------------------------------
ArmorProductionShowCell = class("ArmorProductionShowCellClass", Window)
ArmorProductionShowCell.__size = nil
ArmorProductionShowCell.__text_pos_x = nil

local armor_production_show_cell_create_terminal = {
    _name = "armor_production_show_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ArmorProductionShowCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(armor_production_show_cell_create_terminal)
state_machine.init()

function ArmorProductionShowCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._info = nil

    -- self.m_times = 0
    self._end_time = 0
    self.free_times = 0         -- 免费次数
    self.max_free_times = 0     -- 免费次数上限

    self._text_time = nil

    self._panel_armature = nil

    local function init_armor_production_show_cell_terminal()
        local armor_production_show_cell_click_terminal = {
            _name = "armor_production_show_cell_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                state_machine.excute("armor_production_turn_page_click_cell", 0, cell._index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_production_show_cell_set_selected_terminal = {
            _name = "armor_production_show_cell_set_selected",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[1]
                local selected = params[2]
                cell:setSelected(selected)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_production_show_cell_update_draw_terminal = {
            _name = "armor_production_show_cell_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[1]
                if cell ~= nil and cell.roots ~= nil and cell.roots[1] ~= nil then
                    cell:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(armor_production_show_cell_click_terminal)   
        state_machine.add(armor_production_show_cell_set_selected_terminal)   
        state_machine.add(armor_production_show_cell_update_draw_terminal)   
        state_machine.init()
    end
    init_armor_production_show_cell_terminal()         
end

function ArmorProductionShowCell:setSelected(selected)
    local root = self.roots[1]
    if selected == true then
        root:setColor(cc.c3b(255, 255, 255))
        if self._panel_armature ~= nil then
            self._panel_armature:setVisible(true)
        end
    else
        root:setColor(cc.c3b(160, 160, 160))
        if self._panel_armature ~= nil then
            self._panel_armature:setVisible(false)
        end
    end
end

function ArmorProductionShowCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_armor_production_box = ccui.Helper:seekWidgetByName(root, "Panel_armor_production_box")
    Panel_armor_production_box:removeBackGroundImage()
    Panel_armor_production_box:setBackGroundImage(string.format(config_res.images.ui.armor.armor_production_box, self._index))
    local Text_armor_production_time = ccui.Helper:seekWidgetByName(root, "Text_armor_production_time")
    local Text_armor_production_times = ccui.Helper:seekWidgetByName(root, "Text_armor_production_times")
    Text_armor_production_time:setString("")
    Text_armor_production_times:removeAllChildren(true)
    Text_armor_production_time:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
    Text_armor_production_time:setPositionX(ArmorProductionShowCell.__text_pos_x)

    self._text_time = Text_armor_production_time
    local free_times_info = _ED.user_armor_info.free_times_info[""..self._index]
    self._end_time = free_times_info.free_end_time
    self.free_times = tonumber(free_times_info.free_times)
    self.max_free_times = dms.int(dms["partner_bounty_param"], 12 + self._index, partner_bounty_param.free_count)

    local leave_time = self._end_time - (os.time() + _ED.time_add_or_sub)
    if self.free_times > 0 then
        Text_armor_production_time:setString(string.format(armor_tip_str[2], self.free_times))
    else
        Text_armor_production_time:setString(string.format(armor_tip_str[1], exChangeTimeToString(leave_time)))
    end
    if self._index == 3 then
        Text_armor_production_time:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
        local posX = Text_armor_production_times:getPositionX() - Text_armor_production_time:getContentSize().width / 2
        posX = posX - Text_armor_production_times:getContentSize().width / 2
        Text_armor_production_time:setPositionX(posX - 20)

        local need_times = tonumber(free_times_info.need_times)

        local str = string.gsub(armor_tip_str[3], "@x!", need_times)
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)
        _richText:setContentSize(cc.size(Text_armor_production_times:getContentSize().width, Text_armor_production_times:getContentSize().height))
        local fontSize = Text_armor_production_times:getFontSize()
        local rt2, count2, text2 = draw.richTextCollectionMethod(_richText, 
            str, 
            cc.c3b(255, 255, 255),
            cc.c3b(255, 255, 255),
            0, 
            0, 
            config_res.font.font_name, 
            fontSize,
            chat_rich_text_color)
        _richText:setPosition(cc.p(Text_armor_production_times:getContentSize().width / 2, Text_armor_production_times:getContentSize().height / 2))
        Text_armor_production_times:addChild(_richText)
    end
end

function ArmorProductionShowCell:onUpdate( dt )
    if self._text_time ~= nil and self.free_times < self.max_free_times then
        local now_time = os.time()
        if now_time - zstring.tonumber(self.last_time) >= 1 or now_time < zstring.tonumber(self.last_time) then 
            self.last_time = now_time
            local leave_time = self._end_time - (now_time + _ED.time_add_or_sub)
            if self.free_times == 0 then
                self._text_time:setString(string.format(armor_tip_str[1], exChangeTimeToString(leave_time)))
            end
            if leave_time < 0 then
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("armor_production_update_all", 0, "")
                    end
                end
                NetworkManager:register(protocol_command.armor_check_time.code, nil, nil, nil, nil, responseCallback, false, nil)
            end
        end
    end
end


function ArmorProductionShowCell:onEnterTransitionFinish()

end

function ArmorProductionShowCell:addArmature()
    if self._index ~= 3 then
        return
    end
    local root = self.roots[1]
    local Panel_armor_effect = ccui.Helper:seekWidgetByName(root, "Panel_armor_effect")
    Panel_armor_effect:removeAllChildren(true)

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_armor_production_box_3)
    local armature = ccs.Armature:create("effect_armor_production_box_3")
    armature:setPosition(Panel_armor_effect:getContentSize().width / 2, Panel_armor_effect:getContentSize().height / 2)
    armature:getAnimation():playWithIndex(0)
    Panel_armor_effect:addChild(armature)

    self._panel_armature = Panel_armor_effect
    self._panel_armature:setVisible(false)
end

function ArmorProductionShowCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.armor.armor_production_show_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if ArmorProductionShowCell.__size == nil then
        ArmorProductionShowCell.__size = root:getContentSize()
    end

    local Text_armor_production_time = ccui.Helper:seekWidgetByName(root, "Text_armor_production_time")
    if ArmorProductionShowCell.__text_pos_x == nil then
        ArmorProductionShowCell.__text_pos_x = Text_armor_production_time:getPositionX()
    end
    Text_armor_production_time:setPositionX(ArmorProductionShowCell.__text_pos_x)


    fwin:addTouchEventListener(root, nil, 
    {
        terminal_name = "armor_production_show_cell_click", 
        terminal_state = 0, 
        cell = self,
    }, nil, 1)  

    local widget = ccui.Helper:seekWidgetByName(root, "Panel_armor_production_box")
    if widget._nodeChild ~= nil then
        widget:removeChild(widget._nodeChild, true)
        widget._nodeChild = nil
        widget._istips = false
    end
    state_machine.excute("notification_center_remove_widget", 0, { _widget = widget })
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_armor_production",
        _widget = ccui.Helper:seekWidgetByName(root, "Panel_armor_production_box"),
        _invoke = nil,
        _production_type = self._index,
        _interval = 0.2,})

    self:addArmature()
    self:onUpdateDraw()
end

function ArmorProductionShowCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.armor.armor_production_show_cell, self.roots[1])
end

function ArmorProductionShowCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
    self:registerOnNoteUpdate(self, 0.5)
end

function ArmorProductionShowCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.armor.armor_production_show_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function ArmorProductionShowCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_armor_production_box = ccui.Helper:seekWidgetByName(root,"Panel_armor_up_icon")
    local Text_armor_production_time = ccui.Helper:seekWidgetByName(root,"Text_armor_production_time")
    local Text_armor_production_times = ccui.Helper:seekWidgetByName(root, "Text_armor_production_times")
    local Panel_armor_effect = ccui.Helper:seekWidgetByName(root, "Panel_armor_effect")

    if Panel_armor_production_box ~= nil then
        Panel_armor_production_box:removeBackGroundImage()
        Text_armor_production_time:setString("")
        Text_armor_production_time:setPositionX(ArmorProductionShowCell.__text_pos_x)
        Text_armor_production_times:removeAllChildren(true)
        Panel_armor_effect:removeAllChildren(true)
    end
    self:unregisterOnNoteUpdate(self)
end

function ArmorProductionShowCell:init(params)
    self._index = params[1]

    self:onInit()
    self:setContentSize(ArmorProductionShowCell.__size)
end

