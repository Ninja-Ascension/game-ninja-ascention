-----------------------------
--邮件报告窗口
-----------------------------
MailOtherList = class("MailOtherListClass", Window)

local mail_other_list_window_open_terminal = {
    _name = "mail_other_list_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = MailOtherList:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(mail_other_list_window_open_terminal)
state_machine.init()

function MailOtherList:ctor()
    self.super:ctor()
    self.roots = {}
    
    self._current_page = 0

	self.listview = nil
	self.listview_poy = nil
    self.listview_height = 0
    self._Image_player_build_arrow_down = nil
    self._Image_player_build_arrow_up = nil

    local function init_mail_other_list_terminal()
		--显示界面
		local mail_other_list_show_terminal = {
            _name = "mail_other_list_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--隐藏界面
		local mail_other_list_hide_terminal = {
            _name = "mail_other_list_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

        local mail_other_list_change_page_terminal = {
            _name = "mail_other_list_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params ~= nil and instance._current_page ~= params then
                    instance._current_page = params
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        local mail_other_list_update_draw_terminal = {
            _name = "mail_other_list_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

		state_machine.add(mail_other_list_show_terminal)	
		state_machine.add(mail_other_list_hide_terminal)
        state_machine.add(mail_other_list_change_page_terminal)
        state_machine.add(mail_other_list_update_draw_terminal)
        state_machine.init()
    end
    init_mail_other_list_terminal()
end

function MailOtherList:onHide()
    self:setVisible(false)
end

function MailOtherList:onShow()
    self:setVisible(true)
end

function MailOtherList:onUpdateDraw()
    local root = self.roots[1]
    local ListView_mail = ccui.Helper:seekWidgetByName(root,"ListView_mail")
    ListView_mail:jumpToTop()
    ListView_mail:removeAllItems()

    -- for i=1,10 do
    --    local cell = state_machine.excute("mail_other_create_cell",0, {i, nil, self._current_page})
    --    ListView_mail:addChild(cell)
    -- end

    ListView_mail:requestRefreshView()
    self.listview = ListView_mail
    self.listview_poy = ListView_mail:getInnerContainer():getPositionY()
    self.listview_height = ListView_mail:getInnerContainer():getPositionY()
end

function MailOtherList:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_mail_arrow_down:setVisible(true)
        else
            self._Image_mail_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_mail_arrow_up:setVisible(true)
        else
            self._Image_mail_arrow_up:setVisible(false)
        end
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function MailOtherList:onEnterTransitionFinish()

end

function MailOtherList:onInit( )
    local csbItem = csb.createNode(config_csb.mail.mail_box_listview_tab)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    self._Image_mail_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_mail_arrow_down")
    self._Image_mail_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_mail_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_mail_arrow_down:stopAllActions()
    self._Image_mail_arrow_up:stopAllActions()
    playActions(self._Image_mail_arrow_down)
    playActions(self._Image_mail_arrow_up)
    self._Image_mail_arrow_down:setVisible(false)
    self._Image_mail_arrow_up:setVisible(false)
end

function MailOtherList:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function MailOtherList:onExit()
    state_machine.remove("mail_other_list_show")    
    state_machine.remove("mail_other_list_hide")
    state_machine.remove("mail_other_list_change_page")
    state_machine.remove("mail_other_list_update_draw")
end
