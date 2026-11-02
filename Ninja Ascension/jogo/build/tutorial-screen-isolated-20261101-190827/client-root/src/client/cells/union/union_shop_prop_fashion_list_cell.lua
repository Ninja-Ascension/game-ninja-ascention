--------------------------------------------------------------------------------------------------------------
--  说明：军团商店列表（道具，时装，奖励）
--------------------------------------------------------------------------------------------------------------
UnionShopPropFashionListCell = class("UnionShopPropFashionListCellClass", Window)
UnionShopPropFashionListCell.__size = nil
function UnionShopPropFashionListCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.pagetype = 0
	self.typeIndex = 0
	self.param = nil 
	self.index = 0
	self.mouldid = 0
	self.need = 0
	self.mydata = nil

	self.needgolds=0
	self.propName = " "

	self.canBuyType = 0  -- 购买按钮状态
	app.load("client.cells.prop.prop_money_icon")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")
	-- app.load("client.campaign.worldboss.WorldBossShopBuyNumber")
	 -- Initialize union shop prop fashion list cell state machine.
    local function init_union_shop_prop_fashion_list_cell_terminal()
		--点击购买
        local union_shop_prop_fashion_list_cell_to_buy_terminal = {
            _name = "union_shop_prop_fashion_list_cell_to_buy",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local mCell = params._datas._cell

				if mCell.pagetype == 1 then
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
						return true
					end	
					if mCell.need ~= nil and zstring.tonumber(mCell.need) > 0 then
						local stra = mCell.need.._my_gane_name[13]..","..mCell.needgolds
						mCell:quxSureTip(stra,mCell.propName)
					else
						mCell:quxSureTip(mCell.needgolds,mCell.propName)
					end
				else
	                if TipDlg.drawStorageTipo() == false then
						mCell:onBuy(params)
					end
				end
				-- if tonumber(_ED.union.user_union_info.rest_contribution) < mCell.need then
				-- 	TipDlg.drawTextDailog(tipStringInfo_union_str[36])
				-- 	return
				-- end
				
					-- local index = params._datas._index
					-- local mid = params._datas._mid
					-- local typeIndex = params._datas._typeIndex
					
					-- local _replyPhysical = params._datas.replyPhysical
					-- local function responseGetServerListCallback(response)
					-- 	if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					-- 		mCell:rewadDraw(index)
					-- 	end
					-- end
					
					-- protocol_command.union_shop_exchange.param_list = ""..mid.."\r\n"..typeIndex
					
					-- NetworkManager:register(protocol_command.union_shop_exchange.code, nil, nil, nil, mCell, responseGetServerListCallback, false, nil)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新界面
        local union_shop_prop_fashion_list_cell_refresh_info_terminal = {
            _name = "union_shop_prop_fashion_list_cell_refresh_info",
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
		state_machine.add(union_shop_prop_fashion_list_cell_to_buy_terminal)
		state_machine.add(union_shop_prop_fashion_list_cell_refresh_info_terminal)
        state_machine.init()
    end
    -- call func init  union shop prop fashion list cell state machine.
    init_union_shop_prop_fashion_list_cell_terminal()

end

function UnionShopPropFashionListCell:quxSureTipCallBack( n )
    if n ~= 0 then
        return
    end
	local index = self.index
	local mid = self.mouldid
	local typeIndex = self.typeIndex
	local has = zstring.tonumber(_ED.union.user_union_info.rest_contribution)
	-- local _replyPhysical = params._datas.replyPhysical
	local function responseUnionShopExchangeCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.roots[1] ~= nil then
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
	end

	protocol_command.union_shop_exchange.param_list = ""..mid.."\r\n"..typeIndex.."\r\n".."1"
	
	NetworkManager:register(protocol_command.union_shop_exchange.code, nil, nil, nil, self, responseUnionShopExchangeCallback, false, nil)
end
function UnionShopPropFashionListCell:quxSureTip(stra,strb)
	app.load("client.utils.ConfirmTip")
	local tip = ConfirmTip:new() 
	local str =string.format(tipStringInfo_union_str[50], stra, strb)
    tip:init(self, self.quxSureTipCallBack, str)
    fwin:open(tip,fwin._ui)
end



function UnionShopPropFashionListCell:onBuy(params)

	-- return{	--此处的是个范类型对象,可以是以上类型的任何一个
	-- 	quality = nil,
	-- 	count = nil, --显示一打商品所包含的数量 如x10
	-- 	mid = nil,--物品的模板id
	-- 	gtype = nil,--物品类型,
	-- 	price = nil,--单价x货币,诸如威望啊金币啊xxxxx
	-- 	money = nil,--当前用户持有的x货币的数量
	-- 	name = nil,	--物品名
	-- 	existingDebris = nil, --碎片
	-- 	maxBuyNum = nil, --当前最大可购买次数
	-- 	indexId = nil,--位于本地表中的索引id
	-- 	redDebrisNum = nil, -- 红装碎片需求兑换数
	-- 	redDebrisMID = nil, -- 红装碎片的模板id
	-- 	cell = nil,
	-- 	originType = nil, --调用的来源,区别显示类型
	-- }
	local config = {
			mid 	= self.mid,
			mouldid =self.mouldid,
			typeIndex = self.typeIndex,
			count 	= self.count,
			gtype 	= self.gtype,
			quality = self.quality,
			name 	= self.name,
			existingDebris = self.existingDebris,
			price 	= self.price,
			money 	= zstring.tonumber(tonumber(_ED.union.user_union_info.rest_contribution)),
			maxBuyNum = zstring.tonumber(self.maxBuyNum),
			indexId = self.indexId,
			redDebrisNum = zstring.tonumber(self.redDebrisNum),
			redDebrisMID = zstring.tonumber(self.redDebrisMID),
			_target = params._datas._cell, --用于刷新该条数据
			originType = 2
		}
	params._datas.config = config
	app.load("client.campaign.worldboss.WorldBossShopBuyNumber")
	local ntip = WorldBossShopBuyNumber:createCell()
	ntip:init(params._datas.config)
	fwin:open(ntip, fwin._windows)

end	


function UnionShopPropFashionListCell:rewadDraw(_index)
	local root = self.roots[1]
	if root == nil then
		return
	end	
	local getRewardWnd = DrawRareReward:new()
	getRewardWnd:init(54)
	fwin:open(getRewardWnd,fwin._ui)

	local buybut = ccui.Helper:seekWidgetByName(root, "Button_235")
	local buybutcount = ccui.Helper:seekWidgetByName(root, "Text_17")

	local sumdata = zstring.split(_ED.union.union_shop_info.prop.goods_count, ",")  -- 已兑换次数
	local sum = zstring.tonumber(sumdata[self.mouldid])  
	local cou =  zstring.tonumber(dms.string(dms["union_shop_mould"], self.mouldid, union_shop_mould.sell_can_times))
	if sum >= cou then
		buybutcount:setString(tipStringInfo_union_str[17])
		buybut:setBright(false)
		buybut:setTouchEnabled(false)
	else
		if self.pagetype == 0 then
			-- buybutcount:setString("今日可买"..(cou-sum).."次")
			buybutcount:setString(string.format(tipStringInfo_union_str[19],cou-sum))
		elseif self.pagetype == 2 or self.pagetype == 1 then
			-- buybutcount:setString("可购买"..(cou-sum).."次")
			buybutcount:setString(string.format(tipStringInfo_union_str[19],cou-sum))
		end
		self.maxBuyNum = cou-sum
	end
end



function UnionShopPropFashionListCell:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end	
	if _ED.union.union_info == nil then
		return
	end
	local iconPanel = ccui.Helper:seekWidgetByName(root, "Panel_17")
	local propname = ccui.Helper:seekWidgetByName(root, "Text_46")
	local contribution = ccui.Helper:seekWidgetByName(root, "Text_47")
	local zhuanshi = ccui.Helper:seekWidgetByName(root, "Panel_38") -- zhuanshi
	local buybut = ccui.Helper:seekWidgetByName(root, "Button_235") -- goumai
	local buybutcount = ccui.Helper:seekWidgetByName(root, "Text_17") -- goumai
	zhuanshi:setVisible(false)
	propname:setString("")
	contribution:setString("")
	buybutcount:setString("")

	local reward = self.param 
	local shoptype = dms.atoi(reward, union_shop_mould.shop_type)
	local mouldId = dms.atoi(reward, union_shop_mould.mould_id)
	local count = dms.atoi(reward, union_shop_mould.sell_one_count)
	local sumdata = zstring.split(_ED.union.union_shop_info.prop.goods_count, ",")  -- 已兑换次数
	local sum = zstring.tonumber(sumdata[self.mouldid])
	
	local sellcantimes = dms.atoi(reward, union_shop_mould.sell_can_times)          --购买限制次数
	local needcontribution = dms.atoi(reward, union_shop_mould.need_contribution)         --所需军团贡献
	local needgoods = dms.atoi(reward, union_shop_mould.need_goods)          --所需钻石
	local needlv = dms.atoi(reward, union_shop_mould.need_lv)          --所需军团等级 
	


	contribution:setString(needcontribution)
	self.need = needcontribution

	if _ED.union.union_info.union_grade < needlv then
		self.canBuyType = 1   -- 等级不足
		buybut:setBright(false)
		buybut:setTouchEnabled(false)
		-- buybutcount:setString("军团"..needlv.."级可购买")
		buybutcount:setString(string.format(tipStringInfo_union_str[16],needlv))
	else
		if sum >= sellcantimes then
			self.canBuyType = 0  -- 次数不足
			buybutcount:setString(tipStringInfo_union_str[17])
			buybut:setBright(false)
			buybut:setTouchEnabled(false)
		else
			self.canBuyType = 2  -- 可购买
			if self.pagetype == 0 then
				-- buybutcount:setString("今日可买"..(sellcantimes-sum).."次")
				buybutcount:setString(string.format(tipStringInfo_union_str[18],sellcantimes-sum))
			elseif self.pagetype == 2 or self.pagetype == 1 then
				-- buybutcount:setString("可购买"..(sellcantimes-sum).."次")
				buybutcount:setString(string.format(tipStringInfo_union_str[19],sellcantimes-sum))
			end
			buybut:setTouchEnabled(true)
			buybut:setBright(true)
		end
	end
	iconPanel:removeAllChildren(true)
	local gtype = 0
	local name = ""
	local 
	quality = 5
	if shoptype == -1 then  -- 1 银币 2金币
		if mouldId == 1 then
			local cell = propMoneyIcon:createCell()
			cell:init("1",count,nil)
			iconPanel:addChild(cell)
			propname:setString(_All_tip_string_info._fundName)
			local colortype= 4
			propname:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
			gtype = 1
			name = _All_tip_string_info._fundName
			quality = colortype+1
		elseif mouldId == 2 then
			local cell = propMoneyIcon:createCell()
			cell:init("2",count,nil)
			iconPanel:addChild(cell)
			propname:setString(_All_tip_string_info._crystalName)
			local colortype= 4
			propname:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
			gtype = 2
			name = _All_tip_string_info._crystalName
			quality = colortype+1
		end
	elseif shoptype == 0 then  --道具
		local cell = self:getItemCell(mouldId,nil,count)
		iconPanel:addChild(cell)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        propname:setString(setThePropsIcon(mouldId)[2])
	    else
			propname:setString(dms.string(dms["prop_mould"], mouldId, prop_mould.prop_name))
		end
		local colortype = dms.string(dms["prop_mould"],mouldId,prop_mould.prop_quality)
		propname:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
		gtype = 6
		name = dms.string(dms["prop_mould"], mouldId, prop_mould.prop_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        name = setThePropsIcon(mouldId)[2]
	    end
		quality = colortype+1
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
			name = word_info[3]
			propname:setString(name)
		else
			propname:setString(dms.string(dms["ship_mould"], mouldId, ship_mould.captain_name))
		end
		local colortype = dms.string(dms["ship_mould"],mouldId,ship_mould.ship_type)
		propname:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
		gtype = 13
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], mouldId, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			-- local ship_evo = zstring.split(hero.evolution_status, "|")
			local evo_mould_id = evo_info[dms.int(dms["ship_mould"], mouldId, ship_mould.captain_name)]
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			name = word_info[3]
		else
			name = dms.string(dms["ship_mould"], mouldId, ship_mould.captain_name)
		end
		quality = colortype+1
	elseif shoptype == 2 then -- 装备

		local cell = EquipIconCell:createCell()
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			cell:init(10, nil, mouldId, nil, false, count)
		else
			cell:init(10, nil, mouldId, nil, nil, count)
		end
		iconPanel:addChild(cell)
		propname:setString(dms.string(dms["equipment_mould"], mouldId, equipment_mould.equipment_name))
		self.propName = dms.string(dms["equipment_mould"], mouldId, equipment_mould.equipment_name)
		local colortype = dms.string(dms["equipment_mould"],mouldId,equipment_mould.grow_level)
		propname:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
		gtype = 7
		name = dms.string(dms["equipment_mould"], mouldId, equipment_mould.equipment_name)
		quality = colortype+1
	end
	if needgoods > 0 then
		zhuanshi:setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_47_0"):setString(needgoods)
	end
	self.needgolds=needgoods
	

	--[[
	--碎片数
	local debrisString = "(%d/%d)"
	--已拥有碎片数
	local existingDebris = nil
	--需要的碎片数
	local neededDebris = nil
	-- 是否碎片
	if getIsPropDebris(tID) then
		--获取 需要的碎片,并去遍历已有的碎片
		neededDebris = dms.int(dms["prop_mould"], tID, prop_mould.split_or_merge_count)
		
		existingDebris = getPropAllCountByMouldId(tID)
	end
	--碎片数
	if nil ~= existingDebris and nil ~= neededDebris then
		debrisString = string.format(debrisString, existingDebris, neededDebris)
		self.cacheHoldText:setString(debrisString)
	end
	]]--

	self.mid = mouldId 
	self.count = count
	self.gtype = gtype
	self.price =needcontribution
	self.quality = quality
	self.money = tonumber(_ED.union.user_union_info.rest_contribution)
	self.name = name
	self.existingDebris = nil
	self.maxBuyNum = sellcantimes-sum
	self.indexId = self.index
	self.redDebrisNum = nil
	self.redDebrisMID = nil
	self.originType = union_shop
	-- 	mid =  = nil,--物品的模板id
	-- 	gtype = nil,--物品类型,
	-- 	price = = nil,--单价x货币,诸如威望啊金币啊xxxxx
	-- 	money = = nil,--当前用户持有的x货币的数量
	-- 	name = nil,	--物品名
	-- 	existingDebris = nil, --碎片
	-- 	maxBuyNum = nil, --当前最大可购买次数
	-- 	indexId = nil,--位于本地表中的索引id
	-- 	redDebrisNum = nil, -- 红装碎片需求兑换数
	-- 	redDebrisMID = nil, -- 红装碎片的模板id
	-- 	cell = nil,
	-- 	originType = nil, --调用的来源,区别显示类型

end
--道具
function UnionShopPropFashionListCell:getItemCell(mid,mtype,count,isCertainly)
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

function UnionShopPropFashionListCell:onInit()
	local root = cacher.createUIRef("legion/legion_shop_list.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	
	-- 列表控件动画播放
	-- local action = csb.createTimeline("legion/legion_shop_list_1.csb")
    -- root:runAction(action)
    -- action:play("list_view_cell_open", false)
	-- print("root=======",root)

	if UnionShopPropFashionListCell.__size == nil then
		UnionShopPropFashionListCell.__size = root:getChildByName("Panel_2"):getContentSize()
	end	

	self:updateDraw()
	
	
	-- 购买
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_235"), nil, 
		{
			terminal_name = "union_shop_prop_fashion_list_cell_to_buy", 
			terminal_state = 0, 
			_index = self.index,
			_cell = self,		
			_typeIndex = self.typeIndex,	
			_mid = self.mouldid,		
			isPressedActionEnabled = true
		},
		nil,0)
end

function UnionShopPropFashionListCell:onEnterTransitionFinish()
	
end

function UnionShopPropFashionListCell:upcanBuyType()
	local reward = self.param 
	local needlv = dms.atoi(reward, union_shop_mould.need_lv)          --所需军团等级 
	local sumdata = zstring.split(_ED.union.union_shop_info.prop.goods_count, ",")  -- 已兑换次数
	local sum = zstring.tonumber(sumdata[self.mouldid])
	local sellcantimes = dms.atoi(reward, union_shop_mould.sell_can_times)          --购买限制次数
	if _ED.union.union_info.union_id == nil or tonumber(_ED.union.union_info.union_id) == 0 then
		return
	end
	if _ED.union.union_info.union_grade < needlv then
		self.canBuyType = 1   -- 等级不足
	else
		if sum >= sellcantimes then
			self.canBuyType = 0  -- 次数不足
		else
			self.canBuyType = 2  -- 可购买
		end
	end
end

function UnionShopPropFashionListCell:init( pram, index, page, typeIndex)
	self.pagetype = page 
	self.param = pram 
	self.index = index 

	self.typeIndex = typeIndex
	self.mouldid = dms.atoi(self.param, union_shop_mould.id)
	self:upcanBuyType()
	if self.index < 5 then
		self:onInit()
	end
	self:setContentSize(UnionShopPropFashionListCell.__size)
	return self
end

function UnionShopPropFashionListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionShopPropFashionListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("legion/legion_shop_list.csb", root)
--	root:stopAllActions()
--	root:removeFromParent(false)
	self.roots = {}
end
function UnionShopPropFashionListCell:onExit()
	cacher.freeRef("legion/legion_shop_list.csb", self.roots[1])
end

function UnionShopPropFashionListCell:createCell()
	local cell = UnionShopPropFashionListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
