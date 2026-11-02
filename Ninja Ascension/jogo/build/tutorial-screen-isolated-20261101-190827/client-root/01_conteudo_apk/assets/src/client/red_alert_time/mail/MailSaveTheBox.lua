-----------------------------
--邮件保存箱
-----------------------------
MailSaveTheBox = class("MailSaveTheBoxClass", Window)

local mail_save_the_box_window_open_terminal = {
    _name = "mail_save_the_box_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		-- if true then
			-- TipDlg.drawTextDailog("服务器的邮件拷贝有问题")
			-- return
		-- end
		
		-- if _ED.city_resource_battle_save_report == nil or #_ED.city_resource_battle_save_report <= 1 then
  --           state_machine.lock("mail_save_the_box_window_open", 0, 0)
		-- 	local function responseCallback(response)
  --               state_machine.unlock("mail_save_the_box_window_open", 0, 0)
		-- 		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		-- 			-- if response.node ~= nil and response.node.roots ~= nil then
		-- 				local panel = MailSaveTheBox:new():init(params)
		-- 				fwin:open(panel)
		-- 			-- end	
		-- 		end
		-- 	end
		-- 	NetworkManager:register(protocol_command.battlefield_report_save_get.code, nil, nil, nil, self, responseCallback, false, nil)
		-- else
			local panel = MailSaveTheBox:new():init(params)
			fwin:open(panel)
		-- end
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(mail_save_the_box_window_open_terminal)
state_machine.init()

function MailSaveTheBox:ctor()
    self.super:ctor()
    self.roots = {}
    
    self._current_page = 0

	self.listview = nil
	self.listview_poy = nil
    self.listview_height = 0
    self._Image_player_build_arrow_down = nil
    self._Image_player_build_arrow_up = nil

    self._list_update = 10
    self._max_list = 0

    local function init_mail_save_the_box_terminal()
		--显示界面
		local mail_save_the_box_show_terminal = {
            _name = "mail_save_the_box_show",
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
		local mail_save_the_box_hide_terminal = {
            _name = "mail_save_the_box_hide",
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

        local mail_save_the_box_update_draw_terminal = {
            _name = "mail_save_the_box_update_draw",
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

        local mail_save_the_box_load_lists_terminal = {
            _name = "mail_save_the_box_load_lists",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                self._list_update = self._list_update + 10
                if self._list_update >= self._max_list then
                    self._list_update = self._max_list
                end    
                instance:onUpdateDraw(6)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(mail_save_the_box_show_terminal)	
		state_machine.add(mail_save_the_box_hide_terminal)
        state_machine.add(mail_save_the_box_change_page_terminal)
        state_machine.add(mail_save_the_box_update_draw_terminal)
        state_machine.add(mail_save_the_box_load_lists_terminal)
        state_machine.init()
    end
    init_mail_save_the_box_terminal()
end

function MailSaveTheBox:onHide()
    self:setVisible(false)
end

function MailSaveTheBox:onShow()
    self:setVisible(true)
end

function MailSaveTheBox:onUpdateDraw(index)
    local root = self.roots[1]
    local max_data = zstring.split(dms.string(dms["mail_config"], 2 , mail_config.param),",")
    self._max_list = tonumber(max_data[6])
    local ListView_mail = ccui.Helper:seekWidgetByName(root,"ListView_mail")
    local Text_mail_not = ccui.Helper:seekWidgetByName(root,"Text_mail_not")
    Text_mail_not:setVisible(false)
    if index~= nil then
    else
        ListView_mail:jumpToTop()
    end
    ListView_mail:removeAllItems()

	if _ED.city_resource_battle_save_report~= nil then
		if #_ED.city_resource_battle_save_report > 0 then
			table.sort(_ED.city_resource_battle_save_report, function(c1, c2)
				if c1 ~= nil and c2~= nil then
					if zstring.tonumber(c1.time) > zstring.tonumber(c2.time) then
						return true
					end
				end
				return false
			end)
        else
            Text_mail_not:setVisible(true)
        end
		for i, v in pairs(_ED.city_resource_battle_save_report) do
			if i <= self._list_update then
				local cells = state_machine.excute("mail_create_cell", 0, {i,v,10}) 
				ListView_mail:addChild(cells)
			end
            if i == self._list_update+1 and i < self._max_list+1 then
                local cells = state_machine.excute("mail_create_load_cell", 0, {i,6}) 
                ListView_mail:addChild(cells)
            end
		end
		ListView_mail:requestRefreshView()
	else
        Text_mail_not:setVisible(true)
    end
	
    -- for i=1,10 do
    --    local cell = state_machine.excute("mail_other_create_cell",0, {i, nil, self._current_page})
    --    ListView_mail:addChild(cell)
    -- end

    ListView_mail:requestRefreshView()
    self.listview = ListView_mail
    self.listview_poy = ListView_mail:getInnerContainer():getPositionY()
    self.listview_height = ListView_mail:getInnerContainer():getPositionY()
end

function MailSaveTheBox:onUpdate(dt)
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

function MailSaveTheBox:onEnterTransitionFinish()

end

function MailSaveTheBox:onInit( )
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
    if _ED.city_resource_battle_save_report == nil or #_ED.city_resource_battle_save_report <= 1 then
        -- state_machine.lock("mail_save_the_box_window_open", 0, 0)
        local function responseCallback(response)
            -- state_machine.unlock("mail_save_the_box_window_open", 0, 0)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil then
                    response.node:onUpdateDraw()
                end  
            end
        end
        NetworkManager:register(protocol_command.battlefield_report_save_get.code, nil, nil, nil, self, responseCallback, false, nil)
    else
        self:onUpdateDraw()
    end
    -- self:onUpdateDraw()
end

function MailSaveTheBox:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function MailSaveTheBox:onExit()
    state_machine.remove("mail_save_the_box_show")    
    state_machine.remove("mail_save_the_box_hide")
    state_machine.remove("mail_save_the_box_change_page")
    state_machine.remove("mail_save_the_box_update_draw")
end
