--------------------------------------------------------------------------------------------------------------
--  聊天单页列表
--------------------------------------------------------------------------------------------------------------
RedAlertTimeChatSentList = class("RedAlertTimeChatSentListClass", Window)

local red_alert_time_chat_sent_list_window_open_terminal = {
    _name = "red_alert_time_chat_sent_list_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = RedAlertTimeChatSentList:new():init(params)
        fwin:open(list_view)
        _ED._chat_first_time_to_enter = true
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_chat_sent_list_window_open_terminal)
state_machine.init()

function RedAlertTimeChatSentList:ctor()
	self.super:ctor()
	self.roots = {}

    -- self.__cdt = 1
    
    --var 
    --列表
    self._list_view = nil
    --列表初始高度
    self._list_view_poy = 0
    self.listview_height = 0
    --聊天类型
    self._from_type = nil -- 0 系统 1 世界 2 家族 3 私人 4 国家 5 GM
    -- 0:系统；1:世界；2 国家, 3:军团；4:私聊 ; 6:公会战系统 ;7:公会战倒计时; 8:红包; 9:敌军来袭

    --聊天cell数量
    self._list_view_cell_count = 0

    --上次刷新时间
    self._last_time = nil

    --上次刷新信息时间
    self._last_refush_time = nil

    --cell总高度
    self._cell_height = 0
    self._Image_chat_arrow_down = nil
    self._Image_chat_arrow_up = nil

	-- Initialize chat_sent_list state machine.
    local function init_chat_sent_list_terminal()
    -- 刷新界面
        local red_alert_time_chat_sent_list_update_draw_terminal = {
            _name = "red_alert_time_chat_sent_list_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local chat_list_view = params
                if chat_list_view ~= nil and chat_list_view.roots ~= nil and chat_list_view.roots[1] ~= nil then
                    chat_list_view._list_view:jumpToBottom()
                end 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_chat_sent_list_update_chat_infomation_terminal = {
            _name = "red_alert_time_chat_sent_list_update_chat_infomation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local chat_list_view = params
                if chat_list_view ~= nil and chat_list_view.roots ~= nil and chat_list_view.roots[1] ~= nil then
                    chat_list_view:updateChatInfomation()
                end 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_chat_sent_list_update_draw_terminal) 
        state_machine.add(red_alert_time_chat_sent_list_update_chat_infomation_terminal) 
        state_machine.init()
    end
    
    -- call func chat_sent_list create state machine.
    init_chat_sent_list_terminal()

end

function RedAlertTimeChatSentList:updateDraw()
    local root = self.roots[1]
    self._list_view:removeAllItems()
    local index_system = 1
    local index_my_chat = 1
    local index_other_chat = 1
    self._list_view_cell_count = 0
    if true then
        return
    end
    for i,v in pairs(_ED.send_information) do
		--if self._from_type~= 3 and self._from_type~= 1 and self._from_type~= 2 then
        if self._from_type== 1 then
			if tonumber(v.information_type) == 0 
                or tonumber(v.information_type) == 5 
                or tonumber(v.information_type) == 8
                and tonumber(v.information_type) ~= 4 
                then
                if v.isShow == true then
                    if self._list_view_cell_count < 9 then
                        local cell = state_machine.excute("chat_sent_world_create_cell",0,{v,self._list_view_cell_count})
                        self._list_view:addChild(cell)
                        index_system = index_system + 1
                        self._list_view_cell_count =  self._list_view_cell_count + 1
                        self._cell_height = cell:getContentSize().height
                    end
                end
			end
        end
        if tonumber(v.information_type) == self._from_type and self._from_type~= 0 then
			if tonumber(v.information_type) == 4 and tonumber(v.send_information_camp) ~= tonumber(_ED.user_info.user_force) then
			else
				if v.send_information_id == _ED.user_info.user_id then
                    if self._list_view_cell_count < 9 then
                        local cell = state_machine.excute("chat_sent_player_create_cell",0,{v,self._list_view_cell_count})
                        self._list_view:addChild(cell)
                        index_my_chat = index_my_chat + 1
                        self._list_view_cell_count =  self._list_view_cell_count + 1
                        self._cell_height = cell:getContentSize().height
                    end
				elseif tonumber(v.send_information_id) == 0 and v.isShow == true then
                    if self._list_view_cell_count < 999 then
                        local cell = state_machine.excute("chat_sent_world_create_cell",0,{v,self._list_view_cell_count})
                        self._list_view:addChild(cell)
                        index_system = index_system + 1
                        self._list_view_cell_count =  self._list_view_cell_count + 1
                        self._cell_height = cell:getContentSize().height
                    end
                else
                    if self._list_view_cell_count < 9 then
                        local cell = state_machine.excute("chat_sent_other_player_create_cell",0,{v,self._list_view_cell_count})
                        self._list_view:addChild(cell)
                        index_other_chat = index_other_chat + 1
                        self._list_view_cell_count =  self._list_view_cell_count + 1
    					self._cell_height = cell:getContentSize().height
                    end
				end    
			end
        end
    end
    
    -- self._list_view_cell_count = index_system + index_my_chat + index_other_chat
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self.listview_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:getInnerContainer():setPositionY(500000)
    self._list_view:requestRefreshView()
    -- debug.print_r(self._list_view:getContentSize())
    -- debug.print_r(self._list_view:getInnerContainer():getContentSize())
end

-- function RedAlertTimeChatSentList:romoveMoreThan(information_table)
--     if #information_table >= 20 then
--         self._list_view:removeAllItems()
--         self._list_view:jumpToTop()
--         self._list_view:requestRefreshView()
--         local new_table = {}
--         if #information_table == 20 then
--         else
--             for i = #information_table-20, #information_table do
--                 table.insert(new_table,information_table[i])
--             end
--             -- debug.print_r(new_table)
--             information_table = {}
--             information_table = new_table
--         end
--         self._list_view_cell_count = 20
--     end
--     return information_table
-- end

function RedAlertTimeChatSentList:checkNewListCell()
    local information_table = {}
    local index = 1
    for i,v in pairs(_ED.send_information) do
		if self._from_type~= 4 and self._from_type~= 3 and self._from_type~= 2 and self._from_type~= 9 then
			if tonumber(v.information_type) == 0 or tonumber(v.information_type) == 5 and tonumber(v.information_type) ~= 4 then
                if v.isShow == true then
                    index = index + 1
                    if index > self._list_view_cell_count then
                        table.insert(information_table,v)
                    end
                end
			end
        end
        if (tonumber(v.information_type) == self._from_type and self._from_type~= 0)
            or (self._from_type == 1 and tonumber(v.information_type) == 8)
            then
            if tonumber(v.information_type) == 4 and tonumber(v.send_information_camp) ~= tonumber(_ED.user_info.user_force) then
            else
                if v.isShow == true then
                    index = index + 1
                    if index > self._list_view_cell_count then
                        table.insert(information_table,v)
                    end
                end
            end
        end
    end
    self._list_view_cell_count = index
    return information_table
end

function RedAlertTimeChatSentList:drawNewListCells()
    local information_table = self:checkNewListCell()
    -- information_table = self:romoveMoreThan(information_table)
    local iemsMargin = self._list_view:getItemsMargin()
    local numberLong = 0
    if #information_table > 0 then
        -- print("===============,drawNewListCells",#information_table)
        for i,v in pairs(information_table) do
            if self._from_type~= 4 and self._from_type~= 3 and self._from_type~= 2 and self._from_type~= 9 then
                if tonumber(v.information_type) == 0 or tonumber(v.information_type) == 5 and tonumber(v.information_type) ~= 4 then
                    if v.isShow == true then
                        local cell = state_machine.excute("chat_sent_world_create_cell",0,{v,0})
                        self._list_view:addChild(cell)
                        self._cell_height = cell:getContentSize().height
                        numberLong = numberLong + self._cell_height
                    end
                end
            end
            if (tonumber(v.information_type) == self._from_type and self._from_type~= 0)
                or (self._from_type == 1 and tonumber(v.information_type) == 8)
                then
                if tonumber(v.information_type) == 4 and tonumber(v.send_information_camp) ~= tonumber(_ED.user_info.user_force) then
                else
                    if v.send_information_id == _ED.user_info.user_id 
                        and tonumber(v.information_type) ~= 8
                        then
                        local cell = state_machine.excute("chat_sent_player_create_cell",0,{v,0})
                        self._list_view:addChild(cell)
                        numberLong = numberLong + cell:getContentSize().height + iemsMargin
                    elseif tonumber(v.send_information_id) == 0
                        or tonumber(v.information_type) == 8
                        then
                        if v.isShow == true then
                            local cell = state_machine.excute("chat_sent_world_create_cell",0,{v,0})
                            self._list_view:addChild(cell)
                            numberLong = numberLong + cell:getContentSize().height + iemsMargin
                        end
                    else
                        local cell = state_machine.excute("chat_sent_other_player_create_cell",0,{v,0})
                        self._list_view:addChild(cell)
                        numberLong = numberLong + cell:getContentSize().height + iemsMargin
                    end 
                end   
            end 
        end
        self:updateChatInfomation()
        local items = self._list_view:getItems()
        if #items > 30 then
            local len = #items-30
            for i=1, len do
                local index = len - i + 1
                local itemSize = items[index]:getContentSize()
                -- itemSize:onExitNew()
                self._list_view:removeItem(index - 1)
                numberLong = numberLong - itemSize.height - iemsMargin
            end
        end
        -- self._list_view:jumpToBottom()
        self._list_view:requestRefreshView()
        -- print("===_cell_height=",self._cell_height)
        -- print("=========getPositionY==",self._list_view:getInnerContainer():getPositionY())
        -- print("=========height==",self._list_view:getContentSize().height)
        -- self._list_view:getInnerContainer():setPositionY(self._cell_height - self._list_view:getContentSize().height)
        local now_number_long = self._list_view:getInnerContainer():getPositionY()
        self._list_view:getInnerContainer():setPositionY(now_number_long+numberLong)
        self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
        self.listview_height = 0

        state_machine.excute("red_alert_time_chat_push_notification", 0, {self._from_type, false})
    end
end

function RedAlertTimeChatSentList:updateChatInfomation()
    -- local now_time = os.time()
    -- if now_time - zstring.tonumber(self._last_time) >= 1 then
        -- if self._list_view_cell_count > 30 then
    --         for i = 1,self._list_view_cell_count - 30 do
    --             table.remove(_ED.send_information,i)
    --         end

    --         local index = 1
    --         for i,v in pairs(_ED.send_information) do
				-- if self._from_type~= 4 and self._from_type~= 1 and self._from_type~= 2 then
				-- 	if tonumber(v.information_type) == 0 or tonumber(v.information_type) == 5 and tonumber(v.information_type) ~= 4 then
    --                     if v.isShow == true then
    --                         index = index + 1
    --                     end
				-- 	end
    --             end
    --             if tonumber(v.information_type) == self._from_type and self._from_type~= 0 then
    --                 if tonumber(v.information_type) == 4 and tonumber(v.send_information_camp) ~= tonumber(_ED.user_info.user_force) then
    --                 else
    --                     if v.isShow == true then
    --                         index = index + 1
    --                     end
    --                 end
    --             end
    --         end
    --         self._list_view_cell_count = index
            -- self:updateDraw()
        -- else
            if _ED.chats_add_datas == true or self._from_type == 9 then
                self:drawNewListCells()    
            end
            -- self._list_view:jumpToBottom()
        -- end
    --     self._last_time = now_time
    -- end
        
    -- if now_time - zstring.tonumber(self._last_refush_time) >= 3 then 
    --     local function responseCallback(response)
    --         if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then

    --         end
    --     end
    --     NetworkManager:register(protocol_command.refush_msg.code, nil, nil, nil, self, responseCallback, false, nil)
    --     self._last_refush_time = now_time
    -- end

    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        local items = self._list_view:getItems()
        if #items <= 1 then
            self._Image_chat_arrow_down:setVisible(false)
            self._Image_chat_arrow_up:setVisible(false)
            return
        end
        if self.listview_height == 0 then
            self.listview_height = size.height - self._list_view:getInnerContainer():getContentSize().height
        end
        if self._list_view_poy <= -30 then
            self._Image_chat_arrow_down:setVisible(true)
        else
            self._Image_chat_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self.listview_height + 30 then
            self._Image_chat_arrow_up:setVisible(true)
        else
            self._Image_chat_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
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

function RedAlertTimeChatSentList:onInit()
    local csbItem = csb.createNode(config_csb.chats.chat_sent_list)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- if nil ~= self._list_view.setBounceBottomBoundary then
    --     self._list_view:setBounceBottomBoundary(0)
    -- end

    self._Image_chat_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_chat_arrow_down")
    self._Image_chat_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_chat_arrow_up")
    
    self._list_view = ccui.Helper:seekWidgetByName(root, "ListView_world_chat")
	if tonumber(self._from_type) == 4 then
		self._list_view:setContentSize(cc.size(self._list_view:getContentSize().width,self._list_view:getContentSize().height-64))
		self:setContentSize(self._list_view:getContentSize())
        self:setPositionY(self:getPositionY()+64)
        self._Image_chat_arrow_up:setPositionY(self._Image_chat_arrow_up:getPositionY()-64)
	end

    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_chat_arrow_down:stopAllActions()
    self._Image_chat_arrow_up:stopAllActions()
    playActions(self._Image_chat_arrow_down)
    playActions(self._Image_chat_arrow_up)
    self._Image_chat_arrow_down:setVisible(false)
    self._Image_chat_arrow_up:setVisible(false)

    self:updateDraw()    
    state_machine.excute("red_alert_time_chat_push_notification", 0, {self._from_type, true})
end

function RedAlertTimeChatSentList:onEnterTransitionFinish()
    
end

function RedAlertTimeChatSentList:init(params)
    local rootWindow = params[1]
    self._from_type = params[2]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function RedAlertTimeChatSentList:onExit()

end