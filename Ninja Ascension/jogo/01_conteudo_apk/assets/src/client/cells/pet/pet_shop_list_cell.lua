----------------------------------------------------------------------------------------------------
-- 说明：宠物商店单元项
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
----------------------------------------------------------------------------------------------------
PetShopListCell = class("PetShopListCellClass", Window)

function PetShopListCell:ctor()
    self.super:ctor()
	app.load("client.cells.ship.ship_head_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.prop.prop_icon_new_cell")	
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
	local function init_pet_shop_list_cell_terminal()
		--购买按钮的点击
		local pet_shop_list_cell_item_buy_terminal = {
            _name = "pet_shop_list_cell_item_buy",
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
					
					_mIndex = params._datas._index
					
					-- 请求神将商店购买
					local function recruitCallBack(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							TipDlg.drawTextDailog(_string_piece_info[76])
							if response.node.request == nil then
								return
							end
							response.node.request = nil
							response.node:setBright(false)
							response.node:setTouchEnabled(false)
							state_machine.excute("pet_shop_buy_goods", 0, nil)
						end
					end
		
					protocol_command.pet_shop_exchange.param_list = ""..(tonumber(_mIndex)-1).. "\r\n"
					NetworkManager:register(protocol_command.pet_shop_exchange.code, nil, nil, nil, button_name, recruitCallBack, false, nil)
					
                end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(pet_shop_list_cell_item_buy_terminal)
        state_machine.init()
	end
	init_pet_shop_list_cell_terminal()
end

function PetShopListCell:sureToBuy(sure_number,cell)
	if sure_number == 0 then
		local Button_3 = ccui.Helper:seekWidgetByName(cell.roots[1], "Button_3")		--价钱
		self.isSureGoldToBuye = true
		state_machine.excute("pet_shop_list_cell_item_buy",0,
			{
			_datas={
					terminal_name = "pet_shop_list_cell_item_buy",
					terminal_state = 0, 
					_Button_3 = Button_3,
					_index = cell._index,
					_self = cell
				}
			})
	end
end

function PetShopListCell:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
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
	if tonumber(self.prop.buy_type) == 2 then
		resTypePanel:setBackGroundImage("images/ui/icon/xunshouhun.png")
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

		local iconCell = nil
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
			terminal_name = "pet_shop_list_cell_item_buy",
			terminal_state = 0, 
			_Button_3 = Button_3,
			_index = self._index,
			_self = self
		}, 
		nil, 0)
	end
end

function PetShopListCell:onEnterTransitionFinish()
	local root = nil

	local csbItem = csb.createNode("packs/HeroStorage/generals_juexing_Shop_list.csb")
	root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	
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
		terminal_name = "pet_shop_list_cell_item_buy",
		terminal_state = 0, 
		_Button_3 = Button_3,
		_index = self._index,
		_self = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
end

function PetShopListCell:onExit()
	state_machine.remove("pet_shop_list_cell_item_buy")
end

function PetShopListCell:init(prop,goodsType,ship,index)
	self.prop = prop
	self.goodsType = goodsType
	self.ship = ship
	self._index = index
end

function PetShopListCell:createCell()
	local cell = PetShopListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


