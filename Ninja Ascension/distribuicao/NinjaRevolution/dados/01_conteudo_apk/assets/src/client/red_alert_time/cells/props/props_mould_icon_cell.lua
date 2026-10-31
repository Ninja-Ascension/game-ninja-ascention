--------------------------------------------------------------------------------------------------------------
--  说明：显示带底框图标
--------------------------------------------------------------------------------------------------------------
PropsMouldIconCell = class("PropsMouldIconCellClass", Window)

--创建cell
local props_mould_icon_cell_create_terminal = {
    _name = "props_mould_icon_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = PropsMouldIconCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(props_mould_icon_cell_create_terminal)
state_machine.init()

function PropsMouldIconCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._prop_pic = 0
    self._quality = 0

    local function init_props_mould_icon_cell_terminal()

    end 
    init_props_mould_icon_cell_terminal()
end

function PropsMouldIconCell:updateDraw()
    local root = self.roots[1]
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")
    local Panel_quality_icon = ccui.Helper:seekWidgetByName(root, "Panel_quality_icon")

    Panel_props_icon:removeBackGroundImage()
    Panel_quality_icon:removeBackGroundImage()

    Panel_props_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, self._prop_pic))
    Panel_quality_icon:setBackGroundImage(string.format(config_res.images.ui.icon.icon, self._quality))
end

function PropsMouldIconCell:onInit()
    local root = cacher.createUIRef(string.format(config_csb.cells.props.props_res_icon, 1), "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if PropsMouldIconCell.__size == nil then
        PropsMouldIconCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function PropsMouldIconCell:onEnterTransitionFinish()

end

function PropsMouldIconCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function PropsMouldIconCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.cells.props.props_res_icon, 1), root)
    root:removeFromParent(false)
    self.roots = {}
end

function PropsMouldIconCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")
    local Panel_quality_icon = ccui.Helper:seekWidgetByName(root, "Panel_quality_icon")
    if Panel_game_teaching_icon ~= nil then
        Panel_props_icon:removeBackGroundImage()
        Panel_quality_icon:removeBackGroundImage()
    end
end

function PropsMouldIconCell:init(params)
    self._prop_pic = params[1]
    self._quality = params[2]
    self:onInit()
    self:setContentSize(PropsMouldIconCell.__size)
    
    return self
end

function PropsMouldIconCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.cells.props.props_res_icon, 1), self.roots[1])
end