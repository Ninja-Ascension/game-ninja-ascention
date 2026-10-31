-- ----------------------------------------------------------------------------------------------------
-- 说明：活动 / 每日签到
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityDailySignIn = class("ActivityDailySignInClass", Window)
    
function ActivityDailySignIn:ctor()
    self.super:ctor()
 
    -- Initialize ActivityDailySignIn state machine.
    local function init_ActivityDailySignIn_terminal()
		-- 界面
        -- local helper_dlg_return_terminal = {
            -- _name = "helper_dlg_close",
            -- _init = function (terminal) 
            
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
				-- fwin:close(instance)
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
        -- state_machine.add(helper_dlg_return_terminal)
        -- state_machine.init()
    end
    
    -- call func init ActivityDailySignIn state machine.
    init_ActivityDailySignIn_terminal()
end

function ActivityDailySignIn:onEnterTransitionFinish()
    local csbActivityDailySignIn = csb.createNode("activity/ActivityDailySignIn.csb")
    -- self:addChild(csbActivityDailySignIn)
	
	-- local root = csbActivityDailySignIn:getChildByName("root")
	
    fwin:find("ActivityWindowClass"):activityChange(csbActivityDailySignIn)
	-- local close_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {terminal_name = "helper_dlg_close", terminal_state = 1}, nil, 0)
end

function ActivityDailySignIn:onExit()
	-- state_machine.remove("helper_dlg_close")
end