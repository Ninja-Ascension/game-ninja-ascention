-- --------------------------------------------------------------------------------------------------
-- 说明：阵型保存cell
-- -----------------------------------------------------------------------------------------------------
FormationManageEnabledCell = class("FormationManageEnabledCellClass", Window)
FormationManageEnabledCell.__size = nil

local formation_manage_enabled_cell_create_terminal = {
    _name = "formation_manage_enabled_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local cell = FormationManageEnabledCell:new()
        local index = params[1]
        cell:init(index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(formation_manage_enabled_cell_create_terminal)
state_machine.init()

function FormationManageEnabledCell:ctor()
    self.super:ctor()
    self.roots = {}  

    self._text = nil
    self._index = 1   

    local function init_formation_manage_enabled_cell_terminal()
        -- 保存
        local formation_manage_enabled_cell_save_terminal = {
            _name = "formation_manage_enabled_cell_save",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local index = params._datas.cell._index
                local formation_name = params._datas.cell._text:getString()
    			state_machine.excute("formation_defend_save_formation", 0, {index, formation_name})
                state_machine.excute("formation_manage_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 套用
        local formation_manage_enabled_cell_use_terminal = {
            _name = "formation_manage_enabled_cell_use",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local index = params._datas.cell._index
				state_machine.excute("formation_defend_load_formation", 0, index)
                state_machine.excute("formation_manage_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(formation_manage_enabled_cell_save_terminal)       
        state_machine.add(formation_manage_enabled_cell_use_terminal)       
        state_machine.init()
    end
    init_formation_manage_enabled_cell_terminal()           
end

function FormationManageEnabledCell:onUpdateDraw()
    local root = self.roots[1]
    local Button_form_use = ccui.Helper:seekWidgetByName(root,"Button_form_use")
    local Button_form_save = ccui.Helper:seekWidgetByName(root, "Button_form_save")
    local formation_name = cc.UserDefault:getInstance():getStringForKey(getKey("formation_name"..self._index))
    if formation_name == nil or formation_name == "" then
        Button_form_use:setBright(false)
        Button_form_use:setTouchEnabled(false)
        Button_form_save:setTitleText(formation_type_string[19])
        self._text:setString(string.format(formation_type_string[17], self._index))
    else
        Button_form_use:setBright(true)
        Button_form_use:setTouchEnabled(true)
        self._text:setString(formation_name)
        Button_form_save:setTitleText(formation_type_string[20])
    end
end

function FormationManageEnabledCell:setSelected()

end

function FormationManageEnabledCell:onEnterTransitionFinish()

end

function FormationManageEnabledCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.formation.formation_manage_cell_1, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    local size = root:getContentSize()
    
    if FormationManageEnabledCell.__size == nil then
        FormationManageEnabledCell.__size = size
    end

    if root.__edit_box == nil then
        local edit_box = draw:addEditBoxEx(ccui.Helper:seekWidgetByName(root,"TextField_fomation_name"), formation_type_string[42], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_form_save"), 12, cc.KEYBOARD_RETURNTYPE_DONE) 
        root.__edit_box = edit_box
    end
    self._text = ccui.Helper:seekWidgetByName(root,"TextField_fomation_name")

    -- 保存
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_form_save"), nil, 
    {
        terminal_name = "formation_manage_enabled_cell_save", 
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95, 
    },
    nil,1)

    -- 套用
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_form_use"), nil, 
    {
        terminal_name = "formation_manage_enabled_cell_use", 
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95, 
    },
    nil,1)
    
    self:onUpdateDraw()
end

function FormationManageEnabledCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.formation.formation_manage_cell_1, self.roots[1])

end

function FormationManageEnabledCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function FormationManageEnabledCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.formation.formation_manage_cell_1, root)
    root:removeFromParent(false)
    self.roots = {}
end

function FormationManageEnabledCell:clearUIInfo()
    local root = self.roots[1]
    local TextField_fomation_name = ccui.Helper:seekWidgetByName(root,"TextField_fomation_name")
    local Button_form_use = ccui.Helper:seekWidgetByName(root,"Button_form_use")
    local Button_form_save = ccui.Helper:seekWidgetByName(root, "Button_form_save")

    if TextField_fomation_name ~= nil then
        TextField_fomation_name:setString("")
        Button_form_use:setBright(true)
        Button_form_use:setTouchEnabled(true)
        Button_form_save:setTitleText(formation_type_string[19])
    end

    self._text = nil
end

function FormationManageEnabledCell:init(index) 
    self._index = index

    -- if index ~= nil and index <= 8 then
        self:onInit()
    -- end
    self:setContentSize(FormationManageEnabledCell.__size)
end

