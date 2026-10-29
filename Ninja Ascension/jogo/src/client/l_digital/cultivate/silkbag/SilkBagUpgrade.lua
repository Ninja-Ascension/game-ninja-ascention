-- ------------------------------------------------------------------------------------------------------------
--  说明：锦囊的一键升级
-- ------------------------------------------------------------------------------------------------------------
SilkBagUpgrade = class("SilkBagUpgradeClass", Window)

--打开界面
local silkbag_auto_upgrade_window_open_terminal = {
    _name = "silkbag_auto_upgrade_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(170) == true then
            return
        end
        if fwin:find("SilkBagUpgradeClass") == nil then
            fwin:open(SilkBagUpgrade:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local silkbag_auto_upgrade_window_close_terminal = {
    _name = "silkbag_auto_upgrade_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SilkBagUpgradeClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(silkbag_auto_upgrade_window_open_terminal)
state_machine.add(silkbag_auto_upgrade_window_close_terminal)
state_machine.init()

function SilkBagUpgrade:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._choose_ship = nil
    self._current_level = 0
    self._max_level = 0
    self._current_max_level = 0
    self.dms_max_level = -1
    self._chooseProps = {}
    self._choosePropsCount = {}

    self._totalPropsInfo = {}
    self.propCells = {}
    app.load("client.cells.prop.prop_icon_new_cell")
    local function init_silkbag_auto_upgrade_terminal()
        local silkbag_auto_upgrade_change_times_terminal = {
            _name = "silkbag_auto_upgrade_change_times",
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

        local silkbag_auto_upgrade_silder_update_terminal = {
            _name = "silkbag_auto_upgrade_silder_update",
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

        local silkbag_auto_upgrade_sure_terminal = {
            _name = "silkbag_auto_upgrade_sure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance  then
                    state_machine.lock("silkbag_auto_upgrade_sure",0,"")
                    if tonumber(instance._choose_ship.ship_grade) == tonumber(instance._current_level) then
                        TipDlg.drawTextDailog(tipStringInfo_rescue_silkbag[18])
                        return
                    end
                    local silk_tempor_id = instance._choose_ship.temporId

                    local function responseAutoUpgradeCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if nil ~= response.node and nil ~= response.node.roots and nil ~= response.node.roots[1] then
                                playEffect(formatMusicFile("effect", 9993))
                                TipDlg.drawTextDailog(_new_interface_text[220])
                                state_machine.excute("silk_bag_info_refresh",0,"")
                                state_machine.excute("silkbag_auto_upgrade_window_close",0,"")
                                smFightingChange()
                            end
                        end
                    end
                    local str = ""
                    local index = 0
                    for k,v in pairs(instance._choosePropsCount) do
                        if k == instance:getBreakeConsumeByLevel(instance._current_level-1).prop_type then

                        else
                            if tonumber(v) > 0 then
                                index = index + 1
                                local prop = fundPropWidthId(k)
                                if index == 1 then
                                    str = k..":"..v
                                else
                                    str = str.."|"..k..":"..v
                                end
                            end       
                        end
                    end
                    if str == "" then
                        TipDlg.drawTextDailog(_new_interface_text[241])
                        return
                    end
                    protocol_command.ship_slik_bag_one_key_level_up.param_list = silk_tempor_id.."\r\n"..str
                    NetworkManager:register(protocol_command.ship_slik_bag_one_key_level_up.code, nil, nil, nil, instance, responseAutoUpgradeCallback, false, nil)
                    state_machine.unlock("silkbag_auto_upgrade_sure")
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local silkbag_auto_upgrade_update_choose_props_terminal = {
            _name = "silkbag_auto_upgrade_update_choose_props",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    local ship_config = dms.string(dms["ship_config"],45,4)
                    local ship_config_info = zstring.split(ship_config,"|")

                    local findIndex = 0
                    local isAdd = true
                    for k,v in pairs(instance._chooseProps) do
                        if tonumber(v) == tonumber(params._datas._prop) then
                            isAdd = false
                            findIndex = k
                            break
                        end
                    end
                    if isAdd == true then
                        for k,v in pairs(ship_config_info) do
                            local ship_config_info_per = zstring.split(v,",")
   
                            if tonumber(ship_config_info_per[2]) == tonumber(params._datas._prop) then
                                findIndex = k

                                break
                            end  
                        end
                        if 0 == findIndex then
                            findIndex =table.nums(ship_config_info)+1
                        end
                        instance._chooseProps[findIndex] = params._datas._prop
                    else
                        instance._chooseProps[findIndex] = 0
                    end

                    instance._current_level = tonumber(instance._choose_ship.ship_grade) + 1
                    instance:setSelectNum(instance._current_level)
                    instance:updatePropCellChooseState()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(silkbag_auto_upgrade_silder_update_terminal)
        state_machine.add(silkbag_auto_upgrade_change_times_terminal)
        state_machine.add(silkbag_auto_upgrade_sure_terminal)
        state_machine.add(silkbag_auto_upgrade_update_choose_props_terminal)
        state_machine.init()
    end
    
    init_silkbag_auto_upgrade_terminal()
end

function SilkBagUpgrade:updatePropCellChooseState( ... )
    for k,v in pairs(self.propCells) do
        local propId = zstring.tonumber(self._chooseProps[k])
        v:updateAutoUpgradeState(propId > 0)
    end
end

function SilkBagUpgrade:onUpdateDraw()
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Slider_number"):setTouchEnabled(true)
    ccui.Helper:seekWidgetByName(root, "Button_reduce"):setTouchEnabled(true)
    ccui.Helper:seekWidgetByName(root, "Button_add"):setTouchEnabled(true)

    --重置道具底
    for i=1,6 do
        local Image_props_bg = ccui.Helper:seekWidgetByName(root, "Image_props_bg_"..i)
        local Panel_role_up_lv_box = ccui.Helper:seekWidgetByName(root, "Panel_role_up_lv_box_"..i)
        local Panel_role_up_lv_icon = ccui.Helper:seekWidgetByName(root, "Panel_role_up_lv_icon_"..i)
        local Text_role_up_lv_num = ccui.Helper:seekWidgetByName(root, "Text_role_up_lv_num_"..i)
        Image_props_bg:setVisible(false)
        Panel_role_up_lv_box:setVisible(false)
        Panel_role_up_lv_icon:setVisible(false)
        Text_role_up_lv_num:setVisible(false)
    end

    local growLevelExp = SilkBagHandler.getExpByLevel(self._current_level,self._choose_ship.silkMouldId)
    local maxExp = 0
    --道具
    local ship_config = dms.string(dms["ship_config"],45,4)
    local ship_config_info = zstring.split(ship_config,"|")
    
    for i=1,table.nums(ship_config_info) do
        local Image_props_bg = ccui.Helper:seekWidgetByName(root, "Image_props_bg_"..i)
        local Panel_role_up_lv_box = ccui.Helper:seekWidgetByName(root, "Panel_role_up_lv_box_"..i)
        local Panel_role_up_lv_icon = ccui.Helper:seekWidgetByName(root, "Panel_role_up_lv_icon_"..i)
        local Text_role_up_lv_num = ccui.Helper:seekWidgetByName(root, "Text_role_up_lv_num_"..i)
        Image_props_bg:setVisible(true)
        Panel_role_up_lv_box:setVisible(true)
        Panel_role_up_lv_icon:setVisible(true)
        Text_role_up_lv_num:setVisible(true)
        Panel_role_up_lv_box:removeAllChildren(true)

        local ship_config_info_per = zstring.split(ship_config_info[i],",")

        local cell = PropIconNewCell:createCell()
        local existNumber = tonumber(getPropAllCountByMouldId(ship_config_info_per[2]))
        if existNumber > 0 then
            Panel_role_up_lv_icon:setVisible(false)
            cell:init(cell.enum_type._SILK_AUTO_UPGRADE, ship_config_info_per[2])
        else
            Panel_role_up_lv_icon:setVisible(false)
            cell:init(cell.enum_type._SILK_AUTO_UPGRADE, ship_config_info_per[2], false, true)
        end
        Panel_role_up_lv_box:addChild(cell)
        table.insert(self.propCells, cell)

        self._chooseProps[i] = ship_config_info_per[2]
        local expProvide = ship_config_info_per[3]
        Text_role_up_lv_num:setString("0/"..existNumber)
        Text_role_up_lv_num:setColor(cc.c3b(tipStringInfo_quality_color_Type[2][1], tipStringInfo_quality_color_Type[2][2], tipStringInfo_quality_color_Type[2][3]))
        
        maxExp = maxExp + expProvide * existNumber
        if existNumber == 0 then
            self._chooseProps[i] = 0
        end
        if existNumber > 0 then
            self._totalPropsInfo[""..ship_config_info_per[2]] = {index = i, count = existNumber, exp = expProvide}
        end
    end

    --处理突破道具
    local existNumber = 0
    local curBreakeCousume = self:getBreakeConsumeByLevel(self._current_level)
    if nil ~= curBreakeCousume then
        local breakeIconIndex =table.nums(ship_config_info)+1

        local Image_props_bg = ccui.Helper:seekWidgetByName(root, "Image_props_bg_"..breakeIconIndex)
        local Panel_role_up_lv_box = ccui.Helper:seekWidgetByName(root, "Panel_role_up_lv_box_"..breakeIconIndex)
        local Panel_role_up_lv_icon = ccui.Helper:seekWidgetByName(root, "Panel_role_up_lv_icon_"..breakeIconIndex)
        local Text_role_up_lv_num = ccui.Helper:seekWidgetByName(root, "Text_role_up_lv_num_"..breakeIconIndex)
        Image_props_bg:setVisible(true)
        Panel_role_up_lv_box:setVisible(true)
        Panel_role_up_lv_icon:setVisible(true)
        Text_role_up_lv_num:setVisible(true)
        Panel_role_up_lv_box:removeAllChildren(true)

        local cell = PropIconNewCell:createCell()
        existNumber = tonumber(getPropAllCountByMouldId(curBreakeCousume.prop_type))
        if existNumber > 0 then
            Panel_role_up_lv_icon:setVisible(false)
            cell:init(cell.enum_type._SILK_AUTO_UPGRADE,curBreakeCousume.prop_type)
        else
            Panel_role_up_lv_icon:setVisible(false)
            cell:init(cell.enum_type._SILK_AUTO_UPGRADE,curBreakeCousume.prop_type, false, true)
        end
        Panel_role_up_lv_box:addChild(cell)
        table.insert(self.propCells, cell)

        self._chooseProps[breakeIconIndex] = curBreakeCousume.prop_type

        Text_role_up_lv_num:setString("0/"..existNumber)
        Text_role_up_lv_num:setColor(cc.c3b(tipStringInfo_quality_color_Type[2][1], tipStringInfo_quality_color_Type[2][2], tipStringInfo_quality_color_Type[2][3]))

        if existNumber > 0 then
            self._totalPropsInfo[""..curBreakeCousume.prop_type] = {index = breakeIconIndex, count = existNumber,exp = -1}
        end
    end
    
    local needExp = growLevelExp - self._choose_ship.exprience
    
    if -1 ~= tonumber(self.dms_max_level) then
        for i=tonumber(self._choose_ship.ship_grade) + 1, tonumber(self.dms_max_level) do
            local exp = SilkBagHandler.getExpByLevel(i,self._choose_ship.silkMouldId)
            local needCount = self:getTotalConsumeForBreake(i)
            if i > tonumber(self._choose_ship.ship_grade) + 1 then
                needExp = needExp + tonumber(exp)
            end
            if maxExp >= needExp and existNumber >= needCount then
                self._max_level = i
            else
                if i == tonumber(self._choose_ship.ship_grade) + 1 then
                    self._max_level = self._choose_ship.ship_grade
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
    end
    
    self._max_level = math.min(self._max_level, self.dms_max_level)
    self._current_max_level = self._max_level
end

function SilkBagUpgrade:setSelectNum(select_num)
    self._current_level = select_num
    if self._current_level >= self._current_max_level then
        self._current_level = self._current_max_level
    end

    self._choosePropsCount = {}
    local needExpTotal = SilkBagHandler.getTotalExpByLevel(self._choose_ship.silkMouldId,tonumber(self._choose_ship.ship_grade),self._current_level)
    local needExp = needExpTotal - self._choose_ship.exprience
    local needBreakeCount = self:getTotalConsumeForBreake(self._current_level)
    for k,v in pairs(self._chooseProps) do
        local info = self._totalPropsInfo[""..zstring.tonumber(v)]
        if info ~= nil then
            if (-1 ~= tonumber(info.exp) and needExp > 0) then
                local needCount = math.ceil(needExp/tonumber(info.exp))
                if needCount < tonumber(info.count) then
                    self._choosePropsCount[""..v] = needCount
                    needExp = 0
                else
                    self._choosePropsCount[""..v] = tonumber(info.count)
                    needExp = needExp - tonumber(info.exp) * tonumber(info.count)
                end
            elseif (-1 == tonumber(info.exp) and needBreakeCount > 0) then 
                if needBreakeCount <= tonumber(info.count) then
                    self._choosePropsCount[""..v] = needBreakeCount
                    needBreakeCount = 0
                else
                    self._choosePropsCount[""..v] = tonumber(info.count)
                    needBreakeCount = tonumber(needBreakeCount) - tonumber(info.count)
                end 
            end
        end
    end     
    self:updateUIInfo()
end

function SilkBagUpgrade:updateUIInfo()
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
    local percent = math.floor((self._current_level - tonumber(self._choose_ship.ship_grade)) / (self._max_level - tonumber(self._choose_ship.ship_grade))*100)

    local Slider_number = ccui.Helper:seekWidgetByName(root, "Slider_number")
    Slider_number:setPercent(percent)
    local Text_yjsj_1_0 = ccui.Helper:seekWidgetByName(root, "Text_yjsj_1_0")
    Text_yjsj_1_0:setString(self._current_level.."/"..self._max_level)

    for k,v in pairs(self._totalPropsInfo) do
        local Text_role_up_lv_num = ccui.Helper:seekWidgetByName(root, "Text_role_up_lv_num_"..v.index)
        Text_role_up_lv_num:setString(zstring.tonumber(self._choosePropsCount[""..k]).."/"..v.count)

        if zstring.tonumber(self._choosePropsCount[""..k]) > 0 then
            Text_role_up_lv_num:setColor(cc.c3b(_quality_color[2][1], _quality_color[2][2], _quality_color[2][3]))
        else
            Text_role_up_lv_num:setColor(cc.c3b(_quality_color[1][1], _quality_color[1][2], _quality_color[1][3]))
        end
    end
end

--根据等级获取突破道具数量
function SilkBagUpgrade:getBreakeConsumeByLevel(curLevel)
    local breakeInfo = {}

    local breakeLevel = math.ceil(curLevel/10) - 1
    
    local breakeLibId = dms.int(dms["ship_silk_bag_mould"],self._choose_ship.silkMouldId,ship_silk_bag_mould.breake_group) 
    local breakeLib =dms.searchs(dms["silk_bag_break_group_mould"],ship_silk_bag_breake.lib_id,breakeLibId,ship_silk_bag_breake.cur_breake_level,breakeLevel)

    local shipConfig = breakeLib[1][ship_silk_bag_breake.breake_consume]
    shipConfigInfo = zstring.split(shipConfig,",")
    if -1 ~= tonumber(shipConfigInfo[1]) then
        breakeInfo.prop_id = shipConfigInfo[1]
        breakeInfo.prop_type = shipConfigInfo[2]
        breakeInfo.prop_num = shipConfigInfo[3]

        return breakeInfo
    end
    return nil
end

--获取目前突破所需道具总数量
function SilkBagUpgrade:getTotalConsumeForBreake(level)
    local needBreake = 0
    for i = tonumber(self._choose_ship.ship_grade) + 1, level do
        if math.floor(i/10) ~= tonumber(self._choose_ship.breakLevel) and (i-1) % 10 == 0  then
            local breakConsume = self:getBreakeConsumeByLevel(i-1)
            if nil ~= breakConsume then
                local need = breakConsume.prop_num
                needBreake = need + needBreake
            end
        end
    end

    return needBreake
end

--获取对应品质最大等级
function SilkBagUpgrade:getMaxLevelByDms()
    local quality = dms.int(dms["ship_silk_bag_mould"], self._choose_ship.silkMouldId,ship_silk_bag_mould.quality_level)
    local shipConfig = dms.string(dms["ship_config"],44,4)
    local infoGroups = zstring.split(shipConfig,"|")
    for k,v in pairs(infoGroups) do
        local info = zstring.split(v,",")
        if tonumber(quality) == tonumber(info[1]) then
            self.dms_max_level = tonumber(info[2])
            break
        end
    end
end

function SilkBagUpgrade:onInit()
    local csbItem = csb.createNode("packs/HeroStorage/sm_role_strengthen_tab_cell_2_window.csb")
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
    {
        terminal_name = "silkbag_auto_upgrade_window_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 3)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_Cancel"), nil, 
    {
        terminal_name = "silkbag_auto_upgrade_window_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add"), nil, 
    {
        terminal_name = "silkbag_auto_upgrade_change_times", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
        updateLevel = 1,
    }, nil, 1)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reduce"), nil, 
    {
        terminal_name = "silkbag_auto_upgrade_change_times", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
        updateLevel = -1,
    }, nil, 1)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_confirm"), nil, 
    {
        terminal_name = "silkbag_auto_upgrade_sure", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 1)

    local Slider_number = ccui.Helper:seekWidgetByName(root, "Slider_number")
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            state_machine.excute("silkbag_auto_upgrade_silder_update", 0, {sender:getPercent()})
        end
    end
    Slider_number:addEventListener(percentChangedEvent)
    self:getMaxLevelByDms()
    self._current_level = tonumber(self._choose_ship.ship_grade) + 1
    self:onUpdateDraw()
    self:setSelectNum(self._current_level)
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.01), cc.CallFunc:create(function (sender)
        if sender ~= nil and sender.roots ~= nil and sender.roots[1] ~= nil then
            sender:updatePropCellChooseState()
        end
    end)))
end

function SilkBagUpgrade:init(params)
    self._choose_ship = params
    self:onInit()
    return self
end

function SilkBagUpgrade:onExit()
    state_machine.remove("silkbag_auto_upgrade_sure")
    state_machine.remove("silkbag_auto_upgrade_silder_update")
    state_machine.remove("silkbag_auto_upgrade_change_times")
    state_machine.remove("silkbag_auto_upgrade_update_choose_props")
end