-----------------------------
--成就达成系列（沙漠之鹰等）
-----------------------------
RedAlertTimeAchievementsReached = class("RedAlertTimeAchievementsReachedClass", Window)

local red_alert_time_achievements_reached_window_open_terminal = {
    _name = "red_alert_time_achievements_reached_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeAchievementsReachedClass") then
            local panel = RedAlertTimeAchievementsReached:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_achievements_reached_window_open_terminal)
state_machine.init()

function RedAlertTimeAchievementsReached:ctor()
    self.super:ctor()
    self.roots = {}
	self.activity_type = nil
	self.ranking_type = 0
	self.m_times = 0
    self.m_reset_times = 0
	self.Lead_time = 0

	self.ranking_refresh_time = 0

	self.accept_the_prize = false

	self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._Image_act_share_arrow_down = nil
    self._Image_act_share_arrow_up = nil
    --load lua file
	app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_act_share_cell")
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRuleInfor")
    -- Initialize red_alert_time_achievements_reached state machine.
    local function init_red_alert_time_achievements_reached_terminal()
	
        --
        local red_alert_time_achievements_reached_go_to_terminal = {
          _name = "red_alert_time_achievements_reached_go_to",
          _init = function (terminal) 

          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				if tonumber(instance.activity_type) == 4 then
					state_machine.excute("red_alert_time_achievements_reached_rule",0,instance.activity_type)
				elseif tonumber(instance.activity_type) == 52 then	
					state_machine.excute("red_alert_time_achievements_reached_Jump",0,instance.activity_type)
				elseif tonumber(instance.activity_type) == 53 then	
					state_machine.excute("red_alert_time_achievements_reached_Jump",0,instance.activity_type)	
				elseif tonumber(instance.activity_type) == 56 then	
					state_machine.excute("red_alert_time_achievements_reached_rule",0,instance.activity_type)
				elseif tonumber(instance.activity_type) == 74 then	
					state_machine.excute("red_alert_time_achievements_reached_rule",0,instance.activity_type)			
				else
					
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		
		local red_alert_time_achievements_reached_to_view_terminal = {
          _name = "red_alert_time_achievements_reached_to_view",
          _init = function (terminal) 

          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				if tonumber(instance.activity_type) == 4 then
					state_machine.excute("red_alert_time_achievements_reached_Jump",0,instance.activity_type)
				elseif tonumber(instance.activity_type) == 52 then	
					state_machine.excute("red_alert_time_achievements_reached_rule",0,instance.activity_type)
				elseif tonumber(instance.activity_type) == 53 then	
					state_machine.excute("red_alert_time_achievements_reached_rule",0,instance.activity_type)	
				elseif tonumber(instance.activity_type) == 56 then	
					state_machine.excute("red_alert_time_achievements_reached_Jump",0,instance.activity_type)		
				elseif tonumber(instance.activity_type) == 62 then
					state_machine.excute("red_alert_time_achievements_reached_Jump",0,instance.activity_type)		
				-- elseif tonumber(instance.activity_type) == 69 then
					-- state_machine.excute("red_alert_time_achievements_reached_Jump",0,instance.activity_type)	
				elseif tonumber(instance.activity_type) == 72 then
					state_machine.excute("red_alert_time_achievements_reached_Jump",0,instance.activity_type)		
				elseif tonumber(instance.activity_type) == 74 then
					state_machine.excute("red_alert_time_achievements_reached_Jump",0,instance.activity_type)	
				elseif tonumber(instance.activity_type) == 76 then
					state_machine.excute("red_alert_time_achievements_reached_Jump",0,instance.activity_type)	
				else
					
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		 --规则
		 local red_alert_time_achievements_reached_rule_terminal = {
          _name = "red_alert_time_achievements_reached_rule",
          _init = function (terminal) 

          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				-- print("进入规则界面=="..params)
				state_machine.excute("red_alert_time_rule_infor_window_open",0,instance.activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		 --跳转
		 local red_alert_time_achievements_reached_Jump_terminal = {
          _name = "red_alert_time_achievements_reached_Jump",
          _init = function (terminal) 

          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
          		
          		local function responseCallback(response)
		            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
		                    state_machine.excute("red_alert_time_activity_ranking_window_open",0,params)
		                end
		            end
		        end

				if tonumber(params) == 4 then
					state_machine.excute("wonderful_window_close",0,nil)
					state_machine.excute("pve_manager_window_open",0,nil)
				elseif tonumber(params) == 52 then	
					-- state_machine.excute("rank_window_open",0,{_datas = {list_type = 1}})
					local number = #_ED.activity_info[""..params].activity_data[1]
					local count = zstring.split(_ED.activity_info[""..params].activity_data[1][number].achieve_complete_count,"/")
					-- protocol_command.order_get_info.param_list = ""..(1 - 1).. "\r\n" .."1".. "\r\n" ..count[2]
     --        		NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, self, responseCallback, false, nil)
     				protocol_command.get_activity_rank.param_list = _ED.activity_info[""..params].activity_id .. "\r\n"..params.."\r\n"..(0).."\r\n"..(1).."\r\n".."0"
               		NetworkManager:register(protocol_command.get_activity_rank.code, nil, nil, nil, self, responseCallback, false, nil) 
				elseif tonumber(params) == 53 then	
					-- state_machine.excute("rank_window_open",0,{_datas = {list_type = 2}})
					local number = #_ED.activity_info[""..params].activity_data[1]
					local count = zstring.split(_ED.activity_info[""..params].activity_data[1][number].achieve_complete_count,"/")
					-- protocol_command.order_get_info.param_list = ""..(2 - 1).. "\r\n" .."1".. "\r\n" ..count[2]
     --        		NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, self, responseCallback, false, nil)
     				protocol_command.get_activity_rank.param_list = _ED.activity_info[""..params].activity_id .. "\r\n"..params.."\r\n"..(0).."\r\n"..(1).."\r\n".."0"
               		NetworkManager:register(protocol_command.get_activity_rank.code, nil, nil, nil, self, responseCallback, false, nil) 
				elseif tonumber(params) == 56 then	
					state_machine.excute("wonderful_window_close",0,nil)
					state_machine.excute("short_cut_go_to_other_window",0,{14})
				elseif tonumber(params) == 62 then		
					state_machine.excute("wonderful_window_close",0,nil)
					state_machine.excute("short_cut_go_to_other_window",0,{27})
				-- elseif tonumber(params) == 69 then	
					-- state_machine.excute("short_cut_go_to_other_window",0,{31})
				elseif tonumber(params) == 72 then	
					state_machine.excute("wonderful_window_close",0,nil)
					state_machine.excute("short_cut_go_to_other_window",0,{14})	
				elseif tonumber(params) == 74 then	
					state_machine.excute("wonderful_window_close",0,nil)
					state_machine.excute("short_cut_go_to_other_window",0,{14})
				elseif tonumber(params) == 76 then	
					state_machine.excute("wonderful_window_close",0,nil)			
					state_machine.excute("short_cut_go_to_other_window",0,{31})		
				else
				
				end
				-- print("进入跳转界面=="..params)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }

        --刷新
        local red_alert_time_achievements_reached_update_draw_terminal = {
            _name = "red_alert_time_achievements_reached_update_draw",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    local posY = instance._list_view_poy
                    instance:onUpdateDraw()
                    if math.abs(posY) > math.abs(instance._list_view_height) then
                        posY = instance._list_view_height
                    end
                    instance._list_view:getInnerContainer():setPositionY(posY)  
                    instance._list_view_poy = posY + 1
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		 
        state_machine.add(red_alert_time_achievements_reached_go_to_terminal)
        state_machine.add(red_alert_time_achievements_reached_to_view_terminal)
        state_machine.add(red_alert_time_achievements_reached_rule_terminal)
        state_machine.add(red_alert_time_achievements_reached_Jump_terminal)
        state_machine.add(red_alert_time_achievements_reached_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_achievements_reached state machine.
    init_red_alert_time_achievements_reached_terminal()
end

function RedAlertTimeAchievementsReached:updateRanking()
	local root = self.roots[1]
	local timesData = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state, ",")
	--排行
	local Text_rank_n = ccui.Helper:seekWidgetByName(root,"Text_rank_n")
    Text_rank_n:removeAllChildren(true)
	local fontSize = Text_rank_n:getFontSize()
	local _richText = ccui.RichText:create()
	_richText:ignoreContentAdaptWithSize(false)
	local color = cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3])
	local re1 = nil
	if self.accept_the_prize == true and (tonumber(self.activity_type) == 52 or tonumber(self.activity_type) == 53) then
		if tonumber(timesData[4]) == 0 then
			re1 =ccui.RichElementText:create(1, color,255, activity_str_tip[19], config_res.font.font_name,fontSize)
		else
			re1 =ccui.RichElementText:create(1, color,255, timesData[4], config_res.font.font_name,fontSize)
		end
	else
		if tonumber(_ED.user_ranking_act[self.ranking_type].ranking) == 0 then
			re1 =ccui.RichElementText:create(1, color,255, activity_str_tip[19], config_res.font.font_name,fontSize)
		else
			re1 =ccui.RichElementText:create(1, color,255, _ED.user_ranking_act[self.ranking_type].ranking, config_res.font.font_name,fontSize)
		end
	end
	_richText:pushBackElement(re1)
	local color2 = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
	local re2 = ccui.RichElementText:create(1, color2,255, "("..activity_str_tip[17]..")", config_res.font.font_name,fontSize)
	_richText:pushBackElement(re2)
	_richText:setAnchorPoint(0,0.5)
	_richText:setContentSize(cc.size(Text_rank_n:getContentSize().width,20))
	_richText:setPositionX(-Text_rank_n:getContentSize().width/2)
	_richText:setPositionY(Text_rank_n:getContentSize().height/2)
	Text_rank_n:addChild(_richText)

	-- _ED._activity_ranking = zstring.tonumber(_ED.user_ranking_act[self.ranking_type].ranking)
	
	local Text_fight_t = ccui.Helper:seekWidgetByName(root,"Text_fight_t")
	if tonumber(self.activity_type) == 52 then--战力冲榜
		Text_fight_t:setString(activity_str_tip[20])
	elseif tonumber(self.activity_type) == 53 then--关卡冲榜
		Text_fight_t:setString(activity_str_tip[21])
	end
	local Text_fight_n = ccui.Helper:seekWidgetByName(root,"Text_fight_n")
	if tonumber(self.activity_type) == 52 then--战力冲榜
		if self.accept_the_prize == true then
			Text_fight_n:setString(exChangeNumToString(tonumber(timesData[5])))
		else
			Text_fight_n:setString(exChangeNumToString(_ED.user_info.fighter_capacity))
		end
		
	elseif tonumber(self.activity_type) == 53 then--关卡冲榜
		if self.accept_the_prize == true then
			Text_fight_n:setString(timesData[5])
		else
			local total_count = 0
	        for i = 1, _ED.easy_now_scene_id do
	            total_count = total_count + tonumber(_ED.get_star_count[i])
	        end
			Text_fight_n:setString(total_count)
		end
	end
	if verifySupportLanguage(_lua_release_language_en) == true then
        Text_fight_n:setPositionX(Text_fight_t:getPositionX() + Text_fight_t:getAutoRenderSize().width + 10)
    end
end

function RedAlertTimeAchievementsReached:onUpdateDraw()
    local root = self.roots[1]
    self:rankingRefresh()
	local ListView_act_share = ccui.Helper:seekWidgetByName(root,"ListView_act_share")
    ListView_act_share:jumpToTop()
	ListView_act_share:removeAllItems()
	local index = 1
	local activity_info = _ED.activity_info[""..self.activity_type]
	local timesData = zstring.split(activity_info.activity_add_state, ",")
	local reward_position = 0
	for i=1, #activity_info.activity_data[1] do
	-- for i,v in pairs(_ED.activity_info["44"].activity_data[2]) do
		local cell = state_machine.excute("red_alert_time_act_share_create_cell",0,{activity_info.activity_data[1][i],index,self.activity_type,1})
        ListView_act_share:addChild(cell)
		index = index + 1 
		if tonumber(self.activity_type) == 52 
			or tonumber(self.activity_type) == 53 
			then
			local rank_data = zstring.split(activity_info.activity_data[1][i].achieve_other_info, ",")
			if tonumber(timesData[4]) >= tonumber(rank_data[1])
				and tonumber(timesData[4]) <= tonumber(rank_data[2])
				then
				reward_position = i
			end
		end
	end
    ListView_act_share:requestRefreshView()
	self._list_view = ListView_act_share
	if tonumber(self.activity_type) == 52
		or tonumber(self.activity_type) == 53 
		then
	    self._list_view:refreshView()
	    self._list_view:getInnerContainer():setPosition(cc.p(0,(reward_position+2) * RedAlerTimeActShareCell.__size.height - self._list_view:getInnerContainer():getContentSize().height))
    else
    	self._list_view:requestRefreshView()
    end
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
	--活动名称
	local Text_act_share_name = ccui.Helper:seekWidgetByName(root,"Text_act_share_name")
	Text_act_share_name:setString(activity_info.activity_title)
	--活动描述
	local Text_act_share_infor = ccui.Helper:seekWidgetByName(root,"Text_act_share_infor")
	Text_act_share_infor:setString(activity_info.activity_dec)
	--活动开启结束时间
	local startTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[1])/1000)
	local endTime = nil
	if tonumber(self.activity_type) == 52 or tonumber(self.activity_type) == 53 then
		endTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[3])/1000-1)
	else
		endTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[2])/1000-1)
	end
	local intervalTime = 0
    local time_str = activity_str_tip[93]
    if (tonumber(self.activity_type) == 52 or tonumber(self.activity_type) == 53) and ((tonumber(timesData[3])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))) > 0 then
        self.m_times = ((tonumber(timesData[3])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        intervalTime = ((tonumber(timesData[3])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))/86400
        self.accept_the_prize = false         -- 结束
    else
        self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        intervalTime = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))/86400
        self.accept_the_prize = true          -- 关闭
        if (tonumber(self.activity_type) == 52 or tonumber(self.activity_type) == 53) then
            time_str = activity_str_tip[92]
        end
    end
    -- 结束和关闭倒计时
    local Text_act_share_act_time_1 = ccui.Helper:seekWidgetByName(root,"Text_act_share_act_time_1")
    Text_act_share_act_time_1:removeAllChildren(true)
    Text_act_share_act_time_1:setString("")
    local font_size = Text_act_share_act_time_1:getFontSize()
    local time_info = cc.Label:createWithTTF(time_str, config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_info:setName("time_info")
    time_info:setAnchorPoint(cc.p(0, 0.5))
    time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    time_info:setPositionX(0)
    time_info:setPositionY(Text_act_share_act_time_1:getContentSize().height / 2)
    time_info:setTag(200)
    Text_act_share_act_time_1:addChild(time_info)
    local time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
    time_int:setName("time_int")
    time_int:setAnchorPoint(cc.p(0, 0.5))
    time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
    time_int:setPositionX(time_info:getContentSize().width)
    time_int:setPositionY(Text_act_share_act_time_1:getContentSize().height / 2)
    time_int:setTag(100)
    Text_act_share_act_time_1:addChild(time_int)

    -- 重置倒计时
    if tonumber(self.activity_type) == 4
        or tonumber(self.activity_type) == 56
        or tonumber(self.activity_type) == 62
        then
        local server_time = getCurrentGTM8Time()
        self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1

        local Text_act_share_act_time_2 = ccui.Helper:seekWidgetByName(root,"Text_act_share_act_time_2")
        Text_act_share_act_time_2:removeAllChildren(true)
        Text_act_share_act_time_2:setString("")
        local reset_time_int = cc.Label:createWithTTF("", config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        reset_time_int:setName("reset_time_int")
        reset_time_int:setAnchorPoint(cc.p(0, 0.5))
        reset_time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
        reset_time_int:setPositionX(Text_act_share_act_time_2:getContentSize().width - 80)
        reset_time_int:setPositionY(Text_act_share_act_time_2:getContentSize().height / 2)
        reset_time_int:setTag(100)
        Text_act_share_act_time_2:addChild(reset_time_int)
        local reset_time_info = cc.Label:createWithTTF(activity_str_tip[94], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        reset_time_info:setName("reset_time_info")
        reset_time_info:setAnchorPoint(cc.p(1, 0.5))
        reset_time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        reset_time_info:setPositionX(Text_act_share_act_time_2:getContentSize().width - 80)
        reset_time_info:setPositionY(Text_act_share_act_time_2:getContentSize().height / 2)
        reset_time_info:setTag(200)
        Text_act_share_act_time_2:addChild(reset_time_info)
    end
	
	local Text_rank_t = ccui.Helper:seekWidgetByName(root,"Text_rank_t")
	local Text_rank_n = ccui.Helper:seekWidgetByName(root,"Text_rank_n")
	local fontSize = Text_rank_n:getFontSize() 
	local Text_fight_t = ccui.Helper:seekWidgetByName(root,"Text_fight_t")
	local Text_fight_n = ccui.Helper:seekWidgetByName(root,"Text_fight_n")
	if tonumber(self.activity_type) == 56 or tonumber(self.activity_type) == 62 or tonumber(self.activity_type) == 74 then
		Text_rank_t:setVisible(false)
		Text_fight_t:setVisible(false)
		Text_fight_n:setVisible(false)
		Text_rank_n:setVisible(true)
		Text_rank_n:removeAllChildren(true)
		local _richText2 = ccui.RichText:create()
		_richText2:ignoreContentAdaptWithSize(false)
		_richText2:setContentSize(cc.size(root:getContentSize().width,40))
		_richText2:setAnchorPoint(cc.p(0, 0.5))
		local numbers = zstring.split(activity_info.activity_data[1][1].achieve_complete_count,",")
		local dataset= ""
		if tonumber(self.activity_type) == 56 then
			local numbers = zstring.split(activity_info.activity_add_state,",")
			--dataset= string.gsub(activity_str_tip[10], "x", numbers[4])
			dataset = string.format(activity_str_tip[10],""..numbers[4])
		elseif tonumber(self.activity_type) == 62 then
			numbers = zstring.split(activity_info.activity_data[1][#activity_info.activity_data[1]].achieve_complete_count,",")
            local index = zstring.split(numbers[1],"/")
			--dataset= string.gsub(activity_str_tip[28], "x", index[1])
			dataset = string.format(activity_str_tip[28],""..index[1])
		elseif tonumber(self.activity_type) == 74 then
			numbers = zstring.split(activity_info.activity_data[1][#activity_info.activity_data[1]].achieve_complete_count,",")
			local index = zstring.split(numbers[1],"/")
			--dataset= string.gsub(activity_str_tip[33], "x", exChangeNumToString(index[1]))
			dataset = string.format(activity_str_tip[33],exChangeNumToString(index[1]))
		end
		local rt, count, text = draw.richTextCollectionMethod(_richText2, 
		dataset, 
		cc.c3b(255, 255, 255),
		cc.c3b(255, 255, 255),
		0, 
		0, 
		config_res.font.font_name, 
		fontSize,
		chat_rich_text_color)
		_richText2:formatTextExt()
		local rsize = _richText2:getContentSize()
		_richText2:setPositionX(0)
		_richText2:setPositionY(Text_rank_n:getContentSize().height/2)
		Text_rank_n:addChild(_richText2)
		ccui.Helper:seekWidgetByName(root,"Button_rule"):setTitleText(activity_str_tip[13]) 
		ccui.Helper:seekWidgetByName(root,"Button_look_rank"):setTitleText(activity_str_tip[12]) 
	elseif tonumber(self.activity_type) == 4 then
		ccui.Helper:seekWidgetByName(root,"Button_rule"):setTitleText(activity_str_tip[24]) 
		ccui.Helper:seekWidgetByName(root,"Button_look_rank"):setTitleText(activity_str_tip[12]) 
	-- elseif tonumber(self.activity_type) == 69 then 	
		-- ccui.Helper:seekWidgetByName(root,"Button_rule"):setTitleText(activity_str_tip[29]) 
	elseif tonumber(self.activity_type) == 72 then 	
		ccui.Helper:seekWidgetByName(root,"Button_rule"):setTitleText(activity_str_tip[30]) 
	elseif tonumber(self.activity_type) == 74 then 	
		ccui.Helper:seekWidgetByName(root,"Button_rule"):setTitleText(activity_str_tip[31]) 	
	elseif tonumber(self.activity_type) == 76 then 	
		ccui.Helper:seekWidgetByName(root,"Button_rule"):setTitleText(activity_str_tip[29]) 		
	else
		ccui.Helper:seekWidgetByName(root,"Button_rule"):setTitleText(activity_str_tip[12]) 
		ccui.Helper:seekWidgetByName(root,"Button_look_rank"):setTitleText(activity_str_tip[11]) 
	end
	if tonumber(self.activity_type) == 4 or tonumber(self.activity_type) == 72 or tonumber(self.activity_type) == 76 then
		ccui.Helper:seekWidgetByName(root,"Image_tit_bg"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Text_rank_t"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Text_rank_n"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Text_fight_t"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Text_fight_n"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"ListView_act_share"):setPositionY(ccui.Helper:seekWidgetByName(root,"ListView_act_share")._y+ccui.Helper:seekWidgetByName(root,"Image_tit_bg"):getContentSize().height)
	else
		if tonumber(self.activity_type) == 56 or tonumber(self.activity_type) == 62 or tonumber(self.activity_type) == 74 then
			ccui.Helper:seekWidgetByName(root,"Text_rank_t"):setVisible(false)
			ccui.Helper:seekWidgetByName(root,"Text_fight_t"):setVisible(false)
			ccui.Helper:seekWidgetByName(root,"Text_fight_n"):setVisible(false)
			ccui.Helper:seekWidgetByName(root,"Text_rank_n"):setVisible(true)
		else
			ccui.Helper:seekWidgetByName(root,"Image_tit_bg"):setVisible(true)
			ccui.Helper:seekWidgetByName(root,"Text_rank_t"):setVisible(true)
			ccui.Helper:seekWidgetByName(root,"Text_rank_n"):setVisible(true)
			ccui.Helper:seekWidgetByName(root,"Text_fight_t"):setVisible(true)
			ccui.Helper:seekWidgetByName(root,"Text_fight_n"):setVisible(true)
		end
	end
	--一个按钮
	if tonumber(self.activity_type) == 62 
	-- or tonumber(self.activity_type) == 69 
		or tonumber(self.activity_type) == 72 or tonumber(self.activity_type) == 74 
		or tonumber(self.activity_type) == 76 
		then
		ccui.Helper:seekWidgetByName(root,"Button_rule"):setPositionX(math.abs(ccui.Helper:seekWidgetByName(root,"Button_rule"):getPositionX()-ccui.Helper:seekWidgetByName(root,"Button_look_rank"):getPositionX())/2+ccui.Helper:seekWidgetByName(root,"Button_look_rank"):getPositionX())
		ccui.Helper:seekWidgetByName(root,"Button_look_rank"):setVisible(false)
	else
		ccui.Helper:seekWidgetByName(root,"Button_look_rank"):setVisible(true)
	end

	if tonumber(self.activity_type) == 74 then
		ccui.Helper:seekWidgetByName(root,"Button_act_share_tab_3_infor"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(root,"Button_act_share_tab_3_infor"):setVisible(false)
	end	
	-- self:rankingRefresh()
end

function RedAlertTimeAchievementsReached:rankingRefresh()
	local root = self.roots[1]

	if tonumber(self.activity_type) == 51 then--军团冲级
		if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    then
			self.ranking_type = 0
			self:updateRanking()
		else
			self.ranking_type = 4
		end
	elseif tonumber(self.activity_type) == 52 then--战力冲榜
		self.ranking_type = 1
	elseif tonumber(self.activity_type) == 53 then--关卡排行
		self.ranking_type = 2
	end
	if self.ranking_type ~= 0 then
		if self.accept_the_prize == true and (tonumber(self.activity_type) == 52 or tonumber(self.activity_type) == 53) then
			self:updateRanking()
			return
		end
		local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
               if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
					self:updateRanking()
			   end
            end
        end
		protocol_command.order_self_get_info.param_list = self.ranking_type
		NetworkManager:register(protocol_command.order_self_get_info.code, nil, nil, nil, self, responseCallback, false, nil)  	
	end	
end

function RedAlertTimeAchievementsReached:onEnterTransitionFinish()

end

function RedAlertTimeAchievementsReached:onUpdate(dt)
	if self.accept_the_prize == false then
		if self.ranking_refresh_time <= 0 then
	        self.ranking_refresh_time = self.ranking_refresh_time + dt
	        if self.ranking_refresh_time >= 5*60 then
	            self:rankingRefresh()
	            self.ranking_refresh_time = 0
	        end
	    end
    end
    if self.m_reset_times > 0 then
        self.m_reset_times = self.m_reset_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_act_share_act_time_2"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_act_share_act_time_2"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        end
        if self.m_reset_times <= 0 then
            self.m_reset_times = 0
            self:onUpdateDraw()
        end
    end
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if ccui.Helper:seekWidgetByName(self.roots[1],"Text_act_share_act_time_1"):getChildByTag(100) ~= nil then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_act_share_act_time_1"):getChildByTag(100):setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            if self.accept_the_prize == true then
                state_machine.excute("red_alert_time_wonderful_update_first",0,self.activity_type)
            else
                self:onUpdateDraw()
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
            self._Image_act_share_arrow_down:setVisible(true)
        else
            self._Image_act_share_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_act_share_arrow_up:setVisible(true)
        else
            self._Image_act_share_arrow_up:setVisible(false)
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

function RedAlertTimeAchievementsReached:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_share_tab_3)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	
	if ccui.Helper:seekWidgetByName(root,"ListView_act_share")._y == nil then
		ccui.Helper:seekWidgetByName(root,"ListView_act_share")._y = ccui.Helper:seekWidgetByName(root,"ListView_act_share"):getPositionY()
	end
	ccui.Helper:seekWidgetByName(root,"ListView_act_share"):setPositionY(ccui.Helper:seekWidgetByName(root,"ListView_act_share")._y)
	
	if ccui.Helper:seekWidgetByName(root,"Button_rule")._x == nil then
		ccui.Helper:seekWidgetByName(root,"Button_rule")._x = ccui.Helper:seekWidgetByName(root,"Button_rule"):getPositionX()
	end
	ccui.Helper:seekWidgetByName(root,"Button_rule"):setPositionX(ccui.Helper:seekWidgetByName(root,"Button_rule")._x)
	--前往活动或者查看活动
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rule"), nil, 
    {
        terminal_name = "red_alert_time_achievements_reached_to_view", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	
	--前往排行或者活动规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_look_rank"), nil, 
    {
        terminal_name = "red_alert_time_achievements_reached_go_to", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    --活动规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_act_share_tab_3_infor"), nil, 
    {
        terminal_name = "red_alert_time_achievements_reached_go_to", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

	self._Image_act_share_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_act_share_arrow_down")
    self._Image_act_share_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_act_share_arrow_up")
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_act_share_arrow_down:stopAllActions()
    self._Image_act_share_arrow_up:stopAllActions()
    playActions(self._Image_act_share_arrow_down)
    playActions(self._Image_act_share_arrow_up)
    self._Image_act_share_arrow_down:setVisible(false)
    self._Image_act_share_arrow_up:setVisible(false)
    
	self:onUpdateDraw()
end

function RedAlertTimeAchievementsReached:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self.activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeAchievementsReached:onExit()
    state_machine.remove("red_alert_time_achievements_reached_go_to")
    state_machine.remove("red_alert_time_achievements_reached_to_view")
    state_machine.remove("red_alert_time_achievements_reached_rule")
    state_machine.remove("red_alert_time_achievements_reached_Jump")
    state_machine.remove("red_alert_time_achievements_reached_update_draw")
end
