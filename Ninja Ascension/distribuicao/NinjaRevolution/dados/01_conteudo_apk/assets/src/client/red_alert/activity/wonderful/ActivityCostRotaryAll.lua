--------------------------------------------------------------------------------------------------------------
--  说明：元宝大转盘(活动类型37)
--------------------------------------------------------------------------------------------------------------
ActivityCostRotaryAll = class("ActivityCostRotaryAllClass", Window)
-- 打开
local activity_cost_rotary_all_window_open_terminal = {
    _name = "activity_cost_rotary_all_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ActivityCostRotaryAllClass") then
            fwin:open(ActivityCostRotaryAll:new():init(), fwin._ui)
        end
        _ED.gold_rotary_tip = 0
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
-- 关闭
local activity_cost_rotary_all_window_close_terminal = {
    _name = "activity_cost_rotary_all_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("ActivityCostRotaryAllClass"))    
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_cost_rotary_all_window_open_terminal)
state_machine.add(activity_cost_rotary_all_window_close_terminal)
state_machine.init()

function ActivityCostRotaryAll:ctor()
    self.super:ctor()
    self.roots = {}
    -- 奖励绘制
    self._panel_list = {}
    self._image_list = {}
    -- 左侧列表
    self._list_view = nil
    -- 左侧列表坐标
    self._list_view_poy = 0
    -- 倒计时
    self.Text_limit_time_v = nil
    -- 转盘动画
    self._round = 0
    -- 活动剩余时间
    self._last_time = 0

    app.load("client.red_alert.cells.activity.wonderful.activity_cost_rotary_all_cell")

    local function init_activity_cost_rotary_all_terminal()
        --抽一次
		local activity_cost_rotary_all_get_reward_terminal = {
            _name = "activity_cost_rotary_all_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("activity_cost_rotary_all_get_reward")
                state_machine.lock("activity_cost_rotary_all_window_close")
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:beginRotary()
                        else
                            state_machine.unlock("activity_cost_rotary_all_get_reward")
                            state_machine.unlock("activity_cost_rotary_all_window_close")
                        end
                    else
                        state_machine.unlock("activity_cost_rotary_all_get_reward")
                        state_machine.unlock("activity_cost_rotary_all_window_close")
                    end
                end
                protocol_command.draw_activity_reward.param_list = _ED.activity_info["37"].activity_id .. "\r\n37\r\n0\r\n0\r\n1"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新
        local activity_cost_rotary_all_update_draw_terminal = {
            _name = "activity_cost_rotary_all_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 抽十次
        local activity_cost_rotary_all_get_reward_10_terminal = {
            _name = "activity_cost_rotary_all_get_reward_10",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open", 0, {1037})
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end
                protocol_command.draw_activity_reward.param_list = _ED.activity_info["37"].activity_id .. "\r\n37\r\n0\r\n0\r\n10"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 抽三十次
        local activity_cost_rotary_all_get_reward_30_terminal = {
            _name = "activity_cost_rotary_all_get_reward_30",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open", 0, {1037})
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end
                protocol_command.draw_activity_reward.param_list = _ED.activity_info["37"].activity_id .. "\r\n37\r\n0\r\n0\r\n30"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(activity_cost_rotary_all_get_reward_terminal)	
        state_machine.add(activity_cost_rotary_all_update_draw_terminal) 
        state_machine.add(activity_cost_rotary_all_get_reward_10_terminal) 
        state_machine.add(activity_cost_rotary_all_get_reward_30_terminal) 
        state_machine.init()
    end
    
    init_activity_cost_rotary_all_terminal()
end
-- 转盘抽奖动画结束
function ActivityCostRotaryAll:endRotary()
    self._round = 0
    state_machine.unlock("activity_cost_rotary_all_get_reward")
    state_machine.unlock("activity_cost_rotary_all_window_close")
    local function playActionOne(sender)
        if sender.roots ~= nil then
            sender:stopAllActions()
            sender:onUpdateDraw()
        end
        state_machine.excute("reward_obtain_window_open", 0, {1037})
    end
    local action = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(playActionOne)))
    self:runAction(action)
end
-- 转盘抽奖动画开始
function ActivityCostRotaryAll:beginRotary()
    local root = self.roots[1]
    local index = 0
    local delayTime = 0
    local max_times = 0
    self._round = self._round + 1
    if self._round == 1 then
        delayTime = 0.003
        max_times = 32
    elseif self._round == 2 then
        delayTime = 0.005
        max_times = 16
    elseif self._round == 3 then
        delayTime = 0.008
        max_times = 16 + zstring.tonumber(_ED.activity_rotary_index) - 1
    end
    local function playActionOne(sender)
        index = index + 1
        if index > max_times then
            sender:stopAllActions()
            if sender._round ~= 3 then
                sender:beginRotary()
            else
                sender:endRotary()
            end
        else
            local cell_index = math.floor(index%16)
            for k,v in pairs(sender._image_list) do
                if k == cell_index + 1 then
                    v:setVisible(true)
                else
                    v:setVisible(false)
                end
            end
        end
    end
    local action = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(delayTime),cc.CallFunc:create(playActionOne)))
    self:runAction(action)
end

function ActivityCostRotaryAll:onUpdateDraw()
    local root = self.roots[1]
    local activity_info = _ED.activity_info["37"]
    local activity_data = activity_info.activity_data[1]
    self._panel_list = {}
    self._image_list = {}
    -- 绘制奖励
    for i=1,16 do
		local function showCell()
			local panel = ccui.Helper:seekWidgetByName(root,"Panel_reward_"..i)
			local image = ccui.Helper:seekWidgetByName(root,"Image_reward_get_"..i)
			panel:removeAllChildren(true)
			image:setVisible(false)
			table.insert(self._panel_list, panel)
			table.insert(self._image_list, image)
			-- 如果奖励存在绘制奖励
			if activity_data ~= nil then
				local info = zstring.split(activity_data[i].achieve_reward, ",")
				local data = 
				{
					item_value = info[3],
					prop_type = info[2],
					prop_item = info[1],
				}
				local cell = nil
				if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.change_of_equipment))> 0 
					or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.use_of_ship)) > 0  then
					cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,9,0,false,true})
					if tonumber(data.prop_type) == 7 then 
						cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
					end
				else
					cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
				end  
				panel:addChild(cell)
			end
        end
		if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
			local run_action2  = cc.Sequence:create(cc.DelayTime:create(0.05*i),cc.CallFunc:create(showCell))
			self:runAction(run_action2)
		else
			showCell()
		end	
    end
    -- 已抽奖励次数
    local Text_choujaing_time_v = ccui.Helper:seekWidgetByName(root,"Text_choujaing_time_v")
    local infos = zstring.split(activity_info.activity_add_state, ",")
    Text_choujaing_time_v:setString(infos[2])
    -- 元宝总数
    local Text_gem_v = ccui.Helper:seekWidgetByName(root,"Text_gem_v")
    if tonumber(_ED.user_info.user_gold) >= 100000 then
        local info = math.floor(tonumber(_ED.user_info.user_gold)/10000)
        Text_gem_v:setString(string.format(red_alert_all_str[122],info))
    else
        Text_gem_v:setString(_ED.user_info.user_gold)
    end
    -- 抽奖价格
    local Text_200 = ccui.Helper:seekWidgetByName(root,"Text_200")      -- 抽一次
    Text_200:setString(infos[3])
    local Text_1800 = ccui.Helper:seekWidgetByName(root,"Text_1800")    -- 抽十次
    Text_1800:setString(infos[3]*10*0.9)
    local Text_4800 = ccui.Helper:seekWidgetByName(root,"Text_4800")    -- 抽三十次
    Text_4800:setString(infos[3]*30*0.8)
    -- 活动剩余时间
    self.Text_limit_time_v = ccui.Helper:seekWidgetByName(root,"Text_limit_time_v")
    self._last_time = tonumber(infos[4])/1000 - os.time()
    self:updateLeftReward()
end
-- 绘制左侧
function ActivityCostRotaryAll:updateLeftReward()
    local root = self.roots[1]
    local ListView_left = ccui.Helper:seekWidgetByName(root, "ListView_left")
    ListView_left:removeAllItems()
    ListView_left:jumpToTop()
    local index = 0 
    for k,v in pairs(_ED.activity_info["37"].activity_data[2]) do
        if tonumber(v.achieve_state) == 2 then
        else
            index = index + 1 
            local cell = state_machine.excute("activity_cost_rotary_all_create_cell", 0, {k, v, index})
            ListView_left:addChild(cell)
        end
    end
    ListView_left:requestRefreshView()
    self._list_view = ListView_left
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
end

function ActivityCostRotaryAll:onUpdate(dt)
    -- 活动剩余时间
    self._last_time = self._last_time - dt
    if self._last_time <= 0 then
        self._last_time = 0
    end
    local time = math.modf(self._last_time)
    local day = math.floor(tonumber(time)/3600/24)
    local hour = math.floor(tonumber(time)/3600%24)
    local minute = math.floor((tonumber(time)%3600)/60)
    local second = math.floor((tonumber(time)%3600)%60)
    if hour < 10 then
        hour = "0"..hour
    end
    if minute < 10 then
        minute = "0"..minute
    end
    if second < 10 then
        second = "0"..second
    end
    if self.Text_limit_time_v ~= nil then
        self.Text_limit_time_v:setString(string.format(red_alert_all_str[180], ""..day, ""..hour, ""..minute, ""..second))
    end
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function ActivityCostRotaryAll:onEnterTransitionFinish()

end

function ActivityCostRotaryAll:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.activity_cost_rotary_all)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "activity_cost_rotary_all_window_close", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    -- 抽一次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chou_1"), nil, 
    {
        terminal_name = "activity_cost_rotary_all_get_reward", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    -- 抽十次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chou_10"), nil, 
    {
        terminal_name = "activity_cost_rotary_all_get_reward_10", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    -- 抽三十次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chou_30"), nil, 
    {
        terminal_name = "activity_cost_rotary_all_get_reward_30", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
	self:onUpdateDraw()
end

function ActivityCostRotaryAll:init()
	self:onInit()
    return self
end

function ActivityCostRotaryAll:onExit()
    state_machine.remove("activity_cost_rotary_all_get_reward")
    state_machine.remove("activity_cost_rotary_all_update_draw")
    state_machine.remove("activity_cost_rotary_all_get_reward_10")
    state_machine.remove("activity_cost_rotary_all_get_reward_30")
end
