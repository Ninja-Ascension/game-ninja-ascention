-- ----------------------------------------------------------------------------------------------------
-- 说明：活动 / 累充送礼
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityRecharge = class("ActivityRechargeClass", Window)
    
function ActivityRecharge:ctor()
    self.super:ctor()
 
    -- Initialize ActivityRecharge state machine.
    local function init_ActivityRecharge_terminal()
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
    
    -- call func init ActivityRecharge state machine.
    init_ActivityRecharge_terminal()
end

function ActivityRecharge:onEnterTransitionFinish()
    local csbActivityRecharge = csb.createNode("activity/ActivityRecharge.csb")
    -- self:addChild(csbActivityRecharge)
	
	-- local root = csbActivityRecharge:getChildByName("root")
	
    fwin:find("ActivityWindowClass"):activityChange(csbActivityRecharge)
	-- local close_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {terminal_name = "helper_dlg_close", terminal_state = 1}, nil, 0)
end

function ActivityRecharge:onExit()
	-- state_machine.remove("helper_dlg_close")
end