----------------------------------------------------------------------------------------------------
-- 说明：Pve界面 扫荡完结
-------------------------------------------------------------------------------------------------------
MoppingResultEndCell = class("MoppingResultEndCellClass", Window)

function MoppingResultEndCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.sweep_reward = {}
	self.times = 0
	self.isOver = false
	self.isHaveActivity = false
	
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.ship.ship_icon_cell")
end

function MoppingResultEndCell:onUpdateDraw()

	-- local Panel_reward = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_reward")
	
	-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		-- ccui.Helper:seekWidgetByName(self.roots[1], "Text_cishu_01"):setString(string.format(_new_interface_text[36],zstring.tonumber(self.times)))	-- 标题
		-- ccui.Helper:seekWidgetByName(self.roots[1], "Text_3"):setString("+"..self.sweep_reward.reward_experience)    -- 经验
		-- ccui.Helper:seekWidgetByName(self.roots[1], "Text_5"):setString("+"..self.sweep_reward.reward_silver)    	-- 银币
	-- else
		-- ccui.Helper:seekWidgetByName(self.roots[1], "Text_cishu_01"):setString(self.times)     					-- 标题
		-- ccui.Helper:seekWidgetByName(self.roots[1], "Text_3"):setString(self.sweep_reward.reward_experience)    -- 经验
		-- ccui.Helper:seekWidgetByName(self.roots[1], "Text_5"):setString(self.sweep_reward.reward_silver)    	-- 银币
	-- end

	local cell_list = {}
	--70
	-- debug.print_r(getSceneReward(70))
	local Panel_reward = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_reward")
	local rewardInfo = self.sweep_reward
	if rewardInfo ~= nil then
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_cishu_01"):setVisible(true)
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_reward"):setVisible(true)

		-- 世界等级的加成
		if self.currentSceneType == 0 or self.currentSceneType == 1 then
			if _ED.user_info.world_grade and tonumber(_ED.user_info.user_grade) >= 50 and tonumber(_ED.user_info.user_grade) < _ED.user_info.world_grade then
				if tipStringInfo_world_rank_tips[1] then
					ccui.Helper:seekWidgetByName(self.roots[1], "Text_cishu_01"):setString(tipStringInfo_world_rank_tips[1])
				end
            end
		end

		for i = 1, tonumber(rewardInfo.show_reward_item_count) do
			local rewardList = rewardInfo.show_reward_list[i]
			--道具
			if tonumber(rewardList.prop_type) == 6 and tonumber(rewardList.item_value) > 0 then
				-- local cell = PropIconCell:createCell()
				-- cell:init(30, rewardList.prop_item, tonumber(rewardList.item_value),true)
				local cell = ResourcesIconCell:createCell()
            	cell:init(6, tonumber(rewardList.item_value), rewardList.prop_item, nil,nil,true,true)
				table.insert(cell_list, cell)
			end	
		end
		
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local cellSize = nil
			if cell_list[1] ~= nil then
				local cell = cell_list[1]
				cellSize = cell:getContentSize()
			end
			local sSize = Panel_reward:getContentSize()
		    local sHeight = sSize.height
		    local sWidth = sSize.width
		    local controlSize = Panel_reward:getContentSize()
		    local nextY = sSize.height
		    local nextX = sSize.width
		    local tHeight = 0
		    local cellHeight = 0
		    local tWidth = 0
		    local wPosition = sWidth/5
		    local Hlindex = 0
		    local number = #cell_list
		    local h_index = math.ceil(number/5)
		    cellHeight = h_index*(Panel_reward:getContentSize().width/5)+25
	    	sHeight = math.max(sHeight, cellHeight)
	    	Panel_reward:setContentSize(Panel_reward:getContentSize().width, sHeight)
	    	for j, v in pairs(cell_list) do
	    		Panel_reward:addChild(v)
	    		if v.setActivityDouble ~= nil then
	    			v:setActivityDouble(self.isHaveActivity)
	    		end
		        tWidth = tWidth + wPosition
		        if (j-1)%5 ==0 then
		            Hlindex = Hlindex+1
		            tWidth = 0
		            tHeight = sHeight - wPosition*Hlindex  
		        end
		        if j <= 5 then
		            tHeight = sHeight - wPosition
		        end
		        v:setPosition(cc.p(tWidth,tHeight))
	    	end
	    	local upHeight = sHeight - Panel_reward._h

			self:setContentSize(cc.size(self:getContentSize(),self:getContentSize().height+upHeight))

			self.roots[1]:setPositionY(self.roots[1]._h+upHeight)

			for i, v in pairs(cell_list) do
				if number > 0 then
					local t = 0.5 + 0.5 * (i - 1)
					self.delay = t
					v:runAction(cc.Sequence:create({cc.DelayTime:create(t/2), cc.ScaleTo:create(0.01, 1.05), cc.CallFunc:create(function ( sender )
						sender:setVisible(true)
					end), cc.ScaleTo:create(0.1, 1)}))
					v:setVisible(false)
				end
			end
		end
	else
		local h_height = self:getContentSize().height/2
		self:setContentSize(cc.size(self:getContentSize(),h_height))
		self.roots[1]:setPositionY(self.roots[1]._h-h_height)
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_cishu_01"):setVisible(false)
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_reward"):setVisible(false)
	end

	local Panel_gx = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_gx")
	Panel_gx:removeAllChildren(true)
	local jsonFile = "sprite/spirte_saodang.json"
    local atlasFile = "sprite/spirte_saodang.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "effect", true, nil)
	animation.animationNameList = {"effect","effect_loop"}

	local current_food = dms.int(dms["npc"], self.npcId, npc.attack_need_food)

	if _ED.auto_raids_inof and  _ED.auto_raids_inof[3] and _ED.auto_raids_inof[4] and _ED.auto_raids_inof[5] and _ED.auto_raids_inof[3] >= _ED.auto_raids_inof[4] and _ED.auto_raids_inof[5] < _ED.auto_raids_inof[4]  then  --材料足够
		animation = sp.spine(jsonFile, atlasFile, 1, 0, "effect2", true, nil)
		animation.animationNameList = {"effect2","effect_loop2"}
		_ED.auto_raids_inof[3] = nil
		_ED.auto_raids_inof[4] = nil
		_ED.auto_raids_inof[5] = nil
	elseif current_food and zstring.tonumber(_ED.user_info.user_food) < current_food and nil ~= _ED.auto_raids_real_count and 0 ~= _ED.auto_raids_real_count  then
		animation = sp.spine(jsonFile, atlasFile, 1, 0, "effect3", true, nil)
		animation.animationNameList = {"effect3","effect_loop3"}
	end

	sp.initArmature(animation, false)
	local function changeActionCallback( armatureBack )
		-- local jsonFile = "sprite/spirte_saodang.json"
	 --    local atlasFile = "sprite/spirte_saodang.atlas"
	 --    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "effect_loop", true, nil)
	 --    Panel_gx:addChild(animation)
	 --    armatureBack:removeFromParent(true)
	end
	animation._invoke = changeActionCallback
	animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
	csb.animationChangeToAction(animation, 0, 1, false)
    Panel_gx:addChild(animation)

end

function MoppingResultEndCell:onEnterTransitionFinish()
	local tmpCsb = csb.createNode("duplicate/mopping_results_list_2.csb")
	local root = tmpCsb:getChildByName("root")
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)
	local Size = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_2"):getContentSize()
	self:setContentSize(Size)

	if root._h == nil then
		root._h = root:getPositionY()
	end
	root:setPositionY(root._h)

	if ccui.Helper:seekWidgetByName(root, "Panel_reward")._h == nil then
		ccui.Helper:seekWidgetByName(root, "Panel_reward")._h = ccui.Helper:seekWidgetByName(root, "Panel_reward"):getContentSize().height
	end
	ccui.Helper:seekWidgetByName(root, "Panel_reward"):setContentSize(cc.size(ccui.Helper:seekWidgetByName(root, "Panel_reward"):getContentSize().width,ccui.Helper:seekWidgetByName(root, "Panel_reward")._h))

	self:onUpdateDraw()
end

function MoppingResultEndCell:onExit()
end

function MoppingResultEndCell:init(sweep_reward, isHaveActivity, currentSceneType,npcid)
	self.sweep_reward = sweep_reward
	self.isHaveActivity = isHaveActivity
	self.currentSceneType = currentSceneType
	self.npcId = npcid
end

function MoppingResultEndCell:createCell()
	local cell = MoppingResultEndCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

