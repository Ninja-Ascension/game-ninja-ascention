--------------------------------------------------------------------------------------------------------------
--  说明：单个奖励数据
--------------------------------------------------------------------------------------------------------------
RedAlerTimeActShareCell = class("RedAlerTimeActShareCellClass", Window)
RedAlerTimeActShareCell.__size = nil

--创建cell
local red_alert_time_act_share_create_cell_terminal = {
    _name = "red_alert_time_act_share_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlerTimeActShareCell:new()
		local activity_type = params[1]
		local index = tonumber(params[2])
		local a_type = tonumber(params[3]) or 0
		local group = tonumber(params[4]) or 0
        cell:init(activity_type,index,a_type,group)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_act_share_create_cell_terminal)
state_machine.init()

function RedAlerTimeActShareCell:ctor()
	self.super:ctor()
	self.roots = {}
	self._activity_type = nil
	self.a_type = 0
	self.group = 0
	self.m_time = -1
	self.Lead_time = 0
	self.newTime = 0
	self.acitvity_88_is_reward = false
	 -- Initialize red_alert_time_act_share_cell state machine.
    local function init_red_alert_time_act_share_cell_terminal()
        local red_alert_time_act_share_cell_receive_award_terminal = {
            _name = "red_alert_time_act_share_cell_receive_award",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- print("活动领取接口")
				local cell = params._datas.cells
				if cell.a_type == 84 or cell.a_type == 91 then
					state_machine.excute("red_alert_time_act_share_cell_go",0,cell)
					return
				end
				if cell.a_type == 88 and cell.acitvity_88_is_reward == false then
					state_machine.excute("red_alert_time_act_share_cell_go",0,cell)
					return
				end
				local acitvity = _ED.activity_info[""..cell.a_type]
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        checkRewardObtainDraw()
                        state_machine.excute("main_window_update_top_button",0,"")
						if response.node ~= nil and response.node.roots ~= nil then
							response.node:updateDraw()
							if tonumber(response.node.a_type) == 9 then
								local isover = false
								for i, v in pairs(acitvity.activity_data[2]) do
									if tonumber(v.achieve_state) < 2 then
										isover = true
									end
								end
								if isover == false then
									state_machine.excute("red_alert_time_wonderful_update_first",0,response.node.a_type)
								end	
							end	
						end
					end
				end		
				protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..cell.a_type.."\r\n"..(tonumber(cell.group)-1).."\r\n"..tonumber(cell._activity_type.achieve_index)-1
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local red_alert_time_act_share_cell_go_terminal = {
            _name = "red_alert_time_act_share_cell_go",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params
                local changeType = cell._activity_type.achieve_other_info
                if tonumber(changeType) ~= -1 then
                	state_machine.excute("short_cut_go_to_other_window",0,{tonumber(changeType)})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_act_share_cell_go_terminal)
        state_machine.add(red_alert_time_act_share_cell_receive_award_terminal)
        state_machine.init()
    end 
    -- call func red_alert_time_act_share_cell create state machine.
    init_red_alert_time_act_share_cell_terminal()

end

function RedAlerTimeActShareCell:updateDraw()
    local root = self.roots[1]
	--名称
	local Text_act_share_tit = ccui.Helper:seekWidgetByName(root,"Text_act_share_tit")
	Text_act_share_tit:setString(self._activity_type.achieve_mould_name)
	--进度
	local Text_act_share_progress_n = ccui.Helper:seekWidgetByName(root,"Text_act_share_progress_n")
	local Text_act_share_progress_t = ccui.Helper:seekWidgetByName(root,"Text_act_share_progress_t")
	local Text_act_share_progress_t_p = ccui.Helper:seekWidgetByName(root,"Text_act_share_progress_t_p") -- 需求描述
	local Button_act_share_rec = ccui.Helper:seekWidgetByName(root,"Button_act_share_rec")
	Text_act_share_progress_t_p:setVisible(false)
	Button_act_share_rec:setTitleText(RedAlerTimeActShareCell.originalButtonText)

	local blueButtonTexture = config_res.images.ui.share.blue_button
	local yellowButtonTexture = config_res.images.ui.share.yellow_button
	local grayButtonTexture = config_res.images.ui.share.gray_button
	if self.a_type == 84 or self.a_type == 88 or self.a_type == 91 then
		Button_act_share_rec:loadTextures(blueButtonTexture,blueButtonTexture,grayButtonTexture,1)
	else
		Button_act_share_rec:loadTextures(yellowButtonTexture,yellowButtonTexture,grayButtonTexture,1)
	end

	local initPositionX = Text_act_share_progress_t:getPositionX()
	local fontSize = Text_act_share_progress_t:getFontSize()
	
	local Text_act_share_not = ccui.Helper:seekWidgetByName(root,"Text_act_share_not")
	--奖励
	local ListView_act_share_reward = ccui.Helper:seekWidgetByName(root,"ListView_act_share_reward")
	ListView_act_share_reward:removeAllItems()
	local rewarldData = zstring.split(self._activity_type.achieve_reward, "|")
	for i=1 ,#rewarldData do
		local datas = zstring.split(rewarldData[i], ",")
		if tonumber(datas[1]) == -1 then
			datas[1] = resource_prop_id[tonumber(datas[2])]
			datas[2] = 1
		end
		local prop_type = tonumber(datas[2])
		local show_type = 6
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
		-- print(show_type,datas[1],prop_type,datas[3])
		-- local cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),nil,tonumber(datas[1])})
		local cell = nil
		if self.a_type == 92 then
			local baseGood = zstring.split(self._activity_type.achieve_complete_count, "/")
			local discount = zstring.split(self._activity_type.achieve_other_info, ",")
			datas[3] = baseGood[1] * discount[2] / 100
		end
		if prop_type == 7 then
			local equip_datas = {}
			equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
			equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), tonumber(datas[3])})
		else
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),nil,tonumber(datas[1])})
		end
		ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
		if self.a_type == 76 or self.a_type == 84 or self.a_type == 91 then
			ccui.Helper:seekWidgetByName(cell.roots[1], "Image_num_bg"):setVisible(false)
			ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_n"):setString("")
		end
		if self.a_type == 84 then
			ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_name"):setString("")
		end
		if self.a_type == 91 then
			ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_props_icon"):setTouchEnabled(false)
		end
		cell.roots[1]:setPositionX(10)
		ListView_act_share_reward:addChild(cell)
	end
	if #ListView_act_share_reward:getItems() <= 3 then
		ListView_act_share_reward:setTouchEnabled(false)
	else
		ListView_act_share_reward:setTouchEnabled(true)
	end
	ListView_act_share_reward:requestRefreshView()

	if self.a_type == 47 then
	else
		if self.a_type == 72 then
			local __datas = zstring.split(self._activity_type.achieve_complete_count, "/")
			Text_act_share_progress_n:setString(exChangeNumToString(tonumber(__datas[1])).."/"..exChangeNumToString(tonumber(__datas[2])))
		else
			Text_act_share_progress_n:setString(self._activity_type.achieve_complete_count)
		end
		
	end
	if self.a_type == 86 then
		Text_act_share_progress_n:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
	else
		Text_act_share_progress_n:setColor(RedAlerTimeActShareCell.originalTextColor)
	end

	if self.a_type == 84 or self.a_type == 88 or self.a_type == 91 then
		Text_act_share_progress_t_p:setVisible(true)
		Text_act_share_progress_t:setVisible(false)
		Text_act_share_progress_n:setVisible(false)
		Text_act_share_progress_t_p:setString(self._activity_type.achieve_mould_dec)
		if self.a_type == 91 then
			Button_act_share_rec:setTitleText(activity_str_tip[13])
		else
			Button_act_share_rec:setTitleText(activity_str_tip[104])
		end
		if self.a_type == 88 then
			Text_act_share_progress_t:setVisible(true)
			Text_act_share_progress_n:setVisible(true)
			if tonumber(self._activity_type.achieve_state) <= 1 then
				local datas = zstring.split(self._activity_type.achieve_complete_count, "/")
				if tonumber(datas[1]) < tonumber(datas[2]) then
					self.acitvity_88_is_reward = false
					Button_act_share_rec:setTitleText(activity_str_tip[104])
					Button_act_share_rec:loadTextures(blueButtonTexture,blueButtonTexture,grayButtonTexture,1)
				else
					self.acitvity_88_is_reward = true
					Button_act_share_rec:setTitleText(activity_str_tip[5])
					Button_act_share_rec:loadTextures(yellowButtonTexture,yellowButtonTexture,grayButtonTexture,1)
				end
				Button_act_share_rec:setVisible(true)
				Text_act_share_not:setVisible(false)
			else
				self.acitvity_88_is_reward = false
				Button_act_share_rec:setVisible(false)
				Text_act_share_not:setVisible(true)
				Text_act_share_not:setString(activity_str_tip[2])
			end
		end
		return
	end
	
	if self.a_type == 47 then
		local datas = zstring.split(_ED.activity_info[""..self.a_type].activity_add_state,",")
		self.m_time = (tonumber(datas[3])/1000)+(os.time()-_ED.activity_info[""..self.a_type].start_time)
		self.newTime = os.time()
		local countdatas = zstring.split(self._activity_type.achieve_complete_count, "/")
		Text_act_share_progress_n:setString(math.floor(self.m_time/60).."/"..countdatas[2])
		if math.floor(self.m_time/60) >= tonumber(countdatas[2]) then
			self._activity_type.achieve_complete_count = math.floor(self.m_time/60).."/"..countdatas[2]
			if tonumber(self._activity_type.achieve_state) <= 0 then
				self._activity_type.achieve_state = 1
			end
		end
	else
		if self.a_type == 69 and tonumber(self._activity_type.achieve_index) <= 2 then
        	local datas = zstring.split(_ED.activity_info[""..self.a_type].activity_add_state,",")
			self.m_time = (tonumber(datas[4])/1000)+(os.time()-_ED.activity_info[""..self.a_type].start_time)
			self.newTime = os.time()
			local countdatas = zstring.split(self._activity_type.achieve_complete_count, "/")
			ccui.Helper:seekWidgetByName(self.roots[1],"Text_act_share_progress_n"):setString(math.floor(self.m_time/60).."/"..countdatas[2])
			if _ED.union.union_info == nil 
	            or _ED.union.union_info == {} 
	            or _ED.union.union_info.union_id == nil 
	            or _ED.union.union_info.union_id == "" 
	            or tonumber(_ED.union.union_info.union_id) == 0 
	            then
            	self.m_time = -1
	        else
				-- local datas = zstring.split(_ED.activity_info[""..self.a_type].activity_add_state,",")
				-- self.m_time = (tonumber(datas[4])/1000)+(os.time()-_ED.activity_info[""..self.a_type].start_time)
				-- self.newTime = os.time()
				-- local countdatas = zstring.split(self._activity_type.achieve_complete_count, "/")
				-- ccui.Helper:seekWidgetByName(self.roots[1],"Text_act_share_progress_n"):setString(math.floor(self.m_time/60).."/"..countdatas[2])
				if math.floor(self.m_time/60) >= tonumber(countdatas[2]) then
					self._activity_type.achieve_complete_count = math.floor(self.m_time/60).."/"..countdatas[2]
					if tonumber(self._activity_type.achieve_state) <= 0 then
						self._activity_type.achieve_state = 1
					end
				end
			end
		else
			self.m_time = -1
		end
	end
	if self.a_type == 93 then
		Text_act_share_progress_t_p:setString(self._activity_type.achieve_mould_dec)
	end
	if self.a_type == 9 then
		if tonumber(_ED.activity_info[""..self.a_type].activity_data[1][1].achieve_state) == 0 then
			Text_act_share_not:setVisible(true)
			ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):setVisible(false)
			-- Text_act_share_not:setColor(chat_rich_text_color[6])
			Text_act_share_not:setString(activity_str_tip[1])
			if verifySupportLanguage(_lua_release_language_en) == true then
				Text_act_share_not:setString("")
			end
			Text_act_share_progress_n:setVisible(false)
			Text_act_share_progress_t:setVisible(false)
		else
			if tonumber(self._activity_type.achieve_state) == 0 then
				ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):setVisible(false)
				Text_act_share_not:setVisible(true)
				-- Text_act_share_not:setColor(chat_rich_text_color[1])
				Text_act_share_not:setString(activity_str_tip[8])
				if verifySupportLanguage(_lua_release_language_en) == true then
					Text_act_share_not:setString("")
				end
			elseif tonumber(self._activity_type.achieve_state) == 1 then
				ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):setVisible(true)
				Text_act_share_not:setVisible(false)
			else
				ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):setVisible(false)
				Text_act_share_not:setVisible(true)
				-- Text_act_share_not:setColor(chat_rich_text_color[1])
				Text_act_share_not:setString(activity_str_tip[2])
			end
			Text_act_share_progress_n:setVisible(false)
			Text_act_share_progress_t:setVisible(false)
		end
	else
		if self.a_type == 73 or self.a_type == 76 then
			ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):setVisible(false)
			Text_act_share_progress_n:setVisible(false)
			Text_act_share_progress_t:setVisible(true)
			if self.a_type == 76 then
				Text_act_share_progress_t:setString(self._activity_type.achieve_mould_dec)
				Text_act_share_progress_t:setPositionX(Text_act_share_progress_t._x-100)
			else
				Text_act_share_progress_t:setString(activity_str_tip[34])
				Text_act_share_progress_t:setPositionX(Text_act_share_progress_t._x-100)
			end
		else
			Text_act_share_progress_t:setPositionX(Text_act_share_progress_t._x)
			if self.a_type == 72 then
				Text_act_share_progress_t:setString(activity_str_tip[78])
			elseif self.a_type == 63 then
				Text_act_share_progress_t:setString(activity_str_tip[82])
			-- elseif self.a_type == 86 then
			-- 	Text_act_share_progress_t:setString(activity_str_tip[106])
			elseif self.a_type == 66 then
				Text_act_share_progress_t:setString("")
				Text_act_share_progress_t:removeAllChildren(true)

				local _richText = ccui.RichText:create()
				_richText:ignoreContentAdaptWithSize(false)
				_richText:setContentSize(cc.size(400, 20))
				local rt, count, text = draw.richTextCollectionMethod(_richText, 
					activity_str_tip[83], 
					cc.c3b(189, 206, 224),
					cc.c3b(189, 206, 224),
					0, 
					0, 
					config_res.font.font_name, 
					fontSize,
					chat_rich_text_color)
				_richText:setPosition(cc.p(200, 0))
				Text_act_share_progress_t:addChild(_richText)

				Text_act_share_progress_n:setString("")
				Text_act_share_progress_t:setPositionX(Text_act_share_progress_t._x-100)
			else
				Text_act_share_progress_t:setString(activity_str_tip[35])
			end
			
			if self.a_type == 76 then
				ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):setVisible(false)
				Text_act_share_not:setVisible(false)
			else
				if tonumber(self._activity_type.achieve_state) <= 1 then
					local datas = zstring.split(self._activity_type.achieve_complete_count, "/")
					if tonumber(datas[1]) < tonumber(datas[2]) then
						ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):setVisible(false)
						Text_act_share_not:setVisible(true)
						-- Text_act_share_not:setColor(chat_rich_text_color[6])
						Text_act_share_not:setString(activity_str_tip[8])
						if verifySupportLanguage(_lua_release_language_en) == true then
							Text_act_share_not:setString("")
						end
					else
						ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):setVisible(true)
						Text_act_share_not:setVisible(false)
					end
				else
					ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):setVisible(false)
					Text_act_share_not:setVisible(true)
					-- Text_act_share_not:setColor(chat_rich_text_color[1])
					Text_act_share_not:setString(activity_str_tip[2])
				end
			end
			if self.a_type ~= 47 
				and self.a_type ~= 69 
				and self.a_type ~= 4 
				and self.a_type ~= 72 
				and self.a_type ~= 66
				and self.a_type ~= 86
				and self.a_type ~= 90
				then
				Text_act_share_progress_n:setVisible(false)
				Text_act_share_progress_t:setVisible(false)
			else
				Text_act_share_progress_n:setVisible(true)
				Text_act_share_progress_t:setVisible(true)
			end
			if self.a_type == 63 then
				if tonumber(self._activity_type.achieve_index) == table.nums(_ED.activity_info[""..self.a_type].activity_data[1]) then
					Text_act_share_progress_n:setVisible(true)
					Text_act_share_progress_t:setVisible(true)
				end
			end
		end
	end
	if self.a_type == 52 or self.a_type == 53 or self.a_type == 51 or self.a_type == 66 or self.a_type == 93 then
		local timesData = zstring.split(_ED.activity_info[""..self.a_type].activity_add_state, ",")
		if (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) < tonumber(timesData[3])/1000 then
			self.Lead_time = tonumber(timesData[3])/1000 - (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))
		else
			local datas = zstring.split(self._activity_type.achieve_complete_count, "/")
			if self.a_type == 51 then
				local achievement = zstring.split(self._activity_type.achieve_other_info, ",")
				if tonumber(self._activity_type.achieve_state) ~= 2 then
					if tonumber(achievement[1]) == tonumber(achievement[2]) then
						if tonumber(timesData[5]) == tonumber(achievement[1]) and tonumber(timesData[4]) >= tonumber(achievement[3]) and tonumber(timesData[4]) <= tonumber(achievement[4]) then
							ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):setVisible(true)
							Text_act_share_not:setVisible(false)
						else
							ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):setVisible(false)
							Text_act_share_not:setVisible(true)
						end
					else
						if tonumber(timesData[5]) >= tonumber(achievement[1]) and tonumber(timesData[5]) <= tonumber(achievement[2])
							and tonumber(timesData[4]) >= tonumber(achievement[3]) and tonumber(timesData[4]) <= tonumber(achievement[4]) then
							ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):setVisible(true)
							Text_act_share_not:setVisible(false)
						else
							ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):setVisible(false)
							Text_act_share_not:setVisible(true)
						end
					end
				else
					ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):setVisible(false)
					Text_act_share_not:setVisible(true)
				end
			elseif self.a_type == 52 or self.a_type == 53 or self.a_type == 93 then
				local achievement = zstring.split(self._activity_type.achieve_other_info, ",")
				if tonumber(self._activity_type.achieve_state) ~= 2 then
					if tonumber(achievement[1]) <= tonumber(timesData[4]) 
						and tonumber(achievement[2]) >= tonumber(timesData[4]) 
						then
						ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):setVisible(true)
						Text_act_share_not:setVisible(false)
					else
						ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):setVisible(false)
						Text_act_share_not:setVisible(true)
					end
				else
					ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):setVisible(false)
					Text_act_share_not:setVisible(true)
				end
			else
				if zstring.tonumber(timesData[4]) ~= 0 
					and zstring.tonumber(timesData[4]) == tonumber(self.index)  
					and tonumber(self._activity_type.achieve_state) ~= 2
					then
					ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):setVisible(true)
					Text_act_share_not:setVisible(false)
					if zstring.tonumber(timesData[7]) > zstring.tonumber(timesData[8]) then
						ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):setVisible(false)
						Text_act_share_not:setVisible(true)
					end
				else
					ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):setVisible(false)
					Text_act_share_not:setVisible(true)
				end
			end
		end
	end
	if verifySupportLanguage(_lua_release_language_en) == true then
		if self.a_type == 72 or self.a_type == 63 or self.a_type == 4 or self.a_type == 47 or self.a_type == 69 or self.a_type == 86
			or self.a_type == 90 then
			Text_act_share_progress_n:setPositionX(Text_act_share_progress_t:getPositionX() + Text_act_share_progress_t:getContentSize().width)
		end
		if self.a_type == 73 or self.a_type == 66 or self.a_type == 76 then
			Text_act_share_progress_t:setPositionX(initPositionX)
		end
	end	
end

function RedAlerTimeActShareCell:onInit()
--	debug.print_r(_ED.activity_info[""..self.a_type])
    local root = nil
    if self.a_type == 84 or self.a_type == 88 or self.a_type == 91 or self.a_type == 93 then
		root = cacher.createUIRef(config_csb.cells.activity.act_share_cell_3, "root")
	    RedAlerTimeActShareCell.__size = root:getContentSize()
	else
    	root = cacher.createUIRef(config_csb.cells.activity.act_share_cell_1, "root")
		RedAlerTimeActShareCell.__size = root:getContentSize()
    end
    table.insert(self.roots, root)
    self:addChild(root)
    
    self:setContentSize(RedAlerTimeActShareCell.__size)
	if ccui.Helper:seekWidgetByName(root,"ListView_act_share_reward")._y == nil then
		ccui.Helper:seekWidgetByName(root,"ListView_act_share_reward")._y = ccui.Helper:seekWidgetByName(root,"ListView_act_share_reward"):getPositionY()
	end
	ccui.Helper:seekWidgetByName(root,"ListView_act_share_reward"):setPositionY(ccui.Helper:seekWidgetByName(root,"ListView_act_share_reward")._y)
	if ccui.Helper:seekWidgetByName(root,"Text_act_share_progress_t")._x == nil then
		ccui.Helper:seekWidgetByName(root,"Text_act_share_progress_t")._x = ccui.Helper:seekWidgetByName(root,"Text_act_share_progress_t"):getPositionX()
	end
	ccui.Helper:seekWidgetByName(root,"Text_act_share_progress_t"):setPositionX(ccui.Helper:seekWidgetByName(root,"Text_act_share_progress_t")._x)
	--领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"), nil, 
    {
        terminal_name = "red_alert_time_act_share_cell_receive_award", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
		cells = self
    }, nil, 1)
    if RedAlerTimeActShareCell.originalButtonText == nil then
		RedAlerTimeActShareCell.originalButtonText = ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):getTitleText()
	end
	if RedAlerTimeActShareCell.originalTextColor == nil then
		RedAlerTimeActShareCell.originalTextColor = ccui.Helper:seekWidgetByName(root,"Text_act_share_progress_n"):getTextColor()
	end
	self:updateDraw()

end

function RedAlerTimeActShareCell:onEnterTransitionFinish()
    local root = self.roots[1]
    
end

function RedAlerTimeActShareCell:clearUIInfo( ... )
    local root = self.roots[1]
	local Text_act_share_tit = ccui.Helper:seekWidgetByName(root,"Text_act_share_tit")
	local Text_act_share_progress_n = ccui.Helper:seekWidgetByName(root,"Text_act_share_progress_n")
	local Text_act_share_not = ccui.Helper:seekWidgetByName(root,"Text_act_share_not")
	local ListView_act_share_reward = ccui.Helper:seekWidgetByName(root,"ListView_act_share_reward")
	local Text_act_share_progress_t = ccui.Helper:seekWidgetByName(root,"Text_act_share_progress_t")
	if Text_act_share_tit ~= nil then
		Text_act_share_tit:setString("")
		Text_act_share_not:setString("")
		Text_act_share_progress_n:setString("")
		Text_act_share_not:setVisible(true)
		ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"):setVisible(true)
		ListView_act_share_reward:removeAllItems()
		Text_act_share_progress_t:setString("")
		Text_act_share_progress_t:removeAllChildren(true)
	end
	self.m_time = -1
	self.Lead_time = 0
	self.newTime = 0
	self.acitvity_88_is_reward = false
end

function RedAlerTimeActShareCell:onUpdate(dt)
	if self.Lead_time > 0 then
		self.Lead_time = self.Lead_time - dt
		if self.Lead_time <= 0 then
			self:updateDraw()
		end	
	end	
	if self.m_time ~= -1 then
		local toTme = os.time()
		if toTme - self.newTime >= 60 then
			self.newTime = os.time()
			local datas = zstring.split(_ED.activity_info[""..self.a_type].activity_add_state,",")
			if tonumber(self.a_type) == 47 then
				self.m_time = (tonumber(datas[3])/1000)+(toTme-_ED.activity_info[""..self.a_type].start_time)
			elseif tonumber(self.a_type) == 69 then
				self.m_time = (tonumber(datas[4])/1000)+(toTme-_ED.activity_info[""..self.a_type].start_time)
			else
				self.m_time = (tonumber(datas[3])/1000)+(toTme-_ED.activity_info[""..self.a_type].start_time)
			end
			local countdatas = zstring.split(self._activity_type.achieve_complete_count, "/")
			ccui.Helper:seekWidgetByName(self.roots[1],"Text_act_share_progress_n"):setString(math.floor(self.m_time/60).."/"..countdatas[2])
			if math.floor(self.m_time/60) >= tonumber(countdatas[2]) then
				self._activity_type.achieve_complete_count = math.floor(self.m_time/60).."/"..countdatas[2]
				if tonumber(self._activity_type.achieve_state) <= 0 then
					self._activity_type.achieve_state = 1
					self:updateDraw()
				end
			end
		end
	end
end

function RedAlerTimeActShareCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self, 0.5)
    self:onInit()
end

function RedAlerTimeActShareCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
	if self.a_type == 84 or self.a_type == 88 or self.a_type == 91 or self.a_type == 93 then
		cacher.freeRef(config_csb.cells.activity.act_share_cell_3, root)
	else
    	cacher.freeRef(config_csb.cells.activity.act_share_cell_1, root)
    end
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlerTimeActShareCell:init(activity_type,index,a_type,group)
    self._activity_type = activity_type
	self.index = index
	self.a_type = a_type
	self.group = group
    -- if index ~= nil and index < 8 then
	   self:onInit()
    -- end

    --self:setContentSize(RedAlerTimeActShareCell.__size)
    return self
end

function RedAlerTimeActShareCell:onExit()
	self:clearUIInfo()
	if self.a_type == 84 or self.a_type == 88 or self.a_type == 91 or self.a_type == 93 then
		cacher.freeRef(config_csb.cells.activity.act_share_cell_3, self.roots[1])
	else
    	cacher.freeRef(config_csb.cells.activity.act_share_cell_1, self.roots[1])
    end
end