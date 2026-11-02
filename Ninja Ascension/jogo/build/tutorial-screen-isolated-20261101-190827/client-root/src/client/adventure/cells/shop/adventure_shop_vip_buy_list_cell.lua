----------------------------------------------------------------------------------------------------
-- 说明：商城Vip购买单元项

----------------------------------------------------------------------------------------------------
AdventureShopVipBuyListCell = class("AdventureShopVipBuyListCellClass", Window)

function AdventureShopVipBuyListCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.actions = {}
	self.current_type = nil	--1为道具     2为装备
	self.times = nil
	self.shop_type = nil
	self.isSureBuy = false

	app.load("client.adventure.cells.prop.adventure_sign_prop_icon_cell")
	
	-- 初始化道具小图标事件响应需要使用的状态机
	local function init_shop_prop_buy_list_cell_terminal()
	--使用按钮的点击
		local adventure_shop_prop_buy_list_buy_terminal = {
            _name = "adventure_shop_prop_buy_list_buy",
            _init = function (terminal) 
                app.load("client.adventure.shop.AdventureShopBatch")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
           
		        if params._datas == nil then
            		return
            	end
				if params._datas._canBuy <= zstring.tonumber(_ED.vip_grade) then
					
					if params._datas._limit - params._datas._buyTimes > 0 or params._datas._limit == -1 then
						fwin:open(AdventureShopBatch:new():init({mould_name = params._datas._mould_name ,original_cost = params._datas._sale_price ,shop_prop_instance = params._datas._shop_prop_instance},4,params._datas._instance), fwin._ui)
					else
						TipDlg.drawTextDailog(_string_piece_info[71])
					end
				else
					local resetCountElement = dms.element(dms["base_consume"], 8)
 					local attackCount = dms.atoi(resetCountElement, base_consume.vip_0_value + zstring.tonumber(params._datas._canBuy)-1) --
					TipDlg.drawTextDailog(string.format(_string_piece_info[352],attackCount))
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新列表
		local adventure_shop_prop_buy_list_refush_terminal = {
            _name = "adventure_shop_prop_buy_list_refush",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params
				if cell ~= nil then 
					cell.prop.buy_times = 1
					cell:removeFromParent(true)
					state_machine.excute("adventure_shop_buy_vip_ok_update_list", 0, 0)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_shop_prop_buy_list_buy_terminal)
		state_machine.add(adventure_shop_prop_buy_list_refush_terminal)
        state_machine.init()
	end
	init_shop_prop_buy_list_cell_terminal()
end

function AdventureShopVipBuyListCell:sureToBuy(sure_number , buy_mould)
	
end

function AdventureShopVipBuyListCell:onUpdateDraw()
	local root = self.roots[1]
	
	local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_6")
	local goldNumber = ccui.Helper:seekWidgetByName(root, "Text_5")		--价钱
	local propName = ccui.Helper:seekWidgetByName(root, "Text_name")
	local propDescribe = ccui.Helper:seekWidgetByName(root, "Text_jieshao") --介绍
	local propResidue = ccui.Helper:seekWidgetByName(root, "Text_gmcs")		--剩余购买数量
	local propBuy = ccui.Helper:seekWidgetByName(root, "Button_2")
	
	self.times = zstring.tonumber(self.prop.VIP_buy_times) - zstring.tonumber(self.prop.buy_times)

    if zstring.tonumber(self.prop.VIP_buy_times) == -1 then
		propResidue:setString(_string_piece_info[75])
	else
		if self.times == 0 then
			propResidue:setString(_string_piece_info[71])
		else
			if self.shop_type ~= 1 then
				propResidue:setString(_string_piece_info[69] .. (self.times) .. _string_piece_info[70])
			else
				propResidue:setString(_string_piece_info[160] .. (self.times) .. _string_piece_info[70])
			end
		end
	end

	if self.current_type == 1 then
		if self.shop_type == 1 then
			local propQuality = zstring.tonumber(self.prop.prop_quality) + 1
			propName:setString(self.prop.mould_name)
			local resetCountElement = dms.element(dms["base_consume"], 8)
			local attackCount = dms.atoi(resetCountElement, base_consume.vip_0_value + zstring.tonumber(self.prop.VIP_can_buy)-1) --
			local describe = string.format(_string_piece_info[352],attackCount)
			if zstring.tonumber(self.prop.VIP_can_buy) == 0 then 
				propDescribe:setString(_string_piece_info[449])
			else
				propDescribe:setString(describe)
			end
			
			propName:setColor(cc.c3b(color_Type[propQuality][1], color_Type[propQuality][2], color_Type[propQuality][3]))
			goldNumber:setString(self:drawPrice(self.prop))
			ccui.Helper:seekWidgetByName(root, "Panel_xianzai"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Panel_zhekou"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_222"):setString(self.prop.sale_price)
			ccui.Helper:seekWidgetByName(root, "Text_333"):setString(self.prop.original_cost)			
			ccui.Helper:seekWidgetByName(root, "Text_chongzhi"):setString("" .. getResourceValueToStringForAdventure(_ED.recharge_precious_number) .."/" ..getResourceValueToStringForAdventure(attackCount))

			local cell = adventureSignPropIconCell:createCell()
        	cell:init(4,  {mould_id = self.prop.mould_id}, 0, 0)
            headPanel:removeAllChildren(true)	
			headPanel:addChild(cell)
		end
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
		{
			terminal_name = "adventure_shop_prop_buy_list_buy", 
			terminal_state = 0, 
			_prop = self.prop,
			_type = self.current_type,
			_limit = zstring.tonumber(self.prop.VIP_buy_times),
			_canBuy = zstring.tonumber(self.prop.VIP_can_buy),
			_buyTimes = zstring.tonumber(self.prop.buy_times),
			_shopType = self.shop_type,
			_instance = self,
			_mould_name = self.prop.mould_name,
			_sale_price = self.prop.sale_price,
			_shop_prop_instance = self.prop.shop_prop_instance,
			_current_buy_count = 0,
			cell = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
end

function AdventureShopVipBuyListCell:onEnterTransitionFinish()

end

function AdventureShopVipBuyListCell.onImageLoaded(texture)
	
end

function AdventureShopVipBuyListCell:onArmatureDataLoad(percent)
	
end

function AdventureShopVipBuyListCell:onArmatureDataLoadEx(percent)
end

function AdventureShopVipBuyListCell:onLoad()
	local csbItem = nil
	
	csbItem = csb.createNode("list/list_daoju_1.csb")
	
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_5")
	local panel_size = panel:getContentSize()
	self:onUpdateDraw()
	self:setContentSize(panel_size)

	self:setVisible(false)

	self:onInit()
end

function AdventureShopVipBuyListCell:onInit()

	local root = self.roots[1]
	-- 列表控件动画播放
	self:setVisible(true)
	
end

function AdventureShopVipBuyListCell:onExit()
	
end

function AdventureShopVipBuyListCell:init(prop, interfaceType,types)
	self.prop = prop
	self.current_type = interfaceType
	self.shop_type = types

	self._load_over = false
	self:onLoad()
	return self
end

function AdventureShopVipBuyListCell:createCell()
	local cell = AdventureShopVipBuyListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function AdventureShopVipBuyListCell:drawPrice(_prop)
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

