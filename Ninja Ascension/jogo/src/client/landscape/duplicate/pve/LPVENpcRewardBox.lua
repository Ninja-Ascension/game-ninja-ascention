-- ----------------------------------------------------------------------------------------------------
-- NPC宝箱领取界面
-------------------------------------------------------------------------------------------------------
LPVENpcRewardBox = class("LPVENpcRewardBoxClass", Window)

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

function LPVENpcRewardBox:ctor()
    self.super:ctor()
    self.roots = {}
	
    self.sceneId = 0
    self.npcId = 0
	self.boxIndex = 0		--宝箱的下标
	self.boxCell = nil
	
	--更新状态所用的pageview_seat_cell实例
	self.tmpSeatCell = nil
	
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.duplicate.pve.PVERewardPreviewPanel")
	app.load("client.cells.utils.resources_icon_cell")
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		app.load("client.cells.ship.ship_head_cell")
	end

	self.reworld_sorting = {}
    -- Initialize LPVENpcRewardBox page state machine.
    local function init_lpve_npc_reward_box_terminal()	
		-- 关闭场景星级奖励窗口
		local lpve_npc_reward_box_close_window_terminal = {
            _name = "lpve_npc_reward_box_close_window",
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
		local lpve_npc_reward_box_draw_reward_terminal = {
            _name = "lpve_npc_reward_box_draw_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				local sceneId = params._datas._sceneId
				local reworld_sorting = instance.reworld_sorting
				local function responseDrawStarRewardCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- 根据NPC宝箱的状态，来启动教学事件
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							if response.node == nil or response.node.roots == nil then
								return
							end
						end
						local drawState = _ED.scene_draw_chest_npcs[tostring(response.node.npcId)]
						local sceneParam = "nc"..drawState
						if missionIsOver() == false or executeMissionExt(mission_mould_tuition, touch_off_mission_touch_ui, ""..response.node.npcId, nil, true, sceneParam, true) == false then
			    			
						end

						---[[
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                            then
							app.load("client.reward.DrawRareReward")
							local getRewardWnd = DrawRareReward:new()
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							then
								getRewardWnd:init(7,nil,reworld_sorting)
							else
								getRewardWnd:init(7)
							end
							
							fwin:open(getRewardWnd, fwin._ui)
						else
							local boxId = response.node:checkBoxIDForNpcID(response.node.npcId)
							local previewWnd = PVERewardPreviewPanel:new()
							previewWnd:init(boxId)
							fwin:open(previewWnd, fwin._windows)
						end

						state_machine.excute("pve_bottom_update_box_state", 0, "event pve_bottom_update_box_state.")
						
						if response.node.boxCell ~= nil then
							if response.node.boxCell.roots ~= nil and response.node.boxCell.roots[1] ~= nil then
								response.node.boxCell:changeState(2)
							end
						end	
						
						-- state_machine.excute("plot_copy_chest_npc_get_success", 0, response.node.boxCell)
						fwin:close(response.node)

						state_machine.excute("lpve_scene_updeteinfo",0,"")--刷新顶部信息
						state_machine.excute("lpve_main_scene_updeteinfo",0,"")
						
						state_machine.excute("lduplicate_window_show_one_click", 0, nil) -- 刷新一键领取宝箱按钮
						--]]
					end
				end
				protocol_command.draw_scene_npc_rewad.param_list = ""..sceneId .."\r\n" .. (instance.boxIndex - 1).."\r\n" .. 0
				NetworkManager:register(protocol_command.draw_scene_npc_rewad.code, nil, nil, nil, instance, responseDrawStarRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- EL BOTON GRIS NO DECIA NADA. `Button_receive_ylq` se enseña con el
		-- cofre ya cobrado y tambien con la etapa sin superar, y no tenia
		-- ningun oyente: el toque llegaba al widget y no pasaba nada. Aqui
		-- solo avisa, con los dos textos que ya trae el cliente.
		local lpve_npc_reward_box_not_yet_terminal = {
            _name = "lpve_npc_reward_box_not_yet",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if _ED.scene_draw_chest_npcs[tostring(instance.npcId)] == 1 then
					TipDlg.drawTextDailog(_string_piece_info[181])
				else
					TipDlg.drawTextDailog(_new_interface_text[127])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(lpve_npc_reward_box_not_yet_terminal)
        state_machine.add(lpve_npc_reward_box_close_window_terminal)
        state_machine.add(lpve_npc_reward_box_draw_reward_terminal)
        state_machine.init()
    end
    
    -- call func init LPVENpcRewardBox state machine.
    init_lpve_npc_reward_box_terminal()
end

function LPVENpcRewardBox:onUpdate(dt)
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

function LPVENpcRewardBox:addRewardButtonEvent(but, itemType, info)
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

function LPVENpcRewardBox:onUpdateDraw()
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
		"Panel_4"
	}
	
	--判断NPC宝箱是否显示
	local boxIndex
	local boxID
	boxID, boxIndex = self:checkBoxIDForNpcID(self.npcId)
	self.boxIndex = boxIndex
	
	--显示奖励
	local rewardTotal = 1
	local rewardName = dms.string(dms["scene_reward"], boxID, scene_reward.reward_name)
	local rewardMoney = dms.int(dms["scene_reward"], boxID, scene_reward.reward_silver)
	local rewardGold = dms.int(dms["scene_reward"], boxID, scene_reward.reward_gold)
	local rewardHonor = dms.int(dms["scene_reward"], boxID, scene_reward.reward_honor)
	local rewardSoul = dms.int(dms["scene_reward"], boxID, scene_reward.reward_soul)
	local rewardJade = dms.int(dms["scene_reward"], boxID, scene_reward.reward_jade)
	local rewardItemListStr = dms.string(dms["scene_reward"], boxID, scene_reward.reward_prop)
	local rewardEquListStr = dms.string(dms["scene_reward"], boxID, scene_reward.reward_equipment)
	local rewardShipListStr = dms.string(dms["scene_reward"], boxID, scene_reward.reward_ship)
	
	local listViewAward = nil 
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		 listViewAward=	ccui.Helper:seekWidgetByName(root, "ListView_award")
	end
	listViewAward:removeAllItems()

	--显示标题
	self.cacheTipsText:setString(rewardName)
	-- 4001	元宝	
	-- 4002	银两	
	-- 4003	军团贡献	
	-- 4004	声望	
	-- 4005	战功	
	-- 4006	威名	
	-- 4007	神魂	
	-- 4008	将魂	
	
	if rewardMoney > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(1, rewardMoney, -1)
		local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			listViewAward:addChild(reward)
		else
			mRewardItem:addChild(reward)
		end
		reward:showName(-1,1)
		rewardTotal = rewardTotal + 1

		local Panel_prop = ccui.Helper:seekWidgetByName(reward.roots[1], "Panel_prop")
		self:addRewardButtonEvent(Panel_prop, 1, reward.current_type)
	end
	
	if rewardGold > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(2, rewardGold, -1)
		local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			listViewAward:addChild(reward)
		else
			mRewardItem:addChild(reward)
		end
		reward:showName(-1,2)
		rewardTotal = rewardTotal + 1

		local Panel_prop = ccui.Helper:seekWidgetByName(reward.roots[1], "Panel_prop")
		self:addRewardButtonEvent(Panel_prop, 2, reward.current_type)
	end
	
	if rewardHonor > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(3, rewardHonor, -1)
		local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			listViewAward:addChild(reward)
		else
			mRewardItem:addChild(reward)
		end
		reward:showName(-1,3)
		rewardTotal = rewardTotal + 1
	end
	
	if rewardSoul > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(4, rewardSoul, -1)
		local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			listViewAward:addChild(reward)
		else
			mRewardItem:addChild(reward)
		end
		reward:showName(-1,4)
		rewardTotal = rewardTotal + 1
	end
	
	-- if rewardTotal > 4 then
		-- return
	-- end
	
	if rewardJade > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(5, rewardJade, -1)
		local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			listViewAward:addChild(reward)
		else
			mRewardItem:addChild(reward)
		end
		reward:showName(-1,5)
		rewardTotal = rewardTotal + 1
	end
	
	-- if rewardTotal > 4 then
		-- return
	-- end
	
	--绘制道具
	if rewardItemListStr ~= nil and rewardItemListStr ~= 0 and rewardItemListStr ~= "" then
		local rewardProp = zstring.split(rewardItemListStr, "|")
		if table.getn(rewardProp) > 0 then
			for i,v in pairs(rewardProp) do
				local rewardPropInfo = zstring.split(v, ",")
				if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
					-- app.load("client.cells.prop.prop_icon_cell")
					local reward = PropIconCell:createCell()
					local reawrdID = tonumber(rewardPropInfo[2])
					local rewardNum = tonumber(rewardPropInfo[1])
					reward:init(23, {user_prop_template = reawrdID, prop_number = rewardNum})
					local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						listViewAward:addChild(reward)
					else
						mRewardItem:addChild(reward)
					end
					rewardTotal = rewardTotal + 1

					local Panel_prop = ccui.Helper:seekWidgetByName(reward.roots[1], "Panel_prop")
					self:addRewardButtonEvent(Panel_prop, 6, Panel_prop._datas._prop)
					
					-- if rewardTotal > 4 then
						-- break
					-- end
				end
			end
		end
	end
	
	--绘制装备
	if rewardEquListStr ~= nil and rewardEquListStr ~= 0 and rewardEquListStr ~= "" then
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
					eic:init(10, tmpTable, reawrdID)
					-- self.equipIconPanelArr[i]:addChild(eic)
					local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						listViewAward:addChild(eic)
					else
						mRewardItem:addChild(eic)
					end
					rewardTotal = rewardTotal + 1
					
					-- if rewardTotal > 4 then
						-- break
					-- end
				end
			end
		end
	end
	
	--奖励武将 rewardShipListStr
	if rewardShipListStr ~= nil and rewardShipListStr ~= 0 and rewardShipListStr ~= "" then
		local rewardProp = zstring.split(rewardShipListStr, "|")
		if table.getn(rewardProp) > 0 then
			for i,v in pairs(rewardProp) do
				local rewardPropInfo = zstring.split(v, ",")
				if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
					-- app.load("client.cells.prop.prop_icon_cell")
					-- 等级,数量,id,概率
					local reward = ShipHeadCell:createCell()
					local reawrdID = tonumber(rewardPropInfo[3])
					local rewardLv = tonumber(rewardPropInfo[1])
					local rewardNums = tonumber(rewardPropInfo[2])
					reward:init(nil,13, reawrdID,rewardNums,true)
					local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						listViewAward:addChild(reward)
					else
						mRewardItem:addChild(reward)
					end
					rewardTotal = rewardTotal + 1
					
					-- if rewardTotal > 4 then
						-- break
					-- end
				end
			end
		end
	end
	
	
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
	
	--判断按钮状态
	local drawState = _ED.scene_draw_chest_npcs[tostring(self.npcId)]
	if drawState == 1 then--已经领取
		ccui.Helper:seekWidgetByName(root, "Button_receive"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Button_receive_ylq"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "ImageView_11991"):setVisible(false)--领取
		ccui.Helper:seekWidgetByName(root, "ImageView_11990"):setVisible(true)--已领取
		ccui.Helper:seekWidgetByName(root, "Image_8"):setVisible(true)--已领取
		
		self.cacheTipsText:setString(_string_piece_info[181])
		
	else--没有领取
		if self.tmpSeatCell ~= nil and tonumber(self.tmpSeatCell.npcState) ~= 1 and tonumber(self.tmpSeatCell.npcState) ~= 2 then
			ccui.Helper:seekWidgetByName(root, "Button_receive"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Button_receive_ylq"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "ImageView_11991"):setVisible(true)--领取
			ccui.Helper:seekWidgetByName(root, "ImageView_11990"):setVisible(false)--已领取
		else
			ccui.Helper:seekWidgetByName(root, "Button_receive"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Button_receive_ylq"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "ImageView_11991"):setVisible(true)--领取
			ccui.Helper:seekWidgetByName(root, "ImageView_11990"):setVisible(false)--已领取
		end
	end

	-- EL TITULO PROMETIA «Se puede reclamar» SIEMPRE. El texto compuesto
	-- (_new_interface_text 33 + nombre del npc + 34) es la promesa del cofre;
	-- con la etapa sin superar no es verdad, y con el cofre ya cobrado pisaba
	-- el «Ya has reclamado el cofre» que se acababa de escribir.
	local puedeCobrar = drawState ~= 1
		and self.tmpSeatCell ~= nil
		and tonumber(self.tmpSeatCell.npcState) ~= 1
		and tonumber(self.tmpSeatCell.npcState) ~= 2
	if drawState ~= 1 and puedeCobrar == false then
		self.cacheTipsText:setString(_new_interface_text[127])
	end

	if puedeCobrar and (  __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
        ) then
		local _richText = ccui.RichText:create()
	    _richText:ignoreContentAdaptWithSize(false)
	    _richText:setContentSize(cc.size(self.cacheTipsText:getContentSize().width, self.cacheTipsText:getContentSize().height / 2))

	    local npcName = dms.string(dms["npc"], self.npcId, npc.npc_name)
	    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        local name_info = ""
	        local name_data = zstring.split(npcName, "|")
	        for i, v in pairs(name_data) do
	            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
	            name_info = name_info..word_info[3]
	        end
	        npcName = name_info
	    end
	    -- 临时绘图，需要策划配置数据
	    local fontName = self.cacheTipsText:getFontName()
	    local fontSize = self.cacheTipsText:getFontSize()
	    local color1 = cc.c3b(255, 255, 255)
	    local color2 = cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3])
	    if __lua_project_id == __lua_project_l_naruto then
	    	color1 = cc.c3b(_naruto_tips_color[1][1],_naruto_tips_color[1][2],_naruto_tips_color[1][3])
	    	color2 = cc.c3b(_naruto_tips_color[2][1],_naruto_tips_color[2][2],_naruto_tips_color[2][3])
	    end
	    local re0 = ccui.RichElementText:create(1, color1, 255, _new_interface_text[33] .. " ", fontName, fontSize)
	    local re1 = ccui.RichElementText:create(1, color2, 255, npcName, fontName, fontSize)
	    local re2 = ccui.RichElementText:create(1, color1, 255, " " .. _new_interface_text[34], fontName, fontSize)

	    _richText:pushBackElement(re0)
	    _richText:pushBackElement(re1)
	    _richText:pushBackElement(re2)

	    _richText:setAnchorPoint(cc.p(0, 0))
	    if _ED.is_can_use_formatTextExt == false then
	    	local str = _new_interface_text[33]..npcName.._new_interface_text[34]
	    	self.cacheTipsText:setString(str)
	    	local rich_width = self.cacheTipsText:getAutoRenderSize().width
	        _richText:setPositionX( _richText:getPositionX() - rich_width / 2 )
	    else
	        _richText:formatTextExt()
		    local bsize = self.cacheTipsText:getContentSize()
		    local size = _richText:getContentSize()
		    _richText:setPositionX( (bsize.width - size.width) / 2 )
	    end
	    self.cacheTipsText:addChild(_richText)
	    self.cacheTipsText:setString("")
	end
end

function LPVENpcRewardBox:onUpdateDrawEx()
	-- 显示当前关卡的奖励数据
	--绘制奖励
	local root = self.roots[1]
	local rewardItem = {
		"Panel_1",
		"Panel_2",
		"Panel_3",
		"Panel_4"
	}
	
	--判断NPC宝箱是否显示
	local boxID, boxIndex = self:checkBoxIDForNpcID(self.npcId)
	self.boxIndex = boxIndex
	
	--显示奖励
	local rewardTotal = 1
	local listViewAward = ccui.Helper:seekWidgetByName(root, "ListView_award")
	listViewAward:removeAllItems()
	local index = 1
	local rewardInfoString = dms.string(dms["scene_reward_ex"], boxID, scene_reward_ex.show_reward)
	local rewardInfoArr = zstring.split(rewardInfoString, "|")
    for i, v in pairs(rewardInfoArr) do
        local info = zstring.split(v, ",")
        local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{info[2],info[1],info[3]},true,true,false,true})
        listViewAward:addChild(cell)
        if info[2] == "6" then
            -- local cell = PropIconCell:createCell()
            local reawrdID = tonumber(info[1])
            local rewardNum = tonumber(info[3])
            -- cell:hideNameAndCount()
            -- local cell = ResourcesIconCell:createCell()
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
		        rewardinfo.number = rewardNum
		        self.reworld_sorting[index] = rewardinfo
		        index = index + 1
		    end
       else
            -- local cell = ResourcesIconCell:createCell()
            -- cell:init(info[2], tonumber(info[3]), -1, nil, false, true,0)
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
		        rewardinfo.number = info[3]
		        self.reworld_sorting[index] = rewardinfo
		        index = index + 1
		    end
        end
        rewardTotal = rewardTotal + 1
    end

	--[[local rewardMoney = dms.int(dms["scene_reward"], boxID, scene_reward.reward_silver)
	local rewardGold = dms.int(dms["scene_reward"], boxID, scene_reward.reward_gold)
	local rewardHonor = dms.int(dms["scene_reward"], boxID, scene_reward.reward_honor)
	local rewardSoul = dms.int(dms["scene_reward"], boxID, scene_reward.reward_soul)
	local rewardJade = dms.int(dms["scene_reward"], boxID, scene_reward.reward_jade)
	local rewardItemListStr = dms.string(dms["scene_reward"], boxID, scene_reward.reward_prop)
	local rewardEquListStr = dms.string(dms["scene_reward"], boxID, scene_reward.reward_equipment)
	local rewardShipListStr = dms.string(dms["scene_reward"], boxID, scene_reward.reward_ship)
	
	-- 4001	元宝	
	-- 4002	银两	
	-- 4003	军团贡献	
	-- 4004	声望	
	-- 4005	战功	
	-- 4006	威名	
	-- 4007	神魂	
	-- 4008	将魂	
	
	if rewardMoney > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(1, rewardMoney, -1)
		local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			listViewAward:addChild(reward)
		else
			mRewardItem:addChild(reward)
		end
		reward:showName(-1,1)
		rewardTotal = rewardTotal + 1

		local Panel_prop = ccui.Helper:seekWidgetByName(reward.roots[1], "Panel_prop")
		self:addRewardButtonEvent(Panel_prop, 1, reward.current_type)
	end
	
	if rewardGold > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(2, rewardGold, -1)
		local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			listViewAward:addChild(reward)
		else
			mRewardItem:addChild(reward)
		end
		reward:showName(-1,2)
		rewardTotal = rewardTotal + 1

		local Panel_prop = ccui.Helper:seekWidgetByName(reward.roots[1], "Panel_prop")
		self:addRewardButtonEvent(Panel_prop, 2, reward.current_type)
	end
	
	if rewardHonor > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(3, rewardHonor, -1)
		local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			listViewAward:addChild(reward)
		else
			mRewardItem:addChild(reward)
		end
		reward:showName(-1,3)
		rewardTotal = rewardTotal + 1
	end
	
	if rewardSoul > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(4, rewardSoul, -1)
		local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			listViewAward:addChild(reward)
		else
			mRewardItem:addChild(reward)
		end
		reward:showName(-1,4)
		rewardTotal = rewardTotal + 1
	end
	
	-- if rewardTotal > 4 then
		-- return
	-- end
	
	if rewardJade > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(5, rewardJade, -1)
		local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			listViewAward:addChild(reward)
		else
			mRewardItem:addChild(reward)
		end
		reward:showName(-1,5)
		rewardTotal = rewardTotal + 1
	end
	
	-- if rewardTotal > 4 then
		-- return
	-- end
	
	--绘制道具
	if rewardItemListStr ~= nil and rewardItemListStr ~= 0 and rewardItemListStr ~= "" then
		local rewardProp = zstring.split(rewardItemListStr, "|")
		if table.getn(rewardProp) > 0 then
			for i,v in pairs(rewardProp) do
				local rewardPropInfo = zstring.split(v, ",")
				if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
					-- app.load("client.cells.prop.prop_icon_cell")
					local reward = PropIconCell:createCell()
					local reawrdID = tonumber(rewardPropInfo[2])
					local rewardNum = tonumber(rewardPropInfo[1])
					reward:init(23, {user_prop_template = reawrdID, prop_number = rewardNum})
					local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						listViewAward:addChild(reward)
					else
						mRewardItem:addChild(reward)
					end
					rewardTotal = rewardTotal + 1

					local Panel_prop = ccui.Helper:seekWidgetByName(reward.roots[1], "Panel_prop")
					self:addRewardButtonEvent(Panel_prop, 6, Panel_prop._datas._prop)
					
					-- if rewardTotal > 4 then
						-- break
					-- end
				end
			end
		end
	end
	
	--绘制装备
	if rewardEquListStr ~= nil and rewardEquListStr ~= 0 and rewardEquListStr ~= "" then
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
					eic:init(10, tmpTable, reawrdID)
					-- self.equipIconPanelArr[i]:addChild(eic)
					local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						listViewAward:addChild(eic)
					else
						mRewardItem:addChild(eic)
					end
					rewardTotal = rewardTotal + 1
					
					-- if rewardTotal > 4 then
						-- break
					-- end
				end
			end
		end
	end
	
	--奖励武将 rewardShipListStr
	if rewardShipListStr ~= nil and rewardShipListStr ~= 0 and rewardShipListStr ~= "" then
		local rewardProp = zstring.split(rewardShipListStr, "|")
		if table.getn(rewardProp) > 0 then
			for i,v in pairs(rewardProp) do
				local rewardPropInfo = zstring.split(v, ",")
				if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
					-- app.load("client.cells.prop.prop_icon_cell")
					-- 等级,数量,id,概率
					local reward = ShipHeadCell:createCell()
					local reawrdID = tonumber(rewardPropInfo[3])
					local rewardLv = tonumber(rewardPropInfo[1])
					local rewardNums = tonumber(rewardPropInfo[2])
					reward:init(nil,13, reawrdID,rewardNums,true)
					local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[rewardTotal])
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						listViewAward:addChild(reward)
					else
						mRewardItem:addChild(reward)
					end
					rewardTotal = rewardTotal + 1
					
					-- if rewardTotal > 4 then
						-- break
					-- end
				end
			end
		end
	end]]
	
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
	
	--判断按钮状态
	local drawState = _ED.scene_draw_chest_npcs[tostring(self.npcId)]
	if drawState == 1 then--已经领取
		ccui.Helper:seekWidgetByName(root, "Button_receive"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Button_receive_ylq"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "ImageView_11991"):setVisible(false)--领取
		ccui.Helper:seekWidgetByName(root, "ImageView_11990"):setVisible(true)--已领取
		ccui.Helper:seekWidgetByName(root, "Image_8"):setVisible(true)--已领取
		
		self.cacheTipsText:setString(_string_piece_info[181])
		
	else--没有领取
		if self.tmpSeatCell ~= nil and tonumber(self.tmpSeatCell.npcState) ~= 1 and tonumber(self.tmpSeatCell.npcState) ~= 2 then
			ccui.Helper:seekWidgetByName(root, "Button_receive"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Button_receive_ylq"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "ImageView_11991"):setVisible(true)--领取
			ccui.Helper:seekWidgetByName(root, "ImageView_11990"):setVisible(false)--已领取
		else
			ccui.Helper:seekWidgetByName(root, "Button_receive"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Button_receive_ylq"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "ImageView_11991"):setVisible(true)--领取
			ccui.Helper:seekWidgetByName(root, "ImageView_11990"):setVisible(false)--已领取
			pve_reward_grey_button_not_reached(root)
		end
	end

	-- EL TITULO PROMETIA «Se puede reclamar» SIEMPRE. El texto compuesto
	-- (_new_interface_text 33 + nombre del npc + 34) es la promesa del cofre;
	-- con la etapa sin superar no es verdad, y con el cofre ya cobrado pisaba
	-- el «Ya has reclamado el cofre» que se acababa de escribir.
	local puedeCobrar = drawState ~= 1
		and self.tmpSeatCell ~= nil
		and tonumber(self.tmpSeatCell.npcState) ~= 1
		and tonumber(self.tmpSeatCell.npcState) ~= 2
	if drawState ~= 1 and puedeCobrar == false then
		self.cacheTipsText:setString(_new_interface_text[127])
	end

	if puedeCobrar and (  __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
        ) then
		local _richText = ccui.RichText:create()
	    _richText:ignoreContentAdaptWithSize(false)
	    _richText:setContentSize(cc.size(self.cacheTipsText:getContentSize().width, self.cacheTipsText:getContentSize().height / 2))

	    local npcName = dms.string(dms["npc"], self.npcId, npc.npc_name)
	    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        local name_info = ""
	        local name_data = zstring.split(npcName, "|")
	        for i, v in pairs(name_data) do
	            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
	            name_info = name_info..word_info[3]
	        end
	        npcName = name_info
	    end
	    -- 临时绘图，需要策划配置数据
	    local fontName = self.cacheTipsText:getFontName()
	    local fontSize = self.cacheTipsText:getFontSize()
	    local color1 = cc.c3b(255, 255, 255)
	    local color2 = cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3])
	    if __lua_project_id == __lua_project_l_naruto then
	    	color1 = cc.c3b(_naruto_tips_color[1][1],_naruto_tips_color[1][2],_naruto_tips_color[1][3])
	    	color2 = cc.c3b(_naruto_tips_color[2][1],_naruto_tips_color[2][2],_naruto_tips_color[2][3])
	    end
	    local re0 = ccui.RichElementText:create(1, color1, 255, _new_interface_text[33] .. " ", fontName, fontSize)
	    local re1 = ccui.RichElementText:create(1, color2, 255, npcName, fontName, fontSize)
	    local re2 = ccui.RichElementText:create(1, color1, 255, " " .. _new_interface_text[34], fontName, fontSize)

	    _richText:pushBackElement(re0)
	    _richText:pushBackElement(re1)
	    _richText:pushBackElement(re2)

	    _richText:setAnchorPoint(cc.p(0, 0))
	    if _ED.is_can_use_formatTextExt == false then
	    	local str = _new_interface_text[33]..npcName.._new_interface_text[34]
	    	self.cacheTipsText:setString(str)
	    	local rich_width = self.cacheTipsText:getAutoRenderSize().width
	        _richText:setPositionX( _richText:getPositionX() - rich_width / 2 )
	    else
	        _richText:formatTextExt()
		    local bsize = self.cacheTipsText:getContentSize()
		    local size = _richText:getContentSize()
		    _richText:setPositionX( (bsize.width - size.width) / 2 )
	    end
	    self.cacheTipsText:addChild(_richText)
	    self.cacheTipsText:setString("")
	end
end

--检测table中是否包含传入的NPCid
function LPVENpcRewardBox:checkBoxIDForNpcID(npcID)
	local npcIdListStr = dms.string(dms["pve_scene"], self.sceneId, pve_scene.design_npc)
	local npcIdTable = zstring.split(npcIdListStr, ",")
	local npcRewardListStr = dms.string(dms["pve_scene"], self.sceneId, pve_scene.design_reward)
	local npcRewardTable = zstring.split(npcRewardListStr, ",")
	
	for i, v in pairs(npcIdTable) do
		if tonumber(v) == npcID then
			return npcRewardTable[i], i, npcRewardTable
		end
	end
	return 0, 0, nil
end

function LPVENpcRewardBox:init(sceneId, npcId, aSeatIns, _boxCell)
	self.sceneId = tonumber(sceneId)
	self.npcId = tonumber(npcId)
	self.tmpSeatCell = aSeatIns
	self.boxCell = _boxCell
end

function LPVENpcRewardBox:onEnterTransitionFinish()
	local csbPveDuplicate = csb.createNode("duplicate/copy_the_award.csb")
    local root = csbPveDuplicate:getChildByName("root")
	table.insert(self.roots, root)

    self:addChild(csbPveDuplicate)
	
	--提示文字
	self.cacheTipsText = ccui.Helper:seekWidgetByName(root, "Label_12223")
	
	--临时处理的
	if ccui.Helper:seekWidgetByName(root, "ImageView_13") ~= nil then
		ccui.Helper:seekWidgetByName(root, "ImageView_13"):setVisible(true)
    end
	
	--添加关闭按钮的事件
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
	{
		terminal_name = "lpve_npc_reward_box_close_window", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)

	--添加领取奖励按钮事件
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_receive"), nil, 
	{
		terminal_name = "lpve_npc_reward_box_draw_reward", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_sceneId  = self.sceneId,
		_npcid  = self.npcId,
	}, 
	nil, 0)

	--el boton gris: no cobra, solo dice por que no se puede
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_receive_ylq"), nil, 
	{
		terminal_name = "lpve_npc_reward_box_not_yet", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
	}, 
	nil, 0)
	
    self:onUpdateDraw()
end

function LPVENpcRewardBox:onExit()
    state_machine.remove("lpve_npc_reward_box_not_yet")
    state_machine.remove("lpve_npc_reward_box_close_window")
    state_machine.remove("lpve_npc_reward_box_draw_reward")
end