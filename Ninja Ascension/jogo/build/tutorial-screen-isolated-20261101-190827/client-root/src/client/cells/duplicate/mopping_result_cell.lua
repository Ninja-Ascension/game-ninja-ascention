----------------------------------------------------------------------------------------------------
-- 说明：Pve界面 扫荡成功的信息条
-------------------------------------------------------------------------------------------------------
MoppingResultCell = class("MoppingResultCellClass", Window)

function MoppingResultCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.sweep_reward = {}
	self.times = 0
	self.isOver = false
	self.delay = 0
	self.delayOve = 0
	self.isHaveActivity = false
	
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.ship.ship_icon_cell")

	local function init_mopping_result_cell_terminal()	
        -- 加速
        local mopping_result_cell_accelerate_terminal = {
            _name = "mopping_result_cell_accelerate",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)      
				instance.delayOve = -1
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(mopping_result_cell_accelerate_terminal)
        state_machine.init()
	end
	
	init_mopping_result_cell_terminal()
end

function MoppingResultCell:onUpdateDraw()

	--> print("我获得的物品数量：", self.sweep_reward.reward_prop_number)
	--> print("我获得的装备数量：", self.sweep_reward.reward_equipment_number)

	local resultListView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")
	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital then
		resultListView:removeAllItems()
	end
	local Panel_reward = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_reward")
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_cishu_01"):setString(string.format(_new_interface_text[36],zstring.tonumber(self.times)))	-- 标题
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_3"):setString("+"..self.sweep_reward.reward_experience)    -- 经验
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_5"):setString("+"..self.sweep_reward.reward_silver)    	-- 银币
	else
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_cishu_01"):setString(self.times)     					-- 标题
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_3"):setString(self.sweep_reward.reward_experience)    -- 经验
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_5"):setString(self.sweep_reward.reward_silver)    	-- 银币
	end

	local cell_list = {}
	
	
	if zstring.tonumber(self.sweep_reward.reward_prop_number) > 0 then
		for i = 1, tonumber(self.sweep_reward.reward_prop_number) do
			-- local cell = PropIconCell:createCell()
			-- cell:init(30, self.sweep_reward.reward_prop_item[i].prop_mould_id, self.sweep_reward.reward_prop_item[i].prop_number,true)
			local cell = ResourcesIconCell:createCell()
			if  _ED.auto_raids_inof and   tonumber(_ED.auto_raids_inof[2]) == tonumber(self.sweep_reward.reward_prop_item[i].prop_mould_id) and  _ED.auto_raids_inof[3]~=nil then 
				_ED.auto_raids_inof[3] = _ED.auto_raids_inof[3]+ tonumber(self.sweep_reward.reward_prop_item[i].prop_number)
			end
            cell:init(6, tonumber(self.sweep_reward.reward_prop_item[i].prop_number), self.sweep_reward.reward_prop_item[i].prop_mould_id, nil,nil,true,true)
			if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				table.insert(cell_list, cell)
			else
				resultListView:addChild(cell)	
			end
		end
	end

	if zstring.tonumber(self.sweep_reward.reward_equipment_number) > 0 then
		for i = 1, tonumber(self.sweep_reward.reward_equipment_number) do
			for j = 1,tonumber(self.sweep_reward.reward_equipment_item[i].equipment_number) do
				-- local cell = EquipIconCell:createCell()
				-- cell:init(14, nil, self.sweep_reward.reward_equipment_item[i].equipment_mould_id, nil,true)
				local cell = ResourcesIconCell:createCell()
            	cell:init(7, 1, self.sweep_reward.reward_equipment_item[i].equipment_mould_id,nil,nil,true,true)
				if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					table.insert(cell_list, cell)
				else
					resultListView:addChild(cell)
				end
			end
		end
	end

	if zstring.tonumber(self.sweep_reward.reward_ship_number) > 0 then
		for i = 1, tonumber(self.sweep_reward.reward_ship_number) do
			-- local cell = ShipHeadCell:createCell()
			-- cell:init(nil,13, self.sweep_reward.reward_ship_item[i].ship_mould_id,self.sweep_reward.reward_ship_item[i].ship_number,true)
			local cell = ResourcesIconCell:createCell()
            cell:init(13, tonumber(self.sweep_reward.reward_ship_item[i].ship_number), self.sweep_reward.reward_ship_item[i].ship_mould_id,nil,nil,true,true)
			if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				table.insert(cell_list, cell)
			else
				resultListView:addChild(cell)
			end
		end
	end

	if zstring.tonumber(self.sweep_reward.reward_matrix_number) > 0 then
		for i = 1, tonumber(self.sweep_reward.reward_matrix_number) do
			-- local cell = ShipHeadCell:createCell()
			-- cell:init(nil,13, self.sweep_reward.reward_ship_item[i].ship_mould_id,self.sweep_reward.reward_ship_item[i].ship_number,true)
			local cell = ResourcesIconCell:createCell()
            cell:init(66, tonumber(self.sweep_reward.reward_matrix_item[i].matrix_number), self.sweep_reward.reward_matrix_item[i].matrix_mould_id,nil,nil,true,true)
			if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				table.insert(cell_list, cell)
			else
				resultListView:addChild(cell)
			end
		end
	end

	if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
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
				local t = 0.25 + 0.25 * (i - 1)
				self.delay = t
				if self.delayOve == -1 then
					v:runAction(cc.Sequence:create({cc.DelayTime:create(0), cc.CallFunc:create(function ( sender )
						sender:setVisible(true)
					end)}))
				else
					v:runAction(cc.Sequence:create({cc.DelayTime:create(t/2), cc.ScaleTo:create(0.01, 1.05), cc.CallFunc:create(function ( sender )
						sender:setVisible(true)
					end), cc.ScaleTo:create(0.1, 1)}))
				end
				v:setVisible(false)
			end
		end
	end

	
	local getNum = 0	-- 获得物品数
	getNum = zstring.tonumber(self.sweep_reward.reward_prop_number) + zstring.tonumber(self.sweep_reward.reward_equipment_number)
		+ zstring.tonumber(self.sweep_reward.reward_ship_number)
	if getNum == 0 then
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_6"):setVisible(true)
	end
end

function MoppingResultCell:onEnterTransitionFinish()
	local tmpCsb = csb.createNode("duplicate/mopping_results_list.csb")
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

function MoppingResultCell:onExit()
end

function MoppingResultCell:init(times, sweep_reward, isHaveActivity)
	self.times = times
	self.sweep_reward = sweep_reward
	self.isHaveActivity = isHaveActivity
end

function MoppingResultCell:createCell()
	local cell = MoppingResultCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

