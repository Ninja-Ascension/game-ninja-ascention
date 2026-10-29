-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏副关卡场景界面
-------------------------------------------------------------------------------------------------------
LPVENewMap = class("LPVENewMapClass", Window)

function LPVENewMap:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	
	self.sceneID = 0
	self.rewardBoxes = {}
	self.npcanimations = {}
	self.npcPanels = {}
	self.play_animation = false
	app.load("client.utils.ShadowUtil")
	app.load("client.landscape.cells.duplicate.lduplicate_npc_cell")
	app.load("client.cells.copy.plot_copy_chest")
	app.load("client.duplicate.pve.PVEStarChestPanel")
    local function init_lpve_new_map_window_terminal()
		local lpve_new_map_action_play_terminal = {
            _name = "lpve_new_map_action_play",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local action = self.actions[1]
				action:play(params._actionName, params._bRepeated or false)
				action:setFrameEventCallFunc(function (frame)
					if nil == frame or nil == params._eventName then
						return
					end
					
					local str = frame:getEvent()
					if str == params._eventName then
						params._eventFunc()
					end
				end)
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local lduplicate_new_npc_click_terminal = {
            _name = "lduplicate_new_npc_click",
            _init = function (terminal) 
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.landscape.duplicate.pve.LPVENpc")
				local _cell = params._datas
				if _cell.npcState == nil then
					return false
				end
				
				local sceneParam = "nc".._ED.npc_state[zstring.tonumber(_cell.npcID)]
				if missionIsOver() == false or executeMissionExt(mission_mould_plot, touch_off_mission_touch_npc, "".._cell.npcID, nil, true, sceneParam, false) == false then
					local _LPVENpc = LPVENpc:new()
					_LPVENpc:init(_cell.npcID, 
								  _cell.sceneID, 
								  _cell.bossFlag,
								  _cell.npcState)
					fwin:open(_LPVENpc, fwin._ui)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local lduplicate_new_turn_left_terminal = {
            _name = "lduplicate_new_turn_left",
            _init = function (terminal) 
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- local time1 = os.clock()
            	local left_button = ccui.Helper:seekWidgetByName(instance.roots[1],"Button_zx_pve_left")
				local right_button = ccui.Helper:seekWidgetByName(instance.roots[1],"Button_zx_pve_right")
				left_button:setVisible(false)
				right_button:setVisible(false)            	
                state_machine.lock("lduplicate_new_turn_right")
            	state_machine.lock("lduplicate_new_turn_left")	
        		state_machine.lock("lpvenpc_to_turn")
            	local sceneID = params._datas.sceneID
				local by_open_scene = dms.string(dms["pve_scene"],sceneID,pve_scene.by_open_scene)
				local last_sceneID = tonumber(by_open_scene)
				if last_sceneID == -1 then
	                state_machine.unlock("lduplicate_new_turn_right")
	            	state_machine.unlock("lduplicate_new_turn_left")	
            		state_machine.unlock("lpvenpc_to_turn")
					return
				end

				LDuplicateWindow._infoDatas._chapter = last_sceneID
				local _LPVEMap = LPVENewMap:new()
				_LPVEMap:init(last_sceneID)
				fwin:open(_LPVEMap, fwin._ui)
				state_machine.lock("lduplicate_new_turn_right")
            	state_machine.lock("lduplicate_new_turn_left")
				_LPVEMap.roots[1]:setVisible(false)

				fwin:close(fwin:find("PVEStarCheatPanelClass"))
				state_machine.excute("open_star_cheat_panel",0,{last_sceneID,1})
			state_machine.excute("lpve_main_scene_check_mission",0,last_sceneID)			
				local function TurnPage( ... )
					local Panel_map = ccui.Helper:seekWidgetByName(_LPVEMap.roots[1],"Panel_ship")
				    local gridNodeTarget = cc.NodeGrid:create()
				    gridNodeTarget:setContentSize(Panel_map:getContentSize())
				    gridNodeTarget:setAnchorPoint(cc.p(0,0))
				    gridNodeTarget:setPosition(cc.p(0,0))

				    local sprite = ShadowUtil_createSprite(Panel_map)
				    gridNodeTarget:addChild(sprite)
				    _LPVEMap:addChild(gridNodeTarget)	
					local seq = cc.Sequence:create({cc.PageTurn3D:create(0.25, cc.size(10,15)):reverse(), cc.CallFunc:create(function(sender)
							sender:removeFromParent()
							fwin:close(instance)
							cacher.destoryRefPools()
							cacher.cleanSystemCacher()
							cacher.remvoeUnusedArmatureFileInfoes()
							cacher.removeAllTextures()
							_LPVEMap.roots[1]:setVisible(true)

							local openother = cc.Sequence:create({cc.DelayTime:create(0), cc.CallFunc:create(function(sender)
										state_machine.excute("lduplicate_new_playainimation",0,"")	            						            		
										state_machine.excute("lpve_new_map_draw_box",0,"")
										state_machine.excute("pve_star_cheat_update_panel_box",0,"")
						                state_machine.unlock("lduplicate_new_turn_right")
						            	state_machine.unlock("lduplicate_new_turn_left")
										state_machine.unlock("lpvenpc_to_turn")
										state_machine.excute("lduplicate_new_map_check_button_state")							
								end)})
							_LPVEMap:runAction(openother)
						end)})
				    gridNodeTarget:runAction(seq)
				end
				-- local time2 = os.clock()
				-- print("==========左翻页时间===============",time2 - time1)
				local se = cc.Sequence:create({cc.DelayTime:create(0), cc.CallFunc:create(function(sender)
						TurnPage()
					end)})
				_LPVEMap:runAction(se)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local lduplicate_new_turn_right_terminal = {
            _name = "lduplicate_new_turn_right",
            _init = function (terminal) 
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- local time1 = os.clock()
            	local left_button = ccui.Helper:seekWidgetByName(instance.roots[1],"Button_zx_pve_left")
				local right_button = ccui.Helper:seekWidgetByName(instance.roots[1],"Button_zx_pve_right")
				left_button:setVisible(false)
				right_button:setVisible(false)
            	state_machine.lock("lduplicate_new_turn_right")
            	state_machine.lock("lduplicate_new_turn_left")
        		state_machine.lock("lpvenpc_to_turn")	            	
            	local sceneID = params._datas.sceneID
            	local open_scene_str =dms.string(dms["pve_scene"],tonumber(sceneID),pve_scene.open_scene) 
				if open_scene_str == nil then
	                state_machine.unlock("lduplicate_new_turn_right")
	            	state_machine.unlock("lduplicate_new_turn_left")						
					state_machine.unlock("lpvenpc_to_turn")	        						
					return
				end
				local open_scene_tab = zstring.split(open_scene_str , ",")
				local next_sceneID = tonumber(open_scene_tab[1])
				if next_sceneID == -1 then
	                state_machine.unlock("lduplicate_new_turn_right")
	            	state_machine.unlock("lduplicate_new_turn_left")	
            		state_machine.unlock("lpvenpc_to_turn")
					return					
				end
				if 	_ED.scene_current_state[next_sceneID] == "-1" then
	                state_machine.unlock("lduplicate_new_turn_right")
	            	state_machine.unlock("lduplicate_new_turn_left")		
					state_machine.unlock("lpvenpc_to_turn")	        		
					return
				end

            	local Panel_map = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_ship")

			    local gridNodeTarget = cc.NodeGrid:create()
			    gridNodeTarget:setContentSize(Panel_map:getContentSize())
			    gridNodeTarget:setAnchorPoint(cc.p(0,0))
			    gridNodeTarget:setPosition(cc.p(0,0))

			    local sprite = ShadowUtil_createSprite(Panel_map)
			    gridNodeTarget:addChild(sprite)
            	fwin:close(instance)
				cacher.destoryRefPools()
				cacher.remvoeUnusedArmatureFileInfoes()
				cacher.removeAllTextures()
				cacher.cleanSystemCacher()
				LDuplicateWindow._infoDatas._chapter = next_sceneID

				local _LPVEMap = LPVENewMap:new()
				_LPVEMap:init(next_sceneID)
				fwin:open(_LPVEMap, fwin._ui)
				state_machine.lock("lduplicate_new_turn_right")
            	state_machine.lock("lduplicate_new_turn_left")
			    _LPVEMap:addChild(gridNodeTarget)
			    state_machine.excute("lpve_main_scene_check_mission",0,next_sceneID)
				fwin:close(fwin:find("PVEStarCheatPanelClass"))
				state_machine.excute("open_star_cheat_panel",0,{next_sceneID,1})
				local seq = cc.Sequence:create({cc.PageTurn3D:create(0.25, cc.size(10,15)), cc.CallFunc:create(function(sender)
			        	sender:removeFromParent()
						local openother = cc.Sequence:create({cc.DelayTime:create(0), cc.CallFunc:create(function(sender)
									state_machine.excute("lduplicate_new_playainimation",0,"")	            						            		
									state_machine.excute("lpve_new_map_draw_box",0,"")	
									state_machine.excute("pve_star_cheat_update_panel_box",0,"")
							        state_machine.unlock("lduplicate_new_turn_right")
					            	state_machine.unlock("lduplicate_new_turn_left")
									state_machine.unlock("lpvenpc_to_turn")
									state_machine.excute("lduplicate_new_map_check_button_state")
							end)})
						_LPVEMap:runAction(openother)
			    	end)})
				-- local time2 = os.clock()
				-- print("==========右翻页时间===============",time2 - time1)
			    gridNodeTarget:runAction(seq)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        				-- 翻页
		local lpvenpc_to_turn_terminal = {
            _name = "lpvenpc_to_turn",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local currentNpcID = params._datas.currentNpcID
            	local turn_type = params._datas.turn_type
        		local function get_npc_state(SceneID,npc_id)
					local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], tonumber(SceneID), pve_scene.npcs), ",")
					local sceneState = tonumber(_ED.scene_current_state[SceneID])
					local npcSceneState = tonumber(tempNpcIds[tonumber(sceneState)])
					local boss_index = #tempNpcIds
					local bossID = tonumber(tempNpcIds[boss_index])
					if npcSceneState == nil then
						if npc_id == tonumber(tempNpcIds[1]) then
							return 1,false
						elseif npc_id == bossID then
							return nil, true
						else
							return nil, false
						end
					end
					if npc_id == npcSceneState + 1 then
						if npc_id == bossID then
							return 1,true
						else
							return 1,false
						end
					elseif npc_id < npcSceneState + 1 then
						if npc_id == bossID then
							return 0,true
						else						
							return 0,false
						end
					elseif npc_id > npcSceneState + 1 then
						if npc_id == bossID then
							return nil,true
						else					
							return nil,false
						end
					end
				end
            	if turn_type == "left" then
            		local last_npc_id = dms.int(dms["npc"],currentNpcID,npc.last_npc_id)
            		if last_npc_id == -1 then
            			return
            		end
					local last_NpcSceneID = dms.int(dms["npc"],last_npc_id,npc.scene_id)
					if last_NpcSceneID == -1 then
						return
					end


					local npc_state,bossFlag = get_npc_state(last_NpcSceneID,last_npc_id)
					local npc_window = fwin:find("LPVENpcClass")
					fwin:close(npc_window)

	    			if last_NpcSceneID ~= instance.sceneID then
						state_machine.excute("lduplicate_new_turn_left",0,{
							_datas = 
							{
								terminal_name = "lduplicate_new_turn_left", 
								terminal_state = 0, 
								sceneID = instance.sceneID ,
								isPressedActionEnabled = true
							}
							})
					end

					local new_npc_window = LPVENpc:new()
	    			new_npc_window:init(last_npc_id, 
							  last_NpcSceneID, 
							  bossFlag,
							  npc_state)
	    			fwin:open(new_npc_window,fwin._ui)
            	elseif turn_type == "right" then
            		local next_npc_id = dms.int(dms["npc"],currentNpcID,npc.next_npc_id)
            		if next_npc_id == -1 then
            			return
            		end
					local next_NpcSceneID = dms.int(dms["npc"],next_npc_id,npc.scene_id)
					if next_NpcSceneID == -1 then
						return
					end
					local npc_state,bossFlag = get_npc_state(next_NpcSceneID,next_npc_id)
					-- print("====================",npc_state,bossFlag)
					if npc_state == nil then
						return
					end
					local npc_window = fwin:find("LPVENpcClass")
					fwin:close(npc_window)

	    			if next_NpcSceneID ~= instance.sceneID then
						state_machine.excute("lduplicate_new_turn_right",0,{
							_datas = 
							{
								terminal_name = "lduplicate_new_turn_right", 
								terminal_state = 0, 
								sceneID = instance.sceneID ,
								isPressedActionEnabled = true
							}
							})
					end
					local new_npc_window = LPVENpc:new()
	    			new_npc_window:init(next_npc_id, 
							  next_NpcSceneID, 
							  bossFlag,
							  npc_state)
	    			fwin:open(new_npc_window,fwin._ui)
				end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local lduplicate_new_playainimation_terminal = {
            _name = "lduplicate_new_playainimation",
            _init = function (terminal) 
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            -- print("========================paly")
                for i,v in pairs(self.npcPanels) do
					v:setVisible(true)
            	end
            	for i,v in pairs(self.npcanimations) do
					csb.animationChangeToAction(v,1, 0, false)
            	end
            	self:checkTurnButtonState()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local lpve_new_map_draw_box_terminal = {
            _name = "lpve_new_map_draw_box",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.roots[1] ~= nil then
            		instance:drawPVERewardBox()
            	end
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local lduplicate_new_map_check_button_state_terminal = {
            _name = "lduplicate_new_map_check_button_state",
            _init = function (terminal) 
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:checkTurnButtonState()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(lpve_new_map_action_play_terminal)
		state_machine.add(lduplicate_new_npc_click_terminal)
		state_machine.add(lduplicate_new_turn_left_terminal)
		state_machine.add(lduplicate_new_turn_right_terminal)
		state_machine.add(lpvenpc_to_turn_terminal)
		state_machine.add(lduplicate_new_playainimation_terminal)
		state_machine.add(lpve_new_map_draw_box_terminal)
		state_machine.add(lduplicate_new_map_check_button_state_terminal)
        state_machine.init()
    end
    
    init_lpve_new_map_window_terminal()
end

function LPVENewMap:onUpdateDraw()
	local root = self.roots[1]
	local action = self.actions[1]
	
	self.npcIds = {}
	self.npcStates = {}
	local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], tonumber(self.sceneID), pve_scene.npcs), ",")
	local sceneState = tonumber(_ED.scene_current_state[self.sceneID])
	local tIndex = 1
	for i = 1, table.getn(tempNpcIds) do
		local npcState = 0
		if sceneState + 1 == i then
			npcState = 1
			self.npcIds[tIndex] = tempNpcIds[i]
			self.npcStates[tIndex] = npcState
			break
		end
		self.npcIds[tIndex] = tempNpcIds[i]
		self.npcStates[tIndex] = npcState
		tIndex = tIndex + 1
	end
	-- npc
	local npcIdTableText = nil
	local npcIdTable = nil
	for i = 1, #tempNpcIds do
		-- print("========",tempNpcIds[i], self.npcStates[i], self.sceneID, i, i == #tempNpcIds)
		local _bossFlag = false
		if i == #tempNpcIds then
			_bossFlag = true
		end
		local Panel_map = ccui.Helper:seekWidgetByName(root,"Panel_map")
		local Panel = ccui.Helper:seekWidgetByName(root, string.format("Panel_pve_npc_%d",i))
		local Panel_new = ccui.Helper:seekWidgetByName(root, string.format("Panel_pve_new_%d",i))
		Panel:removeAllChildren(true)
		local PanelSprite = Panel_map:getChildByName(string.format("Sprite_pve_npc_%d",i))
		PanelSprite:setTexture(string.format("images/ui/pve_sn/pve_map_icon_bg/npc_pic_%d.png",tempNpcIds[i]))
		if self.npcStates[i] ~= nil then

			local pathId = dms.string(dms["pve_scene"], self.sceneID, pve_scene.scene_map_id)
			local jsonFile = string.format("images/ui/pve_sn/pve_map_icon_bg/npc_animation_%d.json",tempNpcIds[i])
			local atlasFile = string.format("images/ui/pve_sn/pve_map_icon_bg/npc_animation_%d.atlas",tempNpcIds[i])
			if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
			    local armature = sp.spine(jsonFile, atlasFile, 1, nil, npcAnimations[1], true, nil) 
			   	armature.animationNameList = npcAnimations
			    sp.initArmature(armature, true)  
			    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
			    armature._invoke = nil
			    Panel:addChild(armature)
			    csb.animationChangeToAction(armature,0, 0, nil)
			    Panel:setVisible(false)
			    table.insert(self.npcanimations,armature)
			    table.insert(self.npcPanels,Panel)
			end
		end
		if self.npcStates[i] == 1 then
			local pathId = dms.string(dms["pve_scene"], self.sceneID, pve_scene.scene_map_id)
			local jsonFile = string.format("images/ui/pve_sn/pve_map_icon/map_%s.json",pathId)
			local atlasFile = string.format("images/ui/pve_sn/pve_map_icon/map_%s.atlas",pathId)
		    local armature = sp.spine(jsonFile, atlasFile, 1, nil, npcAnimationsNew[1], true, nil) 
		   	armature.animationNameList = npcAnimationsNew
		    sp.initArmature(armature, true)  
		    -- armature:getAnimation():setSpeedScale(1.0)
		    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
		    -- armature._actionIndex = i
		    -- armature._nextAction = i
		    armature._invoke = nil
		    Panel_new:removeAllChildren(true)
		    Panel_new:addChild(armature)
		    csb.animationChangeToAction(armature, i-1 ,i-1, nil)
			if tonumber(_ED.user_info.user_grade) < 14 and missionIsOver() == true then
				app.load("client.cells.duplicate.pageview_seat_role_guide_cell")
				local guide = PageViewSeatRoleGuide:createCell()
				guide:setPosition(cc.p(Panel_new:getContentSize().width * 0.5, Panel_new:getContentSize().height*0.5))
				Panel_new:addChild(guide)		    
			end
		end
		
		local Sprite_boss = Panel_map:getChildByName(string.format("Sprite_boss_%d", i)) 
		-- if _bossFlag == true then
		-- 	Sprite_boss:setVisible(true)
		-- end	
		-- 	print("=================",tempNpcIds[i])
		local boss_index = dms.int(dms["npc"],tempNpcIds[i],npc.base_pic)
		if boss_index >= 2 then
			Sprite_boss:setVisible(true)
		end
		if self.npcStates[i] == nil then
			display:gray(PanelSprite)
			display:gray(Sprite_boss)	
		end


		Panel:setTouchEnabled(true)
		fwin:addTouchEventListener(Panel, nil, 
		{
			terminal_name = "lduplicate_new_npc_click", 
			terminal_state = 0, 
			npcID = tempNpcIds[i] ,
			sceneID = self.sceneID ,
			bossFlag = _bossFlag ,
			npcState = self.npcStates[i],
			isPressedActionEnabled = false
		}, 
		nil, 0)
		--绘制星星状态
		local maxStar = tonumber(dms.string(dms["npc"], tempNpcIds[i], npc.difficulty_include_count))
		local CurStar = 0
		if zstring.tonumber(_ED.npc_state[tonumber(""..tempNpcIds[i])]) < zstring.tonumber(_ED.npc_max_state[tonumber(""..tempNpcIds[i])]) and zstring.tonumber(_ED.npc_state[tonumber(""..tempNpcIds[i])]) ~= 0 then
			CurStar = tonumber(_ED.npc_max_state[tonumber(""..tempNpcIds[i])])
		else
			CurStar = tonumber(_ED.npc_state[tonumber(""..tempNpcIds[i])])
		end
		local star_panel =  ccui.Helper:seekWidgetByName(root, string.format("Panel_stars_%d", i))
	    local csbPVEstar = csb.createNode("duplicate/map/pve_zx_map_star.csb")
	    local star_root = csbPVEstar:getChildByName("root")
	    self.star_root = star_root
	    star_panel:addChild(csbPVEstar)
		
		local star1 = ccui.Helper:seekWidgetByName(star_root, "Image_star_1")
		local star2 = ccui.Helper:seekWidgetByName(star_root, "Image_star_2")
		local star3 = ccui.Helper:seekWidgetByName(star_root, "Image_star_3")
		if CurStar == 1 then  
			star1:setVisible(true)
			star2:setVisible(false)
			star3:setVisible(false)
		elseif CurStar == 2 then 
			star1:setVisible(true)
			star2:setVisible(true)
			star3:setVisible(false)
		elseif CurStar == 3 then
			star1:setVisible(true)
			star2:setVisible(true)
			star3:setVisible(true)
		else
			star1:setVisible(false)
			star2:setVisible(false)
			star3:setVisible(false)
		end
	end
	-- npc创建的时候播放npc出现动画，只播放一次，这里做状态重置，因为新npc在下个地图，这个地图创建的npc不播动画
	LDuplicateWindow._infoDatas._isNewNPCAction = true    
end

function LPVENewMap:getNpcState(_npcId)
	for i, v in pairs(self.npcIds) do
		if tonumber(v) == tonumber(_npcId) then
			return self.npcStates[i]
		end
	end
	return nil
end

function LPVENewMap:drawPVERewardBox()
	local root = self.roots[1]
	
	local npcIdListStr = dms.string(dms["pve_scene"], self.sceneID, pve_scene.design_npc)
	local npcIDTable = zstring.split(npcIdListStr, ",")
	
	for i = 1, #npcIDTable do
		local npcBoxPad = nil 
		npcBoxPad=ccui.Helper:seekWidgetByName(root, string.format("Panel_pve_baoxiang_%d", i))
		if npcBoxPad ~= nil then
			table.insert(self.rewardBoxes, npcBoxPad)
		end
	end
	
	for i, v in ipairs(self.rewardBoxes) do
		local chest_cell = PlotCopyChest:createCell()
		local param = {state = 0, starNum = 0}
		local drawState = _ED.scene_draw_chest_npcs[npcIDTable[i]]
		local npcState = self:getNpcState(npcIDTable[i])
		
		if npcState ~= nil and npcState ~= 1 and drawState ~= 1 then
			param.state = 1
		elseif drawState == 1 then 	
			param.state = 2
		end	

		if param.state == 2 then
			v:setVisible(false)
		else
			chest_cell:init(4, param, self.sceneID, tonumber(npcIDTable[i]), npcState)
			v:removeAllChildren(true)
			v:addChild(chest_cell)
			v.roots = chest_cell.roots
		end
		if param.state == 1 then
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_battle_control_box",
			_widget = v,
			_invoke = nil,
			_interval = 0.5,})
		end
	end
end

function LPVENewMap:onEnterTransitionFinish()	
	--暂时屏蔽
	
	-- if _ED.is_open_get_last_scend_reward == true and missionIsOver() == true then
	-- 	_ED.is_open_get_last_scend_reward = false
	-- 	app.load("client.landscape.duplicate.pve.LPVELastSceneReward")
	-- 	local by_open_scene = dms.string(dms["pve_scene"],self.sceneID,pve_scene.by_open_scene)
	-- 	local last_sceneID = tonumber(by_open_scene)
	-- 	if last_sceneID ~= -1 then
	-- 		state_machine.excute("lpve_last_scene_reward_open",0,last_sceneID)
	-- 	end	
	-- 	-- print("=============打开领取上一关所有奖励的界面")
	-- end
	if _ED._fight_is_win_bool ~= nil and _ED._fight_is_win_bool == true then
		
    	_ED._fight_is_win_bool = false
		app.load("client.activity.ActivityFirstRecharge")
		state_machine.excute("rechargeable_open",0,0)	
    end	
    self:checkWorldBoss()
end
function LPVENewMap:checkWorldBoss( ... )
	if _ED.rebel_army_mould_id ~= "" and _ED.rebel_army_mould_id ~= nil then
		app.load("client.campaign.worldboss.BetrayArmyNpcArrival")
		local BetrayArmyPve = BetrayArmyNpcArrival:new()
		BetrayArmyPve:init()
		fwin:open(BetrayArmyPve, fwin._windows)
	end
end
function LPVENewMap:afterOpen()
	if self.play_animation == true then
		local root = self.roots[1]
		self.play_animation = false
		state_machine.excute("lduplicate_new_playainimation",0,"")	
		self:drawPVERewardBox()
		self:checkTurnButtonState()

		if fwin:find("PVEStarCheatPanelClass") == nil then
			state_machine.excute("open_star_cheat_panel",0,{self.sceneID})
		else
			fwin:close(fwin:find("PVEStarCheatPanelClass"))
			state_machine.excute("open_star_cheat_panel",0,{self.sceneID})
		end			
	end
end
function LPVENewMap:checkTurnButtonState()
	local root = self.roots[1]
	local left_button = ccui.Helper:seekWidgetByName(root,"Button_zx_pve_left")
	local right_button = ccui.Helper:seekWidgetByName(root,"Button_zx_pve_right")
	local sceneID = self.sceneID
	local open_scene_str =dms.string(dms["pve_scene"],tonumber(sceneID),pve_scene.open_scene) 
	local open_scene_tab = zstring.split(open_scene_str , ",")
	local next_sceneID = tonumber(open_scene_tab[1])
	if next_sceneID == -1 or _ED.scene_current_state[next_sceneID] == "-1"  then
		right_button:setVisible(false)
	else
		right_button:setVisible(true)
	end

	local by_open_scene = dms.string(dms["pve_scene"],sceneID,pve_scene.by_open_scene)
	local last_sceneID = tonumber(by_open_scene)
	if last_sceneID == -1 then
		left_button:setVisible(false)
	else
		left_button:setVisible(true)
	end
end
function LPVENewMap:onInit()

	local pathId = dms.string(dms["pve_scene"], self.sceneID, pve_scene.scene_map_id)
	filePath = string.format("duplicate/map/pve_zx_map_%d.csb", pathId)
    local csbPVEMap = csb.createNode(filePath)
    local root = csbPVEMap:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbPVEMap)
	
	local action = csb.createTimeline(filePath)
	root:runAction(action)
	table.insert(self.actions, action)
	local left_button = ccui.Helper:seekWidgetByName(root,"Button_zx_pve_left")
	local right_button = ccui.Helper:seekWidgetByName(root,"Button_zx_pve_right")	
	fwin:addTouchEventListener(right_button, nil, 
	{
		terminal_name = "lduplicate_new_turn_right", 
		terminal_state = 0, 
		sceneID = self.sceneID ,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	fwin:addTouchEventListener(left_button, nil, 
	{
		terminal_name = "lduplicate_new_turn_left", 
		terminal_state = 0, 
		sceneID = self.sceneID ,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	left_button:setVisible(false)
	right_button:setVisible(false)
	self:onUpdateDraw()
	-- self:drawPVERewardBox()
	
end
function LPVENewMap:init(_sceneID,play_animation)
	self.sceneID = _sceneID
	self.play_animation = play_animation
	self:onInit()
end

function LPVENewMap:close()
	local root = self.roots[1]
	local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], tonumber(self.sceneID), pve_scene.npcs), ",")
	for i = 1, #tempNpcIds do
		-- print("========",tempNpcIds[i], self.npcStates[i], self.sceneID, i, i == #tempNpcIds)
		local _bossFlag = false
		if i == #tempNpcIds then
			_bossFlag = true
		end
		local Panel = ccui.Helper:seekWidgetByName(root, string.format("Panel_pve_npc_%d",i))
		local Panel_new = ccui.Helper:seekWidgetByName(root, string.format("Panel_pve_new_%d",i))
		local star_panel =  ccui.Helper:seekWidgetByName(root, string.format("Panel_stars_%d", i))
		Panel:removeAllChildren(true)
		Panel_new:removeAllChildren(true)
		star_panel:removeAllChildren(true)
	end
	

	local npcIdListStr = dms.string(dms["pve_scene"], self.sceneID, pve_scene.design_npc)
	local npcIDTable = zstring.split(npcIdListStr, ",")
	
	for i = 1, #npcIDTable do
		local npcBoxPad = ccui.Helper:seekWidgetByName(root, string.format("Panel_pve_baoxiang_%d", i))
		npcBoxPad:removeAllChildren(true)
	end
end
function LPVENewMap:onExit()	
	-- state_machine.remove("lpve_map_action_play")
	-- state_machine.remove("lduplicate_new_npc_click")
	-- state_machine.remove("lduplicate_new_turn_left")
	-- state_machine.remove("lduplicate_new_turn_right")
	-- state_machine.remove("lpvenpc_to_turn")
end
