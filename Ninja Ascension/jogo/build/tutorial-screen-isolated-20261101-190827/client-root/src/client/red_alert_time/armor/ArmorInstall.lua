--------------------------------------------------------------------------------------------------------------
--  说明：装甲安装
--------------------------------------------------------------------------------------------------------------
ArmorInstall = class("ArmorInstallClass", Window)

--打开界面
local armor_install_window_open_terminal = {
    _name = "armor_install_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ArmorInstallClass") then
            fwin:open(ArmorInstall:new():init(params), fwin._ui)
        end
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local armor_install_window_close_terminal = {
    _name = "armor_install_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ArmorInstallClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(armor_install_window_open_terminal)
state_machine.add(armor_install_window_close_terminal)
state_machine.init()

function ArmorInstall:ctor()
    self.super:ctor()
    self.roots = {}

    self._formation_type = 0
    self._armor_type = 0
    self._armor_info = nil

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil

    local function init_armor_install_terminal()
        local armor_install_show_terminal = {
            _name = "armor_install_show",
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

        local armor_install_hide_terminal = {
            _name = "armor_install_hide",
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

        local armor_install_update_terminal = {
            _name = "armor_install_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local armor_info = nil
                for k, v in pairs(_ED.user_equiment) do
                    if v.armor_type == instance._armor_type and tonumber(v.formation_type) == instance._formation_type then
                        armor_info = v
                        break
                    end
                end
                instance._armor_info = armor_info
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 装甲补给
        local armor_install_supply_duplication_terminal = {
            _name = "armor_install_supply_duplication",
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
        local armor_install_produce_terminal = {
            _name = "armor_install_produce",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("armor_install_window_close", 0, "")
                state_machine.excute("armor_change_page", 0, {_datas = {page = 1}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 卸下
        local armor_install_unload_terminal = {
            _name = "armor_install_unload",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("armor_install_update", 0, "")
                        state_machine.excute("armor_equipment_update", 0, "")
                        state_machine.excute("armor_pack_update", 0, "")
                        TipDlg.drawTextDailog(armor_tip_str[29])
                    end
                end
                protocol_command.armor_wear.param_list = ""..instance._armor_info.formation_type.."\r\n"..instance._armor_info.equip_id.."\r\n".."1"
                NetworkManager:register(protocol_command.armor_wear.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(armor_install_show_terminal)   
        state_machine.add(armor_install_hide_terminal)
        state_machine.add(armor_install_update_terminal)
        state_machine.add(armor_install_supply_duplication_terminal)
        state_machine.add(armor_install_produce_terminal)
        state_machine.add(armor_install_unload_terminal)
        state_machine.init()
    end
    init_armor_install_terminal()
end

-- 安装中装甲信息
function ArmorInstall:onUpdateDraw()
    local root = self.roots[1]
    local Panel_armor_install_f = ccui.Helper:seekWidgetByName(root,"Panel_armor_install_f")
    local Text_armor_install_not_p = ccui.Helper:seekWidgetByName(root,"Text_armor_install_not_p")
    local Text_armor_install_fomation_n = ccui.Helper:seekWidgetByName(root,"Text_armor_install_fomation_n")

    if self._armor_info == nil then
        Text_armor_install_fomation_n:setString(armor_tip_str[21])
        Panel_armor_install_f:setVisible(false)
        Text_armor_install_not_p:setVisible(true)
    else
        Text_armor_install_fomation_n:setString(string.format(armor_tip_str[10], self._armor_info.formation_type))
        Panel_armor_install_f:setVisible(true)
        Text_armor_install_not_p:setVisible(false)
    
        local Panel_armor_install_ing_icon = ccui.Helper:seekWidgetByName(root,"Panel_armor_install_ing_icon")
        
        local Text_armor_install_ing_name = ccui.Helper:seekWidgetByName(root,"Text_armor_install_ing_name")
        local Text_armor_install_attribte_1 = ccui.Helper:seekWidgetByName(root,"Text_armor_install_attribte_1")
        local Text_armor_install_attribte_infor = ccui.Helper:seekWidgetByName(root,"Text_armor_install_attribte_infor")

        Panel_armor_install_ing_icon:removeAllChildren(true)
        local cell = state_machine.excute("props_icon_create_cell", 0, {8, 14, self._armor_info.equipment_mould_id, 15, nil, nil, self._armor_info})
        Panel_armor_install_ing_icon:addChild(cell)

        Text_armor_install_attribte_infor:setString(self._armor_info.trace_remarks)

        local attr_info = zstring.split(self._armor_info.attr, ",")
        local attr_name = red_alert_time_attribute[tonumber(attr_info[1]) + 1]
        local attr_value = tonumber(attr_info[2])
        Text_armor_install_ing_name:setString(attr_name)

        Text_armor_install_attribte_1:removeAllChildren(true)
        Text_armor_install_attribte_1:ignoreContentAdaptWithSize(false)
        Text_armor_install_attribte_1:setString("")
        local font_size = Text_armor_install_attribte_1:getFontSize()
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)       
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, attr_name, config_res.font.font_name,font_size)
        _richText:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]),255, "+"..attr_value.."%", config_res.font.font_name,font_size)
        _richText:pushBackElement(re2)
        _richText:setPosition(cc.p(Text_armor_install_attribte_1:getContentSize().width/2,Text_armor_install_attribte_1:getContentSize().height/2))
        _richText:setContentSize(cc.size(Text_armor_install_attribte_1:getContentSize().width,font_size))
        Text_armor_install_attribte_1:addChild(_richText)
    end

    self:onUpdateListInfo()
end

function ArmorInstall:onUpdateListInfo()
    local root = self.roots[1]
    local Panel_armor_install = ccui.Helper:seekWidgetByName(root,"Panel_armor_install")
    local Panel_armor_install_empty = ccui.Helper:seekWidgetByName(root,"Panel_armor_install_empty")
    Panel_armor_install:setVisible(false)
    Panel_armor_install_empty:setVisible(false)
    local ListView_armor_install_list = ccui.Helper:seekWidgetByName(root,"ListView_armor_install_list")
    ListView_armor_install_list:jumpToTop()

    local result = {}
    for k, v in pairs(_ED.user_equiment) do
        if v.armor_type == self._armor_type then
            if self._armor_info == nil or tonumber(self._armor_info.equip_id) ~= tonumber(v.equip_id) then
                table.insert(result, v)
            end
        end
    end

    local function sortFunction(a, b)
        if tonumber(a.formation_type) > tonumber(b.formation_type)
            or (tonumber(a.formation_type) == tonumber(b.formation_type) and a.grow_level > b.grow_level)
            or (tonumber(a.formation_type) == tonumber(b.formation_type) and a.grow_level == b.grow_level and tonumber(a.upgrade_level) > tonumber(b.upgrade_level))
            then
            return true
        end
        return false
    end
    table.sort(result, sortFunction)

    local items = ListView_armor_install_list:getItems()
    for k,v in pairs(items) do
        state_machine.excute("armor_install_cell_update_info", 0, {cell = v, index = k, info = result[k]})
    end

    if #result > 0 then
        Panel_armor_install:setVisible(true)
    else
        Panel_armor_install_empty:setVisible(true)
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            ListView_armor_install_list:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("armor_install_cell_create",0, {i, result[i], self._formation_type})
            ListView_armor_install_list:addChild(cell)
        end
    end

    ListView_armor_install_list:requestRefreshView()
    self._list_view = ListView_armor_install_list
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function ArmorInstall:onUpdate( dt )
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

function ArmorInstall:onInit(params)
    local csbItem = csb.createNode(config_csb.armor.armor_install)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_install_close"), nil, 
    {
        terminal_name = "armor_install_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    -- 卸下
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_install_unload"), nil, 
    {
        terminal_name = "armor_install_unload", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1) 

    -- 装甲生产
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_production"), nil, 
    {
        terminal_name = "armor_install_produce", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        page = 1,
    }, nil, 1)  

    -- 装甲补给
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_up_pve_get"), nil, 
    {
        terminal_name = "armor_install_supply_duplication", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1) 

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_armor_install_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_armor_install_arrow_up")
    
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

function ArmorInstall:onEnterTransitionFinish()

end

function ArmorInstall:init(params)
    self._formation_type = params[1]                -- 安装阵位
    self._armor_type = params[2]                    -- 安装索引：1-6
    self._armor_info = params[3]
    self:setTouchEnabled(true)
    self:onInit()
    return self
end

function ArmorInstall:onExit()
    state_machine.remove("armor_install_show")
    state_machine.remove("armor_install_hide")
    state_machine.remove("armor_install_update")
    state_machine.remove("armor_install_produce")
    state_machine.remove("armor_install_supply_duplication")
    state_machine.remove("armor_install_unload")
end