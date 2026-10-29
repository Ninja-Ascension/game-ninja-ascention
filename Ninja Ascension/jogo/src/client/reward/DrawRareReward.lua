-- ----------------------------------------------------------------------------------------------------
-- 说明：奖励绘制（上飘消失，最多只显示3个物品）
-- ----------------------------------------------------------------------------------------------------
DrawRareReward = class("DrawRareRewardClass", Window)

function DrawRareReward:ctor()
    self.super:ctor()
    
	self.roots = {}
	self.actions = {}
	
	self._rewardType = nil
	self._rewardInfo = nil
	self._rewardPad = {}

	self._isShowDouble = false
	self._needSort = true				-- 是否对奖励内容进行排序

	if  __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
		self._max_draw_count = 5
	else
		self._max_draw_count = -1
	end
	self._draw_last_index = 1
	 
    app.load("client.cells.equip.equip_icon_cell")
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.utils.sm_item_icon_cell")
    app.load("client.cells.prop.prop_money_icon")
    app.load("client.cells.prop.prop_money_info")
    app.load("client.cells.prop.prop_information")
    app.load("client.packs.hero.SmHeroSynthesisSuccess")
    app.load("client.cells.prop.sm_hero_information")
    app.load("client.cells.ship.hero_icon_list_cell")
	--app.load("client.packs.hero.SmRoleFashionCard")
    -- Initialize DrawRareReward page state machine.
    local function init_hero_reborn_terminal()
        -- local hero_reborn_terminal = {
            -- _name = "DrawRareReward",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params) 
				
            -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
	
        local draw_rare_reward_close_terminal = {
            _name = "draw_rare_reward_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- local action = instance.actions[1]
				-- action:play("animation1", false)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					if fwin:find("SmTrialTowerRewardClass") ~= nil then
						state_machine.unlock("sm_trial_tower_reward_list_cell_reward_request", 0, "")
					end
				end
				instance:onCheckOver()
            	return true
            end,
            _terminal = nil,
            _terminals = nil
        }

	-- state_machine.add(hero_reborn_terminal)
        state_machine.add(draw_rare_reward_close_terminal)
        state_machine.init()
    end
    
    init_hero_reborn_terminal()
end

function DrawRareReward:onCheckOver()
    if type(cc.nrSpineCommand)=='function'
        and self._rewardInfo and self._draw_last_index>tonumber(self._rewardInfo.show_reward_item_count) then
        if not self.__nr_reward_closed then
            self.__nr_reward_closed=true
            fwin:close(self)
        end
        return
    end
	if nil ~= self._rewardInfo and tonumber(self._rewardInfo.show_reward_item_count) >= self._draw_last_index then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			if self._rewardSorting ~= nil then
				self._rewardInfo.show_reward_list = rewardDrawSorting(self._rewardInfo.show_reward_list,self._rewardSorting)
			end
		end
		self:onUpdateDraw(self._draw_last_index, self._rewardInfo, self._max_draw_count)
	else
		local action = self.actions[1]
		action:play("animation1", false)
	end
end

function DrawRareReward:onUpdateDraw(beginIndex, rewardInfo, drawMaxCount)
	local root = self.roots[1]

    local nameCell = {
		ccui.Helper:seekWidgetByName(root, "Text_956"),
		ccui.Helper:seekWidgetByName(root, "Text_9_0"),
		ccui.Helper:seekWidgetByName(root, "Text_9_0_0"),
		ccui.Helper:seekWidgetByName(root, "Text_9_0_0_0"),
	}

	local rewardInfo_r = rewardInfo.show_reward_list
	local function sortFunc(a, b)
        -- return a.prop_item < b.prop_item
        if a.prop_item < b.prop_item then
        	return true
        elseif a.prop_item == b.prop_item then
        	return tonumber(a.item_value) < tonumber(b.item_value)
        else
        	return false
        end
    end

	if self._needSort == true then
		table.sort(rewardInfo_r, sortFunc)
	end

	local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_136")
	rewardListView:removeAllItems()
	local nCount = 0

	for i = beginIndex, tonumber(rewardInfo.show_reward_item_count) do
		-- if i > 4 then
		-- 	break
		-- end
		local flag = false
		local rewardList = rewardInfo_r[i]
		local id = rewardList.prop_item
		local cell = nil
		-- 物品1类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:经验 9:耐力 10:功能点 
		-- 11:上阵人数 12:体力 13:武将 14竞技场排名 15:伤害 16:比武积分 17:霸气18威名 19 日常任务积分 20功勋 21战功)
		--如果有钱 29 胜点（排位赛使用） 32 魔陷卡 33 驯兽魂
		if tonumber(rewardList.prop_type) == 1 and tonumber(rewardList.item_value) > 0 and flag == false then
			local quality = 1
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				-- cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1,nil,nil,true,true)
				cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,-1,rewardList.item_value},true,true,false,true})
				-- quality = 3
			else
				cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			end
			-- self._rewardPad[i]:addChild(cell)
			flag = true
			rewardListView:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
			else
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				
				local name = _All_tip_string_info._fundName
				nameCell[i] = cell:getName()
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end
		end

		--如果有宝石
		if tonumber(rewardList.prop_type) == 2 and tonumber(rewardList.item_value) > 0 and flag == false then
			
			local quality = 5
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				-- quality = 3
				-- cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1,nil,nil,true,true)
				cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,-1,rewardList.item_value},true,true,false,true})
			else
				cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			end
			-- self._rewardPad[i]:addChild(cell)
			flag = true
			rewardListView:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
			else
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				
				local name = _All_tip_string_info._crystalName
				nameCell[i] = cell:getName()
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end
		end
		--胜点(排位赛使用)
		if tonumber(rewardList.prop_type) == 29 and tonumber(rewardList.item_value) > 0 and flag == false then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,-1,rewardList.item_value},true,true,false,true})
			else
				cell = propMoneyIcon:createCell()
				cell:init("29",tonumber(rewardList.item_value), nil)
			end
			rewardListView:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
			else
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
			end
		end
		--如果有魂玉
		if tonumber(rewardList.prop_type) == 5 and tonumber(rewardList.item_value) > 0 and flag == false then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,-1,rewardList.item_value},true,true,false,true})
			else
				cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			end
			-- self._rewardPad[i]:addChild(cell)
			flag = true
			rewardListView:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
			else
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				
				local name = _All_tip_string_info._soulName
				local quality = 5
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					name = _All_tip_string_info._juexingsuipian
					quality = 4
				end
				nameCell[i] = cell:getName()
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end
		end		
		--道具
		if tonumber(rewardList.prop_type) == 6 and tonumber(rewardList.item_value) > 0 and flag == false then
			
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				-- cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item,nil,nil,true,true)
				cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,rewardList.prop_item,rewardList.item_value},true,true,false,true})
			else
				cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item)
			end
			
			 -- self._rewardPad[i]:addChild(cell)
			flag = true
			rewardListView:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
			else
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				
				nameCell[i] = cell:getName()
				local name = dms.string(dms["prop_mould"], id, prop_mould.prop_name)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			        name = setThePropsIcon(id)[2]
			    end
				local quality = dms.int(dms["prop_mould"], id, prop_mould.prop_quality) + 1
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end
		end	
		--装备
		if tonumber(rewardList.prop_type) == 7 and tonumber(rewardList.item_value) > 0 and flag == false then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				-- cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item,nil,nil,true,true,nil,{equipQuality = 0})
				cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,rewardList.prop_item,rewardList.item_value},true,true,false,true,{equipQuality = 0}})
			else
				cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item)
			end
			-- self._rewardPad[i]:addChild(cell)
			flag = true
			rewardListView:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
			else
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				
				nameCell[i] = cell:getName()
				local name = dms.string(dms["equipment_mould"], id, equipment_mould.equipment_name)
				local quality = dms.int(dms["equipment_mould"], id, equipment_mould.grow_level) + 1
				-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				-- 	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				-- 	then
				-- 	--获取装备名称索引
				-- 	local nameindex = dms.int(dms["equipment_mould"], id, equipment_mould.equipment_name)
				-- 	--通过索引找到word_mould
				-- 	local word_info = dms.element(dms["word_mould"], nameindex)
				-- 	name = word_info[3]
				-- 	quality = dms.int(dms["equipment_mould"], id, equipment_mould.trace_npc_index) + 1
				-- end
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end
		end
		-- 皮肤
		if tonumber(rewardList.prop_type) == 64 and tonumber(rewardList.item_value) > 0 and flag == false then
			
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				--local cell = ResourcesIconCell:createCell()
		        --local limit_time_index  = dms.int(dms["ship_skin_mould"], tonumber(rewardList.prop_item), ship_skin_mould.duration)
				--local des_time_r = zstring.tonumber(limit_time_index) == -1 and tipStringInfo_evolution_status_tips[4] or limit_time_index .. tipStringInfo_evolution_status_tips[5]
				cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,rewardList.prop_item,rewardList.item_value},true,true,false,true})
				--cell:init(64, 0, tonumber(rewardList.prop_item), nil, nil, true, true, 1,{des_time = des_time_r, skin_num = 1})
			else
				local cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item)
			end
			flag = true
			rewardListView:addChild(cell)
		end	
		--体力
		if tonumber(rewardList.prop_type) == 12 and tonumber(rewardList.item_value) > 0 and flag == false then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,-1,rewardList.item_value},true,true,false,true,{equipQuality = 0}})
			else
				cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			end
			flag = true
			rewardListView:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
			else
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				
				nameCell[i] = cell:getName()
				local quality = 1
				local name = _All_tip_string_info._energyName
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end
		end	

		--武将
		if tonumber(rewardList.prop_type) == 13 and tonumber(rewardList.item_value) > 0 and flag == false then
			local ship = nil
			for i,v in pairs(_ED.user_ship) do
		        if _ED.recruit_success_ship_id == v.ship_id then
		            ship = v
		        end
		    end
		    local table = {}
		    if ship ~= nil then
		    	table.shipStar = ship.StarRating
		    end
			
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				-- cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item,nil,nil,true,true , 1,table)
				cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,rewardList.prop_item,rewardList.item_value},true,false,false,true,table})
			else
				cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item)
			end
			-- self._rewardPad[i]:addChild(cell)
			flag = true
			rewardListView:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
			else
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				
				nameCell[i] = cell:getName()
				local name = nil
				local quality = 0
				-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				-- 	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				-- 	then
				-- 	--进化形象
				-- 	--播放武将技能
				-- 	local isOver = false
				-- 	local schedulerID = nil
				-- 	local function anticlockwiseUpdate()
				-- 		fwin:find("DrawRareRewardClass"):setVisible(false)
				-- 		if fwin:find("SmHeroSynthesisSuccessClass") == nil then
				-- 			smFightingChange()
		  --                   local obj = SmHeroSynthesisSuccess:new()
		  --               	fwin:open(obj,fwin._ui)
		  --               end
	   --              	isOver = true
	   --              	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID) 
	   --              end
	   --              local scheduler = cc.Director:getInstance():getScheduler()
	   --              if schedulerID ~= nil then 
	   --                  scheduler:unscheduleScriptEntry(schedulerID)      
	   --              end
	   --              if isOver == false then
	   --              	schedulerID = scheduler:scheduleScriptFunc(anticlockwiseUpdate,0,false)
	   --              end

				-- 	local evo_image = dms.string(dms["ship_mould"], rewardList.prop_item, ship_mould.fitSkillTwo)
				-- 	local evo_info = zstring.split(evo_image, ",")
				-- 	--进化模板id
				-- 	-- local ship_evo = zstring.split(self.ship.evolution_status, "|")
				-- 	local evo_mould_id = evo_info[dms.int(dms["ship_mould"], rewardList.prop_item, ship_mould.captain_name)]
				-- 	local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
				-- 	local word_info = dms.element(dms["word_mould"], name_mould_id)
	   --      		name = word_info[3]
	   --      		quality = 1
		  --       else		
		        	name = dms.string(dms["ship_mould"], id, ship_mould.captain_name)
		        	quality = dms.int(dms["ship_mould"], id, ship_mould.ship_type) + 1
		        -- end
				
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end
		end	
		--威名
		if tonumber(rewardList.prop_type) == 18 and tonumber(rewardList.item_value) > 0 and flag == false then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,rewardList.prop_item,rewardList.item_value},true,true,false,true})
			else
				cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			end
			-- self._rewardPad[i]:addChild(cell)
			flag = true
			rewardListView:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
			else
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				
				nameCell[i] = cell:getName()
				local quality = 3
				local name = _All_tip_string_info._glories
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end
		end	
		--声望
		if tonumber(rewardList.prop_type) == 3 and tonumber(rewardList.item_value) > 0 and flag == false then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,rewardList.prop_item,rewardList.item_value},true,true,false,true})
			else
				cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			end
			-- self._rewardPad[i]:addChild(cell)
			flag = true
			rewardListView:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
			else
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				
				nameCell[i] = cell:getName()
				local quality = 1
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					quality = 3
				end
				local name = _All_tip_string_info._reputation
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end
		end	
		
		--4:将魂
		if tonumber(rewardList.prop_type) == 4 and tonumber(rewardList.item_value) > 0 and flag == false then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,rewardList.prop_item,rewardList.item_value},true,true,false,true})
			else
				cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			end
			-- self._rewardPad[i]:addChild(cell)
			flag = true
			rewardListView:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
			else
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				
				nameCell[i] = cell:getName()
				local quality = 5
				local name = _All_tip_string_info._hero
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end
		end	
		
		if tonumber(rewardList.prop_type) == 21 and tonumber(rewardList.item_value) > 0 and flag == false then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,rewardList.prop_item,rewardList.item_value},true,true,false,true})
			else
				cell = propMoneyIcon:createCell()
				cell:init("7",tonumber(rewardList.item_value), nil)
			end
			rewardListView:addChild(cell)
		end
		if tonumber(rewardList.prop_type) == 28 and tonumber(rewardList.item_value) > 0 and flag == false then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,rewardList.prop_item,rewardList.item_value},true,true,false,true})
			else
				cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			end
			flag = true
			rewardListView:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
			else
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				
				local name = _my_gane_name[13]
				local quality = 1
				nameCell[i] = cell:getName()
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end
		end

		if tonumber(rewardList.prop_type) == 31 and tonumber(rewardList.item_value) > 0 and flag == false then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,rewardList.prop_item,rewardList.item_value},true,true,false,true})
			else
				cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			end
			flag = true
			rewardListView:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
			else
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				
				local name = _my_gane_name[13]
				local quality = 1
				nameCell[i] = cell:getName()
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end
		end
		if __lua_project_id == __lua_project_yugioh then 
			if tonumber(rewardList.prop_type) == 32 then 
				app.load("client.cells.magicCard.magic_trup_card_icon_cell")
				local cell = MagicTrupCardIconCell:createCell()

				cell:init(rewardList.prop_item, rewardList.item_value)
				rewardListView:addChild(cell)
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				flag = true
				cell:showName()
				
			end
		end
		--驯兽魂
		if tonumber(rewardList.prop_type) == 33 and tonumber(rewardList.item_value) > 0 and flag == false then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,rewardList.prop_item,rewardList.item_value},true,true,false,true})
			else
				cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			end
			flag = true
			rewardListView:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
			else
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				
				local name = _my_gane_name[14]
				local quality = 4
				nameCell[i] = cell:getName()
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end
		end

		if tonumber(rewardList.prop_type) == 8 and tonumber(rewardList.item_value) > 0 and flag == false then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,rewardList.prop_item,rewardList.item_value},true,true,false,true})
			else
				cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			end
			flag = true
			rewardListView:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
			else
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				
				local name = reward_prop_list[8]
				local quality = 3
				nameCell[i] = cell:getName()
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end
		end

		if tonumber(rewardList.prop_type) == 34 and tonumber(rewardList.item_value) > 0 and flag == false then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,rewardList.prop_item,rewardList.item_value},true,true,false,true})
			else
				cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			end
			flag = true
			rewardListView:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
			else
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				
				local name = _my_gane_name[15]
				local quality = 3
				nameCell[i] = cell:getName()
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end
		end

		if tonumber(rewardList.prop_type) == 39 and tonumber(rewardList.item_value) > 0 and flag == false then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
				or __lua_project_id == __lua_project_l_naruto 
				then
				cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,rewardList.prop_item,rewardList.item_value},true,true,false,true})
			else
				cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			end
			flag = true
			rewardListView:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
				or __lua_project_id == __lua_project_l_naruto 
				then
			else
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				
				local name = _my_gane_name[17]
				local quality = 4
				nameCell[i] = cell:getName()
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end
		end

		if tonumber(rewardList.prop_type) == 63 and tonumber(rewardList.item_value) > 0 and flag == false then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,rewardList.prop_item,rewardList.item_value},true,true,false,true})
			else
				cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			end
			flag = true
			rewardListView:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
			else
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				
				local name = _my_gane_name[16]
				local quality = 3
				nameCell[i] = cell:getName()
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end
		end

		if tonumber(rewardList.prop_type) == 71 and tonumber(rewardList.item_value) > 0 and flag == false then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
				or __lua_project_id == __lua_project_l_naruto 
				then
					
				local property_info = dms.string(dms["ship_silk_bag_mould"],rewardList.prop_item,ship_silk_bag_mould.base_property)
				local basePropertyList = {}
				if nil ~= property_info then
					local add_property_info = zstring.split(property_info,"|")
					for i = 1,table.nums(add_property_info) do
						local add_property_per = zstring.split(add_property_info[i],",")
						if nil ~= add_property_per then
							local a = tipStringInfo_rescue_silkbag_property["0"]
							local baseProperty ={}
							baseProperty.property_name = tipStringInfo_rescue_silkbag_property[tostring(add_property_per[1])]
							baseProperty.property_value = add_property_per[2]
							basePropertyList[i] = baseProperty
						end
					end
				end
				cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,rewardList.prop_item,rewardList.item_value},true,true,false,true,{basePropertyList,0}})
			else
				cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			end
			flag = true
			rewardListView:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
				or __lua_project_id == __lua_project_l_naruto 
				then
			else
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				
				local name = _my_gane_name[17]
				local quality = 4
				nameCell[i] = cell:getName()
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end
		end

		if tonumber(rewardList.prop_type) == 65 and tonumber(rewardList.item_value) > 0 and flag == false then
			cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,rewardList.prop_item,rewardList.item_value},true,true,false,true})
			flag = true
			rewardListView:addChild(cell)
		end

		--合金
		if tonumber(rewardList.prop_type) == 66 and tonumber(rewardList.item_value) > 0 and flag == false then
			cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,rewardList.prop_item,rewardList.item_value},true,true,false,true})
			flag = true
			rewardListView:addChild(cell)
		end

		--合金精华
		if tonumber(rewardList.prop_type) == 67 and tonumber(rewardList.item_value) > 0 and flag == false then
			flag = true
			cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,rewardList.prop_item,rewardList.item_value},true,true,false,true})
			rewardListView:addChild(cell)
		end

		-- 探索币
		if tonumber(rewardList.prop_type) == 68 and tonumber(rewardList.item_value) > 0 and flag == false then
			cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
			flag = true
			rewardListView:addChild(cell)
		end

		-- 探索币（口袋）
		if tonumber(rewardList.prop_type) == 70 and tonumber(rewardList.item_value) > 0 and flag == false then
			cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
			flag = true
			rewardListView:addChild(cell)
		end

		-- 圣物精华
		if tonumber(rewardList.prop_type) == 69 and tonumber(rewardList.item_value) > 0 and flag == false then
			flag = true
			cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
			rewardListView:addChild(cell)
		end

		-- 战魂
		if tonumber(rewardList.prop_type) == 73 and tonumber(rewardList.item_value) > 0 and flag == false then
			flag = true
			cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
			rewardListView:addChild(cell)

			local mouldId = rewardList.prop_item
			local quality = dms.int(dms["fight_spirit_mould"], mouldId, fight_spirit_mould.quality) + 1

			local pos = dms.int(dms["fight_spirit_mould"], mouldId, fight_spirit_mould.pos)
			local suitId = dms.int(dms["fight_spirit_mould"], mouldId, fight_spirit_mould.suit_id)
			nameCell[i] = ccui.Helper:seekWidgetByName(cell.roots[1],"Label_name")
			nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			nameCell[i]:setString(dms.element(dms["word_mould"], 
				dms.int(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.suit_name))[3].."."..chinese_num[pos])
		end

		-- 代金券
		if tonumber(rewardList.prop_type) == 74 and tonumber(rewardList.item_value) > 0 and flag == false then
			flag = true
			cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
			rewardListView:addChild(cell)
		end

		-- 头像框
		if tonumber(rewardList.prop_type) == 76 and tonumber(rewardList.item_value) > 0 and flag == false then
			flag = true
			cell = state_machine.excute("sm_item_icon_cell_create", 0, {0, {rewardList.prop_type, rewardList.prop_item, rewardList.item_value}, true, true, false, true})
			rewardListView:addChild(cell)
		end

		if cell ~= nil and cell.setActivityDouble ~= nil then
			if self._isShowDouble == true then
				cell:setActivityDouble(self._isShowDouble)
			end
		end
		nCount = nCount + 1
		if nCount >= drawMaxCount and drawMaxCount > 0 then
			break
		end

		
	end

	self._draw_last_index = self._draw_last_index + nCount

	rewardListView:requestRefreshView()
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_yugioh 
		then
		local tpx=120--每个奖励框大小
		local x= rewardListView:getContentSize().width
		local _tables=rewardListView:getItems()
		for i, v in pairs(_tables) do
			tpx=v.roots[1]:getContentSize().width
			v.roots[1]:setPositionX(v.roots[1]:getPositionX()+(x-tpx*#_tables)/2)
			--print("xxxxxxxxxxxxxxxxxxxx:",v.roots[1]:getPositionX()+(x-tpx*rewardInfo.show_reward_item_count)/2)
			
			if drawMaxCount > 0 then
				local t = 0.5 + 0.1 * (i - 1) + 0.001
				v:runAction(cc.Sequence:create({cc.DelayTime:create(t), cc.CallFunc:create(function ( sender )
					sender:setVisible(true)
				end)}))
				v:setVisible(false)
			end
		end
	end
end

function DrawRareReward:onEnterTransitionFinish()
	local csbfenjiefanhuan = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		csbfenjiefanhuan = csb.createNode("refinery/refinery_fenjiefanhuan_2.csb")
		local root = csbfenjiefanhuan:getChildByName("root")
		local Panel_hddh = ccui.Helper:seekWidgetByName(root, "Panel_hddh")
		local jsonFile = "sprite/spirte_daojuhuode.json"
        local atlasFile = "sprite/spirte_daojuhuode.atlas"
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "effect", type(cc.nrSpineCommand)~='function', nil)
        local isOver = false
        local function onFrameEventBullet(bone,evt,originFrameIndex,currentFrameIndex)
	        if evt ~= nil and #evt > 0 then
	            if evt == "union_10010101" then
	                local jsonFile2 = "sprite/effect_10010101.json"
			        local atlasFile2 = "sprite/effect_10010101.atlas"
			        local animation2 = sp.spine(jsonFile2, atlasFile2, 1, 0, "animation", true, nil)
			        animation2:setPosition(cc.p(Panel_hddh:getContentSize().width/2, Panel_hddh:getContentSize().height/2))
			        animation2:setTag(1205)
			        Panel_hddh:addChild(animation2)
			    elseif evt == "union_10010102" then
			    	if Panel_hddh:getChildByTag(1205) ~= nil then
			    		Panel_hddh:removeChildByTag(1205)
			    	end
			    	if isOver == false then
			    		isOver = true
				    	local jsonFile3 = "sprite/effect_10010102.json"
				        local atlasFile3 = "sprite/effect_10010102.atlas"
				        local animation3 = sp.spine(jsonFile3, atlasFile3, 1, 0, "animation", true, nil)
				        animation3:setPosition(cc.p(Panel_hddh:getContentSize().width/2, Panel_hddh:getContentSize().height/2))
				        Panel_hddh:addChild(animation3)
				    end
	            end
	        end
	    end
        animation.animationNameList = {"effect","effect_loop"}
        sp.initArmature(animation, false)
        animation:getAnimation():setFrameEventCallFunc(onFrameEventBullet)
        if type(cc.nrSpineCommand)=='function' then
            -- Play the original opening once, followed only by its idle loop.
            animation:registerSpineEventHandler(function(event)
                if event.animation=='effect' then animation:setAnimation(0,'effect_loop',true) end
            end,sp.EventType.ANIMATION_COMPLETE)
            animation:setAnimation(0,'effect',false)
        else
            animation._invoke = changeActionCallback
            animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
            csb.animationChangeToAction(animation, 0, 1, false)
        end
        Panel_hddh:addChild(animation)
        animation:setPosition(cc.p(Panel_hddh:getContentSize().width/2, Panel_hddh:getContentSize().height/2))
        playEffect(formatMusicFile("effect", 9980))
	else
		csbfenjiefanhuan = csb.createNode("refinery/refinery_fenjiefanhuan_1.csb")
	end
	self:addChild(csbfenjiefanhuan)
	local root = csbfenjiefanhuan:getChildByName("root")
	table.insert(self.roots, root)
	local action = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		action = csb.createTimeline("refinery/refinery_fenjiefanhuan_2.csb")
	else
		action = csb.createTimeline("refinery/refinery_fenjiefanhuan_1.csb")
	end
	table.insert(self.actions, action)
    csbfenjiefanhuan:runAction(action)

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		local btn_ok = ccui.Helper:seekWidgetByName(root, "Button_ok")
		btn_ok:setVisible(false)
		btn_ok:runAction(cc.Sequence:create({cc.DelayTime:create(1), cc.CallFunc:create(function ( sender )
                        btn_ok:setVisible(true)
                    end)}))
		fwin:addTouchEventListener(btn_ok, nil, 
		{
			terminal_name = "draw_rare_reward_close", 
			terminal_state = 0, 
        	touch_black = true,
		}, 
		nil, 3)
    	action:play("animation0", false)
    else
    	action:gotoFrameAndPlay(0, action:getDuration(), false)
	end
    
	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "exit" then
            fwin:close(self)
        end
    end)
   
	for i = 1, 4 do
		self._rewardPad[i] = ccui.Helper:seekWidgetByName(root, string.format("Panel_huode_%d", i))
	end
   
	local function calculateIconType(number)
		local iconid = 3009
		if number >=1 and number<=9999 then
			iconid = 3009
		elseif number>=10000 and number<=99999 then
			iconid = 3011
		elseif number >=100000 then
			iconid = 3013
		end
		return iconid
	end
    local nameCell = {
		ccui.Helper:seekWidgetByName(root, "Text_956"),
		ccui.Helper:seekWidgetByName(root, "Text_9_0"),
		ccui.Helper:seekWidgetByName(root, "Text_9_0_0"),
		ccui.Helper:seekWidgetByName(root, "Text_9_0_0_0"),
	}
	local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_136")
   	local rewardInfo = nil
	if self._rewardInfo == nil then
		rewardInfo = getSceneReward(self._rewardType == nil and 0 or self._rewardType)
		self._rewardInfo = rewardInfo
	else
		getSceneReward(self._rewardType == nil and 0 or self._rewardType)
		rewardInfo = self._rewardInfo
	end
	
	if nil == rewardInfo then
		return
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if self._rewardSorting ~= nil then
			self._rewardInfo.show_reward_list = rewardDrawSorting(self._rewardInfo.show_reward_list,self._rewardSorting)
			self._rewardInfo.show_reward_item_count = #self._rewardInfo.show_reward_list
		end
		self:onUpdateDraw(self._draw_last_index, self._rewardInfo, self._max_draw_count)
	else
		for i=1, tonumber(rewardInfo.show_reward_item_count) do
			-- if i > 4 then
			-- 	break
			-- end
			local flag = false
			local rewardList = rewardInfo.show_reward_list[i]
			local id = rewardList.prop_item
			-- 物品1类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:经验 9:耐力 10:功能点 
			-- 11:上阵人数 12:体力 13:武将 14竞技场排名 15:伤害 16:比武积分 17:霸气18威名 19 日常任务积分 20功勋 21战功)
			--如果有钱 29 胜点（排位赛使用） 32 魔陷卡 33 驯兽魂
			if tonumber(rewardList.prop_type) == 1 and tonumber(rewardList.item_value) > 0 and flag == false then
				local cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
				-- self._rewardPad[i]:addChild(cell)
				rewardListView:addChild(cell)
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				flag = true
				local name = _All_tip_string_info._fundName
				local quality = 1
				nameCell[i] = cell:getName()
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end

			--如果有宝石
			if tonumber(rewardList.prop_type) == 2 and tonumber(rewardList.item_value) > 0 and flag == false then
				local cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
				-- self._rewardPad[i]:addChild(cell)
				rewardListView:addChild(cell)
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				flag = true
				local name = _All_tip_string_info._crystalName
				local quality = 5
				nameCell[i] = cell:getName()
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end
			--胜点(排位赛使用)
			if tonumber(rewardList.prop_type) == 29 and tonumber(rewardList.item_value) > 0 and flag == false then
				local cell = propMoneyIcon:createCell()
				cell:init("29",tonumber(rewardList.item_value), nil)
				rewardListView:addChild(cell)
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				
			end
			--如果有魂玉
			if tonumber(rewardList.prop_type) == 5 and tonumber(rewardList.item_value) > 0 and flag == false then
				local cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
				-- self._rewardPad[i]:addChild(cell)
				rewardListView:addChild(cell)
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				flag = true
				local name = _All_tip_string_info._soulName
				local quality = 5
				nameCell[i] = cell:getName()
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end		
			--道具
			if tonumber(rewardList.prop_type) == 6 and tonumber(rewardList.item_value) > 0 and flag == false then
				local cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item)
				
				 -- self._rewardPad[i]:addChild(cell)
				rewardListView:addChild(cell)
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				flag = true
				if dms.int(dms["prop_mould"], id, prop_mould.props_type) == 20 then--战宠碎片要显示“碎”字
					cell:showName(id ,tonumber(rewardList.prop_type))
				else
					nameCell[i] = cell:getName()
					local name = dms.string(dms["prop_mould"], id, prop_mould.prop_name)
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						name = setThePropsIcon(id)[2]
					end
					local quality = dms.int(dms["prop_mould"], id, prop_mould.prop_quality) + 1
					nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
					nameCell[i]:setString(name)
				end
			end	
			--装备
			if tonumber(rewardList.prop_type) == 7 and tonumber(rewardList.item_value) > 0 and flag == false then
				local cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item)
				-- self._rewardPad[i]:addChild(cell)
				rewardListView:addChild(cell)
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				flag = true
				nameCell[i] = cell:getName()
				local name = dms.string(dms["equipment_mould"], id, equipment_mould.equipment_name)
				local quality = dms.int(dms["equipment_mould"], id, equipment_mould.grow_level) + 1
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end	
			--武将
			if tonumber(rewardList.prop_type) == 13 and tonumber(rewardList.item_value) > 0 and flag == false then
				local cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item)
				-- self._rewardPad[i]:addChild(cell)
				rewardListView:addChild(cell)
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				flag = true
				nameCell[i] = cell:getName()
				local name = dms.string(dms["ship_mould"], id, ship_mould.captain_name)
				local quality = dms.int(dms["ship_mould"], id, ship_mould.ship_type) + 1
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end	
			--威名
			if tonumber(rewardList.prop_type) == 18 and tonumber(rewardList.item_value) > 0 and flag == false then
				local cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
				-- self._rewardPad[i]:addChild(cell)
				rewardListView:addChild(cell)
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				flag = true
				nameCell[i] = cell:getName()
				local quality = 1
				local name = _All_tip_string_info._glories
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end	
			--声望
			if tonumber(rewardList.prop_type) == 3 and tonumber(rewardList.item_value) > 0 and flag == false then
				local cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
				-- self._rewardPad[i]:addChild(cell)
				rewardListView:addChild(cell)
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				flag = true
				nameCell[i] = cell:getName()
				local quality = 4
				local name = _All_tip_string_info._reputation
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end	
			
			--4:将魂
			if tonumber(rewardList.prop_type) == 4 and tonumber(rewardList.item_value) > 0 and flag == false then
				local cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
				-- self._rewardPad[i]:addChild(cell)
				rewardListView:addChild(cell)
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				flag = true
				nameCell[i] = cell:getName()
				local quality = 5
				local name = _All_tip_string_info._hero
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end	
			
			if tonumber(rewardList.prop_type) == 21 and tonumber(rewardList.item_value) > 0 and flag == false then
				local cell = propMoneyIcon:createCell()
				cell:init("7",tonumber(rewardList.item_value), nil)
				rewardListView:addChild(cell)
			end
			if tonumber(rewardList.prop_type) == 28 and tonumber(rewardList.item_value) > 0 and flag == false then
				local cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
				rewardListView:addChild(cell)
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				flag = true
				local name = _my_gane_name[13]
				local quality = 1
				nameCell[i] = cell:getName()
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end

			if tonumber(rewardList.prop_type) == 31 and tonumber(rewardList.item_value) > 0 and flag == false then
				local cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
				rewardListView:addChild(cell)
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				flag = true
				local name = _my_gane_name[13]
				local quality = 1
				nameCell[i] = cell:getName()
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end
			if __lua_project_id == __lua_project_yugioh then 
				if tonumber(rewardList.prop_type) == 32 then 
					app.load("client.cells.magicCard.magic_trup_card_icon_cell")
					local cell = MagicTrupCardIconCell:createCell()

					cell:init(rewardList.prop_item, rewardList.item_value)
					rewardListView:addChild(cell)
					cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
					flag = true
					cell:showName()
					
				end
			end
			--驯兽魂
			if tonumber(rewardList.prop_type) == 33 and tonumber(rewardList.item_value) > 0 and flag == false then
				local cell = ResourcesIconCell:createCell()
				cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
				rewardListView:addChild(cell)
				cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
				flag = true
				local name = _my_gane_name[14]
				local quality = 4
				nameCell[i] = cell:getName()
				nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				nameCell[i]:setString(name)
			end
		end
    end
end

function DrawRareReward:onExit()
	-- state_machine.remove("DrawRareReward")
	state_machine.remove("draw_rare_reward_on_check_over")
end

-- 是否要对奖励内容进行排序
function DrawRareReward:updateSortState(needSort)
	self._needSort = needSort
end

function DrawRareReward:showDoubleState( ... )
	self._isShowDouble = true
end

--2017.10.10新加一个参数,用来记录之前界面绘制的奖励排序
function DrawRareReward:init(_rewardType, _rewardInfo, _rewardSorting)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--处理连点造成多个奖励界面弹出而卡死界面
		if fwin:find("DrawRareRewardClass") ~= nil then
			fwin:close(fwin:find("DrawRareRewardClass"))
		end
	end
	self._rewardType = _rewardType
	self._rewardInfo = _rewardInfo
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if _rewardSorting ~= nil then
			self._rewardSorting = _rewardSorting
		else
			self._rewardSorting = nil
		end
		if fwin:find("HeroStorageClass") ~= nil then
			state_machine.unlock("sm_hero_seat_open_synthesis", 0, "")
			state_machine.excute("hero_list_view_update_cell_lock_synthesis", 0, false)
		end
	end
end
