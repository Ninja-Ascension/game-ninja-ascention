----------------------------------------------------------------------------------------------------
-- 说明：商城道具购买单元项
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
----------------------------------------------------------------------------------------------------
shopPropBuyListCell = class("shopPropBuyListCellClass", Window)

function shopPropBuyListCell:ctor()
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
	local function init_shop_prop_buy_list_cell_terminal()
	--使用按钮的点击
		local shop_prop_buy_list_buy_terminal = {
            _name = "shop_prop_buy_list_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            
		        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		        	if instance.isSureBuy == true then
		        		instance.isSureBuy = false
		        		local buy_id = tonumber(params)
	        			local function responseBuyVipPackCallback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								local function responseVIPShopViewCallBack()
									if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
										TipDlg.drawTextDailog(_string_piece_info[76])
										state_machine.excute("shop_vip_prop_buy_list_update",0,"")
									end
								end
								protocol_command.shop_view.param_list = "1"
								NetworkManager:register(protocol_command.shop_view.code, nil, nil, nil, self, responseVIPShopViewCallBack, false, nil)
							end
						end
						protocol_command.prop_purchase.param_list = buy_id .. "\r\n" .. 1 .. "\r\n" .. 1
						NetworkManager:register(protocol_command.prop_purchase.code, nil, nil, nil, instance, responseBuyVipPackCallback, false, nil)
						return
		        	end
		        end
		        if params._datas == nil then
            		return
            	end
				--> print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz")
				--> print(params._datas._canBuy,_ED.vip_grade,"----------------------------------------------")
				if params._datas._canBuy <= zstring.tonumber(_ED.vip_grade) then
					--> print(params._datas._limit , params._datas._buyTimes,"------------------------")
					if params._datas._limit - params._datas._buyTimes > 0 or params._datas._limit == -1 then
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							local prop_buy_mould = params._datas._prop
							if tonumber(instance.shop_type) == 1 then	
								app.load("client.utils.ConfirmPrompted")
								if instance.isSureBuy == false then
			            			local _sale_price = params._datas._prop.sale_price
			            			local _ConfirmPrompted = ConfirmPrompted:new()
			            			_ConfirmPrompted:init(instance,instance.sureToBuy,_sale_price,params._datas._prop)
			            			fwin:open(_ConfirmPrompted,fwin._windows)		
			            			return
			            		end
			            	else
				            	local cell = ShopPropBuyNumberTip:createCell()
								cell:init(params)
								fwin:open(cell, fwin._ui)
			            	end
						else
							local cell = ShopPropBuyNumberTip:createCell()
							cell:init(params)
							fwin:open(cell, fwin._ui)
						end
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
		local shop_prop_buy_list_refush_terminal = {
            _name = "shop_prop_buy_list_refush",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas._instance
				if self.shop_type == 1 then
					--vip礼包
					cell.prop.buy_times = 1
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
						local parnet = cell:getParent()
						if parnet.child1 == cell then
							if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							else
								parnet.child1:removeFromParent(true)
							end
						end
						if parnet.child2 == cell then
							if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							else
								parnet.child2:removeFromParent(true)
							end
						end						
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							state_machine.excute("shop_vip_prop_buy_list_update", 0, "")
						else
							state_machine.excute("multiple_list_view_cell_manager", 0, parnet)
							for i, v in pairs(cell.listView:getItems()) do
								state_machine.excute("multiple_list_view_cell_manager", 0, v)
							end
						end

					else
						cell:removeFromParent(true)
					end
				else
					-- 普通道具
					local buyCount = params._datas._current_buy_count
					params._datas._prop.buy_times = params._datas._prop.buy_times + buyCount
					
					cell.prop.buy_times = params._datas._prop.buy_times
					cell:onUpdateDraw()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(shop_prop_buy_list_buy_terminal)
		state_machine.add(shop_prop_buy_list_refush_terminal)
        state_machine.init()
	end
	init_shop_prop_buy_list_cell_terminal()
end
function shopPropBuyListCell:sureToBuy(sure_number , buy_mould)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		if sure_number == 0 then
			self.isSureBuy = true
			state_machine.excute("shop_prop_buy_list_buy",0,buy_mould.shop_prop_instance)
		end
	end
end
function shopPropBuyListCell:initDrawTipMessage()
	local root = self.roots[1]
	local propResidue = ccui.Helper:seekWidgetByName(root, "Text_gmcs")		--剩余购买数量
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
end
function shopPropBuyListCell:onUpdateDraw()
	local root = self.roots[1]
	
	local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_6")
	local goldNumber = ccui.Helper:seekWidgetByName(root, "Text_5")		--价钱
	local propName = ccui.Helper:seekWidgetByName(root, "Text_name")
	local propDescribe = ccui.Helper:seekWidgetByName(root, "Text_jieshao")
	local propResidue = ccui.Helper:seekWidgetByName(root, "Text_gmcs")		--剩余购买数量
	local propBuy = ccui.Helper:seekWidgetByName(root, "Button_2")
	
	self.times = zstring.tonumber(self.prop.VIP_buy_times) - zstring.tonumber(self.prop.buy_times)
	
	-- if zstring.tonumber(self.prop.VIP_buy_times) == -1 then
	-- 	propResidue:setString(_string_piece_info[75])
	-- else
	-- 	if self.times == 0 then
	-- 		propResidue:setString(_string_piece_info[71])
	-- 	else
	-- 		if self.shop_type ~= 1 then
	-- 			propResidue:setString(_string_piece_info[69] .. (self.times) .. _string_piece_info[70])
	-- 		else
	-- 			propResidue:setString(_string_piece_info[160] .. (self.times) .. _string_piece_info[70])
	-- 		end
	-- 	end
	-- end


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
			if self.shop_type ~= 1 then
				label1:setString(_string_piece_info[69] .. (self.times) .. _string_piece_info[70])
			else
				label1:setString(_string_piece_info[160] .. (self.times) .. _string_piece_info[70])
			end
		end
	end
	
	
	propResidue:removeAllChildren(true)
    propResidue:addChild(label1)
    -- label1:setPosition( cc.p(s.width/2, s.height/5 * 1.5) )
    label1:setAnchorPoint( cc.p(0.5, 0.5) )
	
	if self.current_type == 1 then
		if self.shop_type == 1 then
			local propQuality = zstring.tonumber(self.prop.prop_quality) + 1
			propName:setString(self.prop.mould_name)
			propDescribe:setString(self.prop.mould_remarks)
			propName:setColor(cc.c3b(color_Type[propQuality][1], color_Type[propQuality][2], color_Type[propQuality][3]))
			goldNumber:setString(self:drawPrice(self.prop))
			ccui.Helper:seekWidgetByName(root, "Panel_xianzai"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Panel_zhekou"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_222"):setString(self.prop.sale_price)
			ccui.Helper:seekWidgetByName(root, "Text_333"):setString(self.prop.original_cost)
			local iconCell = PropIconNewCell:createCell()
			iconCell:init(iconCell.enum_type._SHOW_VIP_GIFT_INFO, self.prop)
			headPanel:addChild(iconCell)

			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
				fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_3"), nil, 
				{
					terminal_name = "prop_head_vip_gift", 
					terminal_state = 0, 
					_prop = self.prop
				}, 
				nil, 0)
			end
		else
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

		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_3"), nil, 
			{
				terminal_name = "equip_icon_cell_change_shop_buy_new", terminal_state = 0, _equip = self.prop
			}, 
			nil, 0)
		end
	end
	--> print(self.prop.VIP_can_buy,"-------------------------------")
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
		{
			terminal_name = "shop_prop_buy_list_buy", 
			terminal_state = 0, 
			_prop = self.prop,
			_type = self.current_type,
			_limit = zstring.tonumber(self.prop.VIP_buy_times),
			_canBuy = zstring.tonumber(self.prop.VIP_can_buy),
			_buyTimes = zstring.tonumber(self.prop.buy_times),
			_shopType = self.shop_type,
			_instance = self,
			_current_buy_count = 0,
			isPressedActionEnabled = true
		}, 
		nil, 0)
end

-- function shopPropBuyListCell:initDraw()
-- 	local root = self.roots[1]

-- 	-- -- 列表控件动画播放
-- 	-- local action = csb.createTimeline("list/list_daoju_1.csb")
--  --    root:runAction(action)
--  --    action:play("list_view_cell_open", false)
	
-- 	-- local panel = ccui.Helper:seekWidgetByName(root, "Panel_5")
-- 	-- local panel_size = panel:getContentSize()
-- 	self:onUpdateDraw()
-- 	-- self:setContentSize(panel_size)
-- end

function shopPropBuyListCell:onEnterTransitionFinish()

end

function shopPropBuyListCell.onImageLoaded(texture)
	
end

function shopPropBuyListCell:onArmatureDataLoad(percent)
	
end

function shopPropBuyListCell:onArmatureDataLoadEx(percent)
	-- if percent >= 1 then
	-- 	if self._load_over == false then
	-- 		self._load_over = true
	-- 		self:onInit()
	-- 	end
	-- end
end

function shopPropBuyListCell:onLoad()
	local csbItem = nil
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		if self.shop_type == 1 then
			csbItem = csb.createNode("list/list_libao.csb")
		else
			csbItem = csb.createNode("list/list_daoju_1.csb")
		end
	else
		csbItem = csb.createNode("list/list_daoju_1.csb")
	end
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
	
	-- 列表控件动画播放
	local action = nil
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		if __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
			if self.shop_type == 1 then
				action = csb.createTimeline("list/list_libao.csb")
			else
				action = csb.createTimeline("list/list_daoju_1.csb")
			end
			
		else
			action = csb.createTimeline("list/list_daoju_1.csb")
		end
		root:runAction(action)
		table.insert(self.actions, action)
	end
	-- action:play("list_view_cell_open", false)
	
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_5")
	local panel_size = panel:getContentSize()
	self:onUpdateDraw()
	self:setContentSize(panel_size)

	self:setVisible(false)

	-- local effect_paths = {
	-- 	"images/ui/effice/effect_22/effect_22.ExportJson",
	-- 	"images/ui/effice/effect_26/effect_26.ExportJson"
	-- }
	-- for i, v in pairs(effect_paths) do
	-- 	local fileName = v
	-- 	ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(fileName, self.onArmatureDataLoad, self.onArmatureDataLoadEx, self)
	-- end

	self:onInit()
	-- -- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onInit, self, false)
end

function shopPropBuyListCell:onInit()
	-- local csbItem = csb.createNode("list/list_daoju_1.csb")
	-- local root = csbItem:getChildByName("root")
	-- root:removeFromParent(false)
	-- self:addChild(root)
	-- table.insert(self.roots, root)

	-- -- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
	
	local root = self.roots[1]
	-- 列表控件动画播放
	-- local action = csb.createTimeline("list/list_daoju_1.csb")
	-- root:runAction(action)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		local action = self.actions[1]
		action:play("list_view_cell_open", false)
	end

	self:setVisible(true)
	
	-- local panel = ccui.Helper:seekWidgetByName(root, "Panel_5")
	-- local panel_size = panel:getContentSize()
	-- self:onUpdateDraw()
	-- self:setContentSize(panel_size)

	-- self:onUpdateDraw()
	-- self:initDrawTipMessage()
end

function shopPropBuyListCell:onExit()
	-- state_machine.remove("shop_prop_buy_list_buy")
	-- state_machine.remove("shop_prop_buy_list_refush")
end

function shopPropBuyListCell:init(prop, interfaceType,types)
	self.prop = prop
	self.current_type = interfaceType
	self.shop_type = types

	self._load_over = false
	self:onLoad()
	return self
end

function shopPropBuyListCell:createCell()
	local cell = shopPropBuyListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function shopPropBuyListCell:drawPrice(_prop)
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

