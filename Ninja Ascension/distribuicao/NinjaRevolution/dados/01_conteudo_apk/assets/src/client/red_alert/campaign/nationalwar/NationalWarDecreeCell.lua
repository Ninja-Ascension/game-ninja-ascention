-----------------------------
--号令cell
-----------------------------
NationalWarDecreeCell = class("NationalWarDecreeCellClass", Window)
NationalWarDecreeCell.__fontName = ""

local national_war_decree_cell_create_cell_terminal = {
    _name = "national_war_decree_cell_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = NationalWarDecreeCell:new()
        local data = params[1]
        local from_type = params[2]
        cell:init(data)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_decree_cell_create_cell_terminal)
state_machine.init()

function NationalWarDecreeCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.decree_data = nil
    self.time_text = nil
    self._lasttime = nil
    self._from_type = nil -- 1 城池外 2 城池内
    -- Initialize national_war_decree machine.
    local function init_national_war_decree_cell_terminal()

        -- 集结瞬间移动
        local national_war_decree_cell_goto_pos_terminal = {
            _name = "national_war_decree_cell_goto_pos",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local city_id = params._datas.cell.decree_data.city
                state_machine.excute("national_war_city_war_map_window_close",0,"")
                state_machine.excute("national_war_decree_window_close",0,"")
                state_machine.excute("national_war_map_move_to_city",0,{city_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(national_war_decree_cell_goto_pos_terminal)    
        state_machine.init()
    end
    
    -- call func init national_war_decree machine.
    init_national_war_decree_cell_terminal()    
end


function NationalWarDecreeCell:onUpdateDraw()
    local root = self.roots[1]
    local city_id = tonumber(self.decree_data.city)
    local order_type = tonumber(self.decree_data.order_type)  
    local city_name = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould],city_id,warfare_map_mould.city_name)
    local userName = self.decree_data.userName
    local Text_decree_build = ccui.Helper:seekWidgetByName(root,"Text_decree_build") -- 建筑名字
    Text_decree_build:setString(city_name)
    local Text_promulgator_name = ccui.Helper:seekWidgetByName(root,"Text_promulgator_name") -- 发布人名字
    local Panel_decree_build = ccui.Helper:seekWidgetByName(root,"Panel_decree_build")
    local pic_index = dms.int(dms[config_res.campaign.nationalwar.warfare_map_mould],city_id,warfare_map_mould.city_pic)
    Panel_decree_build:setBackGroundImage("images/ui/play/nationalwar/build/nationalwar_building_".. pic_index ..".png")    
    local Text_decree_time = ccui.Helper:seekWidgetByName(root,"Text_decree_time") -- 冷却时间

    local Panel_build_propelling = ccui.Helper:seekWidgetByName(root,"Panel_build_propelling")
    Panel_build_propelling:setVisible(true)
    local Image_mass = ccui.Helper:seekWidgetByName(root,"Image_mass")
    local Image_group = ccui.Helper:seekWidgetByName(root,"Image_group")
    Image_mass:setVisible(false)
    Image_group:setVisible(false)
    local officer = tonumber(self.decree_data.officer)
    local leave_time = 0
    if ___is_open_leadname == true then 
        Text_promulgator_name:setFontName("")
        Text_promulgator_name:setFontSize(Text_promulgator_name:getFontSize())
    end
    if order_type == 1 then
        Text_promulgator_name:setString(red_alert_officer[officer]..userName)
        Image_mass:setVisible(true)
        leave_time = self:formatTimeString(_ED.war_decree_time[city_id].country_leave_time)
        Text_decree_time:setString(leave_time)
    elseif order_type == 2 then
        Text_promulgator_name:setString(red_alert_family_officer[officer]..userName)
        Image_group:setVisible(true)
        leave_time = self:formatTimeString(_ED.war_decree_time[city_id].family_leave_time)
        Text_decree_time:setString(leave_time)
    end 
    self.time_text = Text_decree_time  
end

function NationalWarDecreeCell:formatTimeString(_time)    --系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%02d", math.floor(math.max(0,tonumber(_time)/3600))) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((math.max(0,tonumber(_time)%3600)/60))) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(math.max(0,tonumber(_time)%60)))
    return timeString
end

function NationalWarDecreeCell:onUpdate(dt)
    local now_time = os.time()
    if self.time_text == nil or self._lasttime == now_time then
        return
    end
    if self._last_time == nil or now_time >= self._last_time + 1 then  
        local order_type = tonumber(self.decree_data.order_type)  
        local leave_time = 0
        local city_id = tonumber(self.decree_data.city)
        if order_type == 1 then
            leave_time = _ED.war_decree_time[city_id].country_leave_time - (now_time- _ED.war_decree_time[city_id].country_start_time)
            if leave_time < 0 then
                _ED.war_decree_time[city_id].country_leave_time = 0
                self:unregisterOnNoteUpdate(self)
                self:setVisible(false)
                fwin:addService({
                    callback = function ( params )
                        if params._from_type == 1 then
                            state_machine.excute("national_war_decree_remove_cell",0,{params})
                        elseif params._from_type == 2 then
                            state_machine.excute("national_war_decree_tow_remove_cell",0,{params})
                        end
                end,
                params = self
                })      
                return
            end
            self.time_text:setString(self:formatTimeString(leave_time))
        elseif order_type == 2 then
            leave_time = _ED.war_decree_time[city_id].family_leave_time - (now_time- _ED.war_decree_time[city_id].family_start_time)
            if leave_time < 0 then
                _ED.war_decree_time[city_id].family_leave_time = 0
                self:unregisterOnNoteUpdate(self)
                self:setVisible(false)
                fwin:addService({
                    callback = function ( params )
                        if params._from_type == 1 then
                            state_machine.excute("national_war_decree_remove_cell",0,{params})
                        elseif params._from_type == 2 then
                            state_machine.excute("national_war_decree_tow_remove_cell",0,{params})
                        end
                end,
                params = self
                })
                return
            end
            self.time_text:setString(self:formatTimeString(leave_time))
        end
        self._lasttime = now_time
    end
end

function NationalWarDecreeCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.campaign.nationalwar.nationalwar_decree_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root)
    self:setContentSize(root:getContentSize())
    table.insert(self.roots, root)

    -- 号令前往
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_decree_go"), nil, 
    {
        terminal_name = "national_war_decree_cell_goto_pos",
        terminal_state = 0, 
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95,
    }, nil, 0)    
    self:onUpdateDraw() 
end

function NationalWarDecreeCell:init(decree_data,from_type)
    self.decree_data = decree_data
    self._from_type = from_type
    self:onInit()
    return self
end

function NationalWarDecreeCell:onExit()

end
