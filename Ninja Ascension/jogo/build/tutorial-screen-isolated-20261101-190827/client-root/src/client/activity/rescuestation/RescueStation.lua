--[[ ----------------------------------------------------------------------------
-- 救助站主界面
--]] ----------------------------------------------------------------------------
RescueStation = class("RescueStationClass", Window)

-- 打开窗口
local rescue_station_window_open_terminal = {
	_name = "rescue_station_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RescueStationClass") then
			--进入即请求排行榜数据
			 local function callBack( response )
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                  fwin:open(RescueStation:new():init(params), fwin._view) 
                end
            end
			protocol_command.activity_pockmon_rescue_get_cross_rank.param_list = (1).."\r\n"..10
			NetworkManager:register(protocol_command.activity_pockmon_rescue_get_cross_rank.code, nil, nil, nil, instance, callBack, false, nil)
		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local rescue_station_window_close_terminal = {
	_name = "rescue_station_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RescueStationClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(rescue_station_window_open_terminal)
state_machine.add(rescue_station_window_close_terminal)
state_machine.init()

-- 构造器
function RescueStation:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	self._curTime = 0

	app.load("client.activity.rescuestation.RescueStationDiamondAid")
	app.load("client.activity.rescuestation.RescueStationDonation")
	app.load("client.activity.rescuestation.RescueStationTask")
	app.load("client.activity.rescuestation.RescueStationRule")
	app.load("client.activity.rescuestation.RescueStationRewardPreview")
	app.load("client.activity.rescuestation.RescueStationShop")
	app.load("client.activity.rescuestation.RescueStationRank")
	
	local function init_rescue_station_terminal()
		-- 打开角色创建窗口
		local rescue_station_open_terminal = {
			_name = "rescue_station_open",
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
		local rescue_station_close_terminal = {
			_name = "rescue_station_close",
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
		local rescue_station_show_terminal = {
			_name = "rescue_station_show",
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
		local rescue_station_hide_terminal = {
			_name = "rescue_station_hide",
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

		-- 更新
		local rescue_station_uptate_info_terminal = {
			_name = "rescue_station_uptate_info",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local activity = _ED.active_activity[instance._activity_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end

                protocol_command.activity_pockmon_rescue_get_cross_rank.param_list = (1).."\r\n"..10
				NetworkManager:register(protocol_command.activity_pockmon_rescue_get_cross_rank.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 任务 捐赠 钻石 按钮
		local rescue_station_choose_button_terminal = {
			_name = "rescue_station_choose_button",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
			    if self.surplus_time and self.surplus_time < 0 then
			    	TipDlg.drawTextDailog(_string_piece_info[305]) 
			    	return
			    end
			    if  params._datas._idex == 1 then
			    	state_machine.excute("rescue_station_task_window_open",0, "")
			    elseif params._datas._idex == 2 then
			    	state_machine.excute("rescue_station_donation_window_open",0, "")
			    elseif params._datas._idex == 3 then
			    	state_machine.excute("rescue_station_diamond_aid_window_open",0, "")
			    end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

	
		state_machine.add(rescue_station_open_terminal)
		state_machine.add(rescue_station_close_terminal)
		state_machine.add(rescue_station_show_terminal)
		state_machine.add(rescue_station_hide_terminal)
		state_machine.add(rescue_station_uptate_info_terminal)
        state_machine.add(rescue_station_choose_button_terminal)
		state_machine.init()
	end
	init_rescue_station_terminal()
end

-- 对象初始化
function RescueStation:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function RescueStation:onUpdate(dt)
	if self.Text_time and self._curTime > 0 then
        self._curTime = self._curTime + dt
        self.Text_time:setString(os.date("%H"..":".."%M"..":%S", getBaseGTM8Time(self._curTime)))
    end


	if self.Text_rare_time == nil or not self.end_time then
        return
    end

    local old_surplus_time = self.surplus_time
    self.surplus_time = (self.end_time - ((os.time() + _ED.time_add_or_sub))*1000)
    local activity_end_time =  (self.draw_end_time - ((os.time() + _ED.time_add_or_sub))*1000) 

    if self.surplus_time < 0 then
       self.Text_rescue_time_t:setString(tipStringInfo_rescue_station[13])
    end

   	if old_surplus_time and old_surplus_time >= 0 and 
   		self.surplus_time < 0 and not self._end_refresh then
   		self._end_refresh = true
   		state_machine.excute("rescue_station_uptate_info",0, "")
   	end

    if activity_end_time < 0 then
        self.Text_rare_time:setString(_string_piece_info[305])
    else
    	self.Text_rare_time:setString(self.surplus_time < 0 and self:drawTime(activity_end_time) or self:drawTime(self.surplus_time))
    end
end

function RescueStation:drawTime(_time)
    local timeString = ""
    local _dayTime = math.floor((_time / 1000) / 86400)
    local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
    local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
    local _secondsTime = math.ceil((_time / 1000) % 60)
    if _dayTime > 0 then
        timeString = timeString .. _dayTime .._string_piece_info[231]
    end
    if _hourTime > 0 then
        if _hourTime < 10 then
            timeString = timeString .. "0".._hourTime ..":"
        else
            timeString = timeString .. _hourTime ..":"
        end
    end
    if _minutesTime > 0 then
        if _minutesTime < 10 then
            timeString = timeString .. "0".._minutesTime ..":"
        else
            timeString = timeString .. _minutesTime ..":"
        end
    end
    if _secondsTime > 0 then
        if _secondsTime < 10 then
            timeString = timeString .. "0".._secondsTime 
        else
            timeString = timeString .. _secondsTime 
        end
    end
    return timeString
end


function RescueStation:updateCurTime()
	self._curTime = os.time() - _ED.native_time + _ED.system_time
end

function RescueStation:onUpdateDraw()
	local root = self.roots[1]

    local jsonFile = "images/ui/effice/effect_bkmsjls/effect_bkmsjls.json"      --背景光效
    local atlasFile = "images/ui/effice/effect_bkmsjls/effect_bkmsjls.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    local Panel_bg_effect = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_bg_effect") 
    Panel_bg_effect:removeAllChildren(true) 
    Panel_bg_effect:addChild(animation)

    self.Text_rescue_time_t = ccui.Helper:seekWidgetByName(root, "Text_rescue_time_t") 

	self.Text_current_points_n = ccui.Helper:seekWidgetByName(root, "Text_current_points_n") -- 积分
	 
    self.Text_rare_time = ccui.Helper:seekWidgetByName(root, "Text_rescue_time_n")
    
    self.end_time = tonumber(_ED.rescue_station_rank_info.activity_end_time) 

	local info =  _ED.active_activity[159]
    self.draw_end_time = info.end_time 

	self.Text_current_ranking_n = ccui.Helper:seekWidgetByName(root, "Text_current_ranking_n") -- 排名
	if _ED.rescue_station_rank_info.myRank then
		self.Text_current_ranking_n:setString(_ED.rescue_station_rank_info.myRank.rank)
		self.Text_current_points_n:setString(_ED.rescue_station_rank_info.myRank.info.score)
	else
		self.Text_current_ranking_n:setString(tipStringInfo_pokemon_recharge_rank_tips[5])
		self.Text_current_points_n:setString(0)
	end

	-- 服务器当前时间
	self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
	self:updateCurTime()
end

function RescueStation:onEnterTransitionFinish()
	-- 加载RescueStationWindow界面资源.
	local csbNode = csb.createNode("activity/rescue_station/rescue_station.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
    self:registerOnNoteUpdate(self, 1)
	--state_machine.excute("rescue_station_diamond_aid_window_open",0,nil)  
	-- 救助任务
	self.Button_rescue_station_task = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rescue_station_task"), nil,
	{
		terminal_name = "rescue_station_choose_button",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_idex = 1,
	}, nil, 0)	

	-- 道具捐赠
	self.Button_prop_donation = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_prop_donation"), nil,
	{
		terminal_name = "rescue_station_choose_button",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_idex = 2,
	}, nil, 0)	

	-- 钻石援助
	self.Button_diamond_aid = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_diamond_aid"), nil,
	{
		terminal_name = "rescue_station_choose_button",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_idex = 3,
	}, nil, 0)	

	-- 救助排名
	self.Button_rescue_ranking = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rescue_ranking"), nil,
	{
		terminal_name = "rescue_station_rank_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 积分兑换
	self.Button_redeem = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_redeem"), nil,
	{
		terminal_name = "rescue_station_shop_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 奖励预览
	self.Button_reward_preview = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reward_preview"), nil,
	{
		terminal_name = "rescue_station_reward_preview_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 活动说明
	self.Button_event_description = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_event_description"), nil,
	{
		terminal_name = "rescue_station_rule_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_rescue_station_back = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rescue_station_back"), nil,
	{
		terminal_name = "rescue_station_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 更新
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_re"), nil, 
    {
        terminal_name = "rescue_station_uptate_info",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)

	self:onUpdateDraw()
	fwin:close(fwin:find("UserTopInfoAClass"))
	app.load("client.player.UserTopInfoA")
	fwin:open(UserTopInfoA:new(), fwin._windows)
end

function RescueStation:onExit()
	-- 释放RescueStationWindow界面资源.
	fwin:close(fwin:find("UserTopInfoAClass"))
	state_machine.remove("rescue_station_open")
	state_machine.remove("rescue_station_close")
	state_machine.remove("rescue_station_show")
	state_machine.remove("rescue_station_hide")
end

function RescueStation:close()
	-- window event : close.
	
end

function RescueStation:destroy(window)
	-- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
