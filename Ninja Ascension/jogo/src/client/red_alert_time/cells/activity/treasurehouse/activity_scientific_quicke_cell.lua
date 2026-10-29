----------------------------------------------------------------------------------------------------
-- 说明：活力驱动cell
-------------------------------------------------------------------------------------------------------
ActivityScientificQuickeCell = class("ActivityScientificQuickeCellClass", Window)
ActivityScientificQuickeCell.__size = nil

local activity_scientific_quicke_create_cell_terminal = {
    _name = "activity_scientific_quicke_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ActivityScientificQuickeCell:new():init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 1)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_scientific_quicke_create_cell_terminal)
state_machine.init()

function ActivityScientificQuickeCell:ctor()
    self.super:ctor()
    self.roots = {} 

    self._index = 0
    self._info = nil
    self._tick_time = 0
    self._text_time = nil

    local function init_activity_scientific_quicke_cell_terminal()
        
        local activity_scientific_quicke_cell_goto_terminal = {
            _name = "activity_scientific_quicke_cell_goto",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell 
                local changeType = cell._activity_info.achieve_other_info
                if tonumber(changeType) ~= -1 then
                    state_machine.excute("short_cut_go_to_other_window",0,{tonumber(changeType)})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(activity_scientific_quicke_cell_goto_terminal)        
        state_machine.init()
    end
    init_activity_scientific_quicke_cell_terminal()
end

function ActivityScientificQuickeCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_scientific_quicke_icon = ccui.Helper:seekWidgetByName(root,"Panel_scientific_quicke_icon")
    local Text_scientific_quicke_name = ccui.Helper:seekWidgetByName(root,"Text_scientific_quicke_name")
    Panel_scientific_quicke_icon:removeAllChildren(true)
    local prop_info = zstring.split(self._activity_info.achieve_reward, ",")
    local prop_data = {}
    prop_data.prop_item = tonumber(prop_info[1])
    prop_data.prop_type = tonumber(prop_info[2])
    prop_data.item_value = tonumber(prop_info[3])

    local cell = createPropIconCell(prop_data, false, false, false)
    Panel_scientific_quicke_icon:addChild(cell)

    Text_scientific_quicke_name:setString(self._activity_info.achieve_mould_name)

    self:onUpdateOpenState()
end

function ActivityScientificQuickeCell:onUpdateOpenState()
    local root = self.roots[1]
    local Text_scientific_quicke_state = ccui.Helper:seekWidgetByName(root,"Text_scientific_quicke_state")
    local Text_scientific_quicke_dis_t = ccui.Helper:seekWidgetByName(root,"Text_scientific_quicke_dis_t")
    local Text_scientific_quicke_dis_n = ccui.Helper:seekWidgetByName(root,"Text_scientific_quicke_dis_n")

    local other_info = zstring.split(_ED.activity_info[""..self._activity_type].activity_add_state, "!")
    local time_info = zstring.split(other_info[1], ",")
    local start_time = tonumber(time_info[1]/1000)

    local open_info = zstring.split(other_info[2], "|")
    open_info = zstring.split(open_info[self._index], ",")

    local current_time = os.time() + _ED.time_add_or_sub
    self._tick_time = (tonumber(open_info[1])) * 3600-(current_time - start_time)      
    if self._tick_time > 0 then
        Text_scientific_quicke_state:setString(activity_str_tip[156])
        Text_scientific_quicke_state:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        Text_scientific_quicke_dis_t:setString(activity_str_tip[158])
        Text_scientific_quicke_dis_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        self._text_time = Text_scientific_quicke_dis_n
    else
        Text_scientific_quicke_state:setString(activity_str_tip[155])
        Text_scientific_quicke_state:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
        Text_scientific_quicke_dis_t:setString(activity_str_tip[157])
        Text_scientific_quicke_dis_n:setString(string.format(activity_str_tip[159], open_info[2], open_info[3]))
        Text_scientific_quicke_dis_n:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
    end
end

function ActivityScientificQuickeCell:onUpdate(dt)
    if self._text_time ~= nil then
        self._tick_time = self._tick_time - dt
        self._text_time:setString(self:getRedAlertTimeActivityFormat(self._tick_time))
        if self._tick_time < 0 then
            state_machine.excute("red_alert_time_scientific_quicke_updata", 0, "")
        end
    end
end

function ActivityScientificQuickeCell:getRedAlertTimeActivityFormat(_time)
    local timeString = ""
    local now_time = math.max(zstring.tonumber(_time),0)
    now_time = math.floor(now_time)
    local day = math.floor(now_time/86400)
    if day > 0 then
        now_time = math.floor(now_time%86400)
    end
    local hour = string.format("%02d", math.floor(now_time/3600))
    local minute = string.format("%02d", math.floor((now_time%3600)/60))
    local second = string.format("%02d", math.floor(now_time%60))
    if day > 0 then
        timeString = timeString .. day ..activity_str_tip[101]
        return timeString
    else
        timeString = timeString .. hour ..":"
        timeString = timeString .. minute ..":"
        timeString = timeString .. second
        return timeString
    end
end

function ActivityScientificQuickeCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.scientific_quicke_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if ActivityScientificQuickeCell.__size == nil then
        ActivityScientificQuickeCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_scientific_quicke_go"), nil, 
    {
        terminal_name = "activity_scientific_quicke_cell_goto", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        cell = self,
    }, nil, 1)

    self:onUpdateDraw()
end

function ActivityScientificQuickeCell:init(params)
    self._index = params[1]
    self._activity_info = params[2]
    self._activity_type = params[3]
    self:onInit()
    self:setContentSize(ActivityScientificQuickeCell.__size)
    return self
end

function ActivityScientificQuickeCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
    self:registerOnNoteUpdate(self, 1)
end

function ActivityScientificQuickeCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.scientific_quicke_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function ActivityScientificQuickeCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_scientific_quicke_icon = ccui.Helper:seekWidgetByName(root,"Panel_scientific_quicke_icon")
    local Text_scientific_quicke_name = ccui.Helper:seekWidgetByName(root,"Text_scientific_quicke_name")
    local Text_scientific_quicke_state = ccui.Helper:seekWidgetByName(root,"Text_scientific_quicke_state")
    local Text_scientific_quicke_dis_t = ccui.Helper:seekWidgetByName(root,"Text_scientific_quicke_dis_t")
    local Text_scientific_quicke_dis_n = ccui.Helper:seekWidgetByName(root,"Text_scientific_quicke_dis_n")
    if Panel_scientific_quicke_icon ~= nil then
        Panel_scientific_quicke_icon:removeAllChildren(true)
        Text_scientific_quicke_name:setString("")
        Text_scientific_quicke_state:setString("")
        Text_scientific_quicke_dis_t:setString("")
        Text_scientific_quicke_dis_n:setString("")
    end
    self._text_time = nil
    self:unregisterOnNoteUpdate(self)
end

function ActivityScientificQuickeCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.scientific_quicke_cell, root)
end