----------------------------------------------------------------------------------------------------
-- 说明：七天乐列表
-------------------------------------------------------------------------------------------------------
SevenHappyRegressionPage = class("SevenHappyRegressionPageClass", Window)
app.load("client.cells.activity.every_day_welfare_list_cell") 
function SevenHappyRegressionPage:ctor()
    self.super:ctor()
    self.roots = {}

    app.load("client/l_digital/cells/activity/wonderful/sm_activity_7day_regression_reward_cell")

    self.dayIndex = -1
    self._controlers = {}

    local function init_seven_days_regression_welfare_terminal()
        
        -- 切换左侧天数标签
        local seven_happy_regression_page_change_day_terminal = {
            _name = "seven_happy_regression_page_change_day",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local day_index = params._datas._day_index

                -- 未开启提示
                if tonumber(day_index) > tonumber(params._datas._day_count) then
                    TipDlg.drawTextDailog(string.format(_new_interface_text[311], day_index))
                    return false
                end

                for i = 1, 7 do
                    local Image_day = ccui.Helper:seekWidgetByName(instance.roots[1], string.format("Image_day_%d_0", i))
                    if Image_day ~= nil then
                        Image_day:setVisible(false)
                    end
                end

                local Image_day_now = ccui.Helper:seekWidgetByName(instance.roots[1], string.format("Image_day_%d_0", day_index))
                if Image_day_now ~= nil then
                    Image_day_now:setVisible(true)
                end

                state_machine.excute("seven_happy_regression_remove_last_reward", 0, nil)
                self:onUpdateDrawEx(day_index)

                fwin:addService({
                    callback = function ( params )
                        state_machine.excute("notification_center_update", 0, "push_notification_seven_day_regression_page_push")
                    end,
                    delay = 0,
                })

               return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 切换右侧标签
        local seven_happy_regression_page_change_tab_page_terminal = {
            _name = "seven_happy_regression_page_change_tab_page",
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

        -- 点击终极奖励，隐藏任务列表，或点击天数，移除终极奖励
        local seven_happy_regression_page_change_last_reward_state_terminal = {
            _name = "seven_happy_regression_page_change_last_reward_state",
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

        state_machine.add(seven_happy_regression_page_change_day_terminal)
        state_machine.add(seven_happy_regression_page_change_tab_page_terminal)
        state_machine.add(seven_happy_regression_page_change_last_reward_state_terminal)
        state_machine.init()
    end
    
    init_seven_days_regression_welfare_terminal()
end

-- 显示或隐藏列表
function SevenHappyRegressionPage:changeLastState(isShow)
    local root = self.roots[1]
    if root ~= nil then
        local ListView_meirifuli = ccui.Helper:seekWidgetByName(root, "ListView_meirifuli")
        ListView_meirifuli:setVisible(isShow)

        for i = 1, 3 do
            ccui.Helper:seekWidgetByName(root, "Button_7_tab_"..i):setVisible(isShow)
        end

        if isShow == false then
            local ListView_123 = ccui.Helper:seekWidgetByName(root, "ListView_123")
            local items = ListView_123:getItems()
            for i = 1, #items do
                local Image_day = ccui.Helper:seekWidgetByName(root, "Image_day_"..i.."_0")
                Image_day:setVisible(false)
            end
        end
    end
end

function SevenHappyRegressionPage:initListView()
    local root = self.roots[1]
    local ListView_123 = ccui.Helper:seekWidgetByName(root, "ListView_123")
    local items = ListView_123:getItems()

    -- 后端传过来的是0，加1，表示第一天
    local nowDayCount = tonumber(self.userData.curDay)

    for i, v in pairs(items) do 
        local button = v
        local day = i
        fwin:addTouchEventListener(button, nil, 
        {
            terminal_name = "seven_happy_regression_page_change_day",      
            terminal_state = 0,
            _day_index = day,
            _day_count = nowDayCount,
            isPressedActionEnabled = true
        }, 
        nil, 0)
        -- TODO:
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_seven_day_regression_day_push",
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
    end

    for i = 1, 3 do
        local controlButton = ccui.Helper:seekWidgetByName(root, "Button_7_tab_" .. i)
        fwin:addTouchEventListener(controlButton, nil, 
        {
            terminal_name = "seven_happy_regression_page_change_tab_page",      
            terminal_state = 0,
            selector_index = i
        }, 
        nil, 0)
        -- TODO:
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_seven_day_regression_page_push",
            _widget = controlButton,
            _invoke = nil,
            pageIndex = i,
            _interval = 0.5,})
    end

end

function SevenHappyRegressionPage:onUpdate( dt )
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_ContainerPosY == posY then
            return
        end
        self.listview_ContainerPosY = posY
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

function SevenHappyRegressionPage:onUpdateDrawEx(dayIndex, selectorIndex, isboolen)
    local root = self.roots[1]

    local current_controler = self._controlers[dayIndex]
    if current_controler == nil then
        return
    end

    if self.dayIndex == dayIndex 
        and self._current_controler == current_controler
        and selectorIndex == current_controler.selector_index 
        then
        return
    end

    if nil == selectorIndex then
        if current_controler.selector_index < 1 then
            current_controler.selector_index = 1
        end
        selectorIndex = current_controler.selector_index
    else
        current_controler.selector_index = selectorIndex
    end

    self._current_controler = current_controler

    -- 标签页显示
    for i = 1, 3 do
        local controlButton = ccui.Helper:seekWidgetByName(root, "Button_7_tab_" .. i)
        if nil == self._current_controler.selector or i == selectorIndex then
            self._current_controler.selector = controlButton
        end
        controlButton:setHighlighted(false)
        controlButton:setTouchEnabled(true) 

        -- 标签页的数据
        local tabData = self._current_controler.data[i]

        if nil == tabData then
            controlButton:setVisible(false)
        else
            controlButton:setVisible(true)
            local Text_tabbtn_name = ccui.Helper:seekWidgetByName(root, "Text_tabbtn_name_" .. i)

            local name = tonumber(tabData[1][1])
            Text_tabbtn_name:setString(tipStringInfo_seven_happy_task_name[name])
        end
    end

    self._current_controler.selector:setHighlighted(true)
    self._current_controler.selector:setTouchEnabled(false)

    self.dayIndex = dayIndex
    
    -- 任务列表
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_meirifuli")
    listView:jumpToTop()
    listView:removeAllItems()

    -- 当前标签页下的所有任务的数据，第1个数据是标签页的名称，从第2个数据开始是有效的任务数据
    local item_group = {}
    local tabData = self._current_controler.data[selectorIndex]
    for i = 2, #tabData do
        -- 每一个cell的数据
        local cellData = tabData[i]
        local cell = state_machine.excute("sm_activity_regression_7day_reward_cell", 0, {{id = cellData[1], data = cellData, pageIndex = selectorIndex, drawIndex = i - 1, dayIndex = self.dayIndex, userData = self.userData}})
        table.insert(item_group, cell)
    end

    item_group = self:sortListItems(item_group)

    local mm_index = 0
    for k, cell in pairs(item_group) do
        mm_index = mm_index + 1

        if isboolen ~= nil and isboolen == true then
            state_machine.excute("sm_activity_7day_regression_reward_cell_set_number", 0, {cell,mm_index, isboolen})
            cell:setVisible(true)
        else
            state_machine.excute("sm_activity_7day_regression_reward_cell_set_number", 0, {cell, mm_index})
            cell:setVisible(false)
            cell:setScale(1.3)
            cell:setAnchorPoint(cc.p(0.5,0.5))
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
                params.listview_ContainerPosY = listView:getInnerContainer():getPositionY() + 1
            end
        end,
        delay = 0,
        params = self
    })

end

function SevenHappyRegressionPage:sortListItems(items)
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

function SevenHappyRegressionPage:onEnterTransitionFinish()
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local nowDayCount = tonumber(self.userData.curDay)
        state_machine.excute("seven_happy_regression_page_change_day", 0, {
            _datas = {
                terminal_name = "seven_happy_regression_page_change_day",      
                terminal_state = 0,
                _day_index = 1,
                _day_count = nowDayCount,
                isPressedActionEnabled = true
            }
        })
    end
end

function SevenHappyRegressionPage:onInit()
    local csbSevenHappyRegressionPage = csb.createNode("activity/user_return/user_return_7days_page.csb")
    self:addChild(csbSevenHappyRegressionPage)
    local root = csbSevenHappyRegressionPage:getChildByName("root")
    table.insert(self.roots, root)
    self:initListView()
end

function SevenHappyRegressionPage:onExit()
    state_machine.remove("seven_happy_regression_page_change_day")
    state_machine.remove("seven_happy_regression_page_change_tab_page")
    state_machine.remove("seven_happy_regression_page_change_last_reward_state")
end

function SevenHappyRegressionPage:init(dayIndex)
    self.dayIndex = dayIndex

    local configStr = _ED.active_activity[166].need_recharge_count
    local configJson = json.decode(configStr)

    self.configData = {}

    for i = 1, #configJson do
        local dayData = configJson[i]
        for j = 1, #dayData do
            local data = dayData[j]
            local t = zstring.splits(data, "@", ",")
            self.configData[i] = self.configData[i] or {}
            self.configData[i][j] = t
        end
    end

    local userStr = _ED.active_activity[166].activity_params
    self.userData = json.decode(userStr)

    for i, v in pairs(self.configData) do
        table.insert(self._controlers, 
        {
            data = v,
            page_index = i,
            selector_index = -1,
            selector = nil,
        })
    end

    self:onInit()
end
