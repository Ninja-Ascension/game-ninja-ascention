--[[ ----------------------------------------------------------------------------
-- 任务界面
--]] ----------------------------------------------------------------------------
RescueStationTask = class("RescueStationTaskClass", Window)
-- 打开窗口
local rescue_station_task_window_open_terminal = {
	_name = "rescue_station_task_window_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RescueStationTaskClass") then
			fwin:open(RescueStationTask:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local rescue_station_task_window_close_terminal = {
	_name = "rescue_station_task_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RescueStationTaskClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(rescue_station_task_window_open_terminal)
state_machine.add(rescue_station_task_window_close_terminal)
state_machine.init()

-- 构造器
function RescueStationTask:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self._tasknum = 0
	app.load("client.activity.rescuestation.RescueStation")
    app.load("client.reward.DrawRareReward")
	app.load("client.cells.activity.rescue_station_task_cell")
	local function init_rescue_station_task_terminal()
		-- 打开角色创建窗口
		local rescue_station_task_open_terminal = {
			_name = "rescue_station_task_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 关闭角色创建窗口
		local rescue_station_task_close_terminal = {
			_name = "rescue_station_task_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local rescue_station_task_show_terminal = {
			_name = "rescue_station_task_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local rescue_station_task_hide_terminal = {
			_name = "rescue_station_task_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新任务
		local rescue_station_task_update_terminal = {
			_name = "rescue_station_task_update",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:onUpdateDraw()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		} 

		-- 空盒子
		local rescue_station_task_draw_nil_box_terminal = {
			_name = "rescue_station_task_draw_nil_box",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				  TipDlg.drawTextDailog(tipStringInfo_rescue_station[9])
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 盒子
		local rescue_station_task_draw_box_terminal = {
			_name = "rescue_station_task_draw_box",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
			    local function callBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local score = dms.int(dms["activity_config"], 49, activity_config.param)
                        TipDlg.drawTextDailog(string.format(tipStringInfo_rescue_station[10],score))
                    end
                end
                local info =  json.decode(_ED.active_activity[159].activity_params)
                if tonumber(info.task_success_count) >= instance._tasknum then
                	if tonumber(info.ultimate_reward_status) == 0 then
                		NetworkManager:register(protocol_command.activity_pockmon_rescue_draw_ultimate_reward.code, nil, nil, nil, instance, callBack, false, nil)

		                local function rankcallBack( response )
		                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		                        instance:onupdateScore()
		                        state_machine.excute("rescue_station_uptate_info",0, "")
		                    end
		                end
		                protocol_command.activity_pockmon_rescue_get_cross_rank.param_list = (1).."\r\n"..10
		                NetworkManager:register(protocol_command.activity_pockmon_rescue_get_cross_rank.code, nil, nil, nil, instance, rankcallBack, false, nil)
                	end
                else
                    TipDlg.drawTextDailog(tipStringInfo_rescue_station[8])
                end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(rescue_station_task_open_terminal)
		state_machine.add(rescue_station_task_close_terminal)
		state_machine.add(rescue_station_task_show_terminal)
		state_machine.add(rescue_station_task_hide_terminal)
        state_machine.add(rescue_station_task_update_terminal)
        state_machine.add(rescue_station_task_draw_box_terminal)
        state_machine.add(rescue_station_task_draw_nil_box_terminal)
		state_machine.init()
	end
	-- call func init rescue station task state machine.
	init_rescue_station_task_terminal()
end

-- 对象初始化
function RescueStationTask:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function RescueStationTask:onUpdateDraw()
	local root = self.roots[1]
    local info =  json.decode(_ED.active_activity[159].activity_params)
	-- 积分
	self.Text_station_task = ccui.Helper:seekWidgetByName(root, "Text_station_task")

	if _ED.rescue_station_rank_info.myRank then
		self.Text_station_task:setString(_ED.rescue_station_rank_info.myRank.info.score)
	else
		self.Text_station_task:setString(0)
	end

	-- 任务列表
	self.ListView_rescue_station_task = ccui.Helper:seekWidgetByName(root, "ListView_rescue_station_task")
	self.ListView_rescue_station_task:removeAllItems()
   
	local function sortFunction (a, b)
		local task_info_a = dms.searchs(dms["role_rescue_task"],4,tonumber(a.task_type))
		local task_info_b = dms.searchs(dms["role_rescue_task"],4,tonumber(b.task_type))
	
		if tonumber(task_info_a[1][8]) < tonumber(task_info_b[1][8]) then
			return true
		end
		return false
	end
	table.sort(info.task_status, sortFunction)

	local temp_one = {}
	local temp_two = {}
	local temp_three = {}
	local temp_four = {}
	for k,v in pairs(info.task_status) do
		if tonumber(v.is_show) == 1 then
			table.insert(temp_one,v)
		else
			table.insert(temp_two,v)
		end
	end

	for k,v in pairs(temp_one) do
		table.insert(temp_three,v)
	end
	for k,v in pairs(temp_two) do
		table.insert(temp_three,v)
	end

    for k,v in pairs(temp_three) do
        local openparmId = dms.int(dms["role_rescue_task"], tonumber(v.task_type), 7)
		local openFunctionType = dms.int(dms["function_param"], openparmId, function_param.genre)
		if (openFunctionType == 117 and not _ED.active_activity[148])
			or (openFunctionType == 118 and not _ED.active_activity[89])
			or (openFunctionType == 119 and not _ED.active_activity[114])
			or (openFunctionType == 120 and not _ED.active_activity[154])
	    then
	        v.isopen = 0
		else
			v.isopen = 1
		end
    end
	for i, v in pairs(temp_three) do
        local cell = state_machine.excute("rescue_station_task_cell_create",0,{v})
        --table.insert(self._cells,cell)
        self.ListView_rescue_station_task:addChild(cell)
    end

    local num = table.nums(temp_three)
    self._tasknum = num
	-- 任务进度条
	self.LoadingBar_training_exp = ccui.Helper:seekWidgetByName(root, "LoadingBar_training_exp")
	self.LoadingBar_training_exp:setVisible(false)
	--self.LoadingBar_training_exp:setPercent((info.task_success_count/num)*100)
	local Image_30 = ccui.Helper:seekWidgetByName(root, "Image_30")
	Image_30:setVisible(false)
	

	-- 任务完成数量
	local Text_task_exp_0 = ccui.Helper:seekWidgetByName(root, "Text_task_exp_0")
	Text_task_exp_0:setVisible(false)
	self.Text_training_exp_n = ccui.Helper:seekWidgetByName(root, "Text_training_exp_n")
	self.Text_training_exp_n:setVisible(false)
	--self.Text_training_exp_n:setString(info.task_success_count.."/"..num)
	local Text_task_sign_exp = ccui.Helper:seekWidgetByName(root, "Text_task_sign_exp")
	Text_task_sign_exp:setVisible(false)
	local Panel_task_reward_box_rec = ccui.Helper:seekWidgetByName(root, "Panel_task_reward_box_rec")
	Panel_task_reward_box_rec:setVisible(false)

	
	
	local Panel_task_reward_box_rec =  ccui.Helper:seekWidgetByName(root, "Panel_task_reward_box_rec")

    local Button_task_eveday_box_k =  ccui.Helper:seekWidgetByName(root, "Button_task_eveday_box_k")
    local Button_task_eveday_box =  ccui.Helper:seekWidgetByName(root, "Button_task_eveday_box")
    Button_task_eveday_box:setVisible(false)
    Button_task_eveday_box_k:setVisible(false)
    Panel_task_reward_box_rec:setVisible(false)
    -- if tonumber(info.ultimate_reward_status) == 0 then
    --    --Button_task_eveday_box:setVisible(true)
    --     -- if tonumber(info.task_success_count) >= num then
    --     --     Panel_task_reward_box_rec:setVisible(true)
    --     -- end
    -- else
    --     --Button_task_eveday_box_k:setVisible(true)
    -- end
end

function RescueStationTask:onupdateScore()
	if _ED.rescue_station_rank_info.myRank then
		self.Text_station_task:setString(_ED.rescue_station_rank_info.myRank.info.score)
	else
		self.Text_station_task:setString(0)
	end
end

function RescueStationTask:onEnterTransitionFinish()
	-- 加载RescueStationTaskWindow界面资源.
	-- res.activity.rescue_station_task = res/activity/rescue_station_task.csb
	local csbNode = csb.createNode("activity/rescue_station/rescue_station_task.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 每日礼盒
	self.Button_task_eveday_box = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task_eveday_box"), nil,
	{
		terminal_name = "rescue_station_task_draw_box",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
    
    -- 空礼盒
	self.Button_task_eveday_box = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task_eveday_box_k"), nil,
	{
		terminal_name = "rescue_station_task_draw_nil_box",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	-- 关闭
	self.Button_rescue_station_back = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rescue_station_back"), nil,
	{
		terminal_name = "rescue_station_task_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function RescueStationTask:onExit()
	-- 释放RescueStationTaskWindow界面资源.
	state_machine.remove("rescue_station_task_open")
	state_machine.remove("rescue_station_task_close")
	state_machine.remove("rescue_station_task_show")
	state_machine.remove("rescue_station_task_hide")
end

function RescueStationTask:close()
	-- window event : close.
	
end

function RescueStationTask:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
