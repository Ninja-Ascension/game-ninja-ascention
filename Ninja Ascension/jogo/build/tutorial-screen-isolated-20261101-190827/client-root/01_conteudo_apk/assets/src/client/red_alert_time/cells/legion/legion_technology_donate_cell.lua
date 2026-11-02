--------------------------------------------------------------------------------------------------------------
--  科技捐献cell
--------------------------------------------------------------------------------------------------------------
LegionTechnologyDonateCell = class("LegionTechnologyDonateCellClass", Window)
LegionTechnologyDonateCellSize = LegionTechnologyDonateCellSize or nil

--创建cell
local legion_technology_donate_cell_create_terminal = {
    _name = "legion_technology_donate_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionTechnologyDonateCell:new()
        local index = params[1]
        local science_id = params[2]
        cell:init(index, science_id)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_technology_donate_cell_create_terminal)
state_machine.init()

function LegionTechnologyDonateCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._science_id = 0

    local function init_legion_technology_donate_cell_terminal()
        local legion_technology_donate_cell_look_info_terminal = {
            _name = "legion_technology_donate_cell_look_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell

                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(legion_technology_donate_cell_look_info_terminal)
        state_machine.init()
    end
    
    init_legion_technology_donate_cell_terminal()
end


function LegionTechnologyDonateCell:updateDraw()
    local root = self.roots[1]

    local Panel_technology_icon = ccui.Helper:seekWidgetByName(root, "Panel_technology_icon")
    local Text_technology_name = ccui.Helper:seekWidgetByName(root, "Text_technology_name")
    local Text_technology_lv = ccui.Helper:seekWidgetByName(root, "Text_technology_lv")
    local LoadingBar_technology = ccui.Helper:seekWidgetByName(root, "LoadingBar_technology")
    local Text_technology_ing = ccui.Helper:seekWidgetByName(root, "Text_technology_ing")
    Panel_technology_icon:removeAllChildren(true)

    local science_info = _ED.union_science_info[""..self._science_id]
    local cell = state_machine.excute("props_icon_create_cell", 0, {4, 3, self._science_id, 11})
    Panel_technology_icon:addChild(cell)

    local name = dms.string(dms["union_science_mould"], self._science_id, union_science_mould.name)
    Text_technology_name:setString(name)
    Text_technology_lv:setString(string.format(red_alert_time_str[33], science_info.level))

    local init_exp_info = zstring.split(dms.string(dms["union_science_mould"], self._science_id, union_science_mould.init_exp), ",")
    local add_exp_info = zstring.split(dms.string(dms["union_science_mould"], self._science_id, union_science_mould.add_exp), ",")
    local need_exp = tonumber(init_exp_info[3]) + tonumber(add_exp_info[3]) * tonumber(science_info.level)
    local percent = tonumber(science_info.current_exp) / need_exp * 100
    Text_technology_ing:setString(science_info.current_exp.."/"..need_exp)
    LoadingBar_technology:setPercent(percent)
end

function LegionTechnologyDonateCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_technology_donate_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    if LegionTechnologyDonateCellSize == nil then
        LegionTechnologyDonateCellSize = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_technology_infor"), nil, 
    {
        terminal_name = "legion_technology_infor_window_open", 
        terminal_state = 0, 
        touch_black = true,
        science_id = self._science_id,
    }, nil, 1)   

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_technology_up"), nil, 
    {
        terminal_name = "legion_technology_up_window_open", 
        terminal_state = 0, 
        touch_black = true,
        science_id = self._science_id,
    }, nil, 1)   

    root:setSwallowTouches(false)
    local function panelTouchListener( sender, eventType )
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        if eventType == ccui.TouchEventType.began then
            pushEffect(formatMusicFile("button", 1))
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if math.abs(__spoint.x - __epoint.x) <= 10 and math.abs(__spoint.y - __epoint.y) <= 10 then
                state_machine.excute("legion_technology_up_window_open", 0, {_datas = {science_id = self._science_id}})
            end
        end
    end
    root:addTouchEventListener(panelTouchListener)

    self:updateDraw()
end

function LegionTechnologyDonateCell:onEnterTransitionFinish()

end

function LegionTechnologyDonateCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionTechnologyDonateCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_technology_donate_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionTechnologyDonateCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_technology_icon = ccui.Helper:seekWidgetByName(root, "Panel_technology_icon")
    local Text_technology_name = ccui.Helper:seekWidgetByName(root, "Text_technology_name")
    local Text_technology_lv = ccui.Helper:seekWidgetByName(root, "Text_technology_lv")
    local LoadingBar_technology = ccui.Helper:seekWidgetByName(root, "LoadingBar_technology")
    local Text_technology_ing = ccui.Helper:seekWidgetByName(root, "Text_technology_ing")
    if Panel_technology_icon ~= nil then
        Panel_technology_icon:removeAllChildren(true)
        LoadingBar_technology:setPercent(0)
        Text_technology_name:setString("")
        Text_technology_lv:setString("")
        Text_technology_ing:setString("")
    end
end

function LegionTechnologyDonateCell:init(index, science_id)
    self._index = index
    self._science_id = science_id

    if index ~= nil and index <= 9 then
        self:onInit()
    end
    self:setContentSize(LegionTechnologyDonateCellSize)
    return self
end

function LegionTechnologyDonateCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_technology_donate_cell, self.roots[1])
end

