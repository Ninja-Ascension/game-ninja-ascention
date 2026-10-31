-- ----------------------------------------------------------------------------------------------------
-- 说明：成就主界面
-------------------------------------------------------------------------------------------------------
AdventureAchievement = class("AdventureAchievementClass", Window)
    
function AdventureAchievement:ctor()
    self.super:ctor()
    self.roots = {}

	app.load("client.cells.achievement.achievement_list_cell")
    -- Initialize adventure achievement state machine.
    local function init_adventure_achievement_terminal()
		
        local adventure_achievement_update_draw_terminal = {
            _name = "adventure_achievement_update_draw",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(adventure_achievement_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func init adventure achievement state machine.
    init_adventure_achievement_terminal()
end

function AdventureAchievement:init()
	return self
end

function AdventureAchievement:onUpdateDraw()
	local root = self.roots[1]
	local achievementListView = ccui.Helper:seekWidgetByName(root, "ListView_daoju")
    local uncompItems = {}
    local drawItems = {}
    local closeItems = {}
	achievementListView:removeAllItems()
    for i, v in pairs(_ED.daily_task_achievement) do
        local cell = AchievementListCell:createCell()
        local tcell, drawState = cell:init(2, v, achievementListView)
        --achievementListView:addChild(cell)
        if drawState == 0 then
            table.insert(uncompItems, cell)
        elseif drawState == 1 then
            table.insert(drawItems, cell)
			-- 已经完成了不添加进来
        -- elseif drawState == 2 then
            -- table.insert(closeItems, cell)
        end
    end
    for i, v in pairs(drawItems) do
        achievementListView:addChild(v)
    end
    for i, v in pairs(uncompItems) do
        achievementListView:addChild(v)
    end
    for i, v in pairs(closeItems) do
        achievementListView:addChild(v)
    end
    achievementListView:requestRefreshView()
	
end

function AdventureAchievement:onEnterTransitionFinish()
	local csbAdventureAchievement = csb.createNode("system/achievement.csb")
    local root = csbAdventureAchievement:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureAchievement)

	
	local function responseDailyMissionInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then 
                response.node:onUpdateDraw()
            end
		end
	end
		
	protocol_command.daily_mission_init.param_list = ""
	NetworkManager:register(protocol_command.daily_mission_init.code, nil, nil, nil, self, responseDailyMissionInitCallback, false, nil)
	
	
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
		terminal_name = "menu_manager",     
		next_terminal_name = "menu_show_home_page", 
		current_button_name = "Button_daditu",
		but_image = "Image_daditu",         
		terminal_state = 0, 
		isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureAchievement:onExit()

end