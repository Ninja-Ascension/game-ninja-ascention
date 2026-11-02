-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE场景星数奖励面板
-------------------------------------------------------------------------------------------------------
PVESceneStarReward = class("PVESceneStarRewardClass", Window)

-- EL BOTON GRIS SIRVE PARA DOS ESTADOS. `Button_receive_ylq` se enseña
-- tanto con las estrellas sin alcanzar como con el cofre ya cobrado; lo
-- que los distinguia eran dos imagenes encima (ImageView_11991 «领取» /
-- ImageView_11990 «已领取»), y esas imagenes ya no existen en el paquete
-- (images/ui/text/lingqu.png falta; la otra es Default/ImageFile.png). Lo
-- que se ve es el TITULO del boton, y los .csb de es/de/fr/ko lo traducen
-- como «ya cobrado» («Reclamado») donde el base y zh_CN dicen «Collect» /
-- «领取» (duplicate/copy_the_award.csb). Resultado: «Recompensa de Nivel
-- Estrella 3/12» ofrecia «Reclamado» sin haber cobrado nada.
-- Con las estrellas sin alcanzar, el boton gris lleva el rotulo del boton
-- activo (Label_12223_0), que es lo que hace el diseño base.
local function pve_reward_grey_button_not_reached(root)
	local label = ccui.Helper:seekWidgetByName(root, "Label_12223_0")
	local button = ccui.Helper:seekWidgetByName(root, "Button_receive_ylq")
	if label ~= nil and button ~= nil and label:getString() ~= "" then
		button:setTitleText(label:getString())
	end
end

function PVESceneStarReward:ctor()
    self.super:ctor()
    self.roots = {}
	
    self.sceneId = 1
    self.rewardIndex = 3
	self.uiIndex = 1
	self.starReward = 0
	
	self.openState = nil
	self.cacheTipsText = nil
	
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.duplicate.pve.PVERewardPreviewPanel")

	self.reworld_sorting = {}

    -- Initialize PVESceneStarReward page state machine.
    local function init_pve_scene_star_reward_terminal()	
		-- 关闭场景星级奖励窗口
		local pve_scene_star_reward_close_window_terminal = {
            _name = "pve_scene_star_reward_close_window",
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

		--领取场景星级奖励
		local pve_scene_star_reward_draw_reward_terminal = {
            _name = "pve_scene_star_reward_draw_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				local sceneId = params._datas._sceneId
				local rewardIndex = params._datas._rewardIndex
				local reworld_sorting = instance.reworld_sorting
				local function responseDrawStarRewardCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- 领取成功改变宝箱显示状态
						--> print("领取成功！！！！！！！！！！！")
						--> print("ttttttttttttttttttttttttttttttttttttttttt", rewardIndex)
						local pveReward = zstring.split(dms.string(dms["pve_scene"], sceneId, pve_scene.star_reward_id), ",")
						-- local library = dms.string(dms["scene_reward"], tonumber(pveReward[rewardIndex + 1]), scene_reward.reward_prop)
						-- local rewardProp = zstring.split(library, "|")

						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                            then
							app.load("client.reward.DrawRareReward")
							local getRewardWnd = DrawRareReward:new()
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							then
								getRewardWnd:init(0,nil,reworld_sorting)
							else
								getRewardWnd:init(0)
							end
							fwin:open(getRewardWnd, fwin._ui)
						else
							local previewWnd = PVERewardPreviewPanel:new()
							previewWnd:init(tonumber(pveReward[rewardIndex + 1]))
							fwin:open(previewWnd, fwin._windows)
						end
						
						local is2002 = false
						if __lua_project_id == __lua_project_warship_girl_a 
						or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
						or __lua_project_id == __lua_project_koone
						then
							if dev_version >= 2002 then
								is2002 = true
							end
						end
						if true == is2002 then
							state_machine.excute("duplicate_pve_secondary_scene_star_box_update_panel",0 ,"event duplicate_pve_secondary_scene_star_box_update_panel.")
						else
							state_machine.excute("pve_star_cheat_update_panel",0 ,"event pve_star_cheat_update_panel.")
						end

						fwin:close(response.node)
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							state_machine.excute("lpve_scene_updeteinfo",0,"")--刷新顶部信息
						end
						state_machine.excute("lpve_main_scene_updeteinfo",0,"")
						state_machine.excute("lduplicate_window_show_one_click", 0, nil) -- 刷新一键领取宝箱按钮
					else
						--> print("领取失败！！！！！！！！！！！")
					end
				end
				
				--> print("领取奖励的索引", rewardIndex)
				protocol_command.draw_scene_rewad.param_list = ""..sceneId .."\r\n" .. rewardIndex
				NetworkManager:register(protocol_command.draw_scene_rewad.code, nil, nil, nil, instance, responseDrawStarRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(pve_scene_star_reward_close_window_terminal)
        state_machine.add(pve_scene_star_reward_draw_reward_terminal)
        state_machine.init()
    end
    
    -- call func init PVESceneStarReward state machine.
    init_pve_scene_star_reward_terminal()
end

function PVESceneStarReward:onUpdate(dt)
	if nil ~= self._focus then
		self._interval = self._interval + dt
		if self._interval > 0.5 then
			local datas = self._focus._datas
			local focus = self._focus
			self._focus = nil
			self._interval = 0

			if datas.item_type == 1 
				or datas.item_type == 2
				then
				local cell = propMoneyInfo:new()
				cell:init("" .. datas.item_info, nil, focus)
				fwin:open(cell, fwin._windows)
			elseif datas.item_type == 6 then
				local cell = propInformation:new()
				cell:init(datas.item_info, 1, focus)
				fwin:open(cell, fwin._windows)
			end
		end
	end
end

function PVESceneStarReward:addRewardButtonEvent(but, itemType, info)
	if  __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
    else
    	return
    end
	local function rewardTouchCallback(sender, eventType)
        if eventType == ccui.TouchEventType.began then
        	sender._self._focus = sender
        	sender._self._interval = 0
		elseif eventType == ccui.TouchEventType.moved then
		elseif eventType == ccui.TouchEventType.ended 
			or eventType == ccui.TouchEventType.canceled
			then
			sender._self._focus = nil
			sender._self._interval = 0

			local datas = sender._datas
			if datas.item_type == 1 
				or datas.item_type == 2
				then
				fwin:close(fwin:find("propMoneyInfoClass"))
			elseif datas.item_type == 6 then
				fwin:close(fwin:find("propInformationClass"))
			end
		end
    end
    but:addTouchEventListener(rewardTouchCallback)

    but._self = self
    but._datas = {
		terminal_name = "lpve_npc_reward_box_open_reward_preview_window", 
		terminal_state = 0,
		item_type = itemType,
		item_info = info,
		isPressedActionEnabled = true
	}
end

function PVESceneStarReward:onUpdateDraw()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
		or __lua_project_id == __lua_project_l_naruto
		then
		self:onUpdateDrawEx()
		return
	end
	-- 显示当前关卡的奖励数据
	--绘制奖励
	local root = self.roots[1]
	local rewardItem = {
		"Panel_1",
		"Panel_2",
		"Panel_3",
		"Panel_403"
		}
	
	local listViewAward_parent = ccui.Helper:seekWidgetByName(root, "Panel_1217"):getChildByName("ImageView_1226")
	local listViewAward = listViewAward_parent:getChildByName("ListView_award")
	listViewAward:removeAllItems()
	local pveReward = zstring.split(dms.string(dms["pve_scene"], self.sceneId, pve_scene.star_reward_id), ",")
	local rewardID = tonumber(pveReward[self.uiIndex])
	local rewardMoney = dms.int(dms["scene_reward"], rewardID, scene_reward.reward_silver)
	local rewardGold = dms.int(dms["scene_reward"], rewardID, scene_reward.reward_gold)
	local rewardHonor = dms.int(dms["scene_reward"], rewardID, scene_reward.reward_honor)
	local rewardSoul = dms.int(dms["scene_reward"], rewardID, scene_reward.reward_soul)
	local rewardJade = dms.int(dms["scene_reward"], rewardID, scene_reward.reward_jade)
	local rewardItemListStr = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_prop)
	local rewardEquListStr = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_equipment)
	local rewardShipListStr = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_ship)
	local rewardTotal = 1

	if rewardMoney > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(1, rewardMoney, -1)
		--local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		listViewAward:addChild(reward)
		reward:showName(-1,1)
		rewardTotal = rewardTotal + 1

		local Panel_prop = ccui.Helper:seekWidgetByName(reward.roots[1], "Panel_prop")
		self:addRewardButtonEvent(Panel_prop, 1, reward.current_type)
	end
	
	--> print("gggggggggggggggggggggggggggggggggggggggggg", rewardGold)
	if rewardGold > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(2, rewardGold, -1)
		--local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		listViewAward:addChild(reward)
		reward:showName(-1,2)
		rewardTotal = rewardTotal + 1

		local Panel_prop = ccui.Helper:seekWidgetByName(reward.roots[1], "Panel_prop")
		self:addRewardButtonEvent(Panel_prop, 2, reward.current_type)
	end
	
	if rewardHonor > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(3, rewardHonor, -1)
		--local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		listViewAward:addChild(reward)
		reward:showName(-1,3)
		rewardTotal = rewardTotal + 1
	end
	
	if rewardSoul > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(4, rewardSoul, -1)
		--local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		listViewAward:addChild(reward)
		reward:showName(-1,4)
		rewardTotal = rewardTotal + 1
	end
	
	-- if rewardTotal > 4 then
		-- return
	-- end
	
	if rewardJade > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(5, rewardJade, -1)
		--local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		listViewAward:addChild(reward)
		rewardTotal = rewardTotal + 1
	end
	
	-- if rewardTotal > 4 then
		-- return
	-- end
	
	--> print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh", rewardItemListStr)
	
	--绘制道具
	if rewardItemListStr ~= nil and rewardItemListStr ~= 0 and rewardItemListStr ~= "" then
	------------------------------------------------------------
		local rewardProp = zstring.split(rewardItemListStr, "|")
		--> print("ggggggggggggggggggggggggggggggggggggggg", table.getn(rewardProp))
		if table.getn(rewardProp) > 0 then
			for i,v in pairs(rewardProp) do
				local rewardPropInfo = zstring.split(v, ",")
				--> print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz", #rewardPropInfo)
				-- if rewardPropInfo == "" or rewardPropInfo == nil then break end
				if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
					-- app.load("client.cells.prop.prop_icon_cell")
					local reward = PropIconCell:createCell()
					local reawrdID = tonumber(rewardPropInfo[2])
					local rewardNum = tonumber(rewardPropInfo[1])
					-- reward:init(5, {user_prop_template = reawrdID, prop_number = rewardNum})
					reward:init(23, {user_prop_template = reawrdID, prop_number = rewardNum})
					--local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
					listViewAward:addChild(reward)
					rewardTotal = rewardTotal + 1
					
					-- if rewardTotal > 4 then
						-- break
					-- end

					local Panel_prop = ccui.Helper:seekWidgetByName(reward.roots[1], "Panel_prop")
					self:addRewardButtonEvent(Panel_prop, 6, Panel_prop._datas._prop)
				end
			end
		end
	--------------------------------------------------------
	end
	
	--绘制装备
	if rewardEquListStr ~= nil and rewardEquListStr ~= 0 and rewardEquListStr ~= "" then
	------------------------------------------------------------
		local rewardProp = zstring.split(rewardEquListStr, "|")
		if table.getn(rewardProp) > 0 then
			for i,v in pairs(rewardProp) do
				local rewardPropInfo = zstring.split(v, ",")
				if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
					-- app.load("client.cells.prop.prop_icon_cell")
					-- local reward = ArenaRoleIconCell:createCell()
					local reawrdID = tonumber(rewardPropInfo[2])
					local rewardNum = tonumber(rewardPropInfo[1])
					
					local tmpTable = {
						user_equiment_template = reawrdID,
						mould_id = reawrdID,
						user_equiment_grade = 1
					}
					
					local eic = EquipIconCell:createCell()
					eic:init(9, tmpTable, reawrdID)
					-- self.equipIconPanelArr[i]:addChild(eic)
					--local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
					listViewAward:addChild(eic)
					rewardTotal = rewardTotal + 1
					
					-- if rewardTotal > 4 then
						-- break
					-- end
				end
			end
		end
	--------------------------------------------------------
	end
	
	--奖励武将 rewardShipListStr
	if rewardShipListStr ~= nil and rewardShipListStr ~= 0 and rewardShipListStr ~= "" then
	------------------------------------------------------------
		local rewardProp = zstring.split(rewardShipListStr, "|")
		if table.getn(rewardProp) > 0 then
			for i,v in pairs(rewardProp) do
				local rewardPropInfo = zstring.split(v, ",")
				if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
					-- app.load("client.cells.prop.prop_icon_cell")
					-- 等级,数量,id,概率
					local reward = ArenaRoleIconCell:createCell()
					local reawrdID = tonumber(rewardPropInfo[3])
					local rewardLv = tonumber(rewardPropInfo[1])
					local rewardNums = tonumber(rewardPropInfo[2])
					reward:init(reawrdID, 2)
					--local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
					listViewAward:addChild(reward)
					rewardTotal = rewardTotal + 1
					
					-- if rewardTotal > 4 then
						-- break
					-- end
				end
			end
		end
	--------------------------------------------------------
	end
	--奖励绘制完毕
	-----------------------------------------------------------
	
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local tpx=120--每个奖励框大小
		local x= listViewAward:getContentSize().width
		local _tables=listViewAward:getItems()
		for i, v in pairs(_tables) do
			tpx=v.roots[1]:getContentSize().width
			-- print("--",tpx)
			-- print("---",x,v.roots[1]:getPositionX()+(x-tpx*rewardTotal)/2)
			-- print("----",v.roots[1]:getPositionX())
			-- print("-----",rewardTotal)
			v.roots[1]:setPositionX(v.roots[1]:getPositionX()+(x-tpx*(rewardTotal-1))/2)
		end
	end
	
	
	-- local library = dms.string(dms["scene_reward"], tonumber(pveReward[self.uiIndex]), scene_reward.reward_prop)
	--> print("",table.getn(pveReward))
	-- local rewardProp = zstring.split(library, "|")
	-- if table.getn(rewardProp) > 0 then
		-- for i,v in pairs(rewardProp) do
			-- local rewardPropInfo = zstring.split(v, ",")
			-- if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
				-- -- app.load("client.cells.prop.prop_icon_cell")
				-- local reward = PropIconCell:createCell()
				-- local reawrdID = tonumber(rewardPropInfo[2])
				-- local rewardNum = tonumber(rewardPropInfo[1])
				-- reward:init(5, {user_prop_template = reawrdID, prop_number = rewardNum})
				-- local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[i])
				-- mRewardItem:addChild(reward)
			-- end
		-- end
	-- end
	
	if tonumber(self.rewardIndex) == 3 then
		
		ccui.Helper:seekWidgetByName(root,"ImageView_10"):setVisible(true)
		ccui.Helper:seekWidgetByName(root,"ImageView_11"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"ImageView_12"):setVisible(false)
		
	elseif tonumber(self.rewardIndex) == 2 then
		
		ccui.Helper:seekWidgetByName(root,"ImageView_12"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"ImageView_11"):setVisible(true)
		ccui.Helper:seekWidgetByName(root,"ImageView_10"):setVisible(false)
		
	elseif tonumber(self.rewardIndex) == 1 then
		
		ccui.Helper:seekWidgetByName(root,"ImageView_10"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"ImageView_11"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"ImageView_12"):setVisible(true)
		
	end
	
	-- self.starReward
	
	-- 获取当前数量星星
	local nowStar = tonumber(_ED.get_star_count[self.sceneId])
	
	-- 获取当前关卡最大星星
	local maxStar = dms.string(dms["pve_scene"], self.sceneId, pve_scene.total_star)
	
	--判断按钮的状态
	-- if tonumber(self.openState.state) == 0 then
		-- -- if nowStar >= tonumber(self.openState.starNum) then
		-- -- end
		-- ccui.Helper:seekWidgetByName(root, "Button_receive"):setVisible(false)
		-- self.cacheTipsText:setString(string.format(_string_piece_info[180], self.openState.starNum))
	-- elseif tonumber(self.openState.state) == 1 then
		-- ccui.Helper:seekWidgetByName(root, "Button_receive"):setVisible(false)
		-- self.cacheTipsText:setString(_string_piece_info[181])
	-- end
	
	--> print("ttttttttttttttttttttttttttttttttttttt", self.starReward)
	local buttonState = 0	--1已经领取 2未领取 3可以领取
	
	if self.starReward == 0 then
		if nowStar >= tonumber(self.openState.starNum) then
			ccui.Helper:seekWidgetByName(root, "Button_receive"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Button_receive_ylq"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "ImageView_11991"):setVisible(false)--领取
			ccui.Helper:seekWidgetByName(root, "ImageView_11990"):setVisible(false)--已领取
		else
			ccui.Helper:seekWidgetByName(root, "Button_receive"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Button_receive_ylq"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "ImageView_11991"):setVisible(true)--领取
			ccui.Helper:seekWidgetByName(root, "ImageView_11990"):setVisible(false)--已领取
		end
		self.cacheTipsText:setString(string.format(_string_piece_info[180], self.openState.starNum))
	else
		
		if self.starReward == 1 then
			if self.openState.boxIndex == 1 then
				self.cacheTipsText:setString(_string_piece_info[181])
				buttonState = 1
			else
				self:checkAndUpdateStar(nowStar)
			end
		elseif self.starReward == 2 then
			if self.openState.boxIndex == 2 then
				self.cacheTipsText:setString(_string_piece_info[181])
				buttonState = 1
			else
				self:checkAndUpdateStar(nowStar)
			end
		elseif self.starReward == 4 then
			if self.openState.boxIndex == 3 then
				self.cacheTipsText:setString(_string_piece_info[181])
				buttonState = 1
			else
				self:checkAndUpdateStar(nowStar)
			end
		elseif self.starReward == 3 then
			if self.openState.boxIndex == 1 or self.openState.boxIndex == 2 then
				self.cacheTipsText:setString(_string_piece_info[181])
				buttonState = 1
			else
				self:checkAndUpdateStar(nowStar)
			end
		elseif self.starReward == 5 then
			if self.openState.boxIndex == 1 or self.openState.boxIndex == 3 then
				self.cacheTipsText:setString(_string_piece_info[181])
				buttonState = 1
			else
				self:checkAndUpdateStar(nowStar)
			end
		elseif self.starReward == 6 then
			if self.openState.boxIndex == 2 or self.openState.boxIndex == 3 then
				self.cacheTipsText:setString(_string_piece_info[181])
				buttonState = 1
			else
				self:checkAndUpdateStar(nowStar)
			end
		elseif self.starReward == 7 then
			self.cacheTipsText:setString(_string_piece_info[181])
			buttonState = 1
		end
		
		if buttonState == 1 then
			ccui.Helper:seekWidgetByName(root, "Button_receive"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Button_receive_ylq"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "ImageView_11991"):setVisible(false)--领取
			ccui.Helper:seekWidgetByName(root, "ImageView_11990"):setVisible(true)--已领取
		end
		
	end

	if  __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
		local _richText = ccui.RichText:create()
	    _richText:ignoreContentAdaptWithSize(false)

	    -- local sprite = cc.Sprite:create("images/ui/state/star_01.png")
	    -- sprite:setScale(0.5)
	    -- local star = ccui.RichElementCustomNode:create(0, cc.c3b(255, 255, 255), 255, sprite)
	    local star = nil
	    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
	    	star = ccui.RichElementImage:create(1, cc.c3b(71, 71, 71), 255, "images/ui/state/gq_pic_xx2.png")
	    else
			star = ccui.RichElementImage:create(1, cc.c3b(255, 255, 255), 255, "images/ui/state/gq_pic_xx2.png")
		end

	    local color = cc.c3b(255, 255, 255)
	    if __lua_project_id == __lua_project_l_naruto then
	    	color = cc.c3b(_naruto_tips_color[1][1],_naruto_tips_color[1][2],_naruto_tips_color[1][3])
	    end
	    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
	    	color = cc.c3b(71, 71, 71)
	    end
	    
	    local re0 = ccui.RichElementText:create(1, color, 255, nowStar .. "/" .. self.openState.starNum, self.cacheTipsText:getFontName(), self.cacheTipsText:getFontSize())

	    _richText:pushBackElement(star)
	    _richText:pushBackElement(re0)

	    _richText:setContentSize(cc.size(380, 20))
	    _richText:setAnchorPoint(cc.p(0, 0))

	    if _ED.is_can_use_formatTextExt == false then
	    else
	        _richText:formatTextExt()
		    local bsize = self.cacheTipsText:getContentSize()
		    local size = _richText:getContentSize()
		    _richText:setPosition(cc.p(bsize.width / 2 - size.width / 2, bsize.height / 2 - size.height / 2))
	    end
	    self.cacheTipsText:addChild(_richText)
	    self.cacheTipsText:setString("")
	end
end

function PVESceneStarReward:onUpdateDrawEx()
	-- 显示当前关卡的奖励数据
	--绘制奖励
	local root = self.roots[1]
	local rewardItem = {
		"Panel_1",
		"Panel_2",
		"Panel_3",
		"Panel_403"
		}
	
	local listViewAward_parent = ccui.Helper:seekWidgetByName(root, "Panel_1217"):getChildByName("ImageView_1226")
	local listViewAward = listViewAward_parent:getChildByName("ListView_award")
	listViewAward:removeAllItems()

	local rewardTotal = 1
	local pveReward = zstring.split(dms.string(dms["pve_scene"], self.sceneId, pve_scene.star_reward_id), ",")
	local rewardID = tonumber(pveReward[self.uiIndex])
	local rewardInfoString = dms.string(dms["scene_reward_ex"], rewardID, scene_reward_ex.show_reward)
	local rewardInfoArr = zstring.split(rewardInfoString, "|")
	local index = 1
    for i, v in pairs(rewardInfoArr) do
        local info = zstring.split(v, ",")
        local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{info[2],info[1],info[3]},true,true,false,true})
        listViewAward:addChild(cell)
        if info[2] == "6" then
            -- local cell = PropIconCell:createCell()
            local reawrdID = tonumber(info[1])
            local rewardNum = tonumber(info[3])
            -- cell:hideNameAndCount()
   --          local cell = ResourcesIconCell:createCell()
			-- cell:init(6, tonumber(rewardNum), reawrdID,nil,nil,true,true,0)
			-- cell:showName(reawrdID, 6)
			-- cell:init(0, 0, 0, {show_reward_list={{prop_type = 6, prop_item = reawrdID,item_value = rewardNum}}},nil,true,true,0)
            -- cell:init(23, {user_prop_template = reawrdID, prop_number = rewardNum}, nil, true)
            -- listViewAward:addChild(cell)
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				local rewardinfo = {}
		        rewardinfo.type = info[2]
		        rewardinfo.id = reawrdID
		        rewardinfo.number = rewardNum
		        self.reworld_sorting[index] = rewardinfo
		        index = index + 1
		    end
        elseif info[2] == "7" then
            local reawrdID = tonumber(info[1])
            local rewardNum = tonumber(info[3])
            
            local tmpTable = {
                user_equiment_template = reawrdID,
                mould_id = reawrdID,
                user_equiment_grade = 1
            }
            
            -- local cell = EquipIconCell:createCell()
            -- cell:hideNameAndCount()
   --          local cell = ResourcesIconCell:createCell()
			-- cell:init(7, tonumber(rewardNum), reawrdID,nil,nil,true,true,0)
			-- cell:showName(reawrdID, 7)
			-- cell:init(0, 0, 0, {show_reward_list={{prop_type = 7, prop_item = reawrdID,item_value = rewardNum}}},nil,true,true,0)
            -- cell:init(10, tmpTable, reawrdID, nil, true)
            -- listViewAward:addChild(cell)
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				local rewardinfo = {}
		        rewardinfo.type = info[2]
		        rewardinfo.id = reawrdID
		        rewardinfo.number = tmpTable
		        self.reworld_sorting[index] = rewardinfo
		        index = index + 1
		    end
       else
            -- local cell = ResourcesIconCell:createCell()
            -- cell:init(info[2], tonumber(info[3]), -1, nil, false, true)
            -- cell:init(0, 0, 0, {show_reward_list={{prop_type = info[2], prop_item = -1,item_value = info[3]}}},nil,true,true,0)
            -- cell:hideCount(true)
            -- cell:showName(-1, tonumber(info[2]))
            -- listViewAward:addChild(cell)
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				local rewardinfo = {}
		        rewardinfo.type = info[2]
		        rewardinfo.id = -1
		        rewardinfo.number = tonumber(info[3])
		        self.reworld_sorting[index] = rewardinfo
		        index = index + 1
		    end
        end
        rewardTotal = rewardTotal + 1
    end

	--[[local pveReward = zstring.split(dms.string(dms["pve_scene"], self.sceneId, pve_scene.star_reward_id), ",")
	local rewardID = tonumber(pveReward[self.uiIndex])
	local rewardMoney = dms.int(dms["scene_reward"], rewardID, scene_reward.reward_silver)
	local rewardGold = dms.int(dms["scene_reward"], rewardID, scene_reward.reward_gold)
	local rewardHonor = dms.int(dms["scene_reward"], rewardID, scene_reward.reward_honor)
	local rewardSoul = dms.int(dms["scene_reward"], rewardID, scene_reward.reward_soul)
	local rewardJade = dms.int(dms["scene_reward"], rewardID, scene_reward.reward_jade)
	local rewardItemListStr = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_prop)
	local rewardEquListStr = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_equipment)
	local rewardShipListStr = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_ship)
	local rewardTotal = 1

	if rewardMoney > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(1, rewardMoney, -1)
		--local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		listViewAward:addChild(reward)
		reward:showName(-1,1)
		rewardTotal = rewardTotal + 1

		local Panel_prop = ccui.Helper:seekWidgetByName(reward.roots[1], "Panel_prop")
		self:addRewardButtonEvent(Panel_prop, 1, reward.current_type)
	end
	
	--> print("gggggggggggggggggggggggggggggggggggggggggg", rewardGold)
	if rewardGold > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(2, rewardGold, -1)
		--local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		listViewAward:addChild(reward)
		reward:showName(-1,2)
		rewardTotal = rewardTotal + 1

		local Panel_prop = ccui.Helper:seekWidgetByName(reward.roots[1], "Panel_prop")
		self:addRewardButtonEvent(Panel_prop, 2, reward.current_type)
	end
	
	if rewardHonor > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(3, rewardHonor, -1)
		--local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		listViewAward:addChild(reward)
		reward:showName(-1,3)
		rewardTotal = rewardTotal + 1
	end
	
	if rewardSoul > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(4, rewardSoul, -1)
		--local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		listViewAward:addChild(reward)
		reward:showName(-1,4)
		rewardTotal = rewardTotal + 1
	end
	
	-- if rewardTotal > 4 then
		-- return
	-- end
	
	if rewardJade > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(5, rewardJade, -1)
		--local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		listViewAward:addChild(reward)
		rewardTotal = rewardTotal + 1
	end
	
	-- if rewardTotal > 4 then
		-- return
	-- end
	
	--> print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh", rewardItemListStr)
	
	--绘制道具
	if rewardItemListStr ~= nil and rewardItemListStr ~= 0 and rewardItemListStr ~= "" then
	------------------------------------------------------------
		local rewardProp = zstring.split(rewardItemListStr, "|")
		--> print("ggggggggggggggggggggggggggggggggggggggg", table.getn(rewardProp))
		if table.getn(rewardProp) > 0 then
			for i,v in pairs(rewardProp) do
				local rewardPropInfo = zstring.split(v, ",")
				--> print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz", #rewardPropInfo)
				-- if rewardPropInfo == "" or rewardPropInfo == nil then break end
				if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
					-- app.load("client.cells.prop.prop_icon_cell")
					local reward = PropIconCell:createCell()
					local reawrdID = tonumber(rewardPropInfo[2])
					local rewardNum = tonumber(rewardPropInfo[1])
					-- reward:init(5, {user_prop_template = reawrdID, prop_number = rewardNum})
					reward:init(23, {user_prop_template = reawrdID, prop_number = rewardNum})
					--local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
					listViewAward:addChild(reward)
					rewardTotal = rewardTotal + 1
					
					-- if rewardTotal > 4 then
						-- break
					-- end

					local Panel_prop = ccui.Helper:seekWidgetByName(reward.roots[1], "Panel_prop")
					self:addRewardButtonEvent(Panel_prop, 6, Panel_prop._datas._prop)
				end
			end
		end
	--------------------------------------------------------
	end
	
	--绘制装备
	if rewardEquListStr ~= nil and rewardEquListStr ~= 0 and rewardEquListStr ~= "" then
	------------------------------------------------------------
		local rewardProp = zstring.split(rewardEquListStr, "|")
		if table.getn(rewardProp) > 0 then
			for i,v in pairs(rewardProp) do
				local rewardPropInfo = zstring.split(v, ",")
				if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
					-- app.load("client.cells.prop.prop_icon_cell")
					-- local reward = ArenaRoleIconCell:createCell()
					local reawrdID = tonumber(rewardPropInfo[2])
					local rewardNum = tonumber(rewardPropInfo[1])
					
					local tmpTable = {
						user_equiment_template = reawrdID,
						mould_id = reawrdID,
						user_equiment_grade = 1
					}
					
					local eic = EquipIconCell:createCell()
					eic:init(9, tmpTable, reawrdID)
					-- self.equipIconPanelArr[i]:addChild(eic)
					--local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
					listViewAward:addChild(eic)
					rewardTotal = rewardTotal + 1
					
					-- if rewardTotal > 4 then
						-- break
					-- end
				end
			end
		end
	--------------------------------------------------------
	end
	
	--奖励武将 rewardShipListStr
	if rewardShipListStr ~= nil and rewardShipListStr ~= 0 and rewardShipListStr ~= "" then
	------------------------------------------------------------
		local rewardProp = zstring.split(rewardShipListStr, "|")
		if table.getn(rewardProp) > 0 then
			for i,v in pairs(rewardProp) do
				local rewardPropInfo = zstring.split(v, ",")
				if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
					-- app.load("client.cells.prop.prop_icon_cell")
					-- 等级,数量,id,概率
					local reward = ArenaRoleIconCell:createCell()
					local reawrdID = tonumber(rewardPropInfo[3])
					local rewardLv = tonumber(rewardPropInfo[1])
					local rewardNums = tonumber(rewardPropInfo[2])
					reward:init(reawrdID, 2)
					--local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
					listViewAward:addChild(reward)
					rewardTotal = rewardTotal + 1
					
					-- if rewardTotal > 4 then
						-- break
					-- end
				end
			end
		end
	--------------------------------------------------------
	end
	--奖励绘制完毕
	-----------------------------------------------------------
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local tpx=120--每个奖励框大小
		local x= listViewAward:getContentSize().width
		local _tables=listViewAward:getItems()
		for i, v in pairs(_tables) do
			tpx=v.roots[1]:getContentSize().width
			-- print("--",tpx)
			-- print("---",x,v.roots[1]:getPositionX()+(x-tpx*rewardTotal)/2)
			-- print("----",v.roots[1]:getPositionX())
			-- print("-----",rewardTotal)
			v.roots[1]:setPositionX(v.roots[1]:getPositionX()+(x-tpx*(rewardTotal-1))/2)
		end
	end]]
	
	
	-- local library = dms.string(dms["scene_reward"], tonumber(pveReward[self.uiIndex]), scene_reward.reward_prop)
	--> print("",table.getn(pveReward))
	-- local rewardProp = zstring.split(library, "|")
	-- if table.getn(rewardProp) > 0 then
		-- for i,v in pairs(rewardProp) do
			-- local rewardPropInfo = zstring.split(v, ",")
			-- if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
				-- -- app.load("client.cells.prop.prop_icon_cell")
				-- local reward = PropIconCell:createCell()
				-- local reawrdID = tonumber(rewardPropInfo[2])
				-- local rewardNum = tonumber(rewardPropInfo[1])
				-- reward:init(5, {user_prop_template = reawrdID, prop_number = rewardNum})
				-- local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[i])
				-- mRewardItem:addChild(reward)
			-- end
		-- end
	-- end
	
	if tonumber(self.rewardIndex) == 3 then
		
		ccui.Helper:seekWidgetByName(root,"ImageView_10"):setVisible(true)
		ccui.Helper:seekWidgetByName(root,"ImageView_11"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"ImageView_12"):setVisible(false)
		
	elseif tonumber(self.rewardIndex) == 2 then
		
		ccui.Helper:seekWidgetByName(root,"ImageView_12"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"ImageView_11"):setVisible(true)
		ccui.Helper:seekWidgetByName(root,"ImageView_10"):setVisible(false)
		
	elseif tonumber(self.rewardIndex) == 1 then
		
		ccui.Helper:seekWidgetByName(root,"ImageView_10"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"ImageView_11"):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"ImageView_12"):setVisible(true)
		
	end
	
	-- self.starReward
	
	-- 获取当前数量星星
	local nowStar = tonumber(_ED.get_star_count[self.sceneId])
	
	-- 获取当前关卡最大星星
	local maxStar = dms.string(dms["pve_scene"], self.sceneId, pve_scene.total_star)
	
	--判断按钮的状态
	-- if tonumber(self.openState.state) == 0 then
		-- -- if nowStar >= tonumber(self.openState.starNum) then
		-- -- end
		-- ccui.Helper:seekWidgetByName(root, "Button_receive"):setVisible(false)
		-- self.cacheTipsText:setString(string.format(_string_piece_info[180], self.openState.starNum))
	-- elseif tonumber(self.openState.state) == 1 then
		-- ccui.Helper:seekWidgetByName(root, "Button_receive"):setVisible(false)
		-- self.cacheTipsText:setString(_string_piece_info[181])
	-- end
	
	--> print("ttttttttttttttttttttttttttttttttttttt", self.starReward)
	local buttonState = 0	--1已经领取 2未领取 3可以领取
	
	if self.starReward == 0 then
		if nowStar >= tonumber(self.openState.starNum) then
			ccui.Helper:seekWidgetByName(root, "Button_receive"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Button_receive_ylq"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "ImageView_11991"):setVisible(false)--领取
			ccui.Helper:seekWidgetByName(root, "ImageView_11990"):setVisible(false)--已领取
		else
			ccui.Helper:seekWidgetByName(root, "Button_receive"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Button_receive_ylq"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "ImageView_11991"):setVisible(true)--领取
			ccui.Helper:seekWidgetByName(root, "ImageView_11990"):setVisible(false)--已领取
			pve_reward_grey_button_not_reached(root)
		end
		self.cacheTipsText:setString(string.format(_string_piece_info[180], self.openState.starNum))
	else
		
		if self.starReward == 1 then
			if self.openState.boxIndex == 1 then
				self.cacheTipsText:setString(_string_piece_info[181])
				buttonState = 1
			else
				self:checkAndUpdateStar(nowStar)
			end
		elseif self.starReward == 2 then
			if self.openState.boxIndex == 2 then
				self.cacheTipsText:setString(_string_piece_info[181])
				buttonState = 1
			else
				self:checkAndUpdateStar(nowStar)
			end
		elseif self.starReward == 4 then
			if self.openState.boxIndex == 3 then
				self.cacheTipsText:setString(_string_piece_info[181])
				buttonState = 1
			else
				self:checkAndUpdateStar(nowStar)
			end
		elseif self.starReward == 3 then
			if self.openState.boxIndex == 1 or self.openState.boxIndex == 2 then
				self.cacheTipsText:setString(_string_piece_info[181])
				buttonState = 1
			else
				self:checkAndUpdateStar(nowStar)
			end
		elseif self.starReward == 5 then
			if self.openState.boxIndex == 1 or self.openState.boxIndex == 3 then
				self.cacheTipsText:setString(_string_piece_info[181])
				buttonState = 1
			else
				self:checkAndUpdateStar(nowStar)
			end
		elseif self.starReward == 6 then
			if self.openState.boxIndex == 2 or self.openState.boxIndex == 3 then
				self.cacheTipsText:setString(_string_piece_info[181])
				buttonState = 1
			else
				self:checkAndUpdateStar(nowStar)
			end
		elseif self.starReward == 7 then
			self.cacheTipsText:setString(_string_piece_info[181])
			buttonState = 1
		end
		
		if buttonState == 1 then
			ccui.Helper:seekWidgetByName(root, "Button_receive"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Button_receive_ylq"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "ImageView_11991"):setVisible(false)--领取
			ccui.Helper:seekWidgetByName(root, "ImageView_11990"):setVisible(true)--已领取
		end
		
	end

	if  __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
		local _richText = ccui.RichText:create()
	    _richText:ignoreContentAdaptWithSize(false)

	    -- local sprite = cc.Sprite:create("images/ui/state/star_01.png")
	    -- sprite:setScale(0.5)
	    -- local star = ccui.RichElementCustomNode:create(0, cc.c3b(255, 255, 255), 255, sprite)
	    local star = ccui.RichElementImage:create(1, cc.c3b(255, 255, 255), 255, "images/ui/state/gq_pic_xx2.png")
	    local color = cc.c3b(255, 255, 255)
	    if __lua_project_id == __lua_project_l_naruto then
	    	color = cc.c3b(_naruto_tips_color[1][1],_naruto_tips_color[1][2],_naruto_tips_color[1][3])
	    end
	    local re0 = ccui.RichElementText:create(1, color, 255, nowStar .. "/" .. self.openState.starNum, self.cacheTipsText:getFontName(), self.cacheTipsText:getFontSize())

	    _richText:pushBackElement(star)
	    _richText:pushBackElement(re0)

	    _richText:setContentSize(cc.size(380, 20))
	    _richText:setAnchorPoint(cc.p(0, 0))

	    if _ED.is_can_use_formatTextExt == false then
	    else
	        _richText:formatTextExt()
		    local bsize = self.cacheTipsText:getContentSize()
		    local size = _richText:getContentSize()
		    _richText:setPosition(cc.p(bsize.width / 2 - size.width / 2, bsize.height / 2 - size.height / 2))
	    end
	    self.cacheTipsText:addChild(_richText)
	    self.cacheTipsText:setString("")
	end
end

function PVESceneStarReward:checkAndUpdateStar(nowStar)
	if nowStar >= tonumber(self.openState.starNum) then
		ccui.Helper:seekWidgetByName(self.roots[1], "Button_receive"):setVisible(true)
		ccui.Helper:seekWidgetByName(self.roots[1], "ImageView_11991"):setVisible(false)--领取
		ccui.Helper:seekWidgetByName(self.roots[1], "ImageView_11990"):setVisible(false)--已领取
	else
		ccui.Helper:seekWidgetByName(self.roots[1], "Button_receive"):setVisible(false)
		ccui.Helper:seekWidgetByName(self.roots[1], "Button_receive_ylq"):setVisible(true)
		ccui.Helper:seekWidgetByName(self.roots[1], "ImageView_11991"):setVisible(true)--领取
		ccui.Helper:seekWidgetByName(self.roots[1], "ImageView_11990"):setVisible(false)--已领取
		pve_reward_grey_button_not_reached(self.roots[1])
	end
	self.cacheTipsText:setString(string.format(_string_piece_info[180], self.openState.starNum))
end

function PVESceneStarReward:init(sceneId, chestState, openState)
	
	self.sceneId = tonumber(sceneId)
	self.rewardIndex = tonumber(chestState)
	self.openState = openState
	self.uiIndex = openState.boxIndex
	self.starReward = zstring.tonumber(_ED.star_reward_state[self.sceneId])
	
	--> print("tttttttttttttttttttttttttttttttttttttttttttttttttt", self.starReward)
	
	--> print("场景id和奖励索引", self.starReward)
	--> print("场景id", self.sceneId)
end

function PVESceneStarReward:onEnterTransitionFinish()
	local csbPveDuplicate = csb.createNode("duplicate/copy_the_award.csb")
    local root = csbPveDuplicate:getChildByName("root")
	table.insert(self.roots, root)

	-- local action = csb.createTimeline("duplicate/copy_the_award.csb")
    -- csbPveDuplicate:runAction(action)
    -- if action:getDuration() > 0 then
    	-- csbPveDuplicate:gotoFrameAndPlay(0, action:getDuration(), false)
	-- end

    self:addChild(csbPveDuplicate)
	
	--提示文字
	self.cacheTipsText = ccui.Helper:seekWidgetByName(root, "Label_12223")
    
	--添加关闭按钮的事件
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
	{
		terminal_name = "pve_scene_star_reward_close_window", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)

	--添加领取奖励按钮事件
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_receive"), nil, 
	{
		terminal_name = "pve_scene_star_reward_draw_reward", 
		terminal_state = 0, 
		_sceneId  = self.sceneId,
		_rewardIndex  = self.uiIndex - 1,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	--场景的星级奖励
    self:onUpdateDraw()
end

function PVESceneStarReward:onExit()
    state_machine.remove("pve_scene_star_reward_close_window")
    state_machine.remove("pve_scene_star_reward_draw_reward")
end