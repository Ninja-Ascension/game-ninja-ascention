-- --------------------------------------------------------------------------------------------------
-- 说明：阵型保存cell
-- -----------------------------------------------------------------------------------------------------
FormationManageDisabledCell = class("FormationManageDisabledCellClass", Window)
FormationManageDisabledCell.__size = nil

local formation_manage_disabled_cell_create_terminal = {
    _name = "formation_manage_disabled_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local cell = FormationManageDisabledCell:new()
        local index = params[1]
        local vip_level = params[2]
        cell:init(index, vip_level)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(formation_manage_disabled_cell_create_terminal)
state_machine.init()

function FormationManageDisabledCell:ctor()
    self.super:ctor()
    self.roots = {}  

    self._text = nil
    self._index = 1   

    local function init_formation_manage_disabled_cell_terminal()
        -- 充值
        local formation_manage_disabled_cell_recharge_terminal = {
            _name = "formation_manage_disabled_cell_recharge",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("recharge_dialog_window_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
    
        state_machine.add(formation_manage_disabled_cell_recharge_terminal)       
        state_machine.init()
    end
    init_formation_manage_disabled_cell_terminal()           
end

function FormationManageDisabledCell:onUpdateDraw()
    local root = self.roots[1]
    local TextField_fomation_name_1 = ccui.Helper:seekWidgetByName(root,"TextField_fomation_name_1")
    TextField_fomation_name_1:setString(string.format(formation_type_string[17], self._index))

    local Text_form_vip_open = ccui.Helper:seekWidgetByName(root,"Text_form_vip_open")
    Text_form_vip_open:setString(string.format(formation_type_string[18], self._vip_level))
end

function FormationManageDisabledCell:setSelected()

end

function FormationManageDisabledCell:onEnterTransitionFinish()

end

function FormationManageDisabledCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.formation.formation_manage_cell_2, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    local size = root:getContentSize()
    
    if FormationManageDisabledCell.__size == nil then
        FormationManageDisabledCell.__size = size
    end

    -- 充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_form_recharge"), nil, 
    {
        terminal_name = "formation_manage_disabled_cell_recharge", 
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95, 
    },
    nil,1)
    
    self:onUpdateDraw()
end

function FormationManageDisabledCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.formation.formation_manage_cell_2, self.roots[1])

end

function FormationManageDisabledCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function FormationManageDisabledCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.formation.formation_manage_cell_2, root)
    root:removeFromParent(false)
    self.roots = {}
end

function FormationManageDisabledCell:clearUIInfo()
    local root = self.roots[1]
    local TextField_fomation_name_1 = ccui.Helper:seekWidgetByName(root,"TextField_fomation_name_1")
    local Text_form_vip_open = ccui.Helper:seekWidgetByName(root,"Text_form_vip_open")
    if TextField_fomation_name_1 ~= nil then
        TextField_fomation_name_1:setString("")
        Text_form_vip_open:setString("")
    end
end

function FormationManageDisabledCell:init(index, vip_level) 
    self._index = index
    self._vip_level = vip_level

    -- if index ~= nil and index <= 8 then
        self:onInit()
    -- end
    self:setContentSize(FormationManageDisabledCell.__size)
end

