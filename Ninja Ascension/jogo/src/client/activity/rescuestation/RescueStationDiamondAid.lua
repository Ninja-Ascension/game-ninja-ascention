--[[ ----------------------------------------------------------------------------
-- 钻石援助界面
--]] ----------------------------------------------------------------------------
RescueStationDiamondAid = class("RescueStationDiamondAidClass", Window)

-- 打开窗口
local rescue_station_diamond_aid_window_open_terminal = {
	_name = "rescue_station_diamond_aid_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RescueStationDiamondAidClass") then
			fwin:open(RescueStationDiamondAid:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local rescue_station_diamond_aid_window_close_terminal = {
	_name = "rescue_station_diamond_aid_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RescueStationDiamondAidClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(rescue_station_diamond_aid_window_open_terminal)
state_machine.add(rescue_station_diamond_aid_window_close_terminal)
state_machine.init()

-- 构造器
function RescueStationDiamondAid:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
    app.load("client.activity.rescuestation.RescueStation")
	local function init_rescue_station_diamond_aid_terminal()
		-- 打开角色创建窗口
		local rescue_station_diamond_aid_open_terminal = {
			_name = "rescue_station_diamond_aid_open",
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
		local rescue_station_diamond_aid_close_terminal = {
			_name = "rescue_station_diamond_aid_close",
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
		local rescue_station_diamond_aid_show_terminal = {
			_name = "rescue_station_diamond_aid_show",
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
		local rescue_station_diamond_aid_hide_terminal = {
			_name = "rescue_station_diamond_aid_hide",
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

		-- 捐赠钻石
		local rescue_station_diamond_aid_donation_terminal = {
			_name = "rescue_station_diamond_aid_donation",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local function callBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(tipStringInfo_rescue_station[7]) 
                    end
                end
                protocol_command.activity_pockmon_rescue_donation_item.param_list = params._datas._type.."\r\n"..1
                NetworkManager:register(protocol_command.activity_pockmon_rescue_donation_item.code, nil, nil, nil, instance, callBack, false, nil)

                local function rankcallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- La ventana pudo cerrarse antes de que llegara la respuesta.
                        if instance ~= nil and instance.onUpdateDraw ~= nil then
                            instance:onUpdateDraw()
                        end
                        state_machine.excute("rescue_station_uptate_info",0, "")
                    end
                end
                protocol_command.activity_pockmon_rescue_get_cross_rank.param_list = (1).."\r\n"..10
                NetworkManager:register(protocol_command.activity_pockmon_rescue_get_cross_rank.code, nil, nil, nil, instance, rankcallBack, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新
		local rescue_station_diamond_aid_update_rank_terminal = {
			_name = "rescue_station_diamond_aid_update_rank",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local function rankcallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if instance ~= nil and instance.onUpdateDraw ~= nil then
                            instance:onUpdateDraw()
                        end
                        state_machine.excute("rescue_station_uptate_info",0, "")
                    end
                end
                protocol_command.activity_pockmon_rescue_get_cross_rank.param_list = (1).."\r\n"..10
                NetworkManager:register(protocol_command.activity_pockmon_rescue_get_cross_rank.code, nil, nil, nil, instance, rankcallBack, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(rescue_station_diamond_aid_open_terminal)
		state_machine.add(rescue_station_diamond_aid_close_terminal)
		state_machine.add(rescue_station_diamond_aid_show_terminal)
		state_machine.add(rescue_station_diamond_aid_hide_terminal)
		state_machine.add(rescue_station_diamond_aid_donation_terminal)
		state_machine.add(rescue_station_diamond_aid_update_rank_terminal)
		
		state_machine.init()
	end
	-- call func init rescue station diamond aid state machine.
	init_rescue_station_diamond_aid_terminal()
end

-- 对象初始化
function RescueStationDiamondAid:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function RescueStationDiamondAid:drawTime(_time)
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

function RescueStationDiamondAid:onUpdate(dt)
	if self.Text_rare_time == nil or not self.end_time then
        return
    end
    local old_surplus_time = self.surplus_time
    self.surplus_time = (self.end_time - ((os.time() + _ED.time_add_or_sub))*1000)
    self.Text_rare_time:setString(self.surplus_time < 0 and _string_piece_info[305] or self:drawTime(self.surplus_time))

    if old_surplus_time and old_surplus_time >= 0 and 
   		self.surplus_time < 0 and not self._end_refresh then
   		self._end_refresh = true
   		state_machine.excute("rescue_station_diamond_aid_update_rank",0, "")
   	end
end

function RescueStationDiamondAid:onUpdateDraw()
	local root = self.roots[1]

    local score_one =  dms.int(dms["role_rescue_exchange"],1,3)    
	-- 捐赠50钻可获得积分
	self.Text_obtain_a_n = ccui.Helper:seekWidgetByName(root, "Text_obtain_a_n")
    self.Text_obtain_a_n:setString(score_one)
    
    local score_two =  dms.int(dms["role_rescue_exchange"],2,3)    
	-- 捐赠500钻可获得积分
	self.Text_obtain_b_n = ccui.Helper:seekWidgetByName(root, "Text_obtain_b_n")
    self.Text_obtain_b_n:setString(score_two)
    
    self.Text_rare_time = ccui.Helper:seekWidgetByName(root, "Text_rescue_time_n")
    
    self.end_time = tonumber(_ED.rescue_station_rank_info.activity_end_time) 
	
	if next(_ED.rescue_station_rank_info.rankInfo) == nil then
		return
	end

	-- 积分
	self.Text_current_points_n = ccui.Helper:seekWidgetByName(root, "Text_current_points_n")
	-- 排名
	self.Text_current_ranking_n = ccui.Helper:seekWidgetByName(root, "Text_current_ranking_n")

	if _ED.rescue_station_rank_info.myRank then
		self.Text_current_points_n:setString(_ED.rescue_station_rank_info.myRank.info.score)
		self.Text_current_ranking_n:setString(_ED.rescue_station_rank_info.myRank.rank)
	else
		self.Text_current_points_n:setString(0)
		self.Text_current_ranking_n:setString(tipStringInfo_pokemon_recharge_rank_tips[5])
	end


	self.Text_ranking_a_n = ccui.Helper:seekWidgetByName(root, "Text_ranking_a_n")  -- 排行榜第一名称
    if _ED.rescue_station_rank_info.rankInfo[1] then
		self.Text_ranking_a_n:setString(_ED.rescue_station_rank_info.rankInfo[1].info.nickname)
	end

	self.Text_ranking_b_n = ccui.Helper:seekWidgetByName(root, "Text_ranking_b_n")  -- 排行榜第二名称
	if _ED.rescue_station_rank_info.rankInfo[2] then
		self.Text_ranking_b_n:setString(_ED.rescue_station_rank_info.rankInfo[2].info.nickname)
	end

	self.Text_ranking_c_n = ccui.Helper:seekWidgetByName(root, "Text_ranking_c_n")  -- 排行榜第三名称
	if _ED.rescue_station_rank_info.rankInfo[3] then
		self.Text_ranking_c_n:setString(_ED.rescue_station_rank_info.rankInfo[3].info.nickname)
	end
    
    self.Text_ranking_a_j_n = ccui.Helper:seekWidgetByName(root, "Text_ranking_a_j_n")  -- 排行榜第一积分
    if _ED.rescue_station_rank_info.rankInfo[1] then
		self.Text_ranking_a_j_n:setString(_ED.rescue_station_rank_info.rankInfo[1].info.score)
	end

    self.Text_ranking_b_j_n = ccui.Helper:seekWidgetByName(root, "Text_ranking_b_j_n")  -- 排行榜第二积分
    if _ED.rescue_station_rank_info.rankInfo[2] then
		self.Text_ranking_b_j_n:setString(_ED.rescue_station_rank_info.rankInfo[2].info.score)
	end
	
	self.Text_ranking_c_j_n = ccui.Helper:seekWidgetByName(root, "Text_ranking_c_j_n")  -- 排行榜第三积分
	if _ED.rescue_station_rank_info.rankInfo[3] then
		self.Text_ranking_c_j_n:setString(_ED.rescue_station_rank_info.rankInfo[3].info.score)
	end


end

function RescueStationDiamondAid:onEnterTransitionFinish()
	-- 加载RescueStationDiamondAidWindow界面资源.
	-- res.activity.rescue_station_diamond_aid = res/activity/rescue_station_diamond_aid.csb
	local csbNode = csb.createNode("activity/rescue_station/rescue_station_diamond_aid.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
    self:registerOnNoteUpdate(self, 1)
	-- 捐赠500钻按钮
	self.Button_diamond_donation = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_diamond_donation"), nil,
	{
		terminal_name = "rescue_station_diamond_aid_donation",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_type = 2,
	}, nil, 0)	

	-- 捐赠50钻按钮
	self.Button_diamond_donation_a = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_diamond_donation_a"), nil,
	{
		terminal_name = "rescue_station_diamond_aid_donation",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_type = 1,
	}, nil, 0)	

	-- 关闭
	self.Button_station_diamond_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_station_diamond_closed"), nil,
	{
		terminal_name = "rescue_station_diamond_aid_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 刷新
	self.Button_re = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_re"), nil,
	{
		terminal_name = "rescue_station_diamond_aid_update_rank",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
	
	self:onUpdateDraw()
end

function RescueStationDiamondAid:onExit()
	-- 释放RescueStationDiamondAidWindow界面资源.
	state_machine.remove("rescue_station_diamond_aid_open")
	state_machine.remove("rescue_station_diamond_aid_close")
	state_machine.remove("rescue_station_diamond_aid_show")
	state_machine.remove("rescue_station_diamond_aid_hide")
end

function RescueStationDiamondAid:close()
	-- window event : close.
	
end

function RescueStationDiamondAid:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
