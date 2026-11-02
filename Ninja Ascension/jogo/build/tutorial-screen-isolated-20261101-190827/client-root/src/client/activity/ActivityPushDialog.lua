-- ----------------------------------------------------------------------------------------------------
-- 说明：活动推送提示界面
-------------------------------------------------------------------------------------------------------

ActivityPushDialog = class("ActivityPushDialogClass", Window)
    
--打开活动推送界面
local activity_push_goto_open_terminal = {
    _name = "activity_push_goto_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	--需求：
    	--1 判断玩家等级大于7级，进入游戏时才会弹出此界面。
    	--2 判读玩家是否已首充，若未首充，则每日弹出界面为首充CG；若已首充，则弹出界面为活动推送。
    	--3 常规情况下，此界面仅在玩家每日首次登陆时弹出一次。
        if  terminal.isOpend ~= nil then 
        	--本次运行时已经弹出过
        	return
        end  
        --只有第一次进入游戏的时候 
        if terminal.isOpend == nil then 
        	terminal.isOpend = true
    	end
        if _ED.activity_push_info == nil then 
            return
        end
    	local current_timeInfo = os.date("*t", os.time())
    	
    	--条件满足后开始弹出活动或是首充对话框
    	local function gotoActivityDialog()
    		if missionIsOver() == true and zstring.tonumber(_ED.user_info.user_grade) >= _ED.activity_push_info.open_level then  
	        	--需要弹出提示框
	        	if _ED.active_activity[4] ~= nil and _ED.active_activity[4]~="" and tonumber(_ED.recharge_rmb_number) <= 0 then
	        		--首充弹框
	        		app.load("client.activity.ActivityFirstRechargePopup")
	        		fwin:open(ActivityFirstRechargePopup:new(), fwin._windows)
	    		else
	    			--活动弹窗
	        		fwin:open(ActivityPushDialog:new(), fwin._windows)
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
state_machine.add(activity_push_goto_open_terminal)
state_machine.init()

function ActivityPushDialog:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    app.load("client.cells.activity.activity_push_cell")
    -- Initialize ActivityPushDialog page state machine.
    local function init_activity_push_terminal()
		
		local activity_push_goto_terminal = {
            _name = "activity_push_goto",
            _init = function (terminal) 
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local activityId = zstring.tonumber(params._datas.activity_id)
            	fwin:close(fwin:find("ActivityPushDialogClass"))
                if _ED.active_activity[activityId] == nil or _ED.active_activity[activityId] == "" then 
            		return
            	end
            	--服务器活动ID
                --45:18  21:17 62:30 70:36 71:37 28:16 7:8  服务器ID:本地客户端ID
                if activityId == 7 then 
            		--累计充值
                    state_machine.excute("activity_window_open", 0, {"client.activity.ActivityAccumlateRechargeable", "AccumlateRechargeable"})
            	elseif activityId == 21 then 
                    --单日充值
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                        state_machine.excute("activity_window_open", 0, {"client.l_digital.activity.wonderful.SmActivityRechargeEverydayGift", "SmActivityRechargeEverydayGift"}) 
                    else
                        state_machine.excute("activity_window_open", 0, {"client.activity.ActivityOneDayRecharge", "ActivityOneDayRecharge"})
                    end
                elseif activityId == 45 then 
                    --单笔送礼
                    state_machine.excute("activity_window_open", 0, {"client.activity.ActivityOnceRecharge", "ActivityOnceRecharge"})
                elseif activityId == 70 then 
                    --孵化场  
                    state_machine.excute("activity_window_open", 0, {"client.activity.ActivityVarietyShopTwo", "VarietyShopTwo"})
                elseif activityId == 62 then
                    --交易所  
                    state_machine.excute("activity_window_open", 0, {"client.activity.ActivityHalfPriceRestriction", "HalfPriceRestriction"})
                elseif activityId == 28 then 
                    --黑市 -- 
                    state_machine.excute("activity_window_open", 0, {"client.activity.ActivityVarietyShop", "VarietyShop"})
                elseif activityId == 71 then
                    --锻造屋 
                    state_machine.excute("activity_window_open", 0, {"client.activity.ActivityVarietyShopThree", "VarietyShopThree"})
            	end
				
				state_machine.excute("menu_adventure_open_button",0,"")				
			
			    return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(activity_push_goto_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_activity_push_terminal()
end

function ActivityPushDialog:onUpdateDraw()
	local root = self.roots[1]
	if root == nil or _ED.activity_push_info == nil or _ED.activity_push_info.message_info == nil then 
		return
	end
   
    --只会有两个活动
    for i,v in pairs(_ED.activity_push_info.message_info) do
        local activityId = v.activityId
        local panelCell = ccui.Helper:seekWidgetByName(root, "Panel_activity_"..i)
        panelCell:removeAllChildren(true)
        local activityCell = ActivityPushCell:createCell()
        activityCell:init(v)
        panelCell:addChild(activityCell)
        fwin:addTouchEventListener(panelCell,       nil, 
        {
            terminal_name = "activity_push_goto",     
            terminal_state = 0, 
            activity_id = activityId,
            isPressedActionEnabled = false
        }, 
        nil, 0)
    end
   
end

function ActivityPushDialog:onEnterTransitionFinish()
	
	local csbActivityPushDialog = csb.createNode("activity/wonderful/wonderful_tuijian.csb")
	self:addChild(csbActivityPushDialog)
	local root = csbActivityPushDialog:getChildByName("root")
	table.insert(self.roots, root)
	
    local action = csb.createTimeline("activity/wonderful/wonderful_tuijian.csb")
    table.insert(self.actions, action)
    csbActivityPushDialog:runAction(action)
    action:play("window_open", false)
   
	self:onUpdateDraw()

	local function backPlotScene(sender, eventType)				--点击确定
		if eventType == ccui.TouchEventType.ended then
			fwin:close(self)
		elseif eventType == ccui.TouchEventType.began then
			playEffect(formatMusicFile("button", 1))		--加入按钮音效
		end
	end
	ccui.Helper:seekWidgetByName(root, "Panel_269"):addTouchEventListener(backPlotScene)
end


function ActivityPushDialog:init()
	
end

function ActivityPushDialog:onExit()

end
