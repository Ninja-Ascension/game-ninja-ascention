----------------------------------------------------------------------------------------------------
-- 说明：七日活动每日成就列表
-------------------------------------------------------------------------------------------------------
SevenDaysForEveryDayAchievement = class("SevenDaysForEveryDayAchievementClass", Window)
    
function SevenDaysForEveryDayAchievement:ctor()
    self.super:ctor()
    self.roots = {}

    self.activity = _ED.active_activity[42]
    self.dayIndex = 0
    self.achievementIndex = 0

    app.load("client.cells.activity.every_day_achievement_list_cell")
	
    -- Initialize seven days activity for every day achievement page state machine.
    local function init_seven_days_activity_for_every_day_achievement_terminal()
        local seven_days_activity_for_every_day_achievement_reset_terminal = {
            _name = "seven_days_activity_for_every_day_achievement_reset",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                params._instance:init(params._currentDayIndex, params._instance.achievementIndex)
                params._instance:initListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(seven_days_activity_for_every_day_achievement_reset_terminal)
        state_machine.init()
    end
    
    -- call func init seven days activity for every day achievement state machine.
    init_seven_days_activity_for_every_day_achievement_terminal()
end

function SevenDaysForEveryDayAchievement:initListView()
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
    listView:removeAllChildren(true)

    local achievement_page = _ED.active_activity[42].seven_days_rewards[self.dayIndex].achievement_pages[self.achievementIndex]

    local uncompItems = {}
    local drawItems = {}
    local closeItems = {}
    for i, v in pairs(achievement_page._achievement_rewards) do
        local cell = EveryDayAchievementListCell:createCell()
        cell:init(self.achievementIndex, i, self.dayIndex, v, listView)
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
    listView:requestRefreshView()
end

function SevenDaysForEveryDayAchievement:onEnterTransitionFinish()
    local csbSevenDaysForEveryDayAchievement = csb.createNode("activity/7days/week_Activities_listview.csb")
    self:addChild(csbSevenDaysForEveryDayAchievement)

    local root = csbSevenDaysForEveryDayAchievement:getChildByName("root")
    table.insert(self.roots, root)

    root:setSwallowTouches(false)

    -- self:initListView()
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initListView, self)
end

function SevenDaysForEveryDayAchievement:onExit()
    -- state_machine.remove("seven_days_activity_for_every_day_achievement_reset")
end

function SevenDaysForEveryDayAchievement:init(dayIndex, achievementIndex)
    self.dayIndex = dayIndex
    self.achievementIndex = achievementIndex
    return self
end

function SevenDaysForEveryDayAchievement:createCell()
	local cell = SevenDaysForEveryDayAchievement:new()
	cell:registerOnNodeEvent(cell)
	return cell
end