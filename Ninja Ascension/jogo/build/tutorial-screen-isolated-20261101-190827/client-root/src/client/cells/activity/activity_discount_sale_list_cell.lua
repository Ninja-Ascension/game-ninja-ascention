-- ----------------------------------------------------------------------------------------------------
-- 说明：折扣贩售
-------------------------------------------------------------------------------------------------------
ActivityDiscountSaleListCell = class("ActivityDiscountSaleListCellClass", Window)
    
function ActivityDiscountSaleListCell:ctor()
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
	self.remainTimes = 0 --剩余次数
	
	self.get_info_arg = {}
	self.needGolds = 0
    -- Initialize ActivityDiscountSaleListCell state machine.
    local function init_activity_variety_shop_three_list_cell_terminal()
		--兑换
		local variety_shop_three_exchange_terminal = {
            _name = "variety_shop_three_exchange",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local index = params._datas._index
				local mCell = params._datas._cell
				local param = params._datas
				if mCell.needGolds > tonumber(_ED.user_info.user_gold) then
					state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
					{
						terminal_name = "shortcut_open_recharge_window", 
						terminal_state = 0, 
						_msg = _string_piece_info[316], 
						_datas= 
						{

						}
					})
					return
				end	
				if mCell.maxcount > 1 then 
					app.load("client.activity.ActivityDiscountSaleForDrawSelectAward")
					state_machine.excute("activity_discount_sale_for_draw_select_award_window_open",0,mCell)
				else
					app.load("client.activity.ActivityDiscountSaleBatchBuy")
					state_machine.excute("activity_discount_sale_batch_buy_window_open",0,mCell)	
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(variety_shop_three_exchange_terminal)
        state_machine.init()
    end
    
    -- call func init ActivityDiscountSaleListCell state machine.
    init_activity_variety_shop_three_list_cell_terminal()
end

function ActivityDiscountSaleListCell:rewadDraw(_index,buyCounst)
	local root = self.roots[1]
	_ED.discount_sale_exchang_times[self.index] = zstring.tonumber(_ED.discount_sale_exchang_times[self.index]) + buyCounst
	
	local getRewardWnd = DrawRareReward:new()
	getRewardWnd:init(53)
	fwin:open(getRewardWnd,fwin._ui)
	
	local activity = _ED.active_activity[76]
	
	local GetButton = ccui.Helper:seekWidgetByName(root, "Button_12_4")
	if zstring.tonumber(_ED.discount_sale_exchang_times[self.index]) >= zstring.tonumber(self.get_info_arg[1]._maxTimes) then
		GetButton:setBright(false)
		GetButton:setTouchEnabled(false)
	end
	self.remainTimes = zstring.tonumber(self.get_info_arg[1]._maxTimes) - zstring.tonumber(_ED.discount_sale_exchang_times[self.index])
	if self.remainTimes <= 0 then 
		self.remainTimes = 0
	end
	local text = ccui.Helper:seekWidgetByName(root, "Text_013_6")
	text:setString("" ..self.remainTimes
					.."/"..zstring.tonumber(self.get_info_arg[1]._maxTimes))
end
function ActivityDiscountSaleListCell:onUpdateDraw()
	local root = self.roots[1]
	
	local GetButton = ccui.Helper:seekWidgetByName(root, "Button_12_4")
	if zstring.tonumber(_ED.discount_sale_exchang_times[self.index]) >= zstring.tonumber(self.get_info_arg[1]._maxTimes) then
		GetButton:setBright(false)
		GetButton:setTouchEnabled(false)
	end
	
	local text = ccui.Helper:seekWidgetByName(root, "Text_013_6")

	self.remainTimes = zstring.tonumber(self.get_info_arg[1]._maxTimes) - zstring.tonumber(_ED.discount_sale_exchang_times[self.index])

	text:setString("" ..self.remainTimes
					.."/"..zstring.tonumber(self.get_info_arg[1]._maxTimes))
	
	-- FURY: en el arte de este proyecto la lista se llama
	-- "ListView_011_2_0" (landed_gifts_list_dh.csb, en los doce paquetes).
	-- Con el nombre viejo salia nil y moria en el primer addChild.
	local listview = ccui.Helper:seekWidgetByName(root, "ListView_011_2_0")
		or ccui.Helper:seekWidgetByName(root, "ListView_011_2")
	for i, v in ipairs(self.need_info_arg) do
		local propCell = VarietyShopPropIcon:createCell()
		if tonumber(v._type) == 2 and tonumber(v._mould) == 1 then
			self.needGolds = tonumber(v._count)
		end
		propCell:init(propCell.enum_type.NONE, v._type, v._mould, v._count)
		listview:addChild(propCell)
	end
	
	for i, v in ipairs(self.get_info_arg) do
		local propCell = VarietyShopPropIcon:createCell()
		local tmpType = propCell.enum_type.NONE
		if i == 1 then
			tmpType = propCell.enum_type.EQUAL_IMAGE
		end
		propCell:init(tmpType, v._type, v._mould, v._count)
		listview:addChild(propCell)
	end
	
	-- FURY: EL NOMBRE DE LA FILA. `Text_change_name` de
	-- `landed_gifts_list_dh.csb` trae quemado el marcador chino
	-- 兑换物品名称 («nombre del objeto a canjear») y
	-- ninguna de las tres celdas lo pisaba nunca: por eso las filas del
	-- 70, el 71 y el 76 salian en chino. Sale de la MISMA fuente que el
	-- del 28 (ActivityExchangePropList.lua:401-402):
	-- `getItemNameAndQuality`, que lo busca en `prop_mould` y
	-- `word_mould` con el molde que YA viaja dentro del catalogo. No hay
	-- texto que inventar ni token nuevo que mandar.
	local nameText = ccui.Helper:seekWidgetByName(root, "Text_change_name")
	local gain = self.get_info_arg[1]
	if nameText ~= nil then
		if gain ~= nil then
			nameText:ignoreContentAdaptWithSize(true)
			nameText:setString(tostring(
				getItemNameAndQuality({gain._type, gain._mould, gain._count})[1]))
			nameText:setVisible(true)
		else
			nameText:setVisible(false)
		end
	end
end
function ActivityDiscountSaleListCell:onEnterTransitionFinish()
	local csbActivityDiscountSaleListCell = csb.createNode("activity/wonderful/landed_gifts_list_dh.csb")
    local root = csbActivityDiscountSaleListCell:getChildByName("root")
    table.insert(self.roots, root)
	root:removeFromParent(false)
    self:addChild(root)
	
	self:setContentSize(root:getChildByName("Panel_land_list_3"):getContentSize())
	-- 列表控件动画播放
	
	local action = csb.createTimeline("activity/wonderful/landed_gifts_list_dh.csb")
    root:runAction(action)
    action:play("list_view_cell_open", false)
	
	self:onUpdateDraw()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12_4"), nil, 
	{
		terminal_name = "variety_shop_three_exchange", 
		terminal_state = 0, 
		_index = self.index,
		_cell = self,			
		isPressedActionEnabled = true
	},
	nil,0)
end

function ActivityDiscountSaleListCell:onExit()
	
end

function ActivityDiscountSaleListCell:init(example,index)
	self.example = example
	self.index = index
	
	local tmp_data = zstring.split(self.example, "=")
	local tmp_need = nil
	local tmp_get = nil
	local tmp_get_data = nil
	local maxTimes = nil
	
	local activity = _ED.active_activity[76]
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
end

function ActivityDiscountSaleListCell:createCell()
	local cell = ActivityDiscountSaleListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end