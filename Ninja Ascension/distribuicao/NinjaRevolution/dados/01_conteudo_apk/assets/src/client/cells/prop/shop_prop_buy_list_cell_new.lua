----------------------------------------------------------------------------------------------------
-- 说明：商城道具购买单元项
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
----------------------------------------------------------------------------------------------------
shopPropBuyListCellNew = class("shopPropBuyListCellNewClass", Window)
shopPropBuyListCellNew.__size = nil 
function shopPropBuyListCellNew:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.actions = {}
	self.current_type = nil	--1为道具     2为装备
	self.times = nil
	self.shop_type = nil
	self.isSureBuy = false
	app.load("client.cells.prop.prop_icon_new_cell")
	app.load("client.cells.equip.equip_icon_new_cell")
	app.load("client.shop.ShopPropBuyNumberTip")
	
	-- 初始化道具小图标事件响应需要使用的状态机
	local function init_shop_prop_buy_list_cell_new_terminal()
	--使用按钮的点击
		local shop_prop_buy_list_buy_new_terminal = {
            _name = "shop_prop_buy_list_buy_new",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            
				if params._datas._canBuy <= zstring.tonumber(_ED.vip_grade) then
					if params._datas._limit - params._datas._buyTimes > 0 or params._datas._limit == -1 then
		            	local cell = ShopPropBuyNumberTip:createCell()
						cell:init(params)
						fwin:open(cell, fwin._ui)
					else
						TipDlg.drawTextDailog(_string_piece_info[71])
					end
				else
					TipDlg.drawTextDailog(string.format(_string_piece_info[352],params._datas._canBuy))
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新列表
		local shop_prop_buy_list_refush_new_terminal = {
            _name = "shop_prop_buy_list_refush_new",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
					-- 普通道具
				local cell = params._datas._instance
				local buyCount = params._datas._current_buy_count
				params._datas._prop.buy_times = params._datas._prop.buy_times + buyCount
				
				cell.prop.buy_times = params._datas._prop.buy_times
				cell:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(shop_prop_buy_list_buy_new_terminal)
		state_machine.add(shop_prop_buy_list_refush_new_terminal)
        state_machine.init()
	end
	init_shop_prop_buy_list_cell_new_terminal()
end

function shopPropBuyListCellNew:initDrawTipMessage()
	local root = self.roots[1]
	local propResidue = ccui.Helper:seekWidgetByName(root, "Text_gmcs")		--剩余购买数量
	if zstring.tonumber(self.prop.VIP_buy_times) == -1 then
		propResidue:setString(_string_piece_info[75])
	else
		if self.times == 0 then
			propResidue:setString(_string_piece_info[71])
		else
			propResidue:setString(_string_piece_info[160] .. (self.times) .. _string_piece_info[70])
		end
	end
end
function shopPropBuyListCellNew:onUpdateDraw()
	local root = self.roots[1]
	
	local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_6")
	local goldNumber = ccui.Helper:seekWidgetByName(root, "Text_5")		--价钱
	local propName = ccui.Helper:seekWidgetByName(root, "Text_name")
	local propDescribe = ccui.Helper:seekWidgetByName(root, "Text_jieshao")
	local propResidue = ccui.Helper:seekWidgetByName(root, "Text_gmcs")		--剩余购买数量
	local propBuy = ccui.Helper:seekWidgetByName(root, "Button_2")
	headPanel:removeAllChildren(true)
	self.times = zstring.tonumber(self.prop.VIP_buy_times) - zstring.tonumber(self.prop.buy_times)
	
	local image_gem = ccui.Helper:seekWidgetByName(root,"image_gem")
	local Image_nat_icon = ccui.Helper:seekWidgetByName(root,"Image_nat_icon")
	image_gem:setVisible(false)
	Image_nat_icon:setVisible(false)
	if  self.from_type == "war_fight" then
		Image_nat_icon:setVisible(true)
	else
		image_gem:setVisible(true)
	end
	local ttfConfig = {}
    ttfConfig.fontFilePath = propResidue:getFontName()
    ttfConfig.fontSize=18

    local label1 = cc.Label:createWithTTF(ttfConfig,"Green", cc.VERTICAL_TEXT_ALIGNMENT_CENTER, 0)
    label1:setTextColor(propResidue:getTextColor())
    if zstring.tonumber(self.prop.VIP_buy_times) == -1 then
		label1:setString(_string_piece_info[75])
	else
		if self.times == 0 then
			label1:setString(_string_piece_info[71])
		else
			label1:setString(_string_piece_info[160] .. (self.times) .. _string_piece_info[70])
		end
	end
	
	
	propResidue:removeAllChildren(true)
    propResidue:addChild(label1)
    label1:setAnchorPoint( cc.p(0.5, 0.5) )
	
	if self.current_type == 1 then

		local propQuality = zstring.tonumber(self.prop.prop_quality) + 1
		propName:setString(self.prop.mould_name)
		propDescribe:setString(self.prop.mould_remarks)
		propName:setColor(cc.c3b(color_Type[propQuality][1], color_Type[propQuality][2], color_Type[propQuality][3]))
		-- goldNumber:setString(self.prop.original_cost)
		goldNumber:setString(self:drawPrice(self.prop))
		local iconCell = PropIconNewCell:createCell()
		iconCell:init(iconCell.enum_type._SHOW_PROP_INFORMATION, self.prop)
		headPanel:addChild(iconCell)

		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_3"), nil, 
			{
				terminal_name = "prop_head_manager", 
				terminal_state = 0, 
				_prop = self.prop
			}, 
			nil, 0)
		end
	else
		local equipQuality = zstring.tonumber(self.prop.equipment_quality) + 1
		propName:setString(self.prop.mould_name)
		propDescribe:setString(dms.string(dms["equipment_mould"], self.prop.mould_id, equipment_mould.trace_remarks))
		propName:setColor(cc.c3b(color_Type[equipQuality][1], color_Type[equipQuality][2], color_Type[equipQuality][3]))
		-- goldNumber:setString(self.prop.original_cost)
		goldNumber:setString(self:drawPrice(self.prop))
		local iconCell = EquipIconNewCell:createCell()
		iconCell:init(iconCell.enum_type._SHOW_EMENT_BUY, self.prop, nil)
		headPanel:addChild(iconCell)

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_3"), nil, 
		{
			terminal_name = "equip_icon_cell_change_shop_buy_new", terminal_state = 0, _equip = self.prop
		}, 
		nil, 0)
	end
	--> print(self.prop.VIP_can_buy,"-------------------------------")
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
		{
			terminal_name = "shop_prop_buy_list_buy_new", 
			terminal_state = 0, 
			_prop = self.prop,
			_type = self.current_type,
			_limit = zstring.tonumber(self.prop.VIP_buy_times),
			_canBuy = zstring.tonumber(self.prop.VIP_can_buy),
			_buyTimes = zstring.tonumber(self.prop.buy_times),
			_shopType = self.shop_type,
			_instance = self,
			_from_type = self.from_type,
			_current_buy_count = 0,
			isPressedActionEnabled = true
		}, 
		nil, 0)
end



function shopPropBuyListCellNew:onEnterTransitionFinish()

end
function shopPropBuyListCellNew:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function shopPropBuyListCellNew:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local goldNumber = ccui.Helper:seekWidgetByName(root, "Text_5")
		goldNumber:removeAllChildren(true)
		local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_6")
		headPanel:removeAllChildren(true)
	end
	cacher.freeRef("list/list_daoju_1.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function shopPropBuyListCellNew:onInit()
	local root = cacher.createUIRef("list/list_daoju_1.csb", "root")
	self:addChild(root)
	table.insert(self.roots, root)

	local panel = ccui.Helper:seekWidgetByName(root, "Panel_5")
	local panel_size = panel:getContentSize()

	if shopPropBuyListCellNew.__size == nil  then
		shopPropBuyListCellNew.__size = panel_size 
	end
	self:onUpdateDraw()
	self:setContentSize(panel_size)
end

function shopPropBuyListCellNew:close( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		local goldNumber = ccui.Helper:seekWidgetByName(self.roots[1], "Text_5")
		goldNumber:removeAllChildren(true)
		local headPanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_6")
		headPanel:removeAllChildren(true)
	end
end

function shopPropBuyListCellNew:onExit()
	cacher.freeRef("list/list_daoju_1.csb", self.roots[1])
end

function shopPropBuyListCellNew:init(prop, interfaceType,types,index,from_type)
	self.prop = prop
	self.current_type = interfaceType
	self.shop_type = types
	self.from_type = from_type
	if index ~= nil and index < 7 then
		self:onInit()
	end

	self:setContentSize(shopPropBuyListCellNew.__size)
	return self
end

function shopPropBuyListCellNew:createCell()
	local cell = shopPropBuyListCellNew:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function shopPropBuyListCellNew:drawPrice(_prop)
	if zstring.tonumber(_prop.price_increase) == -1 then
		return zstring.tonumber(_prop.original_cost)
	end
	local ret = _prop.price_increase
	local ret2 = zstring.split(ret,"!")
	local priceConfig = {}
	for n, v in pairs(ret2) do
		local temp = zstring.split(v,",")
		local range = zstring.split(temp[1], "-")
		local price = {
			_range = range,
			_price = temp[2]
		}
		priceConfig[n] = price
	end
	
	local buyTimes = zstring.tonumber(_prop.buy_times + 1)
	local price = 0
	for i, v in pairs(priceConfig) do
		if buyTimes >= zstring.tonumber(v._range[1]) and buyTimes <= zstring.tonumber(v._range[2]) then
			return zstring.tonumber(v._price)
		end
	end
	return price
end

