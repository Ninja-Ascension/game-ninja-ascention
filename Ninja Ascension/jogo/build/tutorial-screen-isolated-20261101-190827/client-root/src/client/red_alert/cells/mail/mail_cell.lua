--------------------------------------------------------------------------------------------------------------
--  邮件cell
--------------------------------------------------------------------------------------------------------------
MailCell = class("MailCellClass", Window)
MailCell.__size = nil
--创建cell
local mail_create_cell_terminal = {
    _name = "mail_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = MailCell:new()
        local mail_data = params[1]
        local index = params[2]
        cell:init(mail_data,index)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(mail_create_cell_terminal)
state_machine.init()

function MailCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.selected = false
    self.mail_data = nil
    app.load("client.red_alert.recruit.HeroRecruit")
    
	 -- Initialize mail_cell state machine.
    local function init_mail_cell_terminal()
		
        -- 点击响应
        local mail_cell_click_terminal = {
            _name = "mail_cell_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                state_machine.excute("mail_all_un_select",0,"")
                state_machine.excute("mail_draw_dec",0,cell)
                if cell == nil then
                    return
                end
                cell.selected = true
                cell:SetSelected()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		state_machine.add(mail_cell_click_terminal)
        state_machine.init()
    end
    
    -- call func mail_cell create state machine.
    init_mail_cell_terminal()

end

function MailCell:SetSelected()
    local root = self.roots[1]
    local Image_mail_cell_light = ccui.Helper:seekWidgetByName(root,"Image_mail_cell_light")
    if Image_mail_cell_light == nil then
        return
    end
    Image_mail_cell_light:setVisible(self.selected)
end

function MailCell:updateDraw()
    local root = self.roots[1]
    local name = email_reward_type_dec[self.mail_data.mail_channel_type]
    local Text_mail_cell_name = ccui.Helper:seekWidgetByName(root,"Text_mail_cell_name") -- 名字
    local Panel_mail_icon = ccui.Helper:seekWidgetByName(root,"Panel_mail_icon") -- 图片
    local Text_mail_cell_describe = ccui.Helper:seekWidgetByName(root,"Text_mail_cell_describe") -- 描述
    
    Panel_mail_icon:setBackGroundImage("images/ui/mile_icon/mile_icon_"..self.mail_data.mail_channel_type..".png")
    Text_mail_cell_name:setString(name)
    Text_mail_cell_describe:setString(self.mail_data.mail_date_time)
end

function MailCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.mail.mail_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    table.insert(self.roots, root) 

    if MailCell.__size == nil then
        MailCell.__size = root:getContentSize()
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_mail_cell_bg"), nil, 
    {
        terminal_name = "mail_cell_click", 
        terminal_state = 0, 
        cell = self, 
    }, nil, 0)
	self:updateDraw()

end

function MailCell:onEnterTransitionFinish()

end

function MailCell:init(mail_data,index)
    self.mail_data = mail_data
    if index ~= nil and index < 9 then
        self:onInit()
    end
    self:setContentSize(MailCell.__size)
    return self
end

function MailCell:onExit()

end

function MailCell:onExit()
    cacher.freeRef(config_csb.cells.mail.mail_cell, self.roots[1])

end

function MailCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function MailCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(config_csb.cells.mail.mail_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end