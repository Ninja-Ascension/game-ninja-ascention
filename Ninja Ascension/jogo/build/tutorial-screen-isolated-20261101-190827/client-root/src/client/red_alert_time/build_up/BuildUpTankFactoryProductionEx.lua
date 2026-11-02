--------------------------------------------------------------------------------------------------------------
--  生产列表
--------------------------------------------------------------------------------------------------------------
BuildUpTankFactoryProductionEx = class("BuildUpTankFactoryProductionExClass", Window)

local build_up_tank_factory_production_ex_window_open_terminal = {
    _name = "build_up_tank_factory_production_ex_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = BuildUpTankFactoryProductionEx:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_up_tank_factory_production_ex_window_open_terminal)
state_machine.init()

function BuildUpTankFactoryProductionEx:ctor()
    self.super:ctor()
    self.roots = {}
    
    self._Image_production_arrow_left = nil
    self._Image_production_arrow_right = nil

    self._from_type = 0         -- 1坦克工厂1，2坦克工厂2，3改造工厂
    self.choose_type = 0
    self.pageIndex = 1
    self.tank_list = {}
    self.reform_list = {}
    self._can_production = false

    app.load("client.red_alert_time.cells.build_up.build_up_tank_factory_tank_icon_cell")
    app.load("client.red_alert_time.cells.build_up.build_up_tank_factory_tank_choose_cell")

    local function init_build_up_tank_factory_production_ex_terminal()
        local build_up_tank_factory_production_ex_update_draw_terminal = {
            _name = "build_up_tank_factory_production_ex_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("build_up_tank_factory_production_ex_upgrade_info", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        local build_up_tank_factory_production_ex_show_terminal = {
            _name = "build_up_tank_factory_production_ex_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local page = params
                if page ~= nil and page.roots ~= nil and page.roots[1] ~= nil then
                    page:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local build_up_tank_factory_production_ex_hide_terminal = {
            _name = "build_up_tank_factory_production_ex_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local page = params
                if page ~= nil and page.roots ~= nil and page.roots[1] ~= nil then
                    page:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local build_up_tank_factory_production_ex_upgrade_info_terminal = {
            _name = "build_up_tank_factory_production_ex_upgrade_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local build_up_tank_factory_production_ex_choose_terminal = {
            _name = "build_up_tank_factory_production_ex_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                instance:choosePage(index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local build_up_tank_factory_production_ex_show_info_terminal = {
            _name = "build_up_tank_factory_production_ex_show_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local tankId = 0
                if instance._from_type == 3 then
                    tankId = instance.reform_list[""..instance.choose_type][instance.pageIndex]
                else
                    tankId = instance.tank_list[""..instance.choose_type][instance.pageIndex]
                end
                local tank_info = {tank_id = tankId}
                state_machine.excute("build_up_tank_production_window_open", 0, {instance._from_type, tank_info, false})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local build_up_tank_factory_production_ex_choose_tank_terminal = {
            _name = "build_up_tank_factory_production_ex_choose_tank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local choose_index = params
                instance:scrollToPageIndex(choose_index - 1)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(build_up_tank_factory_production_ex_update_draw_terminal)
        state_machine.add(build_up_tank_factory_production_ex_show_terminal)
        state_machine.add(build_up_tank_factory_production_ex_hide_terminal)
        state_machine.add(build_up_tank_factory_production_ex_upgrade_info_terminal)
        state_machine.add(build_up_tank_factory_production_ex_choose_terminal)
        state_machine.add(build_up_tank_factory_production_ex_show_info_terminal)
        state_machine.add(build_up_tank_factory_production_ex_choose_tank_terminal)
        state_machine.init()
    end
    
    init_build_up_tank_factory_production_ex_terminal()
end

function BuildUpTankFactoryProductionEx:updateChooseTank()
    local root = self.roots[1]
    local ListView_2 = ccui.Helper:seekWidgetByName(root,"ListView_2")

    local result = {}
    if self._from_type == 3 then
        result = self.reform_list[""..self.choose_type]
    else
        result = self.tank_list[""..self.choose_type]
    end

    local items = ListView_2:getItems()
    for k,v in pairs(items) do
        state_machine.excute("build_up_tank_factory_tank_choose_cell_update_info", 0, {cell = v, index = k, ship_mould_id = result[k]})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            ListView_2:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("build_up_tank_factory_tank_choose_cell_create",0, {i,result[i], self._from_type})
            ListView_2:addChild(cell)
        end
    end

    ListView_2:requestRefreshView()
    self:updateChooseTankState()
end

function BuildUpTankFactoryProductionEx:updateChooseTankState()
    local root = self.roots[1]
    local ListView_2 = ccui.Helper:seekWidgetByName(root,"ListView_2")
    local items = ListView_2:getItems()
    for k, v in pairs(items) do
        if k == self.pageIndex then
            state_machine.excute("build_up_tank_factory_tank_choose_cell_set_selected", 0, {v, true})
        else
            state_machine.excute("build_up_tank_factory_tank_choose_cell_set_selected", 0, {v, false})
        end
    end
end

function BuildUpTankFactoryProductionEx:choosePage( index )
    local root = self.roots[1]
    for i=1,4 do
        if i == index then
            ccui.Helper:seekWidgetByName(root,"Button_type_"..i):setHighlighted(true)
        else
            ccui.Helper:seekWidgetByName(root,"Button_type_"..i):setHighlighted(false)
        end
    end
    if self.choose_type == index then
        return
    end
    self.choose_type = index

    local maxCanPro = 1
    local tank_arry = self.tank_list[""..self.choose_type]
    local cur_level = 0
    if self._from_type == 1 then    -- 坦克工厂1
        if _ED.home_build["9"] ~= nil then
            cur_level = _ED.home_build["9"].level
        end
    elseif self._from_type == 2 then    -- 坦克工厂2
        if _ED.home_build["10"] ~= nil then
            cur_level = _ED.home_build["10"].level
        end
    elseif self._from_type == 3 then    -- 改造工厂
        if _ED.home_build["9"] ~= nil then
            cur_level = _ED.home_build["9"].level
        end
        if _ED.home_build["10"] ~= nil 
            and cur_level < _ED.home_build["10"].level then
            cur_level = _ED.home_build["10"].level
        end
        tank_arry = self.reform_list[""..self.choose_type]
    end
    for i , v in pairs(tank_arry) do
        local boatyard_level = dms.int(dms["ship_mould"], tonumber(v) ,ship_mould.boatyard_level) 
        if boatyard_level > cur_level then
            maxCanPro = i - 1
            break
        end
    end
    if maxCanPro < 1 then
        maxCanPro = 1
    end
    self.pageIndex = maxCanPro
    self:updateTankListInfo()
    self:updateDraw()
    self:turnButtonCheckShow()
    self:updateChooseTank()
    fwin:addService({
        callback = function ( params )
            params:scrollToPageIndex(params.pageIndex - 1)
        end,
        delay = 0.1,
        params = self
    })
end

function BuildUpTankFactoryProductionEx:initPageViewScrollTouchListen()
    local root = self.roots[1]
    local PageView_tank = ccui.Helper:seekWidgetByName(root, "PageView_tank")
    PageView_tank:setCustomScrollThreshold(PageView_tank:getContentSize().width / 5)
    local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
            local nowPageIndex = sender:getCurPageIndex()
            self.pageIndex = sender:getCurPageIndex() + 1
            -- if self._from_type == 3 then
            --     if self.pageIndex > #self.reform_list[""..self.choose_type] then
            --         self.pageIndex = 1
            --         self:scrollToPageIndex(self.pageIndex - 1)
            --     end
            -- else
            --     if self.pageIndex > #self.tank_list[""..self.choose_type] then
            --         self.pageIndex = 1
            --         self:scrollToPageIndex(self.pageIndex - 1)
            --     end
            -- end
            self:turnButtonCheckShow()
            self:updateDraw()
            self:updateChooseTankState()
        end
    end 
    PageView_tank:addEventListener(pageViewEvent)
end

function BuildUpTankFactoryProductionEx:scrollToPageIndex(pageIndex)
    local root = self.roots[1]
    local PageView_tank = ccui.Helper:seekWidgetByName(root,"PageView_tank")
    PageView_tank:scrollToPage(pageIndex)
end

function BuildUpTankFactoryProductionEx:turnButtonCheckShow()
    local root = self.roots[1]
    if self.pageIndex == 1 then
        self._Image_production_arrow_left:setVisible(false)
    else
        self._Image_production_arrow_left:setVisible(true)
    end
    local maxCount = 0
    if self._from_type == 3 then
        maxCount = #self.reform_list[""..self.choose_type]
    else
        maxCount = #self.tank_list[""..self.choose_type]
    end
    if self.pageIndex == maxCount then
        self._Image_production_arrow_right:setVisible(false)
    else
        self._Image_production_arrow_right:setVisible(true)
    end
end

function BuildUpTankFactoryProductionEx:updateDraw()
    local root = self.roots[1]
    local Text_tank_num = ccui.Helper:seekWidgetByName(root, "Text_tank_num")
    local Panel_tank_type = ccui.Helper:seekWidgetByName(root, "Panel_tank_type")
    local Text_output_n = ccui.Helper:seekWidgetByName(root, "Text_output_n")
    local Text_load_n = ccui.Helper:seekWidgetByName(root, "Text_load_n")
    local Text_attack_n = ccui.Helper:seekWidgetByName(root, "Text_attack_n")
    local Text_tank_name = ccui.Helper:seekWidgetByName(root, "Text_tank_name")
    local Text_have_lv = ccui.Helper:seekWidgetByName(root, "Text_have_lv")
    local Image_lv_bg = ccui.Helper:seekWidgetByName(root, "Image_lv_bg")
    local Image_lock = ccui.Helper:seekWidgetByName(root, "Image_lock_1")

    local tankId = 0
    if self._from_type == 3 then
        tankId = self.reform_list[""..self.choose_type][self.pageIndex]
    else
        tankId = self.tank_list[""..self.choose_type][self.pageIndex]
    end

    local tank_data = dms.element(dms["ship_mould"], tankId)
    local tank_name = dms.atos(tank_data, ship_mould.captain_name)        -- 名称
    local pic = dms.atoi(tank_data, ship_mould.All_icon)                    -- 图标
    local quality = dms.atoi(tank_data, ship_mould.ship_type)              -- 品质
    local boatyard_level = dms.atoi(tank_data, ship_mould.boatyard_level)    -- 需要工厂等级
    local range = dms.atoi(tank_data, ship_mould.sign_msg)                   -- 攻击范围
    local output = dms.atoi(tank_data, ship_mould.initial_power)
    local attack = dms.atoi(tank_data, ship_mould.initial_courage)
    local load = dms.atos(tank_data, ship_mould.ability)

    Text_tank_name:setString(tank_name)
    Text_tank_name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))

    local tank_data = getShipByTemplateId(tankId)
    local count = 0
    if tank_data ~= nil then
        count = tonumber(tank_data.current_count)
    end
    Text_tank_num:setString(count)
    Panel_tank_type:removeBackGroundImage()
    Panel_tank_type:setBackGroundImage(string.format(config_res.images.ui.icon.icon, range + 114))

    Text_output_n:setString(output)
    Text_attack_n:setString(attack)
    Text_load_n:setString(load)

    local cur_level = 0
    if self._from_type == 1 then    -- 坦克工厂1
        if _ED.home_build["9"] ~= nil then
            cur_level = _ED.home_build["9"].level
        end
    elseif self._from_type == 2 then    -- 坦克工厂2
        if _ED.home_build["10"] ~= nil then
            cur_level = _ED.home_build["10"].level
        end
    elseif self._from_type == 3 then    -- 改造工厂
        if _ED.home_build["9"] ~= nil then
            cur_level = _ED.home_build["9"].level
        end
        if _ED.home_build["10"] ~= nil 
            and cur_level < _ED.home_build["10"].level then
            cur_level = _ED.home_build["10"].level
        end
    end

    if boatyard_level <= cur_level then
        Text_have_lv:setVisible(false)
        Image_lv_bg:setVisible(false)
        Image_lock:setVisible(false)
        self._can_production = true
        state_machine.excute("build_up_tank_production_proc_ex_show", 0, "")
        state_machine.excute("build_up_tank_production_proc_ex_update_tank_id", 0, tankId)
    else
        Text_have_lv:setVisible(true)
        Image_lv_bg:setVisible(true)
        Image_lock:setVisible(true)
        self._can_production = false
        Text_have_lv:setString(string.format(red_alert_all_str[271], boatyard_level))
        state_machine.excute("build_up_tank_production_proc_ex_hide", 0, "")
    end
end

function BuildUpTankFactoryProductionEx:updateTankListInfo( ... )
    local root = self.roots[1]
    local PageView_tank = ccui.Helper:seekWidgetByName(root, "PageView_tank")
    PageView_tank:removeAllPages()
    PageView_tank:removeAllChildren(true)
    if self._from_type == 3 then
        for k,v in pairs(self.reform_list[""..self.choose_type]) do
            local cell = state_machine.excute("build_up_tank_factory_tank_icon_cell_create", 0, {v})
            PageView_tank:addPage(cell)
        end
    else
        for k,v in pairs(self.tank_list[""..self.choose_type]) do
            local cell = state_machine.excute("build_up_tank_factory_tank_icon_cell_create", 0, {v})
            PageView_tank:addPage(cell)
        end
    end
end

function BuildUpTankFactoryProductionEx:onInit()
    local csbItem = csb.createNode(config_csb.build_up.build_up_tank_factory_tab_3)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    for i=1,4 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_type_"..i), nil, 
        {
            terminal_name = "build_up_tank_factory_production_ex_choose",     
            terminal_state = 0, 
            index = i,
        }, nil, 1)
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_tank_info"), nil, 
    {
        terminal_name = "build_up_tank_factory_production_ex_show_info",     
        terminal_state = 0, 
    }, nil, 1)

    self._Image_production_arrow_left = ccui.Helper:seekWidgetByName(root,"Image_production_arrow_left")
    self._Image_production_arrow_right = ccui.Helper:seekWidgetByName(root,"Image_production_arrow_right")

    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_production_arrow_right:stopAllActions()
    self._Image_production_arrow_left:stopAllActions()
    playActions(self._Image_production_arrow_right)
    playActions(self._Image_production_arrow_left)

    self.tank_list = {}
    self.reform_list = {}
    local count = dms.count(dms["ship_mould"])
    for i = 1, 100 do
        local can_production = dms.int(dms["ship_mould"], i, ship_mould.is_general)        -- 是否可生产
        local can_reform = dms.int(dms["ship_mould"], i, ship_mould.can_recruit)        -- 是否可改造
        local camp_preference = 0
        if can_production == 1 then
            camp_preference = dms.int(dms["ship_mould"], i, ship_mould.camp_preference)        -- 排序
            if self.tank_list[""..camp_preference] == nil then
                self.tank_list[""..camp_preference] = {}
            end
            table.insert(self.tank_list[""..camp_preference], i)
        end
        if can_reform == 1 then
            if camp_preference == 0 then
                camp_preference = dms.int(dms["ship_mould"], i, ship_mould.camp_preference)        -- 排序
            end
            if self.reform_list[""..camp_preference] == nil then
                self.reform_list[""..camp_preference] = {}
            end
            table.insert(self.reform_list[""..camp_preference], i)
        end
    end

    local Panel_information = ccui.Helper:seekWidgetByName(root, "Panel_information")
    state_machine.excute("build_up_tank_production_proc_ex_window_open", 0, {Panel_information, self._from_type})

    self:initPageViewScrollTouchListen()
    self:choosePage(1)
end

function BuildUpTankFactoryProductionEx:onEnterTransitionFinish()
    
end

function BuildUpTankFactoryProductionEx:init(params)
    local rootWindow = params[1]
    self._from_type = params[2]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function BuildUpTankFactoryProductionEx:onExit()
    state_machine.remove("build_up_tank_factory_production_ex_update_draw")
    state_machine.remove("build_up_tank_factory_production_ex_show")
    state_machine.remove("build_up_tank_factory_production_ex_hide")
    state_machine.remove("build_up_tank_factory_production_ex_upgrade_info")
    state_machine.remove("build_up_tank_factory_production_ex_choose")
    state_machine.remove("build_up_tank_factory_production_ex_show_info")
    state_machine.remove("build_up_tank_factory_production_ex_choose_tank")
end

