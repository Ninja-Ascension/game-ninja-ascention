-----------------------------
--邮件报告窗口(防守)
-----------------------------
MailPresentationDefensive = class("MailPresentationDefensiveClass", Window)

local mail_presentation_defensive_window_open_terminal = {
    _name = "mail_presentation_defensive_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = MailPresentationDefensive:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(mail_presentation_defensive_window_open_terminal)
state_machine.init()

function MailPresentationDefensive:ctor()
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

    self._mail_type = 0

    local function init_mail_presentation_defensive_terminal()
		--显示界面
		local mail_presentation_defensive_show_terminal = {
            _name = "mail_presentation_defensive_show",
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
		local mail_presentation_defensive_hide_terminal = {
            _name = "mail_presentation_defensive_hide",
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

		local mail_presentation_defensive_update_all_terminal = {
            _name = "mail_presentation_defensive_update_all",
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
		
        local mail_presentation_defensive_update_draw_terminal = {
            _name = "mail_presentation_defensive_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateCell()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        local mail_presentation_defensive_load_lists_terminal = {
            _name = "mail_presentation_defensive_load_lists",
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
                instance:onUpdateDraw(1)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(mail_presentation_defensive_show_terminal)	
		state_machine.add(mail_presentation_defensive_hide_terminal)
        state_machine.add(mail_presentation_defensive_update_all_terminal)
        state_machine.add(mail_presentation_defensive_update_draw_terminal)
        state_machine.add(mail_presentation_defensive_load_lists_terminal)
        state_machine.init()
    end
    init_mail_presentation_defensive_terminal()
end

function MailPresentationDefensive:onHide()
    self:setVisible(false)
end

function MailPresentationDefensive:onShow()
    self:setVisible(true)
end

function MailPresentationDefensive:onUpdateCell()
	local root = self.roots[1]
    if self.listview ~= nil then
        local Text_mail_presentation_not = ccui.Helper:seekWidgetByName(root,"Text_mail_presentation_not")
        Text_mail_presentation_not:setVisible(false)
    	local items = self.listview:getItems()
    	if _ED.city_resource_battle_report~= nil and _ED.city_resource_battle_report[self._mail_type] ~= nil then
    		table.sort(_ED.city_resource_battle_report[self._mail_type], function(c1, c2)
    			if c1~=nil and c2~=nil then
    				if zstring.tonumber(c1.time) > zstring.tonumber(c2.time) then
    					return true
    				end
    			end
    			return false
    		end)
            if #_ED.city_resource_battle_report[self._mail_type] <= 0 then
                Text_mail_presentation_not:setVisible(true)
            else
                local report_info = _ED.city_resource_battle_report[self._mail_type][1]
                if items[1] == nil or tonumber(items[1]._mail_data.time) ~= tonumber(report_info.time) then
                    local cells = state_machine.excute("mail_create_cell", 0, {1,report_info,2}) 
                    self.listview:insertCustomItem(cells, 0)
                    return
                end
            end
            for i, v in pairs(_ED.city_resource_battle_report[self._mail_type]) do
                if i > self._list_update + 1 then
                    self.listview:removeItem(i - 1)
                    local cells = state_machine.excute("mail_create_load_cell", 0, {self._list_update+1,2}) 
                    self.listview:addChild(cells)
                    return
                end
            end
    	else
            Text_mail_presentation_not:setVisible(true)	
    	end
    	self.listview:requestRefreshView()
    end
end

function MailPresentationDefensive:onUpdateDraw(index)
    local root = self.roots[1]
    local max_data = zstring.split(dms.string(dms["mail_config"], 2 , mail_config.param),",")
    self._max_list = tonumber(max_data[2])
    local ListView_presentation = ccui.Helper:seekWidgetByName(root,"ListView_presentation")
    local Text_mail_presentation_not = ccui.Helper:seekWidgetByName(root,"Text_mail_presentation_not")
    Text_mail_presentation_not:setVisible(false)
    if index~= nil then
    else
        ListView_presentation:jumpToTop()
    end
    ListView_presentation:removeAllItems()

    --排序，最新的显示在最上面
	if _ED.city_resource_battle_report~= nil and _ED.city_resource_battle_report[self._mail_type] ~= nil then
		table.sort(_ED.city_resource_battle_report[self._mail_type], function(c1, c2)
			if c1~=nil and c2~=nil then
				if zstring.tonumber(c1.time) > zstring.tonumber(c2.time) then
					return true
				end
			end
			return false
		end)
        if #_ED.city_resource_battle_report[self._mail_type] <= 0 then
            Text_mail_presentation_not:setVisible(true)
        end
		for i, v in pairs(_ED.city_resource_battle_report[self._mail_type]) do
			if i <= self._list_update then
				-- local cells = state_machine.excute("arena_record_cell", 0, v) 
				local cells = state_machine.excute("mail_create_cell", 0, {i,v,2}) 
				ListView_presentation:addChild(cells)
			end
            if i == self._list_update+1 and i < self._max_list+1 then
                local cells = state_machine.excute("mail_create_load_cell", 0, {i,2}) 
                ListView_presentation:addChild(cells)
            end
		end

		ListView_presentation:requestRefreshView()
	else
        Text_mail_presentation_not:setVisible(true)
    end

    ListView_presentation:requestRefreshView()
    self.listview = ListView_presentation
    self.listview_poy = ListView_presentation:getInnerContainer():getPositionY()
    self.listview_height = ListView_presentation:getInnerContainer():getPositionY()
end

function MailPresentationDefensive:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_player_build_arrow_down:setVisible(true)
        else
            self._Image_player_build_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_player_build_arrow_up:setVisible(true)
        else
            self._Image_player_build_arrow_up:setVisible(false)
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

function MailPresentationDefensive:onEnterTransitionFinish()

end

function MailPresentationDefensive:onInit( )
    local csbItem = csb.createNode(config_csb.mail.mail_presentation_tab_listview)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    self._Image_player_build_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_mail_presentation_arrow_down")
    self._Image_player_build_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_mail_presentation_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_player_build_arrow_down:stopAllActions()
    self._Image_player_build_arrow_up:stopAllActions()
    playActions(self._Image_player_build_arrow_down)
    playActions(self._Image_player_build_arrow_up)
    self._Image_player_build_arrow_down:setVisible(false)
    self._Image_player_build_arrow_up:setVisible(false)

    local mail_info = zstring.split(dms.string(dms["mail_config"], 4, mail_config.param), ",")
    self._mail_type = tonumber(mail_info[2])

	local function responseReportCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
				response.node:onUpdateDraw()
			end	
		end
	end	
	protocol_command.battlefield_report_get.param_list = self._mail_type
	NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, self, responseReportCallback, false, nil)

end

function MailPresentationDefensive:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function MailPresentationDefensive:onExit()
    state_machine.remove("mail_presentation_defensive_show")
    state_machine.remove("mail_presentation_defensive_hide")
    state_machine.remove("mail_presentation_defensive_change_page")
    state_machine.remove("mail_presentation_defensive_update_draw")
    state_machine.remove("mail_presentation_defensive_load_lists")
    
end
