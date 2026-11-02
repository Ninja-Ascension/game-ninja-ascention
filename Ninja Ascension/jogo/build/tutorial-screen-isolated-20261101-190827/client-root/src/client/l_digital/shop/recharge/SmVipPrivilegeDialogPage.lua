-- ----------------------------------------------------------------------------------------------------
-- 说明：smVIP权限查看页
-------------------------------------------------------------------------------------------------------
SmVipPrivilegeDialogPage = class("SmVipPrivilegeDialogPageClass", Window)
SmVipPrivilegeDialogPage.__size = nil
function SmVipPrivilegeDialogPage:ctor()
    self.super:ctor()
    self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.l_digital.shop.recharge.SmVipPrivilegeText")
	app.load("client.reward.DrawRareReward")
	self.index = 0
	self._load = false
	self.reworld_sorting = {}
    local function init_VipPrilige_terminal()
		
		local sm_vip_privilege_to_update_buy_button_terminal = {
            _name = "sm_vip_privilege_to_update_buy_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
            	if cell.index >= 17 then
            		if funOpenDrawTip(166 + cell.index - 17) == true then
            			return
            		end
            	end
            	if tonumber(_ED.vip_grade) < cell.index then
            		TipDlg.drawTextDailog(string.format(_string_piece_info[83], tonumber(cell.index)))
            		return
            	end
            	local pack_id = _ED.return_vip_prop[cell.index].shop_prop_instance
            	local Button_vip_privileges_pack_buy = ccui.Helper:seekWidgetByName(cell.roots[1], "Button_vip_privileges_pack_buy")
				local Sprite_vip_privileges_pack_buy = cell.roots[1]:getChildByName("Sprite_vip_privileges_pack_buy")
				local rewardIndex = 0
				local function responseBuyVipPackCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						local function responseVIPShopViewCallBack()
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								local getRewardWnd = DrawRareReward:new()
								getRewardWnd:init(rewardIndex,nil,cell.reworld_sorting)
								-- getRewardWnd:init(rewardIndex)
								fwin:open(getRewardWnd,fwin._windows)
								-- Button_vip_privileges_pack_buy:setTouchEnabled(false)
								Button_vip_privileges_pack_buy:setBright(false)
								
								-- DSC重塑
								if __lua_project_id == __lua_project_l_digital then 
									Button_vip_privileges_pack_buy:setTitleText("")
								else
									Button_vip_privileges_pack_buy:setTitleText(_activity_new_tip_string_info[3])
								end
								display:gray(Sprite_vip_privileges_pack_buy)
								if rewardIndex == 7 then
									_ED.active_activity[4] = nil
									state_machine.excute("home_update_first_recharge", 0,nil)
								end

								state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 1002)
							end
						end
						protocol_command.shop_view.param_list = "1"
						NetworkManager:register(protocol_command.shop_view.code, nil, nil, nil, response.node, responseVIPShopViewCallBack, false, nil)
					end
				end
            	if cell.index > 1 then
            		rewardIndex = 11
					protocol_command.prop_purchase.param_list = pack_id .. "\r\n" .. 1 .. "\r\n" .. 1
					NetworkManager:register(protocol_command.prop_purchase.code, nil, nil, nil, cell, responseBuyVipPackCallback, false, nil)
				else
					rewardIndex = 7
					protocol_command.draw_first_top_up_reward.param_list = 0
					NetworkManager:register(protocol_command.draw_first_top_up_reward.code, nil, nil, nil, cell, responseBuyVipPackCallback, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(sm_vip_privilege_to_update_buy_button_terminal)	
        state_machine.init()
    end
    
    init_VipPrilige_terminal()
end

function SmVipPrivilegeDialogPage:updateDrawButton( cell )
	local root = cell.roots[1]
	if root == nil then
		return
	end
	local data = _ED.return_vip_prop[self.index]
	local Button_vip_privileges_pack_buy = ccui.Helper:seekWidgetByName(root, "Button_vip_privileges_pack_buy")
	local Sprite_vip_privileges_pack_buy = root:getChildByName("Sprite_vip_privileges_pack_buy") 
	local Image_vip_privileges_bar = ccui.Helper:seekWidgetByName(root, "Image_vip_privileges_bar")
	local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
	local Text_vip_privileges_p = ccui.Helper:seekWidgetByName(root, "Text_vip_privileges_p")
	local Text_vip_privileges_price_1 = ccui.Helper:seekWidgetByName(root, "Text_vip_privileges_price_1")
	local Text_vip_privileges_price_n = ccui.Helper:seekWidgetByName(root, "Text_vip_privileges_price_n")
	local Text_vip_privileges_price_2 = ccui.Helper:seekWidgetByName(root, "Text_vip_privileges_price_2")
	local Text_vip_privileges_price_old_n = ccui.Helper:seekWidgetByName(root, "Text_vip_privileges_price_old_n")
	local Image_5_0 = ccui.Helper:seekWidgetByName(root, "Image_5_0")
	local Image_5_0_0 = ccui.Helper:seekWidgetByName(root, "Image_5_0_0")
	local Image_5_0_1 = ccui.Helper:seekWidgetByName(root, "Image_5_0_1")
	local ListView_vip_privileges_pack = ccui.Helper:seekWidgetByName(root, "ListView_vip_privileges_pack")
	local Button_vip_privileges_pack_buy = ccui.Helper:seekWidgetByName(root, "Button_vip_privileges_pack_buy")
	local Panel_vip_prop_1 = ccui.Helper:seekWidgetByName(root, "Panel_vip_prop_1")
	local Panel_vip_prop_2 = ccui.Helper:seekWidgetByName(root, "Panel_vip_prop_2")
	local Panel_vip_prop_3 = ccui.Helper:seekWidgetByName(root, "Panel_vip_prop_3")
	local Panel_vip_prop_4 = ccui.Helper:seekWidgetByName(root, "Panel_vip_prop_4")
	if cell.index > 1 then
		if tonumber(data.buy_times) > 0 or tonumber(_ED.vip_grade) < cell.index then
			-- Button_vip_privileges_pack_buy:setTouchEnabled(false)
			Button_vip_privileges_pack_buy:setBright(false)
			display:gray(Sprite_vip_privileges_pack_buy)
			if tonumber(data.buy_times) > 0 then
				Button_vip_privileges_pack_buy:setTitleText(_activity_new_tip_string_info[3])
			else
				Button_vip_privileges_pack_buy:setTitleText(_activity_new_tip_string_info[9])
			end
		else
			-- Button_vip_privileges_pack_buy:setTouchEnabled(true)
			Button_vip_privileges_pack_buy:setBright(true)
			Button_vip_privileges_pack_buy:setTitleText(_activity_new_tip_string_info[9])
			display:ungray(Sprite_vip_privileges_pack_buy)
		end
	else
		if nil ~= _ED.active_activity[4] and tonumber(_ED.vip_grade) >= cell.index then
			-- Button_vip_privileges_pack_buy:setTouchEnabled(true)
			Button_vip_privileges_pack_buy:setBright(true)
			display:ungray(Sprite_vip_privileges_pack_buy)
		else
			-- Button_vip_privileges_pack_buy:setTouchEnabled(false)
			Button_vip_privileges_pack_buy:setBright(false)
			if nil ~= _ED.active_activity[4] then 
				Button_vip_privileges_pack_buy:setTitleText(_activity_new_tip_string_info[9])
			else
				Button_vip_privileges_pack_buy:setTitleText(_activity_new_tip_string_info[3])
			end
			display:gray(Sprite_vip_privileges_pack_buy)
			if __lua_project_id == __lua_project_l_naruto and (verifySupportLanguage(_lua_release_language_ko) == true or verifySupportLanguage("Ko") == true) then
				if nil ~= _ED.active_activity[4] then
					local activity_reward_status = tonumber(_ED.active_activity[4].activity_id)
					if activity_reward_status == 0 then
						Button_vip_privileges_pack_buy:setTitleText(_activity_new_tip_string_info[9])
					else
						Button_vip_privileges_pack_buy:setTitleText(_activity_new_tip_string_info[3])
					end
				end
			end
		end
	end
	if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
		if self.index == 1 then
			Button_vip_privileges_pack_buy:setVisible(false)
			Image_vip_privileges_bar:setVisible(false)
			Image_3:setVisible(false)
			Text_vip_privileges_p:setVisible(false)
			Text_vip_privileges_price_1:setVisible(false)
			Text_vip_privileges_price_n:setVisible(false)
			Text_vip_privileges_price_2:setVisible(false)
			Text_vip_privileges_price_old_n:setVisible(false)
			Image_5_0:setVisible(false)
			Image_5_0_0:setVisible(false)
			Image_5_0_1:setVisible(false)
			ListView_vip_privileges_pack:setVisible(false)
			Button_vip_privileges_pack_buy:setVisible(false)
			Panel_vip_prop_1:setVisible(false)
			Panel_vip_prop_2:setVisible(false)
			Panel_vip_prop_3:setVisible(false)
			Panel_vip_prop_4:setVisible(false)
		else
			Button_vip_privileges_pack_buy:setVisible(true)
			Image_vip_privileges_bar:setVisible(true)
			Image_3:setVisible(true)
			Text_vip_privileges_p:setVisible(true)
			Text_vip_privileges_price_1:setVisible(true)
			Text_vip_privileges_price_n:setVisible(true)
			Text_vip_privileges_price_2:setVisible(true)
			Text_vip_privileges_price_old_n:setVisible(true)
			Image_5_0:setVisible(true)
			Image_5_0_0:setVisible(true)
			Image_5_0_1:setVisible(true)
			ListView_vip_privileges_pack:setVisible(true)
			Button_vip_privileges_pack_buy:setVisible(true)
			Panel_vip_prop_1:setVisible(true)
			Panel_vip_prop_2:setVisible(true)
			Panel_vip_prop_3:setVisible(true)
			Panel_vip_prop_4:setVisible(true)
		end
	end
	if __lua_project_id == __lua_project_l_digital then 
		-- DSC重塑
		Button_vip_privileges_pack_buy:setTitleText("")
	end
end

function SmVipPrivilegeDialogPage:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local data = _ED.return_vip_prop[self.index]
	--名称
	local Text_vip_privileges_text = ccui.Helper:seekWidgetByName(root, "Text_vip_privileges_text")
	Text_vip_privileges_text:setString(string.format(_new_interface_text[84], self.index))
	--礼包名称
	local Text_vip_privileges_p = ccui.Helper:seekWidgetByName(root, "Text_vip_privileges_p")
	local firstStr = ""
	if self.index == 1 then
		firstStr = _new_interface_text[86]
	end
	Text_vip_privileges_p:setString(string.format(_new_interface_text[85], self.index, firstStr))

	--原价
	local Text_vip_privileges_price_old_n = ccui.Helper:seekWidgetByName(root, "Text_vip_privileges_price_old_n")
	Text_vip_privileges_price_old_n:setString(data.original_cost)
	--现价
	local Text_vip_privileges_price_n = ccui.Helper:seekWidgetByName(root, "Text_vip_privileges_price_n")
	Text_vip_privileges_price_n:setString(data.sale_price)
	--奖励内容
	local ListView_vip_privileges_pack = ccui.Helper:seekWidgetByName(root, "ListView_vip_privileges_pack")
	ListView_vip_privileges_pack:removeAllItems()
	local index = 1
	local sm_index = 0
	local prop_data = dms.element(dms["prop_mould"], tonumber(data.mould_id))
	--获得道具一
	local prop_mould1 = dms.atoi(prop_data , prop_mould.change_of_prop)
	if prop_mould1 > 0 then
		local prop_num1 = dms.atoi(prop_data , prop_mould.split_or_merge_count)
		local cell = ResourcesIconCell:createCell()
		cell:init(6,prop_num1,prop_mould1,nil,nil,nil,true,1)
		if __lua_project_id == __lua_project_onepiece then
			sm_index = sm_index + 1
			local Panel_vip_prop = ccui.Helper:seekWidgetByName(root, "Panel_vip_prop_"..sm_index)
			if Panel_vip_prop ~= nil then
				Panel_vip_prop:removeAllChildren(true)
				Panel_vip_prop:addChild(cell)
			end
		else
			ListView_vip_privileges_pack:addChild(cell)
	    end
        index = index + 1
		local rewardinfo = {}
        rewardinfo.type = 6
        rewardinfo.id = prop_mould1
        rewardinfo.number = prop_num1
        self.reworld_sorting[index] = rewardinfo
	end
	--获得道具二
	local prop_mould2 = dms.atoi(prop_data , prop_mould.use_of_prop)
	if prop_mould2 > 0 then
		local prop_num2 = dms.atoi(prop_data , prop_mould.use_of_prop_count)
		local cell = ResourcesIconCell:createCell()
		cell:init(6,prop_num2,prop_mould2,nil,nil,nil,true,1)
		if __lua_project_id == __lua_project_onepiece then
			sm_index = sm_index + 1
			local Panel_vip_prop = ccui.Helper:seekWidgetByName(root, "Panel_vip_prop_"..sm_index)
			if Panel_vip_prop ~= nil then
				Panel_vip_prop:removeAllChildren(true)
				Panel_vip_prop:addChild(cell)
			end
		else
			ListView_vip_privileges_pack:addChild(cell)
		end
        index = index + 1
		local rewardinfo = {}
        rewardinfo.type = 6
        rewardinfo.id = prop_mould2
        rewardinfo.number = prop_num2
        self.reworld_sorting[index] = rewardinfo
	end
	--获得道具三
	local prop_mould3 = dms.atoi(prop_data , prop_mould.use_of_prop2)
	if prop_mould3 > 0 then
		local prop_num3 = dms.atoi(prop_data , prop_mould.use_of_prop2_count)
		local cell = ResourcesIconCell:createCell()
		cell:init(6,prop_num3,prop_mould3,nil,nil,nil,true,1)
		if __lua_project_id == __lua_project_onepiece then
			sm_index = sm_index + 1
			local Panel_vip_prop = ccui.Helper:seekWidgetByName(root, "Panel_vip_prop_"..sm_index)
			if Panel_vip_prop ~= nil then
				Panel_vip_prop:removeAllChildren(true)
				Panel_vip_prop:addChild(cell)
			end
		else
			ListView_vip_privileges_pack:addChild(cell)
		end
        index = index + 1
		local rewardinfo = {}
        rewardinfo.type = 6
        rewardinfo.id = prop_mould3
        rewardinfo.number = prop_num3
        self.reworld_sorting[index] = rewardinfo
	end
	--获得装备1
	local equip_mould = dms.atoi(prop_data , prop_mould.change_of_equipment)
	if equip_mould > 0 then
		local equip_num = dms.atoi(prop_data , prop_mould.change_of_equipment_count)
		local cell = ResourcesIconCell:createCell()
		cell:init(7,equip_num,equip_mould,nil,nil,nil,true,1,{equipQuality = 1})
		if __lua_project_id == __lua_project_onepiece then
			sm_index = sm_index + 1
			local Panel_vip_prop = ccui.Helper:seekWidgetByName(root, "Panel_vip_prop_"..sm_index)
			if Panel_vip_prop ~= nil then
				Panel_vip_prop:removeAllChildren(true)
				Panel_vip_prop:addChild(cell)
			end
		else
			ListView_vip_privileges_pack:addChild(cell)
		end
        index = index + 1
		local rewardinfo = {}
        rewardinfo.type = 7
        rewardinfo.id = equip_mould
        rewardinfo.number = equip_num
        self.reworld_sorting[index] = rewardinfo
	end
	--获得装备2
	local equip_mould2 = dms.atoi(prop_data , prop_mould.change_of_equipment2)
	if equip_mould2 > 0 then
		local equip_num2 = dms.atoi(prop_data , prop_mould.change_of_equipment2_count)
		local cell = ResourcesIconCell:createCell()
		cell:init(7,equip_num2,equip_mould2,nil,nil,nil,true,1,{equipQuality = 1})
		if __lua_project_id == __lua_project_onepiece then
			sm_index = sm_index + 1
			local Panel_vip_prop = ccui.Helper:seekWidgetByName(root, "Panel_vip_prop_"..sm_index)
			if Panel_vip_prop ~= nil then
				Panel_vip_prop:removeAllChildren(true)
				Panel_vip_prop:addChild(cell)
			end
		else
			ListView_vip_privileges_pack:addChild(cell)
		end
        index = index + 1
		local rewardinfo = {}
        rewardinfo.type = 7
        rewardinfo.id = equip_mould2
        rewardinfo.number = equip_num2
        self.reworld_sorting[index] = rewardinfo
	end
	--获得道具四
	local prop_mould4 = dms.atoi(prop_data , prop_mould.use_of_prop3)
	if prop_mould4 > 0 then
		local prop_num4 = dms.atoi(prop_data , prop_mould.use_of_prop3_count)
		local cell = ResourcesIconCell:createCell()
		cell:init(6,prop_num4,prop_mould4,nil,nil,nil,true,1)
		if __lua_project_id == __lua_project_onepiece then
			sm_index = sm_index + 1
			local Panel_vip_prop = ccui.Helper:seekWidgetByName(root, "Panel_vip_prop_"..sm_index)
			if Panel_vip_prop ~= nil then
				Panel_vip_prop:removeAllChildren(true)
				Panel_vip_prop:addChild(cell)
			end
		else
			ListView_vip_privileges_pack:addChild(cell)
		end
        index = index + 1
		local rewardinfo = {}
        rewardinfo.type = 6
        rewardinfo.id = prop_mould4
        rewardinfo.number = prop_num4
        self.reworld_sorting[index] = rewardinfo
	end
	--获得钻石
	local goods = dms.atoi(prop_data , prop_mould.use_of_gold)
	if goods > 0 then
		local cell = ResourcesIconCell:createCell()
		cell:init(2,goods,-1,nil,nil,nil,true,1)
		if __lua_project_id == __lua_project_onepiece then
			sm_index = sm_index + 1
			local Panel_vip_prop = ccui.Helper:seekWidgetByName(root, "Panel_vip_prop_"..sm_index)
			if Panel_vip_prop ~= nil then
				Panel_vip_prop:removeAllChildren(true)
				Panel_vip_prop:addChild(cell)
			end
		else
			ListView_vip_privileges_pack:addChild(cell)
		end
        index = index + 1
		local rewardinfo = {}
        rewardinfo.type = 2
        rewardinfo.id = -1
        rewardinfo.number = goods
        self.reworld_sorting[index] = rewardinfo
	end
	--获得银币
	local sliver = dms.atoi(prop_data , prop_mould.use_of_silver)
	if sliver > 0 then
		local cell = ResourcesIconCell:createCell()
		cell:init(1,sliver,-1,nil,nil,nil,true,1)
		if __lua_project_id == __lua_project_onepiece then
			sm_index = sm_index + 1
			local Panel_vip_prop = ccui.Helper:seekWidgetByName(root, "Panel_vip_prop_"..sm_index)
			if Panel_vip_prop ~= nil then
				Panel_vip_prop:removeAllChildren(true)
				Panel_vip_prop:addChild(cell)
			end
		else
			ListView_vip_privileges_pack:addChild(cell)
		end
        index = index + 1
		local rewardinfo = {}
        rewardinfo.type = 1
        rewardinfo.id = -1
        rewardinfo.number = sliver
        self.reworld_sorting[index] = rewardinfo
	end

	--介绍信息
	local ListView_vip_privileges_pack_0 = ccui.Helper:seekWidgetByName(root, "ListView_vip_privileges_pack_0")
	ListView_vip_privileges_pack_0:removeAllItems()
	local text_array = zstring.split(self.introduction , "\r\n")
	for i , v in pairs(text_array) do 
		local cell = SmVipPrivilegeText:createCell()
		cell:init(v)
		ListView_vip_privileges_pack_0:addChild(cell)
	end
	self:updateDrawButton(self)
end

function SmVipPrivilegeDialogPage:load( ... )
	local root = self.roots[1]
	if self._load == true or root ~= nil then
		return
	end
	self._load = true
	self:onInit()
end

function SmVipPrivilegeDialogPage:unLoad( ... )
	local root = self.roots[1]
	if self._load == false or root == nil then
		return
	end
	self._load = false
	self:clearUIInfo()
	cacher.freeRef("player/vip_privileges_tab.csb", root)
	self.roots = {}
end

function SmVipPrivilegeDialogPage:clearUIInfo( ... )
	local root = self.roots[1]
	--名称
	local Text_vip_privileges_text = ccui.Helper:seekWidgetByName(root, "Text_vip_privileges_text")
	if Text_vip_privileges_text ~= nil then
		Text_vip_privileges_text:setString("")
	end
	--礼包名称
	local Text_vip_privileges_p = ccui.Helper:seekWidgetByName(root, "Text_vip_privileges_p")
	if Text_vip_privileges_p ~= nil then
		Text_vip_privileges_p:setString("")
	end

	--原价
	local Text_vip_privileges_price_old_n = ccui.Helper:seekWidgetByName(root, "Text_vip_privileges_price_old_n")
	if Text_vip_privileges_price_old_n ~= nil then
		Text_vip_privileges_price_old_n:setString("")
	end
	--现价
	local Text_vip_privileges_price_n = ccui.Helper:seekWidgetByName(root, "Text_vip_privileges_price_n")
	if Text_vip_privileges_price_n ~= nil then
		Text_vip_privileges_price_n:setString("")
	end
	--奖励内容
	local ListView_vip_privileges_pack = ccui.Helper:seekWidgetByName(root, "ListView_vip_privileges_pack")
	if ListView_vip_privileges_pack ~= nil then
		ListView_vip_privileges_pack:removeAllItems()
	end

	for i=1,4 do
		local Panel_vip_prop = ccui.Helper:seekWidgetByName(root, "Panel_vip_prop_"..i)
		if Panel_vip_prop ~= nil then
			Panel_vip_prop:removeAllChildren(true)
		end
	end

	--介绍信息
	local ListView_vip_privileges_pack_0 = ccui.Helper:seekWidgetByName(root, "ListView_vip_privileges_pack_0")
	if ListView_vip_privileges_pack_0 ~= nil then
		ListView_vip_privileges_pack_0:removeAllItems()
	end

	local Button_vip_privileges_pack_buy = ccui.Helper:seekWidgetByName(root, "Button_vip_privileges_pack_buy")
	if Button_vip_privileges_pack_buy ~= nil then
		local Sprite_vip_privileges_pack_buy = root:getChildByName("Sprite_vip_privileges_pack_buy") 
		-- Button_vip_privileges_pack_buy:setTouchEnabled(true)
		Button_vip_privileges_pack_buy:setBright(true)
		Button_vip_privileges_pack_buy:setTitleText(_activity_new_tip_string_info[9])
		display:ungray(Sprite_vip_privileges_pack_buy)
	end
end

function SmVipPrivilegeDialogPage:onInit()
	local root = cacher.createUIRef("player/vip_privileges_tab.csb", "root")
	root:removeFromParent(false)
    table.insert(self.roots, root)

	self:addChild(root)
	self:setContentSize(root:getContentSize())
	if SmVipPrivilegeDialogPage.__size == nil then
		SmVipPrivilegeDialogPage.__size = self:getContentSize()
	end

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_vip_privileges_pack_buy"), nil, 
	{
		terminal_name = "sm_vip_privilege_to_update_buy_button", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		cell = self,
	},
	nil,0)
	
	self:onUpdateDraw()
end

function SmVipPrivilegeDialogPage:init(index , text )
	self.index = index
	self.introduction = text

	-- self:onInit()
	if SmVipPrivilegeDialogPage.__size == nil then
		SmVipPrivilegeDialogPage.__size = self:getContentSize()
	end
end

function SmVipPrivilegeDialogPage:createCell()
	local cell = SmVipPrivilegeDialogPage:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function SmVipPrivilegeDialogPage:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef("player/vip_privileges_tab.csb", root)
end
