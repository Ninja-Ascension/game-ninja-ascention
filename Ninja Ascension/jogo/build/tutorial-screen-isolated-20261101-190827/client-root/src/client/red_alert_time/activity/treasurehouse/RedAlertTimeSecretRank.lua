-- ------------------------------------------------------------------------------------------------------------
--  说明：科威特秘密排行,摧枯拉朽,火线将领，军事讲坛
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeSecretRank = class("RedAlertTimeSecretRankClass", Window)

--打开界面
local red_alert_time_secret_rank_open_terminal = {
    _name = "red_alert_time_secret_rank_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = RedAlertTimeSecretRank:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_secret_rank_open_terminal)
state_machine.init()

function RedAlertTimeSecretRank:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._activity_type = nil

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_seek_rank_arrow_down = nil
    self._Image_seek_rank_arrow_up = nil

    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_seek_treasure_rank_cell")

    local function init_red_alert_time_secret_rank_terminal()
        local red_alert_time_secret_rank_show_terminal = {
            _name = "red_alert_time_secret_rank_show",
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
							response.node:onUpdateDraw()
						end
					end
				end	
                local activity_data = nil
                local protocolType = "1"
                local group = "0" 
                if tonumber(instance._activity_type.activity_type) == 67 or tonumber(instance._activity_type.activity_type) == 99 
                    or tonumber(instance._activity_type.activity_type) == 101 then
                    activity_data = acitvity.activity_data[1]
                    group = "0"
                    protocolType = "2"
                elseif tonumber(instance._activity_type.activity_type) == 97 then
                    activity_data = acitvity.activity_data[2]
                    group = "1"
                    protocolType = "1"
                elseif tonumber(instance._activity_type.activity_type) == 118 then
                    activity_data = acitvity.activity_data[1]
                    group = "0"
                    protocolType = "2"
                elseif tonumber(instance._activity_type.activity_type) == 127 then -- 火力全开
                    activity_data = acitvity.activity_data[2]
                    group = "0"
                    protocolType = "1"
                end	
                local rank = 1
                for k,v in pairs(activity_data) do
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

        local red_alert_time_secret_rank_hide_terminal = {
            _name = "red_alert_time_secret_rank_hide",
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

        local red_alert_time_secret_rank_update_draw_terminal = {
            _name = "red_alert_time_secret_rank_update_draw",
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

        local red_alert_time_secret_rank_update_rank_info_terminal = {
            _name = "red_alert_time_secret_rank_update_rank_info",
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

        state_machine.add(red_alert_time_secret_rank_show_terminal)
        state_machine.add(red_alert_time_secret_rank_hide_terminal)
        state_machine.add(red_alert_time_secret_rank_update_draw_terminal)
        state_machine.add(red_alert_time_secret_rank_update_rank_info_terminal)
        state_machine.init()
    end
    init_red_alert_time_secret_rank_terminal()
end

function RedAlertTimeSecretRank:onUpdateRankInfo()
    local root = self.roots[1]
    local activity_type = self._activity_type.activity_type
    -- 玩家自己的排名信息
    local Text_seek_treasure_rank_me_t_1 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_1")
    local Text_seek_treasure_rank_me_t_2 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_2")
    local Text_seek_treasure_rank_me_t_6 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_6")
    local Text_seek_treasure_rank_me_t_4 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_4")
    local Text_seek_treasure_rank_me_t_5 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_5")
	Text_seek_treasure_rank_me_t_2:setString("")
	Text_seek_treasure_rank_me_t_6:setString("")
	Text_seek_treasure_rank_me_t_4:setString("")
    Text_seek_treasure_rank_me_t_5:setVisible(true)
    Text_seek_treasure_rank_me_t_6:setVisible(true)
    local datas = nil
    local activity_add_state = _ED.activity_info[""..self._activity_type.activity_type].activity_add_state
    local need_data = {
        have_score = 0,
        floor_score = 0,
    }
    local arry_ranking = {}
    if tonumber(activity_type) == 67 then -- 超级配件
        datas = zstring.split(activity_add_state, ",")
        need_data.have_score = datas[4]
        need_data.floor_score = datas[11]
        arry_ranking = _ED.accessories_points_ranking
    elseif tonumber(activity_type) == 97 then -- 摧枯拉朽
        datas = zstring.split(activity_add_state, ",")
        need_data.have_score = datas[4]
        need_data.floor_score = 0
        arry_ranking = _ED.military_exploit_points_ranking
        Text_seek_treasure_rank_me_t_5:setVisible(false)
        Text_seek_treasure_rank_me_t_6:setVisible(false)
    elseif tonumber(activity_type) == 99 then -- 火线将领
        local activity_add_state = zstring.split(activity_add_state, "|")
        datas = zstring.split(activity_add_state[3], ",")
        need_data.have_score = datas[1]
        need_data.floor_score = datas[2]
        arry_ranking = _ED.leader_senior_points_ranking
    elseif tonumber(activity_type) == 101 then -- 军事讲坛
        local activity_add_state = zstring.split(activity_add_state, "|")
        datas = zstring.split(activity_add_state[5], ",")
        need_data.have_score = datas[1]
        need_data.floor_score = datas[2]
        arry_ranking = _ED.military_pulpit_points_ranking
    elseif tonumber(activity_type) == 118 then -- 慷慨馈赠
        datas = zstring.split(activity_add_state, ",")
        need_data.have_score = datas[5]
        need_data.floor_score = datas[10]
        arry_ranking = _ED.largesse_give_points_ranking
    elseif tonumber(activity_type) == 127 then -- 火力全开
        datas = zstring.split(activity_add_state, ",")
        need_data.have_score = datas[5]
        need_data.floor_score = datas[6]
        arry_ranking = _ED.full_vitality_activity_rank
    end
    --已有积分
    local number = math.floor(need_data.have_score)
    if tonumber(activity_type) == 97 
        or tonumber(activity_type) == 127
        then
        number = exChangeNumToString(need_data.have_score , true)
    end
    Text_seek_treasure_rank_me_t_2:setString(number)
    --最低进榜
    Text_seek_treasure_rank_me_t_6:setString(exChangeNumToString(need_data.floor_score))
    --我的排名
    Text_seek_treasure_rank_me_t_4:setString(activity_str_tip[40])
	for i,v in pairs(arry_ranking) do
        if v.name == _ED.user_info.user_name then
			Text_seek_treasure_rank_me_t_4:setString(v.rank)
		end
	end
end

function RedAlertTimeSecretRank:onUpdateDraw()
    local root = self.roots[1]
    local activity_type = self._activity_type.activity_type

    local ListView_seek_treasure_rank = ccui.Helper:seekWidgetByName(root, "ListView_seek_treasure_rank")
    self._list_view = ListView_seek_treasure_rank
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()
	local index = 0
    local arry_ranking = {}
    if tonumber(activity_type) == 67 then -- 超级配件
        arry_ranking = _ED.accessories_points_ranking
    elseif tonumber(activity_type) == 97 then -- 摧枯拉朽
        arry_ranking = _ED.military_exploit_points_ranking
    elseif tonumber(activity_type) == 99 then -- 火线将领
        arry_ranking = _ED.leader_senior_points_ranking
    elseif tonumber(activity_type) == 101 then -- 军事讲坛
        arry_ranking = _ED.military_pulpit_points_ranking
    elseif tonumber(activity_type) == 118 then -- 慷慨馈赠
        arry_ranking = _ED.largesse_give_points_ranking
    elseif tonumber(activity_type) == 127 then -- 火力全开
        arry_ranking = _ED.full_vitality_activity_rank
    end
	for i,v in pairs(arry_ranking) do
		index = index + 1
        local cell = state_machine.excute("red_alert_time_seek_treasure_rank_cell_create", 0, {v,_ED.activity_info[""..self._activity_type.activity_type],index})
        self._list_view:addChild(cell)
	end
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()

    local Text_seek_treasure_rank_t_3 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_t_3")
    local Text_seek_treasure_rank_me_t_1 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_1")
    local Text_seek_treasure_rank_me_t_5 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_5")
    local Text_seek_treasure_rank_me_t_2 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_2")
    local Text_seek_treasure_rank_me_t_6 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_6")
    Text_seek_treasure_rank_me_t_5:ignoreContentAdaptWithSize(true)
    local curr_str = ""
    if tonumber(activity_type) == 97 then
        curr_str = tipStringInfo_rank_type[3]
    elseif tonumber(activity_type) == 101 then
        curr_str = tipStringInfo_rank_type[21]
    elseif tonumber(activity_type) == 118 then
        curr_str = tipStringInfo_rank_type[22]
    else
        curr_str = tipStringInfo_rank_type[6]
    end
    Text_seek_treasure_rank_t_3:setString(curr_str)
    Text_seek_treasure_rank_me_t_1:setString(string.format(tipStringInfo_rank_type[19], curr_str))
    Text_seek_treasure_rank_me_t_5:setString(string.format(tipStringInfo_rank_type[20], curr_str))
    if tonumber(activity_type) == 118 then
        Text_seek_treasure_rank_me_t_2:setPositionX(Text_seek_treasure_rank_me_t_1:getPositionX() + Text_seek_treasure_rank_me_t_1:getContentSize().width)
        Text_seek_treasure_rank_me_t_6:setPositionX(Text_seek_treasure_rank_me_t_5:getPositionX() + Text_seek_treasure_rank_me_t_5:getContentSize().width)
    end
    self:onUpdateRankInfo()
end

function RedAlertTimeSecretRank:onUpdate(dt)
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

function RedAlertTimeSecretRank:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.seek_treasure_tab_2)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_seek_rank_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_seek_rank_arrow_down")
    self._Image_seek_rank_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_seek_rank_arrow_up")
    ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_5"):setVisible(false)
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_seek_rank_arrow_down:stopAllActions()
    self._Image_seek_rank_arrow_up:stopAllActions()
    playActions(self._Image_seek_rank_arrow_down)
    playActions(self._Image_seek_rank_arrow_up)
    self._Image_seek_rank_arrow_down:setVisible(false)
    self._Image_seek_rank_arrow_up:setVisible(false)
	local acitvity = _ED.activity_info[""..self._activity_type.activity_type]
	local function responseCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
				response.node:onUpdateDraw()
			end
		end
	end
    local activity_data = nil
    local protocolType = "1"
    local group = "0"
    if tonumber(self._activity_type.activity_type) == 67 or tonumber(self._activity_type.activity_type) == 99 
        or tonumber(self._activity_type.activity_type) == 101 then
        activity_data = acitvity.activity_data[1]
        group = "0"
        protocolType = "2"
    elseif tonumber(self._activity_type.activity_type) == 97 then
        activity_data = acitvity.activity_data[2]
        group = "1"
        protocolType = "1"
    elseif tonumber(self._activity_type.activity_type) == 118 then
        activity_data = acitvity.activity_data[1]
        group = "0"
        protocolType = "2"
    elseif tonumber(self._activity_type.activity_type) == 127 then -- 火力全开
        activity_data = acitvity.activity_data[2]
        group = "0"
        protocolType = "1"
    end 
    local rank = 1
    for k,v in pairs(activity_data) do
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

function RedAlertTimeSecretRank:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self._activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeSecretRank:onExit()
    state_machine.remove("red_alert_time_secret_rank_show")
    state_machine.remove("red_alert_time_secret_rank_hide")
    state_machine.remove("red_alert_time_secret_rank_update_draw")
    state_machine.remove("red_alert_time_secret_rank_update_rank_info")
end