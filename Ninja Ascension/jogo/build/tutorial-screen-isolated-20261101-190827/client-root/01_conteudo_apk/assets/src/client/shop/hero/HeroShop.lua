-----------------------------------------------------------------------------------------------------------
-- 说明：神秘商店主界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

HeroShop = class("HeroShopClass", Window)
    
function HeroShop:ctor()
    self.super:ctor()
	app.load("client.cells.prop.hero_shop_list_cell")
	app.load("client.shop.ShopUserInformation")
	app.load("client.refinery.RefiningFurnace")
	if __lua_project_id == __lua_project_gragon_tiger_gate
	or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
	or __lua_project_id == __lua_project_red_alert 
	then
		app.load("client.cells.prop.prop_icon_cell")
	end
	self.roots = {}
	self.propId = nil
	self.surplus = 0
	self.closeType = nil
	-- app.load("client.home.home")
	-- app.load("client.player.UserInformation")
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.type = nil
    -- Initialize HeroShop page state machine.
    local function init_HeroShop_terminal()
		--返回home界面
		local hero_shop_return_home_page_terminal = {
            _name = "hero_shop_return_home_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				_ED.secret_shop_is_refresh = false
				if instance.closeType == nil then
					fwin:cleanView(fwin._view) 
					fwin:close(instance)
					if fwin:find("HomeClass") == nil then
		            	state_machine.excute("menu_manager", 0, 
							{
								_datas = {
									terminal_name = "menu_manager", 	
									next_terminal_name = "menu_show_home_page", 
									current_button_name = "Button_home",
									but_image = "Image_home", 		
									terminal_state = 0, 
									isPressedActionEnabled = true
								}
							}
						)
		            end

					state_machine.excute("menu_back_home_page", 0, "") 
				else
					fwin:close(instance)
					if fwin:find("HomeClass") == nil then
		            	state_machine.excute("menu_manager", 0, 
							{
								_datas = {
									terminal_name = "menu_manager", 	
									next_terminal_name = "menu_show_home_page", 
									current_button_name = "Button_home",
									but_image = "Image_home", 		
									terminal_state = 0, 
									isPressedActionEnabled = true
								}
							}
						)
		            end
				end
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					if fwin:find("HeroResolvePageClass") == nil then
						fwin:close(fwin:find("UserTopInfoAClass"))
					end
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local hero_shop_buy_goods_terminal = {
            _name = "hero_shop_buy_goods",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:BuyGoods()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local hero_equiment_resolve_recover_terminal = {
            _name = "hero_equiment_resolve_recover",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 

                if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
                    local isopen,tip = getFunopenLevelAndTip(10)
                    if isopen == true then
						fwin:close(instance)
						if fwin:find("UserTopInfoAClass") ~= nil then
							fwin:close(fwin:find("UserTopInfoAClass"))
						end
						state_machine.excute("menu_clean_page_state", 0,"") 
						fwin:open(RefiningFurnace:new(), fwin._view)
						state_machine.excute("refining_furnace_manager", 0, 
							{
								_datas = {
									terminal_name = "refining_furnace_manager", 	
									next_terminal_name = "refining_furnace_show_hero_resolve_view",	
									current_button_name = "Button_wjfj",  	
									but_image = "", 	
									terminal_state = 0, 
									isPressedActionEnabled = false
								}
							}
						)
                    else
                        TipDlg.drawTextDailog(tip)
                    end
                else
					fwin:close(instance)
					state_machine.excute("menu_clean_page_state", 0,"") 
					fwin:open(RefiningFurnace:new(), fwin._view)
					state_machine.excute("refining_furnace_manager", 0, 
						{
							_datas = {
								terminal_name = "refining_furnace_manager", 	
								next_terminal_name = "refining_furnace_show_hero_resolve_view",	
								current_button_name = "Button_wjfj",  	
								but_image = "", 	
								terminal_state = 0, 
								isPressedActionEnabled = false
							}
						}
					)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--刷新
		local hero_shop_refresh_button_terminal = {
            _name = "hero_shop_refresh_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil then
							local currentType = response.node.closeType
							fwin:close(response.node)
							local heroShop =  HeroShop:new()
							heroShop:init(currentType)
							fwin:open(heroShop, fwin._view) 
						end
					end
				end
				local function refresh( ... )
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						local count = getPropAllCountByMouldId(3)
						if self.surplus > 0 or zstring.tonumber(count) > 0 then
							NetworkManager:register(protocol_command.secret_shop_refresh.code, nil, nil, nil, instance, recruitCallBack, false, nil)
						else
							TipDlg.drawTextDailog(_string_piece_info[161])
						end
					else
						if self.surplus > 0 then
							NetworkManager:register(protocol_command.secret_shop_refresh.code, nil, nil, nil, instance, recruitCallBack, false, nil)
						else
							TipDlg.drawTextDailog(_string_piece_info[161])
						end
					end
				end
				if verifySupportLanguage(_lua_release_language_en) == true then
					if __lua_project_id == __lua_project_warship_girl_b then
						local count = getPropAllCountByMouldId(3)
						if zstring.tonumber(count) == 0 then
							app.load("client.utils.ConfirmTip")
					        local tip = ConfirmTip:new()
					        tip:init(instance, instance.confirmRefresh, _string_piece_info[379], nil, nil)
					        fwin:open(tip, fwin._windows)
					    else
					    	refresh()
					    end
					else
						refresh()
				    end
			    else
					refresh()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local hero_shop_request_buy_item_terminal = {
            _name = "hero_shop_request_buy_item",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if TipDlg.drawStorageTipo() == false then
					local button_name = params._datas._Button_3
					button_name.request = true
					local _mIndex = params._datas._index
					local _sell_type = params._datas._sell_type
					local _sell_price = params._datas._sell_price
					-- 请求神将商店购买
					local function recruitCallBack(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							TipDlg.drawTextDailog(_string_piece_info[76])
							if response.node.request == nil then
								return
							end
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
								if _mIndex ~= nil then
									_ED.secret_shop_init_info.goods_info[_mIndex].remain_times = "0"
								end
							end
							response.node.request = nil
							response.node:setBright(false)
							response.node:setTouchEnabled(false)
							state_machine.excute("hero_shop_buy_goods", 0, nil)
						end
					end
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						if tonumber(_sell_type) == 1  then
							if tonumber(_sell_price) > tonumber(_ED.user_info.user_gold) then
								state_machine.excute("shortcut_open_recharge_window",0,"")
								return
							end
						elseif tonumber(_sell_type) == 0 then
							if tonumber(_sell_price) > tonumber(_ED.user_info.jade) then
								state_machine.excute("shortcut_function_silver_to_get_open",0,5)
								return
							end
						end
					end
					protocol_command.secret_shop_exchange.param_list = ""..(tonumber(_mIndex)-1)
					NetworkManager:register(protocol_command.secret_shop_exchange.code, nil, nil, nil, button_name, recruitCallBack, false, nil)
                end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		state_machine.add(hero_shop_return_home_page_terminal)
		state_machine.add(hero_shop_refresh_button_terminal)
		state_machine.add(hero_equiment_resolve_recover_terminal)
		state_machine.add(hero_shop_buy_goods_terminal)
		state_machine.add(hero_shop_request_buy_item_terminal)

        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_HeroShop_terminal()
end

function HeroShop:confirmRefresh( surenumber )
	if surenumber == 1 then
        return
    end
	local function recruitCallBack(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil then
				local currentType = response.node.closeType
				fwin:close(response.node)
				local heroShop =  HeroShop:new()
				heroShop:init(currentType)
				fwin:open(heroShop, fwin._view) 
			end
		end
	end

	NetworkManager:register(protocol_command.secret_shop_refresh.code, nil, nil, nil, self, recruitCallBack, false, nil)
end

function HeroShop:formatTimeString(_time)	--系统时间转换
	local timeString = ""
	timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
	timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
	timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
	return timeString
end

function HeroShop:BuyGoods()
	local _jade = ccui.Helper:seekWidgetByName(self.roots[1], "Text_4")
	_jade:setString(_ED.user_info.jade)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		if fwin:find("HeroResolvePageClass") ~= nil then
			state_machine.excute("hero_resolve_update_jade",0,"")
		end
	end
end
function HeroShop:DarwCommodity()
	local root = self.roots[1]
	
	local count = getPropAllCountByMouldId(3)

	if count == nil then
		count = 0
	end
	local _refreshCount = ccui.Helper:seekWidgetByName(root, "Text_10_0")
	_refreshCount:setString(count)
	--刷新次数
	local VipLv = tonumber(_ED.vip_grade)
	local refreshNumber = tonumber(dms.string(dms["base_consume"],30,tonumber(base_consume.vip_0_value)+VipLv))--神秘商店刷新次数。VIP越高次数越多
	local surplusRefresh = refreshNumber - tonumber(_ED.secret_shop_init_info.refresh_count)
	local _refreshNumber = ccui.Helper:seekWidgetByName(root, "Text_9")
	self.surplus = surplusRefresh
	_refreshNumber:setString(surplusRefresh)
	
	local CommodityShop = {
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_3"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_4"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_5"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_6"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_7"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_8")
	}
	for i ,v in pairs(_ED.secret_shop_init_info.goods_info) do 
		if i >= 7 then
			return
		else
			if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				then
				self:drawTigergateInfo(CommodityShop[i], i, v)
			else
				local picCell = HeroShopListCell:createCell()
				picCell:init(
				{
					user_prop_template = v.goods_id, 
					mould_id = v.goods_id, 
					prop_number = v.sell_count, 
					buy_type = v.sell_type, 
					picel = v.sell_price
				},
				v.goods_type, v, i)--1：商品类型 2：商品实例 3：商品下标索引
				CommodityShop[i]:removeAllChildren(true)
				CommodityShop[i]:addChild(picCell)
			end
		end
	end
end

function HeroShop:drawTigergateInfo(panel, index, info)
	if info == nil then
		panel:setVisible(false)
		return
	end
	panel:setVisible(true)
	local quality = nil
	local propNameString = nil
	local proptypeString = nil
	local propName = panel:getChildByName("Text_5")  		--名字
	local headPanel = panel:getChildByName("Panel_role_icon")-- 头像
	local resTypePanel = panel:getChildByName("Panel_money_1") 	-- 显示的类型
	local Panel_tuijian = panel:getChildByName("Panel_tuijian")
	local goldNumber = panel:getChildByName("Text_6")		--价钱
	local Button_3 = panel:getChildByName("Button_3")		--购买
	goldNumber:setString(info.sell_price)
	headPanel:removeAllChildren(true)

	if tonumber(info.remain_times) <= 0 then
		Button_3:setBright(false)
		Button_3:setTouchEnabled(false)
	end
	fwin:addTouchEventListener(Button_3, nil,
	{
		terminal_name = "hero_shop_request_buy_item",
		terminal_state = 0, 
		_Button_3 = Button_3,
		_index = index,
		_sell_type = info.sell_type,
		_sell_price = info.sell_price,
		isPressedActionEnabled = true
	}, 
	nil, 0)

	--推荐
	if tonumber(info.recommend) == 1 then
		Panel_tuijian:setBackGroundImage("images/ui/text/sc_tuijian.png")
		Panel_tuijian:setVisible(true)
	else
		Panel_tuijian:setVisible(false)
	end
	--购买类型
	if tonumber(info.sell_type) == 0 then
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_yugioh
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge then 
			resTypePanel:setBackGroundImage("images/ui/icon/icon_shumahun.png")
		else
			resTypePanel:setBackGroundImage("images/ui/icon/icon_jianghun.png")
		end
		
	elseif tonumber(info.sell_type) == 1 then
		resTypePanel:setBackGroundImage("images/ui/icon/icon_gem.png")
	end

	if tonumber(info.goods_type) == 0 then--道具类型
		quality = tonumber(dms.string(dms["prop_mould"], info.goods_id, prop_mould.prop_quality))+1
		propNameString = dms.string(dms["prop_mould"], info.goods_id, prop_mould.prop_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        propNameString = setThePropsIcon(info.goods_id)[2]
	    end
		propName:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		propName:setString(propNameString)
		
		local iconCell = PropIconCell:createCell()
		iconCell:init(14, info)
		headPanel:addChild(iconCell)
		-- fwin:addTouchEventListener(headPanel, nil,
		-- {
		-- 	terminal_name = "hero_shop_list_cell_item_buy",
		-- 	terminal_state = 0, 
		-- 	_Button_3 = Button_3,
		-- 	_index = index,
		-- 	_sell_type = info.sell_type
		-- }, 
		-- nil, 0)
	elseif tonumber(info.goods_type) == 1 then--武将类型
		quality = tonumber(dms.string(dms["ship_mould"], info.goods_id, ship_mould.ship_type))
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], info.goods_id, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			-- local ship_evo = zstring.split(fundShipWidthId(""..shipID).evolution_status, "|")
			local evo_mould_id = evo_info[dms.int(dms["ship_mould"], info.goods_id, ship_mould.captain_name)]
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
        	propNameString = word_info[3]
		else
			propNameString = dms.string(dms["ship_mould"], info.goods_id, ship_mould.captain_name)
		end
		
		propName:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
		propName:setString(propNameString)
		
		local iconCell = ShipHeadCell:createCell()
		iconCell:init(info, 8,nil,info.sell_count)
		headPanel:addChild(iconCell)
		-- fwin:addTouchEventListener(headPanel, nil,
		-- {
		-- 	terminal_name = "hero_shop_list_cell_item_buy",
		-- 	terminal_state = 0, 
		-- 	_Button_3 = Button_3,
		-- 	_index = index,
		-- 	_sell_type = info.sell_type
		-- }, 
		-- nil, 0)

	elseif tonumber(info.goods_type) == 2 then--装备类型
		propNameString = dms.string(dms["equipment_mould"], info.goods_id, equipment_mould.equipment_name)
		local sceneData = dms.element(dms["equipment_mould"],info.goods_id)
		quality = tonumber(dms.string(dms["equipment_mould"], info.goods_id, equipment_mould.grow_level))	 --装备品质	
		propName:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
		propName:setString(getEquipmentNameByMouldAndName(sceneData, propNameString))
		
		local iconCell = EquipIconCell:createCell()
		iconCell:init(6, info)
		headPanel:addChild(iconCell)
		-- fwin:addTouchEventListener(headPanel, nil,
		-- {
		-- 	terminal_name = "hero_shop_list_cell_item_buy",
		-- 	terminal_state = 0, 
		-- 	_Button_3 = Button_3,
		-- 	_index = index,
		-- 	_sell_type = info.sell_type
		-- }, 
		-- nil, 0)
	elseif tonumber(info.goods_type) == -1 then	-- 银币
		app.load("client.cells.prop.prop_money_icon")
		local cell = propMoneyIcon:createCell()
		cell:init("1", info.sell_count, nil)
		propName:setString(_All_tip_string_info._fundName)
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
			propName:setColor(cc.c3b(color_Type[6+1][1],color_Type[6+1][2],color_Type[6+1][3]))
		end
		headPanel:addChild(cell)
		-- fwin:addTouchEventListener(headPanel, nil,
		-- {
		-- 	terminal_name = "hero_shop_list_cell_item_buy",
		-- 	terminal_state = 0, 
		-- 	_Button_3 = Button_3,
		-- 	_index = index,
		-- 	_sell_type = info.sell_type
		-- }, 
		-- nil, 0)
	end
end

function HeroShop:DarwCommodity1()
	local root = self.roots[1]
	if _ED.secret_shop_init_info.os_time ~= nil then
		local times = os.time()- tonumber(_ED.secret_shop_init_info.os_time)
			
		
		local remainTime = 0
		local _refreshTime = ccui.Helper:seekWidgetByName(root, "Text_2")
		if times > _ED.secret_shop_init_info.refresh_time/1000 then -- 当前时间减去登录那一刻的时间大于服务器返回的剩余时间。就说明可以免费招了
			_refreshTime:setString(self:formatTimeString(remainTime))
		else 
			remainTime =_ED.secret_shop_init_info.refresh_time/1000-times	--剩余刷新的时间
			_refreshTime:setString(self:formatTimeString(remainTime))
		end
	end
end

function HeroShop:onUpdate(dt)
	self:DarwCommodity1()
	
end

function HeroShop:onEnterTransitionFinish()		
    local csbHeroShop = csb.createNode("shop/HeroShop/heroShop.csb")
	local action = csb.createTimeline("shop/HeroShop/heroShop.csb") 
	
   	action:gotoFrameAndPlay(0, action:getDuration(), false)
    csbHeroShop:runAction(action)
	local root = csbHeroShop:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbHeroShop)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		if fwin:find("UserTopInfoAClass") == nil then
			local userinfo = UserTopInfoA:new()
			fwin:open(userinfo,fwin._windows)
		else
			fwin:close(fwin:find("UserTopInfoAClass"))
			local userinfo = UserTopInfoA:new()
			fwin:open(userinfo,fwin._windows)
		end
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
			local times = os.time()-_ED.secret_shop_init_info.os_time
			if times > _ED.secret_shop_init_info.refresh_time/1000 then
				TipDlg.drawTextDailog(_string_piece_info[131])
			end
		
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
			{
				terminal_name = "hero_shop_return_home_page", 
				next_terminal_name = "", 
				but_image = "", 
				terminal_state = 0, 
				cell = self,
				isPressedActionEnabled = true
			}, 
			nil, 2)
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil, 
			{
				terminal_name = "hero_shop_refresh_button", 
				next_terminal_name = "", 
				but_image = "", 
				terminal_state = 0, 
				cell = self,
				isPressedActionEnabled = true
			}, 
			nil, 0)
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
			{
				terminal_name = "hero_equiment_resolve_recover", 
				next_terminal_name = "", 
				but_image = "", 
				terminal_state = 0, 
				cell = self,
				isPressedActionEnabled = true
			}, 
			nil, 0)

			self:DarwCommodity()
			self:BuyGoods()
			-- fwin:open(UserTopInfoA:new(), fwin._ui)
			
			if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				then
				-- app.load("client.player.UserTopInfoA") 					--顶部用户信息
				-- self.userinfo = UserTopInfoA:new()
				-- fwin:open(self.userinfo,fwin._view)			
			else
				app.load("client.player.UserInformationShop") 					--顶部用户信息
				self.userinfo = UserInformationShop:new()
				fwin:open(self.userinfo,fwin._view)
			end
	else
		local function recruitCallBack(response)

			if nil == fwin:find("HeroShopClass") then
				return
			end
		
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				local times = os.time()-_ED.secret_shop_init_info.os_time
				if times > _ED.secret_shop_init_info.refresh_time/1000 then
					TipDlg.drawTextDailog(_string_piece_info[131])
				end
			
				fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
				{
					terminal_name = "hero_shop_return_home_page", 
					next_terminal_name = "", 
					but_image = "", 
					terminal_state = 0, 
					cell = self,
					isPressedActionEnabled = true
				}, 
				nil, 2)
				fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil, 
				{
					terminal_name = "hero_shop_refresh_button", 
					next_terminal_name = "", 
					but_image = "", 
					terminal_state = 0, 
					cell = self,
					isPressedActionEnabled = true
				}, 
				nil, 0)
				fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
				{
					terminal_name = "hero_equiment_resolve_recover", 
					next_terminal_name = "", 
					but_image = "", 
					terminal_state = 0, 
					cell = self,
					isPressedActionEnabled = true
				}, 
				nil, 0)

				self:DarwCommodity()
				self:BuyGoods()
			-- fwin:open(UserTopInfoA:new(), fwin._ui)
			
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					-- app.load("client.player.UserTopInfoA") 					--顶部用户信息
					-- self.userinfo = UserTopInfoA:new()
					-- fwin:open(self.userinfo,fwin._view)			
				else
					app.load("client.player.UserInformationShop") 					--顶部用户信息
					self.userinfo = UserInformationShop:new()
					fwin:open(self.userinfo,fwin._view)
				end
			end
		end
		NetworkManager:register(protocol_command.secret_shop_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)
	end
end

function HeroShop:init(closeType)
	self.closeType = closeType
end
function HeroShop:close()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		fwin:close(fwin:find("UserTopInfoAClass"))
	elseif __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_warship_girl_b 
		then 
		fwin:close(fwin:find("UserInformationShopClass"))
	end
end
function HeroShop:onExit()
	if nil ~= self.userinfo and self.userinfo.parent ~= nil then
		fwin:close(self.userinfo)
	end
	state_machine.remove("hero_shop_return_home_page")
	state_machine.remove("hero_shop_refresh_button")
	state_machine.remove("hero_equiment_resolve_recover")
	state_machine.remove("hero_shop_buy_goods")
	state_machine.remove("hero_shop_request_buy_item")
end


