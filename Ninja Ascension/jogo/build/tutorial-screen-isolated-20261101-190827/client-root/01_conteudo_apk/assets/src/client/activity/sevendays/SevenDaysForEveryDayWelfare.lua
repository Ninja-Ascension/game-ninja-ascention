----------------------------------------------------------------------------------------------------
-- 说明：七日活动每日福利列表
-------------------------------------------------------------------------------------------------------
SevenDaysForEveryDayWelfare = class("SevenDaysForEveryDayWelfareClass", Window)
    
function SevenDaysForEveryDayWelfare:ctor()
    self.super:ctor()
    self.roots = {}

    self.dayIndex = 0

    app.load("client.cells.activity.every_day_welfare_list_cell")

    -- Initialize seven days activity for every day welfare page state machine.
    local function init_seven_days_activity_for_every_day_welfare_terminal()
        local seven_days_activity_for_every_day_welfare_reset_terminal = {
            _name = "seven_days_activity_for_every_day_welfare_reset",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:init(params)
                instance:initListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(seven_days_activity_for_every_day_welfare_reset_terminal)
        state_machine.init()
    end
    
    -- call func init seven days activity for every day welfare state machine.
    init_seven_days_activity_for_every_day_welfare_terminal()
end

function SevenDaysForEveryDayWelfare:initListView()
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
    listView:removeAllChildren(true)
    
    local welfares = _ED.active_activity[42].seven_days_rewards[self.dayIndex].welfare

    local uncompItems = {}
    local drawItems = {}
    local closeItems = {}
    for i, v in pairs(welfares) do
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

function SevenDaysForEveryDayWelfare:onEnterTransitionFinish()
    local csbSevenDaysForEveryDayWelfare = csb.createNode("activity/7days/week_Activities_listview.csb")
    self:addChild(csbSevenDaysForEveryDayWelfare)

    local root = csbSevenDaysForEveryDayWelfare:getChildByName("root")
    table.insert(self.roots, root)

    root:setSwallowTouches(false)

    self:initListView()
end

function SevenDaysForEveryDayWelfare:onExit()
    -- state_machine.remove("seven_days_activity_for_every_day_welfare_reset")
end

function SevenDaysForEveryDayWelfare:init(dayIndex)
    self.dayIndex = dayIndex
    return self
end

function SevenDaysForEveryDayWelfare:createCell()
    local cell = SevenDaysForEveryDayWelfare:new()
    cell:registerOnNodeEvent(cell)
    return cell
end