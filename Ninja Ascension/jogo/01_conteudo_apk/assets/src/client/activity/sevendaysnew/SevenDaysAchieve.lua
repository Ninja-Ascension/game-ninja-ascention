----------------------------------------------------------------------------------------------------
-- 说明：七日活动每日成就列表
-------------------------------------------------------------------------------------------------------
SevenDaysAchieve = class("SevenDaysAchieveClass", Window)
app.load("client.cells.activity.every_day_achievement_list_cell_new")
function SevenDaysAchieve:ctor()
    self.super:ctor()
    self.roots = {}

    self.activity = _ED.active_activity[42]

    self.dayIndex = 0
    self.list_view = nil
	self.list_view_posY = nil

    self.list_views = 
    {
        one,
        two,
        three,
        four,
        five,
        six,
        seven
    }
    -- Initialize seven days activity for every day achievement page state machine.
    local function init_seven_days_achieve_terminal()
        --改变天数
        local seven_days_achieve_change_day_terminal = {
            _name = "seven_days_achieve_change_day",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local day_index = params._datas._day_index
                for i=1, 7 do
                    local Image_day = ccui.Helper:seekWidgetByName(instance.roots[1],string.format("Image_day_%d_0",i))
                    Image_day:setVisible(false)
                end
                local Image_day_now = ccui.Helper:seekWidgetByName(instance.roots[1],string.format("Image_day_%d_0",day_index))
                Image_day_now:setVisible(true)

                state_machine.excute("seven_days_change_day",0,day_index)
               return true
            end,
            _terminal = nil,
            _terminals = nil
        }
                        --改变天数图片选中
        local seven_days_achieve_change_image_day_terminal = {
            _name = "seven_days_achieve_change_image_day",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local day_index = params
                for i=1, 7 do
                    local Image_day = ccui.Helper:seekWidgetByName(instance.roots[1],string.format("Image_day_%d_0",i))
                    Image_day:setVisible(false)
                end
                local Image_day_now = ccui.Helper:seekWidgetByName(instance.roots[1],string.format("Image_day_%d_0",day_index))
                Image_day_now:setVisible(true)
               return true
            end,
            _terminal = nil,
            _terminals = nil
        }
                        --刷新列表坐标
        local seven_days_achieve_update_list_poy_terminal = {
            _name = "seven_days_achieve_update_list_poy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:onUpdateDrawListPosY(params)
                end
               return true
            end,
            _terminal = nil,
            _terminals = nil
        }        
        state_machine.add(seven_days_achieve_change_day_terminal)
        state_machine.add(seven_days_achieve_change_image_day_terminal)
        state_machine.add(seven_days_achieve_update_list_poy_terminal)
        state_machine.init()

    end
    
    -- call func init_seven_days_teasure_terminal.
    init_seven_days_achieve_terminal()
end

function SevenDaysAchieve:initListView()
    local root = self.roots[1]
    local ListView_123 = ccui.Helper:seekWidgetByName(root,"ListView_123")
    local items = ListView_123:getItems()
    for i,v in pairs(items) do 
        if i > 1 then
            local button = v
            local day = i - 1
            fwin:addTouchEventListener(button,nil, 
            {
                terminal_name = "seven_days_achieve_change_day",      
                terminal_state = 0,
                _day_index = day,
                isPressedActionEnabled = false
            }, 
            nil, 0)

            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                then
            else
                state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_new_everydays_achieve",
                _widget = button,
                _invoke = nil,
                dayIndex = day,
                _interval = 0.5,})     
            end     
        end
    end
  
end
function SevenDaysAchieve:onUpdateDrawListPosY(day_index)
    self.list_view_posY = -1 
end
function SevenDaysAchieve:onUpdateDraw(day_index)
    self.dayIndex = day_index
    local root = self.roots[1]

    for i=1,7 do
        local listView = ccui.Helper:seekWidgetByName(root, "ListView_meirifuli_"..i)
        listView:setVisible(false)
    end

    local listView = ccui.Helper:seekWidgetByName(root, "ListView_meirifuli_"..self.dayIndex)
    
    if #listView:getItems() > 0 then
        listView:setVisible(true)
        self.list_view = listView
        self.list_view_posY = listView:getInnerContainer():getPositionY()
        listView:requestRefreshView()
        listView:getInnerContainer():setPositionY(self.list_view_posY - 1)        
    else 
        listView:setVisible(true)
        listView:removeAllChildren(true)
        
        local achievement_page = _ED.active_activity[42].seven_days_rewards[self.dayIndex].achievement_pages[1]

        local uncompItems = {}
        local drawItems = {}
        local closeItems = {}
        for i, v in pairs(achievement_page._achievement_rewards) do
            local cell = EveryDayAchievementListCellNew:createCell()
            cell:init(1, i, self.dayIndex, v, listView)
    		local drawState = 0
    		local needCompleteCount = 0
    		local dailyTaskMould = dms.element(dms["achieve"], v.id)
    		local completeCount = zstring.tonumber(v.complete_count)
    		local drawRewardState = zstring.tonumber(v.state)
    		local useType = dms.atoi(dailyTaskMould, achieve.param1)
    		if useType == 3 
    			or useType == 4
    			then
    			needCompleteCount = dms.atoi(dailyTaskMould, achieve.param3)
    		else
    			needCompleteCount = dms.atoi(dailyTaskMould, achieve.param2)
    		end
    		
    		if drawRewardState == 0 then
    			if useType == 7 or useType == 9 then
    				if completeCount > 0 then
    					if completeCount <= needCompleteCount then
    						completeCount = needCompleteCount
    						 drawState = 1
    					else
    						drawState = 0
    					end
    				else
    					drawState = 0
    				end
    			else
    				if completeCount >= needCompleteCount then
    					drawState = 1
    				else
    					drawState = 0
    				end
    			end
    		else
    			drawState = 2
    		end
    		
            if drawState == 0 then
                table.insert(uncompItems, cell)
            elseif drawState == 1 then
                table.insert(drawItems, cell)
            elseif drawState == 2 then
                table.insert(closeItems, cell)
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
        self.list_view = listView
        self.list_view_posY = listView:getInnerContainer():getPositionY()
        listView:requestRefreshView()
        listView:getInnerContainer():setPositionY(self.list_view_posY - 1)
    end
end
function SevenDaysAchieve:onUpdate()
    if self.list_view ~= nil then
        local size = self.list_view:getContentSize()
        local posY = self.list_view:getInnerContainer():getPositionY()
        if self.list_view_posY == posY then
            return
        end
        self.list_view_posY = posY
        local items = self.list_view:getItems()
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
function SevenDaysAchieve:onEnterTransitionFinish()
end
function SevenDaysAchieve:onInit()
    local csbSevenDaysTreasure = csb.createNode("activity/7days/week_Activities_page_3.csb")
    self:addChild(csbSevenDaysTreasure)

    local root = csbSevenDaysTreasure:getChildByName("root")
    table.insert(self.roots, root)
    self:initListView()
end

function SevenDaysAchieve:onExit()
    state_machine.remove("seven_days_achieve_change_day")
    state_machine.remove("seven_days_achieve_change_image_day")
    state_machine.remove("seven_days_achieve_update_list_poy")
end

function SevenDaysAchieve:init(dayIndex)
    self.dayIndex = dayIndex
    self:onInit()
end
