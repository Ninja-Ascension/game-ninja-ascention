-- ----------------------------------------------------------------------------------------------------
-- 说明：推送
-------------------------------------------------------------------------------------------------------
ActivityPushManager = class("ActivityPushManagerClass", Window)

local activity_push_manager_goto_terminal = {
    _name = "activity_push_manager_goto",
    _init = function (terminal)
        app.load("client.red_alert.activity.wonderful.ActivitySevenDay")
        app.load("client.red_alert.activity.wonderful.ActivityPopRecharge")
        app.load("client.red_alert.activity.wonderful.ActivityFristRechargeTop")
        -- app.load("client.red_alert.activity.wonderful.ActivityVipPush")
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if terminal.isOpend ~= nil then 
        	--本次运行时已经弹出过
        	return
        end  
        --只有第一次进入游戏的时候 
        if terminal.isOpend == nil then 
        	terminal.isOpend = true
    	end
    	local current_timeInfo = os.date("*t", os.time())
    	local function gotoActivityDialog()
    		if missionIsOver() == true then
                state_machine.excute("activity_seven_day_window_open", 0, nil)
                state_machine.excute("activity_pop_recharge_window_open", 0, nil)
                -- state_machine.excute("activity_vip_push_window_open", 0, nil)
                if tonumber(_ED.recharge_rmb_number) <= 0 then

                end
	    		--需要记录弹出状态
	        	local recordTime = os.time()
	        	cc.UserDefault:getInstance():setStringForKey(getKey("activity_push_time"),""..recordTime)
			end
    	end
    	--比较时间
    	local recordTime = cc.UserDefault:getInstance():getStringForKey(getKey("activity_push_time"))
    	if recordTime ~= nil and recordTime ~= "" then 
    		--比较是否过了一天
    		record_timeInfo = os.date("*t", zstring.tonumber(recordTime))
    		if record_timeInfo ~= nil then 
    			if zstring.tonumber(current_timeInfo.year) > zstring.tonumber(record_timeInfo.year)
    			or zstring.tonumber(current_timeInfo.month) > zstring.tonumber(record_timeInfo.month)
				or zstring.tonumber(current_timeInfo.day) > zstring.tonumber(record_timeInfo.day) then 
				--超过了一天可以弹出了
					gotoActivityDialog()
				else 
					--当天下次重新进入游戏
                    gotoActivityDialog()
    			end
    		end  
    	else
    		--没有记录过，第一次登入
    		gotoActivityDialog()
    	end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(activity_push_manager_goto_terminal)
state_machine.init()

function ActivityPushManager:ctor()
    self.super:ctor()
end

function ActivityPushManager:onUpdateDraw()
	
end

function ActivityPushManager:onEnterTransitionFinish()

end

function ActivityPushManager:init()
	
end

function ActivityPushManager:onExit()

end
