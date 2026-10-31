----------------------------------------------------------------------------------------------------
-- 说明：跨服矿战单元项
----------------------------------------------------------------------------------------------------
CrossServiceShopCell = class("CrossServiceShopCellClass", Window)
CrossServiceShopCell.__size = nil

function CrossServiceShopCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.actions = {}

	self.left_time = nil
	
	-- 初始化道具小图标事件响应需要使用的状态机
	local function init_cross_server_battel_prop_buy_list_cell_terminal()
	-- 使用按钮的点击
		local cross_server_battel_shop_buy_terminal = {
            _name = "cross_server_battel_shop_buy",
            _init = function (terminal) 
                app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelShopBuy")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas._cell
				if cell.current_buy_times > 0 then
					local prop = cell.prop
					local max_num = cell.current_buy_times
					local had_num = tonumber(_ED.cross_server_battel_mineral_num)
					local need_num =  tonumber(prop.sale_percentage)
					if had_num < need_num then 
						TipDlg.drawTextDailog(tipStringInfo_cross_server_battel_tips[7])
						return true
					end
					local may_num = math.floor(had_num / need_num )
					prop.prop_number = may_num > max_num and max_num or may_num

					instance:setPropInfo(prop)
					prop.id = cell.id
					cell.prop = prop
					cell.form_cell = "cross_server_battel_prop_buy_list_cell"
					
					app.load("client.packs.prop.ComExchange")
					state_machine.excute("com_exchange_use_open",0,cell)
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(cross_server_battel_shop_buy_terminal)
        state_machine.init()
	end
	init_cross_server_battel_prop_buy_list_cell_terminal()
end


function CrossServiceShopCell:setPropInfo(prop)
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

function CrossServiceShopCell:onUpdateDraw(addTimes)
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

	Text_name:setString(self.prop.mould_name .. "*" .. self.prop.number)
	local quality = tonumber(self.prop.prop_quality)
	Text_name:setColor(cc.c3b(color_Type[quality+1][1], color_Type[quality+1][2], color_Type[quality+1][3]))

	Text_5:setString(self.prop.sale_percentage)
	
	local cost_image = {
		[1] = "images/ui/icon/zuanshi.png",   		-- 钻石
		[2] = "images/ui/icon/jinbi.png",   		-- 金币
		[65] = "images/ui/text/cross_service/ico_kuang_s.png" -- 矿石
	}

	Panel_icon:setBackGroundImage(cost_image[self.prop.sell_type])

	local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
	Panel_6:removeAllChildren(true)
	local cell = ResourcesIconCell:createCell()
	if tonumber(self.prop.type) == 7 then
		cell:init(tonumber(self.prop.type),0,tonumber(self.prop.mould_id),nil,nil,nil,true,nil,{equipQuality = quality})
	else
		cell:init(tonumber(self.prop.type),0,tonumber(self.prop.mould_id),nil,nil,nil,true)
	end
	Panel_6:addChild(cell)
	local panel = ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop")
	--panel:setTouchEnabled(false)

	local Text_buy_times = ccui.Helper:seekWidgetByName(root, "Text_buy_times")
	local Image_sale = ccui.Helper:seekWidgetByName(root, "Image_sale")
	self.Text_Sale = ccui.Helper:seekWidgetByName(root, "Text_Sale")
	local buy_times_string = self.current_buy_times .. "/" .. self.buy_times

	Image_sale:setVisible(self.left_time and self.left_time > 0)

	Text_buy_times:setString("")
	Text_buy_times:removeAllChildren(true)

	 local richTextWidth = Text_buy_times:getContentSize().width
    if richTextWidth == 0 then
        richTextWidth = Text_buy_times:getFontSize() * 8
    end
			
	local _richText = ccui.RichText:create()
	_richText:setContentSize(cc.size(richTextWidth, 0))
    _richText:setAnchorPoint(cc.p(0, 0))

    _richText:ignoreContentAdaptWithSize(false)  
     local re1 = ccui.RichElementText:create(1, cc.c3b(0,166,255),255, tipStringInfo_cross_server_battel_tips[1], Text_buy_times:getFontName(),Text_buy_times:getFontSize())
    _richText:pushBackElement(re1)
    local color = tonumber(self.current_buy_times) <= 0 and cc.c3b(255,0,0) or cc.c3b(0,166,255)
     local re2 = ccui.RichElementText:create(1, color,255, buy_times_string, Text_buy_times:getFontName(),Text_buy_times:getFontSize())
    _richText:pushBackElement(re2)
	_richText:setPosition(cc.p(-richTextWidth + Text_buy_times:getFontSize(), Text_buy_times:getFontSize()/2 + 5))
    Text_buy_times:addChild(_richText)

end

function CrossServiceShopCell:formatTimeString( _time )--系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end

function CrossServiceShopCell:onUpdate(dt)
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

function CrossServiceShopCell:onInit()
    local root = cacher.createUIRef("campaign/cross_service/cross_service_shop_cell.csb", "root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_purchase"), nil, 
	{
		terminal_name = "cross_server_battel_shop_buy", 
		terminal_state = 0, 
		_cell = self,
	}, 
	nil, 0)

	local panel_size = root:getContentSize()
	self:onUpdateDraw()
	self:setContentSize(panel_size)
	if CrossServiceShopCell.__size == nil then
		CrossServiceShopCell.__size = panel_size
	end

	self:registerOnNoteUpdate(self, 1)
end

function CrossServiceShopCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function CrossServiceShopCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("campaign/cross_service/cross_service_shop_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function CrossServiceShopCell:clearUIInfo( ... )
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
		Panel_icon:removeBackGroundImage()
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

function CrossServiceShopCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("campaign/cross_service/cross_service_shop_cell.csb", self.roots[1])
end

function CrossServiceShopCell:initData()
	local prop_param = zstring.split(dms.atos(self.shopInfo, cross_mine_war_shop.goods), ",") 
	local prop = {}

	prop.type = tonumber(prop_param[1])
	prop.mould_id = tonumber(prop_param[2])
	prop.number = tonumber(prop_param[3])

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
	local buy_param = zstring.split(dms.atos(self.shopInfo, cross_mine_war_shop.buy_param), ",") 
	prop.sell_type = tonumber(buy_param[1])
	prop.sale_percentage = tonumber(buy_param[3])

	self.buy_times = dms.atoi(self.shopInfo, cross_mine_war_shop.times)
	self.onec_cd_time = dms.atoi(self.shopInfo, cross_mine_war_shop.cd_time)

	self.id = dms.atoi(self.shopInfo, cross_mine_war_shop.id)
	self.prop = prop

	local cd_time = zstring.tonumber(_ED.cross_server_battel_shop_info[self.id .. ""].nextRefTime)
	local left_time = cd_time / 1000 - (_ED.system_time + (os.time() - _ED.native_time))
	if left_time > 0 then
		self.left_time = left_time
	end

	self.current_buy_times = _ED.cross_server_battel_shop_info[self.id .. ""].residueNum
end

function CrossServiceShopCell:init(params)
	self.shopInfo = params
	self:initData()
	self:onInit()
	if CrossServiceShopCell.__size then
		self:setContentSize(CrossServiceShopCell.__size)
	end
end

function CrossServiceShopCell:createCell()
	local cell = CrossServiceShopCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


