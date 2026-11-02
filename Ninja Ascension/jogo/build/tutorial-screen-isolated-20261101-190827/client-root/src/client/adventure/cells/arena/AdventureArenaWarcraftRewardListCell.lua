----------------------------------------------------------------------------------------------------
-- 说明：排位赛奖励列表
----------------------------------------------------------------------------------------------------
AdventureArenaWarcraftRewardListCell = class("AdventureArenaWarcraftRewardListCellClass", Window)
AdventureArenaWarcraftRewardListCell.__size = nil

function AdventureArenaWarcraftRewardListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.index = 1
	self.current_type = 1 --段位奖励  2 连胜奖励
	self.is_digimon = false --项目控制，是否是数码宝贝
	-- Initialize adventure hero list cell state machine.
	local function init_adventure_warcraft_reward_list_cell_terminal()
		local adventure_arena_warcraft_get_list_reward_terminal = {
            _name = "adventure_arena_warcraft_get_list_reward",
            _init = function (terminal)
                app.load("client.adventure.reward.AdventureTipReward")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				local index = cell.current_type 
				if cell.current_type == 1 then 
					local function responseGetRewardCallBack(response)
	                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	                       	if response.node ~= nil and response.node.roots[1] ~= nil then
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
	                    		state_machine.excute("adventure_arena_warcraft_reward_tip_update", 0, "")
	                    		state_machine.excute("adventure_arena_warcraft_more_reward_update_tip", 0, "")

	                       		response.node:updateDrawButtonState()
	                       	end
	                    end
                	end
 					
               	 	protocol_command.warcraft_get_reward.param_list = "" .. cell.index
                	NetworkManager:register(protocol_command.warcraft_get_reward.code, nil, nil, nil, cell, responseGetRewardCallBack, false, nil)
            	else
					local function responseGetWinRewardCallBack(response)
	                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	                       	if response.node ~= nil and response.node.roots[1] ~= nil then
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
	              
	                    		state_machine.excute("adventure_arena_warcraft_reward_tip_update", 0, "")
	                    		state_machine.excute("adventure_arena_warcraft_more_reward_update_tip", 0, "")
	                       		response.node:updateDrawButtonState()
	                       	end
                       		state_machine.excute("adventure_arena_warcraft_list_refresh_win_counts", 0, "")
	                    end
	                end
 
	                protocol_command.draw_win_count_reward.param_list = "" .. cell.index
	                NetworkManager:register(protocol_command.draw_win_count_reward.code, nil, nil, nil, cell, responseGetWinRewardCallBack, false, nil)	
				end 
            end,
            _terminal = nil,
            _terminals = nil
        }
	
        state_machine.add(adventure_arena_warcraft_get_list_reward_terminal)

        state_machine.init()
	end

	-- call func init adventure hero list cell state machine.
	init_adventure_warcraft_reward_list_cell_terminal()
end

function AdventureArenaWarcraftRewardListCell:updateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local title_Text = ccui.Helper:seekWidgetByName(root, "Text_biaoti")
	self.is_digimon = false
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_warship_girl_b 
		then 
		self.is_digimon = true
	else
		self.is_digimon = false
	end
	if self.current_type == 1 then 
		local rewardlist = dms.string(dms["warcraft_mould"], self.index, warcraft_mould.rank_reward)
	    local list_arr = zstring.split("".. rewardlist,"|")
		local title_name = dms.string(dms["warcraft_mould"], self.index, warcraft_mould.title_name)
		if self.is_digimon == true then 
			title_Text:setString(string.format(warcraft_tip[2],title_name))
		else
			title_Text:setString(string.format(_string_piece_info[441],title_name))	
		end
		
		for i=1,3 do
	        local daojuPanel = ccui.Helper:seekWidgetByName(root, "Panel_daoju_" .. i)
	        daojuPanel:removeAllChildren(true)
	        if i <= #list_arr then 
	            local itemList = zstring.split("".. list_arr[i],",")
	            if zstring.tonumber(itemList[1]) == 1 then 
	                --金币
	                local cell = nil
	                if self.is_digimon == true then 
	                	app.load("client.cells.prop.prop_money_icon")
	                	cell = propMoneyIcon:createCell()
	                	cell:init("1",itemList[3],nil)
	                else
						cell = adventureNewSmallPropIconCell:createCell()
	                	cell:init(0, {resource_type = 1} , "" .. getResourceValueToStringForAdventure(itemList[3]), nil, 0, 0)
	                end
	                
	                daojuPanel:addChild(cell)
	            end

	            if zstring.tonumber(itemList[1]) == 5 then 
	            	local cell = nil
	            	if self.is_digimon == true then 
	            		local cell = ResourcesIconCell:createCell()
						cell:init(5, tonumber(itemList[3]),-1)
	            		daojuPanel:addChild(cell)
	            	end
	            end
	            if zstring.tonumber(itemList[1]) == 6 then 
	                --道具
	                local cell = adventureNewSmallPropIconCell:createCell()
	                cell:init(0, {mould_id = itemList[2]} ,"" .. getResourceValueToStringForAdventure(itemList[3]), nil, 0, 0 )
	                daojuPanel:addChild(cell)
	            end
	            if zstring.tonumber(itemList[1]) == 4 then 
	                --荣誉碎片
	                local cell = adventureNewSmallPropIconCell:createCell()
	                cell:init(0, {resource_type = 4} , "" .. getResourceValueToStringForAdventure(itemList[3]), nil, 0, 0)
	                daojuPanel:addChild(cell)
	            end
	        end
	    end
	else
		--连胜奖励
		local rewardlist = dms.string(dms["warcraft_win_reward"], self.index, warcraft_win_reward.win_reward)
	    local list_arr = zstring.split("".. rewardlist,"|")
		local title_name = dms.int(dms["warcraft_win_reward"], self.index, warcraft_win_reward.win_count)
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh 
			or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_warship_girl_b 
			then 
			title_Text:setString(string.format(warcraft_tip[26],title_name))
		else
			title_Text:setString(string.format(_string_piece_info[467],title_name))	
		end
		
		for i=1,3 do
	        local daojuPanel = ccui.Helper:seekWidgetByName(root, "Panel_daoju_" .. i)
	        daojuPanel:removeAllChildren(true)
	        if i <= #list_arr then 
	            local itemList = zstring.split("".. list_arr[i],",")
	            if zstring.tonumber(itemList[1]) == 1 then 
	                --金币
	                local cell = nil
	                if self.is_digimon == true then 
	                	app.load("client.cells.prop.prop_money_icon")
	                	cell = propMoneyIcon:createCell()
	                	cell:init("1",itemList[3],nil)
	                else
	                	cell = adventureNewSmallPropIconCell:createCell()
	                	cell:init(0, {resource_type = 1} , "" .. getResourceValueToStringForAdventure(itemList[3]), nil, 0, 0)
	                end
	                
	                daojuPanel:addChild(cell)
	            end
	            if zstring.tonumber(itemList[1]) == 29 then 
	            	--胜点
	            	app.load("client.cells.prop.prop_money_icon")
                	cell = propMoneyIcon:createCell()
                	cell:init("29",itemList[3],nil)
                	daojuPanel:addChild(cell)
	            end
	            if zstring.tonumber(itemList[1]) == 5 then 
	            	local cell = nil
	            	if self.is_digimon == true then 
	            		local cell = ResourcesIconCell:createCell()
						cell:init(5, tonumber(itemList[3]),-1)
	            		daojuPanel:addChild(cell)
	            	end
	            end
	            if zstring.tonumber(itemList[1]) == 6 then 
	                --道具
	                local cell = adventureNewSmallPropIconCell:createCell()
	                cell:init(0, {mould_id = itemList[2]} ,"" .. getResourceValueToStringForAdventure(itemList[3]), nil, 0, 0 )
	                daojuPanel:addChild(cell)
	            end
	            if zstring.tonumber(itemList[1]) == 4 then 
	                --荣誉碎片
	                local cell = adventureNewSmallPropIconCell:createCell()
	                cell:init(0, {resource_type = 4} , "" .. getResourceValueToStringForAdventure(itemList[3]), nil, 0, 0)
	                daojuPanel:addChild(cell)
	            end
	        end
	    end
	end
    self:updateDrawButtonState()
end

function AdventureArenaWarcraftRewardListCell:updateDrawButtonState()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	--_ED.warcraft_info.current_history_best_title = npos(list) -- 历史最高称号
	local rewardButton = ccui.Helper:seekWidgetByName(root, "Button_4")
	local getReward =  ccui.Helper:seekWidgetByName(root, "Image_8")
	getReward:setVisible(false)
	rewardButton:setColor(cc.c3b(255, 255, 255))
	rewardButton:setTouchEnabled(true)
	rewardButton:setVisible(true)
	if self.current_type == 1 then 
	
		local states = zstring.split("" .. _ED.warcraft_info.get_reward_states, ",")
		local current_state = states[self.index]
		if self.index <= zstring.tonumber(_ED.warcraft_info.current_history_best_title) then 
			--可以领取
			if zstring.tonumber(current_state) == 1  then  -- 0 未领取 1 已经领取
				--已经领取
				getReward:setVisible(true)
				rewardButton:setVisible(false)
			else
				getReward:setVisible(false)
			end
		else
			--级别未满不能领取
			rewardButton:setColor(cc.c3b(150, 150, 150))
			rewardButton:setTouchEnabled(false)
		end
	else
		local states = zstring.split("" .. _ED.warcraft_info.current_win_reward_buy_states, ",")
		local current_state = states[self.index]
		local current_win = dms.int(dms["warcraft_win_reward"], self.index, warcraft_win_reward.win_count)
		if current_win <= zstring.tonumber(_ED.warcraft_info.current_win_max_count) then 
			--可以领取
			if zstring.tonumber(current_state) == 1  then  -- 0 未领取 1 已经领取
				--已经领取
				getReward:setVisible(true)
				rewardButton:setVisible(false)
			else
				getReward:setVisible(false)
			end
		else
			--级别未满不能领取
			rewardButton:setColor(cc.c3b(150, 150, 150))
			rewardButton:setTouchEnabled(false)
		end
	end
	
	
end
function AdventureArenaWarcraftRewardListCell:onInit()
	self.roots = {}
	local root = cacher.createUIRef("list/list_pws_phb_0.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"),       nil, 
	{
		terminal_name = "adventure_arena_warcraft_get_list_reward",
		cell = self,        
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)

	
	-- Get size for root node.
	if AdventureArenaWarcraftRewardListCell.__size == nil then
		local size = root:getContentSize()
		AdventureArenaWarcraftRewardListCell.__size = size
	end

	self:updateDraw(self.current_type)
end

function AdventureArenaWarcraftRewardListCell:onExit()
	cacher.freeRef("list/list_pws_phb_0.csb", self.roots[1])
	self.roots = nil
end

function AdventureArenaWarcraftRewardListCell:init(show_type,drawIndex)
	self.current_type = show_type
	self.index = drawIndex
	if drawIndex ~= nil and drawIndex < 8 then
		self:onInit()
	end

	self:setContentSize(AdventureArenaWarcraftRewardListCell.__size)
	return self
end

function AdventureArenaWarcraftRewardListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureArenaWarcraftRewardListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("list/list_pws_phb_0.csb", root)
	
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureArenaWarcraftRewardListCell:createCell()
	local cell = AdventureArenaWarcraftRewardListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

