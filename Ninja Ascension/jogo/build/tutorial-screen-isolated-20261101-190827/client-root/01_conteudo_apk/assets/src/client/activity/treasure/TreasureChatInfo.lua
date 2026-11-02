----------------------------------------------------------------------------------------------------
-- 说明：数码主界面聊天窗
-------------------------------------------------------------------------------------------------------

TreasureChatInfo = class("TreasureChatInfoClass", Window)

local treasure_chat_info_open_terminal = {
    _name = "treasure_chat_info_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("TreasureChatInfoClass")
        if nil == _Window then
            fwin:open(TreasureChatInfo:new():init(params) , fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(treasure_chat_info_open_terminal)
state_machine.init()
    
function TreasureChatInfo:ctor()
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
    app.load("client.activity.treasure.TreasureChatInfoCell")
    app.load("client.activity.treasure.TreasureChatInfo")
    local function init_treasure_chat_info_home_view_terminal()
        
        local treasure_chat_info_view_extend_or_reduce_terminal = {
            _name = "treasure_chat_info_view_extend_or_reduce",
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
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local treasure_chat_info_view_open_chat_updata_open_state_terminal = {
            _name = "treasure_chat_info_view_open_chat_updata_open_state",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:refreshListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local treasure_chat_info_view_show_terminal = {
            _name = "treasure_chat_info_view_show",
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

        local treasure_chat_info_view_hide_terminal = {
            _name = "treasure_chat_info_view_hide",
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

        local treasure_chat_info_view_updata_terminal = {
            _name = "treasure_chat_info_view_updata",
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

        state_machine.add(treasure_chat_info_view_open_chat_main_window_terminal)
        state_machine.add(treasure_chat_info_view_open_chat_set_window_terminal)
        state_machine.add(treasure_chat_info_view_extend_or_reduce_terminal)
        state_machine.add(treasure_chat_info_view_open_chat_updata_open_state_terminal)
        state_machine.add(treasure_chat_info_view_show_terminal)
        state_machine.add(treasure_chat_info_view_hide_terminal)
        state_machine.add(treasure_chat_info_view_updata_terminal)

        state_machine.init()
    end
    
    init_treasure_chat_info_home_view_terminal()
end

function TreasureChatInfo:onUpdate(dt)
    self._tickTime = self._tickTime + dt
    if self._tickTime >= 1.5 then
        self._tickTime = 0
        if self._isChange == true then
            self._isChange = false
            self:refreshListView()
        end
    end
    -- if self.listview ~= nil then
    --     local size = self.listview:getContentSize()
    --     local posY = self.listviewContainer:getPositionY()
    --     if self.listview_height == posY then
    --         return
    --     end
    --     self.listview_height = posY
    --     local items = self.listview:getItems()
    --     if items[1] == nil then
    --         return
    --     end
    --     local itemSize = items[1]:getContentSize()
    --     for i, v in pairs(items) do
    --         local tempY = v:getPositionY() + posY
    --         if tempY + itemSize.height*2 < 0 or tempY > size.height + itemSize.height*2 then
    --             v:unload()
    --         else
    --             v:reload()
    --         end
    --     end
    -- end
end

function TreasureChatInfo:listviewSize( )
    local root = self.roots[1]
    local Image_chat_home_bg = ccui.Helper:seekWidgetByName(root, "Image_30_0_0")
    local Button_chat_home_arrow = ccui.Helper:seekWidgetByName(root, "Button_get_infor_arrow")
    local ListView_get_infor = ccui.Helper:seekWidgetByName(root, "ListView_get_infor")
    if self.listViewType == 1 then
        Image_chat_home_bg:setContentSize(cc.size(Image_chat_home_bg:getContentSize().width , self.initialHeight + 10))
        ListView_get_infor:setContentSize(cc.size(ListView_get_infor:getContentSize().width , self.initialHeight))
        Button_chat_home_arrow:runAction(cc.RotateTo:create(0.1, 0))
    else
        Image_chat_home_bg:setContentSize(cc.size(Image_chat_home_bg:getContentSize().width , self.initialHeight * 8 + 10))
        ListView_get_infor:setContentSize(cc.size(ListView_get_infor:getContentSize().width , self.initialHeight * 8))
        Button_chat_home_arrow:runAction(cc.RotateTo:create(0.1, 180))
    end
    local imageY = Image_chat_home_bg:getPositionY() + Image_chat_home_bg:getContentSize().height
    Button_chat_home_arrow:setPositionY(imageY - Button_chat_home_arrow:getContentSize().height / 2)
end

function TreasureChatInfo:refreshListView( ... )
    if self.listview == nil then
        return
    end
    local chat_array = {}
    if _ED.activity_treasures_notification ~= nil then
        chat_array = _ED.activity_treasures_notification
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
        state_machine.excute("treasure_chat_info_cell_updata_info", 0, {v, result[k]})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            self.listview:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("treasure_chat_info_cell", 0 , {result[i], i})
            self.listview:addChild(cell)
        end
    end
    self.listview:requestRefreshView()
    self.listview:jumpToTop()
end

function TreasureChatInfo:getIsNeedShow( info )
    local isShow = true
    
    return isShow
end

function TreasureChatInfo:onUpdateDraw( isFirst )
    local root = self.roots[1] 
    local ListView_get_infor = ccui.Helper:seekWidgetByName(root, "ListView_get_infor")
    ListView_get_infor:removeAllItems()
    local chat_array = {}
    if _ED.activity_treasures_notification ~= nil then
        chat_array = _ED.activity_treasures_notification
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
                local cell = TreasureChatInfoCell:createCell()
                cell:init({ v , index })
                ListView_get_infor:addChild(cell)
                index = index + 1
            end
        end
    end

    ListView_get_infor:requestRefreshView()
    ListView_get_infor:jumpToTop() 
    self.listview = ListView_get_infor
    self.listviewContainer = self.listview:getInnerContainer()
    self.listview_height = self.listview:getInnerContainer():getPositionY()
end

function TreasureChatInfo:onInit()
    local csbTreasureChatInfo = csb.createNode("activity/wonderful/rare_treasure_infor_show.csb")
    self:addChild(csbTreasureChatInfo)
    local root = csbTreasureChatInfo:getChildByName("root")
    table.insert(self.roots, root)
    self.times = os.time()
    self.startTime = math.ceil(os.time() - self.times) + 3
    self:setContentSize(root:getContentSize())

    local ListView_get_infor = ccui.Helper:seekWidgetByName(root, "ListView_get_infor")
    ListView_get_infor:setTouchEnabled(true)
    if self.initialHeight == 0 then
        self.initialHeight = ListView_get_infor:getContentSize().height
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_get_infor_arrow"),nil, 
    {
        terminal_name = "treasure_chat_info_view_extend_or_reduce",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self:listviewSize()
    self:onUpdateDraw()
end

function TreasureChatInfo:init(params)
    if params ~= nil then 
        local rootWindow = params
        self._rootWindows = rootWindow
    end    
    self:onInit()
    self:registerOnNoteUpdate(self, 1)
    return self
end

function TreasureChatInfo:onExit()
    state_machine.remove("treasure_chat_info_view_open_chat_set_window")
    state_machine.remove("treasure_chat_info_view_extend_or_reduce")
    state_machine.remove("treasure_chat_info_view_open_chat_main_window")
    state_machine.remove("treasure_chat_info_view_open_chat_updata_open_state")
    state_machine.remove("treasure_chat_info_view_show")
    state_machine.remove("treasure_chat_info_view_hide")
    state_machine.remove("treasure_chat_info_view_updata")
    self:unregisterOnNoteUpdate(self)
end
