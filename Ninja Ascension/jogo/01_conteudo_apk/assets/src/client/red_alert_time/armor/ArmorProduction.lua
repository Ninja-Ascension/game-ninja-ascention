--------------------------------------------------------------------------------------------------------------
--  说明：装甲生产
--------------------------------------------------------------------------------------------------------------
ArmorProduction = class("ArmorProductionClass", Window)

--打开界面
local armor_production_window_open_terminal = {
    _name = "armor_production_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = ArmorProduction:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

--装甲生产时间校验
local armor_production_check_time_terminal = {
    _name = "armor_production_check_time",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local current_time = params
        if _ED.user_armor_info ~= nil and funOpenDrawTip(204, false) == false then
            if _ED.user_armor_info.max_free_times == nil then
                _ED.user_armor_info.max_free_times = {}
                _ED.user_armor_info.max_free_times["1"] = dms.int(dms["partner_bounty_param"], 13, partner_bounty_param.free_count)
                _ED.user_armor_info.max_free_times["2"] = dms.int(dms["partner_bounty_param"], 14, partner_bounty_param.free_count)
                _ED.user_armor_info.max_free_times["3"] = dms.int(dms["partner_bounty_param"], 15, partner_bounty_param.free_count)
            end
            for k, info in pairs(_ED.user_armor_info.free_times_info) do
                local free_times = tonumber(info.free_times)
                if free_times < _ED.user_armor_info.max_free_times[""..k] then
                    local end_time = tonumber(info.free_end_time)
                    local leave_time = end_time - (current_time +  _ED.time_add_or_sub)
                    if leave_time < -1 then
                        NetworkManager:register(protocol_command.armor_check_time.code, nil, nil, nil, nil, nil, false, nil)
                    end
                end
            end
        end
        return 
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(armor_production_window_open_terminal)
state_machine.add(armor_production_check_time_terminal)
state_machine.init()

function ArmorProduction:ctor()
    self.super:ctor()
    self.roots = {}

    self.panel_tables = {}
    self.pos_tables = {}

    self.page_index = 0             -- 当前高亮选项

    self.high_free_times = 0       -- 高级免费次数
    self.middle_free_times = 0     -- 中级免费次数
    self.normal_free_times = 0     -- 普通免费次数

    local function init_armor_production_terminal()
        local armor_production_show_terminal = {
            _name = "armor_production_show",
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

        local armor_production_hide_terminal = {
            _name = "armor_production_hide",
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

        local armor_production_update_terminal = {
            _name = "armor_production_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateFreeTimes()
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_production_turn_page_terminal = {
            _name = "armor_production_turn_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("armor_production_turn_page", 0, 0)
                local turn_type = params[1]
                instance:pageTurn(turn_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_production_turn_page_click_cell_terminal = {
            _name = "armor_production_turn_page_click_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell_index = params
                local index = 2
                for k, v in pairs(self.panel_tables) do
                    if v.cell_index == cell_index then
                        index = v.index
                        break
                    end
                end
                if index < 2 then
                    state_machine.excute("armor_production_turn_page", 0, {1})
                elseif index > 2 then
                    state_machine.excute("armor_production_turn_page", 0, {-1})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_production_update_gold_info_terminal = {
            _name = "armor_production_update_gold_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateGoldInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 装甲生产
        local armor_production_sure_production_terminal = {
            _name = "armor_production_sure_production",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local state = params._datas.state
                local production_type = instance.page_index - 1
                local buy_count = 1
                local cost = 0
                if state == 3 then
                    buy_count = 10
                end
                if state == 2 then
                    if production_type == 0 then
                        cost = dms.int(dms["partner_bounty_param"], 13, partner_bounty_param.spend_gold)
                    elseif production_type == 1 then
                        cost = dms.int(dms["partner_bounty_param"], 14, partner_bounty_param.spend_gold)
                    elseif production_type == 2 then
                        cost = dms.int(dms["partner_bounty_param"], 15, partner_bounty_param.spend_gold)
                    end
                elseif state == 3 then
                    cost = dms.int(dms["partner_bounty_param"], 16, partner_bounty_param.spend_gold)
                    if instance.high_free_times > 0 then
                        TipDlg.drawTextDailog(activity_str_tip[77])
                        return
                    end
                end
                if cost > tonumber(_ED.user_info.user_gold) then
                    state_machine.excute("recharge_tip_window_open", 0, "")
                    return
                end

                local function gotoArmorPack(instance, sure_number)
                    if sure_number == 0 then
                        state_machine.excute("armor_change_page", 0, {_datas = {page = 3}})
                    end
                end
                local armor_count = 0
                for k, v in pairs(getArmorList()) do
                    if v.formation_type == 0 then
                        armor_count = armor_count + 1
                    end
                end
                for k, v in pairs(getPropPackList(26)) do
                    armor_count = armor_count + tonumber(v.prop_number)
                end
                if (armor_count + buy_count) > tonumber(_ED.user_armor_info.armor_capacity) then
                    local tip = ConfirmTip:new()
                    tip:init(instance, gotoArmorPack, armor_tip_str[25])
                    fwin:open(tip,fwin._windows) 
                    return
                end

                state_machine.lock("armor_production_sure_production")
                local function responseCallback( response )
                    state_machine.unlock("armor_production_sure_production")
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if state == 3 then
                            state_machine.excute("armor_production_ten_window_open", 0, {production_type})
                        else
                            state_machine.excute("armor_production_once_window_open", 0, {production_type})
                        end
                    end
                end
                protocol_command.armor_production.param_list = ""..production_type.."\r\n"..buy_count
                NetworkManager:register(protocol_command.armor_production.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_production_update_all_terminal = {
            _name = "armor_production_update_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("armor_production_update", 0, "")
                instance:updateProductionCell()
                instance:updateGoldInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(armor_production_show_terminal)   
        state_machine.add(armor_production_hide_terminal)
        state_machine.add(armor_production_update_terminal)
        state_machine.add(armor_production_turn_page_terminal)
        state_machine.add(armor_production_turn_page_click_cell_terminal)
        state_machine.add(armor_production_sure_production_terminal)
        state_machine.add(armor_production_update_gold_info_terminal)
        state_machine.add(armor_production_update_all_terminal)
        state_machine.init()
    end
    init_armor_production_terminal()
end

function ArmorProduction:updateProductionCell()
    for k, v in pairs(self.panel_tables) do
        local cell = v:getChildByTag(100)
        if cell ~= nil then
            state_machine.excute("armor_production_show_cell_update_draw", 0, {cell})
        end
    end
end

function ArmorProduction:updateSelectedState()
    for k, v in pairs(self.panel_tables) do
        local selected = false
        if v.index == 2 then
            selected = true
        end
        local cell = v:getChildByTag(100)
        if cell ~= nil then
            state_machine.excute("armor_production_show_cell_set_selected", 0, {cell, selected})
        end
    end
end

function ArmorProduction:pageTurn(turn_type)
    for k, v in pairs(self.panel_tables) do
        self:panelRunAction(v, v.index, turn_type)
    end
    self:updateSelectedState()
end

function ArmorProduction:panelRunAction(panel, index, turn_type)
    panel:setLocalZOrder(200)
    local next_index = index + turn_type
    if next_index > 3 then
        next_index = 1
        panel:setLocalZOrder(100)
    end
    if next_index < 1 then
        next_index = 3
        panel:setLocalZOrder(100)
    end
    if next_index == 2 then
        panel:setLocalZOrder(300)
        self.page_index = panel.cell_index
    end
    panel.index = next_index
    local next_pos = self.pos_tables[next_index]

    local scale = 1
    if next_index == 2 then
        scale = 1
    else
        scale = 0.8
    end

    local function MoveCallBack(sender)
        state_machine.unlock("armor_production_turn_page", 0, 0)
        if sender._self ~= nil and sender._self.roots ~= nil and sender._self.roots[1] ~= nil then
            self:onUpdateDraw()
        end
    end

    local move_time = 0.5
    local move = cc.Spawn:create(cc.MoveTo:create(move_time, cc.p(next_pos.x, next_pos.y)), cc.ScaleTo:create(move_time, scale))
    if next_index == 2 then
        move = cc.Sequence:create(move, cc.CallFunc:create(MoveCallBack))
    end
    panel._self = self
    panel:runAction(move)
end

-- 更新免费生产次数数据
function ArmorProduction:updateFreeTimes()
    self.normal_free_times = tonumber(_ED.user_armor_info.free_times_info["1"].free_times)
    self.middle_free_times = tonumber(_ED.user_armor_info.free_times_info["2"].free_times)
    self.high_free_times = tonumber(_ED.user_armor_info.free_times_info["3"].free_times)
end

function ArmorProduction:updateGoldInfo()
    local root = self.roots[1]
    local Text_armor_have_gold_n = ccui.Helper:seekWidgetByName(root, "Text_armor_have_gold_n")
    Text_armor_have_gold_n:setString(_ED.user_info.user_gold)
end

function ArmorProduction:onUpdateDraw()
    local root = self.roots[1]

    local Button_armor_buy_ten = ccui.Helper:seekWidgetByName(root, "Button_armor_buy_ten")
    local Button_armor_buy_one = ccui.Helper:seekWidgetByName(root, "Button_armor_buy_one")
    local Button_armor_free_production = ccui.Helper:seekWidgetByName(root, "Button_armor_free_production")
 
    local Image_armor_gold_icon_1 = ccui.Helper:seekWidgetByName(root, "Image_armor_gold_icon_1")
    local Text_armor_ten_consume_gold_n = ccui.Helper:seekWidgetByName(root, "Text_armor_ten_consume_gold_n")
    local Image_armor_gold_icon_2 = ccui.Helper:seekWidgetByName(root, "Image_armor_gold_icon_2")
    local Text_armor_one_consume_gold_n = ccui.Helper:seekWidgetByName(root, "Text_armor_one_consume_gold_n")

    Button_armor_buy_ten:setVisible(false)
    Button_armor_buy_one:setVisible(false)
    Button_armor_free_production:setVisible(false)
    Image_armor_gold_icon_1:setVisible(false)
    Text_armor_ten_consume_gold_n:setVisible(false)
    Image_armor_gold_icon_2:setVisible(false)
    Text_armor_one_consume_gold_n:setVisible(false)
    -- 更新按钮状态
    if self.page_index == 1 then
        if self.normal_free_times > 0 then
            Button_armor_free_production:setVisible(true)
        else
            Button_armor_buy_one:setVisible(true)
            Image_armor_gold_icon_2:setVisible(true)
            Text_armor_one_consume_gold_n:setVisible(true)
            local cost = dms.int(dms["partner_bounty_param"], 13, partner_bounty_param.spend_gold)
            Text_armor_one_consume_gold_n:setString(cost)
        end
    elseif self.page_index == 2 then
        if self.middle_free_times > 0 then
            Button_armor_free_production:setVisible(true)
        else
            Button_armor_buy_one:setVisible(true)
            Image_armor_gold_icon_2:setVisible(true)
            Text_armor_one_consume_gold_n:setVisible(true)
            local cost = dms.int(dms["partner_bounty_param"], 14, partner_bounty_param.spend_gold)
            Text_armor_one_consume_gold_n:setString(cost)
        end
    else
        if self.high_free_times > 0 then
            Button_armor_free_production:setVisible(true)
        else
            Button_armor_buy_one:setVisible(true)
            Image_armor_gold_icon_2:setVisible(true)
            Text_armor_one_consume_gold_n:setVisible(true)
            local cost = dms.int(dms["partner_bounty_param"], 15, partner_bounty_param.spend_gold)
            Text_armor_one_consume_gold_n:setString(cost)
        end
        Button_armor_buy_ten:setVisible(true)
        Image_armor_gold_icon_1:setVisible(true)
        Text_armor_ten_consume_gold_n:setVisible(true)
        local cost = dms.int(dms["partner_bounty_param"], 16, partner_bounty_param.spend_gold)
        Text_armor_ten_consume_gold_n:setString(cost)
    end

    self:updateGoldInfo()
end

function ArmorProduction:initUI()
    local root = self.roots[1]
    for i = 1, 3 do
        local Panel_armor_show_pic = ccui.Helper:seekWidgetByName(root, "Panel_armor_show_pic_"..i)
        local cell = state_machine.excute("armor_production_show_cell_create", 0, {i})
        cell:setTag(100)
        Panel_armor_show_pic:addChild(cell)
        Panel_armor_show_pic.cell_index = i             -- 1:普通，2：中级，3：高级

        Panel_armor_show_pic.index = i
        table.insert(self.panel_tables, Panel_armor_show_pic)
        local pos = {}
        pos.x, pos.y = Panel_armor_show_pic:getPosition()
        table.insert(self.pos_tables, pos)
    end

    -- 设置当前高亮选项
    if self.high_free_times > 0 then
        self.page_index = 3
    elseif self.middle_free_times > 0 then
        self.page_index = 2
    elseif self.normal_free_times > 0 then
        self.page_index = 1
    else
        self.page_index = 3
    end

    for i = 1, 3 do
        local index = self.page_index
        local scale = 1
        if i == 1 then
            index = index - 1
            if index < 1 then
                index = 3
            end
            scale = 0.8
        elseif i == 3 then
            index = index + 1
            if index > 3 then
                index = 1
        end
            scale = 0.8
        end
        local Panel_armor_show_pic = self.panel_tables[index]
        Panel_armor_show_pic.index = i
        Panel_armor_show_pic:setPosition(cc.p(self.pos_tables[i].x, self.pos_tables[i].y))
        Panel_armor_show_pic:setScale(scale)
    end
    self:updateSelectedState()
end

function ArmorProduction:onInit(params)
    local csbItem = csb.createNode(config_csb.armor.armor_tab_1)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:updateFreeTimes()
    self:initUI()

    -- 当前装甲
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_now"), nil, 
    {
        terminal_name = "armor_change_page", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        page = 2,
    }, nil, 1)  

    -- 购买10次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_buy_ten"), nil, 
    {
        terminal_name = "armor_production_sure_production", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        state = 3,
    }, nil, 1)  

    -- 购买1次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_buy_one"), nil, 
    {
        terminal_name = "armor_production_sure_production", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        state = 2,
    }, nil, 1)  

    -- 免费生产
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_free_production"), nil, 
    {
        terminal_name = "armor_production_sure_production", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        state = 1,
    }, nil, 1)  

    -- 滑动监听
    local height = math.abs(tonumber(self.pos_tables[1].y) - tonumber(self.pos_tables[2].y))
    local function PanelTouchEvent(sender, evenType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        
        if ccui.TouchEventType.began == evenType then

        elseif ccui.TouchEventType.moved == evenType then

        elseif ccui.TouchEventType.canceled == evenType then

        elseif ccui.TouchEventType.ended == evenType then
            if __epoint.y - __spoint.y > height/4 then
                state_machine.excute("armor_production_turn_page",0,{-1})
            end

            if __epoint.y - __spoint.y < -height/4  then
                state_machine.excute("armor_production_turn_page",0,{1})
            end
        end
    end

    local Panel_armor_show = ccui.Helper:seekWidgetByName(root,"Panel_armor_show")
    Panel_armor_show:setLocalZOrder(500)
    Panel_armor_show:setSwallowTouches(false)
    fwin:addTouchEventListener(Panel_armor_show, PanelTouchEvent, 
    {
        terminal_name = "", 
        terminal_state = 0,
    },
    nil,0)

    Image_armor_show_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_armor_show_arrow_down")
    Image_armor_show_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_armor_show_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    Image_armor_show_arrow_down:stopAllActions()
    Image_armor_show_arrow_up:stopAllActions()
    playActions(Image_armor_show_arrow_down)
    playActions(Image_armor_show_arrow_up)
    
    self:onUpdateDraw()
end

function ArmorProduction:onEnterTransitionFinish()

end

function ArmorProduction:init(params)
    self._rootWindows = params[1]
    self:onInit()
    return self
end

function ArmorProduction:onExit()
    state_machine.remove("armor_production_show")
    state_machine.remove("armor_production_hide")
    state_machine.remove("armor_production_update")
    state_machine.remove("armor_production_turn_page")
    state_machine.remove("armor_production_turn_page_click_cell")
    state_machine.remove("armor_production_sure_production")
    state_machine.remove("armor_production_update_gold_info")
    state_machine.remove("armor_production_update_all")
end