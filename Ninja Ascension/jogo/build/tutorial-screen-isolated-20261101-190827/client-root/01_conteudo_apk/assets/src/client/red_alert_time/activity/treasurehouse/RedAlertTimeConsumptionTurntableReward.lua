-- ------------------------------------------------------------------------------------------------------------
--  说明：消费转盘奖励
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeConsumptionTurntableReward = class("RedAlertTimeConsumptionTurntableRewardClass", Window)

--打开界面
local red_alert_time_consumption_turntable_reward_open_terminal = {
    _name = "red_alert_time_consumption_turntable_reward_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = RedAlertTimeConsumptionTurntableReward:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_consumption_turntable_reward_open_terminal)
state_machine.init()

function RedAlertTimeConsumptionTurntableReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_seek_reward_arrow_down = nil
    self._Image_seek_reward_arrow_up = nil

    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_consumption_turntable_reward_cell")
    app.load("client.red_alert_time.cells.props.props_icon_cell")
    local function init_red_alert_time_consumption_turntable_reward_terminal()
        local red_alert_time_consumption_turntable_reward_show_terminal = {
            _name = "red_alert_time_consumption_turntable_reward_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
				local acitvity = _ED.activity_info[""..self._activity_type.activity_type]
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							response.node:onUpdateRankInfo()
						end
					end
				end		
				protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..instance._activity_type.activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."2"
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_consumption_turntable_reward_hide_terminal = {
            _name = "red_alert_time_consumption_turntable_reward_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_consumption_turntable_reward_update_draw_terminal = {
            _name = "red_alert_time_consumption_turntable_reward_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local posY = instance._list_view_poy
                instance:onUpdateDraw()
                if math.abs(posY) > math.abs(instance._list_view_height) then
                    posY = instance._list_view_height
                end
                instance._list_view:getInnerContainer():setPositionY(posY)   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_consumption_turntable_reward_update_rank_info_terminal = {
            _name = "red_alert_time_consumption_turntable_reward_update_rank_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateRankInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_consumption_turntable_reward_get_reward_terminal = {
            _name = "red_alert_time_consumption_turntable_reward_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("red_alert_time_consumption_turntable_reward_update_rank_info", 0, "")
                        end
                        checkRewardObtainDraw()
                        state_machine.excute("notification_center_update", 0, "push_notification_consumption_turntable")
                    end
                end
                local activity_add_state = zstring.split(_ED.activity_info["81"].activity_add_state,",")
                local rank = zstring.tonumber(activity_add_state[13])
                local rewardInfo = _ED.activity_info["81"].activity_data[2]
                for k,v in pairs(rewardInfo) do
                    local info = zstring.split(v.achieve_other_info, ",")
                    if rank >= tonumber(info[1]) and rank <= tonumber(info[2]) then
                        rank = k
                    end
                end
                protocol_command.draw_activity_reward.param_list = _ED.activity_info["81"].activity_id .. "\r\n81\r\n1\r\n"..(rank - 1).."\r\n3"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_consumption_turntable_reward_show_terminal)
        state_machine.add(red_alert_time_consumption_turntable_reward_hide_terminal)
        state_machine.add(red_alert_time_consumption_turntable_reward_update_draw_terminal)
        state_machine.add(red_alert_time_consumption_turntable_reward_update_rank_info_terminal)
        state_machine.add(red_alert_time_consumption_turntable_reward_get_reward_terminal)
        state_machine.init()
    end
    init_red_alert_time_consumption_turntable_reward_terminal()
end

function RedAlertTimeConsumptionTurntableReward:onUpdateRankInfo()
    local root = self.roots[1]
    local activity_info = _ED.activity_info[""..self._activity_type.activity_type]
    local Text_seek_treasure_rank_me_t_2 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_2")
    local Text_seek_treasure_rank_me_t_6 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_6")
    local Text_seek_treasure_rank_me_t_4 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_4")
    Text_seek_treasure_rank_me_t_2:setString("")
    Text_seek_treasure_rank_me_t_6:setString("")
	--已有积分
	local datas = zstring.split(activity_info.activity_add_state, ",")
	Text_seek_treasure_rank_me_t_2:setString(math.floor(datas[6]))
	--最低进榜
	Text_seek_treasure_rank_me_t_6:setString(datas[12])
	--我的排名
	Text_seek_treasure_rank_me_t_4:setString(activity_str_tip[40])
    local isHaveRank = false
    if zstring.tonumber(datas[13]) > 0 then
		Text_seek_treasure_rank_me_t_4:setString(datas[13])
        isHaveRank = true
    end

    local Button_seek_treasure_rec = ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_rec")
    if tonumber(datas[11])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
    else
        if isHaveRank == true then
            local already_receive = false
            local Button_seek_treasure_rec = ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_rec")
            for k,v in pairs(activity_info.activity_data[2]) do
                if tonumber(v.achieve_state) == 2 then
                    already_receive = true
                    break
                end
            end
            if already_receive == true then
                Button_seek_treasure_rec:setTitleText(red_alert_time_str[129])
                Button_seek_treasure_rec:setBright(false)
                Button_seek_treasure_rec:setTouchEnabled(false)
            else
                Button_seek_treasure_rec:setTouchEnabled(true)
                Button_seek_treasure_rec:setBright(true)
            end
        end
    end
end

function RedAlertTimeConsumptionTurntableReward:onUpdateDraw()
    local root = self.roots[1]

    local ListView_seek_treasure_reward = ccui.Helper:seekWidgetByName(root, "ListView_seek_treasure_reward")
    self._list_view = ListView_seek_treasure_reward
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    for k,v in pairs(self._activity_data) do
        local cell = state_machine.excute("red_alert_time_consumption_turntable_reward_cell_create", 0, {k, v.achieve_mould_name,v.achieve_reward})
        self._list_view:addChild(cell)
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    self:onUpdateRankInfo()
end

function RedAlertTimeConsumptionTurntableReward:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_seek_reward_arrow_down:setVisible(true)
        else
            self._Image_seek_reward_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_seek_reward_arrow_up:setVisible(true)
        else
            self._Image_seek_reward_arrow_up:setVisible(false)
        end
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

function RedAlertTimeConsumptionTurntableReward:onInit()
    local csbItem = csb.createNode(string.format(config_csb.treasurehouse.seek_treasure_tab, 3))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 领取
    local Button_seek_treasure_rec = ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_rec")
    Button_seek_treasure_rec:setTouchEnabled(false)
    Button_seek_treasure_rec:setBright(false)
    Button_seek_treasure_rec:setTitleText(red_alert_time_str[128])
    fwin:addTouchEventListener(Button_seek_treasure_rec, nil, 
    {
        terminal_name = "red_alert_time_consumption_turntable_reward_get_reward", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    self._Image_seek_reward_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_seek_reward_arrow_down")
    self._Image_seek_reward_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_seek_reward_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_seek_reward_arrow_down:stopAllActions()
    self._Image_seek_reward_arrow_up:stopAllActions()
    playActions(self._Image_seek_reward_arrow_down)
    playActions(self._Image_seek_reward_arrow_up)
    self._Image_seek_reward_arrow_down:setVisible(false)
    self._Image_seek_reward_arrow_up:setVisible(false)

	local acitvity = _ED.activity_info[""..self._activity_type.activity_type]
	local function responseCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.roots ~= nil then
				response.node:onUpdateDraw()
			end
		end
	end		
	protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..self._activity_type.activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."2"
	NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, self, responseCallback, false, nil)  
end

function RedAlertTimeConsumptionTurntableReward:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self._activity_type = params[2]
    self._activity_data = self._activity_type.activity_data[2]
    self:onInit()
    return self
end

function RedAlertTimeConsumptionTurntableReward:onExit()
    state_machine.remove("red_alert_time_consumption_turntable_reward_show")
    state_machine.remove("red_alert_time_consumption_turntable_reward_hide")
    state_machine.remove("red_alert_time_consumption_turntable_reward_update_draw")
    state_machine.remove("red_alert_time_consumption_turntable_reward_update_rank_info")
    state_machine.remove("red_alert_time_consumption_turntable_reward_get_reward")
end