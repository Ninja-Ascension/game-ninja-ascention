-- ----------------------------------------------------------------------------------------------------
-- 说明：数码活动成就类型cell
-------------------------------------------------------------------------------------------------------
SmActivityCompageCountCell = class("SmActivityCompageCountCellClass", Window)
    
function SmActivityCompageCountCell:ctor()
    self.super:ctor()
	self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")
	app.load("client.cells.prop.prop_money_icon")
	self.example = nil
	self.index = 0
	self.activityType = 0
	self.rewardState = 0

	self.reworld_sorting = {}
    -- Initialize SmActivityCompageCountCell state machine.
    local function init_SmActivityCompageCountCell_terminal()
		
		--领取
		local sm_activity_compage_count_cell_reward_terminal = {
            _name = "sm_activity_compage_count_cell_reward",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if TipDlg.drawStorageTipo() == false then
					local index = params._datas._index
					local tempCell = params._datas._cell
					local _replyPhysical = params._datas.replyPhysical
					local param = params._datas
	            	local activityType = tempCell.activityType
					local function responseGetServerListCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
								if response.node._cell ~= nil and response.node._cell.roots ~= nil and response.node._cell.roots[1] ~= nil then
									response.node._cell:rewadDraw(response.node._index,tempCell)
								end
							end
							state_machine.excute("activity_window_update_activity_page", 0, activityType)

							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(7, nil, response.node.reworld_sorting)
							fwin:open(getRewardWnd, fwin._ui)
						end
					end
					local activityId = _ED.active_activity[tempCell.activityType].activity_id	
					protocol_command.get_activity_reward.param_list = ""..activityId.."\r\n"..(tonumber(index)-1).."\r\n1"
					NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, param, responseGetServerListCallback, false, nil)
					return true
				end
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 前往
        local sm_activity_compage_count_cell_go_to_terminal = {
            _name = "sm_activity_compage_count_cell_go_to",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas._cell
            	local index = params._datas._index
            	local trace_id = 0
            	if tonumber(cell.activityType) == 83 then 		-- 竞技场积分奖励
            		trace_id = 297
        		elseif tonumber(cell.activityType) == 81 
        			or tonumber(cell.activityType) == 116
        			then -- 抽卡活动-送拉拉兽
        			trace_id = 291
        		elseif tonumber(cell.activityType) == 95 
	        		or tonumber(cell.activityType) == 96 
	        		then -- 抽装备
        			trace_id = 280
        		elseif tonumber(cell.activityType) == 102 then -- 购买体力
        			trace_id = 293
        		elseif tonumber(cell.activityType) == 103 then -- 点金奖励
        			trace_id = 292
        		elseif tonumber(cell.activityType) == 104 
        			or tonumber(cell.activityType) == 105
        			then -- 试炼
        			trace_id = 298
        		elseif tonumber(cell.activityType) == 106 then -- 充值送资源
        			trace_id = 0
        			state_machine.excute("shortcut_open_recharge_window", 0, nil)
        		elseif tonumber(cell.activityType) == 108 then -- 普通副本
        			trace_id = 288
        		elseif tonumber(cell.activityType) == 109 then -- 精英副本
        			trace_id = 289
        		elseif tonumber(cell.activityType) == 126 or tonumber(cell.activityType) == 113 then --完成任务送纪念道具,备战奖励
        			local activity_info = _ED.active_activity[cell.activityType].activity_Info
        			local achieve_id 	= tonumber(zstring.split(activity_info[index].activityInfo_need_day, ",")[1])
        			trace_id 			= tonumber(dms.string(dms["achieve"], achieve_id, achieve.track_address))
        		elseif tonumber(cell.activityType) == 138 then -- 抽合金有礼
					trace_id = 373
				elseif tonumber(cell.activityType) == 141 then -- 探索有礼
        			trace_id = 568
        		elseif tonumber(cell.activityType) == 140 then -- 净化挑战有礼
        			trace_id = 299
        		end
        		if trace_id > 0 then
        			state_machine.excute("shortcut_function_trace", 0, {trace_function_id = trace_id, _datas = {}})
        		end
            	return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(sm_activity_compage_count_cell_reward_terminal)
        state_machine.add(sm_activity_compage_count_cell_go_to_terminal)
        state_machine.init()
    end
    
    -- call func init SmActivityCompageCountCell state machine.
    init_SmActivityCompageCountCell_terminal()
end

function SmActivityCompageCountCell:rewadDraw(_index,tempCell)
	local root = self.roots[1]
	
	local getRewardWnd = DrawRareReward:new()
	getRewardWnd:init(7,nil,tempCell.reworld_sorting)
	-- getRewardWnd:init(7)
	fwin:open(getRewardWnd,fwin._ui)
	local activity = _ED.active_activity[self.activityType]
	
	local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_13")
	local GetButton = ccui.Helper:seekWidgetByName(root, "Button_12")
	local scheduleText = ccui.Helper:seekWidgetByName(root, "Text_13")
	--> print("tonumber(activity.activity_Info[_index].activityInfo_isReward)===",tonumber(activity.activity_Info[_index].activityInfo_isReward))
	if tonumber(activity.activity_Info[_index].activityInfo_isReward) == 1	then--DOTO	明明满足条件了。
		Image_13:setVisible(true)
		GetButton:setVisible(false)
		scheduleText:setVisible(false)
	end
end

function SmActivityCompageCountCell:updateGetRewardEnd( _index )
	local root = self.roots[1]
	
	local getRewardWnd = DrawRareReward:new()
	getRewardWnd:init(7)
	fwin:open(getRewardWnd,fwin._ui)
	local activity = _ED.active_activity[self.activityType]
	
	local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_13")
	local GetButton = ccui.Helper:seekWidgetByName(root, "Button_12")
	local scheduleText = ccui.Helper:seekWidgetByName(root, "Text_13")
	--> print("tonumber(activity.activity_Info[_index].activityInfo_isReward)===",tonumber(activity.activity_Info[_index].activityInfo_isReward))
	-- if tonumber(activity.activity_Info[_index].activityInfo_isReward) == 1	then--DOTO	明明满足条件了。
		Image_13:setVisible(true)
		GetButton:setVisible(false)
		scheduleText:setVisible(false)
	-- end
end

function SmActivityCompageCountCell:getPropIconCell(mid)
    app.load("client.cells.prop.model_prop_icon_cell")
    local iconCell = ModelPropIconCell:createCell()
    local config = iconCell:createConfig(mid, 1, true, 1, 13)
    config.isDebris = true
    iconCell:init(config)
    return iconCell
end

function SmActivityCompageCountCell:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[self.activityType]
	local other_info = zstring.split(activity.activity_params ,"|")
	local activity_params = other_info[1]
	local all_number = zstring.split(activity_params ,",")
	local silver_number = tonumber(all_number[1])
	local golds_number = tonumber(all_number[2])
	local titleListText = ccui.Helper:seekWidgetByName(root, "Text_11")
	local titleListTextInfo = ""

	local tipProperty = nil 
	local activityString = nil

	-- 多语言活动配置
	if tipStringInfo_activity_local_data_property then
		activityString = tipStringInfo_activity_local_data_property[tostring(self.activityType)]
	end

	-- FURY: el 113 y el 126 traen `tipStringInfo_activity_local_data_property`
	-- con la CADENA VACIA (es/TipStringInfo.lua:4438 y :4441), asi que esta
	-- guarda dejaba MUERTA la rama propia de los dos -la de mas abajo, que
	-- saca el texto de `achieve` del PAQUETE DE IDIOMA, ya traducido- y la
	-- fila caia al nombre del servidor, que viaja en INGLES y con guiones
	-- (buy_gold_rewards.erl:303-312). Se les deja entrar siempre.
	if (activityString and "" ~= activityString)
		or 113 == tonumber(self.activityType) or 126 == tonumber(self.activityType) then
		if 138 == tonumber(self.activityType) then
			local infoDatas = zstring.split(self.example.activityInfo_need_day,":")
			-- DSC重塑合金文本优化bug3460
			if __lua_project_id == __lua_project_l_digital then
				local strList = tipStringInfo_activity_local_data_property[tostring(self.activityType)]
				local strIndex = 1
				-- 1是钻石 2是金币
				if tonumber(infoDatas[1]) == 1 then
					strIndex = 1
				elseif tonumber(infoDatas[1]) == 2 then
					strIndex = 2
				end
				tipProperty = string.format(strList[strIndex], tonumber(infoDatas[2]))
			else
				tipProperty = string.format(tipStringInfo_activity_local_data_property[tostring(self.activityType)],tonumber(infoDatas[2]))
			end
		elseif 81 == tonumber(self.activityType) then
			local infoDatas = zstring.split(self.example.activityInfo_need_day,",")
			local str = zstring.split(tipStringInfo_activity_local_data_property[tostring(self.activityType)],",")
			tipProperty = string.format(str[tonumber(infoDatas[1]) + 1],tonumber(infoDatas[2]))
		elseif 113 == tonumber(self.activityType) or 126 == tonumber(self.activityType) then
			local infoId = zstring.split(self.example.activityInfo_need_day,",")
			local activityId = tonumber(infoId[1])
			local activityValue = tonumber(infoId[2])
			local str = dms.string(dms["achieve"],activityId,achieve.title)
			local strSub = zstring.split(str,"%d")
			local length = table.nums(strSub)
			
			tipProperty = strSub[1]..tostring(activityValue)..strSub[length]
		else
			tipProperty = string.format(tipStringInfo_activity_local_data_property[tostring(self.activityType)], zstring.tonumber(self.example.activityInfo_need_day))
		end
	end

	if nil ~= tipProperty then 
		titleListTextInfo = tipProperty
	else
		titleListTextInfo = self.example.activityInfo_name
	end
	titleListText:setString(titleListTextInfo)
	local scheduleText = ccui.Helper:seekWidgetByName(root, "Text_13")
	local cost_type = nil
	if tonumber(self.activityType) == 83 
		or tonumber(self.activityType) == 102
		or tonumber(self.activityType) == 103
		or tonumber(self.activityType) == 104
		or tonumber(self.activityType) == 105
		or tonumber(self.activityType) == 95
		or tonumber(self.activityType) == 96
		or tonumber(self.activityType) == 106
		or tonumber(self.activityType) == 108
		or tonumber(self.activityType) == 109
		or tonumber(self.activityType) == 110
		or tonumber(self.activityType) == 115
		or tonumber(self.activityType) == 140
		or tonumber(self.activityType) == 141
		then
		if tonumber(activity_params) > tonumber(self.example.activityInfo_need_day) then
			scheduleText:setString(self.example.activityInfo_need_day.."/"..self.example.activityInfo_need_day)
		else
			scheduleText:setString(activity_params.."/"..self.example.activityInfo_need_day)
		end
	elseif tonumber(self.activityType) == 81 
		or tonumber(self.activityType) == 116
		then
		cost_type = zstring.split(self.example.activityInfo_need_day ,",")
		if tonumber(cost_type[1]) == 0 then
			if tonumber(silver_number) > tonumber(cost_type[2]) then
				scheduleText:setString(cost_type[2].."/"..cost_type[2])
			else
				scheduleText:setString(silver_number.."/"..cost_type[2])
			end
		else
			if tonumber(golds_number) > tonumber(cost_type[2]) then
				scheduleText:setString(cost_type[2].."/"..cost_type[2])
			else
				scheduleText:setString(golds_number.."/"..cost_type[2])
			end
		end
	elseif tonumber(self.activityType) == 113 
		or tonumber(self.activityType) == 126
		then
		other_info = other_info[self.index]
		scheduleText:setString(zstring.split(other_info, ",")[2].."/"..zstring.split(self.example.activityInfo_need_day, ",")[2])
	elseif tonumber(self.activityType) == 138 then
		local have_type = zstring.tonumber(zstring.split(self.example.activityInfo_need_day, ":")[1])
		local max_nums = zstring.tonumber(zstring.split(self.example.activityInfo_need_day, ":")[2])
		local have_num = other_info[have_type]
		if tonumber(have_num) > tonumber(max_nums) then
			scheduleText:setString(max_nums.."/"..max_nums)
		else
			scheduleText:setString(have_num.."/"..max_nums)
		end
	end
	
	local GetButton = ccui.Helper:seekWidgetByName(root, "Button_12") 	 	-- 领取	
	local Button_11 = ccui.Helper:seekWidgetByName(root, "Button_11")		-- 充值
	local Button_13 = ccui.Helper:seekWidgetByName(root, "Button_13") 		-- 前往
	local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_13") 		-- 已领取
	Button_11:setVisible(false)
	GetButton:setVisible(false)
	GetButton:setTouchEnabled(true)
	GetButton:setBright(true)
	Button_13:setVisible(false)
	Image_13:setVisible(false)
	scheduleText:setVisible(true)
	local isComplete = 0
	local max = 0
	if tonumber(self.activityType) == 83 
		or tonumber(self.activityType) == 95
		or tonumber(self.activityType) == 96
		or tonumber(self.activityType) == 102
		or tonumber(self.activityType) == 103
		or tonumber(self.activityType) == 104
		or tonumber(self.activityType) == 105
		or tonumber(self.activityType) == 106
		or tonumber(self.activityType) == 108
		or tonumber(self.activityType) == 109
		or tonumber(self.activityType) == 110
		or tonumber(self.activityType) == 115
		or tonumber(self.activityType) == 140
		or tonumber(self.activityType) == 141
		then
		isComplete = tonumber(activity_params)
		max = tonumber(activity.activity_Info[self.index].activityInfo_need_day)
	elseif tonumber(self.activityType) == 81 
		or tonumber(self.activityType) == 116
		then
		if tonumber(cost_type[1]) == 0 then
			isComplete = silver_number
		else
			isComplete = golds_number
		end
		max = tonumber(cost_type[2])
	elseif tonumber(self.activityType) == 113
		or tonumber(self.activityType) == 126 
		then
		isComplete = tonumber(zstring.split(other_info, ",")[2])
		max = tonumber(zstring.split(self.example.activityInfo_need_day, ",")[2])
	elseif tonumber(self.activityType) == 138 then
		local have_type = zstring.tonumber(zstring.split(self.example.activityInfo_need_day, ":")[1])
		max = zstring.tonumber(zstring.split(self.example.activityInfo_need_day, ":")[2])
		isComplete = tonumber(other_info[have_type])
	end
	if isComplete < max then
		self.rewardState = 0
		if tonumber(self.activityType) == 110
		-- 	or tonumber(self.activityType) == 102
		-- 	or tonumber(self.activityType) == 104
		-- 	or tonumber(self.activityType) == 105
		-- 	or tonumber(self.activityType) == 95
		-- 	or tonumber(self.activityType) == 96
		-- 	or tonumber(self.activityType) == 106
		-- 	or tonumber(self.activityType) == 108
		-- 	or tonumber(self.activityType) == 109
			-- or tonumber(self.activityType) == 110
			-- or tonumber(self.activityType) == 113
			or tonumber(self.activityType) == 115
			-- or tonumber(self.activityType) == 126
			then
			GetButton:setVisible(true)
			GetButton:setTouchEnabled(false)
			GetButton:setBright(false)
		else
			Button_13:setVisible(true)
		end
	elseif tonumber(self.example.activityInfo_isReward) == 0 then
		self.rewardState = 1
		GetButton:setVisible(true)
		scheduleText:setString("")
	else
		self.rewardState = 2
		Image_13:setVisible(true)
		scheduleText:setString("")
	end
end

function SmActivityCompageCountCell:updateRewardInfo( ... )
	local root = self.roots[1]
	local activity = _ED.active_activity[self.activityType]

	local cell_tables = {}
	local index = 1
	if tonumber(activity.activity_Info[self.index].activityInfo_silver) > 0 then--可领取银币数量
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
	end
	if tonumber(activity.activity_Info[self.index].activityInfo_gold) > 0 then--奖励1可领取金币数量
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
	end
	if tonumber(activity.activity_Info[self.index].activityInfo_food) > 0 then--奖励1可领取体力数量
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
	end
	if tonumber(activity.activity_Info[self.index].activityInfo_honour) > 0 then--奖励1可领取声望数量
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
	end
	if tonumber(activity.activity_Info[self.index].activityInfo_equip_count) > 0 then	--可领取装备种类数量
		for n, v in pairs(activity.activity_Info[self.index].activityInfo_equip_info) do
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
		end
	end
	if tonumber(activity.activity_Info[self.index].activityInfo_prop_count) > 0 then--可领取道具种类数量
		for n, v in pairs(activity.activity_Info[self.index].activityInfo_prop_info) do
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
		end
	end
	if tonumber(activity.activity_Info[self.index].activityInfo_general_soul) > 0 then	--可领取水雷魂种类数量
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
	end

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
                    cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1)
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

    local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_11")
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
		ListViewDraw:removeAllItems()
		for k, cell in pairs(cell_tables) do
			ListViewDraw:addChild(cell)
		end

		ListViewDraw:requestRefreshView()
	end
end

function SmActivityCompageCountCell:onEnterTransitionFinish()

end

function SmActivityCompageCountCell:onInit()
	local root = cacher.createUIRef("activity/wonderful/landed_gifts_list.csb", "root")
	-- local csbSmActivityCompageCountCell = csb.createNode("activity/wonderful/landed_gifts_list.csb")
 --    local root = csbSmActivityCompageCountCell:getChildByName("root")
    table.insert(self.roots, root)
	root:removeFromParent(false)
    self:addChild(root)
	
	self:setContentSize(root:getChildByName("Panel_land_list"):getContentSize())
	state_machine.excute("shortcut_function_goto_log", 0, shortcut.shortcut_function_back_scene_enum.AccumlateConsumption)
	
	self:onUpdateDraw()
	self:updateRewardInfo()
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    -- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12"), nil, 
		{
			terminal_name = "sm_activity_compage_count_cell_reward", 
			terminal_state = 0, 
			_index = self.index,
			_cell = self,			
			isPressedActionEnabled = true
		},
		nil,0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_13"), nil, 
	{
		terminal_name = "sm_activity_compage_count_cell_go_to", 
		terminal_state = 0, 
		_index = self.index,
		_cell = self,			
		isPressedActionEnabled = true
	},
	nil,0)
end

function SmActivityCompageCountCell:clearUIInfo( ... )
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

function SmActivityCompageCountCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/landed_gifts_list.csb", self.roots[1])
end

function SmActivityCompageCountCell:init(example,index,activityType)
	self.example = example
	self.index = index
	self.activityType = activityType
	self:onInit()
end

function SmActivityCompageCountCell:createCell()
	local cell = SmActivityCompageCountCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end