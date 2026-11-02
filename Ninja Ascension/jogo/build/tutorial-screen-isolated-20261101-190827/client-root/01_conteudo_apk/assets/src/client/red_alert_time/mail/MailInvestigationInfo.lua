-- ----------------------------------------------------------------------------------------------------
-- 说明：邮件侦察结果
-------------------------------------------------------------------------------------------------------
MailInvestigationInfo = class("MailInvestigationInfoClass", Window)

local mail_investigation_info_open_terminal = {
    _name = "mail_investigation_info_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("MailInvestigationInfoClass")
        if nil == _homeWindow then
    		fwin:open(MailInvestigationInfo:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local mail_investigation_info_close_terminal = {
    _name = "mail_investigation_info_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("MailInvestigationInfoClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("MailInvestigationInfoClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(mail_investigation_info_open_terminal)
state_machine.add(mail_investigation_info_close_terminal)
state_machine.init()
    
function MailInvestigationInfo:ctor()
    self.super:ctor()
    self.roots = {}
	self.m_object = nil
	self.m_Listview = nil
	self.isSave = false
	self.is_union_member = false
	
	app.load("client.red_alert_time.cells.worldMap.world_mine_line_list_cell")

	local function init_mail_investigation_info_terminal()
		-- 定位
        local mail_investigation_info_location_terminal = {
            _name = "mail_investigation_info_location",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				local attachedInfo = zstring.split(self.m_object.param, "|")
				local attachedOne = zstring.split(attachedInfo[2], ",")
				state_machine.excute("mail_investigation_info_close", 0, 0)
				state_machine.excute("mail_window_close", 0, 0)
				state_machine.excute("home_button_select_page", 0, {_datas = {select_page = 2}})
				state_machine.excute("adventure_mine_record_view_position", 0, {tonumber(attachedOne[5]),tonumber(attachedOne[6])})
				state_machine.excute("adventure_mine_update_view_position", 0, 0)

                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("adventure_mine_cell_focus_blink", 0, _ED.world_map_focus)
                    end
                end
				
				_ED.world_map_focus = {attachedOne[5], attachedOne[6]}
                protocol_command.world_map_arena_info_refresh.param_list = "" .. tonumber(attachedOne[5]) .. "\r\n" ..  tonumber(attachedOne[6])
                NetworkManager:register(protocol_command.world_map_arena_info_refresh.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 进攻
        local mail_investigation_info_attack_terminal = {
            _name = "mail_investigation_info_attack",
            _init = function (terminal)
				app.load("client.red_alert_time.formation.Formation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	self.m_object.info = {}
            	self.m_object.info._mould_id = self.m_object.mail_params.Defensive_side.mine_mould_id
            	self.m_object.info._x = self.m_object.mail_params.Defensive_side.attack_print_x
            	self.m_object.info._y = self.m_object.mail_params.Defensive_side.attack_print_y
				-- state_machine.excute("formation_window_open", 0, {_datas = {form_type = 2, attack_cell = self.m_object.info ,playersOrmine = 0}})
                if instance.is_union_member == true then
                    state_machine.excute("formation_window_open", 0, {_datas = {form_type = 2, attack_cell = instance.m_object.info ,playersOrmine = 6}})
                else
                    state_machine.excute("formation_window_open", 0, {_datas = {form_type = 2, attack_cell = instance.m_object.info ,playersOrmine = 0}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 删除
        local mail_investigation_info_delete_terminal = {
            _name = "mail_investigation_info_delete",
            _init = function (terminal)
				-- app.load("client.red_alert_time.formation.Formation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if tonumber(instance.mType) ~= 10 then
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil then
								--清除
								for i, v in pairs(_ED.city_resource_battle_report[tonumber(instance.m_object.nType)]) do
									if tonumber(v.time) == tonumber(instance.m_object.time) then
										_ED.city_resource_battle_report[tonumber(instance.m_object.nType)][i] = nil
									end
								end
								state_machine.excute("mail_presentation_investigation_update_all",0,0)
								state_machine.excute("mail_investigation_info_close",0,0)
							end
						end	
					end
					protocol_command.delete_message.param_list = instance.m_object.nType.."\r\n"..instance.m_object.time
					NetworkManager:register(protocol_command.delete_message.code, nil, nil, nil, self, responseCallback, false, nil)
				else
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil then
								--清除
								for i, v in pairs(_ED.city_resource_battle_save_report) do
									if tonumber(v.time) == tonumber(instance.m_object.time) then
										_ED.city_resource_battle_save_report[i] = nil
									end
								end
								state_machine.excute("mail_save_the_box_update_draw",0,0)
								state_machine.excute("mail_investigation_info_close",0,0)
							end
						end
					end
					protocol_command.battlefield_report_save_delete.param_list = instance.m_object.time
					NetworkManager:register(protocol_command.battlefield_report_save_delete.code, nil, nil, nil, self, responseCallback, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--保存
		local mail_investigation_info_save_terminal = {
            _name = "mail_investigation_info_save",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                if self.isSave == false then
                	local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil then
								TipDlg.drawTextDailog(mail_tip_text[15])
								self:onUpdateButton()
							end
						end
	                end
                	protocol_command.battlefield_report_save.param_list = self.m_object.nType.."\r\n"..self.m_object.time
                	NetworkManager:register(protocol_command.battlefield_report_save.code, nil, nil, nil, self, responseCallback, false, nil)
            	else
            		local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil then
								--清除
								for i, v in pairs(_ED.city_resource_battle_save_report) do
									if tonumber(v.time) == tonumber(self.m_object.time) then
										_ED.city_resource_battle_save_report[i] = nil
									end
								end
								self:onUpdateButton()
								TipDlg.drawTextDailog(mail_tip_text[26])
							end
						end
					end
					protocol_command.battlefield_report_save_delete.param_list = self.m_object.time
					NetworkManager:register(protocol_command.battlefield_report_save_delete.code, nil, nil, nil, self, responseCallback, false, nil)
            	end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(mail_investigation_info_location_terminal)
        state_machine.add(mail_investigation_info_attack_terminal)
        state_machine.add(mail_investigation_info_save_terminal)
        state_machine.add(mail_investigation_info_delete_terminal)
	
		state_machine.init()
	end
	
	init_mail_investigation_info_terminal()
end

function MailInvestigationInfo:init(params)
	self.m_object = params[1]
	self.mType = params[3] or nil
    self:onInit()
    return self
end
function MailInvestigationInfo:getTimeFormatYMDHMS( m_time )
	local temp = os.date("*t",getBaseGTM8Time(m_time))

	local m_month 	= string.format("%02d", temp.month)
	local m_day 	= string.format("%02d", temp.day)
	local m_hour 	= string.format("%02d", temp.hour)
	local m_min 	= string.format("%02d", temp.min)
	local m_sec 	= string.format("%02d", temp.sec)


	local timeString = temp.year ..".".. m_month ..".".. m_day .." ".. m_hour ..":".. m_min ..":".. m_sec


    return timeString
end

function MailInvestigationInfo:onUpdateButton()
	local root = self.roots[1]
	self.isSave = false
	local Button_spy_presentation_save = ccui.Helper:seekWidgetByName(root,"Button_spy_presentation_save")
	if _ED.city_resource_battle_save_report == nil or #_ED.city_resource_battle_save_report <= 1 then
		local function responseCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
					for i,v in pairs(_ED.city_resource_battle_save_report) do
						if tonumber(v.time) == tonumber(self.m_object.time) and tonumber(v.nType) == tonumber(self.m_object.nType) then
							response.node.isSave = true
						end	
					end
					if response.node.isSave == true then
						Button_spy_presentation_save:setTitleText(mail_tip_text[23])
					else
						Button_spy_presentation_save:setTitleText(mail_tip_text[22])
					end
				end
			end
		end
		NetworkManager:register(protocol_command.battlefield_report_save_get.code, nil, nil, nil, self, responseCallback, false, nil)
	else
		for i,v in pairs(_ED.city_resource_battle_save_report) do
			if tonumber(v.time) == tonumber(self.m_object.time) and tonumber(v.nType) == tonumber(self.m_object.nType) then
				self.isSave = true
			end	
		end
		if self.isSave == true then
			Button_spy_presentation_save:setTitleText(mail_tip_text[23])
		else
			Button_spy_presentation_save:setTitleText(mail_tip_text[22])
		end
	end
end

function MailInvestigationInfo:onUpdateDraw()
	local root = self.roots[1]
	local Text_spy_t_n = ccui.Helper:seekWidgetByName(root,"Text_spy_t_n")--侦察了谁
	local Text_spy_base = ccui.Helper:seekWidgetByName(root,"Text_spy_base")--侦察了什么
	local Text_predatory_n = ccui.Helper:seekWidgetByName(root,"Text_predatory_n")--可以被掠夺多少
	local Text_spy_presentation_player = ccui.Helper:seekWidgetByName(root,"Text_spy_presentation_player")--所有者
	Text_spy_presentation_player:removeAllChildren(true)
	local Text_spy_base_n = ccui.Helper:seekWidgetByName(root,"Text_spy_base_n")--有无驻军
	local Text_spy_base_time = ccui.Helper:seekWidgetByName(root,"Text_spy_base_time")--时间
	Text_spy_base_time:setString(self:getTimeFormatYMDHMS(tonumber(self.m_object.time)/1000))
    Text_spy_base_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
	local attachedInfo = zstring.split(self.m_object.param, "|")
	local attachedOne = zstring.split(attachedInfo[2], ",")
	local help_defence = zstring.split(attachedInfo[5], ",")
	local _richText1 = ccui.RichText:create()
	_richText1:ignoreContentAdaptWithSize(false)
	local color1 = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
	local color2 = cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2])
	local colorInfo = cc.c3b(color_Type[tonumber(attachedOne[7])+1][1], color_Type[tonumber(attachedOne[7])+1][2], color_Type[tonumber(attachedOne[7])+1][3])
	if tonumber(attachedOne[7]) == 0 then
		colorInfo = color2
	end
	local re1 = nil
	local re2 = nil
	local re3 = nil
	local re4 = nil
	local re5 = nil
	local attachedTwo = zstring.split(attachedInfo[3], ",")
	local textinfo = zstring.split(mail_tip_text[13], "!x@")
	if tonumber(attachedTwo[8]) == 0 then				--看基地
		Text_spy_base:setString(mail_tip_text[6]) 
		re2 = ccui.RichElementText:create(1, color2,255, attachedOne[1].." "..friends_tip_string[12]..attachedOne[3]..string.format(mail_tip_text[10], attachedOne[5], attachedOne[6]), config_res.font.font_name,20)
		re3 = ccui.RichElementText:create(1, color1,255, textinfo[2], config_res.font.font_name,20)
		re4 = ccui.RichElementText:create(1, color2,255, textinfo[3], config_res.font.font_name,20)
		ccui.Helper:seekWidgetByName(root,"Panel_res_spy_yield"):setVisible(false)
		for i=1,5 do
			local Panel_predatory_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_predatory_res_icon_"..i)
			Panel_predatory_res_icon:setBackGroundImage("images/ui/icon/icon_1.png")
			local sprite = nil
			if i==1 then
				sprite = cc.Sprite:create(config_res.images.ui.home.icon_iron_ore)
			elseif i==2 then
				sprite = cc.Sprite:create(config_res.images.ui.home.icon_petroeum)
			elseif i==3 then
				sprite = cc.Sprite:create(config_res.images.ui.home.icon_lead_ore)
			elseif i==4 then
				sprite = cc.Sprite:create(config_res.images.ui.home.icon_titanium_ore)
			elseif i==5 then
				sprite = cc.Sprite:create(config_res.images.ui.home.icon_gemstone)
			end
			sprite:setAnchorPoint(cc.p(0.5,0.5))
			sprite:setPosition(cc.p((Panel_predatory_res_icon:getContentSize().width/2 ), (Panel_predatory_res_icon:getContentSize().height) / 2))
			Panel_predatory_res_icon:addChild(sprite)
		end
		local datas = zstring.split(_ED.report_reward_info[1], ",")
		--铁
		local Text_predatory_res_n_1 = ccui.Helper:seekWidgetByName(root,"Text_predatory_res_n_1")
		Text_predatory_res_n_1:setString(exChangeNumToString(tonumber(datas[1])))
		--油
		local Text_predatory_res_n_2 = ccui.Helper:seekWidgetByName(root,"Text_predatory_res_n_2")
		Text_predatory_res_n_2:setString(exChangeNumToString(tonumber(datas[2])))
		--铝
		local Text_predatory_res_n_3 = ccui.Helper:seekWidgetByName(root,"Text_predatory_res_n_3")
		Text_predatory_res_n_3:setString(exChangeNumToString(tonumber(datas[3])))
		--钛
		local Text_predatory_res_n_4 = ccui.Helper:seekWidgetByName(root,"Text_predatory_res_n_4")
		Text_predatory_res_n_4:setString(exChangeNumToString(tonumber(datas[4])))
		--宝石
		local Text_predatory_res_n_5 = ccui.Helper:seekWidgetByName(root,"Text_predatory_res_n_5")
		Text_predatory_res_n_5:setString(exChangeNumToString(tonumber(datas[5])))

		Text_predatory_n:setString(exChangeNumToString(tonumber(datas[1])+tonumber(datas[2])+tonumber(datas[3])+tonumber(datas[4])+tonumber(datas[5])))
		if _ED.union.union_info == nil 
            or _ED.union.union_info == {} 
            or _ED.union.union_info.union_id == nil 
            or _ED.union.union_info.union_id == "" 
            or tonumber(_ED.union.union_info.union_id) == 0 
            or _ED.union.union_info.union_name ~= attachedOne[2]
            then
            self.is_union_member = false
        else
            self.is_union_member = true
        end
        local Button_spy_attack = ccui.Helper:seekWidgetByName(root,"Button_spy_attack")
        if self.is_union_member == false then
            Button_spy_attack:setTitleText(formation_type_string[13])
            Button_spy_attack:setVisible(true)
        else
            Button_spy_attack:setTitleText(formation_type_string[39])
            Button_spy_attack:setVisible(true)
        end
	else			--看矿
		Text_spy_base:setString(mail_tip_text[5]) 
		local element = dms.element(dms["world_mine_mould"], tonumber(attachedOne[4]))
		if attachedTwo[1] ~= "" then
            Text_spy_base_n:setString(tipStringInfo_consumption_info[8])
			re2 = ccui.RichElementText:create(1, color2,255, attachedOne[1].." "..friends_tip_string[12]..attachedOne[3], config_res.font.font_name,20)
			re3 = ccui.RichElementText:create(1, color1,255, textinfo[2], config_res.font.font_name,20)
			re4 = ccui.RichElementText:create(1, colorInfo,255, dms.atos(element, world_mine_mould.name).." "..friends_tip_string[12]..dms.atos(element, world_mine_mould.level)..string.format(mail_tip_text[10], attachedOne[5], attachedOne[6]), config_res.font.font_name,20)
		else
            Text_spy_base_n:setString(tipStringInfo_consumption_info[9])
			re2 = ccui.RichElementText:create(1, colorInfo,255, dms.atos(element, world_mine_mould.name).." "..friends_tip_string[12]..dms.atos(element, world_mine_mould.level)..string.format(mail_tip_text[10], attachedOne[5], attachedOne[6]), config_res.font.font_name,20)
		end
		--产出的资源
		local Panel_res_spy_icon = ccui.Helper:seekWidgetByName(root,"Panel_res_spy_icon")
		local mine_type = dms.atos(element, world_mine_mould.mine_type)
		local m_image = nil
		if zstring.tonumber(mine_type) == 1 then
			m_image = config_res.images.ui.home.icon_iron_ore
		elseif zstring.tonumber(mine_type) == 2 then
			m_image = config_res.images.ui.home.icon_petroeum
		elseif zstring.tonumber(mine_type) == 3 then
			m_image = config_res.images.ui.home.icon_lead_ore
		elseif zstring.tonumber(mine_type) == 4 then
			m_image = config_res.images.ui.home.icon_titanium_ore
		else
			m_image = config_res.images.ui.home.icon_gemstone
		end
		Panel_res_spy_icon:setBackGroundImage(m_image)
		--产量
		local Text_res_spy_yield_n = ccui.Helper:seekWidgetByName(root,"Text_res_spy_yield_n")
		local per_second_output = dms.atos(element, world_mine_mould.per_second_output)
		local second_info = zstring.split(per_second_output, ",")
		local Yield = zstring.tonumber(second_info[2])*3600
		Text_res_spy_yield_n:setString(exChangeNumToString(Yield).."/"..tipStringInfo_consumption_info[3])
		local datas = zstring.split(_ED.report_reward_info[1], ",")
		Text_predatory_n:setString(exChangeNumToString(zstring.tonumber(datas[1])+zstring.tonumber(datas[2])+zstring.tonumber(datas[3])+zstring.tonumber(datas[4])+zstring.tonumber(datas[5])))
	    local Text_res_spy_quality_yield = ccui.Helper:seekWidgetByName(root,"Text_res_spy_quality_yield")
        if tonumber(attachedOne[7]) == 0 then
            Text_res_spy_quality_yield:setString("")
        else
            Text_res_spy_quality_yield:setString(tipStringInfo_consumption_info[tonumber(attachedOne[7])+3])
            Text_res_spy_quality_yield:setColor(colorInfo)
        end
    end
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
	_richText1:setContentSize(cc.size(Text_spy_t_n:getContentSize().width,Text_spy_t_n:getContentSize().height))
	_richText1:setAnchorPoint(0,0.5)
	_richText1:setPosition(cc.p(-Text_spy_t_n:getContentSize().width/2,Text_spy_t_n:getContentSize().height/2))
	Text_spy_t_n:addChild(_richText1)	
	local name_info = ""
	local level_info = 0
	if help_defence[1] ~= "" then
		name_info = help_defence[1]
		level_info = help_defence[2]
	else
		name_info = attachedOne[1]
		level_info = attachedOne[3]
	end
	if tonumber(attachedTwo[8]) == 0 			--看基地
		or tonumber(attachedTwo[8]) == 6 		--看玩家占领的矿
		then

		local _richText = ccui.RichText:create()
		_richText:ignoreContentAdaptWithSize(false)
		if tonumber(attachedTwo[8]) == 6 then
			local re1_1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255, tipStringInfo_consumption_info[7], config_res.font.font_name, 22)
			_richText:pushBackElement(re1_1)
		end
		local re1_2 = ccui.RichElementText:create(1, cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]),255, name_info.." "..friends_tip_string[12]..level_info, config_res.font.font_name,22)
		_richText:pushBackElement(re1_2)
		if attachedOne[2] ~= "" then
			local re1_3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255, "["..attachedOne[2].."]", config_res.font.font_name, 22)
			_richText:pushBackElement(re1_3)
		end
		_richText:setPosition(cc.p(-Text_spy_presentation_player:getContentSize().width/2,Text_spy_presentation_player:getContentSize().height/2))
	    _richText:setContentSize(cc.size(Text_spy_presentation_player:getContentSize().width,Text_spy_presentation_player:getContentSize().height))
	    _richText:setAnchorPoint(0,0.5)
		Text_spy_presentation_player:addChild(_richText)

        Text_spy_base_n:setString(tipStringInfo_consumption_info[9])
        local forceData = zstring.split(_ED.report_reward_info[4], "|")
        for i=1,table.nums(forceData) do
            local forceInfo = zstring.split(forceData[i], ",")
            if tonumber(forceInfo[5]) > 0 then
                Text_spy_base_n:setString(tipStringInfo_consumption_info[8])
                break
            end
        end
        if help_defence[1] ~= "" then
            Text_spy_base_n:setString(tipStringInfo_consumption_info[27])
            Text_spy_base_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
        end
	else
		local _richText = ccui.RichText:create()
		_richText:ignoreContentAdaptWithSize(false)
		local re1_1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),255, tipStringInfo_consumption_info[7], config_res.font.font_name, 22)
		_richText:pushBackElement(re1_1)
		_richText:setPosition(cc.p(-Text_spy_presentation_player:getContentSize().width/2,Text_spy_presentation_player:getContentSize().height/2))
	    _richText:setContentSize(cc.size(Text_spy_presentation_player:getContentSize().width,Text_spy_presentation_player:getContentSize().height))
	    _richText:setAnchorPoint(0,0.5)
		Text_spy_presentation_player:addChild(_richText)
	end

	self:onUpdateButton()
end

function MailInvestigationInfo:onInit()
    local csbMailInvestigationInfo = csb.createNode(config_csb.world_map.spy_presentation)
    local root = csbMailInvestigationInfo:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbMailInvestigationInfo)
	
	self.m_Listview = ccui.Helper:seekWidgetByName(root,"ListView_spy_presentation")

    local attachedInfo = zstring.split(self.m_object.param, "|")
    local help_defence = zstring.split(attachedInfo[5], ",")
    local have_defence = false
	-- if help_defence[1] ~= "" then
 --        have_defence = true
 --    end
	local cell = WorldMineLineListCell:createCell()
	cell:init(tonumber(self.m_object.nType),self.m_object,have_defence)
	self.m_Listview:addChild(cell)
	self.m_Listview:setBounceTopBoundary(self.m_Listview:getContentSize().height)

	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_spy_presentation_close"), nil, 
    {
        terminal_name = "mail_investigation_info_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,3)
	
	--查找
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_spy_lookup"), nil, 
    {
        terminal_name = "mail_investigation_info_location",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
	
	--进攻
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_spy_attack"), nil, 
    {
        terminal_name = "mail_investigation_info_attack",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
	
	--保存
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_spy_presentation_save"), nil, 
    {
        terminal_name = "mail_investigation_info_save",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
	
	--删除
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_spy_delete"), nil, 
    {
        terminal_name = "mail_investigation_info_delete",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
	if tonumber(self.mType) == 10 then
		ccui.Helper:seekWidgetByName(root,"Button_spy_presentation_save"):setVisible(false)
	end
	
	self:onUpdateDraw()
end

function MailInvestigationInfo:onExit()
	
end