--------------------------------------------------------------------------------------------------------------
--  说明：神兵副本左侧标签
--------------------------------------------------------------------------------------------------------------
GodWeaponryDuplicateLeftCell = class("GodWeaponryDuplicateLeftCellClass", Window)
GodWeaponryDuplicateLeftCell.__size = nil

--创建cell
local god_weaponry_duplicate_left_create_cell_terminal = {
    _name = "god_weaponry_duplicate_left_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local index = params[1]
        local cell = GodWeaponryDuplicateLeftCell:new()
        cell:init(index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(god_weaponry_duplicate_left_create_cell_terminal)
state_machine.init()
    
function GodWeaponryDuplicateLeftCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.index = 0
    self.info = nil

    local function init_god_weaponry_duplicate_left_cell_terminal()
        local god_weaponry_duplicate_left_cell_selected_terminal = {
            _name = "god_weaponry_duplicate_left_cell_selected",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("god_weaponry_duplicate_left_once", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(god_weaponry_duplicate_left_cell_selected_terminal)
        state_machine.init()
    end
    init_god_weaponry_duplicate_left_cell_terminal()
end

function GodWeaponryDuplicateLeftCell:changeSelectedState( isSelected )
    local root = self.roots[1]
    local Button_diff_bg = ccui.Helper:seekWidgetByName(root, "Button_diff_bg")
    if isSelected == true then 
        Button_diff_bg:setHighlighted(true)
    else
        Button_diff_bg:setHighlighted(false)
    end
end

function GodWeaponryDuplicateLeftCell:onUpdateDraw()
    local root = self.roots[1]
    -- 开放等级
    local Text_open_lv = ccui.Helper:seekWidgetByName(root, "Text_open_lv")
    local duplicate_level = self.index + 73
    local open_level = dms.string(dms["pve_scene"], duplicate_level, pve_scene.open_level)
    Text_open_lv:setString(string.format(red_alert_all_str[107],open_level))
    -- 难度icon
    local Panel_diff_icon = ccui.Helper:seekWidgetByName(root, "Panel_diff_icon")
    local Button_diff_bg = ccui.Helper:seekWidgetByName(root, "Button_diff_bg")
    Panel_diff_icon:removeBackGroundImage()
    if tonumber(open_level) <= tonumber(_ED.user_info.user_grade) then
        Panel_diff_icon:setBackGroundImage("images/ui/play/gemduplicate/gem_duplicate_".. self.index ..".png")
        Button_diff_bg:setTouchEnabled(true)
        Text_open_lv:setString("")
    else
        Panel_diff_icon:setBackGroundImage("images/ui/play/gemduplicate/gem_duplicate_g_".. self.index ..".png")
        Button_diff_bg:setTouchEnabled(false)
        Button_diff_bg:setHighlighted(false)
    end
    -- 难度名字
    local Panel_diff_icon_name = ccui.Helper:seekWidgetByName(root, "Panel_diff_icon_name")
    Panel_diff_icon_name:removeBackGroundImage()
    Panel_diff_icon_name:setBackGroundImage("images/ui/play/gemduplicate/difficulty_".. self.index ..".png")
end

function GodWeaponryDuplicateLeftCell:onInit()
    local csbStrategyLeft = csb.createNode(config_csb.cells.god_weaponry.god_weaponry_duplicate_left_cell)
    self:addChild(csbStrategyLeft)
    local root = csbStrategyLeft:getChildByName("root")
    table.insert(self.roots, root)

    self:setContentSize(root:getContentSize())

    local Button_diff_bg = ccui.Helper:seekWidgetByName(root, "Button_diff_bg")
    Button_diff_bg:setSwallowTouches(false)

    local function panelTouchListener( sender, eventType )
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if math.abs(__spoint.x - __epoint.x) <= 3 and math.abs(__spoint.y - __epoint.y) <= 3 then
                state_machine.excute("god_weaponry_duplicate_left_cell_selected", 0, self.index)
            end
        end
    end
    Button_diff_bg:addTouchEventListener(panelTouchListener)

    self:onUpdateDraw()
end

function GodWeaponryDuplicateLeftCell:init(index)
    self.index = index
    self:onInit()
end
