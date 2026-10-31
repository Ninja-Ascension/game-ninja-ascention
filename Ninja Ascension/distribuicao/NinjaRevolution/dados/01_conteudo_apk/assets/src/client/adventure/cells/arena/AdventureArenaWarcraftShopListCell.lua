----------------------------------------------------------------------------------------------------
-- 说明：商店列表
----------------------------------------------------------------------------------------------------
AdventureArenaWarcraftShopListCell = class("AdventureArenaWarcraftShopListCellClass", Window)
AdventureArenaWarcraftShopListCell.__size = nil

function AdventureArenaWarcraftShopListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.index = 1
	self.current_type = 0 -- 0 积分 1 胜点
	self.activityInfo = nil
	self.is_digimon = false --是否是数码宝贝
	app.load("client.adventure.cells.prop.adventure_new_prop_icon_cell")
	app.load("client.adventure.cells.hero.adventure_hero_icon_cell")
	-- Initialize adventure hero list cell state machine.
	local function init_adventure_warcraft_shop_list_cell_terminal()
		local adventure_arena_warcraft_shop_buy_terminal = {
            _name = "adventure_arena_warcraft_shop_buy",
            _init = function (terminal)
                app.load("client.adventure.reward.AdventureTipReward")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
	            local function responseBuyCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    	if response.node.is_digimon == true then 
                    		app.load("client.reward.DrawRareReward")
                    		local getRewardWnd = DrawRareReward:new()
                   			getRewardWnd:init(61)
                   			fwin:open(getRewardWnd,fwin._dialog)
                    	else
                    		local rewardlist = getSceneReward(61)
                    		if rewardlist ~= nil then 	
                    			fwin:open(AdventureTipReward:new():init(rewardlist), fwin._windows)
                    		end
                    	end
                    	
                    	state_machine.excute("adventure_arena_warcraft_refresh_integral", 0, 0) 
                    	state_machine.excute("adventure_arena_warcraft_shop_buy_update", 0, 0) 
                    	
               			response.node:updateDraw()	
                    end
                end
                protocol_command.warcraft_shop_buy.param_list = "" ..cell.current_type .. "\r\n".. cell.index
                NetworkManager:register(protocol_command.warcraft_shop_buy.code, nil, nil, nil, cell, responseBuyCallBack, false, nil)
            
            end,
            _terminal = nil,
            _terminals = nil
        }
	
        state_machine.add(adventure_arena_warcraft_shop_buy_terminal)

        state_machine.init()
	end

	-- call func init adventure hero list cell state machine.
	init_adventure_warcraft_shop_list_cell_terminal()
end

function AdventureArenaWarcraftShopListCell:updateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id ==__lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_warship_girl_b 
		then  
		self.is_digimon = true
	else
		self.is_digimon = false
	end
	local Text_shengdian = ccui.Helper:seekWidgetByName(root, "Text_shengdian")
	local Text_jifen = ccui.Helper:seekWidgetByName(root, "Text_jifen")
	local Text_xuezuan = ccui.Helper:seekWidgetByName(root, "Text_xuezuan")
	Text_xuezuan:setVisible(true)
	local Text_sycs = ccui.Helper:seekWidgetByName(root, "Text_sycs") --剩余次数
	local Text_shengyu = ccui.Helper:seekWidgetByName(root, "Text_shengyu") --剩余次数数字
	
	local Text_tiaojian = nil
	if self.is_digimon == true then 
		Text_tiaojian = ccui.Helper:seekWidgetByName(root, "Text_tiaojian") --条件
	else
		Text_tiaojian = ccui.Helper:seekWidgetByName(root, "Text_1") --条件
	end
	
	local Text_sp_name = ccui.Helper:seekWidgetByName(root, "Text_sp_name")
	local Text_hero_name = ccui.Helper:seekWidgetByName(root, "Text_hero_name")
	Text_sp_name:setString("")
	Text_hero_name:setString("")
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then 
	else
		Text_tiaojian:setString("")
	end
	
	
	Text_jifen:setVisible(self.current_type == 0)
	Text_shengdian:setVisible(self.current_type == 1)
	local item_panel = ccui.Helper:seekWidgetByName(root, "Panel_shangp")
	item_panel:removeAllChildren(true)
	local buyButton = ccui.Helper:seekWidgetByName(root, "Button_buy")
	buyButton:setTouchEnabled(true)
	buyButton:setColor(cc.c3b(255, 255, 255))

	if self.current_type == 0 then 
		--积分
		local title_id = dms.int(dms["warcraft_shop_info"], self.index, warcraft_shop_info.title_limit)
		local item_type = dms.int(dms["warcraft_shop_info"], self.index, warcraft_shop_info.item_type)
		local title_name = dms.string(dms["warcraft_mould"], title_id, warcraft_mould.title_name)
		local buy_totalCounts = dms.int(dms["warcraft_shop_info"], self.index, warcraft_shop_info.limit_count)
		local buy_times = zstring.split("".. _ED.warcraft_info.normal_shop_state,",")
		local item_mould_id = dms.int(dms["warcraft_shop_info"], self.index, warcraft_shop_info.item_mould_id)
		local one_sell_count = dms.int(dms["warcraft_shop_info"], self.index, warcraft_shop_info.one_sell_count)
		
		if buy_totalCounts == -1 then 
			--无限制
			Text_sycs:setVisible(false)
		else
			Text_sycs:setVisible(true)
			if buy_totalCounts - zstring.tonumber(buy_times[self.index]) == 0 then 
				--没有购买次数了
				buyButton:setTouchEnabled(false)
				buyButton:setColor(cc.c3b(150, 150, 150))
			end
			Text_shengyu:setString("" ..  buy_totalCounts - zstring.tonumber(buy_times[self.index]))
		end
		local cell = nil 
   		
		if item_type == -1 then 
			--资源
			if self.is_digimon == true then 
				app.load("client.cells.prop.prop_money_icon")
            	cell = propMoneyIcon:createCell()
            	cell:init("1",one_sell_count,nil)
			else
				cell = adventureNewPropIconCell:createCell()
				cell:init(0, {resource_type = item_mould_id} , one_sell_count, 0)
				
			end
			Text_sp_name:setString("".. cell.propName) --名称
          	--cell:init(0, {resource_type = item_mould_id} ,-1, nil, 0, 0)
        	item_panel:addChild(cell)
        	
		elseif item_type == 0 then  
			--道具
			local cell = nil
			if self.is_digimon == true then 
				app.load("client.cells.utils.resources_icon_cell")
				cell = ResourcesIconCell:createCell()
				cell:init(6, tonumber(one_sell_count), item_mould_id)
				--Text_sp_name:setString("".. cell:getName():getString()) --名称
			else
				cell = adventureNewPropIconCell:createCell()
            	cell:init(0, {mould_id = item_mould_id} , one_sell_count, 0 )	
            	
			end
   			Text_sp_name:setString("".. cell.propName) --名称
            item_panel:addChild(cell)
            
		elseif item_type == 1 then  
			--佣兵
			cell = AdventureHeroIconCell:createCell()
			cell:init(11, {ship_template_id = item_mould_id}, 1, 0, nil, nil, nil, nil, 0)
			item_panel:addChild(cell)
			Text_hero_name:setString("".. cell.propName) --名称
		elseif item_type == 7 then 
   			--装备 --挖矿没有这个类型
   			cell = EquipIconCell:createCell()
   			cell:init(17,nil,item_mould_id,nil,false,one_sell_count)
   			item_panel:addChild(cell)
			Text_hero_name:setString("".. cell.propName) --名称
		end
		if self.is_digimon == true then 
			Text_tiaojian:setString(string.format(warcraft_tip[3],title_name))	
		else
			Text_tiaojian:setString(string.format(_string_piece_info[442],title_name))	
		end
		local jifen = dms.int(dms["warcraft_shop_info"], self.index, warcraft_shop_info.need_score)
		local xuezuan = dms.int(dms["warcraft_shop_info"], self.index, warcraft_shop_info.need_gold)
		ccui.Helper:seekWidgetByName(root, "Text_xz_number"):setString("".. xuezuan)
		ccui.Helper:seekWidgetByName(root, "Text_jf_number"):setString("".. jifen)
		Text_xuezuan:setVisible(xuezuan > 0 )
	else 
		--胜点
		local shop_datas = zstring.split(_ED.warcraft_info.win_shop_state_info, "\\r\\n")
		local activityInfo = shop_datas[self.index]
		if activityInfo == nil then 
			return
		end
		activityInfo = zstring.replace(activityInfo, "+", "|")
		activityInfo = zstring.replace(activityInfo, "=", "|")		
		-- "29,659,20+2,1,180=6,57,1,2"
      	local items = zstring.split(activityInfo,"|")
      	
      	for i=1,2 do
      		local oneItem = zstring.split(""..items[i],",")
      		if zstring.tonumber(oneItem[1]) == 29 then 
      			--胜点
      			ccui.Helper:seekWidgetByName(root, "Text_sd_number"):setString(""..oneItem[3])
      		end

      		if zstring.tonumber(oneItem[1]) == 2 then 
      			--血钻
      			ccui.Helper:seekWidgetByName(root, "Text_xz_number"):setString(""..oneItem[3])
      			Text_xuezuan:setVisible(zstring.tonumber(oneItem[3]) > 0)
      		end
      	end
      	local getItems = zstring.split(items[3],",")

   		local item_type = zstring.tonumber(getItems[1])
   		local cell = nil
   		if item_type == 6 then 
   			local cell = nil
   			if self.is_digimon == true then 
   				app.load("client.cells.utils.resources_icon_cell")
   				cell = ResourcesIconCell:createCell()
				cell:init(6, tonumber(getItems[3]), getItems[2])
				--Text_sp_name:setString("".. cell:getName():getString()) --名称
			else	
				cell = adventureNewPropIconCell:createCell()
   				cell:init(0, {mould_id = getItems[2]} , getItems[3], 0 )
   				
   			end
   			Text_sp_name:setString("".. cell.propName) --名称
            item_panel:addChild(cell)
   		end
   		if item_type == 7 then 
   			--装备 --挖矿没有这个类型
   			cell = EquipIconCell:createCell()
   			cell:init(17,nil,getItems[2],nil,false,getItems[3])
   			item_panel:addChild(cell)
			Text_hero_name:setString("".. cell.propName) --名称
   		end
   		if item_type == 4 then 
   			--荣誉碎片
   			cell = adventureNewPropIconCell:createCell()
   			cell:init(0, {resource_type = 4} , getItems[3], 0)
        	item_panel:addChild(cell)
        	Text_sp_name:setString("".. cell.propName) --名称
   		end

		 if item_type == 1 then    --金币
		 	if self.is_digimon == true then 
		 		app.load("client.cells.prop.prop_money_icon")
            	cell = propMoneyIcon:createCell()
            	cell:init("1",getItems[3],nil)

         	else
	 			cell = adventureNewPropIconCell:createCell()
   				cell:init(0, {resource_type = 1} , getItems[3], 0)
   				
		 	end
   			Text_sp_name:setString("".. cell.propName) --名称
        	item_panel:addChild(cell)
     
   		end


   		if item_type == 13 then 
   			--武将
   			cell = AdventureHeroIconCell:createCell()
			cell:init(11, {ship_template_id = getItems[2]}, 1, 0, nil, nil, nil, nil, 0)
			item_panel:addChild(cell)
			Text_hero_name:setString("".. cell.propName) --名称
   		end
		local buy_totalCounts = zstring.tonumber(getItems[4])
		if buy_totalCounts == -1 then 
			--无限制
			Text_sycs:setVisible(false)
		else
			--local buy_times = zstring.split(_ED.active_activity[72].activity_extra_prame2, ",")
			local buy_times = zstring.split(_ED.warcraft_info.win_shop_state,",")
			
			Text_sycs:setVisible(true)
			if buy_totalCounts - zstring.tonumber(buy_times[self.index]) == 0 then 
				--没有购买次数了
				buyButton:setTouchEnabled(false)
				buyButton:setColor(cc.c3b(150, 150, 150))
			end
			Text_shengyu:setString("" ..  buy_totalCounts - zstring.tonumber(buy_times[self.index]))
		end
	end
end

function AdventureArenaWarcraftShopListCell:updateDrawButtonState()
	local root = self.roots[1]
	if root == nil then 
		return
	end

end

function AdventureArenaWarcraftShopListCell:onInit()
	self.roots = {}
	local root = cacher.createUIRef("list/list_pws_shop_buy.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy"),       nil, 
	{
		terminal_name = "adventure_arena_warcraft_shop_buy",
		cell = self,        
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)

	
	-- Get size for root node.
	if AdventureArenaWarcraftShopListCell.__size == nil then
		local size = root:getContentSize()
		AdventureArenaWarcraftShopListCell.__size = size
	end

	self:updateDraw()
end

function AdventureArenaWarcraftShopListCell:onExit()
	cacher.freeRef("list/list_pws_shop_buy.csb", self.roots[1])
	self.roots = nil
end

function AdventureArenaWarcraftShopListCell:init(current_type,drawIndex)
	self.current_type = current_type
	self.index = drawIndex
	
	--if drawIndex ~= nil and drawIndex < 8 then
		self:onInit()
	--end

	self:setContentSize(AdventureArenaWarcraftShopListCell.__size)
	return self
end

function AdventureArenaWarcraftShopListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureArenaWarcraftShopListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("list/list_pws_shop_buy.csb", root)
	
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureArenaWarcraftShopListCell:createCell()
	local cell = AdventureArenaWarcraftShopListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

