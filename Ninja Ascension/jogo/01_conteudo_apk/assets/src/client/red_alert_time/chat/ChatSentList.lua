--------------------------------------------------------------------------------------------------------------
--  聊天单页列表
--------------------------------------------------------------------------------------------------------------
ChatSentList = class("ChatSentListClass", Window)

local chat_sent_list_window_open_terminal = {
    _name = "chat_sent_list_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = ChatSentList:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(chat_sent_list_window_open_terminal)
state_machine.init()

function ChatSentList:ctor()
	self.super:ctor()
	self.roots = {}
    
    --var 
    --列表
    self._list_view = nil
    --列表初始高度
    self._list_view_poy = nil
    --聊天类型
    self._from_type = nil -- 0 系统 1 世界 2 家族 3 私人 4 国家 5 GM

    --聊天cell数量
    self._list_view_cell_count = nil

    --上次刷新时间
    self._last_time = nil

    --上次刷新信息时间
    self._last_refush_time = nil

    --cell总高度
    self._cell_height = 0
	-- Initialize chat_sent_list state machine.
    local function init_chat_sent_list_terminal()
   
    end
    
    -- call func chat_sent_list create state machine.
    init_chat_sent_list_terminal()

end

function ChatSentList:updateDraw()
    local root = self.roots[1]
    self._list_view:removeAllItems()
    local index_system = 1
    local index_my_chat = 1
    local index_other_chat = 1
    local total_index = 1
    -- print("===============,updateDraw")
    for i,v in pairs(_ED.send_information) do
		if self._from_type~= 3 and self._from_type~= 1 and self._from_type~= 2 then
			if tonumber(v.information_type) == 0 or tonumber(v.information_type) == 5 and tonumber(v.information_type) ~= 3 then
				local cell = state_machine.excute("chat_sent_world_create_cell",0,{v,total_index})
				self._list_view:addChild(cell)
				index_system = index_system + 1
                total_index = total_index + 1
				self._cell_height = cell:getContentSize().height
			end
        end
        if tonumber(v.information_type) == self._from_type and self._from_type~= 0 then
			if tonumber(v.information_type) == 4 and tonumber(v.send_information_camp) ~= tonumber(_ED.user_info.user_force) then
			else
				if v.send_information_id == _ED.user_info.user_id then
					local cell = state_machine.excute("chat_sent_player_create_cell",0,{v,total_index})
					self._list_view:addChild(cell)
					index_my_chat = index_my_chat + 1
                    total_index = total_index + 1
					self._cell_height = cell:getContentSize().height
                elseif tonumber(v.send_information_id) == 0 then
                    local cell = state_machine.excute("chat_sent_world_create_cell",0,{v,total_index})
                    self._list_view:addChild(cell)
                    index_system = index_system + 1
                    total_index = total_index + 1
                    self._cell_height = cell:getContentSize().height
				else
					local cell = state_machine.excute("chat_sent_other_player_create_cell",0,{v,total_index})
					self._list_view:addChild(cell)
					index_other_chat = index_other_chat + 1
                    total_index = total_index + 1
					self._cell_height = cell:getContentSize().height
				end    
			end  
        end
    end
    
    self._list_view_cell_count = index_system + index_my_chat + index_other_chat
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view:getInnerContainer():setPositionY(500000)
    self._list_view:requestRefreshView()

    -- debug.print_r(self._list_view:getContentSize())
    -- debug.print_r(self._list_view:getInnerContainer():getContentSize())
end

function ChatSentList:checkNewListCell()
    local information_table = {}
    local index = 1
    for i,v in pairs(_ED.send_information) do
		if self._from_type~= 3 and self._from_type~= 1 and self._from_type~= 2 then
			if tonumber(v.information_type) == 0 or tonumber(v.information_type) == 5 and tonumber(v.information_type) ~= 3 then
				index = index + 1
				if index > self._list_view_cell_count then
					table.insert(information_table,v)
				end
			end
        end
        if tonumber(v.information_type) == self._from_type and self._from_type~= 0 then
            if tonumber(v.information_type) == 4 and tonumber(v.send_information_camp) ~= tonumber(_ED.user_info.user_force) then
            else
                index = index + 1
                if index > self._list_view_cell_count then
                    table.insert(information_table,v)
                end
            end
        end
    end
    self._list_view_cell_count = index
    return information_table
end

function ChatSentList:drawNewListCells()
    local information_table = self:checkNewListCell()
    if #information_table > 0 then
        -- print("===============,drawNewListCells",#information_table)
        for i,v in pairs(information_table) do
			if self._from_type~= 3 and self._from_type~= 1 and self._from_type~= 2 then
				if tonumber(v.information_type) == 0 or tonumber(v.information_type) == 5 and tonumber(v.information_type) ~= 3 then
					local cell = state_machine.excute("chat_sent_world_create_cell",0,{v,0})
					self._list_view:addChild(cell)
					self._cell_height = cell:getContentSize().height
				end
            end
            if tonumber(v.information_type) == self._from_type and self._from_type~= 0 then
                if tonumber(v.information_type) == 4 and tonumber(v.send_information_camp) ~= tonumber(_ED.user_info.user_force) then
                else
                    if v.send_information_id == _ED.user_info.user_id then
                        local cell = state_machine.excute("chat_sent_player_create_cell",0,{v,0})
                        self._list_view:addChild(cell)
                        self._cell_height = cell:getContentSize().height
                    elseif tonumber(v.send_information_id) == 0 then
                        local cell = state_machine.excute("chat_sent_world_create_cell",0,{v,0})
                        self._list_view:addChild(cell)
                        self._cell_height = cell:getContentSize().height
                    else
                        local cell = state_machine.excute("chat_sent_other_player_create_cell",0,{v,0})
                        self._list_view:addChild(cell)
                        self._cell_height = cell:getContentSize().height
                    end 
                end   
            end 
        end
        self:onUpdate(0)
        self._list_view:requestRefreshView()
        -- print("===_cell_height=",self._cell_height)
        -- print("=========getPositionY==",self._list_view:getInnerContainer():getPositionY())
        -- print("=========height==",self._list_view:getContentSize().height)
        -- self._list_view:getInnerContainer():setPositionY(self._cell_height - self._list_view:getContentSize().height)

        self._list_view:getInnerContainer():setPositionY(self._cell_height)
        
    end
end

function ChatSentList:onUpdate(dt)
    local now_time = os.time()
    -- if now_time - zstring.tonumber(self._last_time) >= 1 then
        if self._list_view_cell_count > 100 then
            for i = 1,self._list_view_cell_count - 100 do
                table.remove(_ED.send_information,i)
            end

            local index = 1
            for i,v in pairs(_ED.send_information) do
				if self._from_type~= 3 and self._from_type~= 1 and self._from_type~= 2 then
					if tonumber(v.information_type) == 0 or tonumber(v.information_type) == 5 and tonumber(v.information_type) ~= 3 then
						index = index + 1
					end
                end
                if tonumber(v.information_type) == self._from_type and self._from_type~= 0 then
                    if tonumber(v.information_type) == 4 and tonumber(v.send_information_camp) ~= tonumber(_ED.user_info.user_force) then
                    else
                        index = index + 1
                    end
                end
            end
            self._list_view_cell_count = index
            -- self:updateDraw()
        else
            self:drawNewListCells()    
        end
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

function ChatSentList:onInit()
    local csbItem = csb.createNode(config_csb.chats.chat_sent_list)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 
    self._list_view = ccui.Helper:seekWidgetByName(root, "ListView_chat_sent")
    self:setContentSize(self._list_view:getContentSize())
    self:updateDraw()    
end

function ChatSentList:onEnterTransitionFinish()
    
end

function ChatSentList:init(params)
    local rootWindow = params[1]
    self._from_type = params[2]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function ChatSentList:onExit()
   
end