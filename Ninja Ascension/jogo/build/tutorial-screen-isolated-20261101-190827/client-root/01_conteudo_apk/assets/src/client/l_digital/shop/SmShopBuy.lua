-- ----------------------------------------------------------------------------------------------------
-- 说明：sm商城道具购买界面
-------------------------------------------------------------------------------------------------------

SmShopBuy = class("SmShopBuyClass", Window)

local sm_shop_buy_open_terminal = {
    _name = "sm_shop_buy_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local SmShopBuyWindow = fwin:find("SmShopBuyClass")
    	if SmShopBuyWindow ~= nil then
    		fwin:close(SmShopBuyWindow)
    	end
    	local page = SmShopBuy:new():init(params)
    	fwin:open(page , fwin._ui)
		return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(sm_shop_buy_open_terminal)
state_machine.init()

function SmShopBuy:ctor()
    self.super:ctor()
	self.roots = {}
	self.prop = nil
	self.cell = nil
	local function init_sm_shop_buy_terminal()
		local sm_shop_buy_confirm_buy_terminal = {
            _name = "sm_shop_buy_confirm_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = instance.cell
            	local all_money = 0
            	local tip = ""
            	if cell.page == 2 
            		or cell.page == 6
            		then
            		if tonumber(instance.prop.sell_type) == 1 then
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
            	else

            	end
            	if tonumber(all_money) < tonumber(instance.prop.sale_percentage) then
            		if cell.page ~= 2 then
	            		TipDlg.drawTextDailog(string.format( _new_interface_text[93] , tip))
	            		return
	            	else
	            		if tonumber(instance.prop.sell_type) == 1 then
	            			TipDlg.drawTextDailog(_string_piece_info[74])
	            		else
	            			-- state_machine.excute("shortcut_function_silver_to_get_open",0,"shortcut_function_silver_to_get_open.")
	            		end
	            	end
            	end
            	local index = instance.index
            	local function responseBuyPropCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- 杂货，演武，试炼，组织商店购买成功提示
						if cell.page == 2 or cell.page == 3 or cell.page == 4 or cell.page == 5 then
							TipDlg.drawTextDailog(_new_interface_text[92])
						end
						-- `cell` e `index` locales: si la ventana ya se cerro, instance.cell es nil.
						if cell.page == 2 then
							_ED.secret_shop_init_info.goods_info[tonumber(index)].remain_times = tonumber(_ED.secret_shop_init_info.goods_info[tonumber(index)].remain_times)-1
						elseif cell.page == 3 then
							-- 演武商店购买商品，服务器会直接刷新商店信息，客户端不需要+1，服务器返回协议 parse_update_the_store_for_the_arena 376
							-- _ED.arena_good[tonumber(instance.index)].exchange_times = tonumber(_ED.arena_good[tonumber(instance.index)].exchange_times) + 1
						elseif cell.page == 4 then
							_ED.glories_shop_info[tonumber(index)].goods_exchange_times = tonumber(_ED.glories_shop_info[tonumber(index)].goods_exchange_times) + 1
						elseif cell.page == 6 then
							app.load("client.reward.DrawRareReward")
	                        local getRewardWnd = DrawRareReward:new()
	                        getRewardWnd:init(11)
	                        fwin:open(getRewardWnd, fwin._ui)
						else
							-- 组织商店购买商品，服务器会直接刷新商店信息，客户端不需要+1，服务器返回协议 parse_union_treasure_init   249   已修改为1007
							-- _ED.union.union_shop_info.treasure.goods_info[tonumber(instance.index)].remain_times = tonumber(_ED.union.union_shop_info.treasure.goods_info[tonumber(instance.index)].remain_times) + 1
						end

						state_machine.excute("sm_shop_tab_update", 0, "sm_shop_tab_update.")

						if nil ~= fwin:find("ShopPropBuyListViewClass") then
							state_machine.excute("sm_shop_prop_buy_list_refush", 0, cell)
						end

						if nil ~= fwin:find("SecretShopClass") then
							state_machine.excute("sm_secret_shop_prop_buy_list_refush", 0, cell)
						end

						if response.node ~= nil then
							fwin:close(instance)
						end
					end
				end
				if cell.page == 2 then
					protocol_command.secret_shop_exchange.param_list = ""..(instance.index - 1)
                	NetworkManager:register(protocol_command.secret_shop_exchange.code, nil, nil, nil, instance, responseBuyPropCallback, false, nil)
                elseif cell.page == 3 then
                	protocol_command.arena_shop_exchange.param_list = ""..instance.index.."\r\n".."1"
					NetworkManager:register(protocol_command.arena_shop_exchange.code, nil, nil, nil, instance, responseBuyPropCallback, false, nil)
                elseif cell.page == 4 then
                	protocol_command.glories_shop_exchange.param_list = ""..instance.index.."\r\n".."1"
					NetworkManager:register(protocol_command.glories_shop_exchange.code, nil, nil, nil, instance, responseBuyPropCallback, false, nil)
				elseif cell.page == 5 then
	            	protocol_command.union_shop_exchange.param_list = ""..(instance.index - 1).."\r\n".."2".."\r\n".."1"
					NetworkManager:register(protocol_command.union_shop_exchange.code, nil, nil, nil, instance, responseBuyPropCallback, false, nil)
				elseif cell.page == 6 then
	            	protocol_command.mystical_shop_buy.param_list = ""..(instance.index - 1).."\r\n".."1"
					NetworkManager:register(protocol_command.mystical_shop_buy.code, nil, nil, nil, cell, responseBuyPropCallback, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--
		local sm_shop_buy_close_terminal = {
            _name = "sm_shop_buy_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(sm_shop_buy_confirm_buy_terminal)
		state_machine.add(sm_shop_buy_close_terminal)
        state_machine.init()
	end
	init_sm_shop_buy_terminal()
end

function SmShopBuy:onUpdateDraw()
	local root = self.roots[1]
	local Panel_packs_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_packs_props_icon")
	local image_gem = ccui.Helper:seekWidgetByName(root, "image_gem")
	Panel_packs_props_icon:removeAllChildren(true)
	local cell = ResourcesIconCell:createCell()
	if tonumber(self.prop.type) == 7 then
		local quality = tonumber(self.prop.prop_quality)
		cell:init(tonumber(self.prop.type),0,tonumber(self.prop.mould_id),nil,nil,nil,nil,nil,{equipQuality = quality})
	else
		cell:init(tonumber(self.prop.type),0,tonumber(self.prop.mould_id))
	end
	Panel_packs_props_icon:addChild(cell)
	--名称
	local Text_packs_props_name = ccui.Helper:seekWidgetByName(root, "Text_packs_props_name")
	Text_packs_props_name:setString(self.prop.mould_name)
	--描述
	local Text_props_info = ccui.Helper:seekWidgetByName(root, "Text_props_info")
	Text_props_info:setString(self.prop.mould_remarks)
	if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		Text_props_info:setColor(cc.c3b(71,71,71))
	end
	--购买数量
	local Text_buy_n = ccui.Helper:seekWidgetByName(root, "Text_buy_n")
	Text_buy_n:removeAllChildren(true)
	Text_buy_n:setString("")

	local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)

    local richTextWidth = Text_buy_n:getContentSize().width
    if richTextWidth == 0 then
        richTextWidth = Text_buy_n:getFontSize() * 6
    end
			    
    _richText2:setContentSize(cc.size(richTextWidth, 0))
    _richText2:setAnchorPoint(cc.p(0, 0))
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    	_richText2:setColor(cc.c3b(71,71,71))
    end

    local char_str = string.gsub(_new_interface_text[80], "!x@", self.prop.number)
    local rt, count, text = draw.richTextCollectionMethod(_richText2, 
    char_str, 
    cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),
    cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]),
    0, 
    0, 
    Text_buy_n:getFontName(), 
    Text_buy_n:getFontSize(),
    chat_rich_text_color)
    _richText2:setPositionX(-30)
    local rsize = _richText2:getContentSize()
    _richText2:setPositionY(Text_buy_n:getContentSize().height - 3)
    Text_buy_n:addChild(_richText2)

	--价格
	local Text_price_n = ccui.Helper:seekWidgetByName(root, "Text_price_n")
	Text_price_n:setString(self.prop.sale_percentage)

	--拥有数量
	local Text_have_n = ccui.Helper:seekWidgetByName(root, "Text_have_n")
	local haveNumber = 0
	if tonumber(self.prop.type) == 7 then
		for i, v in pairs(_ED.user_equiment) do
			if v.user_equiment_template == ""..self.prop.mould_id then 
				haveNumber = haveNumber + 1
			end
		end
	else
		haveNumber = getPropAllCountByMouldId(tonumber(self.prop.mould_id))
	end
	Text_have_n:setString(haveNumber)
	-- Text_have_n:removeAllChildren(true)
	-- local _richText = ccui.RichText:create()
 --    _richText:ignoreContentAdaptWithSize(false)       
 --     local re1 = ccui.RichElementText:create(1, cc.c3b(255,255,255),255, haveNumber, Text_have_n:getFontName(),Text_have_n:getFontSize())
 --    if __lua_project_id == __lua_project_l_pokemon then
 --    	re1 = ccui.RichElementText:create(1, cc.c3b(71,71,71),255, haveNumber, Text_have_n:getFontName(),Text_have_n:getFontSize())
 --    end
 --    _richText:pushBackElement(re1)  
 --     local re2 = ccui.RichElementText:create(1, cc.c3b(225,182,0),255, _new_interface_text[97], Text_have_n:getFontName(),Text_have_n:getFontSize())
 --    if __lua_project_id == __lua_project_l_pokemon then
 --    	re2 = ccui.RichElementText:create(1, cc.c3b(71,71,71),255, _new_interface_text[97], Text_have_n:getFontName(),Text_have_n:getFontSize())
 --    end
 --    _richText:pushBackElement(re2)
 --    _richText:setPosition(cc.p(Text_have_n:getContentSize().width / 2,Text_have_n:getContentSize().height/2 + 3))
 --    _richText:setContentSize(cc.size(Text_have_n:getContentSize().width,18))
 --    Text_have_n:addChild(_richText)

	local cost_image = {
		ccui.Helper:seekWidgetByName(root, "image_gem_3"),		--宝石
		ccui.Helper:seekWidgetByName(root, "image_money_3"),	--银币
		ccui.Helper:seekWidgetByName(root, "image_jjb_3"),		--竞技币
		ccui.Helper:seekWidgetByName(root, "image_slb_3"),		--试炼币
		ccui.Helper:seekWidgetByName(root, "image_ghb_3"),		--公会币
	}
	for i , v in pairs(cost_image) do
		cost_image[i]:setVisible(false)
	end
	if self.cell.page == 2 then
		if self.prop.sell_type == 1 then
			cost_image[1]:setVisible(true)
		else
			cost_image[2]:setVisible(true)
		end
	elseif self.cell.page == 6 then
		cost_image[self.prop.sell_type]:setVisible(true)
	else
		cost_image[self.cell.page]:setVisible(true)
	end
end

function SmShopBuy:onInit()
	local csbSmShopBuy = csb.createNode("shop/sm_shop_purchase_window.csb")
	local root = csbSmShopBuy:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
    self:addChild(csbSmShopBuy)

    local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
    Image_1:setTouchEnabled(true)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sell"), nil, 
	{
		terminal_name = "sm_shop_buy_confirm_buy", 
		terminal_state = 0, 
		_cell = self,
	}, 
	nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
	{
		terminal_name = "sm_shop_buy_close", 
		terminal_state = 0, 
		_cell = self,
	}, 
	nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, 
	{
		terminal_name = "sm_shop_buy_close", 
		terminal_state = 0, 
		_cell = self,
	}, 
	nil, 0)
	
	self:onUpdateDraw()
end

function SmShopBuy:init(params)
	self.prop = params[1]
	self.cell = params[2]
	self.index = params[3]
	self.call_terminal_name = params[4]
	self:onInit()
	return self
end

function SmShopBuy:onExit()
	state_machine.remove("sm_shop_buy_confirm_buy")
	state_machine.remove("sm_shop_buy_close")
end

