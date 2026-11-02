-----------------------------
-- 选择服务器界面
-----------------------------
ServerManagers = class("ServerManagersClass", Window)

require "frameworks.external.utils.utils"

local server_managers_window_open_terminal = {
    _name = "server_managers_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("ServerManagersClass")
        if nil == _Window then
            fwin:open(ServerManagers:new():init(), fwin._screen)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local server_managers_window_close_terminal = {
    _name = "server_managers_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ServerManagersClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(server_managers_window_open_terminal)
state_machine.add(server_managers_window_close_terminal)
state_machine.init()
function updateDefaultServerFile()
    cc.UserDefault:getInstance():setStringForKey("defserver", _ED.selected_server)
    local sers = cc.UserDefault:getInstance():getStringForKey("defservers")
    if sers == nil then
        sers = ""
    end
    local serverList = zstring.zsplit(sers, ",")
    local rsers = ""
    for i, s in ipairs(serverList) do
        if s ~= nil and s ~= _ED.selected_server then
            rsers = rsers..","
            rsers = rsers..s
        end
    end
    rsers = "".._ED.selected_server..rsers
    cc.UserDefault:getInstance():setStringForKey("defservers", rsers)
    cc.UserDefault:getInstance():setStringForKey("defserver", _ED.selected_server)
    cc.UserDefault:getInstance():flush()
end
    
function ServerManagers:ctor()
    self.super:ctor()
    self.roots = {}

    self.all_server_table = nil
    self.left_server_table = nil
    -- 多少个服务器切分一个界面
    self._cut_number = 0

    -- load lua file
    app.load("client.red_alert_time.cells.login.server_list_left_cell")
    app.load("client.red_alert_time.cells.login.server_list_cell")
    
    -- Initialize ServerManagers page state machine.
    local function init_server_managers_terminal()
        --切换
        local server_list_left_cell_change_server_list_page_terminal = {
            _name = "server_list_left_cell_change_server_list_page",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local table_index = params._datas.cell.table_index
                instance:setSelected(params._datas.cell)
                instance:onUpdateDrawMiddleList(table_index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local server_managers_select_server_terminal = {
            _name = "server_managers_select_server",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local server_number = params._datas.cell.server_number
				if fwin:find("RedAlertTimeSystemSettingsClass") ~= nil then
                    if _ED.selected_server == server_number then
                        return
                    end

                    fwin:removeAll()
                    cacher.destoryRefPools()
                    cacher.cleanSystemCacher()
                    cacher.cleanActionTimeline()
                    checkTipBeLeave()
                    cacher.remvoeUnusedArmatureFileInfoes()
                    fwin:reset(nil)
                    fwin:open(Login:new(), fwin._view)
                    fwin:close(fwin:find("ConnectingViewClass"))
				end
                _ED.selected_server = server_number
                if fwin:find("LoginClass") ~= nil then
                    fwin:find("LoginClass"):updateSelectedServer()
                end
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }
        state_machine.add(server_managers_select_server_terminal)
        state_machine.add(server_list_left_cell_change_server_list_page_terminal)
        state_machine.init()
    end
    
    -- call func init ServerManagers state machine.
    init_server_managers_terminal()
end

function ServerManagers:onEnterTransitionFinish( ... )

end

function ServerManagers:setSelected(cell)
    local root = self.roots[1]
    local ListView_server_manager = ccui.Helper:seekWidgetByName(root,"ListView_server_manager")
    for i,v in pairs(ListView_server_manager:getItems()) do
        if v == cell then
            v:setSelected(true)
        else
            v:setSelected(false)
        end
    end
end

function ServerManagers:onUpdateDrawLeftList( ... )
    local root = self.roots[1]
    local ListView_server_manager = ccui.Helper:seekWidgetByName(root,"ListView_server_manager")
    local max_table_number = #self.left_server_table
    for i,v in pairs(self.left_server_table) do
        local cell = state_machine.excute("server_list_left_create_cell",0,{i,v,max_table_number})  
        ListView_server_manager:insertCustomItem(cell, 0)
    end
    ListView_server_manager:requestRefreshView()
end

function ServerManagers:onUpdateDrawMiddleList(index)
    local root = self.roots[1]
    local function sortType( a, b )
        return tonumber(a.server_number) > tonumber(b.server_number)
    end   
    
    -- 区分机甲和东邪西毒选择服务器界面
    if __lua_project_id == __lua_project_pacific_rim then
        local ListView_server_list = ccui.Helper:seekWidgetByName(root,"ListView_server_list")
        ListView_server_list:removeAllItems()
        table.sort( self.all_server_table[index], sortType )

        for i,v in pairs(self.all_server_table[index]) do
            local cell = state_machine.excute("server_list_create_cell",0,v)
            ListView_server_list:addChild(cell)
        end
        ListView_server_list:requestRefreshView()

    else
        local ScrollView_server_list = ccui.Helper:seekWidgetByName(root,"ScrollView_server_list")
        ScrollView_server_list:removeAllChildren(true)

        local max_line = 0
        table.sort( self.all_server_table[index], sortType )
        local total_count = #self.all_server_table[index]
        if total_count % 2 == 0 then
            max_line = total_count / 2
        else
            max_line = math.floor(total_count / 2) + 1
        end
        local scroll_width = ScrollView_server_list:getContentSize().width
        local scroll_height = ScrollView_server_list:getContentSize().height

        local width = 206
        local height = 60
        local total_height = max_line * height
        if total_height > scroll_height then
            scroll_height = total_height
        end
        local current_height = scroll_height - height

        ScrollView_server_list:getInnerContainer():setContentSize(cc.size(width * 2, scroll_height))

        local current_index = 0

        for i,v in pairs(self.all_server_table[index]) do
            local cell = state_machine.excute("server_list_create_cell",0,v)
            
            current_index = current_index + 1
            if (current_index % 2) == 0 then
                cell:setPosition(cc.p(width, current_height))
                current_height = current_height - height
            else
                cell:setPosition(cc.p(0, current_height))
            end
            ScrollView_server_list:addChild(cell)
        end
        
        ScrollView_server_list:jumpToTop()
    end
end


function ServerManagers:getSeverDatas()
    local sort_table = _ED.all_def_servers
    local function sortType( a, b )
        return tonumber(a.server_number) < tonumber(b.server_number)
    end
    local cut_number = self._cut_number  --多少个服务器切分一个界面

    table.sort( sort_table, sortType ) --已经最新的在最前
    local all_server_table = {}
    local left_server_table = {}
    local lenth = 0
    if #_ED.all_def_servers % cut_number == 0 then
        lenth = math.floor(#_ED.all_def_servers/cut_number)
    else
        lenth = math.floor(#_ED.all_def_servers/cut_number) + 1
    end
    local all_server_number = #_ED.all_def_servers
    for i=1,lenth do
        all_server_table[i] = {}
        
        local name = string.format(red_alert_all_str[159], 1+(i-1)*cut_number, i*cut_number)
        table.insert(left_server_table,name)
    end
    local table_index = 1
    local index = 1
    for i,v in pairs(sort_table) do
        if index > cut_number then
            index = 1
            table_index = table_index + 1
        end
        table.insert(all_server_table[table_index],v)
        index = index + 1
    end
    self.all_server_table = all_server_table
    self.left_server_table = left_server_table  
end

-- 东邪上次登录服务器信息
function ServerManagers:onUpdateDraw()
    local root = self.roots[1]
    local Text_server_number_last = ccui.Helper:seekWidgetByName(root,"Text_server_number_last")
    local Text_server_name_last = ccui.Helper:seekWidgetByName(root,"Text_server_name_last")
    local Panel_server_types = ccui.Helper:seekWidgetByName(root,"Panel_server_types")
    local sers =  cc.UserDefault:getInstance():getStringForKey("defservers")
    if sers == nil then
        Text_server_number_last:setString("")
        Text_server_name_last:setString("")
        return
    end
    
    local serverListIndex = 0
    local serverList_tab = zstring.zsplit(sers, ",")
    local data = _ED.all_servers[serverList_tab[1]]
    if data == nil then
        Text_server_number_last:setString("")
        Text_server_name_last:setString("") 
        return       
    end
    if data.server_code ~= nil then
        Text_server_number_last:setString(string.format(red_alert_all_str[15],data.server_code))
    else
        Text_server_number_last:setString(string.format(red_alert_all_str[15],data.server_number))
    end
    Text_server_name_last:setString(data.server_name)
    Panel_server_types:removeBackGroundImage()
    if tonumber(data.server_type) ~= -1 then
        Panel_server_types:setBackGroundImage("images/ui/state/server_status_" .. data.server_type .. ".png")
    end
end

-- 红警上次登录服务器信息和推荐服务器
function ServerManagers:onUpdateDrawRed()
    local root = self.roots[1]
    local Panel_server_manager_nub_1 = ccui.Helper:seekWidgetByName(root,"Panel_server_manager_nub_1")  -- 推荐服务器
    Panel_server_manager_nub_1:removeAllChildren(true)
    local Panel_server_manager_nub_2 = ccui.Helper:seekWidgetByName(root,"Panel_server_manager_nub_2")  -- 最近登录的服务器
    Panel_server_manager_nub_2:removeAllChildren(true)
    local sers =  cc.UserDefault:getInstance():getStringForKey("defservers")
    if sers ~= nil then
        local serverList_tab = zstring.zsplit(sers, ",")
        local data = _ED.all_servers[serverList_tab[1]]
        if data ~= nil then
            local cell = state_machine.excute("server_list_create_cell",0,data)
            Panel_server_manager_nub_2:addChild(cell)
        end
    end
    
end

function ServerManagers:onInit()  
    local csbservermanager = csb.createNode(config_csb.login.server_managers)
    self:addChild(csbservermanager)
    local root = csbservermanager:getChildByName("root")
    table.insert(self.roots, root)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_server_close"),nil, 
    { 
        terminal_name = "server_managers_window_close", 
        cell = self,
        terminal_state = 0
    }
    ,nil, 1)
    
    if __lua_project_id == __lua_project_pacific_rim then
        self._cut_number = 10
    else
        self._cut_number = 50
    end
    self:onUpdateDrawRed()
    self:getSeverDatas()
    self:onUpdateDrawLeftList()
end

function ServerManagers:init()
    self:onInit()
    return self
end

function ServerManagers:onExit()
    state_machine.remove("server_managers_select_server")
    state_machine.remove("server_list_left_cell_change_server_list_page")
end
