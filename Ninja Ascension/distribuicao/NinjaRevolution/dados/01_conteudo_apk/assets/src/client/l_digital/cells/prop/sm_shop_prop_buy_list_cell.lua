----------------------------------------------------------------------------------------------------
-- 说明：sm商城道具购买单元项
----------------------------------------------------------------------------------------------------
SmShopPropBuyListCell = class("SmShopPropBuyListCellClass", Window)
SmShopPropBuyListCell.__size = nil

function SmShopPropBuyListCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.actions = {}
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.l_digital.shop.SmShopBuy")
	
	-- 初始化道具小图标事件响应需要使用的状态机
	local function init_sm_shop_prop_buy_list_cell_terminal()
	--使用按钮的点击
		local sm_shop_prop_buy_list_buy_terminal = {
            _name = "sm_shop_prop_buy_list_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params[1]
            	local root = cell.roots[1]
            	local Image_sell_out = ccui.Helper:seekWidgetByName(root, "Image_sell_out")
            	if Image_sell_out:isVisible() == true then
				else
					local all_money = 0
					local tip = ""
					if cell.page == 2 then
						if tonumber(cell.prop.sell_type) == 1 then
							all_money = _ED.user_info.user_gold
							tip = union_red_envelopes_tips[2]
						else
							all_money = _ED.user_info.user_silver
							tip = union_red_envelopes_tips[1]
						end
					elseif cell.page == 3 then
						tip = _new_interface_text[96]
						all_money = _ED.user_info.user_honour
					elseif cell.page == 4 then
						tip = _new_interface_text[95]
						all_money = _ED.user_info.all_glories
					elseif cell.page == 5 then
						all_money = _ED.union.user_union_info.rest_contribution
						tip = _new_interface_text[94]
					end
					if tonumber(all_money) < tonumber(cell.prop.sale_percentage) then
						if cell.page ~= 2 then
							TipDlg.drawTextDailog(string.format( _new_interface_text[93] , tip))
							return
						else
							if tonumber(cell.prop.sell_type) == 1 then
								TipDlg.drawTextDailog(_string_piece_info[74])
							end
						end
					end
					
					local prop = cell.prop
					local max_num = instance:getBuyMaxNum(cell)
					local had_num = tonumber(all_money)
					local need_num =  tonumber(cell.prop.sale_percentage)
					local may_num = math.floor(had_num / need_num )
					prop.prop_number = may_num > max_num and max_num or may_num
					prop.mould_id = tonumber(cell.prop.mould_id)
					prop.type = tonumber(cell.prop.type)

					instance:setPropInfo(prop)
					prop.id = cell.index
					cell.prop = prop
					cell.form_cell = instance:getBuyCellName(cell.page) --来自跨服王者之战/公会战兑换cell
					
					app.load("client.packs.prop.ComExchange")
					state_machine.excute("com_exchange_use_open",0,cell)
				end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新列表
		local sm_shop_prop_buy_list_refush_terminal = {
            _name = "sm_shop_prop_buy_list_refush",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- Fury: la compra contesta tarde y la celda puede no tener raiz:
				-- descargada al salir de la vista (`unload` deja roots = {}), aun sin
				-- cargar (index > 4) o de otra clase (4-oct, rol 451, :98 y :117).
				local root = params.roots ~= nil and params.roots[1] or nil
				
            	local show_group = nil
				if params.page == 2 then
					show_group = _ED.secret_shop_init_info.goods_info[tonumber(params.index)]
					params.prop.buy_times = 1 - tonumber(show_group.remain_times)
				elseif params.page == 3 then
					show_group = _ED.arena_good[tonumber(params.index)]
					params.prop.buy_times = tonumber(show_group.exchange_times)
				elseif params.page == 4 then
					show_group = _ED.glories_shop_info[tonumber(params.index)]
					params.prop.buy_times = tonumber(show_group.goods_exchange_times)
				elseif params.page == 5 then
					show_group = _ED.union.union_shop_info.treasure.goods_info[tonumber(params.index)]
					params.prop.buy_times = tonumber(show_group.remain_times)
				end

				local Image_sell_out = root ~= nil and ccui.Helper:seekWidgetByName(root, "Image_sell_out") or nil
				if Image_sell_out == nil then
					return true
				end
				if tonumber(params.prop.buy_times) >= tonumber(params.prop.buy_limit) then
					Image_sell_out:setVisible(true)
					Image_sell_out:setScale(2)
					Image_sell_out:runAction(cc.ScaleTo:create(0.1, 1))
				end

				if params ~= nil then
					params:updateLimitBuyTimes(root)
				end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(sm_shop_prop_buy_list_buy_terminal)
		state_machine.add(sm_shop_prop_buy_list_refush_terminal)
        state_machine.init()
	end
	init_sm_shop_prop_buy_list_cell_terminal()
end

function SmShopPropBuyListCell:setPropInfo(prop)
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
end

function SmShopPropBuyListCell:getBuyMaxNum(params)
	local show_group = nil
	if params.page == 2 then
		show_group = _ED.secret_shop_init_info.goods_info[tonumber(params.index)]
		params.prop.buy_times = 1 - tonumber(show_group.remain_times)
	elseif params.page == 3 then
		show_group = _ED.arena_good[tonumber(params.index)]
		params.prop.buy_times = tonumber(show_group.exchange_times)
	elseif params.page == 4 then
		show_group = _ED.glories_shop_info[tonumber(params.index)]
		params.prop.buy_times = tonumber(show_group.goods_exchange_times)
	elseif params.page == 5 then
		show_group = _ED.union.union_shop_info.treasure.goods_info[tonumber(params.index)]
		params.prop.buy_times = tonumber(show_group.remain_times)
	end
	return params.prop.buy_limit - params.prop.buy_times
end

function SmShopPropBuyListCell:getBuyCellName(typePage)
	local cellName = ""
	if typePage== 2 then
		cellName = "secret_shop_prop_buy_cell"
	elseif typePage == 3 then
		cellName = "arena_shop_prop_buy_cell"
	elseif typePage == 4 then
		cellName = "glories_shop_prop_buy_cell"
	else
		cellName = "union_shop_prop_buy_cell"
	end
	return cellName 
end

function SmShopPropBuyListCell:onUpdateDraw()
	local root = self.roots[1]
	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	Text_name:setString(self.prop.mould_name.." x"..self.prop.number)
	local quality = tonumber(self.prop.prop_quality)
	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital and dark_text_color then
		Text_name:setColor(cc.c3b(dark_text_color[quality+1][1], dark_text_color[quality+1][2], dark_text_color[quality+1][3]))
	else
		Text_name:setColor(cc.c3b(color_Type[quality+1][1], color_Type[quality+1][2], color_Type[quality+1][3]))
	end
	local Text_5 = ccui.Helper:seekWidgetByName(root, "Text_5")
	Text_5:setString(self.prop.sale_percentage)
	local Image_sell_out = ccui.Helper:seekWidgetByName(root, "Image_sell_out")
	if tonumber(self.prop.buy_times) >= tonumber(self.prop.buy_limit) then
		Image_sell_out:setVisible(true)
	else
		Image_sell_out:setVisible(false)
	end

	-- image_gem_1   
	-- image_money_1 
	-- image_jjb_1   
	-- image_slb_1   
	-- image_ghb_1   

	local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")

	local cost_image = {
		"images/ui/icon/zuanshi.png",   		-- 钻石
		"images/ui/icon/jinbi.png",   		-- 金币
		"images/ui/icon/qh_pic_jjb.png",   		--竞技币
		"images/ui/icon/slb.png",   		--试炼币
		"images/ui/icon/icon_ghb.png",   		--公会币
	}
	if self.page == 2 then
		if self.prop.sell_type == 1 then
			Panel_icon:setBackGroundImage(cost_image[1])
		else
			Panel_icon:setBackGroundImage(cost_image[2])
		end
	else
		Panel_icon:setBackGroundImage(cost_image[self.page])
	end
	local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
	Panel_6:removeAllChildren(true)
	local cell = ResourcesIconCell:createCell()
	if tonumber(self.prop.type) == 7 then
		cell:init(tonumber(self.prop.type),0,tonumber(self.prop.mould_id),nil,nil,false,true,nil,{equipQuality = quality})
	else
		cell:init(tonumber(self.prop.type),0,tonumber(self.prop.mould_id),nil,nil,false,true)
	end
	Panel_6:addChild(cell)
	local panel = ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop")
	--panel:setTouchEnabled(false)

	local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
	if Image_1 ~= nil then
		Image_1:setVisible(false)
	end
	self:updateLimitBuyTimes(root)
end

function SmShopPropBuyListCell:updateLimitBuyTimes(root)
	local Text_xiangou = ccui.Helper:seekWidgetByName(root, "Text_xiangou")
	local Text_cishu = ccui.Helper:seekWidgetByName(root, "Text_cishu")
	local Text_time_next = ccui.Helper:seekWidgetByName(root, "Text_time_next")

	Text_xiangou:setVisible(false)
	Text_cishu:setVisible(false)
	Text_time_next:setVisible(false)

	-- 竞技商店，试炼商店，公会商店
	if self.page ~= 2 and self.prop.refresh_type ~= 0 then
		local xiangouContent = ""
		local nextRefreshContent = ""
		if self.prop.refresh_type == 1 then -- 每日刷新
			xiangouContent = tipStringInfo_shop_restriction[1]
			nextRefreshContent = tipStringInfo_shop_restriction[4]
		elseif self.prop.refresh_type == 2 then -- 每周刷新
			xiangouContent = tipStringInfo_shop_restriction[2]
			nextRefreshContent = tipStringInfo_shop_restriction[5]
		elseif self.prop.refresh_type == 3 then -- 每月刷新
			xiangouContent = tipStringInfo_shop_restriction[3]
			nextRefreshContent = tipStringInfo_shop_restriction[6]
		end
		Text_xiangou:setString(xiangouContent)
		Text_cishu:setString(string.format("(%s/%s)", self.prop.buy_times, self.prop.buy_limit))
		Text_time_next:setString(nextRefreshContent)

		if tonumber(self.prop.buy_times) >= tonumber(self.prop.buy_limit) then
			Text_xiangou:setVisible(false)
			Text_xiangou:setVisible(false)
			Text_time_next:setVisible(true)
		else
			Text_xiangou:setVisible(true)
			Text_cishu:setVisible(true)
			Text_time_next:setVisible(false)
		end
	end
end

function SmShopPropBuyListCell:onInit()
    local root = cacher.createUIRef("list/list_daoju.csb", "root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	-- local panel = ccui.Helper:seekWidgetByName(root, "Panel_5")
	local panel_size = root:getContentSize()
	self:onUpdateDraw()
	self:setContentSize(panel_size)
	if SmShopPropBuyListCell.__size == nil then
		SmShopPropBuyListCell.__size = panel_size
	end

	-- self:runAction(cc.Sequence:create({cc.DelayTime:create(0.1), cc.CallFunc:create(function ( sender )
    	-- self:setVisible(true)
 --        sender.roots[1]:runAction(cc.Sequence:create(
 --            cc.ScaleTo:create(0.1, 0.95),
 --            cc.ScaleTo:create(0.05, 1)
 --            ))
 --    end)}))
 	local clickTime = 0
 	local function PanelTouchEvent(sender, evenType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if ccui.TouchEventType.began == evenType then
			clickTime = os.time()
        elseif ccui.TouchEventType.moved == evenType then
        elseif ccui.TouchEventType.canceled == evenType then
		elseif ccui.TouchEventType.ended == evenType then
			if (os.time() - clickTime) < 1 then 
				if math.abs(__epoint.x - __spoint.x) <= 3 
            	and math.abs(__epoint.y - __spoint.y) <= 3 then
                	state_machine.excute("sm_shop_prop_buy_list_buy",0,{sender._self})
            	end
			end
			clickTime = 0
        end
    end
 	local Image_purchase = ccui.Helper:seekWidgetByName(root, "Image_purchase")
 	Image_purchase._self = self
 	Image_purchase:addTouchEventListener(PanelTouchEvent)
	-- fwin:addTouchEventListener(, nil, 
	-- {
	-- 	terminal_name = "sm_shop_prop_buy_list_buy", 
	-- 	terminal_state = 0, 
	-- 	_cell = self,
	-- }, 
	-- nil, 0)
end

function SmShopPropBuyListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function SmShopPropBuyListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("list/list_daoju.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function SmShopPropBuyListCell:clearUIInfo( ... )
    local root = self.roots[1]
    if root == nil then
    	return
    end

	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	local Text_5 = ccui.Helper:seekWidgetByName(root, "Text_5")
	local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
	local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
	local Text_xiangou = ccui.Helper:seekWidgetByName(root, "Text_xiangou")
	local Text_cishu = ccui.Helper:seekWidgetByName(root, "Text_cishu")
	local Text_time_next = ccui.Helper:seekWidgetByName(root, "Text_time_next")
    local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")

	
	if Text_xiangou ~= nil then
		Text_xiangou:setVisible(false)
	end
	if Text_cishu ~= nil then
		Text_cishu:setVisible(false)
	end
	if Text_time_next ~= nil then
		Text_time_next:setVisible(false)
	end
	if Text_name ~= nil then
		Text_name:setString("")
	end
	if Text_5 ~= nil then
		Text_5:setString("")
	end
	if Panel_6 ~= nil then
		Panel_6:removeAllChildren(true)
	end
	if Panel_icon ~= nil then
		Panel_icon:removeBackGroundImage()
	end
	if Image_1 ~= nil then
		Image_1:setVisible(false)
	end
end

function SmShopPropBuyListCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("list/list_daoju.csb", self.roots[1])
end

function SmShopPropBuyListCell:init(prop , page , index)
	self.prop = prop
	self.page = page
	self.index = index
	if self.index <= 4 then
		self:onInit()
	end
	self:setContentSize(SmShopPropBuyListCell.__size)
end

function SmShopPropBuyListCell:createCell()
	local cell = SmShopPropBuyListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


