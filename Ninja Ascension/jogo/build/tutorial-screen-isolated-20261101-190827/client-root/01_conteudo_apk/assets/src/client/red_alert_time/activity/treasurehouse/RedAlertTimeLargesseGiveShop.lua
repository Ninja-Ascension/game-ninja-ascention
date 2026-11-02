-- ------------------------------------------------------------------------------------------------------------
--  慷慨馈赠的奖励界面
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeLargesseGiveShop = class("RedAlertTimeLargesseGiveShopClass", Window)

local red_alert_time_largesse_give_shop_window_open_terminal = {
	_name = "red_alert_time_largesse_give_shop_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)       
    	local tab = RedAlertTimeLargesseGiveShop:new():init(params)
    	fwin:open(tab)     
		return tab
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(red_alert_time_largesse_give_shop_window_open_terminal)
state_machine.init()

function RedAlertTimeLargesseGiveShop:ctor()
	self.super:ctor()
	self.roots = {}
	self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0
    self._Image_seek_rank_arrow_down = nil
    self._Image_seek_rank_arrow_up = nil

    app.load("client.red_alert_time.cells.activity.treasurehouse.activity_largesse_give_shop_cell")

	local function init_red_alert_time_largesse_give_shop_terminal()
		--显示界面
		local red_alert_time_largesse_give_shop_show_terminal = {
			_name = "red_alert_time_largesse_give_shop_show",
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
                            response.node:updateDraw()
                        end
                    end
                end
                local rank = 1
                local activity_data = acitvity.activity_data[1]
                for k,v in pairs(activity_data) do
                    if tonumber(v.achieve_state) == 0 then
                        rank = k
                        break
                    end
                end
                local group = "0"
                local protocolType = "2"
                local curr_page = "" 
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..instance._activity_type.activity_type.."\r\n"..group.."\r\n"..(rank - 1).."\r\n"..protocolType
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
			end,
			_terminal = nil,
			_terminals = nil
		}
		--刷新
        local red_alert_time_largesse_give_buy_update_terminal = {
            _name = "red_alert_time_largesse_give_buy_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
            end,
            _terminal = nil,
            _terminals = nil
        }
        --领取
        local red_alert_time_largesse_give_buy_get_reward_terminal = {
            _name = "red_alert_time_largesse_give_buy_get_reward",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local activity_info = _ED.activity_info[""..self._activity_type.activity_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("red_alert_time_largesse_give_buy_update", 0, "")
                        end
                        checkRewardObtainDraw()
                        state_machine.excute("notification_center_update", 0, "push_notification_largesse_give_rank")
                    end
                end
                local rank = 0
                local arry_ranking = _ED.largesse_give_points_ranking
                local group = "0"
                local protocolType = "3"
                for i,v in pairs(arry_ranking) do
                    if v.name == _ED.user_info.user_name then
                        rank = i
                    end
                end
                local rewardInfo = activity_info.activity_data[1]
                for k,v in pairs(rewardInfo) do
                    local info = zstring.split(v.achieve_other_info, ",")
                    if rank >= tonumber(info[1]) and rank <= tonumber(info[2]) then
                        rank = k
                        break
                    end
                end
                local curr_page = "" 
                protocol_command.draw_activity_reward.param_list = activity_info.activity_id.."\r\n"..activity_info.activity_type.."\r\n"..group.."\r\n"..(rank - 1).."\r\n"..protocolType.."\r\n"..curr_page
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_largesse_give_buy_get_reward_terminal)
        state_machine.add(red_alert_time_largesse_give_buy_update_terminal)
		state_machine.add(red_alert_time_largesse_give_shop_show_terminal)
		state_machine.init()
	end	
	init_red_alert_time_largesse_give_shop_terminal()
end

function RedAlertTimeLargesseGiveShop:updateReward()
    local root = self.roots[1]
    local ListView_seek_treasure_rank = ccui.Helper:seekWidgetByName(root, "ListView_seek_treasure_reward")
    self._list_view = ListView_seek_treasure_rank
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()   
    local result = _ED.activity_info[""..self._activity_type.activity_type].activity_data[1]
    
    for k, v in pairs(result) do
        local cell = state_machine.excute("activity_largesse_give_shop_create_cell", 0, {k, v, self._activity_type.activity_type})
        ListView_seek_treasure_rank:addChild(cell)
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()
end

function RedAlertTimeLargesseGiveShop:updateDraw()
	local root = self.roots[1]
    self._activity_type = _ED.activity_info[""..self._activity_type.activity_type]
    self._activity_data = self._activity_type.activity_data[1]
    
    --我的慷慨值
    local activity_add_state = zstring.split(self._activity_type.activity_add_state,",")
    local Text_seek_treasure_rank_me_t_2 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_2")    
    Text_seek_treasure_rank_me_t_2:setString(activity_add_state[2])
    local have_score = activity_add_state[5]
    local floor_score = activity_add_state[10]

    --我的排名
    local Text_seek_treasure_rank_me_t_4 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_4")  
    local Text_seek_treasure_rank_me_t_6 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_6")  
    --领取按钮
    local Button_seek_treasure_rec = ccui.Helper:seekWidgetByName(root,"Button_seek_treasure_rec")                 
    Button_seek_treasure_rec:setBright(false)

    local haveScore = math.floor(have_score)
    Text_seek_treasure_rank_me_t_2:setString(haveScore)
    --最低进榜
    Text_seek_treasure_rank_me_t_6:setString(exChangeNumToString(floor_score))
    --我的排名
    Text_seek_treasure_rank_me_t_4:setString(activity_str_tip[40])
    local isHaveRank = false
    for i,v in pairs(_ED.largesse_give_points_ranking) do
        if v.name == _ED.user_info.user_name then
            Text_seek_treasure_rank_me_t_4:setString(v.rank)
            isHaveRank = true
        end
    end

    local Text_seek_treasure_rank_me_t_1 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_1")
    local Text_seek_treasure_rank_me_t_5 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_5")
    local curr_str = tipStringInfo_rank_type[22]
    Text_seek_treasure_rank_me_t_1:setString(string.format(tipStringInfo_rank_type[19], curr_str))
    Text_seek_treasure_rank_me_t_5:setString(string.format(tipStringInfo_rank_type[20], curr_str))
    Text_seek_treasure_rank_me_t_5:ignoreContentAdaptWithSize(true)
    Text_seek_treasure_rank_me_t_2:setPositionX(Text_seek_treasure_rank_me_t_1:getPositionX() + Text_seek_treasure_rank_me_t_1:getContentSize().width)
    Text_seek_treasure_rank_me_t_6:setPositionX(Text_seek_treasure_rank_me_t_5:getPositionX() + Text_seek_treasure_rank_me_t_5:getContentSize().width)


    -- 领取状态
    local Button_seek_treasure_rec = ccui.Helper:seekWidgetByName(root, "Button_seek_treasure_rec")
    if tonumber(activity_add_state[3])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
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

function RedAlertTimeLargesseGiveShop:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_seek_rank_arrow_down:setVisible(true)
        else
            self._Image_seek_rank_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_seek_rank_arrow_up:setVisible(true)
        else
            self._Image_seek_rank_arrow_up:setVisible(false)
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

function RedAlertTimeLargesseGiveShop:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.seek_treasure_tab_3)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    --领取
    local Button_seek_treasure_rec = ccui.Helper:seekWidgetByName(root,"Button_seek_treasure_rec")
    fwin:addTouchEventListener(Button_seek_treasure_rec, nil, 
    {
        terminal_name = "red_alert_time_largesse_give_buy_get_reward", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1)
    Button_seek_treasure_rec:setTouchEnabled(false)
    Button_seek_treasure_rec:setBright(false)

    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_seek_rank_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_seek_reward_arrow_down")
    self._Image_seek_rank_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_seek_reward_arrow_up")
    self._Image_seek_rank_arrow_down:stopAllActions()
    self._Image_seek_rank_arrow_up:stopAllActions()
    playActions(self._Image_seek_rank_arrow_down)
    playActions(self._Image_seek_rank_arrow_up)
    self._Image_seek_rank_arrow_down:setVisible(false)
    self._Image_seek_rank_arrow_up:setVisible(false)

    self:updateReward()

    local acitvity = _ED.activity_info[""..self._activity_type.activity_type]
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:updateDraw()
            end
        end
    end
    local rank = 1
    local activity_data = acitvity.activity_data[1]
    for k,v in pairs(activity_data) do
        if tonumber(v.achieve_state) == 0 then
            rank = k
            break
        end
    end
    local group = "0"
    local protocolType = "2"
    local curr_page = "" 
    protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..self._activity_type.activity_type.."\r\n"..group.."\r\n"..(rank - 1).."\r\n"..protocolType.."\r\n"..curr_page
    NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, self, responseCallback, false, nil)  
end

function RedAlertTimeLargesseGiveShop:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeLargesseGiveShop:onExit()
    state_machine.remove("red_alert_time_largesse_shop_buy_show")
end