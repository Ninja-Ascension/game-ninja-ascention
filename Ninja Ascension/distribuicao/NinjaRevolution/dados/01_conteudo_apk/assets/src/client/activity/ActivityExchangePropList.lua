--[[ ----------------------------------------------------------------------------
-- 获取窗口列表项
--]] ----------------------------------------------------------------------------
ActivityExchangePropList = class("ActivityExchangePropListClass", Window)
ActivityExchangePropList.__size = nil

-- 创建Cell实例
local activity_exchange_prop_list_create_terminal = {
	_name = "activity_exchange_prop_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if ActivityExchangePropList then
			local cell = ActivityExchangePropList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(activity_exchange_prop_list_create_terminal)
state_machine.init()

-- 构造器
function ActivityExchangePropList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.example = nil
	self.index = 0
	self.maxcount = 0   --- 可选择数量
	self.activity_id = 0	
	self.need_info_arg = {}
	
	self.get_info_arg = {}
	self.needGolds = 0

	-- load lua files.
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")
	app.load("client.cells.prop.prop_money_icon")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.activity.variety_shop_prop_icon")

	-- Initialize lim pool to get list page state machine.
	local function init_activity_exchange_prop_list_terminal()
		-- 领取奖励
		local variety_shop_exchange_terminal = {
			_name = "variety_shop_exchange",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local index = params._datas._index
				local mCell = params._datas._cell
				if  __lua_project_id == __lua_project_l_pokemon then
					local prop = {}
					local get_info_arg = mCell.get_info_arg[1]
					prop.prop_number = zstring.tonumber(get_info_arg._maxTimes) - zstring.tonumber(_ED.half_price_shop_exchang_times[mCell.index])
					prop.mould_id = tonumber(get_info_arg._mould)
					prop.type = tonumber(get_info_arg._type)
					if prop.type == 6 then
						local prop_info = dms.element(dms["prop_mould"], prop.mould_id)
						if prop.mould_name == nil then
							prop.mould_name = dms.atos(prop_info, prop_mould.prop_name)
							prop.mould_name = setThePropsIcon(prop.mould_id)[2]
						end
						if prop.prop_quality == nil then
							prop.prop_quality = dms.atoi(prop_info, prop_mould.prop_quality)
						end
						prop.mould_remarks = dms.atos(prop_info, prop_mould.remarks)
						prop.mould_remarks = drawPropsDescription(prop.mould_id)
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
					prop.id = index
					mCell.prop = prop
					mCell.form_cell = "half_price_restriction_cell" --来自碎片兑换cell
					--这里添加兑换弹窗
					app.load("client.packs.prop.ComExchange")
					state_machine.excute("com_exchange_use_open",0,mCell)
					state_machine.excute("activity_exchange_prop_close", 0, nil)
				else
					-- 回调
					local function callback()
						state_machine.lock("variety_shop_exchange")
						mCell.command_param_list = ""..tonumber(index).."\r\n"..mCell.activity_id.."\r\n".."1"
						if mCell.maxcount > 1 then
							app.load("client.activity.ActivityVarietyShopForDrawSelectAward")
							fwin:open(ActivityVarietyShopForDrawSelectAward:new():init(params), fwin._dview)
							state_machine.unlock("variety_shop_exchange")
						else
							local function responseExchangeCallback(response)
								state_machine.unlock("variety_shop_exchange")
								if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon
										or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and params.status ~= nil then
									state_machine.excute("use_diamond_confirm_tip_close",0,"")
								end
								if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
									if mCell == nil then
										return
									end
									mCell:rewadDraw(index)
								end
							end

							if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon
									or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
									and ___is_open_diamond_confirm == true and params.status == nil and mCell.needGolds > 0 then
								app.load("client.utils.UseDiamondConfirmTip")
								local window_terminal = state_machine.find("use_diamond_confirm_tip_open")
								if window_terminal.unopen ~= true then
									local str1 = string.format(tipStringInfo_use_diamond[1],mCell.needGolds)
									local str2 = tipStringInfo_use_diamond[5]
									state_machine.excute("use_diamond_confirm_tip_open", 0, {_datas={instance,nil,str1.."|"..str2 ,params}})
									return
								else
									protocol_command.activity_superchange_exchange.param_list = mCell.command_param_list.."\r\n".."1"
									NetworkManager:register(protocol_command.activity_superchange_exchange.code, nil, nil, nil, mCell, responseExchangeCallback, false, nil)
								end
							else
								protocol_command.activity_superchange_exchange.param_list = mCell.command_param_list.."\r\n".."1"
								NetworkManager:register(protocol_command.activity_superchange_exchange.code, nil, nil, nil, mCell, responseExchangeCallback, false, nil)
							end
						end
					end

					-- 当上阵的专属刃具A数量等于0且背包中的刃具A数量等于1时，点击兑换按钮弹出确认弹窗
					if mCell:isShowTip() == true then
						app.load("client.utils.ConfirmTip")
						local tip = ConfirmTip:new() 
						tip:init(mCell, callback, tipStringInfo_activity_exchange_prop[1], nil, nil, nil, false)
						fwin:open(tip, fwin._ui)
						return
					end

					callback()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(variety_shop_exchange_terminal)
	end
	-- call func init lim pool to get list state machine.
	init_activity_exchange_prop_list_terminal()
end

-- 对象初始化
function ActivityExchangePropList:init(params)
	self.example = params[1]
	self.index = params[2]
	
	local tmp_data = zstring.split(self.example, "=")
	local tmp_need = nil
	local tmp_get = nil
	local tmp_get_data = nil
	local maxTimes = nil
	
	local activity = _ED.active_activity[28]

	self.activity_id = activity.activity_id

	tmp_get_data = zstring.split(tmp_data[2],"!")
	maxTimes =  tmp_get_data[2]                     --- 最大次数
	tmp_need = zstring.split(tmp_data[1], "+")
	tmp_get = zstring.split(tmp_get_data[1], "|")
	
	self.need_info_arg = {}
	for i, v in ipairs(tmp_need) do
		local tmp_need_data = zstring.split(v, ",")
		local tmp_need_info = {
			_type = tmp_need_data[1],
			_mould = tmp_need_data[2],
			_count = tmp_need_data[3],
			_silkBagId = -1
		}
		table.insert(self.need_info_arg, tmp_need_info)
	end

	-- debug.print_r(self.need_info_arg, "11self.need_info_arg")
	
	self.get_info_arg = {}
	
	local count = 0
	for i, v in ipairs(tmp_get) do                     --  可兑换的道具 
		count = count + 1
		local tmp_get_data = zstring.split(v, ",")
		local tmp_get_info = {
			_type = tmp_get_data[1],
			_mould = tmp_get_data[2],
			_count = tmp_get_data[3],
			_maxTimes = maxTimes,-- 最大兑换次数
		}
		table.insert(self.get_info_arg, tmp_get_info)
	end

	-- debug.print_r(self.get_info_arg, "self.get_info_arg")

	self.maxcount = count

	-- 忍具的数据
	self._noUseSilkBagInfo = {}
	if _ED.silkbag_pack_info ~= nil then
		for k, v in pairs(_ED.silkbag_pack_info) do
			if tonumber(v.onUseShipId) == -1 and tonumber(v.onUseIndex) == -1 then
				local silkBagMouldId = tonumber(v.silkBagMouldId)
				if self._noUseSilkBagInfo[silkBagMouldId] then
					table.insert(self._noUseSilkBagInfo[silkBagMouldId], v)
				else
					self._noUseSilkBagInfo[silkBagMouldId] = {}
					table.insert(self._noUseSilkBagInfo[silkBagMouldId], v)
				end
			end
		end
	end

	-- 等级从低到高排序
	for k, v in pairs(self._noUseSilkBagInfo) do
		table.sort(self._noUseSilkBagInfo[k], function(a, b)
			return tonumber(a.level) < tonumber(b.level)
		end)
	end

	for _, v in pairs(self.need_info_arg) do
		if tonumber(v._type) == 71 then
			local data = self._noUseSilkBagInfo[tonumber(v._mould)]
			if data and data[1] then
				v._silkBagId = tonumber(data[1].id)
			end
		end
	end
	-- debug.print_r(self.need_info_arg, "22self.need_info_arg")

	self:onInit(params)
	self:setContentSize(ActivityExchangePropList.__size)
	return self
end

function ActivityExchangePropList:rewadDraw(_index, _buyNum)
	local root = self.roots[1]

	local oldExchangeTimes = zstring.tonumber(_ED.half_price_shop_exchang_times[_index])
	_ED.half_price_shop_exchang_times[_index] = _buyNum and (oldExchangeTimes + _buyNum) or (oldExchangeTimes + 1)

	local getRewardWnd = DrawRareReward:new()
	getRewardWnd:init(53)
	fwin:open(getRewardWnd,fwin._ui)
		
	state_machine.excute("activity_exchange_prop_refresh_ui", 0, nil)
end

-- 判断该类型忍具是否上阵
function ActivityExchangePropList:getIsSilkOnEquip(silkBagMouldId)
	local isEquip = false

	local data = self._noUseSilkBagInfo[silkBagMouldId]
	if data then
		for _, v in pairs(data) do
			if tonumber(v.onUseShipId) ~= -1 then
				isEquip = true
				break
			end
		end

	end

	return isEquip
end

-- 获得背包中忍具的数量
function ActivityExchangePropList:getSilkInBagCount(silkBagMouldId)
	local count = 0

	local data = self._noUseSilkBagInfo[silkBagMouldId]
	if data then
		for _, v in pairs(data) do
			if tonumber(v.onUseShipId) == -1 then
				count = count + 1
			end
		end

	end

	return count
end

-- 是否弹出弹窗
function ActivityExchangePropList:isShowTip()
	local isShow = false

	local need_info_arg = self.need_info_arg
	for _, v in ipairs(need_info_arg) do
		if tonumber(v._type) == 71 then
			local cond_1 = self:getIsSilkOnEquip(tonumber(v._mould))
			local cond_2 = self:getSilkInBagCount(tonumber(v._mould))

			-- 没有上阵且背包里只有一个
			isShow = (cond_1 == false) and (cond_2 == 1)

			if isShow == true then
				break
			end
		end
	end

	return isShow
end

function ActivityExchangePropList:onUpdateDraw()
	local root = self.roots[1]

	local Panel_Exchange = ccui.Helper:seekWidgetByName(root, "Panel_Exchange")

	local zhuangbei_jiantou_1_0 = Panel_Exchange:getChildByName("zhuangbei_jiantou_1_0")
	local zhuangbei_jiantou_1 = Panel_Exchange:getChildByName("zhuangbei_jiantou_1")
	zhuangbei_jiantou_1_0:setVisible(true)
	zhuangbei_jiantou_1:setVisible(true)

	local GetButton = ccui.Helper:seekWidgetByName(root, "Button_12_4")
	GetButton:setVisible(true)

	local maxTimes = zstring.tonumber(self.get_info_arg[1]._maxTimes)
	local haveExchangeTimes = zstring.tonumber(_ED.half_price_shop_exchang_times[self.index])

	if haveExchangeTimes >= maxTimes then
		GetButton:setBright(false)
		GetButton:setTouchEnabled(false)
	end
	
	local text = ccui.Helper:seekWidgetByName(root, "Text_13")
	text:setString((maxTimes - haveExchangeTimes) .. "/" .. maxTimes)
	text:setVisible(true)

	local ListView = ccui.Helper:seekWidgetByName(root, "ListView_011_2_0")
	ListView:removeAllItems()
	for i, v in ipairs(self.need_info_arg) do
		local propData = {v._type, v._mould, v._count, nil, v._silkBagId}
		local cell = self:addResourcesIconCell(propData)
		ListView:addChild(cell)    
	end

	local Panel_reward = ccui.Helper:seekWidgetByName(root, "Panel_reward")
	Panel_reward:removeAllChildren(true)

	local Text_11 = ccui.Helper:seekWidgetByName(root, "Text_11")

	local getPropData = self.get_info_arg[1]
	if getPropData then
		local propData = {getPropData._type, getPropData._mould, getPropData._count}
		local cell = self:addResourcesIconCell(propData)
		Panel_reward:addChild(cell)

		
		local name = getItemNameAndQuality(propData)[1]
		Text_11:setString(name)
		Text_11:setVisible(true)
	else
		Text_11:setVisible(false)
	end

	local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon")
	Panel_digimon_icon:setVisible(false)

	self.Button_12_4 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12_4"), nil, 
	{
		terminal_name = "variety_shop_exchange", 
		terminal_state = 0,
		_index = self.index,
		_cell = self,
		isPressedActionEnabled = true
	},
	nil,0)
end

function ActivityExchangePropList:addResourcesIconCell(propData)
	local cell = ResourcesIconCell:createCell()
	local rewardType = tonumber(propData[1])
	local mouldId = tonumber(propData[2])
	if 13 == rewardType then
		local extraTable = {}
		if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
			extraTable.shipStar = tonumber(propData[4])
		else
			extraTable.shipStar = 0
		end
		cell:init(rewardType, tonumber(propData[3]), mouldId, nil, nil, true, true, 1, extraTable)
	elseif 71 == rewardType then
		local property_info = dms.string(dms["ship_silk_bag_mould"],mouldId,ship_silk_bag_mould.base_property)
		local level = 0
		local silkBagId = propData[5]

		if silkBagId and silkBagId ~= -1 then
			for k, v in pairs(_ED.silkbag_pack_info) do
				if tonumber(silkBagId) == tonumber(v.id) then
					level = v.level
					property_info = v.addBaseProperty
					break
				end
			end
		end
		
		local basePropertyList = {}
		if nil ~= property_info then
			local add_property_info = zstring.split(property_info,"|")
			for i = 1,table.nums(add_property_info) do
				local add_property_per = zstring.split(add_property_info[i],",")
				if nil ~= add_property_per then
					local a = tipStringInfo_rescue_silkbag_property["0"]
					local baseProperty ={}
					baseProperty.property_name = tipStringInfo_rescue_silkbag_property[tostring(add_property_per[1])]
					baseProperty.property_value = add_property_per[2]
					basePropertyList[i] = baseProperty
				end
			end
		end
		cell:init(rewardType, tonumber(propData[3]), mouldId, nil, nil, true, true, 0, {basePropertyList, level})
	else
		cell:init(rewardType, tonumber(propData[3]), mouldId, nil, nil, true ,true, 1)
	end
	return cell
end

function ActivityExchangePropList:onEnterTransitionFinish()
	
end

function ActivityExchangePropList:onInit(params)
	-- 加载ActivityExchangePropListWindow界面资源.
	-- res.activity.weapon_exchange_dh = res/activity/weapon_exchange_dh.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/weapon_exchange_dh.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/wonderful/weapon_exchange_dh.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if ActivityExchangePropList.__size == nil then
		ActivityExchangePropList.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function ActivityExchangePropList:onExit()
	-- 释放ActivityExchangePropListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/wonderful/weapon_exchange_dh.csb", root)
	-- ]]
end

function ActivityExchangePropList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ActivityExchangePropList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/wonderful/weapon_exchange_dh.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
