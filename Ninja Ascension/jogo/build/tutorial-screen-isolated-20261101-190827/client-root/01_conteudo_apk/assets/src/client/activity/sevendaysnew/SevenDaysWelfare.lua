----------------------------------------------------------------------------------------------------
-- 说明：七日活动每日福利列表
-------------------------------------------------------------------------------------------------------
SevenDaysWelfare = class("SevenDaysWelfareClass", Window)
app.load("client.cells.activity.every_day_welfare_list_cell") 
function SevenDaysWelfare:ctor()
    self.super:ctor()
    self.roots = {}

    -- load lua files
    app.load("client/l_digital/cells/activity/wonderful/sm_activity_carnival_reward_cell")

    -- var
    self.dayIndex = -1
    self._controlers = {}

    -- Initialize seven days activity for every day welfare page state machine.
    local function init_seven_days_welfare_terminal()
        
        --改变天数
        local seven_days_welfare_change_day_terminal = {
            _name = "seven_days_welfare_change_day",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local day_index = params._datas._day_index

                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                    or __lua_project_id == __lua_project_l_naruto 
                    then
                    if day_index > params._datas._day_count then
                        local day = tonumber(day_index) - tonumber(params._datas._day_count)
                        local temp = os.date("*t", getBaseGTM8Time(_ED.system_time + (os.time() - _ED.native_time)))
                        local m_hour    = tonumber(string.format("%02d", temp.hour))
                        local m_min     = tonumber(string.format("%02d", temp.min))
                        local m_sec     = tonumber(string.format("%02d", temp.sec))
                        local newTimes = day * 24 * 3600 - ((m_hour)*3600 + m_min*60 + m_sec + _ED.system_time - _ED.native_time)
                        local timeString = ""
                        local now_time = math.floor(newTimes)
                        local day = math.floor(now_time/86400)
                        if day > 0 then
                            now_time = math.floor(now_time%86400)
                        end
                        local hour = string.format("%02d", math.floor(now_time/3600))
                        local minute = string.format("%02d", math.floor((now_time%3600)/60))
                        if now_time > 0 and now_time < 60 then
                            minute = 1
                        end
                        if day > 0 then
                            timeString = timeString .. day ..tipStringInfo_mine_info[4]
                        end
                        if day <= 0 and tonumber(hour) <= 0 then
                        else
                            timeString = timeString .. hour ..tipStringInfo_mine_info[5]
                        end
                        timeString = timeString .. minute ..tipStringInfo_mine_info[6]

                        TipDlg.drawTextDailog(string.format(_new_interface_text[88], timeString))
                        return false
                    end
                end

                for i=1, 7 do
                    local Image_day = ccui.Helper:seekWidgetByName(instance.roots[1],string.format("Image_day_%d_0",i))
                    if Image_day ~= nil then
                        Image_day:setVisible(false)
                    end
                end

                local Image_day_now = ccui.Helper:seekWidgetByName(instance.roots[1],string.format("Image_day_%d_0",day_index))
                if Image_day_now ~= nil then
                    Image_day_now:setVisible(true)
                end

                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    state_machine.excute("seven_days_remove_last_reward", 0, nil)
                    self:onUpdateDrawEx(day_index)
                else
                    state_machine.excute("seven_days_change_day",0,day_index)
                end
               return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --改变天数图片选中
        local seven_days_walfare_change_image_day_terminal = {
            _name = "seven_days_walfare_change_image_day",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                else
                    local day_index = params
                    for i=1, 7 do
                        local Image_day = ccui.Helper:seekWidgetByName(instance.roots[1],string.format("Image_day_%d_0",i))
                        Image_day:setVisible(false)
                    end
                    local Image_day_now = ccui.Helper:seekWidgetByName(instance.roots[1],string.format("Image_day_%d_0",day_index))
                    Image_day_now:setVisible(true)
                end
               return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 切换福利子页面
        local seven_days_welfare_change_tab_page_terminal = {
            _name = "seven_days_welfare_change_tab_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local selector_index = nil
                if params ~= nil and params._datas ~= nil and params._datas.selector_index ~= nil then 
                    selector_index = params._datas.selector_index
                end
                if params ~= nil and params[1] == true then
                    instance:onUpdateDrawEx(instance.dayIndex, selector_index, true)
                else
                    instance:onUpdateDrawEx(instance.dayIndex, selector_index)
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local seven_days_welfare_change_last_reward_state_terminal = {
            _name = "seven_days_welfare_change_last_reward_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeLastState(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(seven_days_welfare_change_day_terminal)
        state_machine.add(seven_days_walfare_change_image_day_terminal)
        state_machine.add(seven_days_welfare_change_tab_page_terminal)
        state_machine.add(seven_days_welfare_change_last_reward_state_terminal)
        state_machine.init()
    end
    
    -- call func init_seven_days_welfare_terminal state machine.
    init_seven_days_welfare_terminal()
end

function SevenDaysWelfare:changeLastState( isShow )
    local root = self.roots[1]
    if root ~= nil then
        local ListView_meirifuli = ccui.Helper:seekWidgetByName(root, "ListView_meirifuli")
        ListView_meirifuli:setVisible(isShow)
        for i=1,3 do
            ccui.Helper:seekWidgetByName(root, "Button_7_tab_"..i):setVisible(isShow)
        end
        if isShow == false then
            local ListView_123 = ccui.Helper:seekWidgetByName(root,"ListView_123")
            local items = ListView_123:getItems()
            for i=1,#items do
                local Image_day = ccui.Helper:seekWidgetByName(root, "Image_day_"..i.."_0")
                Image_day:setVisible(false)
            end
        end
    end
end

function SevenDaysWelfare:initListView()
    local root = self.roots[1]
    local ListView_123 = ccui.Helper:seekWidgetByName(root,"ListView_123")
    local items = ListView_123:getItems()

    local activity = _ED.active_activity[42]
    local nowDayCount = zstring.tonumber(activity.activity_day_count)

    for i,v in pairs(items) do 
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
            then
            local button = v
            local day = i
            fwin:addTouchEventListener(button,nil, 
            {
                terminal_name = "seven_days_welfare_change_day",      
                terminal_state = 0,
                _day_index = day,
                _day_count = nowDayCount,
                isPressedActionEnabled = true
            }, 
            nil, 0)

            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_new_everydays_recharge",
                _widget = button,
                _invoke = nil,
                dayIndex = day,
                _interval = 0.5,})

            local Image_day_lock = ccui.Helper:seekWidgetByName(root, "Image_day_lock_" .. i)
            if nil ~= Image_day_lock then
                if nowDayCount >= day then
                    Image_day_lock:setVisible(false)
                else
                    Image_day_lock:setVisible(true)
                end
            end
        else
            if i > 1 then
                local button = v
                local day = i - 1
                fwin:addTouchEventListener(button,nil, 
                {
                    terminal_name = "seven_days_welfare_change_day",      
                    terminal_state = 0,
                    _day_index = day,
                    isPressedActionEnabled = true
                }, 
                nil, 0)
                state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_new_everydays_recharge",
                _widget = button,
                _invoke = nil,
                dayIndex = day,
                _interval = 0.5,})        
            end
        end
    end

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        for i = 1, 3 do
            local controlButton = ccui.Helper:seekWidgetByName(root, "Button_7_tab_" .. i)
            fwin:addTouchEventListener(controlButton,nil, 
            {
                terminal_name = "seven_days_welfare_change_tab_page",      
                terminal_state = 0,
                selector_index = i
            }, 
            nil, 0)
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_activity_everydays_page_push",
                _widget = controlButton,
                _invoke = nil,
                pageIndex = i,
                _interval = 0.5,})
        end
        -- state_machine.excute("seven_days_welfare_change_day", 0, {
        --     _datas = {
        --         terminal_name = "seven_days_welfare_change_day",      
        --         terminal_state = 0,
        --         _day_index = 1,
        --         _day_count = nowDayCount,
        --         isPressedActionEnabled = true
        --     }
        -- })
    end
end

function SevenDaysWelfare:onUpdate( dt )
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_ContainerPosY == posY then
            return
        end
        self.listview_ContainerPosY = posY
        -- self.listview_ContainerPos.y = posY
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

function SevenDaysWelfare:onUpdateDrawEx(dayIndex, selectorIndex,isboolen)

    local root = self.roots[1]

    local current_controler = self._controlers[dayIndex]

    -- print(".........1>>>>", self.dayIndex, dayIndex, selectorIndex, current_controler.selector_index)
    if self.dayIndex == dayIndex 
        and self._current_controler == current_controler
        and selectorIndex == current_controler.selector_index 
        then
        return
    end

    -- print(".........2>>>>", self.dayIndex, dayIndex, selectorIndex, current_controler.selector_index)


    if nil == selectorIndex then
        if current_controler.selector_index < 1 then
            current_controler.selector_index = 1
        end
        selectorIndex = current_controler.selector_index
    else
        current_controler.selector_index = selectorIndex
    end

    self._current_controler = current_controler
    -- print(".........3>>>>", self.dayIndex, dayIndex, selectorIndex, current_controler.selector_index)

    local names = zstring.split(dms.atos(self._current_controler.data, carnival_mould.page_name), ",")


    for i = 1, 3 do
        local controlButton = ccui.Helper:seekWidgetByName(root, "Button_7_tab_" .. i)
        if nil == self._current_controler.selector or i == selectorIndex then
            self._current_controler.selector = controlButton
        end
        controlButton:setHighlighted(false)
        controlButton:setTouchEnabled(true) 

        if nil == names[i] then
            controlButton:setVisible(false)
        else
            controlButton:setVisible(true)
            local Text_tabbtn_name = ccui.Helper:seekWidgetByName(root, "Text_tabbtn_name_" .. i)
            Text_tabbtn_name:setString(names[i])
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_naruto then
                if i == selectorIndex then
                    if __lua_project_id == __lua_project_l_naruto then
                        Text_tabbtn_name:setColor(cc.c3b(10, 25, 57))
                    else
                        Text_tabbtn_name:setColor(cc.c3b(255, 255, 255))
                    end
                else
                    Text_tabbtn_name:setColor(cc.c3b(164, 169, 177))
                end
            elseif __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                Text_tabbtn_name:setColor(cc.c3b(255, 255, 255))
            else
                if i == selectorIndex then
                    Text_tabbtn_name:setColor(cc.c3b(255, 255, 255))
                else
                    Text_tabbtn_name:setColor(cc.c3b(100, 195, 255))
                end
            end
        end
    end

    self._current_controler.selector:setHighlighted(true)
    self._current_controler.selector:setTouchEnabled(false)


    self.dayIndex = dayIndex
    
    state_machine.excute("notification_center_update", 0, "push_notification_activity_everydays_page_push")
    state_machine.excute("notification_center_update", 0, "push_notification_new_everydays_recharge")

    local listView = ccui.Helper:seekWidgetByName(root, "ListView_meirifuli")
    listView:jumpToTop()
    listView:removeAllItems()

    local ids = zstring.splits(dms.atos(self._current_controler.data, carnival_mould.achive), "|", ",")[selectorIndex]
    local item_group = {}
    for i, v in pairs(ids) do
        local cell = state_machine.excute("sm_activity_carnival_reward_cell", 0, {{id = v, carnivalMouldId = dms.atos(self._current_controler.data, carnival_mould.id), pageIndex = selectorIndex, drawIndex = i, dayIndex = self.dayIndex}})
        table.insert(item_group, cell)
    end
    item_group = self:sortListItems(item_group)
    local mm_index = 0
    for k, cell in pairs(item_group) do
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            mm_index = mm_index + 1
            if isboolen ~= nil and isboolen == true then
                state_machine.excute("sm_activity_carnival_reward_cell_set_number", 0, {cell,mm_index,isboolen})
                cell:setVisible(true)
            else
                state_machine.excute("sm_activity_carnival_reward_cell_set_number", 0, {cell,mm_index})
                cell:setVisible(false)
                cell:setScale(1.3)
                cell:setAnchorPoint(cc.p(0.5,0.5))
            end
        end
        listView:addChild(cell)
    end
    listView:requestRefreshView()

    self.listview = listView
    self.listview_ContainerPosY = listView:getInnerContainer():getPositionY()
    fwin:addService({
        callback = function ( params )
            if params.listview ~= nil then
                params.listview:requestRefreshView()
                -- listView:getInnerContainer():setPositionY(self._current_controler.list_view_pos[selectorIndex].y)
                -- self.listview_ContainerPos = self._current_controler.list_view_pos[selectorIndex]
                -- self.listview_ContainerPosY = self._current_controler.list_view_pos[selectorIndex].y + 1
                params.listview_ContainerPosY = listView:getInnerContainer():getPositionY() + 1
            end
        end,
        delay = 0,
        params = self
    })
end

function SevenDaysWelfare:sortListItems(items)
    local result = {}
    local closeItems = {}       -- 已完成
    local drawItems = {}            -- 可领取
    local uncompItems = {}      -- 未完成
    for k, v in pairs(items) do
        if tonumber(v.rewardState) == 0 then
            table.insert(uncompItems, v)
        elseif tonumber(v.rewardState) == 1 then
            table.insert(drawItems, v)
        else
            table.insert(closeItems, v)
        end
    end
    for k, v in pairs(drawItems) do
        table.insert(result, v)
    end
    for k, v in pairs(uncompItems) do
        table.insert(result, v)
    end
    for k, v in pairs(closeItems) do
        table.insert(result, v)
    end

    return result
end

function SevenDaysWelfare:onUpdateDraw(dayIndex)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then

    else
        self.dayIndex = dayIndex
        local root = self.roots[1]
        local listView = ccui.Helper:seekWidgetByName(root, "ListView_meirifuli")
        listView:removeAllItems()
        
        local welfares = _ED.active_activity[42].seven_days_rewards[self.dayIndex].welfare
        local number = #welfares
        local uncompItems = {}
        local drawItems = {}
        local closeItems = {}
        for i, v in pairs(welfares) do
            if i == number then
                -- debug.print_r(welfares)
                local cell = EveryDayWelfareListCell:createCell()
                local tcell, drawState = cell:init(i, self.dayIndex, v, listView)
                if drawState == 0 then
                    table.insert(uncompItems, cell)
                elseif drawState == 1 then
                    table.insert(drawItems, cell)
                elseif drawState == 2 then
                    table.insert(closeItems, cell)
                end
            end
        end
        for i, v in pairs(drawItems) do
            listView:addChild(v)
        end
        for i, v in pairs(uncompItems) do
            listView:addChild(v)
        end
        for i, v in pairs(closeItems) do
            listView:addChild(v)
        end
        listView:requestRefreshView()
    end
end

function SevenDaysWelfare:onEnterTransitionFinish()
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local activity = _ED.active_activity[42]
        local nowDayCount = zstring.tonumber(activity.activity_day_count)
        state_machine.excute("seven_days_welfare_change_day", 0, {
            _datas = {
                terminal_name = "seven_days_welfare_change_day",      
                terminal_state = 0,
                _day_index = 1,
                _day_count = nowDayCount,
                isPressedActionEnabled = true
            }
        })
    end
end

function SevenDaysWelfare:onInit()
    local csbSevenDaysWelfare = csb.createNode("activity/7days/week_Activities_page_2.csb")
    self:addChild(csbSevenDaysWelfare)
    local root = csbSevenDaysWelfare:getChildByName("root")
    table.insert(self.roots, root)
    self:initListView()
end

function SevenDaysWelfare:onExit()
    state_machine.remove("seven_days_welfare_change_day")
    state_machine.remove("seven_days_walfare_change_image_day")
    state_machine.remove("seven_days_welfare_change_tab_page")
    state_machine.remove("seven_days_welfare_change_last_reward_state")
end

function SevenDaysWelfare:init(dayIndex)
    self.dayIndex = dayIndex

    for i, v in pairs(dms["carnival_mould"]) do
        table.insert(self._controlers, 
        {
            data = v,
            page_index = i,
            selector_index = -1,
            selector = nil,
            list_view_pos = {cc.p(0, 0),cc.p(0, 0),cc.p(0, 0)},
        })
    end

    self:onInit()
end
