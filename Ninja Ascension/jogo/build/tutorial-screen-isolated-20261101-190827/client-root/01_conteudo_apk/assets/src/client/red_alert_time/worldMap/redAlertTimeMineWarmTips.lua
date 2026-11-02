-- ----------------------------------------------------------------------------------------------------
-- 说明：点击地块提示
-------------------------------------------------------------------------------------------------------
redAlertTimeMineWarmTips = class("redAlertTimeMineWarmTipsClass", Window)

local red_alert_time_mine_warm_tips_open_terminal = {
    _name = "red_alert_time_mine_warm_tips_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("redAlertTimeMineWarmTipsClass")
        if nil == _homeWindow then
    		fwin:open(redAlertTimeMineWarmTips:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_mine_warm_tips_close_terminal = {
    _name = "red_alert_time_mine_warm_tips_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("redAlertTimeMineWarmTipsClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("redAlertTimeMineWarmTipsClass"))
        end

        if missionIsOver() == false then
	        local tuitionWindow = fwin:find("TuitionControllerClass")
	        if nil ~= tuitionWindow then
	            tuitionWindow:setVisible(true)
	        end
	        local roleDialogueWindow = fwin:find("RoleDialogueClass")
	        if nil ~= roleDialogueWindow then
	            roleDialogueWindow:setVisible(true)
	        end
	        state_machine.excute("events_teaching_skip_show", 0, 0)
	    end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_mine_warm_tips_open_terminal)
state_machine.add(red_alert_time_mine_warm_tips_close_terminal)
state_machine.init()
    
function redAlertTimeMineWarmTips:ctor()
    self.super:ctor()
    self.roots = {}
	self._cell = nil
	self._tip_type = ""
	
	local function init_red_alert_time_mine_warm_tips_terminal()
		-- 确定迁移
        local red_alert_time_mine_base_migration_terminal = {
            _name = "red_alert_time_mine_base_migration",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if zstring.tonumber(self._tip_type) == 1 or zstring.tonumber(self._tip_type) == 8 then
					local function responseWorldChangeUserCityPositionCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil then
								state_machine.excute("adventure_mine_record_view_position", 0, {instance._targetX,instance._targetY})
								state_machine.excute("adventure_mine_update_view_position", 0, 0)
						
								protocol_command.world_map_arena_info_refresh.param_list = "" .. instance._targetX .. "\r\n" .. instance._targetY
								NetworkManager:register(protocol_command.world_map_arena_info_refresh.code, nil, nil, nil, self, nil, false, nil)
								-- fwin:close(response.node)
								state_machine.excute("red_alert_time_mine_warm_tips_close", 0, 0)
							end	
						end
					end
					
					if _ED.world_map~= nil and _ED.world_map.target_event_info ~= nil then
						for i, v in pairs(_ED.world_map.target_event_info) do
							if tonumber(v._event_type) < 10 or tonumber(v._event_type) == 18 then
								TipDlg.drawTextDailog(tipStringInfo_consumption_info[10])
								state_machine.excute("red_alert_time_mine_warm_tips_close", 0, 0)
								return
							end
						end	
					end
					protocol_command.world_change_user_city_position.param_list = "" .. 0 .."\r\n" .. instance._targetX .. "\r\n" .. instance._targetY
					NetworkManager:register(protocol_command.world_change_user_city_position.code, nil, nil, nil, self, responseWorldChangeUserCityPositionCallback,false, nil)
				elseif zstring.tonumber(self._tip_type) == 2 then
					state_machine.excute("world_nearby_list_cell_accelerate_or_revoked", 0, {_datas = {cells = params._datas.cell}})
				elseif zstring.tonumber(self._tip_type) == 3 then	
					state_machine.excute("world_nearby_list_cell_accelerate_or_revoked", 0, {_datas = {cells = params._datas.cell}}) 
				elseif zstring.tonumber(self._tip_type) == 4 then		
					state_machine.excute("red_alert_time_mine_back_to_base_attack",0,0)
				elseif zstring.tonumber(self._tip_type) == 5 then		
					state_machine.excute("arena_shop_cell_exchange_confirmation",0,{_datas = {cells = params._datas.cell}})
				elseif zstring.tonumber(self._tip_type) == 6 then	
					state_machine.excute("arena_dearon_tab_refresh_opponent",0,0)
				elseif zstring.tonumber(self._tip_type) == 7 then		
					state_machine.excute("events_teaching_skip_jump_carried_out",0,0)
			--	elseif zstring.tonumber(self._tip_type) == 8 then 	
					--print("暂未处理")
				--	state_machine.excute("red_alert_time_mine_warm_tips_close", 0, 0)
				elseif zstring.tonumber(self._tip_type) == 9 then	
					state_machine.excute("red_alert_time_mine_reconnaissance_open",0,{_datas = {cells = params._datas.cell,m_type = 2,isForce = 1, from_type = params._datas.cell.from_type}})
				elseif zstring.tonumber(self._tip_type) == 10 then	
					-- if self.local_time > 0 then
						-- state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = params._datas.cell, m_type = 4}})
						-- return
					-- end
					state_machine.excute("red_alert_time_mine_back_to_base_attack",0,1)
                elseif zstring.tonumber(self._tip_type) == 11 then   
                    state_machine.excute("expedition_shop_cell_confirmation_change",0,{_datas = {cells = params._datas.cell}})
                elseif zstring.tonumber(self._tip_type) == 12 then   
                    state_machine.excute("leader_recruit_sure_hoose_recruit",0,{params._datas.cell[3]})
                elseif zstring.tonumber(self._tip_type) == 13 then   
                    state_machine.excute("pve_npc_cell_choose_two",0,{_datas = {cell = params._datas.cell}})
                elseif zstring.tonumber(self._tip_type) == 14 then     
                	state_machine.excute("red_alert_time_lucky_draw_lottery",0,0)
            	elseif zstring.tonumber(self._tip_type) == 15 then     
                	state_machine.excute("red_alert_time_lucky_draw_all_lottery",0,0)
                elseif zstring.tonumber(self._tip_type) == 16 then     
                	state_machine.excute("red_alert_time_tank_draw_lottery50",0,0)
                elseif zstring.tonumber(self._tip_type) == 17 then     
                	state_machine.excute("red_alert_time_red_rnvelopes_activity_codes",0,0)
				elseif zstring.tonumber(self._tip_type) == 0 then	
                elseif zstring.tonumber(self._tip_type) == 18 then   
                    state_machine.excute("camp_pk_shop_cell_confirmation_change",0,{_datas = {cells = params._datas.cell}})
                elseif zstring.tonumber(self._tip_type) == 19 then   
                    state_machine.excute("arena_shop_tab_refresh_list_confirmation",0,0)
                elseif zstring.tonumber(self._tip_type) == 20 then   
                	state_machine.excute("red_alert_time_seven_day_recruit_supplemented_confirm",0,0) 
				elseif zstring.tonumber(self._tip_type) == 21 
					or zstring.tonumber(self._tip_type) == 22 
					then
					state_machine.excute("world_battle_event_info_march_cell_accelerate_or_revoked", 0, {_datas = {cells = params._datas.cell}})
                elseif zstring.tonumber(self._tip_type) == 23 
                    or zstring.tonumber(self._tip_type) == 24
                    then
                    state_machine.excute("formation_implement_cell_accelerate_or_revoked", 0, {_datas = {cells = params._datas.cell}})
                elseif zstring.tonumber(self._tip_type) == 25 then
                    state_machine.excute("guard_battle_sure_clear_cd", 0, {_datas = {cells = params._datas.cell}})
                elseif zstring.tonumber(self._tip_type) == 26 then
                    state_machine.excute("armor_pack_sure_enlarge_pack", 0, "")
                elseif zstring.tonumber(self._tip_type) == 27 then
                    state_machine.excute("red_alert_time_leader_senior_sure_hoose_recruit",0,{params._datas.cell[3]})
                elseif zstring.tonumber(self._tip_type) == 28 then
                    state_machine.excute("red_alert_time_eliminate_music_protocol",0,"")
                elseif zstring.tonumber(self._tip_type) == 29 then
                    state_machine.excute("red_alert_time_discount_store_transfer_buy_goods",0, params._datas.cell )
                elseif zstring.tonumber(self._tip_type) == 30 then
                    state_machine.excute("main_window_sure_buy_city_energy",0, "")
                elseif zstring.tonumber(self._tip_type) == 31 then
                    state_machine.excute("red_alert_time_leader_senior_legend_sure_choose_recruit",0, {params._datas.cell[3]})
                elseif zstring.tonumber(self._tip_type) == 32 then
                    state_machine.excute("red_alert_time_recharge_send_leader_supplemented_confirm",0, {params._datas.cell[3]})
                elseif zstring.tonumber(self._tip_type) == 33 then
                    state_machine.excute("red_alert_time_leader_senior_once_sure_recruit",0, {params._datas.cell[3]})
                elseif zstring.tonumber(self._tip_type) == 34 then
                    state_machine.excute("red_alert_time_leader_senior_ten_sure_recruit",0, {params._datas.cell[3]})
                elseif zstring.tonumber(self._tip_type) == 35 then
                    state_machine.excute("red_alert_time_excavting_comeing_collection_sure_collect",0, {params._datas.cell[3]})
                elseif zstring.tonumber(self._tip_type) == 36 then
                    state_machine.excute("player_energy_add_open",0, "")
                elseif zstring.tonumber(self._tip_type) == 37 then
                    state_machine.excute("red_alert_time_happy_buy_cell_sure_buy",0, params._datas.cell)
                elseif zstring.tonumber(self._tip_type) == 38 then
                    state_machine.excute("red_alert_time_falcon_assault_collotion_sure_choose_recruit",0, {params._datas.cell[3]})
                elseif zstring.tonumber(self._tip_type) == 39 then
                    state_machine.excute("red_alert_time_uitimate_breakthrough_buy_sure_choose_recruit",0, {params._datas.cell[3]})
                elseif zstring.tonumber(self._tip_type) == 40 then
                    state_machine.excute("recharge_dialog_window_open",0, "")
				end		
				state_machine.excute("red_alert_time_mine_warm_tips_close", 0, 0)		
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_mine_warm_tips_window_close_terminal = {
            _name = "red_alert_time_mine_warm_tips_window_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("red_alert_time_mine_warm_tips_close", 0, 0)	
            	if fwin:find("RedAlertTimeLuckyDrawClass") ~= nil then
		        	state_machine.excute("red_alert_time_lucky_draw_unlock", 0, 0)
		        end
		        if fwin:find("LeaderRecruitClass") ~= nil then
		        	state_machine.unlock("leader_recruit_choose_recruit")
		        end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_mine_base_migration_terminal)
        state_machine.add(red_alert_time_mine_warm_tips_window_close_terminal)
	
		state_machine.init()
	end
	
	init_red_alert_time_mine_warm_tips_terminal()
end

function redAlertTimeMineWarmTips:init(params)
	self._cell = params._datas.cell
	self._tip_type = params._datas.m_type
    self:onInit()
    return self
end

function redAlertTimeMineWarmTips:onInit()
    local csbredAlertTimeMineWarmTips = csb.createNode(config_csb.utils.prompt_1)
    local root = csbredAlertTimeMineWarmTips:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbredAlertTimeMineWarmTips)
	
	local Text_141 = ccui.Helper:seekWidgetByName(root,"Text_141")
	if Text_141._y == nil then
		Text_141._y = Text_141:getPositionY()
	end
	Text_141:setPositionY(Text_141._y)
	local textContentSize = Text_141:getContentSize()
	local _richText = nil
	if zstring.tonumber(self._tip_type) == 1 then
		local mx = 599 + self._cell.tileX + 1
		local my = self._cell.tileY + 1
		-- local ta = _ED.cta[my][mx]
		local ta = {}
		local ta_x, ta_y = cc.dms_init_world_map_get(2, mx, my)
		ta.x = ta_x
		ta.y = ta_y
		self._targetX = ta.x
		self._targetY = ta.y
		-- Text_141:setString("是否使用98元宝将基地迁移至["..ta.x..","..ta.y.."]?")
		Text_141:setString(string.format(red_alert_time_str[49],ta.x, ta.y))
	elseif zstring.tonumber(self._tip_type) == 2 
		or zstring.tonumber(self._tip_type) == 21 
        or zstring.tonumber(self._tip_type) == 23
		then	
		Text_141:setString(red_alert_time_str[50])
	elseif zstring.tonumber(self._tip_type) == 3 
		or zstring.tonumber(self._tip_type) == 22 
        or zstring.tonumber(self._tip_type) == 24
		then		
		local times = math.ceil(self._cell.local_time/60)
		if zstring.tonumber(self._tip_type) == 22 then
			times = math.ceil(self._cell.costGoods/60)
		end
		Text_141:setString(string.format(tipStringInfo_consumption_info[13],times))
	elseif zstring.tonumber(self._tip_type) == 4 then			
		Text_141:setString(tipStringInfo_consumption_info[19])
	elseif zstring.tonumber(self._tip_type) == 5 then
		_richText = ccui.RichText:create()		
		local rt, count, text = draw.richTextCollectionMethod(_richText, 
		self._cell._tip_info, 
		cc.c3b(189, 206, 224),
		cc.c3b(189, 206, 224),
		0, 
		0, 
		config_res.font.font_name, 
		20,
		chat_rich_text_color)	
	elseif zstring.tonumber(self._tip_type) == 6 then
		_richText = ccui.RichText:create()
		local color = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
		local text_info = zstring.split(arena_tip_text[1], "/&|")
		local re1 =ccui.RichElementText:create(1, color,255, text_info[1], config_res.font.font_name,20)
		_richText:pushBackElement(re1)
		local path = config_res.images.ui.home.icon_gold
		local reimg = ccui.RichElementImage:create(2, cc.c3b(255, 255, 255), 255, path)
		_richText:pushBackElement(reimg)
		local re2 =ccui.RichElementText:create(1, color,255, string.format(text_info[2],dms.string(dms["arena_config"],13,arena_config.param)), config_res.font.font_name,20)
		_richText:pushBackElement(re2)
	elseif zstring.tonumber(self._tip_type) == 7 then	
		Text_141:setString(mission_tip_string[3])
	elseif zstring.tonumber(self._tip_type) == 8 then	
		local Image_1 = ccui.Helper:seekWidgetByName(root,"Image_1")
		local wdatas = zstring.split(dms.string(dms["world_config"], 7 , world_config.param), "|")
		local datas = zstring.split(wdatas[1], ",")
		if tonumber(datas[1]) == -1 then
			datas[1] = resource_prop_id[tonumber(datas[2])]
			datas[2] = 1
		end
		local prop_type = tonumber(datas[2])
		local show_type = 1
		local prop_from_type = 3
		if tonumber(datas[2]) == 13 then --坦克
			prop_type = 3
			prop_from_type = 10
		elseif tonumber(datas[2]) == 6 then --道具	
			prop_type = 1
			prop_from_type = 1
		elseif tonumber(datas[2]) == 7 then --配件	
			prop_type = 7
			prop_from_type = 4
		else
			prop_type = 1
			prop_from_type = 1
		end
		local cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),nil,tonumber(datas[1])})
		cell:setPosition(cc.p(Image_1:getContentSize().width/2-cell:getContentSize().width/2,Image_1:getContentSize().height/2+Text_141:getContentSize().height/3))
		Image_1:addChild(cell)

		local prop_number_list = cc.Label:createWithTTF("", config_res.font.font_name, 18 / CC_CONTENT_SCALE_FACTOR())
		prop_number_list:setName("prop_number_list")
		prop_number_list:setAnchorPoint(cc.p(0.5, 0.5))
		prop_number_list:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
		prop_number_list:setPositionX(Text_141:getContentSize().width/2)
		prop_number_list:setPositionY(Text_141._y-Text_141:getContentSize().height*4/3)
		prop_number_list:setTag(100)
		local numbers = 0
		for i,v in pairs(_ED.user_prop) do
			if tonumber(v.user_prop_template) == tonumber(datas[1]) then
				numbers = tonumber(v.prop_number)
			end
		end		
		prop_number_list:setString(numbers)
		Text_141:addChild(prop_number_list)

		Text_141:setPositionY(Text_141._y-Text_141:getContentSize().height/2)
		local _richText2 = ccui.RichText:create()
		_richText2:ignoreContentAdaptWithSize(false)
		_richText2:setContentSize(cc.size(Text_141:getContentSize().width, Text_141:getContentSize().height))
		_richText2:setAnchorPoint(cc.p(0.5, 0.5))
		local propMould = dms.element(dms["prop_mould"], tonumber(datas[1]))
		--local datas1 = string.gsub(tipStringInfo_consumption_info[23],"x",dms.atoi(propMould,prop_mould.prop_quality)+1)
		--local datas2 = string.gsub(datas1,"y",dms.atos(propMould,prop_mould.prop_name))
		local quality_str = dms.atos(propMould,prop_mould.prop_quality)+1
		local name_str = dms.atos(propMould,prop_mould.prop_name)
		local datas2 = string.format(tipStringInfo_consumption_info[23],quality_str,name_str)
		local mx = 599 + self._cell.tileX + 1
		local my = self._cell.tileY + 1
		-- local ta = _ED.cta[my][mx]
		local ta = {}
		local ta_x, ta_y = cc.dms_init_world_map_get(2, mx, my)
		self._targetX = ta_x
		self._targetY = ta_y
		local strs = "["..ta_x..","..ta_y.."]?"
		--local datas_info = zstring.split(datas2, "z") --最后的问好拼接到坐标里面，这里不用切割了
		-- local char_str = string.gsub(datas2,"z",strs)
		--local char_str = datas_info[1]
		local char_str = datas2
		if verifySupportLanguage(_lua_release_language_en) == true then
			char_str = char_str..strs
		end
		local rt, count, text = draw.richTextCollectionMethod(_richText2, 
		char_str, 
		cc.c3b(189, 206, 224),
		cc.c3b(189, 206, 224),
		0, 
		0, 
		config_res.font.font_name, 
		20,
		chat_rich_text_color)
		_richText2:formatTextExt()
		local rsize = _richText2:getContentSize()
		_richText2:setPositionY(Text_141:getContentSize().height/2)
		_richText2:setPositionX(Text_141:getContentSize().width)
		Text_141:addChild(_richText2)
		if verifySupportLanguage(_lua_release_language_en) == true then
		else
			local strs_posit = cc.Label:createWithTTF("", config_res.font.font_name, 18 / CC_CONTENT_SCALE_FACTOR())
			strs_posit:setName("strs_posit")
			strs_posit:setAnchorPoint(cc.p(0.5, 0.5))
			strs_posit:setColor(cc.c3b(189, 206, 224))
			strs_posit:setPositionX(Text_141:getContentSize().width/2)
			strs_posit:setPositionY(Text_141._y-Text_141:getContentSize().height/2-Text_141:getContentSize().height-rsize.height)
			strs_posit:setTag(200)
			strs_posit:setString(strs)
			Text_141:addChild(strs_posit)
		end

	elseif zstring.tonumber(self._tip_type) == 9 then	 
		Text_141:setString(tipStringInfo_consumption_info[25])
	elseif zstring.tonumber(self._tip_type) == 10 then	
		Text_141:setString(tipStringInfo_consumption_info[26])
    elseif zstring.tonumber(self._tip_type) == 11 then 
        local cell = self._cell
        local prop_name = dms.string(dms["prop_mould"], cell._reward_prop[1], prop_mould.prop_name)
        local cost = tonumber(cell._cost_prop[3])      
        _richText = ccui.RichText:create()
        local rt, count, text = draw.richTextCollectionMethod(_richText, 
        string.format(red_alert_time_str[234], cost, prop_name), 
        cc.c3b(255, 255, 255),
        cc.c3b(255, 255, 255),
        0, 
        0, 
        config_res.font.font_name, 
        20,
        chat_rich_text_color)   
    elseif zstring.tonumber(self._tip_type) == 12
    	or zstring.tonumber(self._tip_type) == 27 
        or zstring.tonumber(self._tip_type) == 31
        or zstring.tonumber(self._tip_type) == 33
        or zstring.tonumber(self._tip_type) == 34
    	then
    	_richText = ccui.RichText:create()
		local color = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
		local text_info = zstring.split(arena_tip_text[1], "/&|")
		local re1 =ccui.RichElementText:create(1, color,255, text_info[1], config_res.font.font_name,18)
		_richText:pushBackElement(re1)
		local path = config_res.images.ui.home.icon_gold
		local reimg = ccui.RichElementImage:create(2, cc.c3b(255, 255, 255), 255, path)
		_richText:pushBackElement(reimg)
		local re2 =ccui.RichElementText:create(1, color,255, string.format(red_alert_time_str[67], self._cell[1], self._cell[2]), config_res.font.font_name,18)
		_richText:pushBackElement(re2)
    elseif zstring.tonumber(self._tip_type) == 13 then
    	local cell = self._cell
        _richText = ccui.RichText:create()
        local rt, count, text = draw.richTextCollectionMethod(_richText, 
        string.format(red_alert_time_str[251], cell._consume_devote, cell._by_open_npc), 
        cc.c3b(255, 255, 255),
        cc.c3b(255, 255, 255),
        0, 
        0, 
        config_res.font.font_name, 
        20,
        chat_rich_text_color) 
    elseif zstring.tonumber(self._tip_type) == 14 then    
    	Text_141:setString(string.format(activity_str_tip[63],self._cell))
	elseif zstring.tonumber(self._tip_type) == 15 then    
    	Text_141:setString(string.format(activity_str_tip[63],self._cell))
    elseif zstring.tonumber(self._tip_type) == 16 then    
    	Text_141:setString(string.format(activity_str_tip[64],self._cell))	
	elseif zstring.tonumber(self._tip_type) == 17 then    
    	Text_141:setString(string.format(activity_str_tip[65],self._cell[1],self._cell[2]))	
	elseif zstring.tonumber(self._tip_type) == 0 
        or zstring.tonumber(self._tip_type) == 36
        then	 	
		Text_141:setString(self._cell)
	elseif zstring.tonumber(self._tip_type) == 18 then 
        local cell = self._cell
        local prop_name = ""
        if tonumber(cell._reward_prop[2]) == 13 then
        	prop_name = dms.string(dms["ship_mould"], cell._reward_prop[1], ship_mould.captain_name)
        else
        	prop_name = dms.string(dms["prop_mould"], cell._reward_prop[1], prop_mould.prop_name)
        end
        local cost = tonumber(cell._cost_prop[3])      
        _richText = ccui.RichText:create()
        local rt, count, text = draw.richTextCollectionMethod(_richText, 
        string.format(red_alert_time_str[260], cost, prop_name), 
        cc.c3b(255, 255, 255),
        cc.c3b(255, 255, 255),
        0, 
        0, 
        config_res.font.font_name, 
        20,
        chat_rich_text_color)   
    elseif zstring.tonumber(self._tip_type) == 19 then
        _richText = ccui.RichText:create()
        local color = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
        local text_info = zstring.split(arena_tip_text[37], "/&|")
        local re1 =ccui.RichElementText:create(1, color,255, text_info[1], config_res.font.font_name,20)
        _richText:pushBackElement(re1)
        local path = config_res.images.ui.home.icon_gold
        local reimg = ccui.RichElementImage:create(2, cc.c3b(255, 255, 255), 255, path)
        _richText:pushBackElement(reimg)
        local re2 =ccui.RichElementText:create(1, color,255, string.format(text_info[2],self._cell._refresh_cost), config_res.font.font_name,20)
        _richText:pushBackElement(re2)
    elseif zstring.tonumber(self._tip_type) == 20
        or zstring.tonumber(self._tip_type) == 32 
        then  
    	local acitvity = _ED.activity_info[""..self._cell.activity_type]
    	local timesData = zstring.split(acitvity.activity_add_state, ",")
    	local totalDay = tonumber(timesData[6])
    	if totalDay >= self._cell._max_sign_day then
    		totalDay = self._cell._max_sign_day
    	end
    	local m_times = totalDay - tonumber(timesData[4])
    	local todayFinishState = zstring.tonumber(timesData[8])
		if todayFinishState == 0 then
			m_times = m_times - 1
		end
        _richText = ccui.RichText:create()
        local rt, count, text = draw.richTextCollectionMethod(_richText, 
        string.format(activity_str_tip[87], m_times, ""..(m_times*tonumber(timesData[7]))), 
        cc.c3b(255, 255, 255),
        cc.c3b(255, 255, 255),
        0, 
        0, 
        config_res.font.font_name, 
        20,
        chat_rich_text_color) 
    elseif zstring.tonumber(self._tip_type) == 25 then
        _richText = ccui.RichText:create()
        local color = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
        local text_info = zstring.split(red_alert_time_str[178], "/&|")
        local re1 =ccui.RichElementText:create(1, color,255, text_info[1], config_res.font.font_name,20)
        _richText:pushBackElement(re1)
        local path = config_res.images.ui.home.icon_gold
        local reimg = ccui.RichElementImage:create(2, cc.c3b(255, 255, 255), 255, path)
        _richText:pushBackElement(reimg)
        local cost = dms.int(dms["guard_config"], 8, guard_config.param)
        local re2 =ccui.RichElementText:create(1, color,255, string.format(text_info[2],cost), config_res.font.font_name,20)
        _richText:pushBackElement(re2)
    elseif zstring.tonumber(self._tip_type) == 26 then
        _richText = ccui.RichText:create()
        local color = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
        local text_info = zstring.split(armor_tip_str[26], "/&|")
        local re1 =ccui.RichElementText:create(1, color,255, text_info[1], config_res.font.font_name,20)
        _richText:pushBackElement(re1)
        local path = config_res.images.ui.home.icon_gold
        local reimg = ccui.RichElementImage:create(2, cc.c3b(255, 255, 255), 255, path)
        _richText:pushBackElement(reimg)
        local re2 =ccui.RichElementText:create(1, color,255, string.format(text_info[2],self._cell.cost, self._cell.capacity), config_res.font.font_name,20)
        _richText:pushBackElement(re2)
    elseif zstring.tonumber(self._tip_type) == 28 then    
    	_richText = ccui.RichText:create()
		local color = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
		local text_info = zstring.split(activity_str_tip[130], "/&|")
		local re1 =ccui.RichElementText:create(1, color,255, text_info[1], config_res.font.font_name,18)
		_richText:pushBackElement(re1)
		local path = config_res.images.ui.home.icon_gold
		local reimg = ccui.RichElementImage:create(2, cc.c3b(255, 255, 255), 255, path)
		_richText:pushBackElement(reimg)
		local re2 =ccui.RichElementText:create(1, color,255, string.format(text_info[2], self._cell[1]), config_res.font.font_name,18)
		_richText:pushBackElement(re2)
	elseif zstring.tonumber(self._tip_type) == 29 
        or zstring.tonumber(self._tip_type) == 37 
        then 
		_richText = ccui.RichText:create()
		local str = string.format(activity_str_tip[138], self._cell[1].need_gold, self._cell[1].quality,self._cell[1].goods_name)
		if self._cell[1].curr_dis ~= nil then
			str = str..self._cell[1].curr_dis
		end
        local rt, count, text = draw.richTextCollectionMethod(_richText, 
        str, 
        cc.c3b(255, 255, 255),
        cc.c3b(255, 255, 255),
        0, 
        0, 
        config_res.font.font_name, 
        20,
        chat_rich_text_color)
    elseif zstring.tonumber(self._tip_type) == 30 then 
        _richText = ccui.RichText:create()
        local str = string.format(world_city_tip_str[22], self._cell._cost, self._cell._energy)
        local rt, count, text = draw.richTextCollectionMethod(_richText, 
        str, 
        cc.c3b(255, 255, 255),
        cc.c3b(255, 255, 255),
        0, 
        0, 
        config_res.font.font_name, 
        20,
        chat_rich_text_color)

        local Text_legion_city_p = ccui.Helper:seekWidgetByName(root, "Text_legion_city_p")
        if Text_legion_city_p ~= nil then
            Text_legion_city_p:setVisible(true)
        end
    elseif zstring.tonumber(self._tip_type) == 35 
        or zstring.tonumber(self._tip_type) == 38 
        then
        _richText = ccui.RichText:create()
        local color = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
        local text_info = zstring.split(arena_tip_text[1], "/&|")
        local re1 =ccui.RichElementText:create(1, color,255, text_info[1], config_res.font.font_name,18)
        _richText:pushBackElement(re1)
        local path = config_res.images.ui.home.icon_gold
        local reimg = ccui.RichElementImage:create(2, cc.c3b(255, 255, 255), 255, path)
        _richText:pushBackElement(reimg)
        local re2 =ccui.RichElementText:create(1, color,255, string.format(activity_str_tip[178], self._cell[1], self._cell[2]), config_res.font.font_name,18)
        _richText:pushBackElement(re2)
    elseif zstring.tonumber(self._tip_type) == 39 then
        _richText = ccui.RichText:create()
        local color = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
        local text_info = zstring.split(arena_tip_text[1], "/&|")
        local re1 =ccui.RichElementText:create(1, color,255, text_info[1], config_res.font.font_name,18)
        _richText:pushBackElement(re1)
        local path = config_res.images.ui.home.icon_gold
        local reimg = ccui.RichElementImage:create(2, cc.c3b(255, 255, 255), 255, path)
        _richText:pushBackElement(reimg)
        local re2 =ccui.RichElementText:create(1, color,255, string.format(activity_str_tip[204], self._cell[1], self._cell[2]), config_res.font.font_name,18)
        _richText:pushBackElement(re2)
    elseif zstring.tonumber(self._tip_type) == 40 then
    	_richText = ccui.RichText:create()
        local color = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
        local re1 =ccui.RichElementText:create(1, color,255, activity_str_tip[205], config_res.font.font_name,20)
        _richText:pushBackElement(re1)

        local Button_4_8 = ccui.Helper:seekWidgetByName(root,"Button_4_8")
        local Button_3_6 = ccui.Helper:seekWidgetByName(root,"Button_3_6")
        Button_4_8:setTitleText(activity_str_tip[207])
        Button_3_6:setTitleText(activity_str_tip[206])
	end
	--将富文本的布置统一处理,之前个别处理方式会导致ui调整界面的时候文字发生偏移
	--8号类型（高级迁移令迁移）因下面坐标需要采用富文本尺寸，暂时单独处理
	if _richText ~= nil then
		_richText:ignoreContentAdaptWithSize(false)
		_richText:setContentSize(textContentSize)
		_richText:formatTextExt()
		_richText:setPosition(cc.p(textContentSize.width,textContentSize.height/2))
		Text_141:addChild(_richText)
	end
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_4_8"), nil, 
    {
        terminal_name = "red_alert_time_mine_warm_tips_window_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,3)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_prompt_close"), nil, 
    {
        terminal_name = "red_alert_time_mine_warm_tips_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_mine_warm_tips_window_close",
        terminal_state = 0,
    },
    nil,1)
	
	--确定
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_3_6"), nil, 
    {
        terminal_name = "red_alert_time_mine_base_migration",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
		cell = self._cell,
    },
    nil,1)
	
end

function redAlertTimeMineWarmTips:onExit()
	state_machine.remove("red_alert_time_mine_base_migration")
	state_machine.remove("red_alert_time_mine_warm_tips_window_close")
end