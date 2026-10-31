--------------------------------------------------------------------------------------------------------------
--  邮件加载cell
--------------------------------------------------------------------------------------------------------------
MailLoadCell = class("MailLoadCellClass", Window)
MailLoadCell.__size = nil
--创建cell
local mail_create_load_cell_terminal = {
    _name = "mail_create_load_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = MailLoadCell:new()
        local index = params[1]
        local m_type = params[2]
        cell:init(index,m_type)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(mail_create_load_cell_terminal)
state_machine.init()

function MailLoadCell:ctor()
	self.super:ctor()
	self.roots = {}

    self._index = 0
    self._mail_data = nil
    self._ntype = 0
    
    local function init_mail_load_cell_terminal()
	   --
        local mail_load_cell_update_list_terminal = {
            _name = "mail_load_cell_update_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cells
                if cell._ntype == 1 then
                    state_machine.excute("mail_presentation_attack_load_lists", 0, 0)
                elseif cell._ntype == 2 then
                    state_machine.excute("mail_presentation_defensive_load_lists", 0, 0)
                elseif cell._ntype == 3 then
                    state_machine.excute("mail_presentation_investigation_load_lists", 0, 0)
                elseif cell._ntype == 4 then
                    state_machine.excute("mail_in_box_load_lists", 0, 0)
                elseif cell._ntype == 5 then
                    state_machine.excute("mail_out_box_load_lists", 0, 0)
                elseif cell._ntype == 6 then 
                    state_machine.excute("mail_save_the_box_load_lists", 0, 0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(mail_load_cell_update_list_terminal) 
        state_machine.init()
    end
    
    init_mail_load_cell_terminal()
end

function MailLoadCell:setSelected()
    local root = self.roots[1]

end

function MailLoadCell:updateDraw()
    local root = self.roots[1]
	
	
end

function MailLoadCell:onInit()
    local root = cacher.createUIRef(string.format(config_csb.cells.mail.mail_cell, 3), "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    table.insert(self.roots, root) 

    if MailLoadCell.__size == nil then
        MailLoadCell.__size = root:getContentSize()
    end
	
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_mail_bar_list_0"), nil, 
    {
        terminal_name = "mail_load_cell_update_list", 
        terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95,
        cells = self,
    }, nil, 1)

	-- self:updateDraw()
end

function MailLoadCell:onEnterTransitionFinish()

end

function MailLoadCell:init(index,m_type)
    self._index = index
    self._ntype = tonumber(m_type)
    self:onInit()
    self:setContentSize(MailLoadCell.__size)
    return self
end

function MailLoadCell:clearUIInfo( ... )
    local root = self.roots[1]

end

function MailLoadCell:onExit()
	self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.cells.mail.mail_cell, 3), self.roots[1])
end

function MailLoadCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function MailLoadCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.cells.mail.mail_cell, 3), root)
    root:removeFromParent(false)
    self.roots = {}
end