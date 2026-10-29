--------------------------------------------------------------------------------------------------------------
--  说明：军团商店限时列表
--------------------------------------------------------------------------------------------------------------
UnionShopTimeLimitListCell = class("UnionShopTimeLimitListCellClass", Window)
UnionShopTimeLimitListCell.__size = nil

function UnionShopTimeLimitListCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.param = nil 
    self.index = 0
	self.typeIndex = 2
	self.needgolds=0
	self.propName = " "
	 -- Initialize union join list cell state machine.
    local function init_union_shop_time_limit_list_cell_terminal()
		--点击购买
        local union_shop_time_limit_list_cell_to_buy_terminal = {
            _name = "union_shop_time_limit_list_cell_to_buy",
            _init = function (terminal)
              
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local mCell = params._datas._cell
				if mCell.needgolds > tonumber(_ED.user_info.user_gold) then
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
                if TipDlg.drawStorageTipo() == false then
                	mCell:quxSureTip(mCell.needgolds,mCell.propName)
					-- local index = params._datas._index
					-- local typeIndex = params._datas._typeIndex
				
					-- local _replyPhysical = params._datas.replyPhysical
					-- local function responseUnionShopExchangeCallback(response)
					-- 	if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					-- 		mCell:rewadDraw(index)
					-- 	end
					-- end
					
					-- protocol_command.union_shop_exchange.param_list = ""..(index - 1).."\r\n"..typeIndex.."\r\n".."1"
					
					-- NetworkManager:register(protocol_command.union_shop_exchange.code, nil, nil, nil, mCell, responseUnionShopExchangeCallback, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新界面
        local union_shop_time_limit_list_cell_refresh_info_terminal = {
            _name = "union_shop_time_limit_list_cell_refresh_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(union_shop_time_limit_list_cell_to_buy_terminal)
		state_machine.add(union_shop_time_limit_list_cell_refresh_info_terminal)
		
        state_machine.init()
    end
    -- call func init union join list cell state machine.
    init_union_shop_time_limit_list_cell_terminal()

end

function UnionShopTimeLimitListCell:quxSureTipCallBack( n )
    if n ~= 0 then
        return
    end
	local index = self.index
	local typeIndex =  self.typeIndex
	local has = zstring.tonumber(_ED.union.user_union_info.rest_contribution)
	-- local _replyPhysical = params._datas.replyPhysical
	local function responseUnionShopExchangeCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if (__lua_project_id == __lua_project_warship_girl_a 
				or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and __game_data_record_open == true
		  		then 
		  		local num = has - zstring.tonumber(_ED.union.user_union_info.rest_contribution)
		  		if num > 0 then
		  			jttd.consumableItems(_All_tip_string_info._union_exploit,num)
		  		end
		  	end
			response.node:rewadDraw(response.node.index)
		end
	end
	protocol_command.union_shop_exchange.param_list = ""..(index - 1).."\r\n"..typeIndex.."\r\n".."1"
	
	NetworkManager:register(protocol_command.union_shop_exchange.code, nil, nil, nil, self, responseUnionShopExchangeCallback, false, nil)
end
function UnionShopTimeLimitListCell:quxSureTip(stra,strb)
	app.load("client.utils.ConfirmTip")
	local tip = ConfirmTip:new() 
	local str =string.format(tipStringInfo_union_str[50], stra, strb)
    tip:init(self, self.quxSureTipCallBack, str)
    fwin:open(tip,fwin._ui)
end

function UnionShopTimeLimitListCell:rewadDraw(_index)
	local root = self.roots[1]
	if root == nil then
		return
	end	
	local getRewardWnd = DrawRareReward:new()
	getRewardWnd:init(54)
	fwin:open(getRewardWnd,fwin._ui)

	local buybut = ccui.Helper:seekWidgetByName(root, "Button_53")
	local buybutcount = ccui.Helper:seekWidgetByName(root, "Text_54")

	local sum = tonumber(_ED.union.union_shop_info.treasure.goods_info[_index].remain_times)-- 已兑换次数
	local reward = dms.element(dms["union_shop_library"], self.param.goods_id)
	local canbuycount = dms.atoi(reward, union_shop_library.can_buy_count)
	-- local cou =  zstring.tonumber(dms.string(dms["union_shop_library"], self.mid, union_shop_mould.sell_can_times))
	if sum >= canbuycount then
		buybutcount:setString(tipStringInfo_union_str[17])
		buybut:setBright(false)
		buybut:setTouchEnabled(false)
	else
		buybut:setBright(true)
		buybut:setTouchEnabled(true)
		-- buybutcount:setString("可购买"..(canbuycount-sum).."次")
		buybutcount:setString(string.format(tipStringInfo_union_str[19],canbuycount-sum))
	end
	 local unionhas = ccui.Helper:seekWidgetByName(root, "Text_53") -- 军团剩余
	local unionhasnum = dms.atoi(reward, union_shop_library.union_has)
	local unionremaintimes = tonumber(_ED.union.union_shop_info.treasure.goods_info[_index].union_remain_times)-- 已兑换次数
	if unionremaintimes >= unionhasnum then
		-- unionhas:setString("军团剩余".."0")
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			local strs = string.format(tipStringInfo_union_str[20],0)
			unionhas:setString(strs)
		else
			unionhas:setString(tipStringInfo_union_str[20].."0")
		end
	else
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			local strs = string.format(tipStringInfo_union_str[20],unionhasnum-unionremaintimes)
			unionhas:setString(strs)
		else		
			unionhas:setString(tipStringInfo_union_str[20]..(unionhasnum-unionremaintimes))
		end
	end
end

function UnionShopTimeLimitListCell:updateDraw()
    local root = self.roots[1]
    if root == nil then
        return
    end

    local iconPanel = ccui.Helper:seekWidgetByName(root, "Panel_10")

    local propname = ccui.Helper:seekWidgetByName(root, "Text_52")
    local needgoods = ccui.Helper:seekWidgetByName(root, "Text_53_0")
    local unionhas = ccui.Helper:seekWidgetByName(root, "Text_53") -- 军团剩余
    local buybut = ccui.Helper:seekWidgetByName(root, "Button_53") -- goumai  union_hasText_4_0_yj
    local buybutcount = ccui.Helper:seekWidgetByName(root, "Text_54") -- 
    local suip = ccui.Helper:seekWidgetByName(root, "Text_4_0_0_0") -- 拥有碎片
    local yuanjia = ccui.Helper:seekWidgetByName(root, "Text_4_0_yj")
    local reward = dms.element(dms["union_shop_library"], self.param.goods_id)
    local shoptype = dms.atoi(reward, union_shop_library.shop_type)
    local count = dms.atoi(reward, union_shop_library.sell_one_count)

    propname:setString("")
    needgoods:setString("")
    unionhas:setString("")
    buybutcount:setString("")

    local mouldId = dms.atoi(reward, union_shop_library.mould_id)
    local faceprice = dms.atoi(reward, union_shop_library.face_price)
    local unionhasnum = dms.atoi(reward, union_shop_library.union_has)
    local canbuycount = dms.atoi(reward, union_shop_library.can_buy_count)  -- 可购买次数
    local brokennumber = dms.atos(reward, union_shop_library.broken_number) -- 折扣
	local sum = tonumber(self.param.remain_times)
	local unionremaintimes = tonumber(self.param.union_remain_times)
    needgoods:setString(faceprice)
    yuanjia:setString(dms.atoi(reward, union_shop_library.cost_price))
	self.needgolds = faceprice
	ccui.Helper:seekWidgetByName(root, "Text_4_zekou"):setString(brokennumber) -- 折扣
	if unionremaintimes >= unionhasnum then
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			local strs = string.format(tipStringInfo_union_str[20],0)
			unionhas:setString(strs)
		else
			unionhas:setString(tipStringInfo_union_str[20].."0")
		end
	else
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			local strs = string.format(tipStringInfo_union_str[20],unionhasnum-unionremaintimes)
			unionhas:setString(strs)
		else		
			unionhas:setString(tipStringInfo_union_str[20]..(unionhasnum-unionremaintimes))
		end
	end
	
	if sum >= canbuycount then
		buybutcount:setString(tipStringInfo_union_str[17])
		buybut:setBright(false)
		buybut:setTouchEnabled(false)
	else
		-- buybutcount:setString("可购买"..(canbuycount-sum))
		buybutcount:setString(string.format(tipStringInfo_union_str[19],canbuycount-sum))
		buybut:setBright(true)
		buybut:setTouchEnabled(true)
	end
	
	
	iconPanel:removeAllChildren(true)
    if shoptype == -1 then  -- 1 银币 2金币
        if mouldId == 1 then
            local cell = propMoneyIcon:createCell()
            cell:init("1",count,nil)
            iconPanel:addChild(cell)
            propname:setString(_All_tip_string_info._fundName)
            self.propName = _All_tip_string_info._fundName
			local colortype= 4
			propname:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
        elseif mouldId == 2 then
            local cell = propMoneyIcon:createCell()
            cell:init("2",count,nil)
            iconPanel:addChild(cell)
            propname:setString(_All_tip_string_info._crystalName)
            self.propName  = _All_tip_string_info._crystalName
			local colortype=4
			propname:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
        end
    elseif shoptype == 0 then  --道具
        local cell = self:getItemCell(mouldId,nil,count)
        iconPanel:addChild(cell)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        	propname:setString(setThePropsIcon(mouldId)[2])
        else
        	propname:setString(dms.string(dms["prop_mould"], mouldId, prop_mould.prop_name))
        end
        self.propName  = dms.string(dms["prop_mould"], mouldId, prop_mould.prop_name)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        self.propName = setThePropsIcon(mouldId)[2]
	    end
        local colortype = dms.string(dms["prop_mould"],mouldId,prop_mould.prop_quality)
        propname:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
    elseif shoptype == 1 then -- wujiang
        local cell = ShipHeadCell:createCell()
        cell:init(nil, cell.enum_type._DUPLICATE, mouldId, count, false)
        iconPanel:addChild(cell)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], mouldId, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			-- local ship_evo = zstring.split(hero.evolution_status, "|")
			local evo_mould_id = evo_info[dms.int(dms["ship_mould"], mouldId, ship_mould.captain_name)]
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			_name = word_info[3]
			propname:setString(_name)
		else
	        propname:setString(dms.string(dms["ship_mould"], mouldId, ship_mould.captain_name))
	    end
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], mouldId, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			-- local ship_evo = zstring.split(hero.evolution_status, "|")
			local evo_mould_id = evo_info[dms.int(dms["ship_mould"], mouldId, ship_mould.captain_name)]
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			self.propName = word_info[3]
		else
	        self.propName = dms.string(dms["ship_mould"], mouldId, ship_mould.captain_name)
	    end
        local colortype = dms.string(dms["ship_mould"],mouldId,ship_mould.ship_type)
        propname:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
    elseif shoptype == 2 then -- 装备
        local cell = EquipIconCell:createCell()
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        	cell:init(10, nil, mouldId, nil, nil, count)
        else
        	cell:init(10, nil, mouldId, nil, false, count)
        end
        iconPanel:addChild(cell)
        propname:setString(dms.string(dms["equipment_mould"], mouldId, equipment_mould.equipment_name))
        self.propName = dms.string(dms["equipment_mould"], mouldId, equipment_mould.equipment_name)
        local colortype = dms.string(dms["equipment_mould"],mouldId,ship_mould.ship_type)
		propname:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
    end
end
--道具
function UnionShopTimeLimitListCell:getItemCell(mid,mtype,count,isCertainly)
    app.load("client.cells.prop.model_prop_icon_cell")
    local cell = ModelPropIconCell:createCell()
    local cellConfig = cell:createConfig()
    cellConfig.mouldId = mid
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        cellConfig.isShowName = false
    else
        cellConfig.isShowName = false
    end
    cellConfig.isDebris = true
    cellConfig.mouldType = mtype
    cellConfig.touchShowType = 1
    cellConfig.count = count
    cellConfig.isCertainly = isCertainly
    cell:init(cellConfig)
    return cell
end

function UnionShopTimeLimitListCell:onInit()
    local root = cacher.createUIRef("legion/legion_shop_list_1.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

	if UnionShopTimeLimitListCell.__size == nil then
		UnionShopTimeLimitListCell.__size = root:getChildByName("Panel_9"):getContentSize()
    end 
	self:updateDraw()
	
	-- 购买
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_53"), nil, 
		{
			terminal_name = "union_shop_time_limit_list_cell_to_buy", 
			terminal_state = 0, 
			_index = self.index,
			_cell = self,		
			_typeIndex = self.typeIndex,	
			isPressedActionEnabled = true
		},
		nil,0)
end

function UnionShopTimeLimitListCell:onEnterTransitionFinish()

end

function UnionShopTimeLimitListCell:init(param,index,typeIndex)
    self.param = param 
    self.index = index
	self.typeIndex = typeIndex
    if self.index < 5 then
        self:onInit()
    end
    self:setContentSize(UnionShopTimeLimitListCell.__size)
	return self
end

function UnionShopTimeLimitListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionShopTimeLimitListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    cacher.freeRef("legion/legion_shop_list_1.csb", root)
    self.roots = {}
end
function UnionShopTimeLimitListCell:onExit()
    cacher.freeRef("legion/legion_shop_list_1.csb", self.roots[1])
end

function UnionShopTimeLimitListCell:createCell()
	local cell = UnionShopTimeLimitListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
