----------------------------------------------------------------------------------------------------
-- 说明：数码主界面聊天窗
-------------------------------------------------------------------------------------------------------

SmChatHomeView = class("SmChatHomeViewClass", Window)

local sm_chat_view_window_open_terminal = {
    _name = "sm_chat_view_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("SmChatHomeViewClass")
        if nil == _Window then
            fwin:open(SmChatHomeView:new():init(params) , fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_chat_view_window_open_terminal)
state_machine.init()
    
function SmChatHomeView:ctor()
    self.super:ctor()
    self.roots = {}
    self.num = 0
    self._tickTime = 0
    self._isChange = false
    self.listViewType = 1 -- 1小 2 大
    self.listview = nil
    self.listview_poy = nil
    self.open_world = "1" -- "1" 开启 "0" 关闭
    self.open_system = "1"
    self.open_union = "1"
    self.open_team = "1"
    self.open_one_by_one = "1"
    self.initialHeight = 0
    self._maxCount = 30
    app.load("client.l_digital.cells.chat.SmChatHomeViewCell")
    app.load("client.l_digital.chat.ChatSystemCell")
    local function init_sm_chat_home_view_terminal()
        local sm_chat_view_open_chat_main_window_terminal = {
            _name = "sm_chat_view_open_chat_main_window",
            _init = function (terminal) 
                app.load("client.chat.ChatStorage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if fwin:find("ChatStorageClass") == nil  then
                    fwin:open(ChatStorage:new(), fwin._windows)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local sm_chat_view_open_chat_set_window_terminal = {
            _name = "sm_chat_view_open_chat_set_window",
            _init = function (terminal) 
                app.load("client.l_digital.chat.SmChatHomeViewSet")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if fwin:find("SmChatHomeViewSetClass") == nil  then
                    fwin:open(SmChatHomeViewSet:new(), fwin._windows)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_chat_Button_liaotin_window_terminal = {
            _name = "sm_chat_Button_liaotin_window",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("sm_chat_view_open_chat_main_window",0,"sm_chat_view_open_chat_main_window.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local sm_chat_view_extend_or_reduce_terminal = {
            _name = "sm_chat_view_extend_or_reduce",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.listViewType == 1 then
                    instance.listViewType = 2 
                else
                    instance.listViewType = 1
                end
                instance:listviewSize()
                if __lua_project_id == __lua_project_l_digital then 
                    state_machine.excute("home_line_btn_move",0,{instance.listViewType,instance.initialHeight})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local sm_chat_view_open_chat_updata_open_state_terminal = {
            _name = "sm_chat_view_open_chat_updata_open_state",
            _init = function (terminal) 
                app.load("client.l_digital.chat.SmChatHomeViewSet")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local UserDefault = cc.UserDefault:getInstance()
                instance.open_world = UserDefault:getStringForKey(getKey("sm_chat_view_world"))
                instance.open_system = UserDefault:getStringForKey(getKey("sm_chat_view_system"))
                instance.open_union = UserDefault:getStringForKey(getKey("sm_chat_view_union"))
                instance.open_team = UserDefault:getStringForKey(getKey("sm_chat_view_team"))
                instance.open_one_by_one = UserDefault:getStringForKey(getKey("sm_chat_view_one_by_one"))
                instance:refreshListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_chat_view_show_terminal = {
            _name = "sm_chat_view_show",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_chat_view_hide_terminal = {
            _name = "sm_chat_view_hide",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_chat_view_updata_terminal = {
            _name = "sm_chat_view_updata",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- instance:onUpdateDraw()
                instance._isChange = true
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_chat_view_open_chat_main_window_terminal)
        state_machine.add(sm_chat_view_open_chat_set_window_terminal)
        state_machine.add(sm_chat_view_extend_or_reduce_terminal)
        state_machine.add(sm_chat_view_open_chat_updata_open_state_terminal)
        state_machine.add(sm_chat_view_show_terminal)
        state_machine.add(sm_chat_view_hide_terminal)
        state_machine.add(sm_chat_view_updata_terminal)

        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
            state_machine.add(sm_chat_Button_liaotin_window_terminal)
        end

        state_machine.init()
    end
    
    init_sm_chat_home_view_terminal()
end

function SmChatHomeView:onUpdate(dt)
    self._tickTime = self._tickTime + dt
    if self._tickTime >= 1.5 then
        self._tickTime = 0
        if self._isChange == true then
            self._isChange = false
            self:refreshListView()
        end
    end
--  if self.listview ~= nil then
--         local times = math.ceil(os.time() - self.times)
--         if times > 0 and self.startTime == times then
--             -- local function responseInitCallback(response)
--             --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
--                     self:onUpdateDraw()
--             --     end
--             -- end
--             -- NetworkManager:register(protocol_command.refush_msg.code, nil, nil, nil, nil, responseInitCallback, false, nil)
--             self.startTime = times + 3
--         end

--         -- local size = self.listview:getContentSize()
--         -- local posY = self.listview:getInnerContainer():getPositionY()
--         -- if self.listview_height == 0 then
--         --     self.listview_height = posY
--         -- end
--         -- if self.listview_poy == posY then
--         --     return
--         -- end
--         -- self.listview_poy = posY
--         -- local items = self.listview:getItems()
--         -- if items[1] == nil then
--         --     return
--         -- end
--         -- local itemSize = items[1]:getContentSize()
--         -- for i, v in pairs(items) do
--         --     local tempY = v:getPositionY() + posY
--         --     if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
--         --         v:unload()
--         --     else
--         --         v:reload()
--         --     end
--         -- end
--     end
end

function SmChatHomeView:listviewSize( )
    local root = self.roots[1]
    local Image_chat_home_bg = ccui.Helper:seekWidgetByName(root, "Image_chat_home_bg")
    local Button_chat_home_arrow = ccui.Helper:seekWidgetByName(root, "Button_chat_home_arrow")
    local ListView_chat_home_infor = ccui.Helper:seekWidgetByName(root, "ListView_chat_home_infor")
    if self.listViewType == 1 then
        Image_chat_home_bg:setContentSize(cc.size(Image_chat_home_bg:getContentSize().width , self.initialHeight))
        ListView_chat_home_infor:setContentSize(cc.size(ListView_chat_home_infor:getContentSize().width , self.initialHeight))
        Button_chat_home_arrow:runAction(cc.RotateTo:create(0.1, 0))
    else
        Image_chat_home_bg:setContentSize(cc.size(Image_chat_home_bg:getContentSize().width , self.initialHeight * 2))
        ListView_chat_home_infor:setContentSize(cc.size(ListView_chat_home_infor:getContentSize().width , self.initialHeight * 2))
        Button_chat_home_arrow:runAction(cc.RotateTo:create(0.1, 180))
    end
    local imageY = Image_chat_home_bg:getPositionY() + Image_chat_home_bg:getContentSize().height
    Button_chat_home_arrow:setPositionY(imageY - Button_chat_home_arrow:getContentSize().height / 2)
end

function SmChatHomeView:refreshListView( ... )
    if _ED.chat_lock_state then
        return
    end
    if self.listview == nil then
        return
    end
    local chat_array = {}
    if _ED.home_chat_view_information ~= nil then
        chat_array = _ED.home_chat_view_information
    end

    -- local function sortTable( a, b )
    --     return tonumber(a.send_information_time) > tonumber(b.send_information_time)
    -- end
    -- table.sort(chat_array, sortTable)

    local result = {}
    local count = 1

    for i = #chat_array, 1, -1 do
        local v = chat_array[i]
        if count > self._maxCount then
            break
        end
        if self:getIsNeedShow(v) == true then
            table.insert(result, v)
            count = count + 1
        end
    end

    local items = self.listview:getItems()
    for k,v in pairs(items) do
        state_machine.excute("sm_chat_home_view_list_cell_updata_info", 0, {v, result[k]})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            self.listview:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("sm_chat_home_view_list_cell", 0 , {result[i], i})
            self.listview:addChild(cell)
        end
    end
    self.listview:requestRefreshView()
    self.listview:jumpToTop()

end

function SmChatHomeView:getIsNeedShow( info )
    local isShow = false
    if info == nil then
        return isShow
    end
    if tonumber(info.send_information_id) == 0 then
        if self.open_system == "1" then
            isShow = true
        end
    elseif tonumber(info.information_type) == 0 
        or tonumber(info.information_type) == 16
        then
        if self.open_system == "1" then
            isShow = true
        end
    elseif tonumber(info.information_type) == 1 
        or tonumber(info.information_type) == 17
        then
        if self.open_world == "1" then
            isShow = true
        end
    elseif tonumber(info.information_type) == 2 
        or tonumber(info.information_type) == 18
        then
        if self.open_union == "1" then
            isShow = true
        end
    elseif tonumber(info.information_type) == 3 then
        if self.open_one_by_one == "1" then
            isShow = true
        end
    elseif tonumber(info.information_type) == 4 
        or tonumber(info.information_type) == 20
        then
        if self.open_team == "1" then
            isShow = true
        end
    end
    return isShow
end

function SmChatHomeView:onUpdateDraw( isFirst )
    local root = self.roots[1] 
    local ListView_chat_home_infor = ccui.Helper:seekWidgetByName(root, "ListView_chat_home_infor")
    ListView_chat_home_infor:removeAllItems()
    local chat_array = {}
    if _ED.home_chat_view_information ~= nil then
        chat_array = _ED.home_chat_view_information
    end

    -- local function sortTable( a, b )
    --     return tonumber(a.send_information_time) > tonumber(b.send_information_time)
    -- end
    -- table.sort(chat_array,sortTable)

    local index = 1
    for i = #chat_array, 1, -1 do
        local v = chat_array[i]

        if index > self._maxCount then
            break
        else
            if self:getIsNeedShow(v) == true then
                local cell = state_machine.excute("sm_chat_home_view_list_cell", 0 , { v , index } )
                ListView_chat_home_infor:addChild(cell)
                index = index + 1
            end
        end
    end

    ListView_chat_home_infor:requestRefreshView()
    ListView_chat_home_infor:jumpToTop() 
    self.listview = ListView_chat_home_infor
    self.listview_poy = self.listview:getInnerContainer():getPositionY()
    self.listview_height = self.listview:getInnerContainer():getPositionY()
    
end

function SmChatHomeView:onInit()
    local csbSmChatHomeView = csb.createNode("Chat/chat_home_window.csb")
    self:addChild(csbSmChatHomeView)
    local root = csbSmChatHomeView:getChildByName("root")
    table.insert(self.roots, root)
    self.times = os.time()
    self.startTime = math.ceil(os.time() - self.times) + 3
    self:setContentSize(root:getContentSize())
    local instance = cc.UserDefault:getInstance()
    local open_world = instance:getStringForKey(getKey("sm_chat_view_world"))
    if open_world == "" then
        writeKey("sm_chat_view_world" , "1")
        self.open_world = "1"
    else
        self.open_world = open_world
    end
    local open_union = instance:getStringForKey(getKey("sm_chat_view_union"))
    if open_union == "" then
        writeKey("sm_chat_view_union" , "1")
        self.open_union = "1"
    else
        self.open_union = open_union
    end
    local open_system = instance:getStringForKey(getKey("sm_chat_view_system"))
    if open_system == "" then
        writeKey("sm_chat_view_system" , "1")
        self.open_system = "1"
    else
        self.open_system = open_system
    end
    local open_team = instance:getStringForKey(getKey("sm_chat_view_team"))
    if open_team == "" then
        writeKey("sm_chat_view_team" , "1")
        self.open_team = "1"
    else
        self.open_team = open_team
    end
    local open_one_by_one = instance:getStringForKey(getKey("sm_chat_view_one_by_one"))
    if open_one_by_one == "" then
        writeKey("sm_chat_view_one_by_one" , "1")
        self.open_one_by_one = "1"
    else
        self.open_one_by_one = open_one_by_one
    end

    local function fourOpenTouchEvent(sender, eventType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        if eventType == ccui.TouchEventType.began then
            -- sender.isMoving = false
        elseif eventType == ccui.TouchEventType.moved then 
            -- sender.isMoving = true
        elseif eventType == ccui.TouchEventType.ended then 
            if math.abs(__epoint.y - __spoint.y) <= 8 then
                state_machine.excute("sm_chat_view_open_chat_main_window",0,"sm_chat_view_open_chat_main_window.")
            end
        end
    end
    local ListView_chat_home_infor = ccui.Helper:seekWidgetByName(root, "ListView_chat_home_infor")
    ListView_chat_home_infor:setTouchEnabled(true)
    ListView_chat_home_infor:addTouchEventListener(fourOpenTouchEvent)
    if self.initialHeight == 0 then
        self.initialHeight = ListView_chat_home_infor:getContentSize().height
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_home_arrow"),nil, 
    {
        terminal_name = "sm_chat_view_extend_or_reduce",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_home_set"),nil, 
    {
        terminal_name = "sm_chat_view_open_chat_set_window",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_liaotin"),nil, 
        {
            terminal_name = "sm_chat_Button_liaotin_window",     
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end

    self:listviewSize()
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node.onUpdateDraw ~= nil then
                response.node:onUpdateDraw(true)
            end
        end
    end
    self:onUpdateDraw(true)
    -- NetworkManager:register(protocol_command.refush_msg.code, nil, nil, nil, self, responseCallback, false, nil)

    -- iphone刘海适配
    local ListView_chat_home_infor = ccui.Helper:seekWidgetByName(root, "ListView_chat_home_infor")
    if (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and isIphoneX() then 
        if ListView_chat_home_infor then 
            ListView_chat_home_infor:setPositionX(ListView_chat_home_infor:getPositionX()+80)
        end
    end
    
end

function SmChatHomeView:init(params)
    if params ~= nil then 
        local rootWindow = params
        self._rootWindows = rootWindow
    end    
    self:onInit()
    return self
end

function SmChatHomeView:onExit()
    state_machine.remove("sm_chat_view_open_chat_set_window")
    state_machine.remove("sm_chat_view_extend_or_reduce")
    state_machine.remove("sm_chat_view_open_chat_main_window")
    state_machine.remove("sm_chat_view_open_chat_updata_open_state")
    state_machine.remove("sm_chat_view_show")
    state_machine.remove("sm_chat_view_hide")
    state_machine.remove("sm_chat_view_updata")
end
