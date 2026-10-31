-- --------------------------------------------------------------------------------------------------
-- 说明：升级中cell
-- -----------------------------------------------------------------------------------------------------
BuildUpScientificIngCell = class("BuildUpScientificIngCellClass", Window)
BuildUpScientificCellSize = BuildUpScientificCellSize or nil

local build_up_scientific_ing_cell_create_terminal = {
    _name = "build_up_scientific_ing_cell_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local cell = BuildUpScientificIngCell:new()
        local index = params[1]
        local base_barracks_info = params[2]
        local barracks_info = params[3]
        cell:init(index, base_barracks_info, barracks_info)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_up_scientific_ing_cell_create_terminal)
state_machine.init()

function BuildUpScientificIngCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._base_barracks_info = nil
    self._barracks_info = nil

    self._max_time = 0
    self._start_time = 0
    self._need_gold = 0

    local function init_build_up_scientific_ing__cell_terminal()

        -- 取消
        local build_up_scientific_ing_cell_cancel_terminal = {
            _name = "build_up_scientific_ing_cell_cancel",
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
        local build_up_scientific_ing_cell_speed_terminal = {
            _name = "build_up_scientific_ing_cell_add_speed",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                state_machine.excute("build_up_build_scientific_quickly_window_open",0,{cell._base_barracks_info.id,cell._base_barracks_info,cell._need_gold})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 查看详情
        local build_up_scientific_ing_cell_click_terminal = {
            _name = "build_up_scientific_ing_cell_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if cell._base_barracks_info ~= nil then
                    state_machine.excute("build_up_scientific_info_open", 0, {cell._barracks_info, cell._base_barracks_info})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(build_up_scientific_ing_cell_cancel_terminal)       
        state_machine.add(build_up_scientific_ing_cell_speed_terminal)  
        state_machine.add(build_up_scientific_ing_cell_click_terminal)
        state_machine.init()
    end
    init_build_up_scientific_ing__cell_terminal()           
end

function BuildUpScientificIngCell:sureCancelBuild(sure_number)
    if self.roots == nil then
        return
    end
    local root = self.roots[1]
    if root == nil then
        return
    end

    if tonumber(_ED.barracks_info[""..self._base_barracks_info.id].barrack_state) == 0 then
        return
    end
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            TipDlg.drawTextDailog(red_alert_all_str[281])
            state_machine.excute("home_map_update_prodcution_state", 0, {3})
            state_machine.excute("build_up_scientific_to_update_draw", 0, "")
            checkPlayEffect(78)
        end
    end
    if sure_number == 0 then
        protocol_command.barracks_teach_update_cancel.param_list = ""..self._base_barracks_info.id
        NetworkManager:register(protocol_command.barracks_teach_update_cancel.code, nil, nil, nil, nil, responseCallback, false, nil)
    end
end

function BuildUpScientificIngCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    local Text_scientific_name = ccui.Helper:seekWidgetByName(root,"Text_scientific_name")
    local Text_time_ing_n = ccui.Helper:seekWidgetByName(root,"Text_time_ing_n")
    local LoadingBar_time = ccui.Helper:seekWidgetByName(root,"LoadingBar_time")
    local Button_up = ccui.Helper:seekWidgetByName(root,"Button_up")
    local Text_scientific_lv = ccui.Helper:seekWidgetByName(root,"Text_scientific_lv")
    local Image_loading_time_bg = ccui.Helper:seekWidgetByName(root,"Image_loading_time_bg")
    Panel_props_icon:removeBackGroundImage()
    Panel_props_icon:removeAllChildren(true)
    Text_scientific_name:setString("")
    LoadingBar_time:setVisible(true)
    Text_time_ing_n:setVisible(true)
    Image_loading_time_bg:setVisible(true)

    self._loading_bar = LoadingBar_time
    self._text_time = Text_time_ing_n
    Button_up:setVisible(true)

    local Text_scientific_free = ccui.Helper:seekWidgetByName(root,"Text_scientific_free")
    local Image_vip_rock = ccui.Helper:seekWidgetByName(root,"Image_vip_rock")
    local Text_scientific_vip_lv = ccui.Helper:seekWidgetByName(root,"Text_scientific_vip_lv")
    local Panel_props_que_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_que_icon")
    local Panel_attribute_icon = ccui.Helper:seekWidgetByName(root,"Panel_attribute_icon")
    local Image_scientific_free = ccui.Helper:seekWidgetByName(root,"Image_scientific_free")
    if Text_scientific_free ~= nil then
        Text_scientific_free:setVisible(false)
    end
    if Image_scientific_free ~= nil then
        Image_scientific_free:setVisible(false)
    end
    if Image_vip_rock ~= nil then
        Image_vip_rock:setVisible(false)
    end
    if Text_scientific_vip_lv ~= nil then
        Text_scientific_vip_lv:setVisible(false)
    end
    if Panel_props_que_icon ~= nil then
        Panel_props_que_icon:removeBackGroundImage()
    end
    if Panel_attribute_icon ~= nil then
        Panel_attribute_icon:removeBackGroundImage()
    end

    if self._base_barracks_info == nil then
        Button_up:setVisible(false)
        LoadingBar_time:setVisible(false)
        Text_time_ing_n:setVisible(false)
        Image_loading_time_bg:setVisible(false)
        Image_scientific_free:setVisible(true)
        Panel_props_que_icon:setBackGroundImage(string.format(config_res.images.ui.icon.icon, 100))
        local max_count = dms.int(dms["base_consume"], 79, tonumber(_ED.vip_grade) + 4)
        if self._index <= max_count then
            Text_scientific_free:setVisible(true)
            Text_scientific_free:setString(tipString_info_project_pacific_rim[20])
        else
            Image_vip_rock:setVisible(true)
            Text_scientific_vip_lv:setVisible(true)
            local need_vip = 0
            local element = dms.element(dms["base_consume"], 79)
            for i = 1, tonumber(_vip_max_grade[1]) do
                local count = dms.atoi(element, i + 4)
                if count >= self._index then
                    need_vip = i
                    break
                end
            end
            Text_scientific_vip_lv:setString(_string_piece_info[228]..need_vip)
        end
    else
        -- 科研目标名字
        local FontSize = Text_scientific_name:getFontSize()
        if Text_scientific_lv ~= nil then
            Text_scientific_lv:setString(self._barracks_info.barrack_level)
            Text_scientific_name:setString(self._base_barracks_info.name)
        else
            Text_scientific_name:removeAllChildren(true)
            local _richText_2 = ccui.RichText:create()
            _richText_2:ignoreContentAdaptWithSize(false) 
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, self._base_barracks_info.name, "fonts/simhei.ttf",FontSize)
            _richText_2:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, " "..string.format(red_alert_all_str[13], self._barracks_info.barrack_level), "fonts/simhei.ttf",FontSize)
            _richText_2:pushBackElement(re2)
            _richText_2:setContentSize(cc.size(Text_scientific_name:getContentSize().width,FontSize))
            _richText_2:setPosition(cc.p(Text_scientific_name:getContentSize().width / 2,FontSize))
            Text_scientific_name:addChild(_richText_2)
        end
        if __lua_project_id == __lua_project_pacific_rim then
            local pic_index = zstring.split(dms.string(dms["teach_escalate_param"], self._base_barracks_info.id, teach_escalate_param.pic_index), ",")
            Panel_props_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, pic_index[1]))
            Panel_props_que_icon:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[2]))
            Panel_attribute_icon:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[6]))

            local now_time = os.time()
            self._start_time = zstring.tonumber(self._barracks_info.barrack_upgrade_time)
            self._max_time = zstring.tonumber(self._barracks_info.barrack_upgrade_cd)

            local add_time = 0
            if zstring.tonumber(_ED.barracks_info[""..self._base_barracks_info.id].barrack_state) == 1 then
                add_time = zstring.tonumber((now_time + _ED.time_add_or_sub - self._barracks_info.barrack_upgrade_time))
                Button_up:setVisible(true)
                Text_scientific_free:setVisible(false)
                Image_scientific_free:setVisible(false)
            else
                Button_up:setVisible(false)
                Text_scientific_free:setVisible(true)
                Image_scientific_free:setVisible(true)
                Text_scientific_free:setString(tipString_info_project_pacific_rim[19])
            end

            local leave_time = self._max_time - add_time
            local persent = math.floor((self._max_time - leave_time) * 100/ self._max_time)
            self._text_time:setString(exChangeTimeToString(leave_time))
            self._loading_bar:setPercent(persent)
        else
            -- 科研目标icon
            local cell = state_machine.excute("props_icon_create_cell",0,{4,3,self._base_barracks_info.id,4})
            Panel_props_icon:addChild(cell) 
            -- 科研目标所需时间
            if zstring.tonumber(_ED.barracks_info[""..self._base_barracks_info.id].barrack_state) == 1 then             -- 升级中
                local now_time = os.time()

                self._start_time = zstring.tonumber(self._barracks_info.barrack_upgrade_time)
                self._max_time = zstring.tonumber(self._barracks_info.barrack_upgrade_cd)
                
                local leave_time = self._max_time - zstring.tonumber((now_time + _ED.time_add_or_sub - self._barracks_info.barrack_upgrade_time))
                local persent = math.floor((self._max_time - leave_time) * 100/ self._max_time)
                self._text_time:setString(exChangeTimeToString(leave_time))
                self._loading_bar:setPercent(persent)

                Button_up:setBright(true)
                Button_up:setTouchEnabled(true)
            elseif zstring.tonumber(_ED.barracks_info[""..self._base_barracks_info.id].barrack_state) == 2 then             -- 等待中
                self._text_time:setString(red_alert_all_str[289])
                self._loading_bar:setPercent(0)
                Button_up:setBright(false)
                Button_up:setTouchEnabled(false)
            end
        end
    end
end

function BuildUpScientificIngCell:onUpdate(dt)
    if self._base_barracks_info == nil or _ED.barracks_info[""..self._base_barracks_info.id] == nil then
        return
    end

    if self._text_time ~= nil then
        local now_time = os.time()
        if now_time - zstring.tonumber(self.last_time) >= 1 or now_time < zstring.tonumber(self.last_time) then 
            self.last_time = now_time
            if zstring.tonumber(_ED.barracks_info[""..self._base_barracks_info.id].barrack_state) == 1 then
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

function BuildUpScientificIngCell:onEnterTransitionFinish()

end

function BuildUpScientificIngCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.build_up.build_up_scientific_ing_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    local size = root:getContentSize()
    
    if BuildUpScientificCellSize == nil then
        BuildUpScientificCellSize = size
    end

    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_infor"), nil, 
    {
        terminal_name = "build_up_scientific_ing_cell_cancel", 
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)

    -- 加速
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_up"), nil, 
    {
        terminal_name = "build_up_scientific_ing_cell_add_speed", 
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)
    if self._base_barracks_info ~= nil and zstring.tonumber(_ED.barracks_info[""..self._base_barracks_info.id].barrack_state) == 1 then
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_quick_prop_push",
            _widget = ccui.Helper:seekWidgetByName(root, "Button_up"),
            ntype = 2,
            _invoke = nil,
            _interval = 0.2,})
    else
        local widget = ccui.Helper:seekWidgetByName(root, "Button_up")
        if widget._nodeChild ~= nil then
            widget:removeChild(widget._nodeChild, true)
            widget._nodeChild = nil
            widget._istips = false
        end
        state_machine.excute("notification_center_remove_widget", 0, { _widget = widget })
    end

    -- 查看详情
    ccui.Helper:seekWidgetByName(root,"Panel_props_icon"):setTouchEnabled(false)
    fwin:addTouchEventListener(root, nil, 
    {
        terminal_name = "build_up_scientific_ing_cell_click", 
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)
    
    self:onUpdateDraw()
end

function BuildUpScientificIngCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_scientific_ing_cell, self.roots[1])
end

function BuildUpScientificIngCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
    self:registerOnNoteUpdate(self, 0.5)
end

function BuildUpScientificIngCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_scientific_ing_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function BuildUpScientificIngCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    local Text_scientific_name = ccui.Helper:seekWidgetByName(root,"Text_scientific_name")
    local Text_time_ing_n = ccui.Helper:seekWidgetByName(root,"Text_time_ing_n")
    local LoadingBar_time = ccui.Helper:seekWidgetByName(root,"LoadingBar_time")
    local Button_up = ccui.Helper:seekWidgetByName(root,"Button_up")
    local Text_scientific_lv = ccui.Helper:seekWidgetByName(root,"Text_scientific_lv")
    local Panel_props_que_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_que_icon")
    local Panel_attribute_icon = ccui.Helper:seekWidgetByName(root,"Panel_attribute_icon")
    if Panel_props_icon ~= nil then
        Panel_props_icon:removeBackGroundImage()
        Panel_props_icon:removeAllChildren(true)
        Text_scientific_name:setString("")
        Text_scientific_name:removeAllChildren(true)
        Text_time_ing_n:setString("")
        LoadingBar_time:setPercent(0)
        Button_up:setBright(true)
        Button_up:setTouchEnabled(true)
        
        if Button_up._nodeChild ~= nil then
            Button_up:removeChild(Button_up._nodeChild, true)
            Button_up._nodeChild = nil
            Button_up._istips = false
        end
        state_machine.excute("notification_center_remove_widget", 0, { _widget = Button_up })
    end
    if Text_scientific_lv ~= nil then
        Text_scientific_lv:setString("")
    end
    if Panel_props_que_icon ~= nil then
        Panel_props_que_icon:removeBackGroundImage()
    end
    if Panel_attribute_icon ~= nil then
        Panel_attribute_icon:removeBackGroundImage()
    end

    self._max_time = 0
    self._start_time = 0
    self._need_gold = 0
    self:unregisterOnNoteUpdate(self)
end

function BuildUpScientificIngCell:init(index, base_barracks_info, barracks_info) 
    self._index = index
    self._base_barracks_info = base_barracks_info
    self._barracks_info = barracks_info

    if index ~= nil and index <= 8 then
        self:onInit()
    end
    self:setContentSize(BuildUpScientificCellSize)
end

