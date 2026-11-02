-- ------------------------------------------------------------------------------------------------------------
--  说明：科威特排名奖励，摧枯拉朽,火线将领 ,军事讲坛
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeSecretReward = class("RedAlertTimeSecretRewardClass", Window)

--打开界面
local red_alert_time_secret_reward_open_terminal = {
    _name = "red_alert_time_secret_reward_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = RedAlertTimeSecretReward:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_secret_reward_open_terminal)
state_machine.init()

function RedAlertTimeSecretReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._activity_data = nil

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._Image_seek_reward_arrow_down = nil
    self._Image_seek_reward_arrow_up = nil

    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_consumption_turntable_reward_cell")
    app.load("client.red_alert_time.cells.props.props_icon_cell")
    local function init_red_alert_time_secret_reward_terminal()
        local red_alert_time_secret_reward_show_terminal = {
            _name = "red_alert_time_secret_reward_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
				local acitvity = _ED.activity_info[""..instance._activity_type.activity_type]
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
							response.node:onUpdateRankInfo()
						end
					end
				end		
                local rank = 0
                local protocolType = "1"
                local group = "0" 
                if tonumber(instance._activity_type.activity_type) == 67 or tonumber(instance._activity_type.activity_type) == 99 
                    or tonumber(instance._activity_type.activity_type) == 101 then
                    instance._activity_data = acitvity.activity_data[1]
                    group = "0"
                    protocolType = "2"
                elseif tonumber(instance._activity_type.activity_type) == 97 then
                    instance._activity_data = acitvity.activity_data[2]
                    group = "1"
                    protocolType = "1"
                elseif tonumber(instance._activity_type.activity_type) == 127 then -- 火力全开
                    instance._activity_data = acitvity.activity_data[2]
                    group = "0"
                    protocolType = "1"
                end 
                local rank = 0
                for k,v in pairs(instance._activity_data) do
                    if tonumber(v.achieve_state) == 0 then
                        rank = k
                        break
                    end
                end
                local curr_page = "" 
                if tonumber(instance._activity_type.activity_type) == 101 then
                    curr_page = "0" 
                end
				protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..instance._activity_type.activity_type.."\r\n"..group.."\r\n"..(rank - 1).."\r\n"..protocolType.."\r\n"..curr_page
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_secret_reward_hide_terminal = {
            _name = "red_alert_time_secret_reward_hide",
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

        local red_alert_time_secret_reward_update_draw_terminal = {
            _name = "red_alert_time_secret_reward_update_draw",
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

        local red_alert_time_secret_reward_update_rank_info_terminal = {
            _name = "red_alert_time_secret_reward_update_rank_info",
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

        local red_alert_time_secret_reward_get_reward_terminal = {
            _name = "red_alert_time_secret_reward_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local activity_type = instance._activity_type.activity_type
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("red_alert_time_secret_reward_update_rank_info", 0, "")
                        end
                        checkRewardObtainDraw()
                        if tonumber(activity_type) == 67 then
                            state_machine.excute("notification_center_update", 0, "push_notification_seek_treasure")
                        elseif tonumber(activity_type) == 97 then
                            state_machine.excute("notification_center_update", 0, "push_notification_treasurehouse_military_exploit")
                        elseif tonumber(activity_type) == 99 then
                            state_machine.excute("notification_center_update", 0, "push_notification_treasurehouse_leader_senior")
                        elseif tonumber(activity_type) == 101 then
                            state_machine.excute("notification_center_update", 0, "push_notification_treasurehouse_military_pulpit_rank")
                        elseif tonumber(activity_type) == 127 then -- 火力全开
                            state_machine.excute("notification_center_update", 0, "push_notification_treasurehouse_full_vitality_rank")
                        end
                    end
                end
                local rank = 0
                local arry_ranking = {}
                local group = "0"
                local protocolType = "0"
                if tonumber(activity_type) == 67 then -- 超级配件
                    group = "0"
                    arry_ranking = _ED.accessories_points_ranking
                    protocolType = "3"
                elseif tonumber(activity_type) == 97 then -- 摧枯拉朽
                    arry_ranking = _ED.military_exploit_points_ranking
                    group = "1"
                    protocolType = "0"
                elseif tonumber(activity_type) == 99 then -- 火线将领
                    arry_ranking = _ED.leader_senior_points_ranking
                    group = "0"
                    protocolType = "3"
                elseif tonumber(activity_type) == 101 then -- 军事讲坛
                    arry_ranking = _ED.military_pulpit_points_ranking
                    group = "0"
                    protocolType = "3"
                elseif tonumber(activity_type) == 127 then -- 火力全开
                    arry_ranking = _ED.full_vitality_activity_rank
                    group = "0"
                    protocolType = "2"
                end
                for i,v in pairs(arry_ranking) do
                    if v.name == _ED.user_info.user_name then
                        rank = i
                    end
                end
                local rewardInfo = instance._activity_data
                for k,v in pairs(rewardInfo) do
                    if tonumber(activity_type) == 97 then
                    else
                        local info = zstring.split(v.achieve_other_info, ",")
                        if rank >= tonumber(info[1]) and rank <= tonumber(info[2]) then
                            rank = k
                            break
                        end
                    end
                end
                local curr_page = "" 
                if tonumber(activity_type) == 101 then
                    curr_page = "0" 
                end
                protocol_command.draw_activity_reward.param_list = instance._activity_type.activity_id.."\r\n"..instance._activity_type.activity_type.."\r\n"..group.."\r\n"..(rank - 1).."\r\n"..protocolType.."\r\n"..curr_page
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_secret_reward_show_terminal)
        state_machine.add(red_alert_time_secret_reward_hide_terminal)
        state_machine.add(red_alert_time_secret_reward_update_draw_terminal)
        state_machine.add(red_alert_time_secret_reward_update_rank_info_terminal)
        state_machine.add(red_alert_time_secret_reward_get_reward_terminal)
        state_machine.init()
    end
    init_red_alert_time_secret_reward_terminal()
end

function RedAlertTimeSecretReward:onUpdateRankInfo()
    local root = self.roots[1]
    local Text_seek_treasure_rank_me_t_2 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_2")
    local Text_seek_treasure_rank_me_t_6 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_6")
    local Text_seek_treasure_rank_me_t_4 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_4")
    local Text_seek_treasure_rank_me_t_5 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_5")
    Text_seek_treasure_rank_me_t_2:setString("")
    Text_seek_treasure_rank_me_t_6:setString("")
    Text_seek_treasure_rank_me_t_5:setVisible(true)
	--已有积分
    local activity_info = _ED.activity_info[""..self._activity_type.activity_type]
	local datas = nil 
    local need_data = {
        have_score = 0,
        floor_score = 0,
    }
    local arry_ranking = {}
    local rewardTime = 0
    Text_seek_treasure_rank_me_t_6:setVisible(true)
    if tonumber(activity_info.activity_type) == 67 then -- 超级配件
        datas = zstring.split(activity_info.activity_add_state, ",")
        need_data.have_score = datas[4]
        need_data.floor_score = datas[11]
        arry_ranking = _ED.accessories_points_ranking
        rewardTime = datas[10]
        self._activity_data =  activity_info.activity_data[1]
    elseif tonumber(activity_info.activity_type) == 97 then -- 摧枯拉朽
        datas = zstring.split(activity_info.activity_add_state, ",")
        need_data.have_score = datas[4]
        need_data.floor_score = 0
        arry_ranking = _ED.military_exploit_points_ranking
        rewardTime = datas[3]
        self._activity_data =  activity_info.activity_data[2]
        Text_seek_treasure_rank_me_t_5:setVisible(false)
        Text_seek_treasure_rank_me_t_6:setVisible(false)
    elseif tonumber(activity_info.activity_type) == 99 then -- 火线将领
        local activity_add_state = zstring.split(activity_info.activity_add_state, "|")
        datas = zstring.split(activity_add_state[1], ",")
        local rank_info = zstring.split(activity_add_state[3], ",")
        need_data.have_score = rank_info[1]
        need_data.floor_score = rank_info[2]
        arry_ranking = _ED.leader_senior_points_ranking
        rewardTime = datas[3]
        self._activity_data =  activity_info.activity_data[1]
    elseif tonumber(activity_info.activity_type) == 101 then -- 军事讲坛
        local activity_add_state = zstring.split(activity_info.activity_add_state,"|")
        datas = zstring.split(activity_add_state[1],",")
        rewardTime = datas[3]
        local rank_info = zstring.split(activity_add_state[5], ",")
        need_data.have_score = rank_info[1]
        need_data.floor_score = rank_info[2]
        arry_ranking = _ED.military_pulpit_points_ranking
        self._activity_data =  activity_info.activity_data[1]
    elseif tonumber(activity_info.activity_type) == 127 then -- 火力全开
        datas = zstring.split(activity_info.activity_add_state, ",")
        need_data.have_score = datas[5]
        need_data.floor_score = datas[6]
        arry_ranking = _ED.full_vitality_activity_rank
        rewardTime = datas[3]
        self._activity_data =  activity_info.activity_data[2]
    end
    local haveScore = math.floor(need_data.have_score)
    if tonumber(activity_info.activity_type) == 97 
        or tonumber(activity_info.activity_type) == 127
        then
        haveScore = exChangeNumToString(need_data.have_score , true)
    end
	Text_seek_treasure_rank_me_t_2:setString(haveScore)
	--最低进榜
	Text_seek_treasure_rank_me_t_6:setString(exChangeNumToString(need_data.floor_score))
	--我的排名
	Text_seek_treasure_rank_me_t_4:setString(activity_str_tip[40])
    local isHaveRank = false
	for i,v in pairs(arry_ranking) do
		if v.name == _ED.user_info.user_name then
			Text_seek_treasure_rank_me_t_4:setString(v.rank)
            isHaveRank = true
		end
	end

    local Text_seek_treasure_rank_me_t_1 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_1")
    local Text_seek_treasure_rank_me_t_5 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_5")
    local curr_str = ""
    if tonumber(activity_info.activity_type) == 97 then
        curr_str = tipStringInfo_rank_type[3]
    elseif tonumber(activity_info.activity_type) == 101 then
        curr_str = tipStringInfo_rank_type[21]
    else
        curr_str = tipStringInfo_rank_type[6]
    end
    Text_seek_treasure_rank_me_t_1:setString(string.format(tipStringInfo_rank_type[19], curr_str))
    Text_seek_treasure_rank_me_t_5:setString(string.format(tipStringInfo_rank_type[20], curr_str))

    -- 领取状态
    local Button_seek_treasure_rec = ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_rec")
	if tonumber(rewardTime)/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
	else
        if isHaveRank == true then
            local already_receive = false
            local Button_seek_treasure_rec = ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_rec")
            for k,v in pairs(self._activity_data) do
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

function RedAlertTimeSecretReward:onUpdateDraw()
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

function RedAlertTimeSecretReward:onUpdate(dt)
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

function RedAlertTimeSecretReward:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.seek_treasure_tab_3)
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
        terminal_name = "red_alert_time_secret_reward_get_reward", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_5"):setVisible(false)
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
			if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
				response.node:onUpdateDraw()
			end
		end
	end
    local protocolType = "1"
    local group = "0" 
    if tonumber(self._activity_type.activity_type) == 67 or tonumber(self._activity_type.activity_type) == 99 
        or tonumber(self._activity_type.activity_type) == 101 then
        group = "0"
        protocolType = "2"
    elseif tonumber(self._activity_type.activity_type) == 97 then
        group = "1"
        protocolType = "1"
    elseif tonumber(self._activity_type.activity_type) == 127 then -- 火力全开
        group = "0"
        protocolType = "1"
    end 
    local rank = 0
    for k,v in pairs(self._activity_data) do
        if tonumber(v.achieve_state) == 0 then
            rank = k
            break
        end
    end
    local curr_page = "" 
    if tonumber(self._activity_type.activity_type) == 101 then
        curr_page = "0" 
    end
	protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..self._activity_type.activity_type.."\r\n"..group.."\r\n"..(rank - 1).."\r\n"..protocolType.."\r\n"..curr_page
	NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, self, responseCallback, false, nil)  
end

function RedAlertTimeSecretReward:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self._activity_type = params[2]
    if tonumber(self._activity_type.activity_type) == 67 or tonumber(self._activity_type.activity_type) == 99 
        or tonumber(self._activity_type.activity_type) == 101 then
        self._activity_data = self._activity_type.activity_data[1]
    elseif tonumber(self._activity_type.activity_type) == 97 then
        self._activity_data = self._activity_type.activity_data[2]
    elseif tonumber(self._activity_type.activity_type) == 127 then -- 火力全开
        self._activity_data = self._activity_type.activity_data[2]
    end
    self:onInit()
    return self
end

function RedAlertTimeSecretReward:onExit()
    state_machine.remove("red_alert_time_secret_reward_show")
    state_machine.remove("red_alert_time_secret_reward_hide")
    state_machine.remove("red_alert_time_secret_reward_update_draw")
    state_machine.remove("red_alert_time_secret_reward_update_rank_info")
    state_machine.remove("red_alert_time_secret_reward_get_reward")
end