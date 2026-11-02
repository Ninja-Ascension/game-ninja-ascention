----------------------------------------------------------------------------------------------------
-- 说明：神将商店购买单元项
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
----------------------------------------------------------------------------------------------------
HeroShopListCell = class("HeroShopListCellClass", Window)

function HeroShopListCell:ctor()
    self.super:ctor()
	app.load("client.cells.ship.ship_head_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	self.current_type = 0
    -- 定义封装类中的变量
	self.roots = {}		
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.goodsType = 0
	self.ship = nil
	self._index = 0
	self.isSureGoldToBuye = false
	self._name = ""
	-- 初始化道具小图标事件响应需要使用的状态机
	local function init_hero_shop_list_cell_terminal()
		--购买按钮的点击
		local hero_shop_list_cell_item_buy_terminal = {
            _name = "hero_shop_list_cell_item_buy",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if TipDlg.drawStorageTipo() == false then
					local button_name = params._datas._Button_3
					button_name.request = true
					local _mIndex = 0
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						local cell = params._datas._self
						_mIndex = cell._index
					else
						_mIndex = params._datas._index
					end
					-- 请求神将商店购买
					local function recruitCallBack(response)
						if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and params.status~= nil then
							state_machine.excute("use_diamond_confirm_tip_close",0,"")
						end
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							TipDlg.drawTextDailog(_string_piece_info[76])
							if response.node.request == nil then
								return
							end
							response.node.request = nil
							response.node:setBright(false)
							response.node:setTouchEnabled(false)
							state_machine.excute("hero_shop_buy_goods", 0, nil)
							if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
								self.isSureGoldToBuye = false
							end
						end
					end
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						local cell = params._datas._self
						if tonumber(cell.prop.buy_type) == 1  then
							if self.isSureGoldToBuye == false then
								app.load("client.utils.ConfirmTip")
								instance.status = true 
								local tip = ConfirmTip:new()
								tip:init(instance,cell.sureToBuy,string.format(_string_piece_info[387],cell.prop.picel),nil,cell)
								fwin:open(tip,fwin._windows)
								return
							end
							if tonumber(cell.prop.picel) > tonumber(_ED.user_info.user_gold) then
								state_machine.excute("shortcut_open_recharge_window",0,"")
								return
							end
						elseif tonumber(cell.prop.buy_type) == 0 then
							if tonumber(cell.prop.picel) > tonumber(_ED.user_info.jade) then
								state_machine.excute("shortcut_function_silver_to_get_open",0,5)
								return
							end
						end
					end
					if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) 
						and ___is_open_diamond_confirm == true and params.status == nil 
							and zstring.tonumber(params._datas._self.prop.buy_type) == 1 then
						app.load("client.utils.UseDiamondConfirmTip")
						local window_terminal = state_machine.find("use_diamond_confirm_tip_open")
		            	if window_terminal.unopen ~= true then
		            		local price = tonumber(params._datas._self.prop.picel)
		            		local str1 = string.format(tipStringInfo_use_diamond[1],price)
		            		local str2 = tipStringInfo_use_diamond[4]..params._datas._self._name
		            		params._datas._self.buyIndex = _mIndex
		            		state_machine.excute("use_diamond_confirm_tip_open", 0, {_datas={params._datas._self,params._datas._self.buy,str1.."|"..str2 ,nil}})
		            		return
		            	else
		            		protocol_command.secret_shop_exchange.param_list = ""..(tonumber(_mIndex)-1)
							NetworkManager:register(protocol_command.secret_shop_exchange.code, nil, nil, nil, button_name, recruitCallBack, false, nil)
					    end
					else
						if verifySupportLanguage(_lua_release_language_en) == true then
							local cell = params._datas._self
							if __lua_project_id == __lua_project_warship_girl_b then
								app.load("client.utils.ConfirmTip")
						        local tip = ConfirmTip:new()
						        params._datas._self.buyIndex = _mIndex
						        tip:init(instance, cell.sureToBuyOther, string.format(_string_piece_info[380],cell.prop.picel), nil, cell)
						        fwin:open(tip, fwin._windows)
							else
	            				protocol_command.secret_shop_exchange.param_list = ""..(tonumber(_mIndex)-1)
								NetworkManager:register(protocol_command.secret_shop_exchange.code, nil, nil, nil, button_name, recruitCallBack, false, nil)
						    end
					    else
		            		protocol_command.secret_shop_exchange.param_list = ""..(tonumber(_mIndex)-1)
							NetworkManager:register(protocol_command.secret_shop_exchange.code, nil, nil, nil, button_name, recruitCallBack, false, nil)
						end
					end
                end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(hero_shop_list_cell_item_buy_terminal)
        state_machine.init()
	end
	init_hero_shop_list_cell_terminal()
end

function HeroShopListCell:buy(sure_number)
	if sure_number == 0 then
		local function recruitCallBack(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				TipDlg.drawTextDailog(_string_piece_info[76])
				if response.node.request == nil then
					return
				end
				response.node.request = nil
				response.node:setBright(false)
				response.node:setTouchEnabled(false)
				state_machine.excute("hero_shop_buy_goods", 0, nil)
			end
		end
		local Button_3 = ccui.Helper:seekWidgetByName(self.roots[1], "Button_3")
		Button_3.request = true
		protocol_command.secret_shop_exchange.param_list = ""..(tonumber(self.buyIndex)-1)
		NetworkManager:register(protocol_command.secret_shop_exchange.code, nil, nil, nil, Button_3, recruitCallBack, false, nil)
	end
end

function HeroShopListCell:sureToBuy(sure_number,cell)
	if sure_number == 0 then
		local Button_3 = ccui.Helper:seekWidgetByName(cell.roots[1], "Button_3")		--价钱
		self.isSureGoldToBuye = true
		state_machine.excute("hero_shop_list_cell_item_buy",0,
			{
			_datas={
					terminal_name = "hero_shop_list_cell_item_buy",
					terminal_state = 0, 
					_Button_3 = Button_3,
					_index = cell._index,
					_self = cell
				}
			})
	end
end

function HeroShopListCell:sureToBuyOther(sure_number,cell)
	if sure_number == 0 then
		local function recruitCallBack(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				TipDlg.drawTextDailog(_string_piece_info[76])
				if response.node.request == nil then
					return
				end
				response.node.request = nil
				response.node:setBright(false)
				response.node:setTouchEnabled(false)
				state_machine.excute("hero_shop_buy_goods", 0, nil)
			end
		end
		local Button_3 = ccui.Helper:seekWidgetByName(cell.roots[1], "Button_3")
		Button_3.request = true
		protocol_command.secret_shop_exchange.param_list = ""..(tonumber(cell.buyIndex)-1)
		NetworkManager:register(protocol_command.secret_shop_exchange.code, nil, nil, nil, Button_3, recruitCallBack, false, nil)	
	end
end

function HeroShopListCell:onUpdateDraw()
	local root = self.roots[1]
	local quality = nil
	local propNameString = nil
	local proptypeString = nil
	local propName = ccui.Helper:seekWidgetByName(root, "Text_5")  		--名字
	local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_4") 	-- 头像
	local resTypePanel = ccui.Helper:seekWidgetByName(root, "Panel_5") 	-- 显示的类型
	local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
	local Panel_tuijian = ccui.Helper:seekWidgetByName(root, "Panel_tuijian")
	local goldNumber = ccui.Helper:seekWidgetByName(root, "Text_6")		--价钱
	local Button_3 = ccui.Helper:seekWidgetByName(root, "Button_3")		--价钱
	goldNumber:setString(self.prop.picel)
	headPanel:removeAllChildren(true)
	--推荐
	Panel_tuijian:removeBackGroundImage()
	if tonumber(self.ship.recommend) == 1 then
		Panel_tuijian:setBackGroundImage("images/ui/text/sc_tuijian.png")
		Panel_tuijian:setVisible(true)
	else
		Panel_tuijian:setVisible(false)
	end
	--购买类型
	resTypePanel:removeBackGroundImage()
	if tonumber(self.prop.buy_type) == 0 then
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh 
			then 
			resTypePanel:setBackGroundImage("images/ui/icon/icon_shumahun.png")
		else
			resTypePanel:setBackGroundImage("images/ui/icon/icon_jianghun.png")	
		end
		
	elseif tonumber(self.prop.buy_type) == 1 then
		resTypePanel:setBackGroundImage("images/ui/icon/icon_gem.png")
	end
	
	if tonumber(self.goodsType) == 0 then--道具类型
		quality = tonumber(dms.string(dms["prop_mould"], self.prop.user_prop_template, prop_mould.prop_quality))+1
		propNameString = dms.string(dms["prop_mould"], self.prop.user_prop_template, prop_mould.prop_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            propNameString = setThePropsIcon(self.prop.user_prop_template)[2]
        end
		proptypeString = dms.string(dms["prop_mould"], self.prop.user_prop_template, prop_mould.prop_type)
		
		propName:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		propName:setString(propNameString)
		self._name = propNameString
		
		local iconCell = PropIconCell:createCell()
		iconCell:init(14, self.ship)
		headPanel:addChild(iconCell)
		fwin:addTouchEventListener(headPanel, nil,
		{
			terminal_name = "hero_shop_list_cell_item_buy",
			terminal_state = 0, 
			_Button_3 = Button_3,
			_index = self._index,
			_self = self
		}, 
		nil, 0)
	elseif tonumber(self.goodsType) == 1 then--武将类型
		quality = tonumber(dms.string(dms["ship_mould"], self.prop.user_prop_template, ship_mould.ship_type))
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], self.prop.user_prop_template, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			-- local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = evo_info[dms.int(dms["ship_mould"], self.prop.user_prop_template, ship_mould.captain_name)]
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			_name = word_info[3]
			propNameString = _name
		else
			propNameString = dms.string(dms["ship_mould"], self.prop.user_prop_template, ship_mould.captain_name)
		end
		
		propName:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
		propName:setString(propNameString)
		self._name = propNameString
		
		local iconCell = ShipHeadCell:createCell()
		iconCell:init(self.ship,8,nil,self.ship.sell_count)
		headPanel:addChild(iconCell)
		
		fwin:addTouchEventListener(headPanel, nil,
		{
			terminal_name = "hero_shop_list_cell_item_buy",
			terminal_state = 0, 
			_Button_3 = Button_3,
			_index = self._index,
			_self = self
		}, 
		nil, 0)

	elseif tonumber(self.goodsType) == 2 then--装备类型
		propNameString = dms.string(dms["equipment_mould"], self.prop.user_prop_template, equipment_mould.equipment_name)
		local sceneData = dms.element(dms["equipment_mould"],self.prop.user_prop_template)
		quality = tonumber(dms.string(dms["equipment_mould"], self.prop.user_prop_template, equipment_mould.grow_level))	 --装备品质	
		propName:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
		propName:setString(getEquipmentNameByMouldAndName(data, propNameString))
		self._name = getEquipmentNameByMouldAndName(data, propNameString)
		local iconCell = EquipIconCell:createCell()
		iconCell:init(6,self.ship)
		headPanel:addChild(iconCell)
		
		fwin:addTouchEventListener(headPanel, nil,
		{
			terminal_name = "hero_shop_list_cell_item_buy",
			terminal_state = 0, 
			_Button_3 = Button_3,
			_index = self._index,
			_self = self
		}, 
		nil, 0)
	elseif tonumber(self.goodsType) == -1 then	-- 银币
		app.load("client.cells.prop.prop_money_icon")
		local cell = propMoneyIcon:createCell()
		cell:init("1", self.prop.prop_number, nil)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			propName:setColor(cc.c3b(color_Type[6+1][1],color_Type[6+1][2],color_Type[6+1][3]))
		else
			--propName:setColor(cc.c3b(color_Type[6+1][1],color_Type[6+1][2],color_Type[6+1][3]))
		end
		propName:setString(_All_tip_string_info._fundName)
		self._name = _All_tip_string_info._fundName
		headPanel:addChild(cell)
		fwin:addTouchEventListener(headPanel, nil,
		{
			terminal_name = "hero_shop_list_cell_item_buy",
			terminal_state = 0, 
			_Button_3 = Button_3,
			_index = self._index,
			_self = self
		}, 
		nil, 0)
	end
		
	
end

function HeroShopListCell:onEnterTransitionFinish()
	local root = nil
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		root = cacher.createUIRef("shop/HeroShop/heroShop_list.csb", "root")
	else
		local csbItem = csb.createNode("shop/HeroShop/heroShop_list.csb")
		root = csbItem:getChildByName("root")
		root:removeFromParent(false)
	end
	self:addChild(root)
	table.insert(self.roots, root)
	local remainTimes = {}
	
	self:onUpdateDraw()
	remainTimes[self._index] = self.ship.remain_times
	local Button_3 = ccui.Helper:seekWidgetByName(root, "Button_3")		--价钱
	Button_3:setBright(true)
	Button_3:setTouchEnabled(true)
	if tonumber(remainTimes[self._index]) <= 0 then
		Button_3:setBright(false)
		Button_3:setTouchEnabled(false)
	end
	fwin:addTouchEventListener(Button_3, nil,
	{
		terminal_name = "hero_shop_list_cell_item_buy",
		terminal_state = 0, 
		_Button_3 = Button_3,
		_index = self._index,
		_self = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
end

function HeroShopListCell:onExit()
	-- state_machine.remove("hero_shop_list_cell_item_buy")
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		local root = self.roots[1]
		local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_4")
		headPanel:removeAllChildren(true)
		cacher.freeRef("shop/HeroShop/heroShop_list.csb", root)
	end
end

function HeroShopListCell:init(prop,goodsType,ship,index)
	self.prop = prop
	self.goodsType = goodsType
	self.ship = ship
	self._index = index
end

function HeroShopListCell:createCell()
	local cell = HeroShopListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


