-- ----------------------------------------------------------------------------------------------------
-- 说明：累积充值
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
AccumlateRechargeableCell = class("AccumlateRechargeableCellClass", Window)
    
function AccumlateRechargeableCell:ctor()
    self.super:ctor()
	self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")
	app.load("client.cells.prop.prop_money_icon")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.ship.ship_head_cell")
	self.example = nil
	self.index = 0
	self.typeIndex = 7 -- 默认7类型的累冲
	self.isSelect = false   --是否为选择奖励类型
	self.selectConut = 0     -- 可选择数量
	self.shipInfoMould = nil      -- 可选择的武将模板
	self.reworld_sorting = {}
	self.rewardState = 0
    -- Initialize AccumlateRechargeableCell state machine.
    local function init_AccumlateRechargeableCell_terminal()
		--去充值
        local go_to_accumlate_button_terminal = {
            _name = "go_to_accumlate_button",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- fwin:open(RechargeDialog:new(), fwin._windows)
				state_machine.excute("shortcut_open_recharge_window", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--领取
		local get_accumlate_button_terminal = {
            _name = "get_accumlate_button",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if TipDlg.drawStorageTipo() == false then
	            	local typeIndex = params._datas._typeIndex
					local index = params._datas._index
					local mCell = params._datas._cell
					local _replyPhysical = params._datas.replyPhysical
					local param = params._datas
					if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
						or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
						if (typeIndex == 7 or typeIndex == 45 or typeIndex == 21)  and mCell.isSelect == true and mCell.selectConut > 1 then
							local activityId = _ED.active_activity[typeIndex].activity_id
							mCell.command_param_list = ""..activityId.."\r\n"..tonumber(index)-1
							app.load("client.activity.ActivityAccumlateRechargeableForDrawSelectAward")
							fwin:open(ActivityAccumlateRechargeableForDrawSelectAward:new():init(params), fwin._dview)
						else
							local function responseGetServerListCallback(response)
								if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
									if response.node ~= nil then
										-- mCell:rewadDraw(index)
										if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
											--response.node._cell:rewadDraw(response.node._index,mCell)
											response.node._cell:rewadDraw(response.node._index)
										else
											response.node._cell:rewadDraw(response.node._index)
										end
										if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
											state_machine.excute("activity_window_update_activity_page", 0, typeIndex)
										end
									end
								end
							end
							if TipDlg.drawStorageTipo() == false then
								local activityId = _ED.active_activity[typeIndex].activity_id
								protocol_command.get_activity_reward.param_list = ""..activityId.."\r\n"..(tonumber(index)-1).."\r\n".."1"
								NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, param, responseGetServerListCallback, false, nil)
							end							
						end
					else	
						local function responseGetServerListCallback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								-- mCell:rewadDraw(index)
								if response.node ~= nil then
									response.node._cell:rewadDraw(response.node._index)
									if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
										state_machine.excute("activity_window_update_activity_page", 0, typeIndex)
									end
								end
							end
						end
						local activityId = _ED.active_activity[typeIndex].activity_id
						protocol_command.get_activity_reward.param_list = ""..activityId.."\r\n"..(tonumber(index)-1).."\r\n1"
						NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, param, responseGetServerListCallback, false, nil)
					end
					return true
				end
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(go_to_accumlate_button_terminal)
        state_machine.add(get_accumlate_button_terminal)
        state_machine.init()
    end
    
    -- call func init AccumlateRechargeableCell state machine.
    init_AccumlateRechargeableCell_terminal()
end

function AccumlateRechargeableCell:rewadDraw(_index,mCell)
	local root = self.roots[1]
	local getRewardWnd = DrawRareReward:new()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		--getRewardWnd:init(7,nil,mCell.reworld_sorting)
		getRewardWnd:init(7)			
	else
		getRewardWnd:init(7)
	end
	
	fwin:open(getRewardWnd,fwin._ui)
	local activity = _ED.active_activity[self.typeIndex]

	if self.typeIndex == 45 then
		self:onUpdateDrawText()
		self:onUpdateDrawButton()
	end
	
	local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_13")
	local GetButton = ccui.Helper:seekWidgetByName(root, "Button_12")
	local Text_13 = ccui.Helper:seekWidgetByName(root, "Text_13")
	if nil ~= Text_13 then
		Text_13:setVisible(true)
	end
	if tonumber(activity.activity_Info[_index].activityInfo_isReward) == 1 then--领完了。
		Image_13:setVisible(true)
		GetButton:setVisible(false)
		if nil ~= Text_13 then
			Text_13:setVisible(false)
		end
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or 
		__lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		local GoButton = ccui.Helper:seekWidgetByName(root, "Button_11")
		if tonumber(activity.activity_Info[_index].activityInfo_isReward) == -1 then --还有领取次数，但是要充值
			GetButton:setVisible(false)
			GoButton:setVisible(true)
		end
	end
end

function AccumlateRechargeableCell:onUpdateDrawText()
	local root = self.roots[1]
	local activity = _ED.active_activity[self.typeIndex]
	
	local titleListText = ccui.Helper:seekWidgetByName(root, "Text_11")
	
	local scheduleText = ccui.Helper:seekWidgetByName(root, "Text_13")

	if self.typeIndex == 45 then
		-- FURY: "Text_12" no esta en landed_gifts_list.csb de este proyecto.
		local fury_text_12 = ccui.Helper:seekWidgetByName(root, "Text_12")
		if fury_text_12 ~= nil then
			fury_text_12:setString(_string_piece_info[367] .. "：")
		end
		
		local available_count = zstring.tonumber(activity.activity_Info[self.index].available_count)
		
		local completed_count = zstring.tonumber(activity.activity_Info[self.index].completed_count)
		
		titleListText:setString(string.format(_tip_info_activity[self.typeIndex][3],self.example.activityInfo_need_day))
		scheduleText:setString((available_count - completed_count).."/"..available_count)
	else
		titleListText:setString(_string_piece_info[206]..self.example.activityInfo_need_day.._string_piece_info[207])
		if tonumber(activity.total_recharge_count) >= tonumber(self.example.activityInfo_need_day) then
			scheduleText:setString(self.example.activityInfo_need_day.."/"..self.example.activityInfo_need_day)
		else
			scheduleText:setString(activity.total_recharge_count.."/"..self.example.activityInfo_need_day)
		end
	end

end

function AccumlateRechargeableCell:onUpdateDrawLiset()
	local root = self.roots[1]
	local activity = _ED.active_activity[self.typeIndex]
	local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_11")
	ListViewDraw:removeAllItems()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
	elseif __lua_project_id == __lua_project_warship_girl_a 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_gragon_tiger_gate
		then
		if self.typeIndex == 7 or self.typeIndex == 45 or self.typeIndex == 21 then
			local shipinfo = self.example.activityInfo_reward_select  --奖励选择
			if shipinfo ~= nil and shipinfo ~= "" and shipinfo ~= " " and zstring.tonumber(shipinfo) ~= 0 then
				self.isSelect = true
				local shipinfomould = zstring.split(shipinfo, ",")
				local count = #shipinfomould
				self.selectConut = count
				self.shipInfoMould = shipinfomould
				for i = 1,count do
					local cell = ShipHeadCell:createCell()
					if __lua_project_id == __lua_project_gragon_tiger_gate
						then
						cell:init(nil, cell.enum_type._DUPLICATE, tonumber(shipinfomould[i]), 1, true)
					else
						cell:init(nil, cell.enum_type._DUPLICATE, tonumber(shipinfomould[i]), 1, false)
					end
					ListViewDraw:addChild(cell)
				end
				ListViewDraw:requestRefreshView()
				return
			end
		end
	end
	local cell_tables = {}
	local index = 1
	if tonumber(activity.activity_Info[self.index].activityInfo_silver) > 0 then--可领取银币数量
		-- local cell = ResourcesIconCell:createCell()
		-- cell:init(0, 0, 0, {show_reward_list={{prop_type = 1, item_value = activity.activity_Info[self.index].activityInfo_silver}}})
		-- ListViewDraw:addChild(cell)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			local cell = ResourcesIconCell:createCell()
	        cell:init(1, tonumber(activity.activity_Info[self.index].activityInfo_silver), -1,nil,nil,true,true)
	        -- ListViewDraw:addChild(cell)
	        table.insert(cell_tables, cell)
	        local rewardinfo = {}
            rewardinfo.type = 1
            rewardinfo.id = -1
            rewardinfo.number = tonumber(activity.activity_Info[self.index].activityInfo_silver)
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
		else
			local cell = propMoneyIcon:createCell()
			if __lua_project_id == __lua_project_gragon_tiger_gate
				then
				cell:init("1",activity.activity_Info[self.index].activityInfo_silver,_All_tip_string_info._fundName)
			else
				cell:init("1",activity.activity_Info[self.index].activityInfo_silver,nil)
			end
			-- ListViewDraw:addChild(cell)
			table.insert(cell_tables, cell)
		end
		
	end
	if tonumber(activity.activity_Info[self.index].activityInfo_gold) > 0 then--奖励1可领取金币数量
		-- local cell = ResourcesIconCell:createCell()
		-- cell:init(0, 0, 0, {show_reward_list={{prop_type = 2, item_value = activity.activity_Info[self.index].activityInfo_gold}}})
		-- ListViewDraw:addChild(cell)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			local cell = ResourcesIconCell:createCell()
	        cell:init(2, tonumber(activity.activity_Info[self.index].activityInfo_gold), -1,nil,nil,true,true)
	        -- ListViewDraw:addChild(cell)
	        table.insert(cell_tables, cell)
	        local rewardinfo = {}
            rewardinfo.type = 2
            rewardinfo.id = -1
            rewardinfo.number = tonumber(activity.activity_Info[self.index].activityInfo_gold)
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
		else
			local cell = propMoneyIcon:createCell()
			if __lua_project_id == __lua_project_gragon_tiger_gate
				then
				cell:init("2",activity.activity_Info[self.index].activityInfo_gold,_All_tip_string_info._crystalName)
			else
				cell:init("2",activity.activity_Info[self.index].activityInfo_gold,nil)
			end
			-- ListViewDraw:addChild(cell)
			table.insert(cell_tables, cell)
		end
	end
	if tonumber(activity.activity_Info[self.index].activityInfo_food) > 0 then--奖励1可领取体力数量
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			local cell = ResourcesIconCell:createCell()
	        cell:init(12, tonumber(activity.activity_Info[self.index].activityInfo_food), -1,nil,nil,true,true)
	        -- ListViewDraw:addChild(cell)
	        table.insert(cell_tables, cell)
	        local rewardinfo = {}
            rewardinfo.type = 12
            rewardinfo.id = -1
            rewardinfo.number = tonumber(activity.activity_Info[self.index].activityInfo_food)
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
		else
			local cell = ResourcesIconCell:createCell()
			cell:init(0, 0, 0, {show_reward_list={{prop_type = 12, item_value = activity.activity_Info[self.index].activityInfo_food}}})
			-- ListViewDraw:addChild(cell)
			table.insert(cell_tables, cell)
		end
	end
	if tonumber(activity.activity_Info[self.index].activityInfo_honour) > 0 then--奖励1可领取声望数量
		-- local cell = ResourcesIconCell:createCell()
		-- cell:init(0, 0, 0, {show_reward_list={{prop_type = 3, item_value = activity.activity_Info[self.index].activityInfo_honour}}})
		-- ListViewDraw:addChild(cell)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			local cell = ResourcesIconCell:createCell()
	        cell:init(3, tonumber(activity.activity_Info[self.index].activityInfo_honour), -1,nil,nil,true,true)
	        -- ListViewDraw:addChild(cell)
	        table.insert(cell_tables, cell)
	        local rewardinfo = {}
            rewardinfo.type = 3
            rewardinfo.id = -1
            rewardinfo.number = tonumber(activity.activity_Info[self.index].activityInfo_honour)
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
		else
			local cell = propMoneyIcon:createCell()
			cell:init("3",activity.activity_Info[self.index].activityInfo_honour,nil)
			-- ListViewDraw:addChild(cell)
			table.insert(cell_tables, cell)
		end
	end
	if tonumber(activity.activity_Info[self.index].activityInfo_equip_count) > 0 then	--可领取装备种类数量
		for n, v in pairs(activity.activity_Info[self.index].activityInfo_equip_info) do
			-- local cell = ResourcesIconCell:createCell()
			-- cell:init(cell.enum_type.EQUIPMENT_INFORMATION, v.equipMouldCount, v.equipMould, nil)
			-- ListViewDraw:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				--print("------------领取装备种类----------------")
				local cell = ResourcesIconCell:createCell()
		        cell:init(7, tonumber(v.equipMouldCount), v.equipMould,nil,nil,true,true,nil,{equipQuality = 3})
		        -- ListViewDraw:addChild(cell)
		        table.insert(cell_tables, cell)
		        local rewardinfo = {}
	            rewardinfo.type = 7
	            rewardinfo.id = v.equipMould
	            rewardinfo.number = tonumber(v.equipMouldCount)
	            self.reworld_sorting[index] = rewardinfo
	            index = index + 1
			else
				local cell = EquipIconCell:createCell()
				cell:init(10, nil, v.equipMould, nil, nil, v.equipMouldCount)
				-- ListViewDraw:addChild(cell)
				table.insert(cell_tables, cell)
			end
		end
	end
	if tonumber(activity.activity_Info[self.index].activityInfo_general_soul) > 0 then	--可领取水雷魂种类数量
		-- local cell = ResourcesIconCell:createCell()
		-- cell:init(cell.enum_type.EQUIPMENT_INFORMATION, v.equipMouldCount, v.equipMould, nil)
		-- ListViewDraw:addChild(cell)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			local cell = ResourcesIconCell:createCell()
	        cell:init(5, tonumber(activity.activity_Info[self.index].activityInfo_general_soul), -1,nil,nil,true,true)
	        -- ListViewDraw:addChild(cell)
	        table.insert(cell_tables, cell)
	        local rewardinfo = {}
            rewardinfo.type = 5
            rewardinfo.id = -1
            rewardinfo.number = tonumber(activity.activity_Info[self.index].activityInfo_general_soul)
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
		else
			local cell = propMoneyIcon:createCell()
			if __lua_project_id == __lua_project_gragon_tiger_gate
				then	
				cell:init("5",zstring.tonumber(activity.activity_Info[self.index].activityInfo_general_soul), "英魂")
			else
				cell:init("5",zstring.tonumber(activity.activity_Info[self.index].activityInfo_general_soul),nil)
			end
			-- ListViewDraw:addChild(cell)
			table.insert(cell_tables, cell)
		end
	end
	if tonumber(activity.activity_Info[self.index].activityInfo_prop_count) > 0 then--可领取道具种类数量
		for n, v in pairs(activity.activity_Info[self.index].activityInfo_prop_info) do
			-- local cell = ResourcesIconCell:createCell()
			-- cell:init(cell.enum_type.PROP_INFORMATION, v.propMouldCount, v.propMould, nil)
			-- ListViewDraw:addChild(cell)
			-- local cell = PropIconCell:createCell()
			-- cell:init(26, v.propMould,v.propMouldCount)
			-- print("v.propMould-------------",v.propMould)
			-- ListViewDraw:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
		        local cell = ResourcesIconCell:createCell()
		        cell:init(6, tonumber(v.propMouldCount), v.propMould,nil,nil,true,true)
		        -- ListViewDraw:addChild(cell)
		        table.insert(cell_tables, cell)
		        local rewardinfo = {}
	            rewardinfo.type = 6
	            rewardinfo.id = v.propMould
	            rewardinfo.number = tonumber(v.propMouldCount)
	            self.reworld_sorting[index] = rewardinfo
	            index = index + 1
			else
				local cell = self:getItemCell(v.propMould,nil,v.propMouldCount)
				-- ListViewDraw:addChild(cell)
				table.insert(cell_tables, cell)
			end		
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		--其他
		local otherRewards = zstring.splits(activity.activity_Info[self.index].activityInfo_reward_select, "|", ",")
	    if #otherRewards > 0 then 
	        for i, v in pairs(otherRewards) do
	            -- 类型、ID、数量、星级
	            if #v >= 3 then
	                local cell = ResourcesIconCell:createCell()
	                local rewardType = tonumber(v[1])
	                if 13 == rewardType then
	                    local table = {}
	                    if v[4] ~= nil and tonumber(v[4]) ~= -1 then
	                        table.shipStar = tonumber(v[4])
	                    end
	                    cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1,table)
	                    local ships = fundShipWidthTemplateId(tonumber(v[2]))
	                    if ships == nil then
	                        local rewardinfo = {}
	                        rewardinfo.type = rewardType
	                        rewardinfo.id = tonumber(v[2])
	                        rewardinfo.number = tonumber(v[3])
	                        self.reworld_sorting[index] = rewardinfo
	                        index = index + 1
	                    else
	                    	local prop_mlds = dms.int(dms["ship_mould"], tonumber(v[2]), ship_mould.fitSkillOne)
	                        local number_info = zstring.split(dms.string(dms["ship_config"], 13, ship_config.param),"!")[tonumber(v[4])]
	                        local ability = dms.int(dms["ship_mould"], tonumber(v[2]), ship_mould.ability)
	                        local number_data = zstring.split(number_info,"|")[ability-13+1]
	                        local m_number = tonumber(zstring.split(number_data,",")[2])

	                        -- local prop_mlds = dms.int(dms["ship_mould"], tonumber(v[2]), ship_mould.fitSkillOne)
	                        -- local m_number = dms.int(dms["prop_mould"], prop_mlds, prop_mould.split_or_merge_count)
	                        local rewardinfo = {}
	                        rewardinfo.type = 6
	                        rewardinfo.id = prop_mlds
	                        rewardinfo.number = m_number
	                        self.reworld_sorting[index] = rewardinfo
	                        index = index + 1
	                    end
	                elseif 18 == rewardType then
	                    cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1)
	                    local rewardinfo = {}
			            rewardinfo.type = rewardType
			            rewardinfo.id = tonumber(v[2])
			            rewardinfo.number = tonumber(v[3])
			            self.reworld_sorting[index] = rewardinfo
			            index = index + 1
	                else
	                	if rewardType == 7 then
	                    	cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1,{equipQuality = 3})
	                    elseif rewardType == 64 then
	                    	local limit_time_index  = dms.int(dms["ship_skin_mould"], tonumber(v[2]), ship_skin_mould.duration)
							local des_time_r = zstring.tonumber(limit_time_index) == -1 and tipStringInfo_evolution_status_tips[4] or limit_time_index .. tipStringInfo_evolution_status_tips[5]
	                    	cell:init(rewardType, 0, tonumber(v[2]),nil,nil,true,true,1,{des_time = des_time_r, skin_num = 1})
	                    else
	                    	cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1)
	                    end
	                    local rewardinfo = {}
			            rewardinfo.type = rewardType
			            rewardinfo.id = tonumber(v[2])
			            rewardinfo.number = tonumber(v[3])
			            self.reworld_sorting[index] = rewardinfo
			            index = index + 1
	                end
	                -- ListViewDraw:addChild(cell)
	                table.insert(cell_tables, cell)
	            end
	        end
	    end
	end

    local ScrollView_icon = ccui.Helper:seekWidgetByName(root, "ScrollView_icon")
    if ScrollView_icon ~= nil then
    	ScrollView_icon:removeAllChildren(true)

		local total_col = 2
		local count = #cell_tables
		if count > 0 then
			local cell_size = cell_tables[1]:getContentSize()
		    local scroll_width = ScrollView_icon:getContentSize().width
		    local scroll_height = ScrollView_icon:getContentSize().height
		    local cell_width = cell_size.width
		    local cell_height = cell_size.height - 24
		    local height = cell_height * math.ceil(count / total_col)
		    local width = scroll_width / total_col
		    if height > scroll_height then
		        scroll_height = height
		        ScrollView_icon:setInnerContainerSize(cc.size(scroll_width, scroll_height))
		    end

		    for k, v in pairs(cell_tables) do
		    	ScrollView_icon:addChild(v)
		        local row = math.floor((k - 1) % total_col) + 1
		        local col = math.floor((k - 1) / total_col) + 1
		        local posX = scroll_width * row / total_col - width / 2 - cell_width / 2
		        local posY = scroll_height - cell_height * col - 7
		        v:setPosition(posX, posY)
		    end
		end
    else
		for k, cell in pairs(cell_tables) do
			ListViewDraw:addChild(cell)
		end

		ListViewDraw:requestRefreshView()
	end

end
--道具
function AccumlateRechargeableCell:getItemCell(mid,mtype,count,isCertainly)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = mid
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		cellConfig.isShowName = true
	else
		cellConfig.isShowName = false
	end
	cellConfig.isDebris = true
	cellConfig.mouldType = mtype
	cellConfig.touchShowType = 1
	cellConfig.count = count
	cellConfig.isCertainly = isCertainly
	cell:init(cellConfig)
	return cell
end


function AccumlateRechargeableCell:onUpdateDrawButton()
	local root = self.roots[1]
	local activity = _ED.active_activity[self.typeIndex]

	local GotoButton = ccui.Helper:seekWidgetByName(root, "Button_11")
	local GetButton = ccui.Helper:seekWidgetByName(root, "Button_12")
	local Button_13 = ccui.Helper:seekWidgetByName(root, "Button_13")
	local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_13")
	Button_13:setVisible(false)
	if tonumber(self.example.activityInfo_isReward) < 0 then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			GotoButton:setVisible(true)
			GetButton:setVisible(false)
			Image_13:setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_13"):setVisible(true)
			-- GetButton:setTouchEnabled(false)
			-- GetButton:setBright(false)
			self.rewardState = 0
		else
			GotoButton:setVisible(true)
			GetButton:setVisible(false)
			Image_13:setVisible(false)
		end
	elseif tonumber(self.example.activityInfo_isReward) == 0 then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			GotoButton:setVisible(false)
			GetButton:setVisible(true)
			Image_13:setVisible(false)
			GetButton:setTouchEnabled(true)
			GetButton:setBright(true)
			-- GetButton:setTouchEnabled(true)
			-- GetButton:setBright(true)
			ccui.Helper:seekWidgetByName(root, "Text_13"):setVisible(false)
			self.rewardState = 1
		else
			GotoButton:setVisible(false)
			GetButton:setVisible(true)
			Image_13:setVisible(false)
		end
	else
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			GotoButton:setVisible(false)
			GetButton:setVisible(false)
			-- GetButton:setBright(false)
			-- GetButton:setTouchEnabled(false)
			Image_13:setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_13"):setVisible(false)
			self.rewardState = 2
		else
			GotoButton:setVisible(false)
			GetButton:setVisible(false)
			-- GetButton:setBright(false)
			-- GetButton:setTouchEnabled(false)
			Image_13:setVisible(true)
		end
	end
end

function AccumlateRechargeableCell:onUpdateDraw()
	self:onUpdateDrawText()
	self:onUpdateDrawLiset()
	self:onUpdateDrawButton()
end

function AccumlateRechargeableCell:onEnterTransitionFinish()

end

function AccumlateRechargeableCell:onInit()
    local root = cacher.createUIRef("activity/wonderful/landed_gifts_list.csb", "root")
 --    table.insert(self.roots, root)
	-- local csbAccumlateRechargeableCell = csb.createNode("activity/wonderful/landed_gifts_list.csb")
 --    local root = csbAccumlateRechargeableCell:getChildByName("root")
    table.insert(self.roots, root)
	root:removeFromParent(false)
    self:addChild(root)
	
	self:setContentSize(root:getChildByName("Panel_land_list"):getContentSize())
	state_machine.excute("shortcut_function_goto_log", 0, shortcut.shortcut_function_back_scene_enum.AccumlateRechargeable)
	-- 列表控件动画播放
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		local action = csb.createTimeline("activity/wonderful/landed_gifts_list.csb")
	    root:runAction(action)
	    action:play("list_view_cell_open", false)
	end
	
	self:onUpdateDraw()
	-- self:onUpdateDrawLiset()
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)
    
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_11"), nil, 
		{
			terminal_name = "go_to_accumlate_button", 
			terminal_state = 0, 
			isPressedActionEnabled = true
		},
		nil,0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12"), nil, 
		{
			terminal_name = "get_accumlate_button", 
			terminal_state = 0, 
			_index = self.index,
			_cell = self,		
			_typeIndex = self.typeIndex,
			isPressedActionEnabled = true
		},
		nil,0)
end

function AccumlateRechargeableCell:clearUIInfo( ... )
    local root = self.roots[1]
	local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_11")
	if ListViewDraw ~= nil then
		ListViewDraw:removeAllItems()
	end
	local Button_11 = ccui.Helper:seekWidgetByName(root, "Button_11")
	local Button_12 = ccui.Helper:seekWidgetByName(root, "Button_12")
	local Button_13 = ccui.Helper:seekWidgetByName(root, "Button_13")
	local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_13")
	local Text_13 = ccui.Helper:seekWidgetByName(root, "Text_13")
	if Button_11 ~= nil then
		Button_11:setVisible(true)
		Button_12:setVisible(true)
		Button_12:setTouchEnabled(true)
		Button_12:setBright(true)
		Button_13:setVisible(false)
		Image_13:setVisible(false)
		Text_13:setVisible(true)
		Text_13:setString("")
	end
	local ScrollView_icon = ccui.Helper:seekWidgetByName(root, "ScrollView_icon")
	if ScrollView_icon ~= nil then
		ScrollView_icon:removeAllChildren(true)
	end
end

function AccumlateRechargeableCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/landed_gifts_list.csb", self.roots[1])
end

function AccumlateRechargeableCell:init(example,index,typeIndex)
	self.example = example
	self.index = index
	self.typeIndex = tonumber(typeIndex) or 7

	self:onInit()
end


function AccumlateRechargeableCell:createCell()
	local cell = AccumlateRechargeableCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end