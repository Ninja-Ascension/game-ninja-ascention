----------------------------------------------------------------------------------------------------
-- 说明：50-61号活动
-- 单条活动记录
----------------------------------------------------------------------------------------------------
AdventureActivityCumulativeRecruit = class("AdventureActivityCumulativeRecruitClass", Window)
AdventureActivityCumulativeRecruit.__size = nil

function AdventureActivityCumulativeRecruit:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.activity = nil
	self.current_type = 0
	self.drawIndex = 0
	self.activityType = 0 -- 服务器活动ID
	--控件存储  重复调用的时候,需要从root中遍历(提高效率)
	self.receiveButton = nil
	self.describeText = nil
	self.zhanliText = nil 
	self.zhanli1Text = nil
	self.chongzhiButton = nil
	self.lingquImage = nil

	app.load("client.adventure.cells.prop.adventure_new_prop_activity_icon_cell")
	-- Initialize adventure hero icon cell state machine.
	local function init_adventure_activity_cumulative_recruit_terminal()
		
		local adventure_activity_cumulative_recruit_receive_terminal = {
            _name = "adventure_activity_cumulative_recruit_receive",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local cell = params._datas.cell
				local function responseActivityCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						response.node:onUpdateActivityData()
						response.node:updateDraw()
						app.load("client.adventure.reward.AdventureTipReward")
						local reward = getSceneReward(7)
						if reward ~= nil then 
							fwin:open(AdventureTipReward:new():init(reward), fwin._ui)
						end
 						

					end
				end
				local activityType = 0
				if zstring.tonumber(cell.current_type) == 2 then
					activityType = 50
				elseif zstring.tonumber(cell.current_type) == 3 then
					activityType = 51
				elseif zstring.tonumber(cell.current_type) == 4 then
					activityType = 52
				elseif zstring.tonumber(cell.current_type) == 5 then
					activityType = 53
				elseif zstring.tonumber(cell.current_type) == 6 then
					activityType = 54
				elseif zstring.tonumber(cell.current_type) == 7 then
					activityType = 55
				elseif zstring.tonumber(cell.current_type) == 8 then
					activityType = 56
				elseif zstring.tonumber(cell.current_type) == 9 then
					activityType = 57
				elseif zstring.tonumber(cell.current_type) == 10 then
					activityType = 58
				elseif zstring.tonumber(cell.current_type) == 11 then
					activityType = 7
				elseif zstring.tonumber(cell.current_type) == 12 then
					activityType = 17
				elseif zstring.tonumber(cell.current_type) == 14 then
					activityType = 59
				elseif zstring.tonumber(cell.current_type) == 15 then
					activityType = 60	
				elseif zstring.tonumber(cell.current_type) == 16 then
					activityType = 61	
				elseif zstring.tonumber(cell.current_type) == 17 then	
					activityType = 21
				elseif zstring.tonumber(cell.current_type) == 18 then	
					activityType = 24	
				elseif zstring.tonumber(cell.current_type) == 19 then	
					activityType = 45		
				elseif zstring.tonumber(cell.current_type) == 20 then	
					activityType = 69		
				elseif zstring.tonumber(cell.current_type) == 21 then	
					activityType = 73		
				end
				protocol_command.get_activity_reward.param_list = _ED.active_activity[activityType].activity_id.."\r\n"..zstring.tonumber(cell.drawIndex)-1
				NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, cell, responseActivityCallback, true, nil)
			   return true
            end,
            _terminal = nil,
            _terminals = nil
        }
				
		local adventure_activity_cumulative_buy_diamond_terminal = {
            _name = "adventure_activity_cumulative_buy_diamond",
            _init = function (terminal)
                app.load("client.adventure.shop.AdventureRecharge")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
                fwin:open(AdventureRecharge:new():init(cell), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local adventure_activity_cumulative_buy_diamond_update_terminal = {
            _name = "adventure_activity_cumulative_buy_diamond_update",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params
                cell:onUpdateActivityData()
				cell:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(adventure_activity_cumulative_buy_diamond_update_terminal)
        state_machine.add(adventure_activity_cumulative_buy_diamond_terminal)
		state_machine.add(adventure_activity_cumulative_recruit_receive_terminal)
        state_machine.init()
	end

	-- call func init adventure hero icon cell state machine.
	init_adventure_activity_cumulative_recruit_terminal()
end

function AdventureActivityCumulativeRecruit:updateDraw()
	local root = self.roots[1]

	self.zhanli1Text:setVisible(true)
	self.lingquImage:setVisible(false)
	
	self.describeText:setString("")
	local descriString = ""

	--_activity_list_Description
	-- print("-------typae:",self.current_type)
	-- debug.print_r(self.activity)
	if zstring.tonumber(self.current_type) == 11 or zstring.tonumber(self.current_type) == 12 
		or zstring.tonumber(self.current_type) == 20 or zstring.tonumber(self.current_type) == 17 or zstring.tonumber(self.current_type) == 19
		or zstring.tonumber(self.current_type) == 18 
	then 
		self.describeText:setString(string.format(_activity_list_Description[zstring.tonumber(self.current_type)],
			""..getResourceValueToStringForAdventure(self.activity.activityInfo_need_day)))
	elseif zstring.tonumber(self.current_type) == 5 or zstring.tonumber(self.current_type) == 8 or zstring.tonumber(self.current_type) == 2
		or zstring.tonumber(self.current_type) == 15 or zstring.tonumber(self.current_type) == 4 
		or zstring.tonumber(self.current_type) == 14 or zstring.tonumber(self.current_type) == 10 or zstring.tonumber(self.current_type) == 16
		or zstring.tonumber(self.current_type) == 3 
	 then 
		self.describeText:setString(string.format(_activity_list_Description[zstring.tonumber(self.current_type)],
			""..getResourceValueToStringForAdventure(self.activity.available_count)))
	elseif zstring.tonumber(self.current_type) == 6 then 
		self.describeText:setString(string.format(_activity_list_Description[zstring.tonumber(self.current_type)],
			""..self.activity.available_count))
	elseif zstring.tonumber(self.current_type) == 9 or zstring.tonumber(self.current_type) == 7  then 
		self.describeText:setString(self.activity.activityInfo_name)
	end
	
	local guoqiImage = ccui.Helper:seekWidgetByName(root, "Image_guoqi")
	guoqiImage:setVisible(false)
	self.chongzhiButton:setVisible(false)	
	if zstring.tonumber(self.current_type) == 6 
		or zstring.tonumber(self.current_type) == 7 
		then
		self.zhanliText:setVisible(false)
		self.zhanli1Text:setVisible(false)
		if zstring.tonumber(self.current_type) == 6 then
			local content = zstring.split(self.activity.available_count,"-")
			local sceneIndex = 0
			for i, v in pairs(_ED.scene_current_state) do
				if zstring.tonumber(v) == -1 then
					sceneIndex = i -1
					break
				end
			end
		
			if zstring.tonumber(self.activity.activityInfo_isReward) == 1 then--不可领取
				--root:setColor(cc.c3b(150, 150, 150))
				self.receiveButton:setVisible(false)
				self.lingquImage:setVisible(true)
				self.receiveButton:setColor(cc.c3b(150, 150, 150))
				self.receiveButton:setTouchEnabled(false)
			else
				if sceneIndex > zstring.tonumber(content[1]) or (sceneIndex >= zstring.tonumber(content[1]) and zstring.tonumber(_ED.scene_current_state[sceneIndex]) >= zstring.tonumber(content[2])) then--条件达成
					--root:setColor(cc.c3b(255, 255, 255))
					self.receiveButton:setVisible(true)
					self.receiveButton:setColor(cc.c3b(255, 255, 255))
					self.receiveButton:setTouchEnabled(true)
				else
					--root:setColor(cc.c3b(255, 255, 255))
					self.receiveButton:setVisible(true)
					self.receiveButton:setColor(cc.c3b(150, 150, 150))
					self.receiveButton:setTouchEnabled(false)
				end
			end
		elseif zstring.tonumber(self.current_type) == 7 then
			-- if zstring.tonumber(_ED.arena_info[1].arena_buy_number) ~= 0 then
			-- 	if zstring.tonumber(_ED.arena_info[1].arena_buy_number) > zstring.tonumber(self.activity.available_count) then
			-- 		root:setColor(cc.c3b(150, 150, 150))
			-- 	else	
			-- 		root:setColor(cc.c3b(255, 255, 255))
			-- 	end
			-- else
			-- 	root:setColor(cc.c3b(150, 150, 150))
			-- end
		end
	else
		--self.describeText:setString(string.format(_activity_list_Description[zstring.tonumber(self.current_type)],)
		self.zhanli1Text:setVisible(true)

		if zstring.tonumber(self.current_type) == 11 or zstring.tonumber(self.current_type) == 12 
		or zstring.tonumber(self.current_type) == 17 or zstring.tonumber(self.current_type) == 18 or zstring.tonumber(self.current_type) == 20 then
			local existing = nil
			if zstring.tonumber(self.current_type) == 11 or zstring.tonumber(self.current_type) == 17 
			or zstring.tonumber(self.current_type) == 18 then
				if zstring.tonumber(self.current_type) == 18 then
					existing = _ED.active_activity[24].activity_login_day
				elseif zstring.tonumber(self.current_type) == 11 then
					existing = _ED.active_activity[7].total_recharge_count
				elseif zstring.tonumber(self.current_type) == 17 then
					existing = _ED.active_activity[21].total_recharge_count
					
				else 
					existing = _ED.recharge_precious_number
				end
			elseif zstring.tonumber(self.current_type) == 12 or zstring.tonumber(self.current_type) == 20 then
				if  zstring.tonumber(self.current_type) == 12 then 
					existing = _ED.active_activity[17].total_recharge_count
				else
					existing = _ED.active_activity[69].total_recharge_count
				end
				
				--self.describeText:setString(descriString .. _All_tip_string_info._crystalName )
			end
			--self.zhanliText:setString(getResourceValueToStringForAdventure(self.activity.activityInfo_need_day))
			self.zhanli1Text:setString(getResourceValueToStringForAdventure(existing).."/"..getResourceValueToStringForAdventure(self.activity.activityInfo_need_day))
			if zstring.tonumber(self.activity.activityInfo_isReward) == 1 then--不可领取
				--root:setColor(cc.c3b(150, 150, 150))
				self.receiveButton:setVisible(false)
				self.receiveButton:setColor(cc.c3b(150, 150, 150))
				self.receiveButton:setTouchEnabled(false)
				self.lingquImage:setVisible(true)
			else
				if zstring.tonumber(existing) >= zstring.tonumber(self.activity.activityInfo_need_day) then
					--root:setColor(cc.c3b(255, 255, 255))
					self.receiveButton:setVisible(true)
					self.receiveButton:setColor(cc.c3b(255, 255, 255))
					self.receiveButton:setTouchEnabled(true)

				else
					--root:setColor(cc.c3b(255, 255, 255))
					self.receiveButton:setVisible(true)
					self.receiveButton:setColor(cc.c3b(150, 150, 150))
					self.receiveButton:setTouchEnabled(false)
					if zstring.tonumber(self.current_type) == 11 then
						self.chongzhiButton:setVisible(true)	
						self.receiveButton:setVisible(false)
					end
				end
			end
		elseif zstring.tonumber(self.current_type) == 19 then
			--self.describeText:setString(_activity_name[self.current_type] .. self.activity.activityInfo_need_day .. _All_tip_string_info._crystalName  )
			self.zhanli1Text:setString(getResourceValueToStringForAdventure(_ED.active_activity[45].activity_Info[self.drawIndex].completed_count).."/"..getResourceValueToStringForAdventure(_ED.active_activity[45].activity_Info[self.drawIndex].available_count))
			if zstring.tonumber(self.activity.activityInfo_isReward) == -1 then--不可领取
				--root:setColor(cc.c3b(150, 150, 150))
				self.receiveButton:setVisible(false)
				self.chongzhiButton:setVisible(true)
			elseif zstring.tonumber(self.activity.activityInfo_isReward) == 0 then--可以领取
				--root:setColor(cc.c3b(255, 255, 255))
				self.receiveButton:setVisible(true)
				self.receiveButton:setColor(cc.c3b(255, 255, 255))
				self.receiveButton:setTouchEnabled(true)
				self.chongzhiButton:setVisible(false)
			elseif zstring.tonumber(self.activity.activityInfo_isReward) == 1 then--已经领取
				--root:setColor(cc.c3b(255, 255, 255))
				self.receiveButton:setVisible(false)
				self.chongzhiButton:setVisible(false)
			end
		elseif  zstring.tonumber(self.current_type) == 21 then 
			if zstring.tonumber(self.activity.activityInfo_isReward) == -1 then-- 过期
				
				self.receiveButton:setVisible(false)
				self.chongzhiButton:setVisible(false)
				guoqiImage:setVisible(true)
			elseif zstring.tonumber(self.activity.activityInfo_isReward) == 0 then--不能领取
			
				self.receiveButton:setVisible(true)
				self.receiveButton:setColor(cc.c3b(150, 150, 150))
				self.receiveButton:setTouchEnabled(false)
				self.chongzhiButton:setVisible(false)
			elseif zstring.tonumber(self.activity.activityInfo_isReward) == 1 then--可以领取
				self.receiveButton:setVisible(true)
				self.receiveButton:setColor(cc.c3b(255, 255, 255))
				self.receiveButton:setTouchEnabled(true)
				self.chongzhiButton:setVisible(false)
			elseif zstring.tonumber(self.activity.activityInfo_isReward) == 2 then--已经领取
				self.lingquImage:setVisible(true)
				self.receiveButton:setVisible(false)
				self.chongzhiButton:setVisible(false)
			end
		else
			--self.zhanliText:setString(getResourceValueToStringForAdventure(self.activity.available_count))
			if zstring.tonumber(self.current_type) == 8 then
				self.activity.completed_count = _ED.user_info.fight_capacity
			end
			self.zhanli1Text:setString(getResourceValueToStringForAdventure(self.activity.completed_count).."/"..getResourceValueToStringForAdventure(self.activity.available_count))
			if zstring.tonumber(self.activity.activityInfo_isReward) == 1 then--不可领取
				--root:setColor(cc.c3b(150, 150, 150))
				self.receiveButton:setVisible(false)
				self.lingquImage:setVisible(true)
				self.receiveButton:setColor(cc.c3b(150, 150, 150))
				self.receiveButton:setTouchEnabled(false)
			else
				if zstring.tonumber(self.activity.available_count) <= zstring.tonumber(self.activity.completed_count) then
					--root:setColor(cc.c3b(255, 255, 255))
					self.receiveButton:setVisible(true)
					self.receiveButton:setColor(cc.c3b(255, 255, 255))
					self.receiveButton:setTouchEnabled(true)
				else
					--root:setColor(cc.c3b(255, 255, 255))
					self.receiveButton:setVisible(true)
					self.receiveButton:setColor(cc.c3b(150, 150, 150))
					self.receiveButton:setTouchEnabled(false)
				end
			end
		end	
	end

	if zstring.tonumber(self.current_type) == 21 then 
		local infoArr = zstring.split("" ..self.activity.activityInfo_need_day, "-")
		self.zhanli1Text:setString("")	

		local _time = "" .. infoArr[2] .. tipStringInfo_time_info[2] ..infoArr[3] ..tipStringInfo_time_info[10]
		self.describeText:setString(string.format(_activity_list_Description[zstring.tonumber(self.current_type)],_time))
	end
	if zstring.tonumber(self.current_type) == 7 then
		self.receiveButton:setVisible(false)
	end

	local ListView_reward_1 = ccui.Helper:seekWidgetByName(root, "ListView_reward_1")
	ListView_reward_1:removeAllItems()
	if zstring.tonumber(self.activity.activityInfo_silver) > 0 then --银币
		local cell = adventureNewSmallPropActivityCell:createCell()
		cell:init(0, {resource_type = 1} , "" .. getResourceValueToStringForAdventure(self.activity.activityInfo_silver), nil, 0, 0,ListView_reward_1)
		ListView_reward_1:addChild(cell)
	end
	if zstring.tonumber(self.activity.activityInfo_gold) > 0 then --金币
		local cell = adventureNewSmallPropActivityCell:createCell()
		cell:init(0, {resource_type = 2} , "" .. getResourceValueToStringForAdventure(self.activity.activityInfo_gold), nil, 0, 0,ListView_reward_1)
		ListView_reward_1:addChild(cell)
	end
	if zstring.tonumber(self.activity.activityInfo_honour) > 0 then --声望
		local cell = adventureNewSmallPropActivityCell:createCell()
		cell:init(0, {resource_type = 3} , "" .. getResourceValueToStringForAdventure(self.activity.activityInfo_honour), nil, 0, 0,ListView_reward_1)
		ListView_reward_1:addChild(cell)
	end
	
	if zstring.tonumber(self.activity.activityInfo_general_soul) > 0 then --荣耀碎片
		local cell = adventureNewSmallPropActivityCell:createCell()
		cell:init(0, {resource_type = 4} , "" .. getResourceValueToStringForAdventure(self.activity.activityInfo_general_soul), nil, 0, 0,ListView_reward_1)
		ListView_reward_1:addChild(cell)
	end
	
	if zstring.tonumber(self.activity.activityInfo_prop_count) > 0 then --道具
		for i, v in pairs(self.activity.activityInfo_prop_info) do	
			local cell = adventureNewSmallPropActivityCell:createCell()
			cell:init(0, {mould_id = v.propMould} , "" .. getResourceValueToStringForAdventure(v.propMouldCount), nil, 0, 0,ListView_reward_1)
			ListView_reward_1:addChild(cell)
		end
	end
	
	if zstring.tonumber(self.activity.activityInfo_equip_count) > 0 then --装备
		for i, v in pairs(self.activity.activityInfo_equip_info) do	
			local cell = adventureNewSmallPropActivityCell:createCell()
			cell:init(4, {id = v.equipMould}, 0, 4,nil,0,ListView_reward_1)
			ListView_reward_1:addChild(cell)
		end
	end

	self.zhanliText:setVisible(false)
	ListView_reward_1:requestRefreshView()
end

function AdventureActivityCumulativeRecruit:onInit()
	local root = cacher.createUIRef("list/list_zhanli_up.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

	local image_icon = ccui.Helper:seekWidgetByName(root, "Image_24")
	image_icon:setVisible(false)

 	self.receiveButton = ccui.Helper:seekWidgetByName(root, "Button_receive")
	self.describeText = ccui.Helper:seekWidgetByName(root, "Text_7")
	self.zhanliText = ccui.Helper:seekWidgetByName(root, "Text_zhanli") 
	self.zhanli1Text = ccui.Helper:seekWidgetByName(root, "Text_zhanli_1")
	self.chongzhiButton = ccui.Helper:seekWidgetByName(root, "Button_chongzhi")
	self.lingquImage = ccui.Helper:seekWidgetByName(root, "Image_lingqu")
	self.describeText:setString("")
	self.zhanliText:setString("")
	self.zhanli1Text:setString("")
	
	fwin:addTouchEventListener(self.receiveButton,       nil, 
	{
		terminal_name = "adventure_activity_cumulative_recruit_receive",
		cell = self,        
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)

	fwin:addTouchEventListener(self.chongzhiButton,       nil, 
	{
		terminal_name = "adventure_activity_cumulative_buy_diamond",
		cell = self,        
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	-- Get size for root node.
	if AdventureActivityCumulativeRecruit.__size == nil then
		local size = root:getContentSize()
		AdventureActivityCumulativeRecruit.__size = size
	end
	
	self:updateDraw()
end

function AdventureActivityCumulativeRecruit:onUpdateActivityData()
	if _ED.active_activity[self.activityType] ~= nil and _ED.active_activity[self.activityType].activity_Info[self.drawIndex] ~= nil then 
		--- 有值了,重新赋值
		self.activity = _ED.active_activity[self.activityType].activity_Info[self.drawIndex]
	end
end

function AdventureActivityCumulativeRecruit:onExit()
	cacher.freeRef("list/list_zhanli_up.csb", self.roots[1])
end

function AdventureActivityCumulativeRecruit:init(activity,current_type,drawIndex,serType)
	self.activity = activity
	self.current_type = current_type
	self.drawIndex = drawIndex
	self.activityType = tonumber(serType)
	--if drawIndex ~= nil and drawIndex < 5 then
	self:onInit()
--	end
	
	-- local activityType = 0
	-- if zstring.tonumber(current_type) == 2 then
	-- 	activityType = 50
	-- elseif zstring.tonumber(current_type) == 3 then
	-- 	activityType = 51
	-- elseif zstring.tonumber(current_type) == 4 then
	-- 	activityType = 52
	-- elseif zstring.tonumber(current_type) == 5 then
	-- 	activityType = 53
	-- elseif zstring.tonumber(current_type) == 6 then
	-- 	activityType = 54
	-- elseif zstring.tonumber(current_type) == 7 then
	-- 	activityType = 55
	-- elseif zstring.tonumber(current_type) == 8 then
	-- 	activityType = 56
	-- elseif zstring.tonumber(current_type) == 9 then
	-- 	activityType = 57
	-- elseif zstring.tonumber(current_type) == 10 then
	-- 	activityType = 58
	-- elseif zstring.tonumber(current_type) == 11 then
	-- 	activityType = 7
	-- elseif zstring.tonumber(current_type) == 12 then
	-- 	activityType = 17
	-- elseif zstring.tonumber(current_type) == 14 then
	-- 	activityType = 59
	-- elseif zstring.tonumber(current_type) == 15 then
	-- 	activityType = 60	
	-- elseif zstring.tonumber(current_type) == 16 then
	-- 	activityType = 61	
	-- elseif zstring.tonumber(current_type) == 17 then	
	-- 	activityType = 21
	-- elseif zstring.tonumber(current_type) == 18 then	
	-- 	activityType = 24	
	-- elseif zstring.tonumber(current_type) == 19 then	
	-- 	activityType = 45		
	-- end
	
	self:setContentSize(AdventureActivityCumulativeRecruit.__size)
	return self
end

function AdventureActivityCumulativeRecruit:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureActivityCumulativeRecruit:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("list/list_zhanli_up.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureActivityCumulativeRecruit:createCell()
	local cell = AdventureActivityCumulativeRecruit:new()
	cell:registerOnNodeEvent(cell)
	return cell
end