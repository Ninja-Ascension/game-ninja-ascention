-----------------------------
--活动中心
-----------------------------
RedAlertTimeCenter = class("RedAlertTimeCenterClass", Window)

local red_alert_time_center_window_open_terminal = {
    _name = "red_alert_time_center_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if funOpenDrawTip(243) == true then
            return
        end 
        if nil == fwin:find("RedAlertTimeCenterClass") then
			fwin:open(RedAlertTimeCenter:new():init(), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_center_window_close_terminal = {
    _name = "red_alert_time_center_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        --刷新
        state_machine.excute("main_window_update_userinfo", 0, nil)
        state_machine.excute("home_map_update_build", 0, nil)

        state_machine.excute("main_window_push_treasure",0,0)
        fwin:close(fwin:find("RedAlertTimeCenterClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_center_window_open_terminal)
state_machine.add(red_alert_time_center_window_close_terminal)
state_machine.init()

function RedAlertTimeCenter:ctor()
    self.super:ctor()
    self.roots = {}
	self.m_listView = nil
	-- var 活动数据
    self._activity_datas = {}
    --load lua file
	
	
	app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_center_cell")
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeDaySignSeven")
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeDaySign")
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeBrothersShare")
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRechargeBonus")
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeTankDraw")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeTankDrawReward")
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeEquipmentBeast")
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeConsumptionTurntable")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeConsumptionTurntableTransfer")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeConsumptionTurntableRank")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeConsumptionTurntableReward")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeSecret")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeConsumptionTurntableRule")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeFundingAggregation")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeFundingFullService")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeFundingPersonal")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRuleInfor")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeMilitaryExploit")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeLeaderSenior")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeWindingUpPlan")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeEliminateMusic")
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeMilitaryPulpit")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeDiscountStore")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeLuckyDraw")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeScientificQuicke")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeLeaderSeniorLegend")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeFullVitality")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRechargeTurntable")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeSpringPackage")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRechargeSendLeader")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeSnatchRebelHaunt")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeExcavtingComeing")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeLargesseGive")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeCarnivalHour")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeAprilFoolsHappy")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeHappyBuy")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeFestivalEachChild")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeDiscountStoreReward")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeFalconAssault")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeUitimateBreakthrough")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRebateTurntable")
    -- Initialize red_alert_time_center state machine.
    local function init_red_alert_time_center_terminal()
		local copy_paste_text_start_terminal = {
          _name = "copy_paste_text_start",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				handlePlatformRequest(0, CC_COPY_PASTE_TEXT_START, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
          }

          --移除活动页
        local red_alert_time_center_remove_page_terminal = {
            _name = "red_alert_time_center_remove_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:removeActivityPage(params[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

          local red_alert_time_center_update_first_terminal = {
            _name = "red_alert_time_center_update_first",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    for i,cell in pairs(instance._activity_datas) do
                        if cell ~= nil then
                            if tonumber(cell.activity_type) == tonumber(params) then
                                state_machine.excute("red_alert_time_center_remove_page", 0, {tonumber(params)})
                                return
                            end
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local red_alert_time_center_find_terminal = {
            _name = "red_alert_time_center_find",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                for i,v in pairs(_ED.activity_info) do
                    local activity_type = tonumber(v.activity_type)
                    if activity_type == 7               --7日和每日签到   
                    or activity_type == 82
                    or activity_type == 81
                    or activity_type == 57
                    or activity_type == 58
                    or activity_type == 67
                    or activity_type == 71
                    or activity_type == 104
                    or activity_type == 105
                    or activity_type == 75
                    or activity_type == 78
                    or activity_type == 96          -- 清盘计划
                    or activity_type == 97          -- 摧枯拉朽
                    or activity_type == 98          -- 消消乐
                    or activity_type == 99          -- 火线将领
                    or activity_type == 101          -- 军事讲坛
                    or activity_type == 102          -- 坦克拉霸
                    or activity_type == 103          -- 折扣卖场
                    or activity_type == 117          -- 火力驱动
                    or activity_type == 118          -- 慷慨馈赠
                    or activity_type == 119          -- 传奇名将
                    or activity_type == 126
                    or activity_type == 127
                    or activity_type == 129          -- 欢乐团购
                    or activity_type == 130          -- 狂欢时刻
                    or activity_type == 132          -- 节日祝福
                    then    
                        local timesData = zstring.split(v.activity_add_state, ",")
                        if tonumber(activity_type) ~= 82 then
                            if tonumber(timesData[1]) == 1 or tonumber(timesData[1]) == 0 or tonumber(v.activity_add_state) == -1 then
                            else
                                local m_times = ((tonumber(timesData[2])/1000-2)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
                                if m_times <= 0 then
                                    state_machine.excute("red_alert_time_center_update_first",0,v.activity_type)
                                    local closeName = params
                                    fwin:addService({
                                        callback = function ( params )
                                            state_machine.excute(closeName,0,0)
                                        end,
                                        delay = 0.1,
                                        params = nil
                                    })
                                    break
                                end
                            end
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_center_remove_terminal = {
            _name = "red_alert_time_center_remove",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[1]
                cell:runAction(cc.Sequence:create(
                    cc.DelayTime:create(cell.m_times),
                    cc.CallFunc:create(function ( sender )
                        fwin:addService({
                            callback = function ( params )
                                cell.m_times = 0
                                state_machine.excute("red_alert_time_center_update_first",0,cell._activity.activity_type)
                            end,
                            delay = 0.1,
                            params = nil
                        })
                    end)
                ))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_center_new_activity_terminal = {
            _name = "red_alert_time_center_new_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                for i,v in pairs(_ED.activity_info) do
                    local activity_type = tonumber(v.activity_type)
                    if activity_type == 7               --7日和每日签到   
                    or activity_type == 82
                    or activity_type == 81
                    or activity_type == 57
                    or activity_type == 58
                    or activity_type == 67
                    or activity_type == 71
                    or activity_type == 104
                    or activity_type == 105
                    or activity_type == 75
                    or activity_type == 78
                    or activity_type == 96          -- 清盘计划
                    or activity_type == 97          -- 摧枯拉朽
                    or activity_type == 98          -- 消消乐
                    or activity_type == 99          -- 火线将领
                    or activity_type == 101          -- 军事讲坛
                    or activity_type == 102          -- 坦克拉霸
                    or activity_type == 103          -- 折扣卖场
                    or activity_type == 117          -- 火力驱动
                    or activity_type == 118          -- 慷慨馈赠
                    or activity_type == 119          -- 传奇名将
                    or activity_type == 126
                    or activity_type == 127
                    or activity_type == 129          -- 欢乐团购
                    or activity_type == 130          -- 狂欢时刻
                    or activity_type == 132          -- 节日祝福
                    then    
                       local isUpdate = true
                        for j,w in pairs(instance._activity_datas) do
                            if tonumber(w.activity_type) == activity_type then
                                isUpdate = false
                            end
                        end
                        if _ED.activity_info[""..activity_type] ~= nil and isUpdate == true then
                            instance._activity_datas = {}
                            instance:initActivityDatas()
                            instance:onUpdateDraw()
                            return
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_center_update_push_terminal = {
            _name = "red_alert_time_center_update_push",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local ListView_wonderful_label = ccui.Helper:seekWidgetByName(instance.roots[1],"ListView_2")
                local items = ListView_wonderful_label:getItems()
                for i,cell in pairs(items) do
                    if tonumber(cell._actIndex) == tonumber(params) then
                        state_machine.excute("red_alert_time_center_cell_update_push", 0, cell)
                        break
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(copy_paste_text_start_terminal)
        state_machine.add(red_alert_time_center_remove_page_terminal)
        state_machine.add(red_alert_time_center_update_first_terminal)
        state_machine.add(red_alert_time_center_find_terminal)
        state_machine.add(red_alert_time_center_new_activity_terminal)
        state_machine.add(red_alert_time_center_update_push_terminal)
        state_machine.add(red_alert_time_center_remove_terminal)

        state_machine.init()
    end
    
    -- call func init red_alert_time_center state machine.
    init_red_alert_time_center_terminal()
end

function RedAlertTimeCenter:removeActivityPage(activity_type)
    local root = self.roots[1]
    local ListView_wonderful_label = ccui.Helper:seekWidgetByName(root,"ListView_2")
    for i,cell in pairs(self._activity_datas) do
        if tonumber(cell.activity_type) == tonumber(activity_type) then
            table.remove(self._activity_datas,i)
            break
        end
    end
    local items = ListView_wonderful_label:getItems()
    for i,cell in pairs(items) do
        if tonumber(cell._actIndex) == tonumber(activity_type) then
            ListView_wonderful_label:removeItem(ListView_wonderful_label:getIndex(cell))
            break
        end
    end
    _ED.activity_info[""..activity_type] = nil
    ListView_wonderful_label:requestRefreshView()
end

function RedAlertTimeCenter:onUpdateDraw()
    local root = self.roots[1]
    self.m_listView = ccui.Helper:seekWidgetByName(root,"ListView_2")
	self.m_listView:removeAllItems()
	local index = 1
    for i,v in pairs(self._activity_datas) do
        local cell = state_machine.excute("red_alert_time_center_create_cell",0,{v,index})
        cell._actIndex = v.activity_type
        self.m_listView:addChild(cell)
        index = index + 1
    end
	self.m_listView:requestRefreshView()
end

function RedAlertTimeCenter:initActivityDatas()	
	local isrepeat = false
	for i,v in pairs(_ED.activity_info) do
        if v ~= nil then
    		local activity_type = tonumber(v.activity_type)
    		if activity_type == 7 then				--7日和每日签到	
        	    v.value = dms.int(dms["activity_param"],v.activity_type,activity_param.types)
                table.insert(self._activity_datas,v)
            elseif activity_type == 82
        		or activity_type == 81
        		or activity_type == 57
        		or activity_type == 58
        		or activity_type == 67
        		or activity_type == 71
                or activity_type == 104
                or activity_type == 105
        		or activity_type == 75
        		or activity_type == 78
                or activity_type == 96          -- 清盘计划
                or activity_type == 97          -- 摧枯拉朽
                or activity_type == 98          -- 消消乐
                or activity_type == 99          -- 火线将领
                or activity_type == 101          -- 军事讲坛
                or activity_type == 102          -- 坦克拉霸
                or activity_type == 103          -- 折扣卖场
                or activity_type == 117          -- 火力驱动
                or activity_type == 118          -- 慷慨馈赠
                or activity_type == 119          -- 传奇名将
                or activity_type == 126
                or activity_type == 127
                or activity_type == 129          -- 欢乐团购
                or activity_type == 130          -- 狂欢时刻
                or activity_type == 132          -- 节日祝福
        		then	
    			-- local index = 0 
       --          local activity_data = _ED.activity_info[""..v.activity_type].activity_data[1]
                local activity_add_state_arr = zstring.split(v.activity_add_state, "|")
                local timesData = zstring.split(activity_add_state_arr[1], ",")
                if ((tonumber(timesData[2])/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))) > 0 then
        			v.value = dms.int(dms["activity_param"],v.activity_type,activity_param.types)
        			table.insert(self._activity_datas,v)
                else
                    _ED.activity_info[""..activity_type] = nil
                end
    		elseif activity_type == 83 then
    			if _ED.activity_info["7"] == nil then
    			-- debug.print_r(_ED.activity_info[""..v.activity_type])
    				-- local index = 0 
    				-- local activity_data = _ED.activity_info[""..v.activity_type].activity_data[1]
    				v.value = dms.int(dms["activity_param"],v.activity_type,activity_param.types)
    				table.insert(self._activity_datas,v)
    			end
            elseif activity_type == 46 then          -- 幸运抽奖
                if __lua_project_id == __lua_project_pacific_rim then
                    v.value = dms.int(dms["activity_param"],v.activity_type,activity_param.types)
                    table.insert(self._activity_datas,v)
                end
    		end
        end
	end
	local function sortTable( a, b )
        return tonumber(a.value) < tonumber(b.value)
    end

    table.sort(self._activity_datas,sortTable)
end

function RedAlertTimeCenter:onEnterTransitionFinish()

end

function RedAlertTimeCenter:onInit( )
    local csbItem = csb.createNode(config_csb.treasurehouse.active_center)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    self.__check_covers = true
    root.__cwindow = self
	Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)
	
	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_activity_close"), nil, 
    {
        terminal_name = "red_alert_time_center_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)
	
	self:onUpdateDraw()
end

function RedAlertTimeCenter:init()
	self:initActivityDatas()
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

function RedAlertTimeCenter:onExit()
    state_machine.remove("copy_paste_text_start")
    state_machine.remove("red_alert_time_center_remove_page")
    state_machine.remove("red_alert_time_center_update_first")
    state_machine.remove("red_alert_time_center_find")
    state_machine.remove("red_alert_time_center_remove")
    state_machine.remove("red_alert_time_center_new_activity")
    state_machine.remove("red_alert_time_center_update_push")
end
