-- --------------------------------------------------------------------------------------------------
-- 说明：生产中或改造中cell
-- -----------------------------------------------------------------------------------------------------
BuildUpTankFactoryInProductionCell = class("BuildUpTankFactoryInProductionCellClass", Window)
BuildUpTankFactoryInProductionCell.__size = nil

local build_up_tank_factory_in_production_cell_create_terminal = {
    _name = "build_up_tank_factory_in_production_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local cell = BuildUpTankFactoryInProductionCell:new()
        local index = params[1]
        local from_type = params[2]
        local production_info = params[3]
        cell:init(index, from_type, production_info)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.1)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_up_tank_factory_in_production_cell_create_terminal)
state_machine.init()

function BuildUpTankFactoryInProductionCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = index
    self._last_time = 0
    self._max_time = 0
    self._start_time = 0
    self._need_gold = 0

    self._production_info = nil -- 生产信息

    app.load("client.red_alert_time.build_up.BuildUpBuildProductionQuickly")

    local function init_build_up_scientific_ing_cell_terminal()

        -- 取消
        local build_up_tank_factory_in_production_cell_cancel_terminal = {
            _name = "build_up_tank_factory_in_production_cell_cancel",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local tip = ConfirmTip:new()
                tip:init(cell, cell.sureCancelBuild, red_alert_all_str[270])
                fwin:open(tip,fwin._windows) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 加速
        local build_up_tank_factory_in_production_cell_speed_terminal = {
            _name = "build_up_tank_factory_in_production_cell_add_speed",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                if nil ~= cell._production_info then
                    state_machine.excute("build_up_build_production_quickly_window_open", 0, {cell._production_info.mould_id, cell._production_info, cell._from_type})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(build_up_tank_factory_in_production_cell_cancel_terminal)       
        state_machine.add(build_up_tank_factory_in_production_cell_speed_terminal)  
        state_machine.init()
    end
    init_build_up_scientific_ing_cell_terminal()           
end

function BuildUpTankFactoryInProductionCell:sureCancelBuild(sure_number)
    if self.roots == nil then
        return
    end
    local root = self.roots[1]
    if root == nil then
        return
    end

    if _ED.production_info[""..(self._from_type - 1)] == nil
        or _ED.production_info[""..(self._from_type - 1)][""..self._production_info.id] == nil
        then
        return
    end

    local build_id = self._from_type + 8
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            TipDlg.drawTextDailog(red_alert_all_str[281])
            state_machine.excute("home_map_update_prodcution_state", 0, {build_id})
            state_machine.excute("build_up_tank_factory_in_production_update_draw", 0, "")
            -- state_machine.excute("build_up_tank_factory_production_update_draw", 0, "")
            -- state_machine.excute("build_up_reform_factory_production_update_draw", 0, "")
        end
    end
    if sure_number == 0 then
        local factory_type = self._from_type - 1
        protocol_command.factory_product_cancel.param_list = ""..factory_type.."\r\n"..self._production_info.id
        NetworkManager:register(protocol_command.factory_product_cancel.code, nil, nil, nil, nil, responseCallback, false, nil)
    end
end

function BuildUpTankFactoryInProductionCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_tank_icon")
    local Text_tank_name = ccui.Helper:seekWidgetByName(root,"Text_tank_name")
    local Text_time_ing = ccui.Helper:seekWidgetByName(root,"Text_time_ing")
    local LoadingBar_time = ccui.Helper:seekWidgetByName(root,"LoadingBar_time")
    local Button_quicken = ccui.Helper:seekWidgetByName(root,"Button_quicken")
    Panel_tank_icon:removeBackGroundImage()
    Text_tank_name:setString("")

    self._loading_bar = LoadingBar_time
    self._text_time = Text_time_ing

    local tank_data = dms.element(dms["ship_mould"], self._production_info.mould_id)
    local tank_name = dms.atos(tank_data, ship_mould.captain_name)        -- 名称
    local pic = dms.atoi(tank_data, ship_mould.All_icon)                    -- 图标
    local quality = dms.atoi(tank_data, ship_mould.ship_type)              -- 品质

    -- 生产目标icon
    Panel_tank_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, pic))
    -- 生产目标名字
    Text_tank_name:removeAllChildren(true)
    local _richText_2 = ccui.RichText:create()
    _richText_2:ignoreContentAdaptWithSize(false) 
    local color = cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3])
    local re1 = ccui.RichElementText:create(1, color,255, tank_name, "fonts/simhei.ttf",20)
    _richText_2:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "*"..self._production_info.count, "fonts/simhei.ttf",20)
    _richText_2:pushBackElement(re2)
    _richText_2:setContentSize(cc.size(200,20))
    _richText_2:setPosition(cc.p(100,0))
    Text_tank_name:addChild(_richText_2)
    -- 生产目标所需时间

    if zstring.tonumber(self._production_info.production_state) == 0 then       -- 生产中
        self._max_time = self._production_info.production_start_cd
        self._start_time = self._production_info.production_start_time

        local now_time = os.time()
        local leave_time = self._max_time - zstring.tonumber((now_time + _ED.time_add_or_sub - self._start_time))
        local persent = math.floor((self._max_time - leave_time) * 100/ self._max_time)
        self._text_time:setString(exChangeTimeToString(leave_time))
        self._loading_bar:setPercent(persent)
        Button_quicken:setBright(true)
        Button_quicken:setTouchEnabled(true)
    else                    -- 等待中
        self._text_time:setString(red_alert_all_str[289])
        self._loading_bar:setPercent(0)
        Button_quicken:setBright(false)
        Button_quicken:setTouchEnabled(false)
    end
end

function BuildUpTankFactoryInProductionCell:onUpdate(dt)
    if self._text_time ~= nil then
        local now_time = os.time()
        if now_time - zstring.tonumber(self.last_time) >= 1 or now_time < zstring.tonumber(self.last_time) then 
            self.last_time = now_time
            local info = _ED.production_info[""..(self._from_type - 1)]
            if info ~= nil
                and info[""..self._production_info.id] ~= nil
                and zstring.tonumber(info[""..self._production_info.id].production_state) == 0 
                then

                local leave_time = self._max_time - zstring.tonumber((now_time + _ED.time_add_or_sub - self._start_time))
                leave_time = math.min(leave_time, self._max_time)
                local persent = math.floor((self._max_time - leave_time) * 100 / self._max_time)
                self._loading_bar:setPercent(persent)
                self._text_time:setString(exChangeTimeToString(leave_time))
                local need_gold = dms.int(dms["major_city_config"],11,major_city_config.param)
                self._need_gold = math.ceil(leave_time/60 * need_gold)
            end
        end
    end
end

function BuildUpTankFactoryInProductionCell:onEnterTransitionFinish()

end

function BuildUpTankFactoryInProductionCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.build_up.build_up_tank_factory_cell_2, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    local size = root:getContentSize()
    
    if BuildUpTankFactoryInProductionCell.__size == nil then
        BuildUpTankFactoryInProductionCell.__size = size
    end

    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_cancel"), nil, 
    {
        terminal_name = "build_up_tank_factory_in_production_cell_cancel", 
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95, 
        touch_black = true,
    },
    nil,1)

    -- 加速
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_quicken"), nil, 
    {
        terminal_name = "build_up_tank_factory_in_production_cell_add_speed", 
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95, 
        touch_black = true,
    },
    nil,1)

    if zstring.tonumber(self._production_info.production_state) == 0 then
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_quick_prop_push",
            _widget = ccui.Helper:seekWidgetByName(root, "Button_quicken"),
            ntype = 3,
            _invoke = nil,
            _interval = 0.2,})
    else
        local widget = ccui.Helper:seekWidgetByName(root, "Button_quicken")
        if widget._nodeChild ~= nil then
            widget:removeChild(widget._nodeChild, true)
            widget._nodeChild = nil
            widget._istips = false
        end
        state_machine.excute("notification_center_remove_widget", 0, { _widget = widget })
    end
    
    self:onUpdateDraw()
end

function BuildUpTankFactoryInProductionCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_tank_factory_cell_2, self.roots[1])

end

function BuildUpTankFactoryInProductionCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function BuildUpTankFactoryInProductionCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_tank_factory_cell_2, root)
    root:removeFromParent(false)
    self.roots = {}
end

function BuildUpTankFactoryInProductionCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_tank_icon")
    local Text_tank_name = ccui.Helper:seekWidgetByName(root,"Text_tank_name")
    local Text_time_ing = ccui.Helper:seekWidgetByName(root,"Text_time_ing")
    local LoadingBar_time = ccui.Helper:seekWidgetByName(root,"LoadingBar_time")
    local Button_quicken = ccui.Helper:seekWidgetByName(root, "Button_quicken")

    if Panel_tank_icon ~= nil then
        Panel_tank_icon:removeBackGroundImage()
        Text_tank_name:setString("")
        Text_tank_name:removeAllChildren(true)
        Text_time_ing:setString("")
        LoadingBar_time:setPercent(0)
        if Button_quicken._nodeChild ~= nil then
            Button_quicken:removeChild(Button_quicken._nodeChild, true)
            Button_quicken._nodeChild = nil
            Button_quicken._istips = false
            state_machine.excute("notification_center_remove_widget", 0, { _widget = Button_quicken })
        end
    end
end

function BuildUpTankFactoryInProductionCell:init(index, from_type, production_info) 
    self._index = index
    self._from_type = from_type
    self._production_info = production_info

    if index ~= nil and index <= 10 then
        self:onInit()
    end
    self:setContentSize(BuildUpTankFactoryInProductionCell.__size)
end

