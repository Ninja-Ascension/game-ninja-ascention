--------------------------------------------------------------------------------------------------------------
--  说明：装甲仓库
--------------------------------------------------------------------------------------------------------------
ArmorPack = class("ArmorPackClass", Window)

--打开界面
local armor_pack_window_open_terminal = {
    _name = "armor_pack_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = ArmorPack:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(armor_pack_window_open_terminal)
state_machine.init()

function ArmorPack:ctor()
    self.super:ctor()
    self.roots = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil

    self._is_sell = false            -- 是否出售
    self._sell_gem = 0               -- 出售获得宝石

    local function init_armor_pack_terminal()
        local armor_pack_show_terminal = {
            _name = "armor_pack_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(true)
                instance._is_sell = false
                instance:changeSellState()
                instance:refreshListView()
                instance:pushUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_pack_hide_terminal = {
            _name = "armor_pack_hide",
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

        local armor_pack_update_terminal = {
            _name = "armor_pack_update",
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

        -- 扩容
        local armor_pack_enlarge_terminal = {
            _name = "armor_pack_enlarge",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._is_sell == false then
                    local info = zstring.split(dms.string(dms["equipment_config"], 10, equipment_config.param), "|")
                    local current_count = tonumber(_ED.user_armor_info.enlarge_count)
                    if current_count < #info then
                        local cost_info = zstring.split(info[current_count + 1], ",")
                        local cell = {}
                        cell.cost = cost_info[2]
                        cell.capacity = cost_info[1]
                        state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {m_type = 26, cell = cell}})
                    else
                        TipDlg.drawTextDailog(armor_tip_str[37])
                    end
                else
                    state_machine.excute("armor_batch_choose_window_open", 0, {_datas = {from_type = 1}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 出售
        local armor_pack_sell_terminal = {
            _name = "armor_pack_sell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._is_sell == false then
                    instance._is_sell = true
                    instance:changeSellState()
                else
                    instance:sellArmor()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 装甲补给
        local armor_pack_supply_duplication_terminal = {
            _name = "armor_pack_supply_duplication",
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

        local armor_pack_install_terminal = {
            _name = "armor_pack_install",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._is_sell == false then
                    state_machine.excute("armor_change_page", 0, {_datas = {page = 2}})
                else
                    instance._is_sell = false
                    instance:changeSellState()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local armor_pack_update_sell_gem_terminal = {
            _name = "armor_pack_update_sell_gem",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local add_gem = params
                instance:updateSellGem(add_gem)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 批量选择
        local armor_pack_update_batch_choose_terminal = {
            _name = "armor_pack_update_batch_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                for k, v in pairs(instance._list_view:getItems()) do
                    state_machine.excute("armor_packs_cell_set_batch_choose", 0, {v, params})
                end
                instance:checkSellGem()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 确认扩容
        local armor_pack_sure_enlarge_pack_terminal = {
            _name = "armor_pack_sure_enlarge_pack",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots ~= nil then
                            response.node:onUpdateCapacity()
                        end
                        state_machine.excute("main_window_update_gold_info", 0, "")
                        state_machine.excute("armor_production_update_gold_info", 0, "")
                        TipDlg.drawTextDailog(armor_tip_str[27])
                    end
                end
                protocol_command.armor_packs_expansion.param_list = ""
                NetworkManager:register(protocol_command.armor_packs_expansion.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(armor_pack_show_terminal)   
        state_machine.add(armor_pack_hide_terminal)
        state_machine.add(armor_pack_update_terminal)
        state_machine.add(armor_pack_enlarge_terminal)
        state_machine.add(armor_pack_sell_terminal)
        state_machine.add(armor_pack_supply_duplication_terminal)
        state_machine.add(armor_pack_install_terminal)
        state_machine.add(armor_pack_update_sell_gem_terminal)
        state_machine.add(armor_pack_update_batch_choose_terminal)
        state_machine.add(armor_pack_sure_enlarge_pack_terminal)
        state_machine.init()
    end
    init_armor_pack_terminal()
end

function ArmorPack:refreshListView()
    self._list_view:jumpToTop()
    self._list_view:requestRefreshView()
end

function ArmorPack:pushUpdateDraw()
    -- 装甲
    if _ED.push_armor_parts == nil then
        _ED.push_armor_parts = {}
    end
    for k, v in pairs(_ED.user_equiment) do
        if tonumber(v.formation_type) == 0 and v.armor_type > 0 then  
            _ED.push_armor_parts[""..v.equip_id] = zstring.tonumber(v.equipment_mould_id)
        end
    end

    local str = ""
    for k, v in pairs(_ED.user_equiment) do
        if tonumber(v.formation_type) == 0 and v.armor_type > 0 then
            local equipment_mould_id = _ED.push_armor_parts[""..v.equip_id]
            if zstring.tonumber(v.equipment_mould_id) == zstring.tonumber(equipment_mould_id) then
                if str == "" then
                    str = zstring.tonumber(v.equip_id) ..","..zstring.tonumber(v.equipment_mould_id)
                else
                    str = str .."|"..zstring.tonumber(v.equip_id) ..","..zstring.tonumber(v.equipment_mould_id)
                end
            end
        end
    end
    cc.UserDefault:getInstance():setStringForKey(getKey("push_armor_parts"), str)

    -- 装甲经验
    if _ED.push_armor_packs == nil then
        _ED.push_armor_packs = {}
    end
    for k, v in pairs(_ED.user_prop) do
        if v.storage_page_index == 26 then
            _ED.push_armor_packs[""..v.user_prop_template] = zstring.tonumber(v.prop_number)
        end
    end

    local str = ""
    local base_info = _ED.push_armor_packs
    for k, v in pairs(_ED.user_prop) do
        if v.storage_page_index == 26 then
            local count = base_info[""..v.user_prop_template]
            if zstring.tonumber(v.prop_number) > zstring.tonumber(count) then
            else
                if str == "" then
                    str = "26"..","..v.user_prop_template ..","..zstring.tonumber(v.prop_number)
                else
                    str = str .."|".."26"..","..v.user_prop_template ..","..zstring.tonumber(v.prop_number)
                end
            end
        end
    end

    cc.UserDefault:getInstance():setStringForKey(getKey("push_armor_packs"), str)
end

function ArmorPack:sellArmor()
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
        TipDlg.drawTextDailog(armor_tip_str[15])
        return
    end
    state_machine.excute("armor_sell_window_open", 0, {self._sell_gem, param_list})
end

function ArmorPack:changeSellState()
    local root = self.roots[1]
    local items = self._list_view:getItems()
    local state = 1
    if self._is_sell == true then
        state = 2
    end
    for k, v in pairs(items) do
        state_machine.excute("armor_packs_cell_change_state", 0, {v, state})
    end

    local Button_armor_packs_install = ccui.Helper:seekWidgetByName(root,"Button_armor_packs_install")
    local Button_armor_packs_sell = ccui.Helper:seekWidgetByName(root,"Button_armor_packs_sell")
    local Text_armor_packs_cell_get_t = ccui.Helper:seekWidgetByName(root,"Text_armor_packs_cell_get_t")
    local Text_armor_packs_cell_get_n = ccui.Helper:seekWidgetByName(root,"Text_armor_packs_cell_get_n")
    local Image_armor_packs_gem = ccui.Helper:seekWidgetByName(root,"Image_armor_packs_gem")
    local Button_armor_packs_enlarge = ccui.Helper:seekWidgetByName(root,"Button_armor_packs_enlarge")
    Button_armor_packs_enlarge:setTouchEnabled(true)
    Button_armor_packs_enlarge:setBright(true)
    if self._is_sell == false then
        Button_armor_packs_install:setTitleText(armor_tip_str[13])
        Button_armor_packs_sell:loadTextureNormal("images/ui/share/button_share_1.png", 1)
        Button_armor_packs_sell:loadTexturePressed("images/ui/share/button_share_1.png", 1)
        Text_armor_packs_cell_get_t:setVisible(false)
        Text_armor_packs_cell_get_n:setVisible(false)
        Image_armor_packs_gem:setVisible(false)
        Button_armor_packs_enlarge:setTitleText(armor_tip_str[17])
        local info = zstring.split(dms.string(dms["equipment_config"], 10, equipment_config.param), "|")
        if tonumber(_ED.user_armor_info.enlarge_count) >= #info then
            Button_armor_packs_enlarge:setTouchEnabled(false)
            Button_armor_packs_enlarge:setBright(false)
        end
    else
        Button_armor_packs_install:setTitleText(armor_tip_str[14])
        Button_armor_packs_sell:loadTextureNormal("images/ui/share/button_share_2.png", 1)
        Button_armor_packs_sell:loadTexturePressed("images/ui/share/button_share_2.png", 1)
        Text_armor_packs_cell_get_t:setVisible(true)
        Text_armor_packs_cell_get_n:setVisible(true)
        Image_armor_packs_gem:setVisible(true)
        Button_armor_packs_enlarge:setTitleText(armor_tip_str[18])

        self._sell_gem = 0
        self:updateSellGem(0)
    end
end

-- 刷新出售获得宝石数
function ArmorPack:updateSellGem(add_gem)
    local root = self.roots[1]
    local Text_armor_packs_cell_get_n = ccui.Helper:seekWidgetByName(root,"Text_armor_packs_cell_get_n")
    self._sell_gem = self._sell_gem + add_gem
    Text_armor_packs_cell_get_n:setString(exChangeNumToString(self._sell_gem))
end

function ArmorPack:checkSellGem()
    if self._is_sell == false then
        return
    end
    
    local root = self.roots[1]
    local Text_armor_packs_cell_get_n = ccui.Helper:seekWidgetByName(root,"Text_armor_packs_cell_get_n")
    self._sell_gem = 0
    for k, v in pairs(self._list_view:getItems()) do
        if v:isSelected() == true then
            self._sell_gem = self._sell_gem + tonumber(v._cost)
        end
    end
    Text_armor_packs_cell_get_n:setString(exChangeNumToString(self._sell_gem))
end

-- 仓库容量刷新
function ArmorPack:onUpdateCapacity()
    local root = self.roots[1]
    local Text_armor_packs_enlarge_n = ccui.Helper:seekWidgetByName(root,"Text_armor_packs_enlarge_n")
    local current_count = #self._list_view:getItems()
    Text_armor_packs_enlarge_n:setString(string.format(armor_tip_str[24], current_count, tonumber(_ED.user_armor_info.armor_capacity)))

    local Button_armor_packs_enlarge = ccui.Helper:seekWidgetByName(root,"Button_armor_packs_enlarge")
    Button_armor_packs_enlarge:setTouchEnabled(true)
    Button_armor_packs_enlarge:setBright(true)
    if self._is_sell == false then
        local info = zstring.split(dms.string(dms["equipment_config"], 10, equipment_config.param), "|")
        if tonumber(_ED.user_armor_info.enlarge_count) >= #info then
            Button_armor_packs_enlarge:setTouchEnabled(false)
            Button_armor_packs_enlarge:setBright(false)
        end
    end
end

function ArmorPack:onUpdateDraw()
    local root = self.roots[1]
    local Panel_armor_packs = ccui.Helper:seekWidgetByName(root,"Panel_armor_packs")
    local Panel_armor_packs_empty = ccui.Helper:seekWidgetByName(root,"Panel_armor_packs_empty")
    Panel_armor_packs:setVisible(false)
    Panel_armor_packs_empty:setVisible(false)

    local state = 1
    if self._is_sell == true then
        state = 2
    end

    local ListView_armor_packs = ccui.Helper:seekWidgetByName(root,"ListView_armor_packs")
    ListView_armor_packs:jumpToTop()

    local armor_list = {}       -- 装甲
    local prop_list = {}        -- 经验
    -- 未穿戴装甲
    for k, v in pairs(getArmorList()) do
        if tonumber(v.formation_type) == 0 then
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
            or (a.info.grow_level == b.info.grow_level and tonumber(a.info.upgrade_level) == tonumber(b.info.upgrade_level) and tonumber(a.info.armor_type) < tonumber(b.info.armor_type))
            or (a.info.grow_level == b.info.grow_level and tonumber(a.info.upgrade_level) == tonumber(b.info.upgrade_level) and tonumber(a.info.armor_type) == tonumber(b.info.armor_type) and tonumber(a.info.experience) > tonumber(b.info.experience))
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
    for k, v in pairs(armor_list) do
        table.insert(result, v)
    end
    for k, v in pairs(prop_list) do
        table.insert(result, v)
    end

    local items = ListView_armor_packs:getItems()
    for k,v in pairs(items) do
        if result[k] == nil then
            state_machine.excute("armor_packs_cell_update_info", 0, {cell = v, index = k, _prop_type = 0, _info = nil})
        else
            state_machine.excute("armor_packs_cell_update_info", 0, {cell = v, index = k, _prop_type = result[k].prop_type, _info = result[k].info})
        end
    end

    if #result > 0 then
        Panel_armor_packs:setVisible(true)
    else
        Panel_armor_packs_empty:setVisible(true)
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            ListView_armor_packs:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("armor_packs_cell_create",0, {i, result[i].info, result[i].prop_type, state})
            ListView_armor_packs:addChild(cell)
        end
    end

    ListView_armor_packs:requestRefreshView()
    self._list_view = ListView_armor_packs
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    self:checkSellGem()
    self:onUpdateCapacity()
end

function ArmorPack:onUpdate( dt )
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

function ArmorPack:onInit(params)
    local csbItem = csb.createNode(config_csb.armor.armor_tab_3)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 扩容
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_packs_enlarge"), nil, 
    {
        terminal_name = "armor_pack_enlarge", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 安装
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_packs_install"), nil, 
    {
        terminal_name = "armor_pack_install", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 出售
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_packs_sell"), nil, 
    {
        terminal_name = "armor_pack_sell", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 装甲生产
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_production"), nil, 
    {
        terminal_name = "armor_change_page", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        page = 1,
    }, nil, 1)  

    -- 装甲补给
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_pve_get"), nil, 
    {
        terminal_name = "armor_pack_supply_duplication", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_armor_packs_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_armor_packs_arrow_up")
    
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
    self:pushUpdateDraw()
end

function ArmorPack:onEnterTransitionFinish()

end

function ArmorPack:init(params)
    self._rootWindows = params[1]
    self:onInit()
    return self
end

function ArmorPack:onExit()
    state_machine.remove("armor_pack_show")
    state_machine.remove("armor_pack_hide")
    state_machine.remove("armor_pack_update")
    state_machine.remove("armor_pack_enlarge")
    state_machine.remove("armor_pack_sell")
    state_machine.remove("armor_pack_supply_duplication")
    state_machine.remove("armor_pack_install")
    state_machine.remove("armor_pack_update_sell_gem")
    state_machine.remove("armor_pack_update_batch_choose")
    state_machine.remove("armor_pack_sure_enlarge_pack")
end