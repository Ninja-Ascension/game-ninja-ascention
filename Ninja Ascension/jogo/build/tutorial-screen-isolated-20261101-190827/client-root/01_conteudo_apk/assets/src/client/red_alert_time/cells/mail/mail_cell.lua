--------------------------------------------------------------------------------------------------------------
--  邮件cell
--------------------------------------------------------------------------------------------------------------
MailCell = class("MailCellClass", Window)
MailCell.__size = nil
--创建cell
local mail_create_cell_terminal = {
    _name = "mail_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = MailCell:new()
        local index = params[1]
        local mail_data = params[2]
        local ntype = params[3]
        cell:init(index, mail_data, ntype)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(mail_create_cell_terminal)
state_machine.init()

function MailCell:ctor()
	self.super:ctor()
	self.roots = {}

    self._index = 0
    self._mail_data = nil
    self._ntype = 0
    
    local function init_mail_cell_terminal()
        local mail_cell_click_terminal = {
            _name = "mail_cell_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                -- cell:setSelected()
				local function responseCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
							if tonumber(response.node._ntype) == 10 then
								if tonumber(response.node._mail_data.mail_params.mail_type) == 2 then
									local attachedInfo = zstring.split(response.node._mail_data.param, "|")
									local attachedOne = zstring.split(attachedInfo[2], ",")
									local attachedTwo = zstring.split(attachedInfo[3], ",")
									if tonumber(attachedTwo[8]) == 5 then				--看叛军
										state_machine.excute("mail_rebel_investigation_info_open", 0, {response.node._mail_data, tonumber(response.node._mail_data.nType), response.node._ntype})
									else
										state_machine.excute("mail_investigation_info_open", 0, {response.node._mail_data, tonumber(response.node._mail_data.nType), response.node._ntype})
									end
								else
									state_machine.excute("mail_presentation_info_window_open", 0, {response.node._mail_data, tonumber(response.node._mail_data.nType), response.node._ntype})
								end
							else
								for i, v in pairs(_ED.city_resource_battle_report[zstring.tonumber(response.node._mail_data.nType)]) do
									if zstring.tonumber(v.time) == zstring.tonumber(response.node._mail_data.time) then
										_ED.city_resource_battle_report[zstring.tonumber(response.node._mail_data.nType)][i].read_type = 1
										if _ED.mould_function_push_info["7"] ~= nil then
											local datas = zstring.split(_ED.mould_function_push_info["7"].params, ",")
											local m_type = 0 
											if tonumber(response.node._mail_data.nType) == 200 then
												m_type = 1
											elseif tonumber(response.node._mail_data.nType) == 1200 then
												m_type = 2
											elseif tonumber(response.node._mail_data.nType) == 10002 then
												m_type = 3
											end
											if datas[m_type] ~= nil then
												if zstring.tonumber(datas[m_type]) > 0 then
													datas[m_type] = zstring.tonumber(datas[m_type]) - 1
												end
											end
											_ED.mould_function_push_info["7"].params = ""..datas[1]..","..datas[2]..","..datas[3]
										end
										-- local attachedInfo = zstring.split(response.node._mail_data.param, "|")
										if tonumber(response.node._mail_data.mail_params.mail_type) == 2 then
											local attachedInfo = zstring.split(response.node._mail_data.param, "|")
											local attachedOne = zstring.split(attachedInfo[2], ",")
											local attachedTwo = zstring.split(attachedInfo[3], ",")
											if tonumber(attachedTwo[8]) == 5 then				--看叛军
												state_machine.excute("mail_rebel_investigation_info_open", 0, {response.node._mail_data, tonumber(response.node._mail_data.nType), response.node._ntype})
											else
												state_machine.excute("mail_investigation_info_open", 0, {response.node._mail_data, tonumber(response.node._mail_data.nType), response.node._ntype})
											end
										else
											state_machine.excute("mail_presentation_info_window_open", 0, {response.node._mail_data, tonumber(response.node._mail_data.nType), response.node._ntype})
										end
									end
								end
							end
							response.node:updateDraw()
						end	
						-- state_machine.excute("main_window_update_userinfo", 0, nil)
						state_machine.excute("notification_center_update", 0, "push_notification_mine_push")
						state_machine.excute("notification_center_update", 0, "push_notification_mine_in_box_push")
						state_machine.excute("notification_center_update", 0, "push_notification_mine_report_push")
						state_machine.excute("notification_center_update", 0, "push_notification_mine_report_attack")
						state_machine.excute("notification_center_update", 0, "push_notification_mine_report_defense")
						state_machine.excute("notification_center_update", 0, "push_notification_mine_report_scout")

                        state_machine.excute("mail_update_mail_count_info", 0, "")
					end
				end
				local ntype= 0
				if tonumber(cell._ntype) == 10 then
					ntype = 11000
				else
					ntype = tonumber(cell._mail_data.nType)
				end
				protocol_command.battlefield_report_details_get.param_list = ntype.."\r\n"..cell._mail_data.time
				NetworkManager:register(protocol_command.battlefield_report_details_get.code, nil, nil, nil, cell, responseCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		state_machine.add(mail_cell_click_terminal)
        state_machine.init()
    end
    
    init_mail_cell_terminal()
end

function MailCell:setSelected()
    local root = self.roots[1]
    local Image_line_icon = ccui.Helper:seekWidgetByName(root,"Image_line_icon")
    Image_line_icon:setVisible(false)
    local Image_line_icon_read = ccui.Helper:seekWidgetByName(root,"Image_line_icon_read")
    Image_line_icon_read:setVisible(true)
end

function MailCell:updateDraw()
    local root = self.roots[1]
    local Image_line_icon = ccui.Helper:seekWidgetByName(root,"Image_line_icon")
    local Image_line_icon_read = ccui.Helper:seekWidgetByName(root,"Image_line_icon_read")
    local Text_mail_name = ccui.Helper:seekWidgetByName(root,"Text_mail_name")
    local Panel_mail_icon = ccui.Helper:seekWidgetByName(root,"Panel_mail_icon")
	Panel_mail_icon:removeBackGroundImage()
    local Text_mail_infor = ccui.Helper:seekWidgetByName(root,"Text_mail_infor")
	Text_mail_infor:removeAllChildren(true)
    local Text_mail_time = ccui.Helper:seekWidgetByName(root,"Text_mail_time")
	
	-- local attachedInfo = zstring.split(self._mail_data.param, "|")
	-- local attachedOne = zstring.split(attachedInfo[2], ",")
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
	
	local image_name = nil
	if tonumber(self._mail_data.nType) == 203 
		or (tonumber(self._mail_data.nType) == 200 and self._mail_data.mail_params.Defensive_side ~= nil and tonumber(self._mail_data.mail_params.Defensive_side.attack_type) == 5)
		then
		local attachedInfo = zstring.split(self._mail_data.param, "|")
		local _richText_2 = ccui.RichText:create()
	    _richText_2:ignoreContentAdaptWithSize(false) 
	    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, mail_tip_text[8], "fonts/simhei.ttf",20)
	    _richText_2:pushBackElement(re1)  
	    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]),255, self._mail_data.mail_params.Defensive_side.name..friends_tip_string[12]..self._mail_data.mail_params.Defensive_side.level..string.format(mail_tip_text[10], self._mail_data.mail_params.Defensive_side.attack_print_x, self._mail_data.mail_params.Defensive_side.attack_print_y), "fonts/simhei.ttf",20)
	    _richText_2:pushBackElement(re2)
	    local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, tipStringInfo_consumption_info[2], "fonts/simhei.ttf",20)
	    _richText_2:pushBackElement(re3)
	    _richText_2:setPosition(cc.p(Text_mail_infor:getContentSize().width/2,Text_mail_infor:getContentSize().height/2))
	    _richText_2:setContentSize(cc.size(Text_mail_infor:getContentSize().width,20))
	    Text_mail_infor:addChild(_richText_2)
		--邮件类型
		if tonumber(self._mail_data.mail_params.mail_type) == 0 then   --//攻
			if tonumber(self._mail_data.result) == 1 then
				Text_mail_name:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
				Text_mail_name:setString(mail_tip_text[1]) --胜利
				image_name = string.format(config_res.images.ui.share.world_implement_icon, 1)
			else
				Text_mail_name:setColor(cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2]))
				Text_mail_name:setString(mail_tip_text[2]) --失败
				image_name = string.format(config_res.images.ui.share.world_implement_icon, 5)
			end
		elseif tonumber(self._mail_data.mail_params.mail_type) == 1 then	--//防守
			if tonumber(self._mail_data.result) == 1 then
				Text_mail_name:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
				Text_mail_name:setString(mail_tip_text[3]) --胜利
				image_name = string.format(config_res.images.ui.share.world_implement_icon, 6)
			else
				Text_mail_name:setColor(cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2]))
				Text_mail_name:setString(mail_tip_text[4]) --失败
				image_name = string.format(config_res.images.ui.share.world_implement_icon, 12)
			end
		elseif tonumber(self._mail_data.mail_params.mail_type) == 2 then   --//侦查	
			image_name = string.format(config_res.images.ui.share.world_implement_icon, 11)
			Text_mail_name:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
			-- local attachedTwo = zstring.split(attachedInfo[3], ",")
			local textinfo = zstring.split(mail_tip_text[13], "!x@")
			if tonumber(self._mail_data.mail_params.Defensive_side.attack_type) == 0 then	--看基地
				Text_mail_name:setString(mail_tip_text[6]) 
				re1 = ccui.RichElementText:create(1, color1,255, textinfo[1], config_res.font.font_name,20)
				re2 = ccui.RichElementText:create(1, color2,255, self._mail_data.mail_params.Attack_side.name.." "..friends_tip_string[12]..self._mail_data.mail_params.Attack_side.level..string.format(mail_tip_text[10], self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y), config_res.font.font_name,20)
				re3 = ccui.RichElementText:create(1, color1,255, textinfo[2], config_res.font.font_name,20)
				re4 = ccui.RichElementText:create(1, color2,255, textinfo[3], config_res.font.font_name,20)
			else			--看矿
				Text_mail_name:setString(mail_tip_text[5]) 
				local element = dms.element(dms["world_mine_mould"], tonumber(self._mail_data.mail_params.Attack_side.mine_mould_id))
				if self._mail_data.mail_params.Defensive_side.name ~= "" then
					re1 = ccui.RichElementText:create(1, color1,255, textinfo[1], config_res.font.font_name,20)
					re2 = ccui.RichElementText:create(1, color2,255, self._mail_data.mail_params.Attack_side.name.." "..friends_tip_string[12]..self._mail_data.mail_params.Attack_side.level, config_res.font.font_name,20)
					re3 = ccui.RichElementText:create(1, color1,255, textinfo[2], config_res.font.font_name,20)
					re4 = ccui.RichElementText:create(1, colorInfo,255, dms.atos(element, world_mine_mould.name).." "..friends_tip_string[12]..dms.atos(element, world_mine_mould.level)..string.format(mail_tip_text[10], self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y), config_res.font.font_name,20)
				else
					re1 = ccui.RichElementText:create(1, color1,255, textinfo[1], config_res.font.font_name,20)
					re2 = ccui.RichElementText:create(1, colorInfo,255, dms.atos(element, world_mine_mould.name).." "..friends_tip_string[12]..dms.atos(element, world_mine_mould.level)..string.format(mail_tip_text[10], self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y), config_res.font.font_name,20)
				end
			end
		end
	else
		--邮件类型
		if tonumber(self._mail_data.mail_params.mail_type) == 0 then   --//攻
			if tonumber(self._mail_data.result) == 1 then
				Text_mail_name:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
				Text_mail_name:setString(mail_tip_text[1]) --胜利
				image_name = string.format(config_res.images.ui.share.world_implement_icon, 1)
			else
				Text_mail_name:setColor(cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2]))
				Text_mail_name:setString(mail_tip_text[2]) --失败
				image_name = string.format(config_res.images.ui.share.world_implement_icon, 5)
			end
			if tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 4 and tonumber(self._mail_data.mail_params.Attack_side.mine_mould_id) ~= 0 then
				Text_mail_name:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
				Text_mail_name:setString(mail_tip_text[7]) --采集报告
				image_name = string.format(config_res.images.ui.share.world_implement_icon, 1)
				local element = dms.element(dms["world_mine_mould"], tonumber(self._mail_data.mail_params.Attack_side.mine_mould_id))
				local textinfo = zstring.split(mail_tip_text[9], "!x@")
				re1 = ccui.RichElementText:create(1, color1,255, textinfo[1], config_res.font.font_name,20)
				re3 = ccui.RichElementText:create(1, color1,255, textinfo[2], config_res.font.font_name,20)
				re2 = ccui.RichElementText:create(1, colorInfo,255, dms.atos(element, world_mine_mould.name).." "..friends_tip_string[12]..dms.atos(element, world_mine_mould.level)..string.format(mail_tip_text[10], self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y), config_res.font.font_name,20)
            else
				re1 = ccui.RichElementText:create(1, color1,255, mail_tip_text[8], config_res.font.font_name,20)
				if tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 0 then		--打矿
					local element = dms.element(dms["world_mine_mould"], tonumber(self._mail_data.mail_params.Attack_side.mine_mould_id))
					re2 = ccui.RichElementText:create(1, colorInfo,255, dms.atos(element, world_mine_mould.name).." "..friends_tip_string[12]..dms.atos(element, world_mine_mould.level)..string.format(mail_tip_text[10], self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y), config_res.font.font_name,20)		
				elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 1 then		--打有人的矿
					local element = dms.element(dms["world_mine_mould"], tonumber(self._mail_data.mail_params.Defensive_side.mine_mould_id))
					re2 = ccui.RichElementText:create(1, color2,255, self._mail_data.mail_params.Defensive_side.name.." "..friends_tip_string[12]..self._mail_data.mail_params.Defensive_side.level, config_res.font.font_name,20)
					re3 = ccui.RichElementText:create(1, color1,255, tipStringInfo_campaign_info[33], config_res.font.font_name,20)
                    re4 = ccui.RichElementText:create(1, colorInfo,255, dms.atos(element, world_mine_mould.name).." "..friends_tip_string[12]..dms.atos(element, world_mine_mould.level)..string.format(mail_tip_text[10], self._mail_data.mail_params.Defensive_side.attack_print_x, self._mail_data.mail_params.Defensive_side.attack_print_y), config_res.font.font_name,20)
				elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 2 then		--打基地
					local textinfo = zstring.split(mail_tip_text[11], "!x@")
					-- re2 = ccui.RichElementText:create(1, color1,255, textinfo[1], config_res.font.font_name,20)
					re3 = ccui.RichElementText:create(1, color2,255, self._mail_data.mail_params.Defensive_side.name.." "..friends_tip_string[12]..self._mail_data.mail_params.Defensive_side.level..string.format(mail_tip_text[10], self._mail_data.mail_params.Defensive_side.attack_print_x, self._mail_data.mail_params.Defensive_side.attack_print_y), config_res.font.font_name,20)
					re4 = ccui.RichElementText:create(1, color1,255, textinfo[2], config_res.font.font_name,20)
				elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 6 
                    or tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 7
                    then  
                    --城市战
                    local world_city_name = dms.string(dms["world_city_mould"], self._mail_data.mail_params.Attack_side.mine_mould_id, world_city_mould.name)
                    local level = dms.int(dms["world_city_mould"], self._mail_data.mail_params.Attack_side.mine_mould_id, world_city_mould.level)
                    local pos = zstring.split(dms.string(dms["world_city_mould"], self._mail_data.mail_params.Attack_side.mine_mould_id, world_city_mould.position), ",")
                    re2 = ccui.RichElementText:create(1, color2,255, world_city_name.." "..friends_tip_string[12]..level..string.format(mail_tip_text[10], pos[1], pos[2]), config_res.font.font_name,20)
                end
			end
		elseif tonumber(self._mail_data.mail_params.mail_type) == 1 then	--//防守
			if tonumber(self._mail_data.result) == 1 then
				Text_mail_name:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
				Text_mail_name:setString(mail_tip_text[3]) --胜利
				image_name = string.format(config_res.images.ui.share.world_implement_icon, 6)
			else
				Text_mail_name:setColor(cc.c3b(arena_color_Type[2][1], arena_color_Type[2][2], arena_color_Type[2][2]))
				Text_mail_name:setString(mail_tip_text[4]) --失败
				image_name = string.format(config_res.images.ui.share.world_implement_icon, 12)
			end
			local textinfo = zstring.split(mail_tip_text[12], "!x@")
			if tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 1 then
				local element = dms.element(dms["world_mine_mould"], tonumber(self._mail_data.mail_params.Attack_side.mine_mould_id))
				re1 = ccui.RichElementText:create(1, color1,255, textinfo[1], config_res.font.font_name,20)
				re2 = ccui.RichElementText:create(1, colorInfo,255, dms.atos(element, world_mine_mould.name).." "..friends_tip_string[12]..dms.atos(element, world_mine_mould.level), config_res.font.font_name,20)
				re3 = ccui.RichElementText:create(1, color1,255, textinfo[3], config_res.font.font_name,20)
				re4 = ccui.RichElementText:create(1, color2,255, self._mail_data.mail_params.Attack_side.name.." "..friends_tip_string[12]..self._mail_data.mail_params.Attack_side.level..string.format(mail_tip_text[10], self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y), config_res.font.font_name,20)
				re5 = ccui.RichElementText:create(1, color1,255, textinfo[4], config_res.font.font_name,20)
			elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 2 then
				local attachedInfo = zstring.split(self._mail_data.param, "|")
				local name_info = zstring.split(attachedInfo[4], ",")
                if zstring.tonumber(name_info[3]) == tonumber(_ED.user_info.user_id) then
			        if tonumber(self._mail_data.result) == 1 then
						Text_mail_name:setString(mail_tip_text[62]) --胜利
					else
						Text_mail_name:setString(mail_tip_text[63]) --失败
					end
			        re1 = ccui.RichElementText:create(1, color2,255, self._mail_data.mail_params.Defensive_side.name.." "..friends_tip_string[12]..self._mail_data.mail_params.Defensive_side.level, config_res.font.font_name,20)
					re2 = ccui.RichElementText:create(1, color2,255, textinfo[2], config_res.font.font_name,20)
					re3 = ccui.RichElementText:create(1, color1,255, textinfo[3], config_res.font.font_name,20)
					re4 = ccui.RichElementText:create(1, color2,255, self._mail_data.mail_params.Attack_side.name.." "..friends_tip_string[12]..self._mail_data.mail_params.Attack_side.level, config_res.font.font_name,20)
					re5 = ccui.RichElementText:create(1, color1,255, textinfo[4], config_res.font.font_name,20)
			    else
					re1 = ccui.RichElementText:create(1, color1,255, textinfo[1], config_res.font.font_name,20)
					re2 = ccui.RichElementText:create(1, color2,255, textinfo[2], config_res.font.font_name,20)
					re3 = ccui.RichElementText:create(1, color1,255, textinfo[3], config_res.font.font_name,20)
					re4 = ccui.RichElementText:create(1, color2,255, self._mail_data.mail_params.Attack_side.name.." "..friends_tip_string[12]..self._mail_data.mail_params.Attack_side.level..string.format(mail_tip_text[10], self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y), config_res.font.font_name,20)
					re5 = ccui.RichElementText:create(1, color1,255, textinfo[4], config_res.font.font_name,20)
			    end
			 elseif tonumber(self._mail_data.mail_params.Attack_side.attack_type) == 6 then
                local world_city_name = dms.string(dms["world_city_mould"], self._mail_data.mail_params.Attack_side.mine_mould_id, world_city_mould.name)
                local level = dms.int(dms["world_city_mould"], self._mail_data.mail_params.Attack_side.mine_mould_id, world_city_mould.level)
                local pos = zstring.split(dms.string(dms["world_city_mould"], self._mail_data.mail_params.Attack_side.mine_mould_id, world_city_mould.position), ",")
                re1 = ccui.RichElementText:create(1, color2,255, world_city_name.." "..friends_tip_string[12]..level..string.format(mail_tip_text[10], pos[1], pos[2]), config_res.font.font_name,20)
                re2 = ccui.RichElementText:create(1, color1,255, mail_tip_text[74], config_res.font.font_name,20)
                re3 = ccui.RichElementText:create(1, color2,255, self._mail_data.mail_params.Attack_side.name.." "..friends_tip_string[12]..self._mail_data.mail_params.Attack_side.level..string.format(mail_tip_text[10], self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y), config_res.font.font_name,20)
                re4 = ccui.RichElementText:create(1, color1,255, formation_type_string[13], config_res.font.font_name,20)
			end
			
		elseif tonumber(self._mail_data.mail_params.mail_type) == 2 then   --//侦查	
			image_name = string.format(config_res.images.ui.share.world_implement_icon, 11)
			Text_mail_name:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
			-- local attachedTwo = zstring.split(attachedInfo[3], ",")
			local textinfo = zstring.split(mail_tip_text[13], "!x@")
			if tonumber(self._mail_data.mail_params.Defensive_side.attack_type) == 0 
				or tonumber(self._mail_data.mail_params.Defensive_side.attack_type) == 5 then	--看基地
				Text_mail_name:setString(mail_tip_text[6]) 
				re1 = ccui.RichElementText:create(1, color1,255, textinfo[1], config_res.font.font_name,20)
				re2 = ccui.RichElementText:create(1, color2,255, self._mail_data.mail_params.Attack_side.name.." "..friends_tip_string[12]..self._mail_data.mail_params.Attack_side.level..string.format(mail_tip_text[10], self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y), config_res.font.font_name,20)
				re3 = ccui.RichElementText:create(1, color1,255, textinfo[2], config_res.font.font_name,20)
				re4 = ccui.RichElementText:create(1, color2,255, textinfo[3], config_res.font.font_name,20)
			else			--看矿
				Text_mail_name:setString(mail_tip_text[5]) 
				local element = dms.element(dms["world_mine_mould"], tonumber(self._mail_data.mail_params.Attack_side.mine_mould_id))
				if self._mail_data.mail_params.Defensive_side.name ~= "" then
					re1 = ccui.RichElementText:create(1, color1,255, textinfo[1], config_res.font.font_name,20)
					re2 = ccui.RichElementText:create(1, color2,255, self._mail_data.mail_params.Attack_side.name.." "..friends_tip_string[12]..self._mail_data.mail_params.Attack_side.level, config_res.font.font_name,20)
					re3 = ccui.RichElementText:create(1, color1,255, textinfo[2], config_res.font.font_name,20)
					re4 = ccui.RichElementText:create(1, colorInfo,255, dms.atos(element, world_mine_mould.name).." "..friends_tip_string[12]..dms.atos(element, world_mine_mould.level)..string.format(mail_tip_text[10], self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y), config_res.font.font_name,20)
				else
					re1 = ccui.RichElementText:create(1, color1,255, textinfo[1], config_res.font.font_name,20)
					re2 = ccui.RichElementText:create(1, colorInfo,255, dms.atos(element, world_mine_mould.name).." "..friends_tip_string[12]..dms.atos(element, world_mine_mould.level)..string.format(mail_tip_text[10], self._mail_data.mail_params.Attack_side.attack_print_x, self._mail_data.mail_params.Attack_side.attack_print_y), config_res.font.font_name,20)
				end
			end 
		elseif tonumber(self._mail_data.mail_params.mail_type) == 3 then   --//协防撤离	
			local param = zstring.split(self._mail_data.param, "|")
			Text_mail_name:setColor(cc.c3b(arena_color_Type[1][1], arena_color_Type[1][2], arena_color_Type[1][2]))
			image_name = string.format(config_res.images.ui.share.world_implement_icon, 1)
			local attachedOne = zstring.split(param[2], ",")
			local attachedTwo = zstring.split(param[3], ",")
            local defence_id = zstring.tonumber(param[5])
            if defence_id ~= tonumber(_ED.user_info.user_id) then
                if tonumber(attachedOne[8]) == 0 then
                    Text_mail_name:setString(mail_tip_text[55])
					re1 = ccui.RichElementText:create(1, color2,255, attachedTwo[1].." "..friends_tip_string[12]..attachedTwo[3]..string.format(mail_tip_text[10], attachedTwo[5],attachedTwo[6]), config_res.font.font_name,20)
					re2 = ccui.RichElementText:create(1, color1,255, mail_tip_text[59], config_res.font.font_name,20)
                else
                    Text_mail_name:setString(mail_tip_text[56])
					re1 = ccui.RichElementText:create(1, color1,255, mail_tip_text[57], config_res.font.font_name,20)
					re2 = ccui.RichElementText:create(1, color2,255, attachedOne[1].." "..friends_tip_string[12]..attachedOne[3]..string.format(mail_tip_text[10], attachedOne[5],attachedOne[6]), config_res.font.font_name,20)
					re3 = ccui.RichElementText:create(1, color1,255, mail_tip_text[58], config_res.font.font_name,20)
                end
            else
                if tonumber(attachedTwo[8]) == 0 then
                    Text_mail_name:setString(mail_tip_text[55])
					re1 = ccui.RichElementText:create(1, color2,255, attachedTwo[1].." "..friends_tip_string[12]..attachedTwo[3]..string.format(mail_tip_text[10], attachedTwo[5],attachedTwo[6]), config_res.font.font_name,20)
					re2 = ccui.RichElementText:create(1, color1,255, mail_tip_text[59], config_res.font.font_name,20)
                else
                    Text_mail_name:setString(mail_tip_text[56])
					re1 = ccui.RichElementText:create(1, color1,255, mail_tip_text[57], config_res.font.font_name,20)
					re2 = ccui.RichElementText:create(1, color2,255, attachedOne[1].." "..friends_tip_string[12]..attachedOne[3]..string.format(mail_tip_text[10], attachedOne[5],attachedOne[6]), config_res.font.font_name,20)
					re3 = ccui.RichElementText:create(1, color1,255, mail_tip_text[58], config_res.font.font_name,20)
                end
            end
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
	--
	local Image_mail_line = ccui.Helper:seekWidgetByName(root,"Image_mail_line")
	local Image_mail_line_read = ccui.Helper:seekWidgetByName(root,"Image_mail_line_read")
	Image_mail_line:setVisible(false)
	Image_mail_line_read:setVisible(false)
	Image_line_icon:setVisible(false)
	Image_line_icon_read:setVisible(false)
	Panel_mail_icon:setBackGroundImage(image_name)
	if self._ntype == 3 then
		Image_line_icon_read:setVisible(true)
        Image_mail_line_read:setVisible(true)
	else
		if zstring.tonumber(self._mail_data.read_type) == 0 then
		    --未读
	        Image_line_icon:setVisible(true)
	        Image_mail_line:setVisible(true)
	    else
	        --已读
	        Image_line_icon_read:setVisible(true)
	        Image_mail_line_read:setVisible(true)
	    end
	end
	
	--时间
    if __lua_project_id == __lua_project_pacific_rim then
        Text_mail_time:setString(getLeaveTimeString(tonumber(self._mail_data.time)/1000, true))
    else
	    Text_mail_time:setString(self:getTimeFormatYMDHMS(tonumber(self._mail_data.time)/1000))
    end
	--邮件简报
	_richText1:setContentSize(cc.size(Text_mail_infor:getContentSize().width,Text_mail_infor:getContentSize().height))
	_richText1:setAnchorPoint(0,0.5)
	_richText1:setPosition(cc.p(-Text_mail_infor:getContentSize().width/2,Text_mail_infor:getContentSize().height/2))
	Text_mail_infor:addChild(_richText1)	
	
end

function MailCell:getTimeFormatYMDHMS( m_time )
	local temp = os.date("*t", getBaseGTM8Time(m_time))

	local m_month 	= string.format("%02d", temp.month)
	local m_day 	= string.format("%02d", temp.day)
	local m_hour 	= string.format("%02d", temp.hour)
	local m_min 	= string.format("%02d", temp.min)
	local m_sec 	= string.format("%02d", temp.sec)

	local timeString = temp.year .."-".. m_month .."-".. m_day .." ".. m_hour ..":".. m_min ..":".. m_sec
    return timeString
end

function MailCell:onInit()
    local root = cacher.createUIRef(string.format(config_csb.cells.mail.mail_cell, 1), "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    table.insert(self.roots, root) 

    if MailCell.__size == nil then
        MailCell.__size = root:getContentSize()
    end

    root:setSwallowTouches(false)
    local function panelTouchListener( sender, eventType )
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        if eventType == ccui.TouchEventType.began then
        	pushEffect(formatMusicFile("button", 1))
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if math.abs(__spoint.x - __epoint.x) <= 10 and math.abs(__spoint.y - __epoint.y) <= 10 then
                state_machine.excute("mail_cell_click", 0, {_datas = {cell = self}})
            end
        end
    end
    root:addTouchEventListener(panelTouchListener)
	if self._mail_data.mail_params == nil then
		local attachedInfo = zstring.split(self._mail_data.param, "|")
		local attachedOne = zstring.split(attachedInfo[2], ",")
		local attachedTwo = zstring.split(attachedInfo[3], ",")
		local mail_params = {}
		mail_params.mail_type = attachedInfo[1]		--邮件类型，0攻1防2侦查
		mail_params.Attack_side = {}
		mail_params.Attack_side.name = attachedOne[1]	--攻方名称
		mail_params.Attack_side.union_name = attachedOne[2] --攻方工会名称
		mail_params.Attack_side.level = attachedOne[3] --攻方等级
		mail_params.Attack_side.mine_mould_id = attachedOne[4] --矿点模板id
		mail_params.Attack_side.attack_print_x = attachedOne[5] --攻击点的x
		mail_params.Attack_side.attack_print_y = attachedOne[6] --攻击点的y
		mail_params.Attack_side.quality = attachedOne[7] --攻击点的品质
		mail_params.Attack_side.attack_type = attachedOne[8] --攻击类型如果是4的时候是无战斗返回
		mail_params.Attack_side.currentBoom = attachedOne[10] --当前繁荣度
		mail_params.Attack_side.maxBoom = attachedOne[11] --最大繁荣度
        mail_params.Attack_side.military_number = attachedOne[12] --获得军工
        mail_params.Attack_side.boomChange = zstring.tonumber(attachedOne[13]) --变更的繁荣度
        if mail_params.Attack_side.currentBoom ~= nil and mail_params.Attack_side.maxBoom ~= nil then
            mail_params.Attack_side.currentBoom = math.min(tonumber(mail_params.Attack_side.currentBoom), tonumber(mail_params.Attack_side.maxBoom))
        end
		if tonumber(mail_params.Attack_side.attack_type) == 4 then
			mail_params.rewardType = attachedInfo[3]		--0正常采集，1打自己的无效，2打同工会的无效，3目标不存在，4玩家开启保护罩攻击无效, 5叛军攻击无效返回
		else
			mail_params.Defensive_side = {}
			mail_params.Defensive_side.name = attachedTwo[1]	--守方名称
			mail_params.Defensive_side.union_name = attachedTwo[2] --守方工会名称
			mail_params.Defensive_side.level = attachedTwo[3] --守方等级
			mail_params.Defensive_side.mine_mould_id = attachedTwo[4] --矿点模板id
			mail_params.Defensive_side.attack_print_x = attachedTwo[5] --攻击点的x
			mail_params.Defensive_side.attack_print_y = attachedTwo[6] --攻击点的y
			mail_params.Defensive_side.quality = attachedTwo[7] --攻击点的品质
			mail_params.Defensive_side.attack_type = attachedTwo[8] --攻击类型
			mail_params.Defensive_side.currentBoom = attachedTwo[10] --当前繁荣度
			mail_params.Defensive_side.maxBoom = attachedTwo[11] --最大繁荣度
            mail_params.Defensive_side.military_number = attachedTwo[12] --获得军工
            mail_params.Defensive_side.boomChange = zstring.tonumber(attachedTwo[13]) --变更的繁荣度
            if mail_params.Defensive_side.currentBoom ~= nil and mail_params.Defensive_side.maxBoom ~= nil then
                mail_params.Defensive_side.currentBoom = math.min(tonumber(mail_params.Defensive_side.currentBoom), tonumber(mail_params.Defensive_side.maxBoom))
            end
            if tonumber(mail_params.Defensive_side.attack_type) == 7 then
                mail_params.Defensive_side.name = dms.string(dms["world_city_mould"], mail_params.Defensive_side.mine_mould_id, world_city_mould.name)
                mail_params.Defensive_side.level = dms.int(dms["world_city_mould"], mail_params.Defensive_side.mine_mould_id, world_city_mould.level)
            end
		end
		self._mail_data.mail_params = mail_params
	end
	-- debug.print_r(self._mail_data.mail_params)
	
	self:updateDraw()
end

function MailCell:onEnterTransitionFinish()

end

function MailCell:init(index, mail_data, ntype)
    self._index = index
    self._mail_data = mail_data
    self._ntype = ntype
    if self._ntype == 1 or self._ntype == 2 or self._ntype == 3 then
        if self._mail_data.nType == 200 or self._mail_data.nType == 203 then
            self._ntype = 1
        elseif self._mail_data.nType == 1200 then
            self._ntype = 2
        elseif self._mail_data.nType == 10002 then
            self._ntype = 3
        end
    end
    if index ~= nil and index <= 20 then
        self:onInit()
    end
    self:setContentSize(MailCell.__size)
    return self
end

function MailCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_mail_name = ccui.Helper:seekWidgetByName(root,"Text_mail_name")
    local Panel_mail_icon = ccui.Helper:seekWidgetByName(root,"Panel_mail_icon")
    local Text_mail_infor = ccui.Helper:seekWidgetByName(root,"Text_mail_infor")
    local Text_mail_time = ccui.Helper:seekWidgetByName(root,"Text_mail_time")
	if Text_mail_name~= nil then
		Text_mail_name:setString("")
		Text_mail_time:setString("")
		Panel_mail_icon:removeBackGroundImage()
		Text_mail_infor:removeAllChildren(true)
	end
end

function MailCell:onExit()
	self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.cells.mail.mail_cell, 1), self.roots[1])
end

function MailCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function MailCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.cells.mail.mail_cell, 1), root)
    root:removeFromParent(false)
    self.roots = {}
end