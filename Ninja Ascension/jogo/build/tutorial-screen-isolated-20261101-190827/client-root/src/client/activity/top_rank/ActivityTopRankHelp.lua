-- ----------------------------------------------------------------------------------------------------
-- 说明：top排行榜帮助
-------------------------------------------------------------------------------------------------------
ActivityTopRankHelp = class("ActivityTopRankHelpClass", Window)

local activity_top_rank_open_terminal = {
    _name = "activity_top_rank_help_open",
    _init = function (terminal) 
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local topRankHelp = ActivityTopRankHelp:new()
        topRankHelp:init()
        fwin:open(topRankHelp, fwin._windows)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(activity_top_rank_open_terminal)
state_machine.init()

function ActivityTopRankHelp:ctor()
    self.super:ctor()
    
    self.roots = {}
    
    self.treasure_instance = nil
    self.types = nil
    app.load("client.activity.top_rank.ActivityTopRankHelpList")
    -- Initialize TreasureRebornPage page state machine.
    local function init_activity_top_rank_help_terminal()
        -- 重生界面初始化，包含清除当前武将处理
        local activity_top_rank_help_back_terminal = {
            _name = "activity_top_rank_help_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(activity_top_rank_help_back_terminal)
        state_machine.init()
    end
    init_activity_top_rank_help_terminal()
end

function ActivityTopRankHelp:onUpdateDraw1()
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
    local name = ""
    local info = {}
    for i=1,13 do
        info[i] = _top_rank_info[i]    
    end
    local cell = ActivityTopRankHelpList:createCell()
    cell:init(name, info)
    listView:addChild(cell)
end

function ActivityTopRankHelp:onEnterTransitionFinish()
    local refinery_help = csb.createNode("refinery/refinery_help.csb")
    self:addChild(refinery_help)
    local root = refinery_help:getChildByName("root")
    table.insert(self.roots, root)
    
    --选择
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_help"), nil, 
    {
        terminal_name = "activity_top_rank_help_back",
    },
    nil, 0)
    self:onUpdateDraw1()
end

function ActivityTopRankHelp:init(types)
    self.types = types
end

function ActivityTopRankHelp:onExit()
    state_machine.remove("activity_top_rank_help_back")
end
