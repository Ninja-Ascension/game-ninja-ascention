----------------------------------------------------------------------------------------------------
-- 说明：跨服矿战单元项
----------------------------------------------------------------------------------------------------
CrossTotalWarShopCell = class("CrossTotalWarShopCellClass", Window)
CrossTotalWarShopCell.__size = nil

function CrossTotalWarShopCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.propData = nil		-- 当前要绘制的道具实例数据对对象
	self.actions = {}

	self.left_time = nil
	
	-- 初始化道具小图标事件响应需要使用的状态机
	local function init_cross_total_war_prop_buy_list_cell_terminal()
	-- 使用按钮的点击
		local cross_total_war_shop_buy_terminal = {
            _name = "cross_total_war_shop_buy",
            _init = function (terminal) 
				app.load("client.l_digital.campaign.cross_total_war.CrossTotalWarShopBuy")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas._cell
				if cell.current_buy_times > 0 then
					if tonumber(_ED.cross_arena_shop_info.coin) >= tonumber(cell.propData.sale_percentage) then
						local prop = {}
						local reward = dms.element(dms["cross_arena_shop"], cell.id)
						local reworld_prop = zstring.split(dms.atos(reward, 2), ",")
						local had_num = tonumber(_ED.cross_arena_shop_info.coin)
						local need_num =  tonumber(cell.propData.sale_percentage)
						local may_num = math.floor(had_num / need_num )
						if may_num > cell.current_buy_times then
							may_num = cell.current_buy_times
						end
						prop.prop_number = may_num
						prop.mould_id = tonumber(reworld_prop[2])
						prop.type = tonumber(reworld_prop[1])
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
						prop.id = cell.id
						cell.prop = prop
						cell.form_cell = "sm_total_war_exchange_list_cell" --来自跨服王者之战/公会战兑换cell

						--这里添加兑换弹窗
						app.load("client.packs.prop.ComExchange")
						state_machine.excute("com_exchange_use_open",0,cell)
						fwin:close(instance)
					else 
						TipDlg.drawTextDailog(tipStringInfo_cross_total_war_tips[1])
					end
				else 
					TipDlg.drawTextDailog(tipStringInfo_cross_total_war_tips[3])
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(cross_total_war_shop_buy_terminal)
        state_machine.init()
	end
	init_cross_total_war_prop_buy_list_cell_terminal()
end


function CrossTotalWarShopCell:onUpdateDraw(addTimes)
	local root = self.roots[1]
	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	local Text_5 = ccui.Helper:seekWidgetByName(root, "Text_5")
	local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
	local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
	if addTimes then
		self.current_buy_times = self.current_buy_times + addTimes
		if not self.left_time and self.current_buy_times < self.buy_times then
			local left_time = self.onec_cd_time
			if left_time ~= 0 then
				self.left_time = left_time

			end 
		end
	end

	Text_name:setString(self.propData.mould_name .. "*" .. self.propData.number)
	local quality = tonumber(self.propData.prop_quality)
	Text_name:setColor(cc.c3b(color_Type[quality+1][1], color_Type[quality+1][2], color_Type[quality+1][3]))

	Text_5:setString(self.propData.sale_percentage)
	
	local cost_image = {
		[1] = "images/ui/icon/zuanshi.png",   		-- 钻石
		[2] = "images/ui/icon/jinbi.png",   		-- 金币
		[65] = "images/ui/text/cross_service/ico_kuang_s.png" -- 矿石
	}

	-- Panel_icon:setBackGroundImage(cost_image[self.propData.sell_type])

	local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
	Panel_6:removeAllChildren(true)
	local cell = ResourcesIconCell:createCell()
	if tonumber(self.propData.type) == 7 then
		cell:init(tonumber(self.propData.type),0,tonumber(self.propData.mould_id),nil,nil,nil,true,nil,{equipQuality = quality})
	else
		cell:init(tonumber(self.propData.type),0,tonumber(self.propData.mould_id),nil,nil,nil,true)
	end
	Panel_6:addChild(cell)
	local panel = ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop")
	--panel:setTouchEnabled(false)

	local Text_buy_times = ccui.Helper:seekWidgetByName(root, "Text_buy_times")
	local Image_sale = ccui.Helper:seekWidgetByName(root, "Image_sale")
	self.Text_Sale = ccui.Helper:seekWidgetByName(root, "Text_Sale")
	local buy_times_string = self.current_buy_times .. "/" .. self.buy_times

	Image_sale:setVisible(self.left_time and self.left_time > 0)

	local Text_buy_day = ccui.Helper:seekWidgetByName(root, "Text_buy_day")
	local Text_buy_week = ccui.Helper:seekWidgetByName(root, "Text_buy_week")
	Text_buy_day:setVisible(false)
	Text_buy_week:setVisible(false)
	local day_txt = Text_buy_day:getString()
	local week_txt = Text_buy_week:getString()
	
	local type_txt = day_txt
	
	if self.propData.good_type == 2 then
		type_txt = week_txt
	end


	Text_buy_times:setVisible(true)
	Text_buy_times:removeAllChildren(true)


	 local richTextWidth = Text_buy_times:getContentSize().width
    if richTextWidth == 0 then
        richTextWidth = Text_buy_times:getFontSize() * 8
    end
			
	local _richText = ccui.RichText:create()
	_richText:setContentSize(cc.size(richTextWidth, 0))
    _richText:setAnchorPoint(cc.p(0, 0))

    _richText:ignoreContentAdaptWithSize(false)  
     local re1 = ccui.RichElementText:create(1, cc.c3b(0,166,255),255, type_txt, Text_buy_times:getFontName(),Text_buy_times:getFontSize())
    _richText:pushBackElement(re1)
    local color = tonumber(self.current_buy_times) <= 0 and cc.c3b(255,0,0) or cc.c3b(0,166,255)
     local re2 = ccui.RichElementText:create(1, color,255, buy_times_string, Text_buy_times:getFontName(),Text_buy_times:getFontSize())
    _richText:pushBackElement(re2)
	_richText:setPosition(cc.p(-richTextWidth/2 + Text_buy_times:getFontSize(), Text_buy_times:getFontSize()/2 + 5))
	Text_buy_times:setString("")

    Text_buy_times:addChild(_richText)

end

function CrossTotalWarShopCell:formatTimeString( _time )--系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end

function CrossTotalWarShopCell:onUpdate(dt)
	if nil ~= self.left_time then
        self.left_time = self.left_time - dt
        if self.left_time <= 0 then
        	self.left_time = nil
            self:onUpdateDraw(1)
        else
        	self.Text_Sale:setString(self:formatTimeString(self.left_time))
        end
    end
end

function CrossTotalWarShopCell:onInit()
    local root = cacher.createUIRef("campaign/cross_total_war/cross_total_war_shop_list.csb", "root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_purchase"), nil, 
	{
		terminal_name = "cross_total_war_shop_buy", 
		terminal_state = 0, 
		_cell = self,
	}, 
	nil, 0)

	local panel_size = root:getContentSize()
	self:onUpdateDraw()
	self:setContentSize(panel_size)
	if CrossTotalWarShopCell.__size == nil then
		CrossTotalWarShopCell.__size = panel_size
	end

	self:registerOnNoteUpdate(self, 1)
end

function CrossTotalWarShopCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function CrossTotalWarShopCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("campaign/cross_total_war/cross_total_war_shop_list.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function CrossTotalWarShopCell:clearUIInfo( ... )
    local root = self.roots[1]
	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	local Text_5 = ccui.Helper:seekWidgetByName(root, "Text_5")
	local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
	local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
	local Text_buy_times = ccui.Helper:seekWidgetByName(root, "Text_buy_times")
	local Text_Sale = ccui.Helper:seekWidgetByName(root, "Text_Sale")

	if Text_name ~= nil then
		Text_name:setString("")
		Text_5:setString("")
		Panel_6:removeAllChildren(true)
		-- Panel_icon:removeBackGroundImage()
	end
	if Text_buy_times then
		Text_buy_times:setString("")
		Text_buy_times:removeAllChildren(true)
	end
    local Image_sale = ccui.Helper:seekWidgetByName(root, "Image_sale")
	if Image_sale ~= nil then
		Image_sale:setVisible(false)
		Text_Sale:setString("")
	end
end

function CrossTotalWarShopCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("campaign/cross_total_war/cross_total_war_shop_list.csb", self.roots[1])
end

function CrossTotalWarShopCell:initData()



	local prop = {}

	local reward = dms.element(dms["cross_arena_shop"], self.shopInfo.goodsId)

	local prop_param = zstring.split(dms.atos(reward, 2), ",")
	local cost_info = zstring.split(dms.atos(reward, 3), ",")

	-- prop.mould_id = tonumber(goods_info[2])
	-- prop.type = tonumber(goods_info[1])
	-- prop.sale_percentage = self.shopInfo.price
	-- prop.good_index = self.shopInfo.weights
	-- prop.max_buy_times = self.shopInfo.maxFrequency
	-- prop.good_id = self.shopInfo.goodsId

	-- if prop.number == nil then
	-- 	prop.number = 1
	-- end

	-- local prop_param = zstring.split(dms.atos(self.shopInfo, cross_mine_war_shop.goods), ",") 
	-- local prop = {}
	prop.good_type = dms.atoi(reward, 5)

	prop.type = tonumber(prop_param[1])
	prop.mould_id = tonumber(prop_param[2])
	prop.number = tonumber(prop_param[3])
	if prop.number == nil then
		prop.number = 1
	end

	if prop.type == 6 then
		prop_info = dms.element(dms["prop_mould"], prop.mould_id)
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
	elseif prop.type == 7 then
		prop_info = dms.element(dms["equipment_mould"], prop.mould_id)
		if prop.mould_name == nil then
			prop.mould_name = smEquipWordlFundByIndex(prop.mould_id , 1)
		end
		prop.prop_quality = dms.atoi(prop_info, equipment_mould.trace_npc_index)
		if prop.prop_quality == 0 then
			prop.prop_quality = 3
		end
		prop.mould_remarks = smEquipWordlFundByIndex(prop.mould_id , 2)--描述
	end

	--消耗
	-- local buy_param = zstring.split(dms.atos(self.shopInfo, cross_mine_war_shop.buy_param), ",") 
	prop.sell_type = tonumber(dms.atos(reward, 5))
	prop.sale_percentage = tonumber(dms.atos(reward, 3))

	self.buy_times = self.shopInfo.maxFrequency
	-- self.onec_cd_time = dms.atoi(self.shopInfo, cross_mine_war_shop.cd_time)

	self.id = self.shopInfo.goodsId
	self.propData = prop

	-- local cd_time = zstring.tonumber(_ED.cross_total_war_shop_info[self.id .. ""].nextRefTime)
	-- local left_time = cd_time / 1000 - (_ED.system_time + (os.time() - _ED.native_time))
	-- if left_time > 0 then
	-- 	self.left_time = left_time
	-- end

	self.current_buy_times = tonumber(self.buy_times) - tonumber(self.shopInfo.purchasedTimes)
end

function CrossTotalWarShopCell:init(params)
	self.shopInfo = params
	self:initData()
	self:onInit()
	if CrossTotalWarShopCell.__size then
		self:setContentSize(CrossTotalWarShopCell.__size)
	end
end

function CrossTotalWarShopCell:createCell()
	local cell = CrossTotalWarShopCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


