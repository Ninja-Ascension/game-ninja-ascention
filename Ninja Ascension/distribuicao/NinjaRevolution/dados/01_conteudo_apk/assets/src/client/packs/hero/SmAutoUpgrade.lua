-- ------------------------------------------------------------------------------------------------------------
--  说明：数码一键升级
-- ------------------------------------------------------------------------------------------------------------
SmAutoUpgrade = class("SmAutoUpgradeClass", Window)

--打开界面
local sm_auto_upgrade_window_open_terminal = {
    _name = "sm_auto_upgrade_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(170) == true then
            return
        end
        if fwin:find("SmAutoUpgradeClass") == nil then
            fwin:open(SmAutoUpgrade:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local sm_auto_upgrade_window_close_terminal = {
    _name = "sm_auto_upgrade_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SmAutoUpgradeClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(sm_auto_upgrade_window_open_terminal)
state_machine.add(sm_auto_upgrade_window_close_terminal)
state_machine.init()

function SmAutoUpgrade:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._choose_ship = nil
    self._current_level = 0
    self._max_level = 0
    self._current_max_level = 0
    self._chooseProps = {}
    self._choosePropsCount = {}

    self._totalPropsInfo = {}
    self.propCells = {}

    local function init_sm_auto_upgrade_terminal()
        local sm_auto_upgrade_change_times_terminal = {
            _name = "sm_auto_upgrade_change_times",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._current_level + tonumber(params._datas.updateLevel) <= tonumber(instance._choose_ship.ship_grade) then
                    return
                end
                if instance._current_level + tonumber(params._datas.updateLevel) > instance._current_max_level then
                    return
                end
                instance._current_level = instance._current_level + tonumber(params._datas.updateLevel)
                instance:setSelectNum(instance._current_level)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_auto_upgrade_silder_update_terminal = {
            _name = "sm_auto_upgrade_silder_update",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Slider_number = ccui.Helper:seekWidgetByName(instance.roots[1], "Slider_number")
                local select_num = math.ceil(tonumber(Slider_number:getPercent()) * (self._max_level - tonumber(instance._choose_ship.ship_grade)) / 100)
                if select_num <= 0 then
                    select_num = 1
                end
                instance:setSelectNum(instance._choose_ship.ship_grade + select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_auto_upgrade_sure_terminal = {
            _name = "sm_auto_upgrade_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(instance._choose_ship.ship_grade) >= math.min(100, tonumber(_ED.user_info.user_grade)) then
                    TipDlg.drawTextDailog(_new_interface_text[244])
                    return
                end
                if instance._current_level <= tonumber(instance._choose_ship.ship_grade) then
                    TipDlg.drawTextDailog(_new_interface_text[241])
                    return
                end
                local ship_id = instance._choose_ship.ship_id
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        playEffect(formatMusicFile("effect", 9993))
                        TipDlg.drawTextDailog(_new_interface_text[220])
                        state_machine.excute("sm_role_strengthen_tab_play_control_effect", 0, 0)
                        if fwin:find("HeroDevelopClass") ~= nil then
                            state_machine.excute("hero_develop_page_strength_to_update_ship", 0, _ED.user_ship[""..ship_id])
                            state_machine.excute("hero_develop_page_strength_to_update_all_icon", 0, _ED.user_ship[""..ship_id])
                        else
                            for i, v in pairs(_ED.user_formetion_status) do
                                if tonumber(v) == tonumber(ship_id) then
                                    state_machine.excute("formation_set_ship", 0, _ED.user_ship[""..ship_id])
                                    break
                                end
                            end
                        end
                        state_machine.excute("sm_role_strengthen_tab_up_stop_update", 0, "")
                        state_machine.excute("sm_role_strengthen_tab_up_grade_update_draw", 0, nil)
                        setShipPushData(ship_id, -1, -1)
                        state_machine.excute("sm_auto_upgrade_window_close", 0, nil)
                        smFightingChange()
                    end
                end
                local str = ""
                local index = 0
                for k,v in pairs(instance._choosePropsCount) do
                    if tonumber(v) > 0 then
                        index = index + 1
                        local prop = fundPropWidthId(k)
                        if index == 1 then
                            str = prop.user_prop_id..":"..v
                        else
                            str = str..","..prop.user_prop_id..":"..v
                        end
                    end
                end
                if str == "" then
                    TipDlg.drawTextDailog(_new_interface_text[241])
                    return
                end
                protocol_command.ship_escalate.param_list = "0\r\n"..instance._choose_ship.ship_id.."\r\n"..str.."\r\n"..instance._current_level
                NetworkManager:register(protocol_command.ship_escalate.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_auto_upgrade_update_choose_props_terminal = {
            _name = "sm_auto_upgrade_update_choose_props",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    local up_grade_consumption = dms.string(dms["ship_config"], 1, ship_config.param)
                    local consumption_data = zstring.split(up_grade_consumption, ",")
                    local findIndex = 0
                    local isAdd = true
                    for k,v in pairs(instance._chooseProps) do
                        if tonumber(v) == tonumber(params) then
                            isAdd = false
                            findIndex = k
                            break
                        end
                    end
                    if isAdd == true then
                        for k,v in pairs(consumption_data) do
                            if tonumber(v) == tonumber(params) then
                                findIndex = k
                                break
                            end
                        end
                        instance._chooseProps[findIndex] = params
                    else
                        instance._chooseProps[findIndex] = 0
                    end
                    instance._current_level = tonumber(instance._choose_ship.ship_grade) + 1
                    instance:updateCurrentMaxLevel()
                    instance:setSelectNum(instance._current_level)
                    instance:updatePropCellChooseState()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_auto_upgrade_silder_update_terminal)
        state_machine.add(sm_auto_upgrade_change_times_terminal)
        state_machine.add(sm_auto_upgrade_sure_terminal)
        state_machine.add(sm_auto_upgrade_update_choose_props_terminal)
        state_machine.init()
    end
    
    init_sm_auto_upgrade_terminal()
end

function SmAutoUpgrade:updatePropCellChooseState( ... )
    for k,v in pairs(self.propCells) do
        local propId = zstring.tonumber(self._chooseProps[k])
        v:updateAutoUpgradeState(propId > 0)
    end
end

function SmAutoUpgrade:updateCurrentMaxLevel( ... )
    local available = tonumber(self._choose_ship.exprience) or 0
    for _,v in pairs(self._chooseProps) do
        local info = self._totalPropsInfo[tostring(v)]
        if info then available = available + info.count * info.exp end
    end
    local current = tonumber(self._choose_ship.ship_grade)
    local cap = math.min(100, tonumber(_ED.user_info.user_grade), self._max_level)
    local ability = dms.int(dms["ship_mould"], self._choose_ship.ship_template_id, ship_mould.ability)
    local reachable = current
    for level = current + 1, cap do
        local needed = dms.int(dms["ship_experience_param"], level, ability - 13 + 3)
        if available < needed then break end
        available = available - needed
        reachable = level
    end
    self._current_max_level = reachable
    local enabled = reachable > current
    for _,name in ipairs({"Slider_number", "Button_reduce", "Button_add"}) do
        ccui.Helper:seekWidgetByName(self.roots[1], name):setTouchEnabled(enabled)
    end
end

function SmAutoUpgrade:onUpdateDraw()
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Slider_number"):setTouchEnabled(true)
    ccui.Helper:seekWidgetByName(root, "Button_reduce"):setTouchEnabled(true)
    ccui.Helper:seekWidgetByName(root, "Button_add"):setTouchEnabled(true)
    local up_grade_consumption = dms.string(dms["ship_config"], 1, ship_config.param)
    local consumption_data = zstring.split(up_grade_consumption, ",")
    self._chooseProps = consumption_data
    
    self._totalPropsInfo = {}
    self.propCells = {}
    local maxExp = 0
    for i=1, 6 do
        local Panel_role_up_lv_box = ccui.Helper:seekWidgetByName(root, "Panel_role_up_lv_box_"..i)
        local Panel_role_up_lv_icon = ccui.Helper:seekWidgetByName(root, "Panel_role_up_lv_icon_"..i)
        local Text_role_up_lv_num = ccui.Helper:seekWidgetByName(root, "Text_role_up_lv_num_"..i)
        Panel_role_up_lv_box:removeAllChildren(true)

        local cell = PropIconNewCell:createCell()
        local existNumber = tonumber(getPropAllCountByMouldId(consumption_data[i]))
        if existNumber > 0 then
            Panel_role_up_lv_icon:setVisible(false)
            cell:init(cell.enum_type._AUTO_UPGRADE, consumption_data[i])
        else
            Panel_role_up_lv_icon:setVisible(false)
            cell:init(cell.enum_type._AUTO_UPGRADE, consumption_data[i], false, true)
        end
        Panel_role_up_lv_box:addChild(cell)
        table.insert(self.propCells, cell)

        local expShip = dms.string(dms["prop_mould"], consumption_data[i], prop_mould.use_of_ship)
        local expProvide = dms.string(dms["ship_mould"], expShip, ship_mould.initial_experience_supply)
        Text_role_up_lv_num:setString("0/"..existNumber)
        Text_role_up_lv_num:setColor(cc.c3b(tipStringInfo_quality_color_Type[2][1], tipStringInfo_quality_color_Type[2][2], tipStringInfo_quality_color_Type[2][3]))
        
        maxExp = maxExp + expProvide * existNumber
        if existNumber == 0 then
            self._chooseProps[i] = 0
        end
        if existNumber > 0 then
            self._totalPropsInfo[""..consumption_data[i]] = {index = i, count = existNumber, exp = expProvide}
        end
    end

    local needExp = self._choose_ship.grade_need_exprience - self._choose_ship.exprience
    local ability = dms.int(dms["ship_mould"], self._choose_ship.ship_template_id, ship_mould.ability)

    local levelLimNum = 100
    local levelLim = dms.int(dms["ship_config"], 49, ship_config.param)
    if levelLim then
        levelLimNum = levelLim
    end

    for i=tonumber(self._choose_ship.ship_grade) + 1, levelLimNum do
        local exp = dms.int(dms["ship_experience_param"], i, ability-13+3)
        if i > tonumber(self._choose_ship.ship_grade) + 1 then
            needExp = needExp + exp
        end
        if maxExp >= needExp then
            self._max_level = i
        else
            if i == tonumber(self._choose_ship.ship_grade) + 1 then
                self._max_level = tonumber(_ED.user_info.user_grade)
                self._current_level = tonumber(self._choose_ship.ship_grade)
                ccui.Helper:seekWidgetByName(root, "Slider_number"):setTouchEnabled(false)
                ccui.Helper:seekWidgetByName(root, "Button_reduce"):setTouchEnabled(false)
                ccui.Helper:seekWidgetByName(root, "Button_add"):setTouchEnabled(false)
                break
            else
                break
            end
        end
    end
    self._max_level = math.min(100, self._max_level, tonumber(_ED.user_info.user_grade))
    self:updateCurrentMaxLevel()
end

function SmAutoUpgrade:setSelectNum(select_num)
    local root = self.roots[1]
    self._current_level = select_num
    if self._current_level >= self._current_max_level then
        self._current_level = self._current_max_level
    end
    if self._current_level <= tonumber(self._choose_ship.ship_grade) then
        self._current_level = tonumber(self._choose_ship.ship_grade)
    end
    local span = self._max_level - tonumber(self._choose_ship.ship_grade)
    local percent = span > 0 and math.floor((self._current_level - tonumber(self._choose_ship.ship_grade)) / span*100) or 0

    local Slider_number = ccui.Helper:seekWidgetByName(root, "Slider_number")
    Slider_number:setPercent(percent)
    local Text_yjsj_1_0 = ccui.Helper:seekWidgetByName(root, "Text_yjsj_1_0")
    Text_yjsj_1_0:setString(self._current_level.."/"..self._max_level)
    
    self._choosePropsCount = {}

    local ability = dms.int(dms["ship_mould"], self._choose_ship.ship_template_id, ship_mould.ability)

    local needExp2 = 0
    local min_grade = tonumber(self._choose_ship.ship_grade) + 1
    if min_grade > self._current_level then
        for k,v in pairs(self._chooseProps) do
            local info = self._totalPropsInfo[""..zstring.tonumber(v)]
            if info ~= nil then
               self._choosePropsCount[""..v] = tonumber(info.count)
            end
        end
    else
        for i = tonumber(self._choose_ship.ship_grade) + 1, self._current_level do
            local exp = dms.int(dms["ship_experience_param"], i, ability - 13 + 3)
            needExp2 = needExp2 + exp
        end
        local needExp = needExp2 - self._choose_ship.exprience
        for k,v in pairs(self._chooseProps) do
            local info = self._totalPropsInfo[""..zstring.tonumber(v)]
            if info ~= nil then
                local needCount = math.ceil(needExp/tonumber(info.exp))
                if needCount < tonumber(info.count) then
                    self._choosePropsCount[""..v] = needCount
                    break
                else
                    self._choosePropsCount[""..v] = tonumber(info.count)
                    needExp = needExp - tonumber(info.exp) * tonumber(info.count)
                end
            end
        end
    end

    for k,v in pairs(self._totalPropsInfo) do
        local Text_role_up_lv_num = ccui.Helper:seekWidgetByName(root, "Text_role_up_lv_num_"..v.index)
        Text_role_up_lv_num:setString(zstring.tonumber(self._choosePropsCount[""..k]).."/"..v.count)
        if zstring.tonumber(self._choosePropsCount[""..k]) > 0 then
            Text_role_up_lv_num:setColor(cc.c3b(_quality_color[2][1], _quality_color[2][2], _quality_color[2][3]))
        else
            Text_role_up_lv_num:setColor(cc.c3b(_quality_color[1][1], _quality_color[1][2], _quality_color[1][3]))
        end
    end
    self:updateUIInfo()
end

function SmAutoUpgrade:updateUIInfo()
    local root = self.roots[1]
    local Button_add = ccui.Helper:seekWidgetByName(root, "Button_add")
    local Button_reduce = ccui.Helper:seekWidgetByName(root, "Button_reduce")
    Button_add:setTouchEnabled(true)
    Button_add:setHighlighted(true)
    Button_reduce:setTouchEnabled(true)
    Button_reduce:setHighlighted(true)
    if self._current_level >= self._current_max_level then
        Button_add:setTouchEnabled(false)
        Button_add:setHighlighted(false)
    end
    if self._current_level <= tonumber(self._choose_ship.ship_grade) then
        Button_reduce:setTouchEnabled(false)
        Button_reduce:setHighlighted(false)
    end
end

function SmAutoUpgrade:onInit()
    local csbItem = csb.createNode("packs/HeroStorage/sm_role_strengthen_tab_cell_2_window.csb")
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
    {
        terminal_name = "sm_auto_upgrade_window_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 3)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_Cancel"), nil, 
    {
        terminal_name = "sm_auto_upgrade_window_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add"), nil, 
    {
        terminal_name = "sm_auto_upgrade_change_times", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
        updateLevel = 1,
    }, nil, 1)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reduce"), nil, 
    {
        terminal_name = "sm_auto_upgrade_change_times", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
        updateLevel = -1,
    }, nil, 1)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_confirm"), nil, 
    {
        terminal_name = "sm_auto_upgrade_sure", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 1)

    local Slider_number = ccui.Helper:seekWidgetByName(root, "Slider_number")
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            state_machine.excute("sm_auto_upgrade_silder_update", 0, {sender:getPercent()})
        end
    end
    Slider_number:addEventListener(percentChangedEvent)

    self._current_level = tonumber(self._choose_ship.ship_grade) + 1
    self:onUpdateDraw()
    self:setSelectNum(self._current_level)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.01), cc.CallFunc:create(function (sender)
        if sender ~= nil and sender.roots ~= nil and sender.roots[1] ~= nil then
            sender:updatePropCellChooseState()
        end
    end)))
end

function SmAutoUpgrade:init(params)
    self._choose_ship = params
    self:onInit()
    return self
end

function SmAutoUpgrade:onExit()
    state_machine.remove("sm_auto_upgrade_sure")
    state_machine.remove("sm_auto_upgrade_silder_update")
    state_machine.remove("sm_auto_upgrade_change_times")
    state_machine.remove("sm_auto_upgrade_update_choose_props")
end