-----------------------------
-- 单个合金
-----------------------------
AlloyMatrixFormationCell = class("AlloyMatrixFormationCellClass", Window)

function AlloyMatrixFormationCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.ishow = false

    app.load("client.l_digital.cultivate.matrix.AlloyMatrixStrengthenOne")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixFormation")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixFormationChange")
    
    local function init_alloy_matrix_formation_cell_terminal()
        local alloy_matrix_show_strengthen_one_terminal = {
            _name = "alloy_matrix_show_strengthen_one",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas._cell
                local parent = params._datas._parent
                state_machine.excute("alloy_matrix_strengthen_one_show", 0, cell)
                state_machine.excute("alloy_matrix_choose_cell", 0, {cell, parent})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local alloy_matrix_show_matrix_add_terminal = {
            _name = "alloy_matrix_show_matrix_add",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas._cell
                if cell.index and cell.ship then
                    state_machine.excute("alloy_matrix_formation_change_open", 0, {cell.index, cell.ship})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        

        state_machine.add(alloy_matrix_show_strengthen_one_terminal)
        state_machine.add(alloy_matrix_show_matrix_add_terminal)
        state_machine.init()
    end
    init_alloy_matrix_formation_cell_terminal()
end

function AlloyMatrixFormationCell:onUpdateDraw()
	local root = self.roots[1]
    local Panel_alloy_matrix_icon = ccui.Helper:seekWidgetByName(root,"Panel_alloy_matrix_icon")
    local Image_alloy_matrix_add = ccui.Helper:seekWidgetByName(root,"Image_alloy_matrix_add")
    local Panel_alloy_matrix_attr_text = ccui.Helper:seekWidgetByName(root,"Panel_alloy_matrix_attr_text")
    local Text_alloy_matrix_add_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_matrix_add_n")
    local Image_alloy_matrix_add_bg = ccui.Helper:seekWidgetByName(root,"Image_alloy_matrix_add_bg")

    Panel_alloy_matrix_icon:removeBackGroundImage()
    Panel_alloy_matrix_attr_text:removeBackGroundImage()
    Image_alloy_matrix_add_bg:setVisible(false)
    Text_alloy_matrix_add_n:setString("")
    
    if self.matrix_id and _ED.user_alloy_matrix[tonumber(self.matrix_id)] then
        local metal = _ED.user_alloy_matrix[tonumber(self.matrix_id)]
        local level = metal.metalLevel
        local pic_id = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.pic_id)
        local matrix_add_type = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.add_type)
        local quality = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.quality)
        Panel_alloy_matrix_attr_text:setBackGroundImage(string.format("images/ui/text/smhj/attr_text_%d.png", matrix_add_type))
        Panel_alloy_matrix_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", pic_id))

        if tonumber(level) > 1 then
            Text_alloy_matrix_add_n:setString("+" .. level)
        end
        Panel_alloy_matrix_icon:setVisible(true)
        Image_alloy_matrix_add:setVisible(false)
    else
        Panel_alloy_matrix_icon:setVisible(false)
        Image_alloy_matrix_add:setVisible(true)

    end
end

function AlloyMatrixFormationCell:setSelected(isSelected)
    local root = self.roots[1]
    local hook = ccui.Helper:seekWidgetByName(root,"Image_alloy_matrix_icon_hook")
    hook:setVisible(isSelected)
    self.ishow = isSelected
end

function AlloyMatrixFormationCell:onUpdate( dt )
    
end

function AlloyMatrixFormationCell:init(params)
	self.matrix_id = params[1]
    self.isTouched = params[2]
    self.is_strengh = params[3]
    self.index = params[4]
    self.ship = params[5]
    self.parent = params[6]
	self:onInit()
    return self
end

function AlloyMatrixFormationCell:onInit()
    local csbItem = csb.createNode("cultivate/alloy_matrix_famation_icon_cell.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
        table.insert(self.roots, root)

    if self.isTouched and self.is_strengh == 1 then
        ccui.Helper:seekWidgetByName(root,"Panel_alloy_matrix_icon"):setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root,"Image_alloy_matrix_add"):setTouchEnabled(true)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_alloy_matrix_icon"), nil, 
        {
            terminal_name = "alloy_matrix_show_strengthen_one", 
            terminal_state = 0,
            _cell = self,
            _parent = self.parent,
            touch_black = true,
        }, nil, 3)

        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_alloy_matrix_add"), nil, 
        {
            terminal_name = "alloy_matrix_show_matrix_add", 
            terminal_state = 0,
            _cell = self,
            touch_black = true,
        }, nil, 3)
    else
        ccui.Helper:seekWidgetByName(root,"Panel_alloy_matrix_icon"):setTouchEnabled(false)
        ccui.Helper:seekWidgetByName(root,"Image_alloy_matrix_add"):setTouchEnabled(false)
    end
    self:onUpdateDraw()
end

function AlloyMatrixFormationCell:onEnterTransitionFinish()
end

function AlloyMatrixFormationCell:createCell()
	local cell = AlloyMatrixFormationCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function AlloyMatrixFormationCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_alloy_matrix_icon = ccui.Helper:seekWidgetByName(root, "Panel_alloy_matrix_icon")
    local Panel_alloy_matrix_attr_text = ccui.Helper:seekWidgetByName(root, "Panel_alloy_matrix_attr_text")
    local Text_alloy_matrix_add_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_matrix_add_n")
    local Image_alloy_matrix_add = ccui.Helper:seekWidgetByName(root, "Image_alloy_matrix_add")
    
    if Panel_alloy_matrix_icon ~= nil then
        Panel_alloy_matrix_icon:removeBackGroundImage()
    end

    if Panel_alloy_matrix_attr_text ~= nil then
        Panel_alloy_matrix_attr_text:removeBackGroundImage()
    end

    if Text_alloy_matrix_add_n then
        Text_alloy_matrix_add_n:setString("")
    end

    if Image_alloy_matrix_add then
        Image_alloy_matrix_add:setVisible(false)
    end
end

function AlloyMatrixFormationCell:onExit()
    self:clearUIInfo()
    state_machine.remove("alloy_matrix_update_choose_state")
end
