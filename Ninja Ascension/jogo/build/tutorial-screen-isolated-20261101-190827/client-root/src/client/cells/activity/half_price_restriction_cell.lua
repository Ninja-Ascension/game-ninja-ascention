-- ----------------------------------------------------------------------------------------------------
-- 说明：半价限购
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
HalfPriceRestrictionCell = class("HalfPriceRestrictionCellClass", Window)
    
function HalfPriceRestrictionCell:ctor()
    self.super:ctor()
	self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")
	app.load("client.cells.prop.prop_money_icon")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.activity.variety_shop_prop_icon")
	self.example = nil
	self.index = 0
	self.maxcount = 0   --- 可选择数量
	self.activity_id = 0	
	self.need_info_arg = {}
	
	self.get_info_arg = {}
	self.needGolds = 0
	self.rewardState = 0
    -- Initialize HalfPriceRestrictionCell state machine.
    local function init_HalfPriceRestrictionCell_terminal()
		--兑换
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
				if  __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_naruto or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
					local prop = {}
					local get_info_arg = mCell.get_info_arg[1]
					prop.prop_number = zstring.tonumber(get_info_arg._maxTimes) - zstring.tonumber(_ED.half_price_shop_exchang_times[mCell.index])
					prop.mould_id = tonumber(get_info_arg._mould)
					prop.type = tonumber(get_info_arg._type)
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
					prop.id = index
					mCell.prop = prop
					mCell.form_cell = "half_price_restriction_cell" --来自碎片兑换cell
					--这里添加兑换弹窗
					app.load("client.packs.prop.ComExchange")
					state_machine.excute("com_exchange_use_open",0,mCell)
					fwin:close(instance)
				else
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

				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(variety_shop_exchange_terminal)
        state_machine.init()
    end
    
    -- call func init HalfPriceRestrictionCell state machine.
    init_HalfPriceRestrictionCell_terminal()
end

function HalfPriceRestrictionCell:rewadDraw(_index, _buyNum)
	local root = self.roots[1]

	local oldExchangeTimes = zstring.tonumber(_ED.half_price_shop_exchang_times[_index])
	_ED.half_price_shop_exchang_times[_index] = _buyNum and (oldExchangeTimes + _buyNum) or (oldExchangeTimes + 1)

	local getRewardWnd = DrawRareReward:new()
	getRewardWnd:init(53)
	fwin:open(getRewardWnd,fwin._ui)
	
	local activity = _ED.active_activity[7]
	
	local GetButton = ccui.Helper:seekWidgetByName(root, "Button_12_4")
	GetButton:setVisible(true)
	if zstring.tonumber(_ED.half_price_shop_exchang_times[_index]) >= zstring.tonumber(self.get_info_arg[1]._maxTimes) then
		GetButton:setBright(false)
		GetButton:setTouchEnabled(false)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
			state_machine.excute("activity_window_update_activity_page", 0, self.m_type)
		end
	else
		local text = ccui.Helper:seekWidgetByName(root, "Text_13")
		if text ~= nil then
			text:setString((zstring.tonumber(self.get_info_arg[1]._maxTimes) - zstring.tonumber(_ED.half_price_shop_exchang_times[_index]))
							.."/"..zstring.tonumber(self.get_info_arg[1]._maxTimes))
		end
	end
end

function HalfPriceRestrictionCell:onUpdateDraw()
	local root = self.roots[1]
	local Panel_land_list = ccui.Helper:seekWidgetByName(root, "Panel_land_list")
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
	else
		Panel_land_list = ccui.Helper:seekWidgetByName(root, "Panel_Exchange")
	end
	local zhuangbei_jiantou_1_0 = Panel_land_list:getChildByName("zhuangbei_jiantou_1_0")
	local zhuangbei_jiantou_1 = Panel_land_list:getChildByName("zhuangbei_jiantou_1")
	zhuangbei_jiantou_1_0:setVisible(true)
	zhuangbei_jiantou_1:setVisible(true)
	local GetButton = ccui.Helper:seekWidgetByName(root, "Button_12_4")
	GetButton:setVisible(true)
	self.rewardState = 1
	if zstring.tonumber(_ED.half_price_shop_exchang_times[self.index]) >= zstring.tonumber(self.get_info_arg[1]._maxTimes) then
		self.rewardState = 2
		GetButton:setBright(false)
		GetButton:setTouchEnabled(false)
	end
	
	local text = ccui.Helper:seekWidgetByName(root, "Text_13")
	text:setString((zstring.tonumber(self.get_info_arg[1]._maxTimes) - zstring.tonumber(_ED.half_price_shop_exchang_times[self.index]))
					.."/"..zstring.tonumber(self.get_info_arg[1]._maxTimes))

	local listview = ccui.Helper:seekWidgetByName(root, "ListView_011_2_0")
	
	for i, v in ipairs(self.need_info_arg) do
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local rewardIcon = ResourcesIconCell:createCell()
			local mould_id = -1
			if tonumber(v._type) ~= 6 and tonumber(v._type) ~= 7 and tonumber(v._type) ~= 13 then
				 rewardIcon:init(v._type, tonumber(v._count), -1,nil,nil,true,true,1)
				 mould_id = -1
			else
		        rewardIcon:init(v._type, tonumber(v._count), v._mould,nil,nil,true,true,1)
		        mould_id = v._mould
		    end
		    if __lua_project_id == __lua_project_l_naruto then
		    	rewardIcon:showName(tonumber(mould_id), tonumber(v._type))
		    end
	        listview:addChild(rewardIcon)    
	    else	
			local propCell = VarietyShopPropIcon:createCell()
			propCell:init(propCell.enum_type.NONE, v._type, v._mould, v._count)
			if tonumber(v._type) == 2 and tonumber(v._mould) == 1 then
				self.needGolds = tonumber(v._count)
			end
			listview:addChild(propCell)
		end
	end

	for i, v in ipairs(self.get_info_arg) do
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local Panel_reward_2 = ccui.Helper:seekWidgetByName(root, "Panel_reward_2")
			Panel_reward_2:removeAllChildren(true)
			local rewardIcon = ResourcesIconCell:createCell()
			rewardIcon:init(v._type, tonumber(v._count), v._mould,nil,nil,true,true,1)
			if __lua_project_id == __lua_project_l_naruto then
		    	rewardIcon:showName(tonumber(v._mould), tonumber(v._type))
		    end
			Panel_reward_2:addChild(rewardIcon)
		else
			local propCell = VarietyShopPropIcon:createCell()
			local tmpType = propCell.enum_type.NONE
			if i == 1 then
				tmpType = propCell.enum_type.EQUAL_IMAGE
			end
			propCell:init(tmpType, v._type, v._mould, v._count)
			listview:addChild(propCell)
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local activity = nil
		if self.m_type ~= nil then
			activity = _ED.active_activity[tonumber(self.m_type)]
		else
			activity = _ED.active_activity[62]
		end
		local Text_11 = ccui.Helper:seekWidgetByName(root, "Text_11")
		Text_11:setString(activity.activity_reward_name[tonumber(self.index)])
	end
end
function HalfPriceRestrictionCell:onEnterTransitionFinish()

end

function HalfPriceRestrictionCell:onInit()
	local root = cacher.createUIRef("activity/wonderful/landed_gifts_list_zhaomu.csb", "root")
	-- local csbHalfPriceRestrictionCell = csb.createNode("activity/wonderful/landed_gifts_list_dh.csb")
 --    local root = csbHalfPriceRestrictionCell:getChildByName("root")
    table.insert(self.roots, root)
	root:removeFromParent(false)
    self:addChild(root)
	
	self:setContentSize(root:getChildByName("Panel_land_list"):getContentSize())
	-- 列表控件动画播放
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		local action = csb.createTimeline("activity/wonderful/landed_gifts_list_dh.csb")
	    root:runAction(action)
	    action:play("list_view_cell_open", false)
	end

	self:clearUIInfo()
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    -- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)
	self:onUpdateDraw()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12_4"), nil, 
		{
			terminal_name = "variety_shop_exchange", 
			terminal_state = 0, 
			_index = self.index,
			_cell = self,			
			isPressedActionEnabled = true
		},
		nil,0)
end

function HalfPriceRestrictionCell:clearUIInfo( ... )
    local root = self.roots[1]
	local ListView_011_2_0 = ccui.Helper:seekWidgetByName(root, "ListView_011_2_0")
	local Text_11 = ccui.Helper:seekWidgetByName(root, "Text_11")
	local Text_13 = ccui.Helper:seekWidgetByName(root, "Text_13")
	local Button_12_4 = ccui.Helper:seekWidgetByName(root, "Button_12_4")
	local Panel_reward_2 = ccui.Helper:seekWidgetByName(root, "Panel_reward_2")

	local Button_zhaomu = ccui.Helper:seekWidgetByName(root, "Button_zhaomu")
	local Button_receive = ccui.Helper:seekWidgetByName(root, "Button_receive")
	local Image_received = ccui.Helper:seekWidgetByName(root, "Image_received")
	local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon")
	local Image_received_0 = ccui.Helper:seekWidgetByName(root, "Image_received_0")
	local Panel_reward_1 = ccui.Helper:seekWidgetByName(root, "Panel_reward_1")
	local Panel_land_list = ccui.Helper:seekWidgetByName(root, "Panel_land_list")
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
	else
		Panel_land_list = ccui.Helper:seekWidgetByName(root, "Panel_Exchange")
	end
	local zhuangbei_jiantou_1_0 = Panel_land_list:getChildByName("zhuangbei_jiantou_1_0")
	local zhuangbei_jiantou_1 = Panel_land_list:getChildByName("zhuangbei_jiantou_1")
	if ListView_011_2_0 ~= nil then
		ListView_011_2_0:removeAllItems()
		Text_11:setString("")
		Text_11:removeAllChildren(true)
		Text_13:setString("")
		Button_12_4:setBright(true)
		Button_12_4:setTouchEnabled(true)
		Button_12_4:setVisible(false)
		Panel_reward_2:removeAllChildren(true)
		Button_zhaomu:setVisible(false)
		Button_receive:setVisible(false)
		Image_received:setVisible(false)
		Panel_digimon_icon:removeAllChildren(true)
		Image_received_0:setVisible(false)
		Panel_reward_1:removeAllChildren(true)
		zhuangbei_jiantou_1_0:setVisible(false)
		zhuangbei_jiantou_1:setVisible(false)
	end
end

function HalfPriceRestrictionCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/landed_gifts_list_zhaomu.csb", self.roots[1])
end

function HalfPriceRestrictionCell:init(example,index ,m_type)
	self.example = example
	self.index = index
	self.m_type = m_type or nil
	
	local tmp_data = zstring.split(self.example, "=")
	local tmp_need = nil
	local tmp_get = nil
	local tmp_get_data = nil
	local maxTimes = nil
	
	local activity = nil
	if self.m_type ~= nil then
		activity = _ED.active_activity[tonumber(self.m_type)]
	else
		activity = _ED.active_activity[62]
	end

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
		}
		table.insert(self.need_info_arg, tmp_need_info)
	end
	
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
	self.maxcount = count
	self:onInit()
end

function HalfPriceRestrictionCell:createCell()
	local cell = HalfPriceRestrictionCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end