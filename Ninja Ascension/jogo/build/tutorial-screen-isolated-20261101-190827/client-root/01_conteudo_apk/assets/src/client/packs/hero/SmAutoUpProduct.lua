-- ------------------------------------------------------------------------------------------------------------
--  说明：数码一键进阶
-- ------------------------------------------------------------------------------------------------------------
SmAutoUpProduct = class("SmAutoUpProductClass", Window)

--打开界面
local sm_auto_up_product_window_open_terminal = {
    _name = "sm_auto_up_product_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(169) == true then
            return
        end
        if fwin:find("SmAutoUpProductClass") == nil then
            fwin:open(SmAutoUpProduct:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local sm_auto_up_product_window_close_terminal = {
    _name = "sm_auto_up_product_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SmAutoUpProductClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(sm_auto_up_product_window_open_terminal)
state_machine.add(sm_auto_up_product_window_close_terminal)
state_machine.init()

function SmAutoUpProduct:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._choose_ship = nil
    self._level_up_times = 0
    self._max_level_up_times = 0

    local function init_sm_auto_up_product_terminal()
        local sm_auto_up_product_change_times_terminal = {
            _name = "sm_auto_up_product_change_times",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw(tonumber(params._datas.updateCount))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_auto_up_product_sure_terminal = {
            _name = "sm_auto_up_product_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._level_up_times == 0 then
                    TipDlg.drawTextDailog(_new_interface_text[240])
                    return
                end
                local ship_id = instance._choose_ship.ship_id
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        playEffect(formatMusicFile("effect", 9981))
                        TipDlg.drawTextDailog(_new_interface_text[290])
                        local currShip = _ED.user_ship[""..ship_id]
                        setShipPushData(ship_id,2,-1)
                        state_machine.excute("sm_role_strengthen_tab_update_ship_info",0,{ship_id})
                        if fwin:find("HeroDevelopClass") ~= nil then
                            state_machine.excute("hero_develop_page_strength_to_update_ship", 0, currShip)
                            state_machine.excute("hero_develop_page_strength_to_update_all_icon",0,currShip)
                        else
                            for i, v in pairs(_ED.user_formetion_status) do
                                if tonumber(v) == tonumber(ship_id) then
                                    state_machine.excute("formation_set_ship",0,currShip)
                                    break
                                end
                            end
                            state_machine.excute("hero_icon_listview_update_all_icon",0,currShip)
                            -- state_machine.excute("hero_icon_listview_icon_push_updata",0,"hero_icon_listview_icon_push_updata.")
                        end
                        -- state_machine.excute("sm_role_strengthen_tab_play_control_effect", 0, 0)

                        state_machine.excute("sm_auto_up_product_window_close", 0, nil)
                        smFightingChange()
                    end
                end
                protocol_command.ship_grow_up.param_list = instance._choose_ship.ship_id.."\r\n\r\n\r\n\r\n"..instance._level_up_times
                NetworkManager:register(protocol_command.ship_grow_up.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_auto_up_product_change_times_terminal)
        state_machine.add(sm_auto_up_product_sure_terminal)
        state_machine.init()
    end
    
    init_sm_auto_up_product_terminal()
end

function SmAutoUpProduct:onUpdateDraw(changeTimes)
    local root = self.roots[1]
    local ScrollView_cailiao = ccui.Helper:seekWidgetByName(root, "ScrollView_cailiao")
    ScrollView_cailiao:removeAllChildren(true)
    if changeTimes == 0 then
        self._max_level_up_times = 0
        self._level_up_times = 0
    else
        self._level_up_times = self._level_up_times + changeTimes
    end
    local update_group_id = dms.int(dms["ship_mould"], self._choose_ship.ship_template_id, ship_mould.required_material_id)
    local update_group = dms.searchs(dms["ship_grow_requirement"], ship_grow_requirement.need_iron, update_group_id)

    local costSilver = 0
    local costProps = {}
    local times = 0
    local targetShipLevel = 0
    -- FURY: NI UN tonumber A PELO EN ESTE BUCLE.
    --
    -- `_ED.user_info.user_silver` puede llegar nil (un bloque corto lo
    -- deja sin escribir) y `tonumber(nil)` es nil: la comparacion
    -- reventaba la ventana entera y «Avanzar con un clic» no abria nada
    -- ni sacaba aviso. Con la plata a cero -o sea, desconocida- se deja
    -- decidir al servidor, que es quien la cobra; el Order y el grado
    -- valen cero, que es el escalon de partida.
    local user_silver = zstring.tonumber(_ED.user_info.user_silver)
    local ship_grade = zstring.tonumber(self._choose_ship.ship_grade)
    for m=zstring.tonumber(self._choose_ship.Order), #update_group do
        local needData = update_group[m + 1]
        if needData == nil then
            break
        end
        local need_level = dms.atoi(needData, ship_grow_requirement.need_level)
        if ship_grade < need_level then
            break
        else
            local need_silver = dms.atoi(needData, ship_grow_requirement.need_silver)
            if user_silver > 0 and costSilver + need_silver > user_silver then
                break
            else
                local isAllEnough = true
                local addProps = {}
                for i=1, 4 do
                    local propMould = dms.atoi(needData, ship_grow_requirement.need_prop1 + (i - 1) * 2)
                    local propNumber = dms.atoi(needData, ship_grow_requirement.need_prop1_count + (i - 1) * 2)
                    local existNumber = tonumber(getPropAllCountByMouldId(propMould))
                    local useCount = zstring.tonumber(costProps[""..propMould]) + propNumber
                    if existNumber >= useCount then
                        addProps[""..propMould] = zstring.tonumber(addProps[""..propMould]) + propNumber
                    else
                        isAllEnough = false
                        break
                    end
                end
                if isAllEnough == true then
                    for k,v in pairs(addProps) do
                        costProps[""..k] = zstring.tonumber(costProps[""..k]) + v
                    end
                    costSilver = costSilver + need_silver
                    times = times + 1
                    targetShipLevel = m
                    if changeTimes == 0 then
                        self._level_up_times = self._level_up_times + 1
                        self._max_level_up_times = self._max_level_up_times + 1
                    elseif changeTimes == -1 then
                        if times == self._level_up_times then
                            break
                        end
                    elseif changeTimes == 1 then
                        if times == self._level_up_times then
                            break
                        end
                    end
                else
                    break
                end
            end
        end
    end

    local panel = ScrollView_cailiao:getInnerContainer()
    panel:setContentSize(ScrollView_cailiao:getContentSize())
    panel:setPosition(cc.p(0, 0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local tHeight = 0
    local tWidth = 0
    local wPosition = sSize.width/5
    local Hlindex = 0
    local m_number = math.ceil(table.nums(costProps)/5)
    local cellHeight = 0
    local cellWidth = 0
    local index = 0
    cellHeight = m_number*(ScrollView_cailiao:getContentSize().width/5)
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(ScrollView_cailiao:getContentSize().width, sHeight)
    for k,v in pairs(costProps) do
        index = index + 1
        local cell = PropIconNewCell:createCell()
        cell:init(cell.enum_type._SHOW_PROP_GETWAY_INFORMATION, k)
        cell:onInit()
        panel:addChild(cell)
        cell:updateIconCountInfo(getPropAllCountByMouldId(k).."/"..v)
        tWidth = tWidth + wPosition
        if (index - 1)%5 == 0 then
            Hlindex = Hlindex + 1
            tWidth = 0
            tHeight = sHeight - wPosition * Hlindex
        end
        if index <= 5 then
            tHeight = sHeight - wPosition
        end
        cell:setPosition(cc.p(tWidth, tHeight))
    end
    ScrollView_cailiao:jumpToTop()

    local quality = shipOrEquipSetColour(zstring.tonumber(self._choose_ship.Order) + self._level_up_times)
    local Text_jj_pz = ccui.Helper:seekWidgetByName(root, "Text_jj_pz")
    local Text_jj_jinbi_0 = ccui.Helper:seekWidgetByName(root, "Text_jj_jinbi_0")
    local levelIndex = getShipNameOrder(zstring.tonumber(self._choose_ship.Order) + self._level_up_times)
    if levelIndex == 0 then
        Text_jj_pz:setString(_ship_types_by_color[quality])
    else
        Text_jj_pz:setString(_ship_types_by_color[quality].." +"..levelIndex)
    end
    Text_jj_pz:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1], tipStringInfo_quality_color_Type[quality][2], tipStringInfo_quality_color_Type[quality][3]))
    Text_jj_jinbi_0:setString(costSilver)

    self:updateUIInfo()
end

function SmAutoUpProduct:updateUIInfo()
    local root = self.roots[1]
    local Button_add = ccui.Helper:seekWidgetByName(root, "Button_add")
    local Button_reduce = ccui.Helper:seekWidgetByName(root, "Button_reduce")
    Button_add:setTouchEnabled(true)
    -- Button_add:setHighlighted(true)
    Button_add:setBright(false)
    Button_reduce:setTouchEnabled(true)
    -- Button_reduce:setHighlighted(true)
    Button_reduce:setBright(false)
    if self._level_up_times == self._max_level_up_times then
        Button_add:setTouchEnabled(false)
        -- Button_add:setHighlighted(false)
        Button_add:setBright(true)
    end
    if self._level_up_times <= 1 then
        Button_reduce:setTouchEnabled(false)
        -- Button_reduce:setHighlighted(false)
        Button_reduce:setBright(true)
    end
end

function SmAutoUpProduct:updateShipInfo( ... )
    local root = self.roots[1]
    local Text_jj_name = ccui.Helper:seekWidgetByName(root, "Text_jj_name")
    local Panel_jj_icon = ccui.Helper:seekWidgetByName(root, "Panel_jj_icon")
    Panel_jj_icon:removeAllChildren(true)
    Text_jj_name:setString("")

    local cell = ShipIconCell:createCell()
    cell:init(self._choose_ship, 13, nil, nil, nil)
    Panel_jj_icon:addChild(cell)

    local evo_image = dms.string(dms["ship_mould"], self._choose_ship.ship_template_id, ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
    local ship_evo = zstring.split(self._choose_ship.evolution_status, "|")
    local evo_mould_id = evo_info[tonumber(ship_evo[1])]
    local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
    local word_info = dms.element(dms["word_mould"], name_mould_id)
    local name = word_info[3]
    if getShipNameOrder(zstring.tonumber(self._choose_ship.Order)) > 0 then
        name = name.." +"..getShipNameOrder(zstring.tonumber(self._choose_ship.Order))
    end
    local quality = shipOrEquipSetColour(zstring.tonumber(self._choose_ship.Order))
    Text_jj_name:setString(name)
    Text_jj_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1], tipStringInfo_quality_color_Type[quality][2], tipStringInfo_quality_color_Type[quality][3]))
end

function SmAutoUpProduct:onInit()
    local csbItem = csb.createNode("packs/HeroStorage/sm_role_strengthen_tab_cell_1_window.csb")
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_Cancel"), nil, 
    {
        terminal_name = "sm_auto_up_product_window_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 3)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
    {
        terminal_name = "sm_auto_up_product_window_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add"), nil, 
    {
        terminal_name = "sm_auto_up_product_change_times", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
        updateCount = 1,
    }, nil, 1)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reduce"), nil, 
    {
        terminal_name = "sm_auto_up_product_change_times", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
        updateCount = -1,
    }, nil, 1)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_confirm"), nil, 
    {
        terminal_name = "sm_auto_up_product_sure", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 1)

    self:updateShipInfo()
    self:onUpdateDraw(0)
end

function SmAutoUpProduct:init(params)
    self._choose_ship = params
    self:onInit()
    return self
end

function SmAutoUpProduct:onExit()
    state_machine.remove("sm_auto_up_product_change_times")
    state_machine.remove("sm_auto_up_product_sure")
end