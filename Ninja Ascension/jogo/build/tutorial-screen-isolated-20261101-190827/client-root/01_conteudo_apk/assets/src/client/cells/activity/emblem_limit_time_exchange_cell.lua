-- ----------------------------------------------------------------------------------------------------
-- 说明：徽章限时兑换
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
EmblemLimitTimeExchangeCell = class("EmblemLimitTimeExchangeCellClass", Window)
	
function EmblemLimitTimeExchangeCell:ctor()
	self.super:ctor()
	self.roots = {}
	
	-- var
	self.activity = nil
	self.index = 0

	-- load lua files
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")
	app.load("client.cells.prop.prop_money_icon")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")

	-- Initialize emblem_limit_time_exchange_cell state machine.
	local function init_emblem_limit_time_exchange_cell_terminal()
		--兑换
		local emblem_limit_time_exchange_cell_exchange_terminal = {
			_name = "emblem_limit_time_exchange_cell_exchange",
			_init = function (terminal) 
			
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				local activity = _ED.active_activity[124]
				if activity == nil then
					return
				end

				-- 调用批量兑换界面
				-- Fury: `instance` es la ultima celda creada (puede estar destruida); la tocada es `cell`.
				cell:exchangeReward(cell)

				-- app.load("client.l_digital.activity.wonderful.SmActivityPropDiscountBuyConfirm")
				-- local temp = {index = _index, activity_id = 124}
				-- state_machine.excute("sm_activity_auto_upgrade_window_open", 0, temp)

				-- local function responseExchangeCallback(response)
				-- 	if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				-- 		if response.node ~= nil then
				-- 			response.node:onUpdateDraw(true)
				-- 			------刷新排序
				-- 			if response.node.nCount == 0 then
				-- 				state_machine.excute("activity_emblem_limit_time_exchange_update_draw",0,"")
				-- 			end

				-- 			app.load("client.reward.DrawRareReward")
				-- 			local getRewardWnd = DrawRareReward:new()
				-- 			getRewardWnd:init(7)
				-- 			fwin:open(getRewardWnd, fwin._ui)
				-- 		end							
				-- 	end
				-- end
				-- local cell = params._datas.cell
				-- protocol_command.get_activity_reward.param_list = cell.activity.activity_id.."\r\n" .. ""..tonumber(cell.index - 1).."\r\n".."0"
				-- NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, cell, responseExchangeCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		state_machine.add(emblem_limit_time_exchange_cell_exchange_terminal)
		state_machine.init()
	end
	
	-- call func init emblem_limit_time_exchange_cell state machine.
	init_emblem_limit_time_exchange_cell_terminal()
end

function EmblemLimitTimeExchangeCell:exchangeReward(cell)
	local activityInfo = cell.activity.activity_Info[tonumber(cell.index)]
	local may_num = self:mayExchangeNum(activityInfo, cell.nCount)
	if may_num > 0  then
		if cell.nCount > 1 then
			if "" ~= activityInfo.activityInfo_reward_select then
				local rewardInfo = zstring.splits(activityInfo.activityInfo_reward_select, "|", ",")[1]
				local type = tonumber(rewardInfo[1])
				local count = tonumber(rewardInfo[3])
				local mould_id = rewardInfo[2]
				local prop = {}
				prop.prop_number = cell.nCount
				if may_num < cell.nCount then
					prop.prop_number = may_num
				end
				prop.mould_id = mould_id
				prop.type = type
				if prop.type == 6 then
					local prop_info = dms.element(dms["prop_mould"], prop.mould_id)
					if prop.mould_name == nil then
						prop.mould_name = dms.atos(prop_info, prop_mould.prop_name)
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
							prop.mould_name = setThePropsIcon(prop.mould_id)[2]
						end
					end

					if prop.prop_quality == nil then
						prop.prop_quality = dms.atoi(prop_info, prop_mould.prop_quality)
					end

					prop.mould_remarks = dms.atos(prop_info, prop_mould.remarks)
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						prop.mould_remarks = drawPropsDescription(prop.mould_id)
					end
					-- 武器
				elseif prop.type == 7 then
					local prop_info = dms.element(dms["equipment_mould"], prop.mould_id)
					if prop.mould_name == nil then
						prop.mould_name = smEquipWordlFundByIndex(prop.mould_id , 1)
					end
					prop.prop_quality = dms.atoi(prop_info, equipment_mould.trace_npc_index)
					if prop.prop_quality == 0 then
						prop.prop_quality = 3
					end
					prop.mould_remarks = smEquipWordlFundByIndex(prop.mould_id , 2)--描述
				elseif prop.type == 13 then
					if prop.prop_quality == nil then
						prop.prop_quality = dms.int(dms["ship_mould"], prop.mould_id, ship_mould.ship_type)+1
					end

					if prop.mould_name == nil then
						local evo_image = dms.string(dms["ship_mould"], prop.mould_id, ship_mould.fitSkillTwo)
						local evo_info = zstring.split(evo_image, ",")
						local evo_mould_id = evo_info[dms.int(dms["ship_mould"], prop.mould_id, ship_mould.captain_name)]
						local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
						local word_info = dms.element(dms["word_mould"], name_mould_id)
						prop.mould_name = word_info[3]
					end
				else
					if prop.prop_quality == nil then
						prop.prop_quality = 0
					end
					if prop.mould_name == nil then
						prop.mould_name = _All_tip_string_info._fundName
					end
				end
				prop.id = cell.index
				cell.prop = prop
				cell.form_cell = "emblem_limit_time_exchange_cell" --来自ID = 124活动cell

				--这里添加兑换弹窗
				app.load("client.packs.prop.ComExchange")
				state_machine.excute("com_exchange_use_open", 0, cell)
			end
		else
			local function responseExchangeCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					app.load("client.reward.DrawRareReward")
					local getRewardWnd = DrawRareReward:new()
					getRewardWnd:init(7)
					fwin:open(getRewardWnd, fwin._ui)

					state_machine.excute("activity_emblem_limit_time_exchange_update_draw", 0, nil)
				end
			end
			protocol_command.get_activity_reward.param_list = cell.activity.activity_id.."\r\n" .. ""..tonumber(cell.index - 1).."\r\n".."0"
			NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, cell, responseExchangeCallback, false, nil)
		end
	else
		TipDlg.drawTextDailog(_string_piece_info[85])
	end
end

--返回可以兑换的物品数量
function EmblemLimitTimeExchangeCell:mayExchangeNum(activityInfo, limitNum)
	local exchangeInfos = zstring.split(activityInfo.activityInfo_need_day, "@")
	local itemInfos = zstring.splits(exchangeInfos[1], ":", ",")
	local may_num = limitNum
	for i, info in pairs(itemInfos) do
		local needPropItemNum = tonumber(info[2])
		local needMouldId = tonumber(info[1])
		local had_num = tonumber(getPropAllCountByMouldId(needMouldId))
		local cur_num =	math.floor(had_num / needPropItemNum )
		if cur_num < may_num then
			may_num = cur_num
		end
	end
	return may_num
end

function EmblemLimitTimeExchangeCell:onUpdateDraw(update)
	local root = self.roots[1]
	local activityInfo = self.activity.activity_Info[tonumber(self.index)]
	local countInfos = zstring.split(self.activity.activity_params, ",")

	local exchangeInfos = zstring.split(activityInfo.activityInfo_need_day, "@")
	local itemInfos = zstring.splits(exchangeInfos[1], ":", ",")

	local Text_11 = ccui.Helper:seekWidgetByName(root, "Text_11")

	local porp_name = nil
	local propInfo = zstring.splits(activityInfo.activityInfo_reward_select, "|", ",")[1]
	local propType = tonumber(propInfo[1])
	local propId = tonumber(propInfo[2])
	if 1 == propType or 
		2 == propType or 
		3 == propType or 
		9 == propType or
		10 == propType
		 then 
		porp_name = _my_gane_name[propType]
	elseif 4 == propType then 
		porp_name = _my_gane_name[5]
	elseif 6 == propType then
		local property = dms.int(dms["prop_mould"],propId,prop_mould.prop_name)
		local porp_name_word = dms.element(dms["word_mould"], property)
		porp_name = porp_name_word[3]
	elseif 7 == propType then 
		local nameindex = dms.int(dms["equipment_mould"], propId, equipment_mould.equipment_name)
		local word_info = dms.element(dms["word_mould"], nameindex)
		porp_name = word_info[3]	
	elseif 8 == propType then 
		porp_name = _my_gane_name[7]
	elseif 12 == propType then 
		porp_name = _my_gane_name[8]
	elseif 13 == propType then 
		
		local evo_image = dms.string(dms["ship_mould"], propId, ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		local evo_mould_id = evo_info[dms.int(dms["ship_mould"], propId, ship_mould.captain_name)]
		local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
		porp_name = word_info[3]
	elseif 18 == propType then 
		porp_name = _my_gane_name[6]
	elseif 20 == propType then 
		porp_name = _my_gane_name[11]
	elseif 28 == propType then 
		porp_name = _my_gane_name[13]
	elseif 31 == propType then 
		porp_name = red_alert_resouce_tip[1][1]
	elseif 33 == propType then 
		porp_name = _my_gane_name[14]
	elseif 34 == propType then 
		porp_name = _my_gane_name[15]
	elseif 71 == propType then 
		local nameindex = dms.string(dms["ship_silk_bag_mould"], propId, ship_silk_bag_mould.silkbag_name)
		local word_info = dms.element(dms["word_mould"], nameindex)
		porp_name = word_info[3]
	elseif 73 == propType then 
		local pos = dms.int(dms["fight_spirit_mould"], propId, fight_spirit_mould.pos)
		local suitId = dms.int(dms["fight_spirit_mould"], propId, fight_spirit_mould.suit_id)
		porp_name = dms.element(dms["word_mould"], dms.int(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.suit_name))[3].."."..chinese_num[pos]
	end

	local name = activityInfo.activityInfo_name
	if nil ~= porp_name and "" ~= porp_name then
		name = porp_name
	end
	
	Text_11:setString(name)

	-- 兑换次数
	self.Text_13 = ccui.Helper:seekWidgetByName(root, "Text_13")
	local nCount = (tonumber(exchangeInfos[2]) - tonumber(countInfos[self.index]))
	self.Text_13:setString(nCount .. "/" .. exchangeInfos[2])
	self.Text_13._def_color = self.Text_13:getColor()
	if nCount <= 0 then
		self.Text_13:setColor(cc.c3b(recruit_preview_tip_color[6][1], recruit_preview_tip_color[6][2], recruit_preview_tip_color[6][3]))

		self.Button_lingqu:setBright(false)
		self.Button_lingqu:setTouchEnabled(false)
		self.Button_lingqu:setHighlighted(true)
	else
		self.Text_13:setColor(self.Text_13._def_color)

		self.Button_lingqu:setBright(true)
		self.Button_lingqu:setTouchEnabled(true)
		self.Button_lingqu:setHighlighted(false)
	end

	self.nCount = nCount

	if true ~= update then
		local ListView_011_2_0 = ccui.Helper:seekWidgetByName(root, "ListView_011_2_0")
		for i, info in pairs(itemInfos) do
			local needPropIcon = ResourcesIconCell:createCell()
			needPropIcon:init(6, tonumber(info[2]), info[1], nil,nil,true,true,1)
			ListView_011_2_0:addChild(needPropIcon)

			-- 设置数量颜色
			-- local item_order_level = ccui.Helper:seekWidgetByName(needPropIcon.roots[1], "Label_l-order_level") -- 右下角等级，数量
			-- item_order_level:setVisible(true)
		end

		if "" ~= activityInfo.activityInfo_reward_select then
			local rewardInfo = zstring.splits(activityInfo.activityInfo_reward_select, "|", ",")[1]
			local Panel_reward_2 = ccui.Helper:seekWidgetByName(root, "Panel_reward_2")
			local rewardIcon = ResourcesIconCell:createCell()
			if tonumber(rewardInfo[1]) == 7 then
				local quality = 3
				rewardIcon:init(tonumber(rewardInfo[1]),0,tonumber(rewardInfo[2]),nil,nil,true,true,1,{equipQuality = quality})
			else
				rewardIcon:init(tonumber(rewardInfo[1]), tonumber(rewardInfo[3]), rewardInfo[2], nil,nil,true,true,1)
			end
			Panel_reward_2:addChild(rewardIcon)
		end
	end
end
function EmblemLimitTimeExchangeCell:onInit()
	local csbEmblemLimitTimeExchangeCell = csb.createNode("activity/wonderful/april_fools_day_list.csb")
	local root = csbEmblemLimitTimeExchangeCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
	self:addChild(root)
	
	self:setContentSize(root:getChildByName("Panel_land_list"):getContentSize())

	-- 兑换奖励
	self.Button_lingqu = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12_4"), nil,
	{
		terminal_name = "emblem_limit_time_exchange_cell_exchange",
		terminal_state = 0,
		isPressedActionEnabled = true,
		cell = self,
	}, nil, 0)

	self:onUpdateDraw()
end

function EmblemLimitTimeExchangeCell:onExit()
	
end

function EmblemLimitTimeExchangeCell:init(activity, index, listView)
	self.activity = activity
	self.index = index
	self.listView = listView
	self:onInit()
end

function EmblemLimitTimeExchangeCell:createCell()
	local cell = EmblemLimitTimeExchangeCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

