-----------------------------
--军团系列系列（军团冲级）,同心协力
-----------------------------
RedAlertTimeLegionSeries = class("RedAlertTimeLegionSeriesClass", Window)

local red_alert_time_legion_series_window_open_terminal = {
    _name = "red_alert_time_legion_series_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeLegionSeriesClass") then
            local panel = RedAlertTimeLegionSeries:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_legion_series_window_open_terminal)
state_machine.init()

function RedAlertTimeLegionSeries:ctor()
    self.super:ctor()
    self.roots = {}
	self.activity_type = nil
	self.ranking_type = 0
    self.m_times = 0
    self.m_reset_times = 0

    self.accept_the_prize = false

    self.ranking_refresh_time = 0

	self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._Image_act_share_arrow_down = nil
    self._Image_act_share_arrow_up = nil
    --load lua file
	app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_act_share_cell")
	app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRuleInfor")
    -- Initialize red_alert_time_legion_series state machine.
    local function init_red_alert_time_legion_series_terminal()
	
        --
        local red_alert_time_legion_series_go_to_terminal = {
          _name = "red_alert_time_legion_series_go_to",
          _init = function (terminal) 

          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("red_alert_time_activity_ranking_window_open",0,instance.activity_type)
                        end
                    end
                end
                -- local number = #_ED.activity_info[""..instance.activity_type].activity_data[1]
                -- local count = zstring.split(_ED.activity_info[""..instance.activity_type].activity_data[1][number].achieve_complete_count,"/")
                -- if tonumber(instance.activity_type) == 51 or tonumber(instance.activity_type) == 69 then
                --     protocol_command.union_order.param_list = "1".. "\r\n" ..count[2].."\r\n1"
                --     NetworkManager:register(protocol_command.union_order.code, nil, nil, nil, self, responseCallback, false, nil)
                -- else
                --     protocol_command.union_order.param_list = "1".. "\r\n" ..count[2].."\r\n0"
                --     NetworkManager:register(protocol_command.union_order.code, nil, nil, nil, self, responseCallback, false, nil)
                -- end
                protocol_command.get_activity_rank.param_list = _ED.activity_info[""..instance.activity_type].activity_id .. "\r\n"..instance.activity_type.."\r\n"..(0).."\r\n"..(1).."\r\n".."0"
                NetworkManager:register(protocol_command.get_activity_rank.code, nil, nil, nil, self, responseCallback, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		
		local red_alert_time_legion_series_to_view_terminal = {
          _name = "red_alert_time_legion_series_to_view",
          _init = function (terminal) 

          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				state_machine.excute("red_alert_time_rule_infor_window_open",0,instance.activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
		 
		 local red_alert_time_legion_series_donation_terminal = {
          _name = "red_alert_time_legion_series_donation",
          _init = function (terminal) 

          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
                if tonumber(instance.activity_type) == 73 then
                    state_machine.excute("short_cut_go_to_other_window",0,{29})
                else
                    state_machine.excute("short_cut_go_to_other_window",0,{31})
                end
                state_machine.excute("wonderful_window_close",0,nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }
         local red_alert_time_activity_updata_total_union_contribute_terminal = {
              _name = "red_alert_time_activity_updata_total_union_contribute",
              _init = function (terminal) 

              end,
              _inited = false,
              _instance = self,
              _state = 0,
              _invoke = function(terminal, instance, params) 
                    instance:getUnionTotalContribute()
                    return true
                end,
                _terminal = nil,
                _terminals = nil
         }

         --刷新
        local red_alert_time_legion_series_update_draw_terminal = {
            _name = "red_alert_time_legion_series_update_draw",
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

        state_machine.add(red_alert_time_activity_updata_total_union_contribute_terminal)
        state_machine.add(red_alert_time_legion_series_go_to_terminal)
        state_machine.add(red_alert_time_legion_series_to_view_terminal)
        state_machine.add(red_alert_time_legion_series_donation_terminal)
        state_machine.add(red_alert_time_legion_series_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_legion_series state machine.
    init_red_alert_time_legion_series_terminal()
end

function RedAlertTimeLegionSeries:updateRanking()
	local root = self.roots[1]
	--军团排行
	local Text_legion_rank_n = ccui.Helper:seekWidgetByName(root,"Text_legion_rank_n")
    local Text_legion_rank_t = ccui.Helper:seekWidgetByName(root,"Text_legion_rank_t")
    Text_legion_rank_n:removeAllChildren(true)
	local _richText = ccui.RichText:create()
	_richText:ignoreContentAdaptWithSize(false)
	local color = cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3])
	local re1 = nil
    local footSize = Text_legion_rank_n:getFontSize()
	if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    then
		re1 =ccui.RichElementText:create(1, color,255, activity_str_tip[18], config_res.font.font_name,footSize)
	else
        if tonumber(self.activity_type) == 73 then
            if _ED.activity_legion_copy~= nil and _ED.activity_legion_copy.rank ~= nil then
                if _ED.activity_legion_copy.rank > 0 then
                    re1 =ccui.RichElementText:create(1, color,255, _ED.activity_legion_copy.rank, config_res.font.font_name,footSize)
                else
                    re1 =ccui.RichElementText:create(1, color,255, _ED.activity_legion_copy.rank, config_res.font.font_name,footSize)    
                end
            else
                re1 =ccui.RichElementText:create(1, color,255, _ED.activity_legion_copy.rank, config_res.font.font_name,footSize)
            end
        else
            local timesData = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state, ",")
            local rank_str = activity_str_tip[19]
            if self.accept_the_prize == false then
                if tonumber(_ED.user_ranking_act[self.ranking_type].ranking) > 0 then
                    rank_str = "".._ED.user_ranking_act[self.ranking_type].ranking
                else
                    rank_str = activity_str_tip[19]
                end
            else
                if tonumber(timesData[4]) == 0 and tonumber(timesData[5]) == 0 then
                    rank_str = activity_str_tip[18]
                elseif tonumber(timesData[4]) == 0 then
                    rank_str = activity_str_tip[19]
                else
                    rank_str = ""..timesData[4]
                end
            end
            re1 =ccui.RichElementText:create(1, color,255, rank_str, config_res.font.font_name,footSize)
    	end
	end
	_richText:pushBackElement(re1)
	local color2 = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
	local re2 = ccui.RichElementText:create(1, color2,255, "("..activity_str_tip[17]..")", config_res.font.font_name,footSize)
	_richText:pushBackElement(re2)
	_richText:setAnchorPoint(0.5,0.5)
	_richText:setContentSize(cc.size(Text_legion_rank_n:getContentSize().width,footSize))
	_richText:setPositionX(Text_legion_rank_n:getContentSize().width/2)
	_richText:setPositionY(Text_legion_rank_n:getContentSize().height/2)
	Text_legion_rank_n:addChild(_richText)
	
	--军团等级
	local Text_legion_lv_n = ccui.Helper:seekWidgetByName(root,"Text_legion_lv_n")
	if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    then
                    if tonumber(self.activity_type) == 73 then
                        Text_legion_lv_n:setString("0")
                    else
                        Text_legion_lv_n:setString(activity_str_tip[18])
                    end
		
	else
        if tonumber(self.activity_type) == 73 then
            if _ED.activity_legion_copy~= nil and _ED.activity_legion_copy.rank ~= nil then
                Text_legion_lv_n:setString(_ED.activity_legion_copy.c_break)
            else
                Text_legion_lv_n:setString("0")
            end
        else
            local timesData = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state, ",")
            if self.accept_the_prize == true and tonumber(timesData[4]) == 0 and tonumber(timesData[5]) == 0 then
                Text_legion_lv_n:setString(activity_str_tip[18])
            else
                if self.accept_the_prize == true then
                    if tonumber(self.activity_type) == 51 then
                        Text_legion_lv_n:setString(exChangeNumToString(timesData[6]))
                    elseif tonumber(self.activity_type) == 66 then
                        Text_legion_lv_n:setString(exChangeNumToString(timesData[5]))
                    end
                else
                    if tonumber(self.activity_type) == 51 then
                        Text_legion_lv_n:setString(_ED.union.union_info.union_grade)  
                    elseif tonumber(self.activity_type) == 66 then
                        Text_legion_lv_n:setString(exChangeNumToString(_ED.union.union_info.combat_force))
                    end
                end
            end
        end
	end		
end
function RedAlertTimeLegionSeries:getUnionTotalContribute()
    local root = self.roots[1]
    local Text_legion_lv_n = ccui.Helper:seekWidgetByName(root,"Text_legion_lv_n")
    Text_legion_lv_n:setString("")
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil  and response.node.roots[1] ~= nil then
                Text_legion_lv_n:setString(zstring.tonumber(_ED.union_total_contribute))
            end
        end
    end 
    local acitvity = _ED.activity_info[""..self.activity_type]
    local index = "0" 
    if tonumber(self.activity_type) == 93 then
        if tonumber(acitvity.activity_data[1][1].achieve_state) == 2 then
            index = "1"
        end
    end
    protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..self.activity_type.."\r\n".."0".."\r\n"..index.."\r\n".."2"
    NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, self, responseCallback, false, nil)   
end

function RedAlertTimeLegionSeries:onUpdateDraw()
    local root = self.roots[1]
	local ListView_act_share = ccui.Helper:seekWidgetByName(root,"ListView_act_share")
    local Button_go_legion = ccui.Helper:seekWidgetByName(root,"Button_go_legion")
    local Text_legion_lv_n = ccui.Helper:seekWidgetByName(root,"Text_legion_lv_n")
    Button_go_legion:setVisible(true)

    local Text_legion_lv_t = ccui.Helper:seekWidgetByName(root,"Text_legion_lv_t")
    if tonumber(self.activity_type) == 51 then
        Text_legion_lv_t:setString(activity_str_tip[79])
    elseif tonumber(self.activity_type) == 73 then
        Text_legion_lv_t:setString(activity_str_tip[80])
    elseif tonumber(self.activity_type) == 66 then
        Text_legion_lv_t:setString(activity_str_tip[81])
    elseif tonumber(self.activity_type) == 93 then
        Text_legion_lv_t:setString(activity_str_tip[110])
    end
    if verifySupportLanguage(_lua_release_language_en) == true then
        Text_legion_lv_n:setPositionX(Text_legion_lv_t:getPositionX() + Text_legion_lv_t:getAutoRenderSize().width + 10)
    end

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
        if tonumber(self.activity_type) == 51 then
            local rank_data = zstring.split(activity_info.activity_data[1][i].achieve_other_info, ",")
            if tonumber(timesData[4]) >= tonumber(rank_data[3])
                and tonumber(timesData[4]) <= tonumber(rank_data[4])
                then
                if zstring.tonumber(_ED.union.user_union_info.union_post) == tonumber(rank_data[1]) 
                    or zstring.tonumber(_ED.union.user_union_info.union_post) == tonumber(rank_data[2]) 
                    then
                    reward_position = i
                end
            end
        end
	end

    ListView_act_share:requestRefreshView()
	self._list_view = ListView_act_share
    if tonumber(self.activity_type) == 51 then
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
    if tonumber(self.activity_type) == 51 or tonumber(self.activity_type) == 66 
        or tonumber(self.activity_type) == 93
        then
        endTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[3])/1000-1)
    else
        endTime = getRedAlertTimeFormatYMDHMS(tonumber(timesData[2])/1000-1)    
    end
    local intervalTime = 0
    local time_str = activity_str_tip[93]
    if (tonumber(self.activity_type) == 51 or tonumber(self.activity_type) == 66 or tonumber(self.activity_type) == 93) and ((tonumber(timesData[3])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))) > 0 then
        self.m_times = ((tonumber(timesData[3])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        intervalTime = ((tonumber(timesData[3])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))/86400
        self.accept_the_prize = false
    else
        self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        intervalTime = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))/86400
        self.accept_the_prize = true
        if (tonumber(self.activity_type) == 51 or tonumber(self.activity_type) == 66 or tonumber(self.activity_type) == 93) then
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
    if tonumber(self.activity_type) == 69
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
    local Button_look_rank = ccui.Helper:seekWidgetByName(root,"Button_look_rank")
    local Button_rule = ccui.Helper:seekWidgetByName(root,"Button_rule")
    if tonumber(self.activity_type) == 73 then
        Button_go_legion:setTitleText(activity_str_tip[36]) 
        -- if _ED.union.union_info == nil 
        --     or _ED.union.union_info == {} 
        --     or _ED.union.union_info.union_id == nil 
        --     or _ED.union.union_info.union_id == "" 
        --     or tonumber(_ED.union.union_info.union_id) == 0 
        --     then
        --     Button_look_rank:setTouchEnabled(false)
        --     Button_look_rank:setBright(false)
        -- else
        --     Button_look_rank:setTouchEnabled(true)
        --     Button_look_rank:setBright(true)
        -- end
    else
        Button_go_legion:setTitleText(activity_str_tip[29]) 
    end
    if tonumber(self.activity_type) == 69 then
        Button_go_legion:setVisible(true)
        Button_look_rank:setVisible(false)
        Button_rule:setVisible(false)
        Button_go_legion:setPositionX(self:getContentSize().width/2-Button_go_legion:getContentSize().width/2)
        ccui.Helper:seekWidgetByName(root,"Image_tit_bg"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_legion_rank_t"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_legion_rank_n"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_legion_lv_t"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_legion_lv_n"):setVisible(false)
        ListView_act_share:setPositionY(ListView_act_share._y+ccui.Helper:seekWidgetByName(root,"Image_tit_bg"):getContentSize().height)
    else
        ccui.Helper:seekWidgetByName(root,"Image_tit_bg"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Text_legion_rank_t"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Text_legion_rank_n"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Text_legion_lv_t"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Text_legion_lv_n"):setVisible(true)
        ListView_act_share:setPositionY(ListView_act_share._y)
    end
    if tonumber(self.activity_type) == 66 then
        Button_go_legion:setVisible(false)
        Button_look_rank:setPositionX(133)
        Button_rule:setPositionX(363)
    elseif tonumber(self.activity_type) == 93 then
        Button_rule:setVisible(false)
        Button_look_rank:setPositionX(root:getContentSize().width/3)
        Button_go_legion:setPositionX(root:getContentSize().width/3 * 2)
    end
	self:rankingRefresh()
    if tonumber(self.activity_type) == 93 then
        self:getUnionTotalContribute()
    end
end

function RedAlertTimeLegionSeries:rankingRefresh()
    local root = self.roots[1]
    if tonumber(self.activity_type) == 51 or tonumber(self.activity_type) == 66 
    or tonumber(self.activity_type) == 76 or tonumber(self.activity_type) == 93 
    then--军团冲级
        if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    then
            self.ranking_type = 0
            self:updateRanking()
        else
            local timesData = zstring.split(_ED.activity_info[""..self.activity_type].activity_add_state, ",")
            if self.accept_the_prize == true and tonumber(timesData[4]) == 0 and tonumber(timesData[5]) == 0 then
                self.ranking_type = 0
                self:updateRanking()
            else
                if tonumber(self.activity_type) == 51 then
                    self.ranking_type = 10
                elseif tonumber(self.activity_type) == 66 then
                    self.ranking_type = 4
                elseif tonumber(self.activity_type) == 93 then
                    self.ranking_type = 11
                end
            end
        end
    elseif tonumber(self.activity_type) == 52 then--战力冲榜
        self.ranking_type = 1
    elseif tonumber(self.activity_type) == 53 then--关卡排行
        self.ranking_type = 2
    elseif tonumber(self.activity_type) == 73 then--军团副本   
        self.ranking_type = 0
        self:updateRanking()
    end
    if self.ranking_type ~= 0 then
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
               if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                    response.node:updateRanking()
               end
            end
        end
        protocol_command.order_self_get_info.param_list = self.ranking_type
        NetworkManager:register(protocol_command.order_self_get_info.code, nil, nil, nil, self, responseCallback, false, nil)   
    end 
end

function RedAlertTimeLegionSeries:onEnterTransitionFinish()

end

function RedAlertTimeLegionSeries:onUpdate(dt)
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

function RedAlertTimeLegionSeries:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_share_tab_2)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	
	--前往活动或者查看活动
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rule"), nil, 
    {
        terminal_name = "red_alert_time_legion_series_to_view", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	
	--查看排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_look_rank"), nil, 
    {
        terminal_name = "red_alert_time_legion_series_go_to", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	
	--前往捐献
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_go_legion"), nil, 
    {
        terminal_name = "red_alert_time_legion_series_donation", 
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

    local ListView_act_share = ccui.Helper:seekWidgetByName(root,"ListView_act_share")
    if ListView_act_share._y == nil then
        ListView_act_share._y = ListView_act_share:getPositionY()
    end
    ListView_act_share:setPositionY(ListView_act_share._y)
	
	self:onUpdateDraw()
	
end

function RedAlertTimeLegionSeries:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self.activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeLegionSeries:onExit()
    state_machine.remove("red_alert_time_legion_series_go_to")
    state_machine.remove("red_alert_time_legion_series_to_view")
    state_machine.remove("red_alert_time_legion_series_donation")
    state_machine.remove("red_alert_time_activity_updata_total_union_contribute")
    state_machine.remove("red_alert_time_legion_series_update_draw")
end
