-----------------------------
--任务 日常
-----------------------------
TaskDailyList = class("TaskDailyListClass", Window)

local task_daily_list_window_open_terminal = {
    _name = "task_daily_list_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = TaskDailyList:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(task_daily_list_window_open_terminal)
state_machine.init()

function TaskDailyList:ctor()
    self.super:ctor()
    self.roots = {}
    
    self._current_page = 0
    self._fightPanel = nil
    self._unionPanel = nil
    self._developPanel = nil
    self._privilegePanel = nil

    self.listview = nil
    self.listview_poy = nil

    self._Image_player_build_arrow_down = nil
    self._Image_player_build_arrow_up = nil
    local function init_task_daily_list_terminal()
        --显示界面
        local task_daily_list_window_show_terminal = {
            _name = "task_daily_list_window_show",
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
        local task_daily_list_window_hide_terminal = {
            _name = "task_daily_list_window_hide",
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

        --重新绘制
        local task_daily_list_update_listview_terminal = {
            _name = "task_daily_list_update_listview",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.listview ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local task_daily_change_page_terminal = {
            _name = "task_daily_change_page",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeSelectPage(tonumber(params._datas._page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local task_daily_list_get_reward_terminal = {
            _name = "task_daily_list_get_reward",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local task_type = self._current_page + 3
                local task_id = 0
                local task_mould_id = 0
                for k,task_data in pairs(_ED.user_task_infos["8"]) do
                    if task_data.little_type == task_type then 
                        task_id = task_data.task_id
                        task_mould_id = task_data.task_mould_id
                    end
                end
                _ED.last_user_level = _ED.user_info.user_grade
                _ED.last_prestige_level = _ED.user_info.credit_level
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("task_daily_list_update_listview", 0, nil)
                        checkRewardObtainDraw()
                        checkEffectLevelUp()
                    end
                end
                protocol_command.get_task_reward.param_list = task_id .. "\r\n" .. task_mould_id
                NetworkManager:register(protocol_command.get_task_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local task_daily_list_show_info_terminal = {
            _name = "task_daily_list_show_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local task_type = self._current_page + 3
                for k,task_info in pairs(_ED.user_task_infos["8"]) do
                    if task_info.little_type == task_type then 
                        local achieve_mould_id = task_info.achieve_mould_id
                        local achieve_data = dms.element(dms["achievement_mould"], achieve_mould_id)
                        local achievement_reward = zstring.split(dms.atos(achieve_data, achievement_mould.achievement_reward), "|")
                        state_machine.excute("task_detail_open", 0, {task_info,achievement_reward})
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(task_daily_list_window_show_terminal) 
        state_machine.add(task_daily_list_window_hide_terminal)
        state_machine.add(task_daily_list_update_listview_terminal)
        state_machine.add(task_daily_change_page_terminal)
        state_machine.add(task_daily_list_get_reward_terminal)
        state_machine.add(task_daily_list_show_info_terminal)
        state_machine.init()
    end

    init_task_daily_list_terminal()
end

function TaskDailyList:onHide()
    self:setVisible(false)
end

function TaskDailyList:onShow()
    self:setVisible(true)
end

function TaskDailyList:changeSelectPage( page )
    local root = self.roots[1]
    local Button_task_daily_battle = ccui.Helper:seekWidgetByName(root, "Button_task_daily_battle")
    local Button_task_daily_legion = ccui.Helper:seekWidgetByName(root, "Button_task_daily_legion")
    local Button_task_daily_develop = ccui.Helper:seekWidgetByName(root, "Button_task_daily_develop")
    local Button_task_daily_privilege = ccui.Helper:seekWidgetByName(root, "Button_task_daily_privilege")
    Button_task_daily_battle:setHighlighted(false)
    Button_task_daily_legion:setHighlighted(false)
    Button_task_daily_develop:setHighlighted(false)
    Button_task_daily_privilege:setHighlighted(false)
    if page == 1 then
        Button_task_daily_battle:setHighlighted(true)
    elseif page == 2 then
        Button_task_daily_legion:setHighlighted(true)
    elseif page == 3 then
        Button_task_daily_develop:setHighlighted(true)
    else
        Button_task_daily_privilege:setHighlighted(true)
    end
    if page == self._current_page then
        return
    end
    self._current_page = page
    self:onUpdateDraw()
end

function TaskDailyList:updateListInfo( ... )
    local root = self.roots[1]
    local task_type = self._current_page + 3
    self.listview:jumpToTop()

    local goings = {}
    local result = {}
    local overs = {}
    local index = 1
    for k, v in pairs(_ED.user_task_infos["1"]) do
        if v.little_type == task_type then 
            if zstring.tonumber(v.task_state) == 0 then
                table.insert(goings, v)
            elseif zstring.tonumber(v.task_state) == 1 then
                table.insert(result, v)
            elseif zstring.tonumber(v.task_state) == 2 then
                table.insert(overs, v)
            end
            index = index + 1
        end
    end
    for k,v in pairs(goings) do
        table.insert(result, v)
    end
    for k,v in pairs(overs) do
        table.insert(result, v)
    end

    local items = self.listview:getItems()
    for k,v in pairs(items) do
        state_machine.excute("task_daily_cell_update_info", 0, {cell = v, index = k, task_data = result[k], task_type = self._current_page})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            self.listview:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("task_daily_create_cell",0, {self._current_page, result[i], i})
            self.listview:addChild(cell)
        end
    end

    self.listview:requestRefreshView()
    self.listview_poy = self.listview:getInnerContainer():getPositionY()
    self.listview_height = self.listview:getInnerContainer():getPositionY()
end

function TaskDailyList:onUpdateDraw()
    local root = self.roots[1]
    local task_type = self._current_page + 3
    local Text_task_infor_1 = ccui.Helper:seekWidgetByName(root, "Text_task_infor_1")
    local Text_task_infor_2 = ccui.Helper:seekWidgetByName(root, "Text_task_infor_2")
    local Button_task_infor = ccui.Helper:seekWidgetByName(root, "Button_task_infor")
    local Button_task_daily_receive = ccui.Helper:seekWidgetByName(root, "Button_task_daily_receive")
    local Text_task_speed = ccui.Helper:seekWidgetByName(root, "Text_task_speed")
    Text_task_infor_1:setVisible(false)
    Text_task_infor_2:setVisible(false)
    Text_task_infor_2:removeAllChildren(true)
    Button_task_infor:setVisible(false)
    Button_task_daily_receive:setVisible(false)
    Text_task_speed:setVisible(false)
    Text_task_speed:removeAllChildren(true)
    Button_task_daily_receive:setBright(true)
    Button_task_daily_receive:setTouchEnabled(true)

    if _ED.user_task_infos["8"] ~= nil then
        for k,task_info in pairs(_ED.user_task_infos["8"]) do
            if task_info.little_type == task_type then 
                Text_task_infor_1:setVisible(true)
                Text_task_infor_2:setVisible(true)
                Button_task_infor:setVisible(true)
                Text_task_speed:setVisible(true)
                Button_task_daily_receive:setVisible(true)
                Button_task_daily_receive:setTitleText(red_alert_all_str[170])
                local achieve_data = dms.element(dms["achievement_mould"],task_info.achieve_mould_id)
                -- 奖励
                local achievement_reward = dms.atos(achieve_data,achievement_mould.achievement_reward)
                achievement_reward = zstring.split(achievement_reward,"|")
                local str_table = {}
                local pic_index = nil
                local prop_name = nil
                local info = {}
                for i,v in pairs(achievement_reward) do
                    local temp_tab = zstring.split(v,",")
                    if tonumber(temp_tab[1]) <= 0 then
                        prop_name = dms.string(dms["prop_mould"], resource_prop_id[tonumber(temp_tab[2])], prop_mould.prop_name)
                        pic_index = dms.string(dms["prop_mould"], resource_prop_id[tonumber(temp_tab[2])], prop_mould.pic_index)
                        pic_index = zstring.split(pic_index, ",")
                    else
                        if tonumber(temp_tab[2]) == 6 then
                            prop_name = dms.string(dms["prop_mould"], temp_tab[1], prop_mould.prop_name)
                            pic_index = dms.string(dms["prop_mould"], temp_tab[1], prop_mould.pic_index)
                            pic_index = zstring.split(pic_index, ",")
                        else
                            prop_name = dms.string(dms["ship_mould"], temp_tab[1], ship_mould.captain_name)
                            pic_index = dms.string(dms["ship_mould"], temp_tab[1], ship_mould.head_icon)
                            pic_index = zstring.split(pic_index, ",")
                        end
                    end
                    info = {prop_name,pic_index[2],exChangeNumToString(temp_tab[3])}
                    table.insert(str_table, info)
                end
                local _richText_1 = ccui.RichText:create()
                _richText_1:ignoreContentAdaptWithSize(false) 
                for i1,v1 in pairs(str_table) do
                    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[v1[2]+1][1],color_Type[v1[2]+1][2],color_Type[v1[2]+1][3]),255, "  "..v1[1], "fonts/simhei.ttf",20)
                    _richText_1:pushBackElement(re1)  
                    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "+"..v1[3], "fonts/simhei.ttf",20)
                    _richText_1:pushBackElement(re2)
                end
                _richText_1:setPosition(cc.p(Text_task_infor_2:getContentSize().width/2,Text_task_infor_2:getContentSize().height/2))
                _richText_1:setContentSize(cc.size(Text_task_infor_2:getContentSize().width,20))
                Text_task_infor_2:addChild(_richText_1)

                local task_complete_count = zstring.tonumber(task_info.task_complete_count)
                local need_complete_count = zstring.tonumber(task_info.need_complete_count)
                local task_state = zstring.tonumber(task_info.task_state)
                local _richText_2 = ccui.RichText:create()
                _richText_2:ignoreContentAdaptWithSize(false) 
                local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_all_str[127], "fonts/simhei.ttf",20)
                _richText_2:pushBackElement(re1)  
                local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, exChangeNumToString(task_complete_count), "fonts/simhei.ttf",20)
                _richText_2:pushBackElement(re2)
                local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "/"..exChangeNumToString(need_complete_count), "fonts/simhei.ttf",20)
                _richText_2:pushBackElement(re3)
                _richText_2:ignoreAnchorPointForPosition(true)
                local info = red_alert_all_str[127]..exChangeNumToString(task_complete_count).."/"..exChangeNumToString(need_complete_count)
                local len_size = 0
                local map = string.utf8.chars(info)
                for i,v in pairs(map) do
                    local len = string.len(v)
                    if string.len(v) > 1 then
                        len = string.len(v) - 1
                    end
                    len_size = len_size + len
                end
                _richText_2:setPosition(cc.p(Text_task_speed:getContentSize().width-len_size*11.375,Text_task_speed:getContentSize().height/2))

                local str = ""..red_alert_all_str[127]..exChangeNumToString(task_complete_count).."/"..exChangeNumToString(need_complete_count)
                local len = 0
                local map = string.utf8.chars(str)
                for k, v in pairs(map) do
                    if string.len(v) == 1 then
                        len = len + 1
                    else
                        len = len + 2
                    end
                end
                len = math.ceil(len)
                local width = len * 10
                _richText_2:setContentSize(cc.size(Text_task_speed:getContentSize().width,20))
                _richText_2:setAnchorPoint(0, 0.5)
                _richText_2:setPosition(cc.p(Text_task_speed:getContentSize().width / 2 - width + 5,Text_task_speed:getContentSize().height/2))
                Text_task_speed:addChild(_richText_2)

                -- 按钮状态
                if task_complete_count >= need_complete_count then
                    Button_task_daily_receive:setBright(true)
                    Button_task_daily_receive:setTouchEnabled(true)
                else
                    Button_task_daily_receive:setBright(false)
                    Button_task_daily_receive:setTouchEnabled(false)
                end
                if task_state == 2 then
                    Button_task_daily_receive:setBright(false)
                    Button_task_daily_receive:setTouchEnabled(false)
                    Button_task_daily_receive:setTitleText(red_alert_all_str[55])
                end
            end
        end
    end
    if _ED.user_task_infos["1"] == nil then
        return
    end
    -- local ListView_task_main = ccui.Helper:seekWidgetByName(root, "ListView_task_mine")
    -- ListView_task_main:jumpToTop()
    -- ListView_task_main:removeAllItems()

    -- local cells = {}
    -- local finish_cells = {}
    -- local over_cells = {}
    -- local index = 1
    -- for k, v in pairs(_ED.user_task_infos["1"]) do
    --     if v.little_type == task_type then 
    --         local cell = state_machine.excute("task_daily_create_cell",0, {self._current_page, v, index})
    --         if zstring.tonumber(v.task_state) == 0 then
    --             table.insert(cells, cell)
    --         elseif zstring.tonumber(v.task_state) == 1 then
    --             table.insert(finish_cells, cell)
    --         elseif zstring.tonumber(v.task_state) == 2 then
    --             table.insert(over_cells, cell)
    --         end
    --         index = index + 1
    --     end
    -- end
    -- for i,cell in pairs(finish_cells) do
    --     ListView_task_main:addChild(cell)
    -- end
    -- for i,cell in pairs(cells) do
    --     ListView_task_main:addChild(cell)
    -- end
    -- for i,cell in pairs(over_cells) do
    --     ListView_task_main:addChild(cell)
    -- end

    -- ListView_task_main:requestRefreshView()
    -- self.listview = ListView_task_main
    -- self.listview_poy = ListView_task_main:getInnerContainer():getPositionY()
    -- self.listview_height = ListView_task_main:getInnerContainer():getPositionY()
    self:updateListInfo()
end

function TaskDailyList:onUpdate(dt)
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

function TaskDailyList:onEnterTransitionFinish()

end

function TaskDailyList:onInit( )
    local csbItem = csb.createNode(config_csb.task.task_daily_tab)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_task_daily_battle"), nil, 
    {
        terminal_name = "task_daily_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_task_button_fight",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_task_daily_battle"),
    _invoke = nil,
    _interval = 0.2,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_task_daily_legion"), nil, 
    {
        terminal_name = "task_daily_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_task_button_legion",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_task_daily_legion"),
    _invoke = nil,
    _interval = 0.2,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_task_daily_develop"), nil, 
    {
        terminal_name = "task_daily_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_task_button_grow",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_task_daily_develop"),
    _invoke = nil,
    _interval = 0.2,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_task_daily_privilege"), nil, 
    {
        terminal_name = "task_daily_change_page", 
        terminal_state = 0, 
        _page = 4,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_task_button_privilege",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_task_daily_privilege"),
    _invoke = nil,
    _interval = 0.2,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_task_infor"), nil, 
    {
        terminal_name = "task_daily_list_show_info", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_task_daily_receive"), nil, 
    {
        terminal_name = "task_daily_list_get_reward", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    self._Image_player_build_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_production_arrow_down")
    self._Image_player_build_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_production_arrow_up")
    
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

    self.listview = ccui.Helper:seekWidgetByName(root, "ListView_task_mine")
    self.listview:removeAllItems()

    self:changeSelectPage(1)
end

function TaskDailyList:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow      
    self:onInit()
    return self
end

function TaskDailyList:onExit()
    state_machine.remove("task_daily_list_window_show") 
    state_machine.remove("task_daily_list_window_hide")
    state_machine.remove("task_daily_list_update_listview")
    state_machine.remove("task_daily_change_page")
    state_machine.remove("task_daily_list_show_info")
    state_machine.remove("task_daily_list_get_reward")
end