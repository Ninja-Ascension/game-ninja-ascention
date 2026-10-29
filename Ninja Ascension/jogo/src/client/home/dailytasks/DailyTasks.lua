-- ----------------------------------------------------------------------------------------------------
-- 说明：日常任务
-- 创建时间	2015-03-06
-- 作者：胡文轩
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

DailyTasks = class("DailyTasksClass", Window)
    
function DailyTasks:ctor()
    self.super:ctor()
    
	-- app.load("client.packs.treasure.TreasureStorage")
	
    -- Initialize DailyTasks page state machine.
    local function init_daily_tasks_terminal()
	
		local daily_tasks_back_terminal = {
            _name = "daily_tasks_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:open(Home:new(), fwin._view)
				fwin:open(UserInformation:new(), fwin._view)
				fwin:close(instance)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
	
	
		state_machine.add(daily_tasks_back_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_daily_tasks_terminal()
end

function DailyTasks:onEnterTransitionFinish()
	

	local csbDailyTasks = csb.createNode("home/dailytasks/DailyTasks.csb")
	self:addChild(csbDailyTasks)
		
	local root = csbDailyTasks:getChildByName("root")
	local Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1_1"), nil, {terminal_name = "daily_tasks_back", terminal_state = 0, 
									isPressedActionEnabled = true}, nil, 2)
	
	local Text = ccui.Helper:seekWidgetByName(root, "Text")
	Text:setString(_string_piece_info[138])
	

	
end


function DailyTasks:onExit()
	
	
	state_machine.remove("daily_tasks_back")
end