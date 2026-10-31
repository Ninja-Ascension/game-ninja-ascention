-----------------------------
--邮件报告详情
-----------------------------
MailPresentationInfo = class("MailPresentationInfoClass", Window)

local mail_presentation_info_window_open_terminal = {
    _name = "mail_presentation_info_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:open(MailPresentationInfo:new():init(params), fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

local mail_presentation_info_window_close_terminal = {
    _name = "mail_presentation_info_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("MailPresentationInfoClass"))
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(mail_presentation_info_window_open_terminal)
state_machine.add(mail_presentation_info_window_close_terminal)
state_machine.init()

function MailPresentationInfo:ctor()
    self.super:ctor()
    self.roots = {}
    
	self._mail_data = nil
	self._report_type = 0
	self._mtype = 0
	
    self._info = nil

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = nil

    self._Image_presentation_arrow_down = nil
    self._Image_presentation_arrow_up = nil
	
	self.title_info = ""
    self.shareId = 0
    self.paramsInfo = ""

	self.isSave = false

    self._info_show = {false, false, false}         -- 是否显示配件、装甲、将领信息
    self._info_panel_root = nil

    self._enemy_coord = nil            -- 对方坐标
	
	app.load("client.red_alert_time.cells.props.props_icon_cell")
	app.load("client.red_alert_time.mail.MailWriteAn")
    app.load("client.red_alert_time.cells.worldMap.world_mine_line_list_cell")
    app.load("client.red_alert_time.cells.mail.mail_presentation_info_cell")

    local function init_mail_presentation_info_terminal()
        -- 删除
        local mail_presentation_info_delete_terminal = {
            _name = "mail_presentation_info_delete",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- local mail_id = instance._mail_data.mail_id
				local cell = params._datas.cells
				if cell._mtype ~= 10 then
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil then
								--清除
								for i, v in pairs(_ED.city_resource_battle_report[tonumber(cell._report_type)]) do
									if tonumber(v.time) == tonumber(response.node._mail_data.time) then
										_ED.city_resource_battle_report[tonumber(response.node._report_type)][i] = nil
									end
								end
								-- debug.print_r(_ED.city_resource_battle_report[tonumber(cell._report_type)])
								--刷新
								if tonumber(response.node._report_type) == 200
									or tonumber(response.node._report_type) == 203
								 	then
									-- state_machine.excute("mail_presentation_attack_update_remove",0,{_datas = {times = cell._mail_data.time}})
									state_machine.excute("mail_presentation_attack_update_all",0,0)
								elseif tonumber(response.node._report_type) == 1200 then
									state_machine.excute("mail_presentation_defensive_update_all",0,0)
								elseif tonumber(response.node._report_type) == 10002 then
									state_machine.excute("mail_presentation_investigation_update_all",0,0)
								elseif tonumber(response.node._report_type) == 11 then
									state_machine.excute("arena_my_record_tab_update_draw",0,0)
                                elseif tonumber(response.node._report_type) == 201 then
                                    state_machine.excute("expedition_record_update_list_info",0,0)
                                elseif tonumber(response.node._report_type) == 202 then
                                    state_machine.excute("limit_dekaron_grand_update_list_info",0,0)
								end
								state_machine.excute("mail_presentation_info_window_close",0,{nil,data})
							end
						end	
					end
					protocol_command.delete_message.param_list = cell._report_type.."\r\n"..cell._mail_data.time
					NetworkManager:register(protocol_command.delete_message.code, nil, nil, nil, cell, responseCallback, false, nil)
				else
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil then
								--清除
								for i, v in pairs(_ED.city_resource_battle_save_report) do
									if tonumber(v.time) == tonumber(response.node._mail_data.time) then
										_ED.city_resource_battle_save_report[i] = nil
									end
								end
								state_machine.excute("mail_save_the_box_update_draw",0,0)
								state_machine.excute("mail_presentation_info_window_close",0,0)
							end
						end	
					end
                    protocol_command.battlefield_report_save_delete.param_list = cell._mail_data.time
                    NetworkManager:register(protocol_command.battlefield_report_save_delete.code, nil, nil, nil, cell, responseCallback, false, nil)    
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
		
		--回放
		local mail_presentation_info_playback_terminal = {
            _name = "mail_presentation_info_playback",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                state_machine.lock("mail_presentation_info_playback")
                local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        fwin:addService({
                            callback = function ( params )
                                state_machine.unlock("mail_presentation_info_playback")
                            end,
                            delay = 0.3,
                            params = nil
                        })
						if response.node ~= nil and response.node.roots ~= nil then
							_ED._is_playback = true
							if _ED._battle_sweep == 1 then

							else
								-- fwin:cleanView(fwin._ui)
								_ED.init_environment_fight_complete = true
								
								state_machine.excute("formation_defend_close", 0, 0)
								state_machine.excute("formation_window_close", 0, 0)
								state_machine.excute("fight_window_open", 0, 0)
								state_machine.excute("formation_defend_close", 0, 0)
							end
						end
                    else
                        state_machine.unlock("mail_presentation_info_playback")
					end		
                end
				-- if cell._report_type == 11 or self._report_type == 10000 
					-- or cell._report_type == 24
					-- then
					local scene_npc_tab = dms.string(dms["arena_config"],11,arena_config.param)
					scene_npc_tab = zstring.split(scene_npc_tab,",")
					local scene_id = scene_npc_tab[1]
					local npc_id = scene_npc_tab[2]
					_ED._current_scene_id = scene_id
					_ED._scene_npc_id = npc_id
					if cell._report_type == 200 or self._report_type == 1200 then
						_ED._battle_init_type = 200
					else
						_ED._battle_init_type = cell._report_type
					end
					
				-- end
				if cell._mtype == 100 then
					protocol_command.get_share_message.param_list = cell._mail_data.sender.."\r\n"..cell._mail_data.nType.."\r\n"..cell._mail_data.time.."\r\n".."1"
					NetworkManager:register(protocol_command.get_share_message.code, nil, nil, nil, self, responseCallback, false, nil)
				else
					protocol_command.battlefield_report_battle_info_get.param_list = cell._report_type.."\r\n"..cell._mail_data.time
					NetworkManager:register(protocol_command.battlefield_report_battle_info_get.code, nil, nil, nil, self, responseCallback, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

		--保存
		local mail_presentation_info_save_terminal = {
            _name = "mail_presentation_info_save",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                if cell.isSave == false then
	                local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                response.node:onUpdateButton()
                            end
                            TipDlg.drawTextDailog(mail_tip_text[15])
                            state_machine.excute("mail_save_the_box_update_draw", 0, nil)
                        end 
	                end
	                protocol_command.battlefield_report_save.param_list = cell._report_type.."\r\n"..cell._mail_data.time
	                NetworkManager:register(protocol_command.battlefield_report_save.code, nil, nil, nil, cell, responseCallback, false, nil)
            	else
            		local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                --清除
                                for i, v in pairs(_ED.city_resource_battle_save_report) do
                                    if tonumber(v.time) == tonumber(cell._mail_data.time) then
                                        _ED.city_resource_battle_save_report[i] = nil
                                    end
                                end
                                response.node:onUpdateButton()
                            end
                            TipDlg.drawTextDailog(mail_tip_text[26])
                            state_machine.excute("mail_save_the_box_update_draw", 0, nil)
                        end
					end
                    protocol_command.battlefield_report_save_delete.param_list = cell._mail_data.time
					NetworkManager:register(protocol_command.battlefield_report_save_delete.code, nil, nil, nil, cell, responseCallback, false, nil)	
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
		
		--查找
		local mail_presentation_info_Find_terminal = {
            _name = "mail_presentation_info_Find",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells

				local attachedInfo = zstring.split(cell._mail_data.param, "|")
				local attachedOne = zstring.split(attachedInfo[2], ",")
                local attachedTwo = zstring.split(attachedInfo[3], ",")
                local position_x = tonumber(attachedOne[5])
                local position_y = tonumber(attachedOne[6])
                if cell._report_type == 200 
                    and tonumber(attachedInfo[1]) == 0 
                    and #attachedTwo >= 2 
                    then      -- 进攻
                    position_x = tonumber(attachedTwo[5])
                    position_y = tonumber(attachedTwo[6])
                end

				state_machine.excute("mail_presentation_info_window_close", 0, 0)
				state_machine.excute("mail_window_close", 0, 0)
				state_machine.excute("home_button_select_page", 0, {_datas = {select_page = 2}})
				state_machine.excute("adventure_mine_record_view_position", 0, {position_x,position_y})
				state_machine.excute("adventure_mine_update_view_position", 0, 0)

                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("adventure_mine_cell_focus_blink", 0, _ED.world_map_focus)
                    end
                end

				_ED.world_map_focus = {position_x, position_y}
                protocol_command.world_map_arena_info_refresh.param_list = "" .. tonumber(attachedOne[5]) .. "\r\n" ..  tonumber(attachedOne[6])
                NetworkManager:register(protocol_command.world_map_arena_info_refresh.code, nil, nil, nil, nil, responseCallback, false, nil)
                --print(attachedOne[5],attachedOne[6])
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		--打开分享
		local mail_presentation_info_open_share_terminal = {
            _name = "mail_presentation_info_open_share",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local root = instance.roots[1]
                local Panel_share = ccui.Helper:seekWidgetByName(root, "Panel_share")
                local Panel_share_close = ccui.Helper:seekWidgetByName(root, "Panel_share_close")
                Panel_share:setVisible(true)
                Panel_share_close:setVisible(true)
                Animations_PlayOpenMainUI({Panel_share}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_SLIDE_DOWN, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		--关闭分享
		local mail_presentation_info_close_share_terminal = {
            _name = "mail_presentation_info_close_share",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local root = instance.roots[1]
                local Panel_share = ccui.Helper:seekWidgetByName(root, "Panel_share")
                local Panel_share_close = ccui.Helper:seekWidgetByName(root, "Panel_share_close")
                Panel_share:setVisible(false)
                Panel_share_close:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		--分享到聊天
		local mail_presentation_info_share_chats_terminal = {
            _name = "mail_presentation_info_share_chats",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                if tonumber(params._datas.chat_type) == 14 then
                    if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    then
                        state_machine.excute("mail_presentation_info_close_share", 0, 0)            
                        TipDlg.drawTextDailog(game_share_tip_text[2])
                        return
                    end
                end
                if funOpenDrawTip(237) == true then
                    state_machine.excute("mail_presentation_info_close_share", 0, 0) 
                    return
                end 
				local function responseSendMessageCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							state_machine.excute("mail_presentation_info_close_share", 0, 0)
							TipDlg.drawTextDailog(game_share_tip_text[1])
						end	
					end
				end
				local datas = nil
				if cell._report_type == 11 or cell._report_type == 10000 then--战地争霸类型
					datas = cell.title_info
				else
					datas = cell.title_info
				end

                local npc_mould_id = 0
                if cell._mail_data.npc_moud_id ~= nil and tonumber(cell._mail_data.npc_moud_id) > 0 then
                    npc_mould_id = cell._mail_data.npc_moud_id
                end

				local str = chat_section[1].."5".."|"..cell._mail_data.time.."+"..cell._mail_data.userHeadPic.."+"..cell._mail_data.userCamp.."+"..cell._mail_data.userGender
					.."+"..cell._mail_data.userFighting.."+"..cell._mail_data.read_type.."+"..cell._mail_data.userOfficialRankId.."+"..cell._mail_data.param
					.."+"..cell._mail_data.result.."+"..cell._mail_data.nType.."+"..cell._mail_data.userLevel.."+"..cell._mail_data.userId.."+"..cell._mail_data.userName.."+".._ED.user_info.user_id.."+"..npc_mould_id

           		protocol_command.send_share_message.param_list = zstring.exchangeTo(str).."\r\n"..params._datas.chat_type.. "\r\n" .. "0".."\r\n".._ED.user_info.user_id.."\r\n"..cell._report_type.."\r\n"..cell._mail_data.time.."\r\n"..cell.shareId.."\r\n"..zstring.exchangeTo(cell.paramsInfo)
                NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_share_message.code))
           		responseSendMessageCallback({node=cell, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		--写邮件
		local mail_presentation_info_an_email_terminal = {
            _name = "mail_presentation_info_an_email",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if tonumber(self._mail_data.mail_params.mail_type) == 0 then
            		state_machine.excute("write_an_email_window_open", 0, {_datas={name=self._mail_data.mail_params.Defensive_side.name,title=""}})
            	else
            		state_machine.excute("write_an_email_window_open", 0, {_datas={name=self._mail_data.mail_params.Attack_side.name,title=""}})
            	end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        --进攻
        local mail_presentation_info_attack_terminal = {
            _name = "mail_presentation_info_attack",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if (instance._report_type == 200 and  tonumber(instance._mail_data.mail_params.Attack_side.attack_type) == 4) then
                    local attack_info = {}
                    attack_info._mould_id = instance._mail_data.mail_params.Attack_side.mine_mould_id
                    attack_info._x = instance._mail_data.mail_params.Attack_side.attack_print_x
                    attack_info._y = instance._mail_data.mail_params.Attack_side.attack_print_y
                    state_machine.excute("formation_window_open", 0, {_datas = {form_type = 2, attack_cell = attack_info ,playersOrmine = 0}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        --显示隐藏配件信息
        local mail_presentation_info_show_equipment_info_terminal = {
            _name = "mail_presentation_info_show_equipment_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                for i = 1, 3 do 
                    if params[i] ~= nil then
                        instance._info_show[i] = params[i]
                    end
                end
                instance:updateEquipmentInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

		state_machine.add(mail_presentation_info_delete_terminal)
		state_machine.add(mail_presentation_info_playback_terminal)
		state_machine.add(mail_presentation_info_save_terminal)
		state_machine.add(mail_presentation_info_Find_terminal)
		state_machine.add(mail_presentation_info_open_share_terminal)
		state_machine.add(mail_presentation_info_close_share_terminal)
		state_machine.add(mail_presentation_info_share_chats_terminal)
		state_machine.add(mail_presentation_info_an_email_terminal)
        state_machine.add(mail_presentation_info_attack_terminal)
        state_machine.add(mail_presentation_info_show_equipment_info_terminal)
        state_machine.init()
    end
    init_mail_presentation_info_terminal()
end


function MailPresentationInfo:getTimeFormatYMDHMS( m_time )
	local temp = os.date("*t",getBaseGTM8Time(m_time))

	local m_month 	= string.format("%02d", temp.month)
	local m_day 	= string.format("%02d", temp.day)
	local m_hour 	= string.format("%02d", temp.hour)
	local m_min 	= string.format("%02d", temp.min)
	local m_sec 	= string.format("%02d", temp.sec)


	local timeString = temp.year ..".".. m_month ..".".. m_day .." ".. m_hour ..":".. m_min ..":".. m_sec


    return timeString
end

function MailPresentationInfo:onUpdateButton()
	local root = self.roots[1]
	self.isSave = false
	local Button_mail_presentation_save = ccui.Helper:seekWidgetByName(root,"Button_mail_presentation_save")
	if _ED.city_resource_battle_save_report == nil or #_ED.city_resource_battle_save_report <= 1 then
		local function responseCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if response.node ~= nil and response.node.roots ~= nil then
					for i,v in pairs(_ED.city_resource_battle_save_report) do
						if tonumber(v.time) == tonumber(self._mail_data.time) and tonumber(v.nType) == tonumber(self._report_type) then
							self.isSave = true
						end	
					end
					if self.isSave == true then
						Button_mail_presentation_save:setTitleText(mail_tip_text[23])
					else
						Button_mail_presentation_save:setTitleText(mail_tip_text[22])
					end
				end
			end
		end
		NetworkManager:register(protocol_command.battlefield_report_save_get.code, nil, nil, nil, self, responseCallback, false, nil)
	else
		for i,v in pairs(_ED.city_resource_battle_save_report) do
			if tonumber(v.time) == tonumber(self._mail_data.time) and tonumber(v.nType) == tonumber(self._report_type) then
				self.isSave = true
			end	
		end
		if self.isSave == true then
			Button_mail_presentation_save:setTitleText(mail_tip_text[23])
		else
			Button_mail_presentation_save:setTitleText(mail_tip_text[22])
		end
	end
end

function MailPresentationInfo:onUpdateDraw(  )
    local root = self.roots[1]
    local Panel_battle_state_icon = ccui.Helper:seekWidgetByName(root,"Panel_battle_state_icon")        -- 邮件图标
    local Text_battle_infor = ccui.Helper:seekWidgetByName(root,"Text_battle_infor")                    -- 标题
    local Text_battle_result = ccui.Helper:seekWidgetByName(root,"Text_battle_result")                  -- 类型
    local Text_battle_grrison_state = ccui.Helper:seekWidgetByName(root,"Text_battle_grrison_state")                  -- 是否有驻军
    local Text_battle_time = ccui.Helper:seekWidgetByName(root,"Text_battle_time")             -- 时间
	Text_battle_infor:removeAllChildren(true)
	Text_battle_infor:setString("")
    local result_type = 0   -- 0:胜利，1：失败
    if self._report_type == 11     --战地争霸类型
        or self._report_type == 10000 
        or self._report_type == 24
        or self._report_type == 10001
        or self._report_type == 10003   --军团争霸类型
        or self._report_type == 10004
        or self._report_type == 207
        or self._report_type == 209
        or self._report_type == 10006
        then 
        Panel_battle_state_icon:removeAllChildren(true)
        local attachedInfo = zstring.split(self._mail_data.param, "|")
        local image_name =""
		if tonumber(attachedInfo[1]) == 0 then 
			--攻
			if tonumber(self._mail_data.result) == 1 then
				Text_battle_result:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
				Text_battle_result:setString(arena_tip_text[2]) --胜利
				image_name = "images/ui/share/world_implement_icon_1.png"
                if self._report_type == 10003 or self._report_type == 10004 or self._report_type == 207 or self._report_type == 209 or self._report_type == 10006 then
                    Text_battle_result:setString(arena_tip_text[28])
                end
                result_type = 0
			else
				Text_battle_result:setColor(cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2]))
				Text_battle_result:setString(arena_tip_text[3]) --失败
				image_name = "images/ui/share/world_implement_icon_5.png"
                if self._report_type == 10003 or self._report_type == 10004 or self._report_type == 207 or self._report_type == 209 or self._report_type == 10006 then
                    Text_battle_result:setString(arena_tip_text[29])
                end
                result_type = 1
			end
			Panel_battle_state_icon:setBackGroundImage(image_name)
			local _richText1 = ccui.RichText:create()
			_richText1:ignoreContentAdaptWithSize(false)
			local color1 = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
			local color2 = cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2])
			local re1 = nil
			local re2 = nil
			if tonumber(self._report_type) == 11 then
				re1 =ccui.RichElementText:create(1, color1,255, arena_tip_text[6], config_res.font.font_name,22)
				re2 =ccui.RichElementText:create(1, color2,255, self._mail_data.userName.." "..friends_tip_string[12]..self._mail_data.userLevel, config_res.font.font_name,22)
				_richText1:pushBackElement(re1)
				_richText1:pushBackElement(re2)

                local datas = dms.string(dms["message_share"], 53 + result_type, message_share.content)
                local data1 =  string.gsub(datas, "!x@", self._mail_data.userName.." "..friends_tip_string[12]..self._mail_data.userLevel)
				self.title_info = data1
                self.shareId = 53 + result_type
                -- self.paramsInfo = self._mail_data.userName.." "..friends_tip_string[12]..self._mail_data.userLevel
                self.paramsInfo = "0-0,"..self._mail_data.userName.." "..friends_tip_string[12]..self._mail_data.userLevel
			elseif self._report_type == 10003 or self._report_type == 10004 or self._report_type == 207 or self._report_type == 209 or self._report_type == 10006 then
                local attackInfo = zstring.split(attachedInfo[2], ",")
                local defendInfo = zstring.split(attachedInfo[3], ",")
                
                re1 =ccui.RichElementText:create(1, color2,255, attackInfo[1].." "..friends_tip_string[12]..attackInfo[3], config_res.font.font_name,22)
                re2 =ccui.RichElementText:create(1, color1,255, arena_tip_text[27], config_res.font.font_name,22)
                re3 =ccui.RichElementText:create(1, color2,255, defendInfo[1].." "..friends_tip_string[12]..defendInfo[3], config_res.font.font_name,22)
                _richText1:pushBackElement(re1)
                _richText1:pushBackElement(re2)
                _richText1:pushBackElement(re3)

                local datas = dms.string(dms["message_share"], 61 + result_type, message_share.content)
                local data1 =  string.gsub(datas, "!x@", attackInfo[1].." "..friends_tip_string[12]..attackInfo[3])
                local data2 =  string.gsub(data1, "!y@", defendInfo[1].." "..friends_tip_string[12]..defendInfo[3])
                self.title_info = data2
                self.shareId = 61 + result_type
                -- self.paramsInfo = attackInfo[1].." "..friends_tip_string[12]..attackInfo[3]..","..defendInfo[1].." "..friends_tip_string[12]..defendInfo[3]
                self.paramsInfo = "0-0,"..attackInfo[1].." "..friends_tip_string[12]..attackInfo[3]..","..defendInfo[1].." "..friends_tip_string[12]..defendInfo[3]
            else
				local attackInfo = zstring.split(attachedInfo[2], ",")
				local defendInfo = zstring.split(attachedInfo[3], ",")
				
				re1 =ccui.RichElementText:create(1, color2,255, attackInfo[1].." "..friends_tip_string[12]..attackInfo[3], config_res.font.font_name,22)
				re2 =ccui.RichElementText:create(1, color1,255, arena_tip_text[11], config_res.font.font_name,22)
				re3 =ccui.RichElementText:create(1, color2,255, defendInfo[1].." "..friends_tip_string[12]..defendInfo[3], config_res.font.font_name,22)
				_richText1:pushBackElement(re1)
				_richText1:pushBackElement(re2)
				_richText1:pushBackElement(re3)

                if self._report_type == 10001 or tonumber(self._report_type) == 24 then
                    if attackInfo[1] == _ED.user_info.user_name then
                        local datas = dms.string(dms["message_share"], 48 + result_type, message_share.content)
                        local data1 =  string.gsub(datas, "!x@", defendInfo[1].." "..friends_tip_string[12]..defendInfo[3])
                        self.title_info = data1
                        self.shareId = 48 + result_type
                        -- self.paramsInfo = defendInfo[1].." "..friends_tip_string[12]..defendInfo[3]
                        self.paramsInfo = "0-0,"..defendInfo[1].." "..friends_tip_string[12]..defendInfo[3]
                    elseif defendInfo[1] == _ED.user_info.user_name then
                        local datas = dms.string(dms["message_share"], 50 + (1 - result_type), message_share.content)
                        local data1 =  string.gsub(datas, "!x@", attackInfo[1].." "..friends_tip_string[12]..attackInfo[3])
                        self.title_info = data1
                        self.shareId = 50 + (1 - result_type)
                        -- self.paramsInfo = attackInfo[1].." "..friends_tip_string[12]..attackInfo[3]
                        self.paramsInfo = "0-0,"..attackInfo[1].." "..friends_tip_string[12]..attackInfo[3]
                    end
                end
            end
			
			_richText1:setContentSize(cc.size(Text_battle_infor:getContentSize().width,Text_battle_infor:getContentSize().height))
			_richText1:setAnchorPoint(0,0.5)
			_richText1:setPosition(cc.p(-Text_battle_infor:getContentSize().width/2,Text_battle_infor:getContentSize().height/2))
			Text_battle_infor:addChild(_richText1)		

            local title = ""
            if self._report_type == 11 then
                title = dms.string(dms["message_share"], 53, message_share.title)
                -- self.shareId = 53
                -- self.paramsInfo = ""
            elseif self._report_type == 24 or self._report_type == 10001 then
                title = dms.string(dms["message_share"], 48, message_share.title)
                -- self.shareId = 48
                -- self.paramsInfo = ""
            else
                title = dms.string(dms["message_share"], 37, message_share.title)
                -- self.shareId = 37
                -- self.paramsInfo = ""
            end
            if tonumber(title) ~= nil and tonumber(title) < 0 then
            title = ""
            else
                title = title.."\r\n"
            end
            self.title_info = title..self.title_info
            self.title_info = zstring.exchangeTo(self.title_info)
		else
			if tonumber(self._mail_data.result) == 1 then
				Text_battle_result:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
				Text_battle_result:setString(arena_tip_text[4]) --胜利
				image_name = "images/ui/share/world_implement_icon_7.png"
                if self._report_type == 10003 or self._report_type == 10004 or self._report_type == 207 or self._report_type == 209 or self._report_type == 10006 then
                    Text_battle_result:setString(arena_tip_text[29])
                end
                result_type = 0
			else
				Text_battle_result:setColor(cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2]))
				Text_battle_result:setString(arena_tip_text[5]) --失败
				image_name = "images/ui/share/world_implement_icon_12.png"
                if self._report_type == 10003 or self._report_type == 10004 or self._report_type == 207 or self._report_type == 209 or self._report_type == 10006 then
                    Text_battle_result:setString(arena_tip_text[28])
                end
                result_type = 1
			end
			Panel_battle_state_icon:setBackGroundImage(image_name)
			--守
			local _richText1 = ccui.RichText:create()
			_richText1:ignoreContentAdaptWithSize(false)
			local color1 = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
			local color2 = cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2])
			local re1 = nil
			local re2 = nil
			if tonumber(self._report_type) == 11 then
				re1 =ccui.RichElementText:create(1, color1,255, arena_tip_text[7], config_res.font.font_name,22)
				re2 =ccui.RichElementText:create(1, color2,255, self._mail_data.userName.." "..friends_tip_string[12]..self._mail_data.userLevel, config_res.font.font_name,22)
				_richText1:pushBackElement(re2)
				_richText1:pushBackElement(re1)

                local datas = dms.string(dms["message_share"], 55 + result_type, message_share.content)
                local data1 =  string.gsub(datas, "!x@", self._mail_data.userName.." "..friends_tip_string[12]..self._mail_data.userLevel)
                self.title_info = data1
                self.shareId = 55 + result_type
                -- self.paramsInfo = self._mail_data.userName.." "..friends_tip_string[12]..self._mail_data.userLevel
                self.paramsInfo = "0-0,"..self._mail_data.userName.." "..friends_tip_string[12]..self._mail_data.userLevel
			elseif self._report_type == 10003 or self._report_type == 10004 or self._report_type == 207 or self._report_type == 209 or self._report_type == 10006 then
                local attackInfo = zstring.split(attachedInfo[2], ",")
                local defendInfo = zstring.split(attachedInfo[3], ",")
                
                re1 =ccui.RichElementText:create(1, color2,255, attackInfo[1].." "..friends_tip_string[12]..attackInfo[3], config_res.font.font_name,22)
                re2 =ccui.RichElementText:create(1, color1,255, arena_tip_text[27], config_res.font.font_name,22)
                re3 =ccui.RichElementText:create(1, color2,255, defendInfo[1].." "..friends_tip_string[12]..defendInfo[3], config_res.font.font_name,22)
                _richText1:pushBackElement(re1)
                _richText1:pushBackElement(re2)
                _richText1:pushBackElement(re3)

                local datas = ""
                if result_type == 0 then
                    datas = dms.string(dms["message_share"], 62, message_share.content)
                    self.shareId = 62
                else
                    datas = dms.string(dms["message_share"], 61, message_share.content)
                    self.shareId = 61
                end
                local data1 =  string.gsub(datas, "!x@", attackInfo[1].." "..friends_tip_string[12]..attackInfo[3])
                local data2 =  string.gsub(data1, "!y@", defendInfo[1].." "..friends_tip_string[12]..defendInfo[3])
                self.title_info = data2
                -- self.paramsInfo = attackInfo[1].." "..friends_tip_string[12]..attackInfo[3]..","..defendInfo[1].." "..friends_tip_string[12]..defendInfo[3]
                self.paramsInfo = "0-0,"..attackInfo[1].." "..friends_tip_string[12]..attackInfo[3]..","..defendInfo[1].." "..friends_tip_string[12]..defendInfo[3]
            else
				local attackInfo = zstring.split(attachedInfo[2], ",")
				local defendInfo = zstring.split(attachedInfo[3], ",")
				re1 =ccui.RichElementText:create(1, color2,255, attackInfo[1].." "..friends_tip_string[12]..attackInfo[3], config_res.font.font_name,22)
				re2 =ccui.RichElementText:create(1, color1,255, arena_tip_text[11], config_res.font.font_name,22)
				re3 =ccui.RichElementText:create(1, color2,255, defendInfo[1].." "..friends_tip_string[12]..defendInfo[3], config_res.font.font_name,22)
				
				_richText1:pushBackElement(re1)
                _richText1:pushBackElement(re2)
                _richText1:pushBackElement(re3)

                if self._report_type == 10001 or tonumber(self._report_type) == 24 then
                    if attackInfo[1] == _ED.user_info.user_name then
                        local datas = dms.string(dms["message_share"], 48 + (1 - result_type), message_share.content)
                        local data1 =  string.gsub(datas, "!x@", defendInfo[1].." "..friends_tip_string[12]..defendInfo[3])
                        self.title_info = data1
                        self.shareId = 48 + (1 - result_type)
                        -- self.paramsInfo = defendInfo[1].." "..friends_tip_string[12]..defendInfo[3]
                        self.paramsInfo = "0-0,"..defendInfo[1].." "..friends_tip_string[12]..defendInfo[3]
                    elseif defendInfo[1] == _ED.user_info.user_name then
                        local datas = dms.string(dms["message_share"], 50 + result_type, message_share.content)
                        local data1 =  string.gsub(datas, "!x@", attackInfo[1].." "..friends_tip_string[12]..attackInfo[3])
                        self.title_info = data1
                        self.shareId = 50 + (1 - result_type)
                        -- self.paramsInfo = attackInfo[1].." "..friends_tip_string[12]..attackInfo[3]
                        self.paramsInfo = "0-0,"..attackInfo[1].." "..friends_tip_string[12]..attackInfo[3]
                    end
                end
			end
			
			_richText1:setContentSize(cc.size(Text_battle_infor:getContentSize().width,Text_battle_infor:getContentSize().height))
			_richText1:setAnchorPoint(0,0.5)
			_richText1:setPosition(cc.p(-Text_battle_infor:getContentSize().width/2,Text_battle_infor:getContentSize().height/2))
			Text_battle_infor:addChild(_richText1)

            local title = ""
            if self._report_type == 11 then
                title = dms.string(dms["message_share"], 53, message_share.title)
                -- self.shareId = 53
                -- self.paramsInfo = ""
            elseif self._report_type == 24 or self._report_type == 10001 then
                title = dms.string(dms["message_share"], 48, message_share.title)
                -- self.shareId = 48
                -- self.paramsInfo = ""
            else
                title = dms.string(dms["message_share"], 37, message_share.title)
                -- self.shareId = 37
                -- self.paramsInfo = ""
            end
            if tonumber(title) ~= nil and tonumber(title) < 0 then
            title = ""
            else
                title = title.."\r\n"
            end
            self.title_info = title..self.title_info
            self.title_info = zstring.exchangeTo(self.title_info)
		end
    elseif self._report_type == 210 
        or self._report_type == 10007
        then
        -- 城市战
        local result = tonumber(self._mail_data.result)
        local attachedInfo = zstring.split(self._mail_data.param, "|")
        local attackInfo = zstring.split(attachedInfo[2], ",")
        local defenceInfo = zstring.split(attachedInfo[3], ",")
        if tonumber(defenceInfo[4]) == tonumber(_ED.union.union_info.union_id) then
            local temp = attackInfo
            attackInfo = defenceInfo
            defenceInfo = temp

            if self._report_type == 10007 then
                if result == 1 then
                    result = 0
                else
                    result = 1
                end
            end
        end

        local other_info = zstring.split(attachedInfo[4], ",")
        local open_state = zstring.tonumber(other_info[3])
        local record_type = zstring.tonumber(other_info[4])

        local world_city_name = dms.string(dms["world_city_mould"], other_info[1], world_city_mould.name)

        local info = ""
        local color_index = 0
        local state_info = ""
        if record_type == 0 then
            -- 战斗报告
            local result_type = 0
            local defence_type = 0

            if result == 1 then        -- 胜利
                result_type = 1
                state_info = world_city_tip_str[35]
                color_index = 2
                if open_state > 0 and tonumber(other_info[2]) == 0 then
                    defence_type = 1
                    state_info = world_city_tip_str[37]
                end
            else
                result_type = 2
                state_info = world_city_tip_str[36]
                color_index = 6
                if open_state > 0 and tonumber(other_info[2]) == 0 then
                    defence_type = 2
                    state_info = world_city_tip_str[38]
                end
            end

        	if tonumber(self._report_type) == 10007 then         -- 军团战报
                result_type = result_type + 2
            end

            info = string.gsub(world_city_tip_str[result_type + 38], "!x@", attackInfo[1])
            info = string.gsub(info, "!y@", defenceInfo[1])
            info = string.gsub(info, "!z@", defenceInfo[2])

            if defence_type > 0 then
                info = info..","..world_city_tip_str[defence_type + 42]
                info = string.gsub(info, "!x@", world_city_name)
                info = string.gsub(info, "!y@", defenceInfo[2])
            end
        else
            local attackInfo = zstring.split(attachedInfo[2], ",")
            if tonumber(attackInfo[4]) == tonumber(_ED.union.union_info.union_id) then         -- 掠夺资源
                info = string.gsub(world_city_tip_str[45], "!x@", attackInfo[1])
                info = string.gsub(info, "!y@", world_city_name)
                state_info = world_city_tip_str[35]
                color_index = 2
            else                        -- 被掠夺资源
                info = string.gsub(world_city_tip_str[46], "!x@", world_city_name)
                info = string.gsub(info, "!y@", attackInfo[1])
                info = string.gsub(info, "!z@", attackInfo[2])
                state_info = world_city_tip_str[36]
                color_index = 6
            end
        end
        Text_battle_result:setString(state_info)
        Text_battle_result:setColor(cc.c3b(color_Type[color_index][1], color_Type[color_index][2], color_Type[color_index][3]))

        local font_size = Text_battle_infor:getFontSize()
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)
        local rt, count, text = draw.richTextCollectionMethod(_richText, 
            info, 
            cc.c3b(255, 255, 255),
            cc.c3b(255, 255, 255),
            0, 
            0, 
            config_res.font.font_name, 
            20,
            chat_rich_text_color)   
        _richText:setPosition(cc.p(Text_battle_infor:getContentSize().width/2,Text_battle_infor:getContentSize().height/2))
        _richText:setContentSize(cc.size(Text_battle_infor:getContentSize().width, Text_battle_infor:getContentSize().height))
        Text_battle_infor:addChild(_richText)

        local image_name =""
        if tonumber(attachedInfo[1]) == 0 then 
            --攻
            if tonumber(self._mail_data.result) == 1 then
                self.shareId = 80
                self.paramsInfo = "106-2-"..other_info[1]..","..defenceInfo[1]..","..other_info[1]
                image_name = "images/ui/share/world_implement_icon_1.png"
            else
                self.shareId = 81
                self.paramsInfo = "106-2-"..other_info[1]..","..defenceInfo[1]..","..other_info[1]
                image_name = "images/ui/share/world_implement_icon_5.png"
            end 
        else
            if tonumber(self._mail_data.result) == 1 then
                self.shareId = 82
                self.paramsInfo = "106-1-"..other_info[1]..","..other_info[1]..","..defenceInfo[1]
                image_name = "images/ui/share/world_implement_icon_7.png"
            else
                self.shareId = 83
                self.paramsInfo = "106-1-"..other_info[1]..","..other_info[1]..","..defenceInfo[1]
                image_name = "images/ui/share/world_implement_icon_12.png"
            end
        end
        Panel_battle_state_icon:setBackGroundImage(image_name)
	elseif self._report_type == 201 then
		Panel_battle_state_icon:removeAllChildren(true)
		local attachedInfo = zstring.split(self._mail_data.param, "|")
		local _richText1 = ccui.RichText:create()
		_richText1:ignoreContentAdaptWithSize(false)
		local color1 = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
		local color2 = cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2])
		local attackInfo = zstring.split(attachedInfo[2], ",")
		local defendInfo = zstring.split(attachedInfo[3], ",")

		re1 =ccui.RichElementText:create(1, color1,255, string.format(mail_tip_text[24],(attachedInfo[4]+1)), config_res.font.font_name,20)
		re2 =ccui.RichElementText:create(1, color2,255, defendInfo[1].." "..friends_tip_string[12]..defendInfo[3], config_res.font.font_name,20)
		_richText1:pushBackElement(re1)
		_richText1:pushBackElement(re2)
		_richText1:setContentSize(cc.size(Text_battle_infor:getContentSize().width,Text_battle_infor:getContentSize().height))
		_richText1:setAnchorPoint(0,0.5)
		_richText1:setPosition(cc.p(-Text_battle_infor:getContentSize().width/2,Text_battle_infor:getContentSize().height/2))
		Text_battle_infor:addChild(_richText1)
        local image_name =""
        local is_victory = false
        if tonumber(attachedInfo[1]) == 0 then 
            --攻
            if tonumber(self._mail_data.result) == 1 then
                Text_battle_result:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
                Text_battle_result:setString(arena_tip_text[2]) --胜利
                image_name = "images/ui/share/world_implement_icon_1.png"
                is_victory = true
            else
                Text_battle_result:setColor(cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2]))
                Text_battle_result:setString(arena_tip_text[3]) --失败
                image_name = "images/ui/share/world_implement_icon_5.png"
                is_victory = false
            end 
        else
            if tonumber(self._mail_data.result) == 1 then
                Text_battle_result:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
                Text_battle_result:setString(arena_tip_text[4]) --胜利
                image_name = "images/ui/share/world_implement_icon_7.png"
                is_victory = true
            else
                Text_battle_result:setColor(cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2]))
                Text_battle_result:setString(arena_tip_text[5]) --失败
                image_name = "images/ui/share/world_implement_icon_12.png"
                is_victory = false
            end
        end
        Panel_battle_state_icon:setBackGroundImage(image_name)

        -- 分享信息
        local datas = ""
        local title = ""
        if is_victory == true then
            datas = dms.string(dms["message_share"], 57, message_share.content)
            title = dms.string(dms["message_share"], 57, message_share.title)
            self.shareId = 57
        else
            datas = dms.string(dms["message_share"], 58, message_share.content)
            title = dms.string(dms["message_share"], 58, message_share.title)
            self.shareId = 58
        end
        if tonumber(title) ~= nil and tonumber(title) < 0 then
            title = ""
        else
            title = title.."\r\n"
        end
        local data1 =  string.gsub(datas, "!x@", defendInfo[1].." "..friends_tip_string[12]..defendInfo[3])
        datas = data1
        self.title_info = title..datas
        self.title_info = zstring.exchangeTo(self.title_info)
        -- self.paramsInfo = defendInfo[1].." "..friends_tip_string[12]..defendInfo[3]
        self.paramsInfo = "0-0,"..defendInfo[1].." "..friends_tip_string[12]..defendInfo[3]
	elseif self._report_type == 202 then
		Panel_battle_state_icon:removeAllChildren(true)
		local attachedInfo = zstring.split(self._mail_data.param, "|")
		local battle_infor = mail_tip_text[19]..string.format(mail_tip_text[20],attachedInfo[4])
		Text_battle_infor:setString(battle_infor)
		local image_name =""
        local is_victory = false
		if tonumber(attachedInfo[1]) == 0 then 
			--攻
			if tonumber(self._mail_data.result) == 1 then
				Text_battle_result:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
				Text_battle_result:setString(arena_tip_text[2]) --胜利
				image_name = "images/ui/share/world_implement_icon_1.png"
                is_victory = true
			else
				Text_battle_result:setColor(cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2]))
				Text_battle_result:setString(arena_tip_text[3]) --失败
				image_name = "images/ui/share/world_implement_icon_5.png"
                is_victory = false
			end	
		else
			if tonumber(self._mail_data.result) == 1 then
				Text_battle_result:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
				Text_battle_result:setString(arena_tip_text[4]) --胜利
				image_name = "images/ui/share/world_implement_icon_7.png"
                is_victory = true
			else
				Text_battle_result:setColor(cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2]))
				Text_battle_result:setString(arena_tip_text[5]) --失败
				image_name = "images/ui/share/world_implement_icon_12.png"
                is_victory = false
			end
		end
		Panel_battle_state_icon:setBackGroundImage(image_name)

        -- 分享信息
        local datas = ""
        local title = ""
        if is_victory == true then
            datas = dms.string(dms["message_share"], 77, message_share.content)
            title = dms.string(dms["message_share"], 77, message_share.title)
            self.shareId = 77
        else
            datas = dms.string(dms["message_share"], 78, message_share.content)
            title = dms.string(dms["message_share"], 78, message_share.title)
            self.shareId = 78
        end
        if tonumber(title) ~= nil and tonumber(title) < 0 then
            title = ""
        else
            title = title.."\r\n"
        end
        local data1 =  string.gsub(datas, "!x@", string.format(mail_tip_text[20],attachedInfo[4]))
        datas = data1
        self.title_info = title..datas
        self.title_info = zstring.exchangeTo(self.title_info)
        -- self.paramsInfo = string.format(mail_tip_text[20],attachedInfo[4])
        self.paramsInfo = "100-1-"..attachedInfo[4]..","..string.format(mail_tip_text[20],attachedInfo[4])
	elseif self._report_type == 203 
		or (tonumber(self._mail_data.nType) == 200 and self._mail_data.mail_params.Defensive_side~= nil and tonumber(self._mail_data.mail_params.Defensive_side.attack_type) == 5)
        then
		Panel_battle_state_icon:removeAllChildren(true)
		local attachedInfo = zstring.split(self._mail_data.param, "|")
		local _richText1 = ccui.RichText:create()
        _richText1:ignoreContentAdaptWithSize(false)
        local color1 = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
        local color2 = cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2])
        local attackInfo = zstring.split(attachedInfo[2], ",")
        local defendInfo = zstring.split(attachedInfo[3], ",")

        re1 =ccui.RichElementText:create(1, color1,255, mail_tip_text[8], config_res.font.font_name,20)
        re2 =ccui.RichElementText:create(1, color2,255, defendInfo[1].." "..friends_tip_string[12]..defendInfo[3]..string.format(mail_tip_text[10], defendInfo[5], defendInfo[6]), config_res.font.font_name,20)
        re3 =ccui.RichElementText:create(1, color1,255, tipStringInfo_consumption_info[2], config_res.font.font_name,20)
        self._enemy_coord = {defendInfo[5], defendInfo[6]}
        _richText1:pushBackElement(re1)
        _richText1:pushBackElement(re2)
        _richText1:pushBackElement(re3)
        _richText1:setContentSize(cc.size(Text_battle_infor:getContentSize().width,Text_battle_infor:getContentSize().height))
        _richText1:setAnchorPoint(0,0.5)
        _richText1:setPosition(cc.p(-Text_battle_infor:getContentSize().width/2,Text_battle_infor:getContentSize().height/2))
        Text_battle_infor:addChild(_richText1)
        local image_name =""
        if tonumber(attachedInfo[1]) == 0 then 
            --攻
            if tonumber(self._mail_data.result) == 1 then
                Text_battle_result:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
                Text_battle_result:setString(arena_tip_text[2]) --胜利
                image_name = "images/ui/share/world_implement_icon_1.png"
            else
                Text_battle_result:setColor(cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2]))
                Text_battle_result:setString(arena_tip_text[3]) --失败
                image_name = "images/ui/share/world_implement_icon_5.png"
            end 
        else
            if tonumber(self._mail_data.result) == 1 then
                Text_battle_result:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
                Text_battle_result:setString(arena_tip_text[4]) --胜利
                image_name = "images/ui/share/world_implement_icon_7.png"
            else
                Text_battle_result:setColor(cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2]))
                Text_battle_result:setString(arena_tip_text[5]) --失败
                image_name = "images/ui/share/world_implement_icon_12.png"
            end
        end
        Panel_battle_state_icon:setBackGroundImage(image_name)

        -- 分享信息
        local datas = dms.string(dms["message_share"], 37 + result_type, message_share.content)
        local title = dms.string(dms["message_share"], 37 + result_type, message_share.title)
        if tonumber(title) ~= nil and tonumber(title) < 0 then
            title = ""
        else
            title = title.."\r\n"
        end
        local data1 =  string.gsub(datas, "!x@", defendInfo[1])
        datas = data1
        self.title_info = title..datas
        self.title_info = zstring.exchangeTo(self.title_info)
        self.shareId = 37 + result_type
        -- self.paramsInfo = defendInfo[1]
        self.paramsInfo = "0-0,"..defendInfo[1]
	else		
		local image_name =""
		local _richText1 = ccui.RichText:create()
		_richText1:ignoreContentAdaptWithSize(false)
		local color1 = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
		local color2 = cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2])
		local colorInfo = cc.c3b(color_Type[tonumber(self._mail_data.mail_params.Attack_side.quality)+1][1], color_Type[tonumber(self._mail_data.mail_params.Attack_side.quality)+1][2], color_Type[tonumber(self._mail_data.mail_params.Attack_side.quality)+1][3])
		if tonumber(self._mail_data.mail_params.Attack_side.quality) == 0 then
			colorInfo = color2
		end
		local re1 = nil
		local re2 = nil
		local re3 = nil
		local re4 = nil
		local re5 = nil

        local message_type = 0          -- 分享信息id
        local message_info1 = ""
        local message_info2 = ""
        local frist_message = "0-0,"
		if tonumber(self._mail_data.mail_params.mail_type) == 0 then   --//攻
			if tonumber(self._mail_data.result) == 1 then
				Text_battle_result:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
				Text_battle_result:setString(mail_tip_text[1]) --胜利
				image_name = "images/ui/share/world_implement_icon_1.png"
				if tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 0 then		--打矿
					Text_battle_grrison_state:setString(tipStringInfo_consumption_info[9])
                    message_type = 39
				elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 1 then		--打有人的矿
					Text_battle_grrison_state:setString(tipStringInfo_consumption_info[8])
                    message_type = 41
				elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 2 then		--打基地
                    message_type = 37
                elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 6 then      --打城市
                    message_type = 80
				end
			else
				Text_battle_result:setColor(cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2]))
				Text_battle_result:setString(mail_tip_text[2]) --失败
				image_name = "images/ui/share/world_implement_icon_5.png"

                if tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 0 then      --打矿
                    Text_battle_grrison_state:setString(tipStringInfo_consumption_info[9])
                    message_type = 40
                elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 1 then      --打有人的矿
                    Text_battle_grrison_state:setString(tipStringInfo_consumption_info[8])
                    message_type = 42
                elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 2 then      --打基地
                    message_type = 38
                elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 6 then      --打城市
                    message_type = 81
                end
			end

            if self._report_type == 200 
                and _ED.report_reward_info[4] ~= nil 
                and tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 2
                then 
                local forceData = zstring.split(_ED.report_reward_info[4], "|")
                local battle_grrison_index = 9
                for i=1,table.nums(forceData) do
                    local forceInfo = zstring.split(forceData[i], ",")
                    if tonumber(forceInfo[5]) > 0 then
                        battle_grrison_index = 8
                        break
                    end
                end
                Text_battle_grrison_state:setString(tipStringInfo_consumption_info[battle_grrison_index])
            end


            if tonumber(self._mail_data.mail_params.rewardType) == 5 then
                local npc_mould_id = dms.string(dms["rebel_haunt_mould"], self._mail_data.mail_params.Attack_side.mine_mould_id, rebel_haunt_mould.npc_mould_id) 
                local npcName = dms.string(dms["npc"], npc_mould_id, npc.npc_name) 

                Text_battle_result:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
                Text_battle_result:setString(mail_tip_text[33])
                image_name = "images/ui/share/world_implement_icon_1.png"
                local element = dms.element(dms["world_mine_mould"], tonumber(self._mail_data.mail_params.Attack_side.mine_mould_id))
                local textinfo = zstring.split(mail_tip_text[34], "!x@")
                re1 = ccui.RichElementText:create(1, color1,255, textinfo[1], config_res.font.font_name,20)
                re3 = ccui.RichElementText:create(1, color1,255, textinfo[2], config_res.font.font_name,20)
                re2 = ccui.RichElementText:create(1, colorInfo,255, npcName.." "..friends_tip_string[12].._ED.world_level..string.format(mail_tip_text[10], self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y), config_res.font.font_name,20)
                -- self.title_info = textinfo[1]..textinfo[2]..npcName.." "..friends_tip_string[12].._ED.world_level.."%|0|"..Text_battle_result:getString().."%"
                self._enemy_coord = {self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y}
                message_info1 = npcName.."&nbsp;"..friends_tip_string[12].._ED.world_level
                frist_message = "101-1-"..npc_mould_id.."-".._ED.world_level..","
            else
                if tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 4 then
                    Text_battle_result:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
                    Text_battle_result:setString(mail_tip_text[7]) --采集报告
                    image_name = "images/ui/share/world_implement_icon_1.png"
                    local element = dms.element(dms["world_mine_mould"], tonumber(self._mail_data.mail_params.Attack_side.mine_mould_id))
                    local textinfo = zstring.split(mail_tip_text[9], "!x@")
                    re1 = ccui.RichElementText:create(1, color1,255, textinfo[1], config_res.font.font_name,20)
                    re3 = ccui.RichElementText:create(1, color1,255, textinfo[2], config_res.font.font_name,20)
                    re2 = ccui.RichElementText:create(1, colorInfo,255, dms.atos(element, world_mine_mould.name).." "..friends_tip_string[12]..dms.atos(element, world_mine_mould.level)..string.format(mail_tip_text[10], self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y), config_res.font.font_name,20)
                    -- self.title_info = textinfo[1]..dms.atos(element, world_mine_mould.name).." "..friends_tip_string[12]..dms.atos(element, world_mine_mould.level)..textinfo[2].."%|0|"..Text_battle_result:getString().."%"
                    self._enemy_coord = {self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y}
                    message_info1 = dms.atos(element, world_mine_mould.name).."&nbsp;"..friends_tip_string[12]..dms.atos(element, world_mine_mould.level)
                    frist_message = "102-1-"..tonumber(self._mail_data.mail_params.Attack_side.mine_mould_id)..","
                else
                    re1 = ccui.RichElementText:create(1, color1,255, mail_tip_text[8], config_res.font.font_name,20)
                    if tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 0 then      --打矿
                        local element = dms.element(dms["world_mine_mould"], tonumber(self._mail_data.mail_params.Attack_side.mine_mould_id))
                        re2 = ccui.RichElementText:create(1, colorInfo,255, dms.atos(element, world_mine_mould.name).." "..friends_tip_string[12]..dms.atos(element, world_mine_mould.level)..string.format(mail_tip_text[10], self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y), config_res.font.font_name,20)       
                        -- self.title_info = mail_tip_text[8]..dms.atos(element, world_mine_mould.name).." "..friends_tip_string[12]..dms.atos(element, world_mine_mould.level)..Text_battle_result:getString()
                        self._enemy_coord = {self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y}
                        message_info1 = dms.atos(element, world_mine_mould.name).."&nbsp;"..friends_tip_string[12]..dms.atos(element, world_mine_mould.level)
                        frist_message = "103-1-"..tonumber(self._mail_data.mail_params.Attack_side.mine_mould_id)..","
                    elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 1 then      --打有人的矿
                        local element = dms.element(dms["world_mine_mould"], tonumber(self._mail_data.mail_params.Defensive_side.mine_mould_id))
                        re2 = ccui.RichElementText:create(1, color2,255, self._mail_data.mail_params.Defensive_side.name.." "..friends_tip_string[12]..self._mail_data.mail_params.Defensive_side.level, config_res.font.font_name,20)
                        re3 = ccui.RichElementText:create(1, color1,255, tipStringInfo_campaign_info[33], config_res.font.font_name,20)
                        re4 = ccui.RichElementText:create(1, colorInfo,255, dms.atos(element, world_mine_mould.name).." "..friends_tip_string[12]..dms.atos(element, world_mine_mould.level)..string.format(mail_tip_text[10], self._mail_data.mail_params.Defensive_side.attack_print_x, self._mail_data.mail_params.Defensive_side.attack_print_y), config_res.font.font_name,20)
                        -- self.title_info = mail_tip_text[8]..self._mail_data.mail_params.Defensive_side.name.." "..friends_tip_string[12]..self._mail_data.mail_params.Defensive_side.level..dms.atos(element, world_mine_mould.name).."%|0|"..Text_battle_result:getString().."%"
                        self._enemy_coord = {self._mail_data.mail_params.Defensive_side.attack_print_x, self._mail_data.mail_params.Defensive_side.attack_print_y}
                        message_info1 = self._mail_data.mail_params.Defensive_side.name.."&nbsp;"..friends_tip_string[12]..self._mail_data.mail_params.Defensive_side.level
                        message_info2 = dms.atos(element, world_mine_mould.name).."&nbsp;"..friends_tip_string[12]..dms.atos(element, world_mine_mould.level)
                        frist_message = "104-2-"..tonumber(self._mail_data.mail_params.Attack_side.mine_mould_id)..","
                    elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 2 then      --打基地
                        local textinfo = zstring.split(mail_tip_text[11], "!x@")
                        -- re2 = ccui.RichElementText:create(1, color1,255, textinfo[1], config_res.font.font_name,20)
                        re3 = ccui.RichElementText:create(1, color2,255, self._mail_data.mail_params.Defensive_side.name.." "..friends_tip_string[12]..self._mail_data.mail_params.Defensive_side.level..string.format(mail_tip_text[10], self._mail_data.mail_params.Defensive_side.attack_print_x, self._mail_data.mail_params.Defensive_side.attack_print_y), config_res.font.font_name,20)
                        re4 = ccui.RichElementText:create(1, color1,255, textinfo[2], config_res.font.font_name,20)
                        -- self.title_info = mail_tip_text[8]..self._mail_data.mail_params.Defensive_side.name.." "..friends_tip_string[12]..self._mail_data.mail_params.Defensive_side.level..textinfo[2].."%|0|"..Text_battle_result:getString().."%"
                        self._enemy_coord = {self._mail_data.mail_params.Defensive_side.attack_print_x, self._mail_data.mail_params.Defensive_side.attack_print_y}
                        message_info1 = self._mail_data.mail_params.Defensive_side.name.."&nbsp;"..friends_tip_string[12]..self._mail_data.mail_params.Defensive_side.level
                        frist_message = "0-0,"

                        local attachedInfo = zstring.split(self._mail_data.param, "|")
                        local name_info = zstring.split(attachedInfo[4], ",")
                        if name_info[1] ~= nil and name_info[1] ~= "" then
                            Text_battle_grrison_state:setString(tipStringInfo_consumption_info[27])
                        end
                    elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 6 
                        or tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 7
                        then  
                        --城市战
                        local world_city_name = dms.string(dms["world_city_mould"], self._mail_data.mail_params.Attack_side.mine_mould_id, world_city_mould.name)
                        local level = dms.int(dms["world_city_mould"], self._mail_data.mail_params.Attack_side.mine_mould_id, world_city_mould.level)
                        local pos = zstring.split(dms.string(dms["world_city_mould"], self._mail_data.mail_params.Attack_side.mine_mould_id, world_city_mould.position), ",")
                        re2 = ccui.RichElementText:create(1, color2,255, world_city_name.." "..friends_tip_string[12]..level..string.format(mail_tip_text[10], pos[1], pos[2]), config_res.font.font_name,20)

                        local defence_name = ""..self._mail_data.mail_params.Defensive_side.name.."&nbsp;"..friends_tip_string[12]..self._mail_data.mail_params.Defensive_side.level
                        local npc_mould_id = 0
                        if self._mail_data.npc_moud_id ~= nil and self._mail_data.npc_moud_id > 0 then
                            npc_mould_id = self._mail_data.npc_moud_id
                            defence_name = defence_name.."_"..npc_mould_id.."_"..self._mail_data.mail_params.Defensive_side.level
                        end
                        frist_message = "106-2-"..self._mail_data.mail_params.Attack_side.mine_mould_id..","..defence_name..","..self._mail_data.mail_params.Attack_side.mine_mould_id
                        self._enemy_coord = {self._mail_data.mail_params.Defensive_side.attack_print_x, self._mail_data.mail_params.Defensive_side.attack_print_y}
                        local city_type = dms.int(dms["world_city_mould"], self._mail_data.mail_params.Attack_side.mine_mould_id, world_city_mould.city_type)
                        if city_type == 3002 then
                            message_type = message_type + 4
                        end
                    end
                end
            end
        elseif tonumber(self._mail_data.mail_params.mail_type) == 1 then    --//防守
            if tonumber(self._mail_data.result) == 1 then
                Text_battle_result:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
                Text_battle_result:setString(mail_tip_text[3]) --胜利
                image_name = "images/ui/share/world_implement_icon_6.png"

                if tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 1 then      --矿被攻击
                    message_type = 45
                elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 2 then      --基地被攻击
                    message_type = 43
                elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 6 then      --打城市
                    message_type = 82
                end
            else
                Text_battle_result:setColor(cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2]))
                Text_battle_result:setString(mail_tip_text[4]) --失败
                image_name = "images/ui/share/world_implement_icon_12.png"
                if tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 1 then      --矿被攻击
                    message_type = 46
                elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 2 then      --基地被攻击
                    message_type = 44
                elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 6 then      --打城市
                    message_type = 83
                end
            end
            if self._report_type == 1200 
                and _ED.report_reward_info[4] ~= nil 
                then 
                local forceData = zstring.split(_ED.report_reward_info[4], "|")
                local battle_grrison_index = 9
                for i=1,table.nums(forceData) do
                    local forceInfo = zstring.split(forceData[i], ",")
                    if tonumber(forceInfo[5]) > 0 then
                        battle_grrison_index = 8
                        break
                    end
                end
                Text_battle_grrison_state:setString(tipStringInfo_consumption_info[battle_grrison_index])
            end
            local textinfo = zstring.split(mail_tip_text[12], "!x@")
            if tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 1 then
    			local element = dms.element(dms["world_mine_mould"], tonumber(self._mail_data.mail_params.Attack_side.mine_mould_id))
    			re1 = ccui.RichElementText:create(1, color1,255, textinfo[1], config_res.font.font_name,22)
                re2 = ccui.RichElementText:create(1, colorInfo,255, dms.atos(element, world_mine_mould.name).." "..friends_tip_string[12]..dms.atos(element, world_mine_mould.level), config_res.font.font_name,22)
    			re3 = ccui.RichElementText:create(1, color1,255, textinfo[3], config_res.font.font_name,22)
    			re4 = ccui.RichElementText:create(1, color2,255, self._mail_data.mail_params.Attack_side.name.." "..friends_tip_string[12]..self._mail_data.mail_params.Attack_side.level..string.format(mail_tip_text[10], self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y), config_res.font.font_name,22)
    			re5 = ccui.RichElementText:create(1, color1,255, textinfo[4], config_res.font.font_name,22)
    			-- self.title_info = dms.atos(element, world_mine_mould.name).." "..friends_tip_string[12]..dms.atos(element, world_mine_mould.level)..textinfo[3]..self._mail_data.mail_params.Attack_side.name.." "..friends_tip_string[12]..self._mail_data.mail_params.Attack_side.level..textinfo[4].."%|0|"..Text_battle_result:getString().."%"
    		    self._enemy_coord = {self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y}
                message_info1 = dms.atos(element, world_mine_mould.name).."&nbsp;"..friends_tip_string[12]..dms.atos(element, world_mine_mould.level)
                message_info2 = self._mail_data.mail_params.Attack_side.name.."&nbsp;"..friends_tip_string[12]..self._mail_data.mail_params.Attack_side.level
                frist_message = "105-1-"..tonumber(self._mail_data.mail_params.Attack_side.mine_mould_id)..","
            elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 2 then
                local attachedInfo = zstring.split(self._mail_data.param, "|")
                local name_info = zstring.split(attachedInfo[4], ",")
                if zstring.tonumber(name_info[3]) == tonumber(_ED.user_info.user_id) then
                    if tonumber(self._mail_data.result) == 1 then
                        Text_battle_result:setString(mail_tip_text[62]) --胜利
                    else
                        Text_battle_result:setString(mail_tip_text[63]) --失败
                    end
                    re1 = ccui.RichElementText:create(1, color2,255, self._mail_data.mail_params.Defensive_side.name.." "..friends_tip_string[12]..self._mail_data.mail_params.Defensive_side.level, config_res.font.font_name,22)
                    re2 = ccui.RichElementText:create(1, color2,255, textinfo[2], config_res.font.font_name,22)
                    re3 = ccui.RichElementText:create(1, color1,255, textinfo[3], config_res.font.font_name,22)
                    re4 = ccui.RichElementText:create(1, color2,255, self._mail_data.mail_params.Attack_side.name.." "..friends_tip_string[12]..self._mail_data.mail_params.Attack_side.level, config_res.font.font_name,22)
                    re5 = ccui.RichElementText:create(1, color1,255, textinfo[4], config_res.font.font_name,22)
                else
                    if name_info[1] ~= "" then
                        Text_battle_grrison_state:setString(tipStringInfo_consumption_info[27])
                    end
                    re1 = ccui.RichElementText:create(1, color1,255, textinfo[1], config_res.font.font_name,22)
                    re2 = ccui.RichElementText:create(1, color2,255, textinfo[2], config_res.font.font_name,22)
                    re3 = ccui.RichElementText:create(1, color1,255, textinfo[3], config_res.font.font_name,22)
                    re4 = ccui.RichElementText:create(1, color2,255, self._mail_data.mail_params.Attack_side.name.." "..friends_tip_string[12]..self._mail_data.mail_params.Attack_side.level..string.format(mail_tip_text[10], self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y), config_res.font.font_name,22)
                    re5 = ccui.RichElementText:create(1, color1,255, textinfo[4], config_res.font.font_name,22)
                    self._enemy_coord = {self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y}
                end
    			message_info1 = self._mail_data.mail_params.Attack_side.name.."&nbsp;"..friends_tip_string[12]..self._mail_data.mail_params.Attack_side.level
                frist_message = "0-0,"
            elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 6 then
                local world_city_name = dms.string(dms["world_city_mould"], self._mail_data.mail_params.Attack_side.mine_mould_id, world_city_mould.name)
                local level = dms.int(dms["world_city_mould"], self._mail_data.mail_params.Attack_side.mine_mould_id, world_city_mould.level)
                local pos = zstring.split(dms.string(dms["world_city_mould"], self._mail_data.mail_params.Attack_side.mine_mould_id, world_city_mould.position), ",")
                re1 = ccui.RichElementText:create(1, color2,255, world_city_name.." "..friends_tip_string[12]..level..string.format(mail_tip_text[10], pos[1], pos[2]), config_res.font.font_name,20)
                re2 = ccui.RichElementText:create(1, color1,255, mail_tip_text[74], config_res.font.font_name,20)
                re3 = ccui.RichElementText:create(1, color2,255, self._mail_data.mail_params.Attack_side.name.." "..friends_tip_string[12]..self._mail_data.mail_params.Attack_side.level..string.format(mail_tip_text[10], self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y), config_res.font.font_name,20)
                re4 = ccui.RichElementText:create(1, color1,255, formation_type_string[13], config_res.font.font_name,20)
                -- 分享
                local attack_name = self._mail_data.mail_params.Attack_side.name.."&nbsp;"..friends_tip_string[12]..self._mail_data.mail_params.Attack_side.level
                frist_message = "106-1-"..self._mail_data.mail_params.Attack_side.mine_mould_id..","..self._mail_data.mail_params.Attack_side.mine_mould_id..","..attack_name
                self._enemy_coord = {self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y}
                local city_type = dms.int(dms["world_city_mould"], self._mail_data.mail_params.Attack_side.mine_mould_id, world_city_mould.city_type)
                if city_type == 3002 then
                    message_type = message_type + 4
                end
            end
        elseif tonumber(self._mail_data.mail_params.mail_type) == 3 then    --//协防
            local attachedInfo = zstring.split(self._mail_data.param, "|")
            local attachedOne = zstring.split(attachedInfo[2], ",")
            local attachedTwo = zstring.split(attachedInfo[3], ",")
            local defence_id = zstring.tonumber(attachedInfo[5])
            image_name = string.format(config_res.images.ui.share.world_implement_icon, 1)
            Text_battle_result:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
            if defence_id ~= tonumber(_ED.user_info.user_id) then
                if tonumber(attachedOne[8]) == 0 then
                    Text_battle_result:setString(mail_tip_text[55])
                    re1 = ccui.RichElementText:create(1, color2,255, attachedTwo[1].." "..friends_tip_string[12]..attachedTwo[3]..string.format(mail_tip_text[10], attachedTwo[5],attachedTwo[6]), config_res.font.font_name,20)
                    re2 = ccui.RichElementText:create(1, color1,255, mail_tip_text[59], config_res.font.font_name,20)
                    self._enemy_coord = {attachedTwo[5],attachedTwo[6]}
                else
                    Text_battle_result:setString(mail_tip_text[56])
                    re1 = ccui.RichElementText:create(1, color1,255, mail_tip_text[57], config_res.font.font_name,20)
                    re2 = ccui.RichElementText:create(1, color2,255, attachedOne[1].." "..friends_tip_string[12]..attachedOne[3]..string.format(mail_tip_text[10], attachedOne[5],attachedOne[6]), config_res.font.font_name,20)
                    re3 = ccui.RichElementText:create(1, color1,255, mail_tip_text[58], config_res.font.font_name,20)
                    self._enemy_coord = {attachedOne[5],attachedOne[6]}
                end
            else
                if tonumber(attachedTwo[8]) == 0 then
                    Text_battle_result:setString(mail_tip_text[55])
                    re1 = ccui.RichElementText:create(1, color2,255, attachedTwo[1].." "..friends_tip_string[12]..attachedTwo[3]..string.format(mail_tip_text[10], attachedTwo[5],attachedTwo[6]), config_res.font.font_name,20)
                    re2 = ccui.RichElementText:create(1, color1,255, mail_tip_text[59], config_res.font.font_name,20)
                    self._enemy_coord = {attachedTwo[5],attachedTwo[6]}
                else
                    Text_battle_result:setString(mail_tip_text[56])
                    re1 = ccui.RichElementText:create(1, color1,255, mail_tip_text[57], config_res.font.font_name,20)
                    re2 = ccui.RichElementText:create(1, color2,255, attachedOne[1].." "..friends_tip_string[12]..attachedOne[3]..string.format(mail_tip_text[10], attachedOne[5],attachedOne[6]), config_res.font.font_name,20)
                    re3 = ccui.RichElementText:create(1, color1,255, mail_tip_text[58], config_res.font.font_name,20)
                    self._enemy_coord = {attachedOne[5],attachedOne[6]}
                end
            end
	    end

        -- 分享信息
        if message_type > 0 then
            local title = dms.string(dms["message_share"], message_type, message_share.title)
            local datas = dms.string(dms["message_share"], message_type, message_share.content)
            if tonumber(title) ~= nil and tonumber(title) < 0 then
                title = ""
            else
                title = title.."\r\n"
            end
            if message_info1 ~= nil and message_info1 ~= "" then
                datas =  string.gsub(datas, "!x@", message_info1)
                self.paramsInfo = message_info1
            end
            if message_info2 ~= nil and message_info2 ~= "" then
                datas =  string.gsub(datas, "!y@", message_info2)
                self.paramsInfo = self.paramsInfo..","..message_info2
            end
            self.paramsInfo = frist_message..self.paramsInfo
            self.shareId = message_type
            self.title_info = title..datas
            self.title_info = zstring.exchangeTo(self.title_info)
        end

		Panel_battle_state_icon:setBackGroundImage(image_name)
		if re1~= nil then
			_richText1:pushBackElement(re1)
		end
		if re2~= nil then
			_richText1:pushBackElement(re2)
		end
		if re3~= nil then
			_richText1:pushBackElement(re3)
		end	
		if re4~= nil then
			_richText1:pushBackElement(re4)
		end
		if re5~= nil then
			_richText1:pushBackElement(re5)
		end
		_richText1:setContentSize(cc.size(Text_battle_infor:getContentSize().width,Text_battle_infor:getContentSize().height))
		_richText1:setAnchorPoint(0,0.5)
		_richText1:setPosition(cc.p(-Text_battle_infor:getContentSize().width/2,Text_battle_infor:getContentSize().height/2))
		Text_battle_infor:addChild(_richText1)	
	end
	Text_battle_time:setString(self:getTimeFormatYMDHMS(tonumber(self._mail_data.time)/1000))

    if __lua_project_id == __lua_project_pacific_rim then
        self:updatePacificRimInfo()
    else
        self:udapteRedAlertTimeInfo()
    end
end

function MailPresentationInfo:udapteRedAlertTimeInfo()
    local root = self.roots[1]
    -- 邮件内容
    local ListView_presentation = ccui.Helper:seekWidgetByName(root,"ListView_presentation")
    self._list_view = ListView_presentation

    local attachedInfo = zstring.split(self._mail_data.param, "|")
    local up_index = 0
    local down_index = 1
    if tonumber(attachedInfo[1]) == 1 then
        up_index = 1
        down_index = 0
    else
    end

    if self._report_type == 11 or self._report_type == 10000 --战地争霸类型
        then 
        self:updateGetArenaInfo()       -- 奖励
        self:updateResultInfo()         -- 战斗结果
        self:updateEquipmentInfo()
        self:updateLostInfo(0, up_index)          -- 防守方
        self:updateLostInfo(1, down_index)          -- 进攻方
        self:updateRepaireInfo()        -- 维修信息
    elseif self._report_type == 24 
        or self._report_type == 10001
        or self._report_type == 201
        or self._report_type == 202
        or self._report_type == 203
        then
        self:updateGetExpInfo()
        self:updateResultInfo()         -- 战斗结果
        self:updateEquipmentInfo()
        self:updateLostInfo(0, up_index)          -- 防守方
        self:updateLostInfo(1, down_index)          -- 进攻方
        self:updateRepaireInfo()        -- 维修信息
    elseif self._report_type == 210
        or self._report_type == 10007
        then
        local other_info = zstring.split(attachedInfo[4], ",")
        local record_type = tonumber(other_info[4])
        if record_type == 0 then
            self:updateGetExpInfo()
            self:updateResultInfo()         -- 战斗结果
            self:updateEquipmentInfo()
            self:updateLostInfo(0, up_index)          -- 防守方
            self:updateLostInfo(1, down_index)          -- 进攻方
            self:updateRepaireInfo()        -- 维修信息
        else
            self:updateGetResourceInfo()
        end
    elseif self._report_type == 10003 
        or self._report_type == 10004
        or self._report_type == 207  
        or self._report_type == 209
        or self._report_type == 10006
        then
        self:updateResultInfo()         -- 战斗结果
        self:updateEquipmentInfo()
        self:updateLostInfo(0, up_index)          -- 防守方
        self:updateLostInfo(1, down_index)          -- 进攻方
        self:updateRepaireInfo()        -- 维修信息
    else
        -- local attachedInfo = zstring.split(self._mail_data.param, "|")
        -- local attachedOne = zstring.split(attachedInfo[2], ",")
        rewarld = {}
        if _ED.report_reward_info[1] ~= nil then
            rewarld = zstring.split(_ED.report_reward_info[1], "|")
        end
        if tonumber(self._mail_data.mail_params.mail_type) == 0 then
            if tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 4 then
                if tonumber(self._mail_data.mail_params.rewardType) == 0 then
                    self:updateMainCollectionRewarld()
                else
                    -- self:updateGetResourceInfo()     -- 奖励
                end     
            elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 2 
                or tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 1
                then
                if tonumber(self._mail_data.result) == 1 then
                    self:updateGetResourceInfo()
                else
                    self:updateGetExpInfo()
                end
                self:updateResultInfo()         -- 战斗结果
                self:updateEquipmentInfo()
                self:updateLostInfo(0, up_index)          -- 防守方
                self:updateLostInfo(1, down_index)          -- 进攻方
                self:updateRepaireInfo()        -- 维修信息
            elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 6 then
                self:updateGetExpInfo()
                self:updateResultInfo()
                self:updateEquipmentInfo()
                self:updateLostInfo(0, up_index)          -- 防守方
                self:updateLostInfo(1, down_index)          -- 进攻方
                self:updateRepaireInfo()        -- 维修信息
            elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 7 then
                self:updateGetResourceInfo()     -- 奖励
            else
                if #rewarld > 1 then
                    self:updateGetMineInfoTwo()     -- 奖励
                else
                    self:updateGetExpInfo()
                end
                self:updateResultInfo()         -- 战斗结果
                self:updateEquipmentInfo()
                self:updateLostInfo(0, up_index)          -- 防守方
                self:updateLostInfo(1, down_index)          -- 进攻方
                self:updateRepaireInfo()        -- 维修信息
            end 
        elseif tonumber(self._mail_data.mail_params.mail_type) == 3 then        -- 协防
            self:updateDefenceResultInfo()
            self:updateDefenceInfo()
        else
            --如果防守方不是我的话，说明是协防防守
            local attachedInfo = zstring.split(self._mail_data.param, "|")
            local defence_id = 0
            if attachedInfo[4] ~= nil then
                local defence_info = zstring.split(attachedInfo[4], ",")
                defence_id = zstring.tonumber(defence_info[3])
            end
            if tonumber(defence_id) ~= tonumber(_ED.user_info.user_id) then
                if #rewarld > 1 then                 -- 奖励
                    self:updateGetResourceInfo()
                else
                    self:updateGetExpInfo()
                end     
            end
            self:updateResultInfo()         -- 战斗结果
            self:updateEquipmentInfo()
            self:updateLostInfo(0, up_index)          -- 防守方
            self:updateLostInfo(1, down_index)          -- 进攻方
            self:updateRepaireInfo()        -- 维修信息
        end
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self:onUpdateButton()

    self._list_view:setBounceTopBoundary(self._list_view:getContentSize().height)
end

function MailPresentationInfo:updatePacificRimInfo()
    local root = self.roots[1]
    self:updateMailTypeInfo()
    -- 邮件内容
    local ListView_presentation = ccui.Helper:seekWidgetByName(root,"ListView_presentation")
    self._list_view = ListView_presentation

    local attachedInfo = zstring.split(self._mail_data.param, "|")
    local up_index = 0
    local down_index = 1
    if tonumber(attachedInfo[1]) == 1 then
        up_index = 1
        down_index = 0
    else
    end

    if self._report_type == 11 or self._report_type == 10000 --战地争霸类型
        then 
        self:updateResultInfo()         -- 战斗结果
        self:addRewardTitle()
        self:updateGetArenaInfo()       -- 奖励
        self:updateEquipmentInfo()
        self:updateLostInfo(0, up_index)          -- 防守方
        self:updateLostInfo(1, down_index)          -- 进攻方
        self:updateRepaireInfo()        -- 维修信息
    elseif self._report_type == 24 
        or self._report_type == 10001
        or self._report_type == 201
        or self._report_type == 202
        or self._report_type == 203
        then
        self:updateResultInfo()         -- 战斗结果
        self:addRewardTitle()
        self:updateGetExpInfo()
        self:updateEquipmentInfo()
        self:updateLostInfo(0, up_index)          -- 防守方
        self:updateLostInfo(1, down_index)          -- 进攻方
        self:updateRepaireInfo()        -- 维修信息
    elseif self._report_type == 210
        or self._report_type == 10007
        then
        local other_info = zstring.split(attachedInfo[4], ",")
        local record_type = tonumber(other_info[4])
        if record_type == 0 then
            self:updateResultInfo()         -- 战斗结果
            self:addRewardTitle()
            self:updateGetExpInfo()
            self:updateEquipmentInfo()
            self:updateLostInfo(0, up_index)          -- 防守方
            self:updateLostInfo(1, down_index)          -- 进攻方
            self:updateRepaireInfo()        -- 维修信息
        else
            self:addRewardTitle()
            self:updateGetResourceInfo()
        end
    elseif self._report_type == 10003 
        or self._report_type == 10004
        or self._report_type == 207  
        or self._report_type == 209
        or self._report_type == 10006
        then
        self:updateResultInfo()         -- 战斗结果
        self:updateEquipmentInfo()
        self:updateLostInfo(0, up_index)          -- 防守方
        self:updateLostInfo(1, down_index)          -- 进攻方
        self:updateRepaireInfo()        -- 维修信息
    else
        -- local attachedInfo = zstring.split(self._mail_data.param, "|")
        -- local attachedOne = zstring.split(attachedInfo[2], ",")
        rewarld = {}
        if _ED.report_reward_info[1] ~= nil then
            rewarld = zstring.split(_ED.report_reward_info[1], "|")
        end

        if tonumber(self._mail_data.mail_params.mail_type) == 0 then
            if tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 4 then
                self:addRewardTitle()
                if tonumber(self._mail_data.mail_params.rewardType) == 0 then
                    self:updateMainCollectionRewarld()
                else
                    -- self:updateGetResourceInfo()     -- 奖励
                end     
            elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 2 
                or tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 1
                then
                self:updateResultInfo()         -- 战斗结果
                self:addRewardTitle()
                if tonumber(self._mail_data.result) == 1 then
                    self:updateGetResourceInfo()
                else
                    self:updateGetExpInfo()
                end
                self:updateBoomInfo()
                self:updateEquipmentInfo()
                self:updateLostInfo(0, up_index)          -- 防守方
                self:updateLostInfo(1, down_index)          -- 进攻方
                self:updateRepaireInfo()        -- 维修信息
            elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 6 then
                self:updateResultInfo()
                self:addRewardTitle()
                self:updateGetExpInfo()
                self:updateEquipmentInfo()
                self:updateLostInfo(0, up_index)          -- 防守方
                self:updateLostInfo(1, down_index)          -- 进攻方
                self:updateRepaireInfo()        -- 维修信息
            elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 7 then
                self:addRewardTitle()
                self:updateGetResourceInfo()     -- 奖励
            else
                self:updateResultInfo()         -- 战斗结果
                self:addRewardTitle()
                if #rewarld > 1 then
                    self:updateGetMineInfoTwo()     -- 奖励
                else
                    self:updateGetExpInfo()
                end
                self:updateBoomInfo()
                self:updateEquipmentInfo()
                self:updateLostInfo(0, up_index)          -- 防守方
                self:updateLostInfo(1, down_index)          -- 进攻方
                self:updateRepaireInfo()        -- 维修信息
            end 
        elseif tonumber(self._mail_data.mail_params.mail_type) == 3 then        -- 协防
            self:updateDefenceResultInfo()
            self:updateDefenceInfo()
        else
            --如果防守方不是我的话，说明是协防防守
            local attachedInfo = zstring.split(self._mail_data.param, "|")
            local defence_id = 0
            if attachedInfo[4] ~= nil then
                local defence_info = zstring.split(attachedInfo[4], ",")
                defence_id = zstring.tonumber(defence_info[3])
            end
            self:updateResultInfo()         -- 战斗结果
            if tonumber(defence_id) ~= tonumber(_ED.user_info.user_id) then
                self:addRewardTitle()
                if #rewarld > 1 then                 -- 奖励
                    self:updateGetResourceInfo()
                else
                    self:updateGetExpInfo()
                end
                if tonumber(self._mail_data.mail_params.mail_type) == 1
                    and tonumber(self._mail_data.mail_params.Defensive_side.attack_type) == 1
                    then
                else
                    self:updateBoomInfo()
                end
            end
            self:updateEquipmentInfo()
            self:updateLostInfo(0, up_index)          -- 防守方
            self:updateLostInfo(1, down_index)          -- 进攻方
            self:updateRepaireInfo()        -- 维修信息
        end
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self:onUpdateButton()

    self._list_view:setBounceTopBoundary(self._list_view:getContentSize().height)
end

-- 显示战斗类型和结果
function MailPresentationInfo:updateMailTypeInfo()
    local root = self.roots[1]
    local Panel_presentation_vic = ccui.Helper:seekWidgetByName(root,"Panel_presentation_vic")
    if ((self._report_type == 200 or self._report_type == 1200) and tonumber(self._mail_data.mail_params.mail_type) == 3)
        or tonumber(self._mail_data.result) == 1
        then
        Panel_presentation_vic:setBackGroundImage(string.format(config_res.images.ui.share.mail_vic_box, 1))
    else
        Panel_presentation_vic:setBackGroundImage(string.format(config_res.images.ui.share.mail_vic_box, 2))
    end

    local Text_battle_infor_n = ccui.Helper:seekWidgetByName(root,"Text_battle_infor_n")
    local attack_info = ""        -- 进攻类型
    local attachedInfo = zstring.split(self._mail_data.param, "|")
    if tonumber(attachedInfo[1]) == 0 then  --//攻
        attack_info = formation_type_string[13]
    else
        attack_info = formation_type_string[35]
    end
    local report_info = ""        -- 战报类型
    -- 战斗类型
    if self._report_type == 11     --战地争霸
        or self._report_type == 10000 
        then
        report_info = _ED.fight_center_list_info["1"].list_type_name
    elseif self._report_type == 201     --远征
        then
        report_info = _ED.fight_center_list_info["2"].list_type_name
    elseif self._report_type == 202     --极限挑战
        then
        report_info = _ED.fight_center_list_info["6"].list_type_name
    elseif self._report_type == 207     --军团争霸
        or self._report_type == 10003 
        or self._report_type == 10004
        then
        report_info = _ED.fight_center_list_info["7"].list_type_name
    elseif self._report_type == 209     --守卫战
        or self._report_type == 10006 
        then
        report_info = _ED.fight_center_list_info["9"].list_type_name
    elseif self._report_type == 24     --军团切磋
        or self._report_type == 10001 
        then
        report_info = tipString_info_project_pacific_rim[9]
    elseif self._report_type == 203 
        or (tonumber(self._mail_data.nType) == 200 and self._mail_data.mail_params.Defensive_side~= nil and tonumber(self._mail_data.mail_params.Defensive_side.attack_type) == 5)
        then
        report_info = tipString_info_project_pacific_rim[10]
    elseif self._report_type == 210
        or self._report_type == 10007
        then
        report_info = _ED.fight_center_list_info["13"].list_type_name
    else
        if tonumber(self._mail_data.mail_params.mail_type) == 0 then   --//攻
            attack_info = formation_type_string[13]
            if tonumber(self._mail_data.mail_params.rewardType) == 5 then  -- 打叛军
                report_info = tipString_info_project_pacific_rim[10]
            else
                if tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 4 then
                    report_info = mail_tip_text[7]
                    attack_info = ""
                else
                    if tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 0       --打矿
                        or tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 1   --打有人的矿
                        then      
                        local element = dms.element(dms["world_mine_mould"], tonumber(self._mail_data.mail_params.Attack_side.mine_mould_id))
                        report_info = dms.atos(element, world_mine_mould.name)
                    elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 2 then      --打基地
                        report_info = tipStringInfo_campaign_info[34]
                    end
                end
            end
        elseif tonumber(self._mail_data.mail_params.mail_type) == 1 then    --//防守
            attack_info = formation_type_string[35]
            if tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 1 then      -- 矿被攻击
                local element = dms.element(dms["world_mine_mould"], tonumber(self._mail_data.mail_params.Attack_side.mine_mould_id))
                report_info = dms.atos(element, world_mine_mould.name)
            elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 2 then  -- 基地被攻击
                report_info = tipStringInfo_campaign_info[34]
            end
        elseif tonumber(self._mail_data.mail_params.mail_type) == 3 then    --//协防
            attack_info = ""
            local attachedInfo = zstring.split(self._mail_data.param, "|")
            local attachedOne = zstring.split(attachedInfo[2], ",")
            local attachedTwo = zstring.split(attachedInfo[3], ",")
            local defence_id = zstring.tonumber(attachedInfo[5])
            if defence_id ~= tonumber(_ED.user_info.user_id) then
                if tonumber(attachedOne[8]) == 0 then
                    report_info = mail_tip_text[55]
                else
                    report_info = mail_tip_text[56]
                end
            else
                if tonumber(attachedTwo[8]) == 0 then
                    report_info = mail_tip_text[55]
                else
                    report_info = mail_tip_text[56]
                end
            end
        end
    end
    Text_battle_infor_n:setString(attack_info..report_info)
end

-- 繁荣度信息
function MailPresentationInfo:updateBoomInfo()
    local csbItem = csb.createNode(string.format(config_csb.cells.mail.mail_presentation_cell, 16))
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self._list_view:addChild(root)
    -- 我方
    local Text_boom_me_n = ccui.Helper:seekWidgetByName(root,"Text_boom_me_n")        -- 繁荣度
    local LoadingBar_boom_me = ccui.Helper:seekWidgetByName(root,"LoadingBar_boom_me")        -- 繁荣度
    local Text_prosperity_me = ccui.Helper:seekWidgetByName(root,"Text_prosperity_me")        -- 繁荣度/繁荣度

    -- 敌方
    local Text_boom_enemy_n = ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_n")        -- 繁荣度
    local LoadingBar_boom_enemy = ccui.Helper:seekWidgetByName(root,"LoadingBar_boom_enemy")        -- 繁荣度
    local Text_prosperity_enemy = ccui.Helper:seekWidgetByName(root,"Text_prosperity_enemy")        -- 繁荣度/繁荣度

    local my_side = self._mail_data.mail_params.Attack_side
    local enemy_side = self._mail_data.mail_params.Defensive_side
    if tonumber(self._mail_data.mail_params.mail_type) == 1 then    -- 防守邮件
        my_side = self._mail_data.mail_params.Defensive_side
        enemy_side = self._mail_data.mail_params.Attack_side
    end

    if tonumber(my_side.attack_type) == 0 
        or tonumber(my_side.attack_type) == 1 
        then    --打矿
        if tonumber(self._report_type) == 1200 then
            ccui.Helper:seekWidgetByName(root,"Text_boom_me_t"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_boom_me"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"LoadingBar_boom_me"):setVisible(false)
        end
        ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_n"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"LoadingBar_boom_enemy"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Image_boom_enemy"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_t"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "LoadingBar_boom_me"):setPercent(tonumber(my_side.currentBoom) / tonumber(my_side.maxBoom) * 100)
        if tonumber(my_side.boomChange) >= 0 then
            ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setString("+"..my_side.boomChange)
            ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
        else
            ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setString(my_side.boomChange)
            ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
        end
        if self._report_type == 200 and tonumber(self._mail_data.mail_params.mail_type) == 0 then
            Text_prosperity_me:setString(my_side.currentBoom.."/"..my_side.maxBoom)
        else
            Text_prosperity_me:setString("")
        end
    else    
        ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_n"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"LoadingBar_boom_enemy"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Image_boom_enemy"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_t"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "LoadingBar_boom_me"):setPercent(tonumber(my_side.currentBoom) / tonumber(my_side.maxBoom) * 100)
        if tonumber(my_side.boomChange) >= 0 then
            ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setString("+"..my_side.boomChange)
            ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
        else
            ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setString(my_side.boomChange)
            ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
        end
        Text_prosperity_me:setString(my_side.currentBoom.."/"..my_side.maxBoom)
        ccui.Helper:seekWidgetByName(root, "LoadingBar_boom_enemy"):setPercent(tonumber(enemy_side.currentBoom) / tonumber(enemy_side.maxBoom) * 100)
        if tonumber(enemy_side.boomChange) > 0 then
            ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_n"):setString("+"..enemy_side.boomChange)
            ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_n"):setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))

        else
            ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_n"):setString(enemy_side.boomChange)
            ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_n"):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
        end
        -- ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_n"):setString(tonumber(enemy_side.currentBoom)-tonumber(enemy_side.maxBoom))
        Text_prosperity_enemy:setString(enemy_side.currentBoom.."/"..enemy_side.maxBoom)
    end
end

-- 战利品标头
function MailPresentationInfo:addRewardTitle()
    local csbItem = csb.createNode(string.format(config_csb.cells.mail.mail_presentation_cell, 15))
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self._list_view:addChild(root)
end

-- 获得的竞技场奖励信息
function MailPresentationInfo:updateGetArenaInfo()
    local csbItem = csb.createNode(string.format(config_csb.cells.mail.mail_presentation_cell, 6))
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self._list_view:addChild(root)
	

    local Text_integtal_n = ccui.Helper:seekWidgetByName(root,"Text_integtal_n")        -- 积分
	local Text_rank_n = ccui.Helper:seekWidgetByName(root,"Text_rank_n")        -- 排名
    local Text_honor_n = ccui.Helper:seekWidgetByName(root,"Text_honor_n")        -- 荣誉
	if _ED.report_reward_info[1] ~= nil then
		local datas = zstring.split(_ED.report_reward_info[1], "|")
		local rewardInfo = zstring.split(datas[1], ",")
		Text_integtal_n:setString("+"..rewardInfo[3])
		local paramData = zstring.split(self._mail_data.param, "|")
		if tonumber(paramData[4]) > 0 then
			Text_rank_n:setString("+"..paramData[4])	
		else
			Text_rank_n:setString(paramData[4])	
		end
		local rewardDats = zstring.split(datas[2], ",")
		Text_honor_n:setString("+0")--("+"..rewardDats[3])
	end
end

-- 矿点采集
function MailPresentationInfo:updateMainCollectionRewarld()
	local csbItem = csb.createNode(string.format(config_csb.cells.mail.mail_presentation_cell, 7))
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self._list_view:addChild(root)
	
	local Text_collection_res_n = ccui.Helper:seekWidgetByName(root,"Text_collection_res_n") --采集总量
	local Text_boom_n = ccui.Helper:seekWidgetByName(root,"Text_boom_n") --繁荣度增加
	local Panel_predatory_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_predatory_res_icon") --资源图标
	Panel_predatory_res_icon:removeAllChildren(true)
	local Text_predatory_res_n =  ccui.Helper:seekWidgetByName(root,"Text_predatory_res_n") --资源数
	-- debug.print_r(_ED.report_reward_info)
	local rewarld = zstring.split(_ED.report_reward_info[1], ",")
	-- Panel_predatory_res_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", zstring.tonumber(rewarld[2])))
	local cell = state_machine.excute("props_icon_create_cell",0,{1,3,zstring.tonumber(rewarld[2]),1})
	Panel_predatory_res_icon:addChild(cell) 
	Text_collection_res_n:setString(exChangeNumToString(tonumber(rewarld[3])))
	Text_predatory_res_n:setString("+"..exChangeNumToString(tonumber(rewarld[3])))
	Text_boom_n:setString("+"..self._mail_data.mail_params.Attack_side.boomChange)
end

--  打矿获得的道具
function MailPresentationInfo:updateGetMineInfo()
    local csbItem = csb.createNode(string.format(config_csb.cells.mail.mail_presentation_cell, 1))
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self._list_view:addChild(root)
	
    local Text_loss_res_t = ccui.Helper:seekWidgetByName(root,"Text_loss_res_t")        -- 损失资源或获得资源类型
    local Text_loss_res_n = ccui.Helper:seekWidgetByName(root,"Text_loss_res_n")        -- 资源数量
    local Text_military_t = ccui.Helper:seekWidgetByName(root,"Text_military_t")        -- 军功
    local Text_military_n = ccui.Helper:seekWidgetByName(root,"Text_military_n")        -- 军功
    local Text_honor_n = ccui.Helper:seekWidgetByName(root,"Text_honor_n")           -- 荣誉
	local str = ""
	Text_loss_res_t:setString(red_alert_war_city_map_tip[18])
	local rewarld = zstring.split(_ED.report_reward_info[1], "|")
	local allnumber = 0
	if #rewarld > 1 then
		-- for i = 1, 5 do
			local Panel_predatory_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_predatory_res_icon_"..3)        -- 资源图标
			local Text_predatory_res_n = ccui.Helper:seekWidgetByName(root,"Text_predatory_res_n_"..3)                -- 数量
			Panel_predatory_res_icon:removeAllChildren(true)
			local rewarld_info = zstring.split(rewarld[1], ",")
			local cell = state_machine.excute("props_icon_create_cell",0,{6,3,zstring.tonumber(rewarld_info[1]),1})
			ccui.Helper:seekWidgetByName(cell.roots[1], "Image_num_bg"):setVisible(false)
			ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_n"):setVisible(false)
			ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_name"):setVisible(false)
			Panel_predatory_res_icon:addChild(cell) 
			Text_predatory_res_n:setString("+"..str..exChangeNumToString(tonumber(rewarld_info[3])))
			allnumber = allnumber + tonumber(rewarld_info[3])
		-- end
    end
	Text_loss_res_n:setString("+"..str..exChangeNumToString(allnumber))
	local rewarld_info = zstring.split(rewarld[#rewarld], ",")
	Text_military_n:setString("+"..rewarld_info[3])
	Text_honor_n:setString("+0")
	Text_military_t:setString(reward_prop_list[tonumber(rewarld_info[2])])
	-- if self._mail_data.mail_params ~= nil and self._mail_data.mail_params.Attack_side ~= nil then
		-- if tonumber(mail_params.Attack_side.attack_type) == 4 then
			-- Text_loss_res_t:setString()
		-- end
	-- end
	
end

--  打矿获得的道具
function MailPresentationInfo:updateGetMineInfoTwo()
    local csbItem = csb.createNode(string.format(config_csb.cells.mail.mail_presentation_cell, 9))
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self._list_view:addChild(root)
	
    local Text_loss_res_t = ccui.Helper:seekWidgetByName(root,"Text_loss_res_t")        -- 损失资源或获得资源类型
    local Text_loss_res_n = ccui.Helper:seekWidgetByName(root,"Text_loss_res_n")        -- 资源数量
    local Text_military_t = ccui.Helper:seekWidgetByName(root,"Text_military_t")        -- 军功
    local Text_military_n = ccui.Helper:seekWidgetByName(root,"Text_military_n")        -- 军功
    local Text_honor_n = ccui.Helper:seekWidgetByName(root,"Text_honor_n")           -- 荣誉
    local ListView_predatory_res = ccui.Helper:seekWidgetByName(root,"ListView_predatory_res")
    ListView_predatory_res:removeAllItems()
    local listViewSize = ListView_predatory_res:getContentSize()
	local nCoount = 0
	local tWidth = 0
	local iemsMargin = ListView_predatory_res:getItemsMargin()

	local str = ""
	Text_loss_res_t:setString(red_alert_war_city_map_tip[18])
	local rewarld = zstring.split(_ED.report_reward_info[1], "|")
	local allnumber = 0
	local number = 0

	for i,v in pairs(rewarld) do
		local rewarld_info = zstring.split(v, ",")
		if tonumber(rewarld_info[1]) ~= -1 then
			local cell = state_machine.excute("props_icon_create_cell",0,{6,3,zstring.tonumber(rewarld_info[1]),1})
			ListView_predatory_res:addChild(cell)
			ccui.Helper:seekWidgetByName(cell.roots[1], "Image_num_bg"):setVisible(false)
			ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_n"):setVisible(false)
			ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_name"):setString("+1")
            ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_name"):setScale(1.5)
			allnumber = allnumber + tonumber(rewarld_info[3])
			if nCoount > 0 then
				tWidth = tWidth + iemsMargin
			end
			nCoount = nCoount + 1
		end
	end
	
	tWidth = tWidth + PropsIconCell.__size.width * nCoount
		local viewWidth = listViewSize.width * ListView_predatory_res:getScaleX()
		if viewWidth > tWidth then
			-- local containerLayer = ListView_rew_icon:getInnerContainer()
			ListView_predatory_res:setPositionX(ListView_predatory_res:getPositionX() + viewWidth / 2 - tWidth / 2+20)
		end
	ListView_predatory_res:setTouchEnabled(false)
	ListView_predatory_res:requestRefreshView()

	Text_loss_res_n:setString("+"..str..exChangeNumToString(allnumber))
	local rewarld_info = zstring.split(rewarld[#rewarld], ",")
	Text_military_n:setString("+"..exChangeNumToString(rewarld_info[3]))
	Text_honor_n:setString("+0")
	Text_military_t:setString(reward_prop_list[tonumber(rewarld_info[2])])
	-- if self._mail_data.mail_params ~= nil and self._mail_data.mail_params.Attack_side ~= nil then
		-- if tonumber(mail_params.Attack_side.attack_type) == 4 then
			-- Text_loss_res_t:setString()
		-- end
	-- end
	
end

--  获得或损失资源信息
function MailPresentationInfo:updateGetResourceInfo()
    local csbItem = csb.createNode(string.format(config_csb.cells.mail.mail_presentation_cell, 1))
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self._list_view:addChild(root)
	
    local Text_loss_res_t = ccui.Helper:seekWidgetByName(root,"Text_loss_res_t")        -- 损失资源或获得资源类型
    local Text_loss_res_n = ccui.Helper:seekWidgetByName(root,"Text_loss_res_n")        -- 资源数量
    local Text_military_n = ccui.Helper:seekWidgetByName(root,"Text_military_n")        -- 军功
    local Text_military_t = ccui.Helper:seekWidgetByName(root,"Text_military_t")        -- 军功
    local Text_honor_n = ccui.Helper:seekWidgetByName(root,"Text_honor_n")           -- 荣誉
    Text_military_t:setString(reward_prop_list[18])

	local rewarld = zstring.split(_ED.report_reward_info[1], "|")
	local allnumber = 0
	local reworld_list = {}
	local military_number = 0
    local str = ""
    if self._report_type == 210 or self._report_type == 10007 then
        local attachedInfo = zstring.split(self._mail_data.param, "|")
        local attackInfo = zstring.split(attachedInfo[2], ",")
        local defenceInfo = zstring.split(attachedInfo[3], ",")
        if tonumber(attackInfo[4]) == tonumber(_ED.union.union_info.union_id) then
            str = "+"
            Text_loss_res_t:setString(red_alert_war_city_map_tip[16])
            military_number = tonumber(attackInfo[5])
        else
            str = "-"
            Text_loss_res_t:setString(red_alert_war_city_map_tip[17])
            military_number = tonumber(defenceInfo[5])
        end
    else
        if tonumber(self._mail_data.mail_params.mail_type) == 1 then
            str = "-"
            Text_loss_res_t:setString(red_alert_war_city_map_tip[17])
        else
            str = "+"
            Text_loss_res_t:setString(red_alert_war_city_map_tip[16])
        end
    	if tonumber(self._mail_data.mail_params.mail_type) == 0 then
    		military_number = tonumber(self._mail_data.mail_params.Attack_side.military_number)
    	elseif tonumber(self._mail_data.mail_params.mail_type) == 1 then
    		military_number = tonumber(self._mail_data.mail_params.Defensive_side.military_number)
    	end
    end
    local rewarldData = {
        {0,33,0},
        {0,41,0},
        {0,42,0},
        {0,43,0},
        {0,1,0},
    }
    for i, v in pairs(rewarld) do
        local rewarld_info = zstring.split(v, ",")
        for j, w in pairs(rewarldData) do
            if tonumber(rewarld_info[2]) == tonumber(w[2]) then
                rewarldData[j][3] = tonumber(rewarld_info[3])
                break
            end
        end
    end
    for j, w in pairs(rewarldData) do
        table.insert(reworld_list, w)
    end 

	-- for i, v in pairs(rewarld) do
	-- 	local rewarld_info = zstring.split(v, ",")
	-- 	if tonumber(rewarld_info[2]) == 33 or tonumber(rewarld_info[2]) == 41 or tonumber(rewarld_info[2]) == 42 
	-- 		or tonumber(rewarld_info[2]) == 43 or tonumber(rewarld_info[2]) == 1 then
	-- 		table.insert(reworld_list, v)
	-- 	end
	-- end

    if self._report_type == 200 
        and tonumber(self._mail_data.mail_params.mail_type) == 0
        and tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 1
        then
        -- 打玩家的矿
        local reward_info = zstring.split(rewarld[1], ",")

        local Panel_predatory_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_predatory_res_icon_3")        -- 资源图标
        local Text_predatory_res_n = ccui.Helper:seekWidgetByName(root,"Text_predatory_res_n_3")                -- 数量
        Panel_predatory_res_icon:removeAllChildren(true)
        local cell = state_machine.excute("props_icon_create_cell",0,{1,3,zstring.tonumber(reward_info[2]),1})
        Panel_predatory_res_icon:addChild(cell) 
        Text_predatory_res_n:setString(str..exChangeNumToString(tonumber(reward_info[3])))
        allnumber = allnumber + tonumber(reward_info[3])
    else
    	if #reworld_list > 1 then
    		for i = 1, #reworld_list do
    			local Panel_predatory_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_predatory_res_icon_"..i)        -- 资源图标
    			local Text_predatory_res_n = ccui.Helper:seekWidgetByName(root,"Text_predatory_res_n_"..i)                -- 数量
    			Panel_predatory_res_icon:removeAllChildren(true)
    			-- local rewarld_info = zstring.split(reworld_list[i], ",")
    			local cell = state_machine.excute("props_icon_create_cell",0,{1,3,zstring.tonumber(reworld_list[i][2]),1})
    			Panel_predatory_res_icon:addChild(cell) 
    			Text_predatory_res_n:setString(str..exChangeNumToString(tonumber(reworld_list[i][3])))
    			allnumber = allnumber + tonumber(reworld_list[i][3])
    		end
        end
    end
	Text_loss_res_n:setString(str..exChangeNumToString(allnumber))
	Text_military_n:setString("+"..exChangeNumToString(military_number))
	Text_honor_n:setString("+0")
	
	-- if self._mail_data.mail_params ~= nil and self._mail_data.mail_params.Attack_side ~= nil then
		-- if tonumber(mail_params.Attack_side.attack_type) == 4 then
			-- Text_loss_res_t:setString()
		-- end
	-- end
	
end

-- 获得的经验信息
function MailPresentationInfo:updateGetExpInfo()
    local csbItem = csb.createNode(string.format(config_csb.cells.mail.mail_presentation_cell, 2))
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self._list_view:addChild(root)
    local Text_exp_t = ccui.Helper:seekWidgetByName(root,"Text_exp_t")
    local Text_honor_t = ccui.Helper:seekWidgetByName(root,"Text_honor_t")
    local Text_exp_n = ccui.Helper:seekWidgetByName(root,"Text_exp_n")        -- 经验
    local Text_honor_n = ccui.Helper:seekWidgetByName(root,"Text_honor_n")        -- 荣誉
	-- debug.print_r(_ED.report_reward_info)
	if self._report_type == 202 then
		local attachedInfo = zstring.split(self._mail_data.param, "|")
		Text_exp_t:setString(mail_tip_text[21])
		Text_exp_n:setString("+"..exChangeNumToString(attachedInfo[6]))
		Text_honor_t:setString("")
	elseif self._report_type == 201 then
		Text_exp_t:setString(mail_tip_text[25])
		local rewarld = zstring.split(_ED.report_reward_info[1], ",") 

		if #rewarld > 1 then
			Text_exp_n:setString("+"..exChangeNumToString(rewarld[3]))
			Text_honor_n:setString("+0")
		else
			Text_exp_n:setString("+0")
			Text_honor_n:setString("+0")
		end
    elseif self._report_type == 1200
        or self._report_type == 200
        then
        local military_number = 0
        if tonumber(self._mail_data.mail_params.mail_type) == 0 then
            military_number = tonumber(self._mail_data.mail_params.Attack_side.military_number)
        elseif tonumber(self._mail_data.mail_params.mail_type) == 1 then
            military_number = tonumber(self._mail_data.mail_params.Defensive_side.military_number)
        end
        rewarld = {}
        if _ED.report_reward_info[1] ~= nil then
            rewarld = zstring.split(_ED.report_reward_info[1], "|")
        end
        if tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 6 
            or tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 7
            then
            Text_exp_t:setString(mail_tip_text[50])
            Text_exp_n:setString("+"..exChangeNumToString(military_number))
        elseif zstring.tonumber(military_number) == 0 and #rewarld == 1 
            and tonumber(self._mail_data.mail_params.mail_type) ~= 1
            then
            local red1 = zstring.split(rewarld[1], ",") 
            if tonumber(red1[1]) == -1 and tonumber(red1[2]) == 8 and tonumber(red1[3]) ~= 0 then
                Text_exp_n:setString("+"..exChangeNumToString(tonumber(red1[3])))
            else
                Text_exp_n:setString("+0")
            end
        else
            Text_exp_t:setString(mail_tip_text[50])
            Text_exp_n:setString("+"..exChangeNumToString(military_number))
        end

        
        Text_honor_n:setString("+0")
    elseif self._report_type == 210
        or self._report_type == 10007
        then
        -- 军功
        local attachedInfo = zstring.split(self._mail_data.param, "|")
        local attackInfo = zstring.split(attachedInfo[2], ",")
        local defenceInfo = zstring.split(attachedInfo[3], ",")
        if tonumber(defenceInfo[4]) == tonumber(_ED.union.union_info.union_id) then
            attackInfo = defenceInfo
        end
        Text_exp_t:setString(mail_tip_text[50])
        Text_exp_n:setString("+"..exChangeNumToString(attackInfo[5]))

        Text_honor_n:setString("+0")
	else
		local rewarld = zstring.split(_ED.report_reward_info[1], "|") 
		if #rewarld > 1 then
			local red1 = zstring.split(rewarld[1], ",") 
			local red2 = zstring.split(rewarld[2], ",") 
			Text_exp_n:setString("+"..exChangeNumToString(red2[3]))
			Text_honor_n:setString("+"..red1[3])
		else
			local red1 = zstring.split(rewarld[1], ",") 
			Text_exp_n:setString("+"..exChangeNumToString(red1[3]))
			Text_honor_n:setString("+0")
		end

        if self._report_type == 24
            or self._report_type == 10001
            then
            Text_exp_n:setVisible(false)
            Text_exp_t:setVisible(false)
        else
			if tonumber(self._mail_data.mail_params.Defensive_side.attack_type) == 5 then
				Text_exp_t:setString(reward_prop_list[18])
				Text_exp_n:setString(":+"..exChangeNumToString(self._mail_data.mail_params.Attack_side.military_number))
			end
            Text_exp_n:setVisible(true)
            Text_exp_t:setVisible(true)
        end
	end
	
end

-- 战斗结果
function MailPresentationInfo:updateResultInfo()
    local csbItem = csb.createNode(string.format(config_csb.cells.mail.mail_presentation_cell, 3))
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self._list_view:addChild(root)

    -- 我方
    local Text_boom_me_n = ccui.Helper:seekWidgetByName(root,"Text_boom_me_n")        -- 繁荣度
    local LoadingBar_boom_me = ccui.Helper:seekWidgetByName(root,"LoadingBar_boom_me")        -- 繁荣度
    local Text_player_me_name = ccui.Helper:seekWidgetByName(root,"Text_player_me_name")        -- 姓名等级
    local Text_player_me_legion = ccui.Helper:seekWidgetByName(root,"Text_player_me_legion")        -- 军团
    local Text_prosperity_me = ccui.Helper:seekWidgetByName(root,"Text_prosperity_me")        -- 繁荣度/繁荣度

    -- 敌方
    local Text_boom_enemy_n = ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_n")        -- 繁荣度
    local LoadingBar_boom_enemy = ccui.Helper:seekWidgetByName(root,"LoadingBar_boom_enemy")        -- 繁荣度
    local Text_player_enemy_name = ccui.Helper:seekWidgetByName(root,"Text_player_enemy_name")        -- 姓名等级
    local Text_player_enemy_legion = ccui.Helper:seekWidgetByName(root,"Text_player_enemy_legion")        -- 军团
    local Text_prosperity_enemy = ccui.Helper:seekWidgetByName(root,"Text_prosperity_enemy")        -- 繁荣度/繁荣度
    Text_player_enemy_legion:removeAllChildren(true)
	Text_player_enemy_legion:setString("")


    -- 战斗结果
    local Panel_battle_vic = ccui.Helper:seekWidgetByName(root,"Panel_battle_vic")        -- 胜利或失败图片
    Panel_battle_vic:removeBackGroundImage()
    if self._report_type == 11 
        or self._report_type == 10000 --战地争霸类型
        or self._report_type == 24
        or self._report_type == 10001
        or self._report_type == 201
        or self._report_type == 202
        or self._report_type == 10003   --军团争霸类型
        or self._report_type == 10004
        or self._report_type == 207
        or self._report_type == 209
        or self._report_type == 10006
        or self._report_type == 210
        or self._report_type == 10007
        then 
        ccui.Helper:seekWidgetByName(root,"Text_boom_me_t"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_t"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_n"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Image_boom_me"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"LoadingBar_boom_me"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Image_boom_enemy"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"LoadingBar_boom_enemy"):setVisible(false)
    else
        -- local attachedInfo = zstring.split(self._mail_data.param, "|")
        -- local attachedOne = zstring.split(attachedInfo[2], ",")
        local my_side = self._mail_data.mail_params.Attack_side
        local enemy_side = self._mail_data.mail_params.Defensive_side
        if tonumber(self._mail_data.mail_params.mail_type) == 1 then    -- 防守邮件
            my_side = self._mail_data.mail_params.Defensive_side
            enemy_side = self._mail_data.mail_params.Attack_side
        end
        ccui.Helper:seekWidgetByName(root,"Text_boom_me_t"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Image_boom_me"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"LoadingBar_boom_me"):setVisible(true)
        if tonumber(my_side.attack_type) == 0 
            or tonumber(my_side.attack_type) == 1 
            then    --打矿
            if tonumber(self._report_type) == 1200 then
                ccui.Helper:seekWidgetByName(root,"Text_boom_me_t"):setVisible(false)
                ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setVisible(false)
                ccui.Helper:seekWidgetByName(root,"Image_boom_me"):setVisible(false)
                ccui.Helper:seekWidgetByName(root,"LoadingBar_boom_me"):setVisible(false)
            end
            ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_n"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"LoadingBar_boom_enemy"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_boom_enemy"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_t"):setVisible(false)
            ccui.Helper:seekWidgetByName(root, "LoadingBar_boom_me"):setPercent(tonumber(my_side.currentBoom) / tonumber(my_side.maxBoom) * 100)
		    if tonumber(my_side.boomChange) >= 0 then
			    ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setString("+"..my_side.boomChange)
			    ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
            else
				ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setString(my_side.boomChange)
                ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
			end
            if self._report_type == 200 and tonumber(self._mail_data.mail_params.mail_type) == 0 then
			    Text_prosperity_me:setString(my_side.currentBoom.."/"..my_side.maxBoom)
            else
                Text_prosperity_me:setString("")
            end
        elseif tonumber(my_side.attack_type) == 6 
            or tonumber(my_side.attack_type) == 7 
            then
            -- 城市战
            ccui.Helper:seekWidgetByName(root,"Text_boom_me_t"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_t"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_n"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_boom_me"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"LoadingBar_boom_me"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"Image_boom_enemy"):setVisible(false)
            ccui.Helper:seekWidgetByName(root,"LoadingBar_boom_enemy"):setVisible(false)
		else	
			ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_n"):setVisible(true)
			ccui.Helper:seekWidgetByName(root,"LoadingBar_boom_enemy"):setVisible(true)
			ccui.Helper:seekWidgetByName(root,"Image_boom_enemy"):setVisible(true)
			ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_t"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "LoadingBar_boom_me"):setPercent(tonumber(my_side.currentBoom) / tonumber(my_side.maxBoom) * 100)
			if tonumber(my_side.boomChange) >= 0 then
                ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setString("+"..my_side.boomChange)
                ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
			else
				ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setString(my_side.boomChange)
                ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
			end
			Text_prosperity_me:setString(my_side.currentBoom.."/"..my_side.maxBoom)
			ccui.Helper:seekWidgetByName(root, "LoadingBar_boom_enemy"):setPercent(tonumber(enemy_side.currentBoom) / tonumber(enemy_side.maxBoom) * 100)
			if tonumber(enemy_side.boomChange) > 0 then
				ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_n"):setString("+"..enemy_side.boomChange)
                ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_n"):setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))

			else
				ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_n"):setString(enemy_side.boomChange)
			    ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_n"):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
            end
			-- ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_n"):setString(tonumber(enemy_side.currentBoom)-tonumber(enemy_side.maxBoom))
			Text_prosperity_enemy:setString(enemy_side.currentBoom.."/"..enemy_side.maxBoom)
		end
	end
	--攻
	--如果是失败左边变红，否则右边变红
	local color_1 = nil
	local color_2 = nil
	local attachedInfo = zstring.split(self._mail_data.param, "|")
	if self._mail_data.mail_params==nil then
		self._mail_data.mail_params = {}
		self._mail_data.mail_params.mail_type = attachedInfo[1]
	end
	if tonumber(self._mail_data.mail_params.mail_type) == 0 then 
		if tonumber(self._mail_data.result) == 0 then
			color_1 = cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2])
			color_2 = cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2])
		else
			color_1 = cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2])
			color_2 = cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2])
		end
	else
		if tonumber(self._mail_data.result) == 0 then
            color_1 = cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2])
            color_2 = cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2])
        else
			color_1 = cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2])
			color_2 = cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2])
		end
	end

    local left_info = nil
    local right_info = nil
    local enemy_name = ""
    local battleData = zstring.split(self._mail_data.param, "|")
    local name_info = zstring.split(battleData[4], ",")
    if tonumber(self._mail_data.mail_params.mail_type) == 1 then
        left_info = zstring.split(battleData[3], ",")
        right_info = zstring.split(battleData[2], ",")
    else
        left_info = zstring.split(battleData[2], ",")
        right_info = zstring.split(battleData[3], ",")
    end
    local level_info = left_info[3]

    if ((self._report_type == 200 or self._report_type == 1200) and tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 2)
        and zstring.tonumber(name_info[3]) == tonumber(_ED.user_info.user_id) then
        if zstring.tonumber(name_info[2]) > 0 then
            level_info = name_info[2]
        end
        ccui.Helper:seekWidgetByName(root,"Text_boom_me_t"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_boom_me_n"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_t"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_boom_enemy_n"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Image_boom_me"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"LoadingBar_boom_me"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Image_boom_enemy"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"LoadingBar_boom_enemy"):setVisible(false)
        Text_prosperity_me:setString("")
        Text_prosperity_enemy:setString("")
        enemy_name = name_info[1]
    else
        enemy_name = left_info[1]
    end
    
	Text_player_me_name:setString(enemy_name..friends_tip_string[12]..level_info)
	Text_player_me_name:setColor(color_1)
	Text_player_me_legion:setString(left_info[2])
	if self._report_type == 202 then
		Text_player_enemy_name:setString(string.format(mail_tip_text[20],attachedInfo[4]))
		local _richText_1 = ccui.RichText:create()
	    _richText_1:ignoreContentAdaptWithSize(false) 
	    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, mail_tip_text[18], "fonts/simhei.ttf",22)
	    _richText_1:pushBackElement(re1)  
	    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, attachedInfo[5], "fonts/simhei.ttf",22)
	    _richText_1:pushBackElement(re2)
	    _richText_1:setPosition(cc.p(Text_player_enemy_legion:getContentSize().width/2+30,Text_player_enemy_legion:getContentSize().height/2))
	    _richText_1:setContentSize(cc.size(Text_player_enemy_legion:getContentSize().width,22))
	    Text_player_enemy_legion:addChild(_richText_1)
	else
        Text_player_enemy_name:setString(right_info[1]..friends_tip_string[12]..right_info[3])
        Text_player_enemy_legion:setString(right_info[2])
	end
	Text_player_enemy_name:setColor(color_2)

	if tonumber(self._mail_data.result) == 1 then
		Panel_battle_vic:setBackGroundImage("images/ui/share/mail_text_3.png")
	else
		Panel_battle_vic:setBackGroundImage("images/ui/share/mail_text_4.png")
	end

    local Text_player_enemy_world_xy = ccui.Helper:seekWidgetByName(root,"Text_player_enemy_world_xy")
    if Text_player_enemy_world_xy ~= nil then
        if self._enemy_coord ~= nil then
            Text_player_enemy_world_xy:setString(string.format(mail_tip_text[10], self._enemy_coord[1], self._enemy_coord[2]))
        else
            Text_player_enemy_world_xy:setString("")
        end
    end

    local Panel_battle_arrow = ccui.Helper:seekWidgetByName(root,"Panel_battle_arrow")
    if Panel_battle_arrow ~= nil then
        local attachedInfo = zstring.split(self._mail_data.param, "|")
        if tonumber(attachedInfo[1]) == 0 then  --//攻
            Panel_battle_arrow:setBackGroundImage(string.format(config_res.images.ui.share.mail_arrow, 1))
        else
            Panel_battle_arrow:setBackGroundImage(string.format(config_res.images.ui.share.mail_arrow, 2))
        end
    end

    -- 头像信息
    local battleData = zstring.split(self._mail_data.param, "|")
    local attack_head_info = zstring.split(battleData[#battleData - 1], ",")
    local defence_head_info = zstring.split(battleData[#battleData], ",")
    local left_head_info = nil
    local right_head_info = nil
    if #attack_head_info == 4 and #defence_head_info == 4 then 
        left_head_info = attack_head_info
        right_head_info = defence_head_info

        if self._report_type == 200 or self._report_type == 203 then
            if self._report_type == 203 
                or (tonumber(self._mail_data.nType) == 200 and self._mail_data.mail_params.Defensive_side~= nil and tonumber(self._mail_data.mail_params.Defensive_side.attack_type) == 5)
                then
                local head_pic = zstring.split(dms.string(dms["npc"], self._mail_data.npc_moud_id, npc.head_pic), ",")
                right_head_info = {-1, head_pic[2]}
            elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 0 then      --打矿
                local element = dms.element(dms["world_mine_mould"], tonumber(self._mail_data.mail_params.Attack_side.mine_mould_id))
                right_head_info = {-2, self._mail_data.mail_params.Attack_side.mine_mould_id}
            end
        end
        if tonumber(self._mail_data.mail_params.mail_type) == 1 then    -- 防守邮件
            right_head_info = attack_head_info
            left_head_info = defence_head_info
        end

        if (self._report_type == 200 or self._report_type == 1200) then
            left_head_info = "".._ED.user_info.user_id..",".._ED.user_info.user_head_id
            left_head_info = zstring.split(left_head_info, ",")
        end
    end

    local Panel_1 = ccui.Helper:seekWidgetByName(root,"Panel_1")
    if Panel_1 ~= nil and left_head_info ~= nil then
        Panel_1:removeAllChildren(true)
        Panel_1:removeBackGroundImage()
        if tonumber(left_head_info[1]) > 0 then
            local avatar_info = {}
            local cell = PlayerHeadIcon:createCell()
            avatar_info.object = ""..left_head_info[2]..","..left_head_info[3]..","..left_head_info[4]
            avatar_info.vip = 0
            avatar_info._type = 0
            if tonumber(_ED.user_info.user_id) ~= tonumber(left_head_info[1]) then
                avatar_info._is_click = true
                avatar_info._user_id = tonumber(left_head_info[1])
            end
            cell:init(avatar_info)
            Panel_1:addChild(cell)
        elseif tonumber(left_head_info[1]) == -1  then
            Panel_1:setBackGroundImage(string.format(config_res.images.ui.props.tank, left_head_info[2]))
        elseif tonumber(left_head_info[1]) == -2  then
            local avatar_info = {}
            local cell = PlayerHeadIcon:createCell()
            avatar_info.object = ""
            avatar_info.vip = 0
            avatar_info._type = 1
            avatar_info._mould_id = tonumber(left_head_info[2])
            cell:init(avatar_info)
            Panel_1:addChild(cell)
        end
    end

    local Panel_1_0 = ccui.Helper:seekWidgetByName(root,"Panel_1_0")
    if Panel_1_0 ~= nil and right_head_info ~= nil then
        Panel_1_0:removeAllChildren(true)
        Panel_1_0:removeBackGroundImage()
        if tonumber(right_head_info[1]) > 0 then
            local avatar_info = {}
            local cell = PlayerHeadIcon:createCell()
            avatar_info.object = ""..right_head_info[2]..","..right_head_info[3]..","..right_head_info[4]
            avatar_info.vip = 0
            avatar_info._type = 0
            if tonumber(_ED.user_info.user_id) ~= tonumber(right_head_info[1]) then
                avatar_info._is_click = true
                avatar_info._user_id = tonumber(right_head_info[1])
            end
            cell:init(avatar_info)
            Panel_1_0:addChild(cell)
        elseif tonumber(right_head_info[1]) == -1  then
            Panel_1_0:setBackGroundImage(string.format(config_res.images.ui.props.tank, right_head_info[2]))
        elseif tonumber(right_head_info[1]) == -2  then
            local avatar_info = {}
            local cell = PlayerHeadIcon:createCell()
            avatar_info.object = ""
            avatar_info.vip = 0
            avatar_info._type = 1
            avatar_info._mould_id = tonumber(right_head_info[2])
            cell:init(avatar_info)
            Panel_1_0:addChild(cell)
        end
    end
end

-- 显示配件、装甲具体信息
function MailPresentationInfo:addEquipmentShowInfo(show_type, my_info, enemy_info)
    local csbItem = csb.createNode(string.format(config_csb.cells.mail.mail_presentation_cell, 11))
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)

    for i = 1, 4 do
        local Text_parts_me_t = ccui.Helper:seekWidgetByName(root,"Text_parts_me_t_"..i)
        local Text_parts_me_n = ccui.Helper:seekWidgetByName(root,"Text_parts_me_n_"..i)
        local Text_parts_enemy_t = ccui.Helper:seekWidgetByName(root,"Text_parts_enemy_t_"..i)
        local Text_parts_enemy_n = ccui.Helper:seekWidgetByName(root,"Text_parts_enemy_n_"..i)

        local color = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
        if show_type == 1 and i <= 3 then
            Text_parts_me_t:setString(mail_tip_text[66 + i])
            Text_parts_enemy_t:setString(mail_tip_text[66 + i])
            Text_parts_me_n:setString(my_info[i])
            Text_parts_enemy_n:setString(enemy_info[i])
            color = cc.c3b(color_Type[i + 1][1], color_Type[i + 1][2], color_Type[i + 1][3])
        elseif show_type == 2 then
            Text_parts_me_t:setString(mail_tip_text[69 + i])
            Text_parts_enemy_t:setString(mail_tip_text[69 + i])
            Text_parts_me_n:setString(my_info[i])
            Text_parts_enemy_n:setString(enemy_info[i])
            color = cc.c3b(color_Type[i][1], color_Type[i][2], color_Type[i][3])
        end

        Text_parts_me_t:setColor(color)
        Text_parts_me_n:setColor(color)
        Text_parts_enemy_t:setColor(color)
        Text_parts_enemy_n:setColor(color)
        if show_type == 1 and i == 4 then
            Text_parts_me_t:setVisible(false)
            Text_parts_me_n:setVisible(false)
            Text_parts_enemy_t:setVisible(false)
            Text_parts_enemy_n:setVisible(false)
        end
    end

    return root
end

-- 显示将领具体信息
function MailPresentationInfo:addLeaderShowInfo(my_leader_info, enemy_leader_info)
    local csbItem = csb.createNode(string.format(config_csb.cells.mail.mail_presentation_cell, 13))
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)

    for i = 1, 6 do
        local Text_leader_me_t = ccui.Helper:seekWidgetByName(root, "Text_leader_me_t_"..i)
        local Text_leader_me_n = ccui.Helper:seekWidgetByName(root, "Text_leader_me_n_"..i)
        local Text_leader_enemy_t = ccui.Helper:seekWidgetByName(root, "Text_leader_enemy_t_"..i)
        local Text_leader_enemy = ccui.Helper:seekWidgetByName(root, "Text_leader_enemy_"..i)

        if my_leader_info ~= nil and my_leader_info[i] ~= nil and my_leader_info[i].leader_id > 0 then
            local ship_name = dms.string(dms["ship_mould"], my_leader_info[i].leader_id, ship_mould.captain_name)
            local quality = dms.int(dms["ship_mould"], my_leader_info[i].leader_id, ship_mould.ship_type)

            Text_leader_me_t:setString(""..i.."."..ship_name..friends_tip_string[12]..my_leader_info[i].level)
            Text_leader_me_t:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
            Text_leader_me_n:setString(""..my_leader_info[i].accessories)
            Text_leader_me_n:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
        else
            Text_leader_me_t:setString(""..i..".")
            Text_leader_me_t:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            Text_leader_me_n:setString("")
            Text_leader_me_n:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        end

        if enemy_leader_info ~= nil and enemy_leader_info[i] ~= nil and enemy_leader_info[i].leader_id > 0 then
            local ship_name = dms.string(dms["ship_mould"], enemy_leader_info[i].leader_id, ship_mould.captain_name)
            local quality = dms.int(dms["ship_mould"], enemy_leader_info[i].leader_id, ship_mould.ship_type)

            Text_leader_enemy_t:setString(""..i.."."..ship_name..friends_tip_string[12]..enemy_leader_info[i].level)
            Text_leader_enemy_t:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
            Text_leader_enemy:setString(""..enemy_leader_info[i].accessories)
            Text_leader_enemy:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
        else
            Text_leader_enemy_t:setString(""..i..".")
            Text_leader_enemy_t:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            Text_leader_enemy:setString("")
            Text_leader_enemy:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        end
    end

    return root
end

-- 配件强度信息
function MailPresentationInfo:updateEquipmentInfo()
    if self._info_panel_root == nil then
        local csbItem = csb.createNode(string.format(config_csb.cells.mail.mail_presentation_cell, 14))
        local root = csbItem:getChildByName("root")
        root:removeFromParent(false)
        self._list_view:addChild(root)
        self._info_panel_root = root
    end
    local root = self._info_panel_root
    local Panel_parts_fight_tit_k = ccui.Helper:seekWidgetByName(root, "Panel_parts_fight_tit_k")
    Panel_parts_fight_tit_k:removeAllChildren(true)

    local cell_tables = {}

    if self._mail_data.mail_params==nil then
        local attachedInfo = zstring.split(self._mail_data.param, "|")
        self._mail_data.mail_params = {}
        self._mail_data.mail_params.mail_type = attachedInfo[1]
    end
    -- 配件
    local AccessoriesDatas = zstring.split(_ED.report_reward_info[2], "|") 
    local myAccessories = nil
    local otherAccessories = nil
    if tonumber(self._mail_data.mail_params.mail_type) == 1 then
        myAccessories = zstring.split(AccessoriesDatas[2], ",") 
        otherAccessories = zstring.split(AccessoriesDatas[1], ",") 
    else
        myAccessories = zstring.split(AccessoriesDatas[1], ",") 
        otherAccessories = zstring.split(AccessoriesDatas[2], ",") 
    end
    local my_total = tonumber(myAccessories[1])+tonumber(myAccessories[2])+tonumber(myAccessories[3])
    local enemy_total = tonumber(otherAccessories[1])+tonumber(otherAccessories[2])+tonumber(otherAccessories[3])
    local cell = state_machine.excute("mail_presentation_info_cell_create", 0, {1, self._info_show[1], my_total, enemy_total})
    table.insert(cell_tables, cell)
    if self._info_show[1] == true then
        local cell = self:addEquipmentShowInfo(1, myAccessories, otherAccessories)
        table.insert(cell_tables, cell)
    end

    -- 装甲
    local AccessoriesDatas = zstring.split(_ED.report_reward_info[3], "|") 
    local myAccessories = nil
    local otherAccessories = nil
    if tonumber(self._mail_data.mail_params.mail_type) == 1 then
        myAccessories = zstring.split(AccessoriesDatas[2], ",") 
        otherAccessories = zstring.split(AccessoriesDatas[1], ",") 
    else
        myAccessories = zstring.split(AccessoriesDatas[1], ",") 
        otherAccessories = zstring.split(AccessoriesDatas[2], ",") 
    end
    local my_total = tonumber(myAccessories[1])+tonumber(myAccessories[2])+tonumber(myAccessories[3])+tonumber(myAccessories[4])
    local enemy_total = tonumber(otherAccessories[1])+tonumber(otherAccessories[2])+tonumber(otherAccessories[3])+tonumber(otherAccessories[4])
    local cell = state_machine.excute("mail_presentation_info_cell_create", 0, {2, self._info_show[2], my_total, enemy_total})
    table.insert(cell_tables, cell)
    if self._info_show[2] == true then
        local cell = self:addEquipmentShowInfo(2, myAccessories, otherAccessories)
        table.insert(cell_tables, cell)
    end

    -- 将领
    local myAccessories = nil
    local otherAccessories = nil
    local my_formation = nil
    local enemy_formation = nil

    if tonumber(self._mail_data.mail_params.mail_type) == 1 then
        myAccessories = _ED.report_reward_info[8]
        otherAccessories = _ED.report_reward_info[7]
        my_formation = _ED.report_reward_info[4]
        enemy_formation = _ED.report_reward_info[5]
    else
        myAccessories = _ED.report_reward_info[7]
        otherAccessories = _ED.report_reward_info[8]
        my_formation = _ED.report_reward_info[5]
        enemy_formation = _ED.report_reward_info[4]
    end

    local function getLeaderInfo(accessories, formation)
        if accessories == nil or formation == nil then
            return nil
        end
        local result = {}
        accessories_info = zstring.split(accessories, "|")
        formation_info = zstring.split(formation, "|")
        for i = 1, 6 do
            local info = {
                leader_id = 0,
                accessories = 0,
                level = 0,
            }
            local acc_info = zstring.split(accessories_info[i], ",")
            local force_info = zstring.split(formation_info[i], ",")
            if tonumber(force_info[7]) > 0 and tonumber(force_info[5]) > 0 then
                info.leader_id = tonumber(force_info[7])
            end
            info.accessories = tonumber(acc_info[1])
            info.level = tonumber(acc_info[2])
            table.insert(result, info)
        end
        return result
    end
    local my_leader_info = getLeaderInfo(myAccessories, my_formation)
    local enemy_leader_info = getLeaderInfo(otherAccessories, enemy_formation)
    my_total = 0
    enemy_total = 0
    if my_leader_info ~= nil and enemy_leader_info ~= nil then
        for i = 1, 6 do
            my_total = my_total + my_leader_info[i].accessories
            enemy_total = enemy_total + enemy_leader_info[i].accessories
        end
    end
    local cell = state_machine.excute("mail_presentation_info_cell_create", 0, {3, self._info_show[3], my_total, enemy_total})
    table.insert(cell_tables, cell)
    if self._info_show[3] == true then
        local cell = self:addLeaderShowInfo(my_leader_info, enemy_leader_info)
        table.insert(cell_tables, cell)
    end

    local height = 0
    for i = #cell_tables, 1, -1 do
        local cell = cell_tables[i]
        Panel_parts_fight_tit_k:addChild(cell)
        cell:setPositionY(height)
        height = height + cell:getContentSize().height
    end
    root:setContentSize(root:getContentSize().width, height)

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:setBounceTopBoundary(self._list_view:getContentSize().height)
end

-- 维修说明信息
function MailPresentationInfo:updateRepaireInfo()
    local csbItem = csb.createNode(string.format(config_csb.cells.mail.mail_presentation_cell, 5))
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self._list_view:addChild(root)
end

-- 部队损耗信息
function MailPresentationInfo:updateLostInfo(formation_type, lost_type)
    local csbItem = csb.createNode(config_csb.cells.world.troops_formation_all_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self._list_view:addChild(root)
    local forceData = {}
    if _ED.report_reward_info[lost_type+4] ~= nil then
	   forceData = zstring.split(_ED.report_reward_info[lost_type+4], "|")
    end
	local attachedInfo = zstring.split(self._mail_data.param, "|")
	local attachedOne = zstring.split(attachedInfo[2], ",")
	if self._mail_data.mail_params.Attack_side == nil then
		self._mail_data.mail_params.Attack_side = {}
		self._mail_data.mail_params.Attack_side.attack_type = attachedOne[8]
	end
    local Image_formation_t_1 = ccui.Helper:seekWidgetByName(root,"Image_formation_t_1")      -- 前排
    local Image_formation_t_2 = ccui.Helper:seekWidgetByName(root,"Image_formation_t_2")      -- 后排
    local Text_first_strike = ccui.Helper:seekWidgetByName(root,"Text_first_strike")        -- 先攻
    local Text_spy_presentation_troops_t = ccui.Helper:seekWidgetByName(root,"Text_spy_presentation_troops_t")      -- 部队信息
    local Text_spy_presentation_troops_n = ccui.Helper:seekWidgetByName(root,"Text_spy_presentation_troops_n")      -- 损耗信息

    local Panel_formation_box_back = ccui.Helper:seekWidgetByName(root,"Panel_formation_box_back")
    local Panel_formation_box_front = ccui.Helper:seekWidgetByName(root,"Panel_formation_box_front")
    local front_y = Panel_formation_box_front:getPositionY()
    local back_y = Panel_formation_box_back:getPositionY()

	if formation_type == 0 then
        Panel_formation_box_front:setPositionY(back_y)
        Panel_formation_box_back:setPositionY(front_y)
    else
        Panel_formation_box_front:setPositionY(front_y)
        Panel_formation_box_back:setPositionY(back_y)
	end
	local maxShip = 0
	local lackShip = 0
    for i = 1, 6 do
        local index = i
        local Text_formation_loss_n = ccui.Helper:seekWidgetByName(root,"Text_formation_loss_n_"..index) 				-- 损耗数量
        local Panel_formation_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_formation_tank_icon_"..index)        -- 坦克图标
        -- local Panel_formation_position = ccui.Helper:seekWidgetByName(root,"Panel_formation_position_"..index)          -- 攻击类型图标
        local Text_formation_tank_n = ccui.Helper:seekWidgetByName(root,"Text_formation_tank_n_"..index)                -- 损耗数量
        local Text_formation_tank_name = ccui.Helper:seekWidgetByName(root,"Text_formation_tank_name_"..index)          -- 坦克名称
        local Text_formation_leader_name = ccui.Helper:seekWidgetByName(root,"Text_formation_leader_name_"..index)      -- 将领名称
        local Panel_formation_leader_star = ccui.Helper:seekWidgetByName(root,"Panel_formation_leader_star_"..index)    -- 将领星级图标
        local Text_formation_leader_n = ccui.Helper:seekWidgetByName(root,"Text_formation_leader_n_"..index)            -- 无将领文本
        local Text_formation_n = ccui.Helper:seekWidgetByName(root,"Text_formation_n_"..index)
		local bg = ccui.Helper:seekWidgetByName(root,"Image_formation_loss_bg_"..index)

        Panel_formation_tank_icon:removeBackGroundImage()
        -- Panel_formation_position:removeBackGroundImage()
        Panel_formation_leader_star:removeBackGroundImage()
        Text_formation_n:setString(i)
        Text_formation_leader_n:setColor(cc.c3b(color_Type[11][1], color_Type[11][2], color_Type[11][3]))
        if forceData[i] ~= nil then
            local forceInfo = zstring.split(forceData[i], ",")
            if tonumber(forceInfo[2]) > 0 then
                local ships = nil
                local ship_type = 0
                
                if lost_type == 0 and
                    (tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 0 or
                    (tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 6 and self._mail_data.isNpc == true))
                    then
                    ships = dms.element(dms["environment_ship"], tonumber(forceInfo[2]))
                    ship_type = dms.atoi(ships, environment_ship.ship_type)+1
                    Panel_formation_tank_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, dms.atoi(ships, environment_ship.pic_index)))
                    -- Panel_formation_position:setBackGroundImage(string.format(config_res.images.ui.icon.icon, dms.atoi(ships, environment_ship.camp_preference)+114))
                    Text_formation_tank_name:setString(dms.atos(ships, environment_ship.ship_name))
                else
                    ships = dms.element(dms["ship_mould"], tonumber(forceInfo[2]))
                    ship_type = dms.atoi(ships, ship_mould.ship_type)+1
                    Panel_formation_tank_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, dms.atoi(ships, ship_mould.bust_index)))
                    -- Panel_formation_position:setBackGroundImage(string.format(config_res.images.ui.icon.icon, dms.atoi(ships, ship_mould.sign_msg)+114))
                    Text_formation_tank_name:setString(dms.atos(ships, ship_mould.captain_name))
                end
                
                Text_formation_tank_name:setColor(cc.c3b(color_Type[ship_type][1], color_Type[ship_type][2], color_Type[ship_type][3]))
    			bg:setVisible(true)
    			Text_formation_loss_n:setString("-"..(tonumber(forceInfo[5])-tonumber(forceInfo[3])).."/"..forceInfo[5])
    			local _richText1 = ccui.RichText:create()
    			_richText1:ignoreContentAdaptWithSize(false)
    			local color1 = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
    			local color2 = cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2])
    			local re1 =ccui.RichElementText:create(1, color2,255, "-"..(tonumber(forceInfo[5])-tonumber(forceInfo[3])), config_res.font.font_name,20)
    			_richText1:pushBackElement(re1)
    			local re2 =ccui.RichElementText:create(1, color1,255, "/"..forceInfo[5], config_res.font.font_name,20)
    			_richText1:pushBackElement(re2)
    			_richText1:setContentSize(cc.size(Text_formation_loss_n:getContentSize().width,Text_formation_loss_n:getContentSize().height))
    			_richText1:setAnchorPoint(0.5,0.5)
    			_richText1:setPosition(cc.p(Text_formation_loss_n:getContentSize().width/2+20,Text_formation_loss_n:getContentSize().height/2))
    			-- _richText1:setPositionX(Text_formation_loss_n:getContentSize().width/2+20)
    			Text_formation_loss_n:addChild(_richText1)
    			
    			local nsize = bg:getContentSize()
    			nsize.width = Text_formation_loss_n:getContentSize().width+1
    			-- bg:setContentSize(nsize)
    			Text_formation_loss_n:setString("")
    			maxShip = maxShip+tonumber(forceInfo[5])
    			lackShip = lackShip + (tonumber(forceInfo[5])-tonumber(forceInfo[3]))
    		end
    		if tonumber(forceInfo[5]) > 0 and tonumber(forceInfo[7]) > 0 then
    			local ship_name = dms.string(dms["ship_mould"], forceInfo[7], ship_mould.captain_name)
                local quality = dms.int(dms["ship_mould"], forceInfo[7], ship_mould.ship_type)
                local initial_rank_level = dms.int(dms["ship_mould"], forceInfo[7], ship_mould.initial_rank_level)
                Text_formation_leader_name:setString(ship_name)
                Text_formation_leader_name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
                Panel_formation_leader_star:setBackGroundImage(string.format(config_res.images.ui.icon.icon, initial_rank_level + 118))
    		    Text_formation_leader_n:setVisible(false)
            end
        end
    end
	local paramData = zstring.split(self._mail_data.param, "|")
	local teamInfo = nil
    local name_info = zstring.split(paramData[4], ",")
	if lost_type == 0 then
		teamInfo = zstring.split(paramData[3], ",")
        if name_info[1] ~= "" 
            and ((self._report_type == 200 or self._report_type == 1200) and tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 2)   -- 打基地才有协防
            then
            teamInfo[1] = name_info[1]
        end
    else
        teamInfo = zstring.split(paramData[2], ",")
    end
	Text_spy_presentation_troops_t:setString(teamInfo[1])
	local texts = ""
	local color = nil
	if lackShip == maxShip then
		color = cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2])
        if maxShip == 0 then
            --修改字符串拼写方式，防止英文替换不应该替换的
            --texts = string.gsub(arena_tip_text[10], "s", "0")
            texts = string.format(arena_tip_text[10], "0").."%"
        else
		    --texts = string.gsub(arena_tip_text[10], "s", "100")
            texts = string.format(arena_tip_text[10], "100").."%"
        end
	else
		color = cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2])
        local percent = math.ceil(lackShip*100/maxShip)
		--texts = string.gsub(arena_tip_text[26], "s", percent)
        texts = string.format(arena_tip_text[26], percent).."%"
	end
	Text_spy_presentation_troops_n:setColor(color)
	if lackShip == maxShip or maxShip == 0 then
		Text_spy_presentation_troops_n:setString(arena_tip_text[8].." "..texts)
	else
		Text_spy_presentation_troops_n:setString(arena_tip_text[9].." "..texts)
	end
	if Text_first_strike ~= nil then
		Text_first_strike:setVisible(false)
		if (zstring.tonumber(_ED.report_reward_info[6]) == 0 and lost_type == 1) 
			or (zstring.tonumber(_ED.report_reward_info[6]) == 1 and lost_type == 0) 
			then
			Text_first_strike:setVisible(true)
		end
	end
end

-- 协防结果信息
function MailPresentationInfo:updateDefenceResultInfo()
    local csbItem = csb.createNode(string.format(config_csb.cells.mail.mail_presentation_cell, 10))
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self._list_view:addChild(root)

    local Text_player_name_lv_1 = ccui.Helper:seekWidgetByName(root,"Text_player_name_lv_1")
    local Text_player_legion_1 = ccui.Helper:seekWidgetByName(root,"Text_player_legion_1")
    local Text_player_name_lv_2 = ccui.Helper:seekWidgetByName(root,"Text_player_name_lv_2")
    local Text_player_legion_2 = ccui.Helper:seekWidgetByName(root,"Text_player_legion_2")
    local Text_player_world_help_state = ccui.Helper:seekWidgetByName(root,"Text_player_world_help_state")

    local attachedInfo = zstring.split(self._mail_data.param, "|")
    local attachedOne = zstring.split(attachedInfo[2], ",")
    local attachedTwo = zstring.split(attachedInfo[3], ",")
    local defence_id = zstring.tonumber(attachedInfo[5])

    Text_player_name_lv_2:setString(attachedOne[1].." "..friends_tip_string[12]..attachedOne[3])
    Text_player_legion_2:setString(attachedOne[2])
    Text_player_name_lv_1:setString(attachedTwo[1].." "..friends_tip_string[12]..attachedTwo[3])
    Text_player_legion_1:setString(attachedTwo[2])
    
    if defence_id ~= tonumber(_ED.user_info.user_id) then
        if tonumber(attachedOne[8]) == 0 then
            Text_player_world_help_state:setString(mail_tip_text[61])
        else
            Text_player_world_help_state:setString(mail_tip_text[60])
        end
    else
        if tonumber(attachedTwo[8]) == 0 then
            Text_player_world_help_state:setString(mail_tip_text[61])       -- 撤离
        else
            Text_player_world_help_state:setString(mail_tip_text[60])       -- 返回
        end
    end
end

-- 协防阵容信息
function MailPresentationInfo:updateDefenceInfo()
    local cell = WorldMineLineListCell:createCell()
    cell:init(tonumber(self._report_type),self._mail_data,false)
    self._list_view:addChild(cell)
end

function MailPresentationInfo:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_presentation_arrow_down:setVisible(true)
        else
            self._Image_presentation_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_presentation_arrow_up:setVisible(true)
        else
            self._Image_presentation_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
    end
end

function MailPresentationInfo:onEnterTransitionFinish()

end

function MailPresentationInfo:onInit( )
    local csbItem = csb.createNode(config_csb.mail.mail_presentation_infor)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_mail_presentation_close"), nil, 
    {
        terminal_name = "mail_presentation_info_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    -- 回放
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_presentation_playback"), nil, 
    {
        terminal_name = "mail_presentation_info_playback", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
		cells = self,
    }, nil, 1)

    -- 查找
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_presentation_lookup"), nil, 
    {
        terminal_name = "mail_presentation_info_Find", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
		cells = self,
    }, nil, 1)

    -- 删除
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_presentation_delete"), nil, 
    {
        terminal_name = "mail_presentation_info_delete", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
		cells = self
    }, nil, 1)

    -- 邮件
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_presentation_mail"), nil, 
    {
        terminal_name = "mail_presentation_info_an_email", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    -- 进攻
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_presentation_attack"), nil, 
    {
        terminal_name = "mail_presentation_info_attack", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    -- 保存
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_mail_presentation_save"), nil, 
    {
        terminal_name = "mail_presentation_info_save", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
		cells = self,
    }, nil, 1)

    -- 分享
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_mail_presentation_share"), nil, 
    {
        terminal_name = "mail_presentation_info_open_share", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)
	
	--关闭分享
	ccui.Helper:seekWidgetByName(root,"Panel_share_close"):setSwallowTouches(false)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_share_close"), nil, 
    {
        terminal_name = "mail_presentation_info_close_share", 
        terminal_state = 0, 
    }, nil, 1)    
	
	-- 分享到聊天
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_share_legion_chat"), nil, 
    {
        terminal_name = "mail_presentation_info_share_chats", 
        terminal_state = 0, 
        touch_black = true,
		cells = self,
		chat_type = 14,
    }, nil, 1)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_share_world_chat"), nil, 
    {
        terminal_name = "mail_presentation_info_share_chats", 
        terminal_state = 0, 
        touch_black = true,
		cells = self,
		chat_type = 13,
    }, nil, 1)

    self._Image_presentation_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_presentation_arrow_down")
    self._Image_presentation_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_presentation_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_presentation_arrow_down:stopAllActions()
    self._Image_presentation_arrow_up:stopAllActions()
    playActions(self._Image_presentation_arrow_down)
    playActions(self._Image_presentation_arrow_up)
    self._Image_presentation_arrow_down:setVisible(false)
    self._Image_presentation_arrow_up:setVisible(false)

	self:onUpdateDraw()
	if self._report_type == 11 --战地争霸类型
        or self._report_type == 201
 		then 
		ccui.Helper:seekWidgetByName(root,"Button_mail_presentation_save"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_lookup"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_lookup"):setBright(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_mail"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_mail"):setBright(false)
	elseif self._report_type == 24 
        or self._report_type == 10001
        then
		ccui.Helper:seekWidgetByName(root,"Button_mail_presentation_save"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_lookup"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_lookup"):setBright(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_lookup"):setTitleText(mail_tip_text[27])
		ccui.Helper:seekWidgetByName(root,"Button_presentation_mail"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_mail"):setBright(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_delete"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_delete"):setBright(false)

        local Image_share_box = ccui.Helper:seekWidgetByName(root,"Image_share_box")
        local Button_share_world_chat = ccui.Helper:seekWidgetByName(root,"Button_share_world_chat")
        Image_share_box:setContentSize(Image_share_box:getContentSize().width, 130)
        Image_share_box:setPositionY(140)
        Button_share_world_chat:setVisible(false)

        if self._report_type == 10001 then
            local attachedInfo = zstring.split(self._mail_data.param, "|")
            local attackInfo = zstring.split(attachedInfo[2], ",")
            local defendInfo = zstring.split(attachedInfo[3], ",")
            if (attackInfo[1] ~= _ED.user_info.user_name and defendInfo[1] ~= _ED.user_info.user_name) then
                ccui.Helper:seekWidgetByName(root,"Button_mail_presentation_share"):setVisible(false)
            end
        end
	elseif self._report_type == 10003 
        or self._report_type == 10004 
        or self._report_type == 207 
        or self._report_type == 10000
        or self._report_type == 209
        or self._report_type == 10006
        or self._report_type == 210
        or self._report_type == 10007
        then
		ccui.Helper:seekWidgetByName(root,"Button_mail_presentation_save"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Button_mail_presentation_share"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_mail"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_mail"):setBright(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_delete"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_delete"):setBright(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_lookup"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_lookup"):setBright(false)
        if self._report_type == 210 then
            ccui.Helper:seekWidgetByName(root,"Button_mail_presentation_share"):setVisible(true)
        end
	elseif self._report_type == 202 then 
		ccui.Helper:seekWidgetByName(root,"Button_mail_presentation_save"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_mail"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_mail"):setBright(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_lookup"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_lookup"):setBright(false)
	else
		ccui.Helper:seekWidgetByName(root,"Button_mail_presentation_save"):setVisible(true)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_lookup"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_lookup"):setBright(true)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_mail"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_mail"):setBright(true)

        if (self._report_type == 200 
            and (tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 4 or tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 7))
            or (self._report_type == 200 and  tonumber(self._mail_data.mail_params.mail_type) == 3)
            or (self._report_type == 1200 and  tonumber(self._mail_data.mail_params.mail_type) == 3)
            then
            ccui.Helper:seekWidgetByName(root,"Button_mail_presentation_share"):setVisible(false)
        end

        if (self._report_type == 200 and  
            (tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 4
            or tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 7)) then      -- 采集报告
            local Button_presentation_playback = ccui.Helper:seekWidgetByName(root,"Button_presentation_playback")
            local Button_presentation_lookup = ccui.Helper:seekWidgetByName(root,"Button_presentation_lookup")
            local Button_presentation_delete = ccui.Helper:seekWidgetByName(root,"Button_presentation_delete")
            local Button_presentation_mail = ccui.Helper:seekWidgetByName(root,"Button_presentation_mail")
            local Button_presentation_attack = ccui.Helper:seekWidgetByName(root,"Button_presentation_attack")
            Button_presentation_playback:setVisible(false)
            Button_presentation_mail:setVisible(false)
            Button_presentation_attack:setVisible(true)

            local posX_1 = (Button_presentation_playback:getPositionX() + Button_presentation_lookup:getPositionX()) / 2
            local posX_2 = (Button_presentation_lookup:getPositionX() + Button_presentation_delete:getPositionX()) / 2
            local posX_3 = (Button_presentation_delete:getPositionX() + Button_presentation_mail:getPositionX()) / 2
            Button_presentation_lookup:setPositionX(posX_1)
            Button_presentation_delete:setPositionX(posX_2)
            Button_presentation_attack:setPositionX(posX_3)
        end
	end
	-- ccui.Helper:seekWidgetByName(root,"Button_presentation_mail"):setBright(false)
	local isOnceHaveNotTank = false
	if _ED.report_reward_info ~= nil then
		local isAttackHaveHero = false
		local isDefendHaveHero = false
		if _ED.report_reward_info[4] ~= nil then
			local forceData = zstring.split(_ED.report_reward_info[4], "|")
			if forceData ~= nil then
				for i=1,6 do
					local forceInfo = zstring.split(forceData[i], ",")
					if zstring.tonumber(forceInfo[2]) > 0 then
						isAttackHaveHero = true
						break
					end
				end
			end
		end
		if _ED.report_reward_info[5] ~= nil then
			local forceData = zstring.split(_ED.report_reward_info[5], "|")
			if forceData ~= nil then
				for i=1,6 do
					local forceInfo = zstring.split(forceData[i], ",")
					if zstring.tonumber(forceInfo[2]) > 0 then
						isDefendHaveHero = true
						break
					end
				end
			end
		end
		if isAttackHaveHero == false or isDefendHaveHero == false then
			isOnceHaveNotTank = true
		end
	end
	local attachedInfo = zstring.split(self._mail_data.param, "|")
	local attachedOne = zstring.split(attachedInfo[2], ",")
	if (self._mail_data.mail_params ~= nil and tonumber(self._mail_data.mail_params.mail_type) == 3)
        or isOnceHaveNotTank == true 
        or (attachedOne[8] ~= nil and tonumber(attachedOne[8]) == 4) 
        then
		ccui.Helper:seekWidgetByName(root,"Button_presentation_playback"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_playback"):setBright(false)
	end
	if self._mtype == 10 then
		ccui.Helper:seekWidgetByName(root,"Button_mail_presentation_save"):setVisible(false)
	end
	
	if self._mtype == 100 then
		ccui.Helper:seekWidgetByName(root,"Button_mail_presentation_share"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Button_mail_presentation_save"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_lookup"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_lookup"):setBright(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_delete"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_delete"):setBright(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_mail"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root,"Button_presentation_mail"):setBright(false)
	end
end

function MailPresentationInfo:init(params)    
    self._mail_data = params[1]
	self._report_type = tonumber(params[2])
	self._mtype = tonumber(params[3]) or 0
	self:onInit()
    return self
end

function MailPresentationInfo:onExit()
    state_machine.remove("mail_presentation_info_delete")
    state_machine.remove("mail_presentation_info_playback")
    state_machine.remove("mail_presentation_info_save")
    state_machine.remove("mail_presentation_info_Find")
    state_machine.remove("mail_presentation_info_open_share")
    state_machine.remove("mail_presentation_info_close_share")
    state_machine.remove("mail_presentation_info_share_chats")
    state_machine.remove("mail_presentation_info_an_email")
    state_machine.remove("mail_presentation_info_attack")
    state_machine.remove("mail_presentation_info_show_equipment_info")
end
