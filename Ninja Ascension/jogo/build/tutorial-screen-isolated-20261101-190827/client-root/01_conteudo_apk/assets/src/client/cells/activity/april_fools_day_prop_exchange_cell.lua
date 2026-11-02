-- ----------------------------------------------------------------------------------------------------
-- 说明：杂货铺
-------------------------------------------------------------------------------------------------------
AprilFoolsDayPropExchange = class("AprilFoolsDayPropExchangeClass", Window)
	
function AprilFoolsDayPropExchange:ctor()
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

	-- Initialize april_fools_day_prop_exchange_cell state machine.
	local function init_april_fools_day_prop_exchange_cell_terminal()
		--兑换
		local april_fools_day_prop_exchange_cell_exchange_terminal = {
			_name = "april_fools_day_prop_exchange_cell_exchange",
			_init = function (terminal) 
			
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				local activityInfo = cell.activity.activity_Info[tonumber(cell.index)]
				local may_num = instance:mayExchangeNum(activityInfo,cell.nCount)
				if may_num >0  then
					if cell.nCount >1 then
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
									prop.prop_quality = zstring.tonumber(rewardInfo[4])
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
							cell.form_cell = "april_fools_day_prop_exchange_cell" --来自节日活动cell

							--这里添加兑换弹窗
							app.load("client.packs.prop.ComExchange")
							state_machine.excute("com_exchange_use_open",0,cell)
							fwin:close(instance)
						end
					else
						local function responseExchangeCallback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								if response.node ~= nil then
									response.node:onUpdateDraw(true)

									if response.node.nCount == 0 then
										local activity = response.node.activity
										local cell = AprilFoolsDayPropExchange:createCell()
										cell:init(activity, response.node.index, response.node.listView)
										response.node.listView:addChild(cell)
										response.node.listView:requestRefreshView()
										response.node:removeFromParent(true)
									end

									state_machine.excute("april_fools_day_prop_exchange_activity_refresh_cost_prop", 0, nil)

									app.load("client.reward.DrawRareReward")
									local getRewardWnd = DrawRareReward:new()
									getRewardWnd:init(7)
									fwin:open(getRewardWnd, fwin._ui)
								end
							end
						end
						local cell = params._datas.cell
						protocol_command.get_activity_reward.param_list = cell.activity.activity_id.."\r\n" .. ""..tonumber(cell.index - 1).."\r\n".."0"
						NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, cell, responseExchangeCallback, false, nil)
					end
				else
					TipDlg.drawTextDailog(_string_piece_info[85])
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		state_machine.add(april_fools_day_prop_exchange_cell_exchange_terminal)
		state_machine.init()
	end
	
	-- call func init april_fools_day_prop_exchange_cell state machine.
	init_april_fools_day_prop_exchange_cell_terminal()
end
--返回可以兑换的物品数量
function AprilFoolsDayPropExchange:mayExchangeNum(activityInfo,limitNum)
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

function AprilFoolsDayPropExchange:onUpdateDraw(update)
	local root = self.roots[1]
	local activityInfo = self.activity.activity_Info[tonumber(self.index)]
	local countInfos = zstring.split(self.activity.activity_params, ",")

	local exchangeInfos = zstring.split(activityInfo.activityInfo_need_day, "@")
	local itemInfos = zstring.splits(exchangeInfos[1], ":", ",")

	-- 标题
	local Text_11 = ccui.Helper:seekWidgetByName(root, "Text_11")

	local porp_name = getItemNameAndQuality(zstring.splits(activityInfo.activityInfo_reward_select, "|", ",")[1])[1]
	if nil == porp_name or "" == porp_name  then 
		porp_name = activityInfo.activityInfo_name
	end
	Text_11:setString(porp_name)

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
			local rewardInfo_two = zstring.splits(activityInfo.activityInfo_reward_select, "|", ",")[2]
			local Panel_reward_2 = ccui.Helper:seekWidgetByName(root, "Panel_reward_2")
			local rewardIcon = ResourcesIconCell:createCell()
			if rewardInfo[4] then
				rewardIcon:init(tonumber(rewardInfo[1]), tonumber(rewardInfo[3]), rewardInfo[2], nil,nil,true,true,1,{shipStar = tonumber(rewardInfo[4])})
			else
				rewardIcon:init(tonumber(rewardInfo[1]), tonumber(rewardInfo[3]), rewardInfo[2], nil,nil,true,true,1)
			end
			Panel_reward_2:addChild(rewardIcon)
            
            local Panel_reward_3 = ccui.Helper:seekWidgetByName(root, "Panel_reward_3")
            if rewardInfo_two and (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and Panel_reward_3 then
				local rewardIcon = ResourcesIconCell:createCell()
				rewardIcon:init(tonumber(rewardInfo_two[1]), tonumber(rewardInfo_two[3]), rewardInfo_two[2], nil,nil,true,true,1,{shipStar = rewardInfo[4]})
				Panel_reward_3:addChild(rewardIcon)
            end
		end
	end
end
function AprilFoolsDayPropExchange:onInit()
	local csbAprilFoolsDayPropExchange = csb.createNode("activity/wonderful/april_fools_day_list.csb")
	local root = csbAprilFoolsDayPropExchange:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
	self:addChild(root)
	
	self:setContentSize(root:getChildByName("Panel_land_list"):getContentSize())

	-- 兑换奖励
	self.Button_lingqu = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12_4"), nil,
	{
		terminal_name = "april_fools_day_prop_exchange_cell_exchange",
		terminal_state = 0,
		isPressedActionEnabled = true,
		cell = self,
	}, nil, 0)

	self:onUpdateDraw()
end

function AprilFoolsDayPropExchange:onExit()
	
end

function AprilFoolsDayPropExchange:init(activity, index, listView)
	self.activity = activity
	self.index = index
	self.listView = listView
	self:onInit()
end

function AprilFoolsDayPropExchange:createCell()
	local cell = AprilFoolsDayPropExchange:new()
	cell:registerOnNodeEvent(cell)
	return cell
end