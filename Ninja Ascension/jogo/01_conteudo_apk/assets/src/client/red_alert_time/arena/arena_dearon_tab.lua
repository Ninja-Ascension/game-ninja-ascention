-- ----------------------------------------------------------------------------------------------------
-- 说明：战地争霸挑战界面
-------------------------------------------------------------------------------------------------------
ArenaDearonTab = class("ArenaDearonTabClass", Window)

local arena_dearon_tab_open_terminal = {
    _name = "arena_dearon_tab_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaDearonTabClass")
        if nil == _homeWindow then
    		fwin:open(ArenaDearonTab:new():init(params[1]), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local arena_dearon_tab_close_terminal = {
    _name = "arena_dearon_tab_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaDearonTabClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("ArenaDearonTabClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_dearon_tab_open_terminal)
state_machine.add(arena_dearon_tab_close_terminal)
state_machine.init()
    
function ArenaDearonTab:ctor()
    self.super:ctor()
    self.roots = {}
	self._current_page = 0
	self.oldRank = nil

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil

    self._is_cd_time = false
    self._text_cd_time = nil
    self.m_times = 0

	app.load("client.red_alert_time.cells.arena.arena_dearon_cell")
	app.load("client.red_alert_time.cells.worldMap.player_head_icon")
	app.load("client.red_alert_time.arena.arena_rank_up")
	app.load("client.red_alert_time.arena.arena_dearon_number_of_purchases")
	app.load("client.red_alert_time.worldMap.redAlertTimeMineWarmTips")
	app.load("client.red_alert_time.arena.arena_record")
	
	local function init_arena_dearon_tab_terminal()
		local arena_dearon_tab_show_terminal = {
            _name = "arena_dearon_tab_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local arena_dearon_tab_hide_terminal = {
            _name = "arena_dearon_tab_hide",
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
		
		local arena_dearon_tab_update_terminal = {
            _name = "arena_dearon_tab_update",
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
		
		local arena_dearon_tab_rank_change_update_terminal = {
            _name = "arena_dearon_tab_rank_change_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.oldRank = params
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--排名提升动画
		local arena_dearon_tab_rank_ascension_animation_terminal = {
            _name = "arena_dearon_tab_rank_ascension_animation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.oldRank ~= nil and tonumber(instance.oldRank.user_rank) == tonumber(_ED.arena_info.rank) then
					state_machine.excute("arena_rank_up_open", 0, instance.oldRank) 
					instance.oldRank = nil
                    _ED.arena_last_rank = tonumber(_ED.arena_info.rank)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--刷新攻击次数
		local arena_dearon_tab_update_attack_terminal = {
            _name = "arena_dearon_tab_update_attack",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawAttack()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--请求换一批
		local arena_dearon_tab_replace_the_opponent_terminal = {
            _name = "arena_dearon_tab_replace_the_opponent",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._is_cd_time == true then
                    local leave_time = _ED.arena_info.fight_cooling_time - (os.time() + _ED.time_add_or_sub)
                    local per_min_cost = dms.int(dms["arena_config"], 19, arena_config.param)
                    local cost = math.ceil(leave_time / 60) * per_min_cost
                    local tip = ConfirmTip:new()
                    tip:init(instance, instance.clearCdTime, string.format(red_alert_time_str[192], cost))
                    fwin:open(tip,fwin._windows) 
                else
				    state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = "", m_type = 6}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local arena_dearon_tab_refresh_opponent_terminal = {
            _name = "arena_dearon_tab_refresh_opponent",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseLounchCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
    						response.node:onUpdateDraw()
                            TipDlg.drawTextDailog(arena_tip_text[36])
                        end
					end
				end
				protocol_command.arena_lounch_refresh.param_list = "0" .. "\r\n" .. _ED.arena_info.arena_id
				NetworkManager:register(protocol_command.arena_lounch_refresh.code, nil, nil, nil, instance, responseLounchCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local arena_dearon_tab_supplement_time_terminal = {
            _name = "arena_dearon_tab_supplement_time",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local max_count = dms.int(dms["base_consume"], 92, base_consume.vip_0_value + tonumber(_ED.vip_grade))
                local count = max_count - zstring.tonumber(_ED.arena_info.buy_attack_count)
                if count > 0 then
                    state_machine.excute("arena_dearon_number_of_purchases_open", 0, "")
                else
                    TipDlg.drawTextDailog(red_alert_time_str[214])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local arena_dearon_tab_update_formation_fight_terminal = {
            _name = "arena_dearon_tab_update_formation_fight",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local new_fight_number = params
                -- 阵型改变时，服务器不会传挑战列表，由客户端更新本地数据
                for i,v in pairs(_ED.arena_info.user_info) do
                    if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
                        v.user_fight = new_fight_number
                        break
                    end
                end
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(arena_dearon_tab_show_terminal)
        state_machine.add(arena_dearon_tab_hide_terminal) 
        state_machine.add(arena_dearon_tab_update_terminal) 
        state_machine.add(arena_dearon_tab_rank_change_update_terminal) 
        state_machine.add(arena_dearon_tab_rank_ascension_animation_terminal) 
        state_machine.add(arena_dearon_tab_update_attack_terminal) 
        state_machine.add(arena_dearon_tab_replace_the_opponent_terminal) 
        state_machine.add(arena_dearon_tab_refresh_opponent_terminal) 
        state_machine.add(arena_dearon_tab_supplement_time_terminal) 
        state_machine.add(arena_dearon_tab_update_formation_fight_terminal) 
	
		state_machine.init()
	end
	
	init_arena_dearon_tab_terminal()
	
end

function ArenaDearonTab:clearCdTime( sure_number )
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("arena_dearon_tab_update", 0, "")
        end
    end
    if sure_number == 0 then
        protocol_command.arena_launch_clear_cd.param_list = "0"
        NetworkManager:register(protocol_command.arena_launch_clear_cd.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function ArenaDearonTab:updateDrawAttack()
    --计算火线支援活动加层
    local activity_add = 0
    if _ED.activity_info["91"] ~= nil then
        local timesData = zstring.split(_ED.activity_info["91"].activity_add_state, ",")
        self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        if self.m_times > 0 then
            activity_add = timesData[5]
        end
    end

	local root = self.roots[1]
	--攻击次数
	local Text_dearon_time_n = ccui.Helper:seekWidgetByName(root, "Text_dearon_time_n")
    Text_dearon_time_n:setString("")
    Text_dearon_time_n:removeAllChildren(true)
    local fontSize = Text_dearon_time_n:getFontSize()
    local count = zstring.tonumber(_ED.arena_info.buy_attack_count) + dms.int(dms["arena_config"],1,arena_config.param) + activity_add

    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)
    local curr_attack_number = _ED.arena_info.leave_attack_count + activity_add
    curr_attack_number = math.max(curr_attack_number,0)
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, curr_attack_number, "fonts/simhei.ttf",fontSize)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, string.format(arena_tip_text[30], ""..count), "fonts/simhei.ttf",fontSize)
    _richText:pushBackElement(re2)  
    _richText:setPosition(cc.p(Text_dearon_time_n:getContentSize().width/2,Text_dearon_time_n:getContentSize().height/2))
    _richText:setContentSize(cc.size(Text_dearon_time_n:getContentSize().width,22))
    Text_dearon_time_n:addChild(_richText)
end

function ArenaDearonTab:onUpdateDraw()
	local root = self.roots[1]

    local Text_dearon_count_down = ccui.Helper:seekWidgetByName(root, "Text_dearon_count_down")
    local Button_for_a_batch_0 = ccui.Helper:seekWidgetByName(root, "Button_for_a_batch_0")
    self._text_cd_time = Text_dearon_count_down
    local leave_time = _ED.arena_info.fight_cooling_time - (os.time() + _ED.time_add_or_sub)
    if leave_time > 0 then
        self._is_cd_time = true
        self._text_cd_time:setString(string.format(red_alert_time_str[187], exChangeTimeToString(leave_time)))
        Button_for_a_batch_0:setTitleText(arena_tip_text[32])
    else
        self._is_cd_time = false
        self._text_cd_time:setString("")
        Button_for_a_batch_0:setTitleText(arena_tip_text[31])
    end

	table.sort(_ED.arena_info.user_info, function(c1, c2)
		if zstring.tonumber(c1.user_rank) < zstring.tonumber(c2.user_rank) then
			return true
		end
		return false
	end)
	local ListView_arena_dearon = ccui.Helper:seekWidgetByName(root, "ListView_arena_dearon")
    ListView_arena_dearon:jumpToTop()
	ListView_arena_dearon:removeAllItems()
	local myArena = nil
    local index = 1
	for i,v in pairs(_ED.arena_info.user_info) do
		if tonumber(v.user_id) ~= tonumber(_ED.user_info.user_id) then
            if index <= 5 then
    			local cells = state_machine.excute("arena_dearon_cell", 0, {v, index, self._is_cd_time}) 
    			ListView_arena_dearon:addChild(cells)
                index = index + 1
            end
		else
			myArena = v
		end
	end
	ListView_arena_dearon:requestRefreshView()
    self._list_view = ListView_arena_dearon
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

	--排名
	local Text_player_tank_n = ccui.Helper:seekWidgetByName(root, "Text_player_tank_n")
    local Text_player_tank_t = ccui.Helper:seekWidgetByName(root, "Text_player_tank_t")
	Text_player_tank_n:setString(_ED.arena_info.rank)

    local is_lucky_rank = false
    for k, v in pairs(_ED.arena_lucky_ranking) do
        if tonumber(v.this_period_lucky_rank) == tonumber(_ED.arena_info.rank) then
            is_lucky_rank = true
            break
        end
    end
    if is_lucky_rank == false then
        Text_player_tank_t:setString(arena_tip_text[17])
        Text_player_tank_t:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        Text_player_tank_n:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
    else
        Text_player_tank_t:setString(string.format(arena_tip_text[35], _ED.arena_info.rank))
        Text_player_tank_t:setColor(cc.c3b(color_Type[4][1], color_Type[4][2], color_Type[4][3]))
        Text_player_tank_n:setString("")
    end

	--阵型战力
	local Text_battle_formation_fight_n = ccui.Helper:seekWidgetByName(root, "Text_battle_formation_fight_n")
	Text_battle_formation_fight_n:setString(exChangeNumToString(myArena.user_fight))
	--连胜次数
	local Text_battle_vic_time_n = ccui.Helper:seekWidgetByName(root, "Text_battle_vic_time_n") 
	Text_battle_vic_time_n:setString(myArena.win_streak_number)
	--头像
	local Panel_player_head = ccui.Helper:seekWidgetByName(root, "Panel_player_head")
	Panel_player_head:removeAllChildren(true)
	local cell = PlayerHeadIcon:createCell()
	local avatar_info = {}
	avatar_info.object = _ED.user_info.user_head_id
	avatar_info.vip = _ED.vip_grade
	avatar_info._type = 0
	cell:init(avatar_info)
	Panel_player_head:addChild(cell)
	
	self:updateDrawAttack()
end

function ArenaDearonTab:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("arena_dearon_tab_update", 0, "")
        end
    end
    if self._text_cd_time ~= nil then
        local now_time = os.time()
        if now_time - zstring.tonumber(self.last_time) >= 1 or now_time < zstring.tonumber(self.last_time) then 
            self.last_time = now_time
            if self._is_cd_time == true then
                local leave_time = _ED.arena_info.fight_cooling_time - (os.time() + _ED.time_add_or_sub)
                if leave_time < 0 then
                    leave_time = 0
                end
                self._text_cd_time:setString(string.format(red_alert_time_str[187], exChangeNumTimeString(leave_time, 2)))

                if leave_time <= 0 then
                    -- 倒计时结束
                    self._is_cd_time = false
                    self._text_cd_time:setString("")
                    self:onUpdateDraw()
                end
            end
        end
    end

    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_arrow_down:setVisible(true)
        else
            self._Image_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_arrow_up:setVisible(true)
        else
            self._Image_arrow_up:setVisible(false)
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


function ArenaDearonTab:init(params1)
	self._rootWindows = params1
    self:onInit()
    return self
end

function ArenaDearonTab:onInit()
    local csbArenaDearonTab = csb.createNode(config_csb.arena.arena_dearon_tab)
    local root = csbArenaDearonTab:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbArenaDearonTab)
	
	if _ED.arena_info.user_info == nil or _ED.arena_info.user_info == "" then
		local function responseLounchCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                    response.node:onUpdateDraw()
                end
			end
		end
		protocol_command.arena_lounch_refresh.param_list = "0" .. "\r\n" .. _ED.arena_info.arena_id
		NetworkManager:register(protocol_command.arena_lounch_refresh.code, nil, nil, nil, self, responseLounchCallback, false, nil)
	else
		self:onUpdateDraw()
	end
	
	-- if _ED.city_resource_battle_report == nil or _ED.city_resource_battle_report[11] == nil then
		-- if _ED.city_resource_battle_report[11] == nil then
			local function responseReportCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					protocol_command.battlefield_report_get.param_list = 10000
					NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, nil, nil, false, nil)
				end
			end
			protocol_command.battlefield_report_get.param_list = 11
			NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, nil, responseReportCallback, false, nil)
		-- end
		-- if _ED.city_resource_battle_report[10000] == nil then
			
		-- end
	-- end
	
	
	--换一批
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_for_a_batch_0"), nil, 
    {
        terminal_name = "arena_dearon_tab_replace_the_opponent", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	
	--补充次数
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_supplement_time"), nil, 
    {
        terminal_name = "arena_dearon_tab_supplement_time", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	
	--战报入口
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_battle_battlefield"), nil, 
    {
        terminal_name = "arena_record_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_arena_record",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_battle_battlefield"),
    _invoke = nil,
    _interval = 0.2,})

    local Button_arena_troop = ccui.Helper:seekWidgetByName(root, "Button_arena_troop")
    if Button_arena_troop ~= nil then
        fwin:addTouchEventListener(Button_arena_troop, nil, 
        {
            terminal_name = "formation_window_open", 
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
            form_type = 11,
        }, nil, 1)
    end

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_dearon_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_dearon_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_arrow_down:stopAllActions()
    self._Image_arrow_up:stopAllActions()
    playActions(self._Image_arrow_down)
    playActions(self._Image_arrow_up)
    self._Image_arrow_down:setVisible(false)
    self._Image_arrow_up:setVisible(false)
	
end

function ArenaDearonTab:onExit()
	state_machine.remove("arena_dearon_tab_show")
    state_machine.remove("arena_dearon_tab_hide")
    state_machine.remove("arena_dearon_tab_update")
    state_machine.remove("arena_dearon_tab_rank_change_update")
    state_machine.remove("arena_dearon_tab_rank_ascension_animation")
    state_machine.remove("arena_dearon_tab_update_attack")
    state_machine.remove("arena_dearon_tab_replace_the_opponent")
    state_machine.remove("arena_dearon_tab_refresh_opponent")
    state_machine.remove("arena_dearon_tab_supplement_time")
    state_machine.remove("arena_dearon_tab_update_formation_fight")
end

function ArenaDearonTab:onResume()
	state_machine.excute("arena_dearon_tab_rank_ascension_animation", 0, 0) 
end