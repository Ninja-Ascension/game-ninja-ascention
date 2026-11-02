-- ----------------------------------------------------------------------------------------------------
-- 说明：角色对话场景
-- 创建时间
-- 作者：肖雄
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

RoleDialogue = nil

if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
	or __lua_project_id == __lua_project_red_alert 
	or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
	then
--------------------------------------------------------------------------------------------------------------------------------------
-----龙虎门的对话框  开始-------------------------------------------------------------------------------------------------------------

	RoleDialogue = class("RoleDialogueClass", Window)
	
	function RoleDialogue:ctor()
		self.super:ctor()
		
		self.roots = {}
		self.actions = {}
		
		self.head = nil
		self.action = nil
		
		self.color = nil
		self.animationList = {}

		self.left_actions = false
		self.right_actions = false
		
		local function init_RoleDialogue_terminal()
			local role_role_dialogue_touch_terminal = {
				_name = "role_dialogue_touch",
				_init = function (terminal)
					
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					instance:touchNextMission()
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}
			
			
			
			local role_dialogue_push_terminal = {
				_name = "role_dialogue_push",
				_init = function (terminal)
					
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					instance:init(params._mission, params._missions, params._eventIndex)
					instance:updateChat()
					instance.delaytime = 0.2
					instance:unregisterOnNoteUpdate(self)
					instance:registerOnNoteUpdate(self, 0.02)
					-- instance:changeCgState()
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}
			
			local role_dialogue_out_terminal = {
				_name = "role_dialogue_out",
				_init = function (terminal)
					
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)				
						local temp_mission = self.mission
						fwin:close(instance)
						saveExecuteEvent(temp_mission, true)
						cc.Director:getInstance():getTextureCache():removeUnusedTextures()
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}
			
			state_machine.add(role_role_dialogue_touch_terminal)
			state_machine.add(role_dialogue_push_terminal)
			state_machine.add(role_dialogue_out_terminal)
			state_machine.init()
		end
		
		init_RoleDialogue_terminal()
	end


	function RoleDialogue:onEnterTransitionFinish()
		local csbres = nil
		if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			csbres = "chat/dialog_lhm.csb"
		else
			csbres = "Chat/dialog_lhm.csb"
		end
		local csbRoleDialogue = csb.createNode(csbres)
		self:addChild(csbRoleDialogue)
		local root = csbRoleDialogue:getChildByName("root")
		table.insert(self.roots, root)

	    local action = csb.createTimeline(csbres)
    	table.insert(self.actions, action)

    	csbRoleDialogue:runAction(action)
        
        if __lua_project_id == __lua_project_red_alert 
        	or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
        	then
        	action:play("window_open", false)
        else
        	action:play("chat_heiping_in", false)
        end
	    action:setFrameEventCallFunc(function (frame)
	        if nil == frame then
	            return
	        end
	        local str = frame:getEvent()
	        if str == "chat_heiping_in_over" then
	        	action:play("chat_heiping_cs", true)
	        elseif str == "chat_heiping_out_over" then
	        end
	    end)


		self._last_left_head = self.left_head
		self._last_right_head = self.right_head
		self._last_dir = self._dir
		
		self.Panel_dialog_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_dialog_1")
		
		fwin:addTouchEventListener(self.Panel_dialog_1, nil, {terminal_name = "role_dialogue_touch", terminal_state = 1}, nil, 0)

		-- 左边
		self.panel_left = ccui.Helper:seekWidgetByName(root, "Panel_role_1")
		self.Image_r_1 = ccui.Helper:seekWidgetByName(root, "Image_r_1")
		self.panel_role_left = ccui.Helper:seekWidgetByName(root, "Panel_role_01")
		self.panel_name_left = ccui.Helper:seekWidgetByName(root, "Text_role_neme")
		self.panel_chat_left = ccui.Helper:seekWidgetByName(root, "Text_xx_1")
		
		-- 右边
		self.panel_right = ccui.Helper:seekWidgetByName(root, "Panel_role_2")
		self.Image_r_2 = ccui.Helper:seekWidgetByName(root, "Image_r_2")
		self.panel_role_right = ccui.Helper:seekWidgetByName(root, "Panel_role_02")
		self.panel_name_right = ccui.Helper:seekWidgetByName(root, "Text_role_neme_0")
		self.panel_chat_right = ccui.Helper:seekWidgetByName(root, "Text_xx_2")

		self.panel_cg_dh = ccui.Helper:seekWidgetByName(root, "Panel_cg_dh")
		self.Panel_15698 = ccui.Helper:seekWidgetByName(root, "Panel_15698")

		-- 用于左右头像层级切换
		self.topZOrder = #self.Panel_dialog_1:getChildren()
		self.bottomZOrder = -1

		if nil ~= self.panel_cg_dh then
			self.Panel_dialog_1:reorderChild(self.panel_cg_dh, self.bottomZOrder - 1)
		end

		if nil ~= self.Panel_15698 then
			self.Panel_dialog_1:reorderChild(self.Panel_15698, self.bottomZOrder - 2)
		end
		
		self:updateChat()
		self:registerOnNoteUpdate(self, 0.02)
	end

	local delaytime = 0.2
	function RoleDialogue:onUpdate( dt )
		delaytime = delaytime - dt
		if delaytime <= 0 then
			self:unregisterOnNoteUpdate(self)
			delaytime = 0.2
			self:changeCgState()
		end
	end

	function RoleDialogue:onArmatureDataLoad( ... )
    -- body
	end

	function RoleDialogue:onArmatureDataLoadEx( ... )
	    -- body
	end

	function RoleDialogue:loadArmature( ... )
		local path = ""
		for i,v in ipairs(self.cgList) do
			if tonumber(v) > 0 then
				path = "images/ui/effice/dialog_cg/dialog_cg_"..v.."/dialog_cg_"..v..".ExportJson"
				ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path)
			end
		end
	end

	function RoleDialogue:unLoadArmature( ... )
		local path = ""
		for i,v in ipairs(self.cgList) do
			if tonumber(v) > 0 then
				path = "images/ui/effice/dialog_cg/dialog_cg_"..v.."/dialog_cg_"..v..".ExportJson"
				ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(path)
			end
		end
	end
	
	function RoleDialogue:updateChat()
		if nil ~= self.panel_role_left then
			self.panel_role_left:removeAllChildren()
		end
		if __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
			then
			if nil ~= self.panel_role_left then
				local ani_index_left = zstring.split(self.left_head,",")
				if ani_index_left ~= nil and ani_index_left[1] ~= nil then
					local animationName = "animation" -- string.format("big_head_%d", ani_index_left[1])
					local jsonFile = string.format("images/face/big_head/big_head_%d.json", ani_index_left[1])
					local atlasFile = string.format("images/face/big_head/big_head_%d.atlas", ani_index_left[1])
					if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
						local animation = sp.spine(jsonFile, atlasFile, 1, 0, animationName, true, nil)
						self.panel_role_left:addChild(animation)
					end
				end
			end

			if nil ~= self.panel_role_right then
				self.panel_role_right:removeAllChildren()
				local ani_index_right = zstring.split(self.right_head,",")
				if ani_index_right ~= nil and ani_index_right[1] ~= nil then
					animationName = "animation" -- string.format("big_head_%d", ani_index_right[1])
					jsonFile = string.format("images/face/big_head/big_head_%d.json", ani_index_right[1])
					atlasFile = string.format("images/face/big_head/big_head_%d.atlas", ani_index_right[1])
					if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
						local animation = sp.spine(jsonFile, atlasFile, 1, 0, animationName, true, nil)
						self.panel_role_right:addChild(animation)
					end
				end
			end
		elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			self.panel_role_left:removeBackGroundImage()
			local imageleft = string.format("images/face/big_head/big_head_%d.png", tonumber(self.left_head))
			if imageleft ~= nil then
				self.panel_role_left:setBackGroundImage(imageleft)
			end
			self.panel_role_right:removeAllChildren()
			self.panel_role_right:removeBackGroundImage()
			local imageright = string.format("images/face/big_head/big_head_%d.png", tonumber(self.right_head))
			if imageright ~= nil then
				self.panel_role_right:setBackGroundImage(imageright)
			end
		else
			local animationName = string.format("big_head_%d", self.left_head)
			local jsonFile = string.format("images/face/big_head/big_head_%d.json", self.left_head)
			local atlasFile = string.format("images/face/big_head/big_head_%d.atlas", self.left_head)
			if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
				local animation = sp.spine(jsonFile, atlasFile, 1, 0, animationName, true, nil)
				self.panel_role_left:addChild(animation)
			end

			self.panel_role_right:removeAllChildren()
			animationName = string.format("big_head_%d", self.right_head)
			jsonFile = string.format("images/face/big_head/big_head_%d.json", self.right_head)
			atlasFile = string.format("images/face/big_head/big_head_%d.atlas", self.right_head)
			if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
				local animation = sp.spine(jsonFile, atlasFile, 1, 0, animationName, true, nil)
				self.panel_role_right:addChild(animation)
			end
		end
		-- if __lua_project_id == __lua_project_red_alert then

		-- 	local quality_left = zstring.split(self.left_head,",")[2]
		-- 	if nil ~= quality_left then
		-- 		-- local quality_right = dms.int(dms["ship_mould"],self.right_head,ship_mould.ship_type)
		-- 		self.panel_name_left:setColor(cc.c3b(color_Type[quality_left+1][1],color_Type[quality_left+1][2],color_Type[quality_left+1][3]))
		-- 		-- self.panel_name_right:setColor(cc.c3b(color_Type[quality_right+1][1],color_Type[quality_right+1][2],color_Type[quality_right+1][3]))
		-- 	end
		-- end
		if self._dir == 0 then --左边
			local quality_left = nil 
			local heads = zstring.split("" ..self.left_head,",")
			if #heads >= 2 then 
				quality_left = zstring.split(self.left_head,",")[2]
			end
			if nil ~= quality_left then
				if nil ~= self.panel_name_left then
					self.panel_name_left:setColor(cc.c3b(color_Type[quality_left+1][1],color_Type[quality_left+1][2],color_Type[quality_left+1][3]))
				end
			end

			if nil ~= self.panel_right then
				self.panel_right:setVisible(false)
			end
			if nil ~= self.Image_r_2 then
				self.Image_r_2:setVisible(false)
			end

			if nil ~= self.panel_left then
				self.panel_left:setVisible(true)
			end
			if nil ~= self.Image_r_1 then
				self.Image_r_1:setVisible(true)
			end
			-- self.panel_role_left:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", self.left_head))
			if nil ~= self.panel_name_left then
				self.panel_name_left:setString(self._name)
			end

			if nil ~= self.panel_chat_left then
				self.panel_chat_left:setString(self._string)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
					self.panel_chat_left:removeAllChildren(true)
					local _richText2 = ccui.RichText:create()
					_richText2:ignoreContentAdaptWithSize(false)

					local richTextWidth = self.panel_chat_left:getContentSize().width
			        if richTextWidth == 0 then
				        richTextWidth = self.panel_chat_left:getFontSize() * 6
				    end

					_richText2:setContentSize(cc.size(self.panel_chat_left:getContentSize().width, 0))
					_richText2:setAnchorPoint(cc.p(0, 0))
					self.panel_chat_left:setString("")
					local rt, count, text = draw.richTextCollectionMethod(_richText2, 
					self._string, 
					cc.c3b(255, 255, 255),
					cc.c3b(255, 255, 255),
					0, 
					0, 
					self.panel_chat_left:getFontName(), 
					self.panel_chat_left:getFontSize(),
					chat_rich_text_color)
					_richText2:formatTextExt()
					local rsize = _richText2:getContentSize()
					_richText2:setPositionY((self.panel_chat_left:getContentSize().height-rsize.height)/2+rsize.height)
					self.panel_chat_left:addChild(_richText2)
				end
			end
			
			if nil ~= self.panel_role_left then
				self.panel_role_left:setColor(cc.c3b(255,255,255))
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
					if self.left_actions == false then
						self.actions[1]:play("chat_heiping_right", false)
						self.left_actions = true
						self.right_actions = false
					end
				end
			end

			if nil ~= self.panel_role_right then
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_role_right:setColor(cc.c3b(150,150,150))
				else
					self.panel_role_right:setColor(cc.c3b(50,50,50))
				end
			end
			
			if nil ~= self.Panel_dialog_1 then
				if nil ~= self.panel_role_left  then
					self.Panel_dialog_1:reorderChild(self.panel_role_left ,self.topZOrder)
				end

				if nil ~= self.panel_role_right then
					self.Panel_dialog_1:reorderChild(self.panel_role_right, self.bottomZOrder)
				end
			end
		else
			local quality_right = nil
			local heads = zstring.split("" ..self.right_head,",")
			if #heads >= 2 then 
				quality_right= zstring.split(self.right_head,",")[2]
			end
			if nil ~= quality_right then
				if nil ~= self.panel_name_right then
					self.panel_name_right:setColor(cc.c3b(color_Type[quality_right+1][1],color_Type[quality_right+1][2],color_Type[quality_right+1][3]))
				end
			end

			if nil ~= self.panel_left then
				self.panel_left:setVisible(false)
			end
			if nil ~= self.Image_r_1 then
				self.Image_r_1:setVisible(false)
			end
			if nil ~= self.panel_right then
				self.panel_right:setVisible(true)
			end
			if nil ~= self.Image_r_2 then
				self.Image_r_2:setVisible(true)
			end
			-- self.panel_role_right:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", self.right_head))
			if nil ~= self.panel_name_right then
				self.panel_name_right:setString(self._name)
			end
			if nil ~= self.panel_chat_right then
				self.panel_chat_right:setString(self._string)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
					self.panel_chat_right:removeAllChildren(true)
					local _richText2 = ccui.RichText:create()
					_richText2:ignoreContentAdaptWithSize(false)

					local richTextWidth = self.panel_chat_right:getContentSize().width
			        if richTextWidth == 0 then
				        richTextWidth = self.panel_chat_right:getFontSize() * 6
				    end
			    
					_richText2:setContentSize(cc.size(richTextWidth, 0))
					_richText2:setAnchorPoint(cc.p(0, 0))
					self.panel_chat_right:setString("")
					local rt, count, text = draw.richTextCollectionMethod(_richText2, 
					self._string, 
					cc.c3b(255, 255, 255),
					cc.c3b(255, 255, 255),
					0, 
					0, 
					self.panel_chat_right:getFontName(), 
					self.panel_chat_right:getFontSize(),
					chat_rich_text_color)
					_richText2:formatTextExt()
					local rsize = _richText2:getContentSize()
					_richText2:setPositionY((self.panel_chat_right:getContentSize().height-rsize.height)/2+rsize.height)
					self.panel_chat_right:addChild(_richText2)
				end
			end
			
			if nil ~= self.panel_role_right then
				self.panel_role_right:setColor(cc.c3b(255,255,255))
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
					if self.right_actions == false then
						self.actions[1]:play("chat_heiping_left", false)
						self.right_actions = true
						self.left_actions = false
					end
				end
			end
			if nil ~= self.panel_role_left then
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_role_left:setColor(cc.c3b(150,150,150))
				else
					self.panel_role_left:setColor(cc.c3b(50,50,50))
				end
			end
			
			if nil ~= self.Panel_dialog_1 then
				if nil ~= self.panel_role_left then
					self.Panel_dialog_1:reorderChild(self.panel_role_left, self.bottomZOrder)
				end
				if nil ~= self.panel_role_right then
					self.Panel_dialog_1:reorderChild(self.panel_role_right, self.topZOrder)
				end
			end
		end
		local root = self.roots[1]
		local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
		local Image_10 = ccui.Helper:seekWidgetByName(root, "Image_10")
		if nil ~= Image_1 then
			Image_1:setVisible(true)
		end
		if nil ~= Image_10 then
			Image_10:setVisible(true)
		end
		if nil ~= self.panel_role_left then
			self.panel_role_left:setVisible(true)
		end
		if nil ~= self.panel_role_right then
			self.panel_role_right:setVisible(true)
		end
		if self._string == "" then
			if nil ~= Image_1 then
				Image_1:setVisible(false)
			end
			if nil ~= Image_10 then
				Image_10:setVisible(false)
			end
			if nil ~= self.panel_left then
				self.panel_left:setVisible(false)
			end
			if nil ~= self.Image_r_1 then
				self.Image_r_1:setVisible(false)
			end
			if nil ~= self.panel_right then
				self.panel_right:setVisible(false)
			end
			if nil ~= self.Image_r_2 then
				self.Image_r_2:setVisible(false)
			end
			if nil ~= self.panel_role_left then
				self.panel_role_left:setVisible(false)
			end
			if nil ~= self.panel_role_right then
				self.panel_role_right:setVisible(false)
			end
		end
	end
	

	function RoleDialogue:onExit()
		state_machine.excute("fight_role_controller_update_dialog_state", 0 , false)
		local action = self.actions[1]
		action:play("chat_heiping_out", false)
		self.animationList = {}
		self:unLoadArmature()
		state_machine.remove("role_dialogue_touch")
		state_machine.remove("role_dialogue_out")
		state_machine.remove("role_dialogue_push")
	end

	function RoleDialogue:createCell()
		local cell = RoleDialogue:new()
		cell:registerOnNodeEvent(cell)
		return cell
	end
	
	function RoleDialogue:init(current_mission, missions, eventIndex)
		-- print("enter next mission---------------")
		state_machine.excute("fight_role_controller_update_dialog_state", 0 , true)
		self.mission = current_mission
		self.missions = missions
		self.eventIndex = eventIndex
		self._dir = dms.atoi(self.mission, mission_param1)
		self.left_head = dms.atos(self.mission, mission_param2)
		self.right_head = dms.atos(self.mission, mission_param3)
		self._name = dms.atos(self.mission, mission_param4)
		local msg = dms.atos(self.mission, mission_param5)
		self._string = zstring.replace(msg, "{}", _ED.user_info.user_name)
		self.left_look = dms.atoi(self.mission, mission_param6)
		self.right_look = dms.atoi(self.mission, mission_param7)
		self.cgList = zstring.split(dms.atos(self.mission, mission_param8), ",")
		self:loadArmature()
		self.isClearAllCG = false
		if tonumber(dms.atos(self.mission, mission_param10)) == 1 then
			self.isClearAllCG = true
		end
		self.currentCgIndex = 0
		self.currentCgFrame = 0

		for i,v in ipairs(self.cgList) do
			if tonumber(v) > 0 then
				self.lastAniIndex = i
			end
		end

		if self._name == "{}" then
			self._name = _ED.user_info.user_name
		end
		
		if self.left_head == "{}" then
			if __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
				then
				if tonumber(_ED.user_info.user_gender) == 1 then
					self.left_head = "301,4"
				else
					self.left_head = "302,4"
				end
			else
				for i, shipInfo in pairs(_ED.user_ship) do
					if shipInfo.ship_id~= nil then
						local shipData = dms.element(dms["ship_mould"],shipInfo.ship_template_id)
						if dms.atoi(shipData, ship_mould.captain_type) == 0 then
							self.left_head = dms.atos(shipData, ship_mould.bust_index)
							self.left_head = tonumber(self.left_head) - 1000
							if shipInfo._head ~= nil then
								self.left_head = shipInfo._head
							end
						end
					end
				end
			end
		end
		
		if self.right_head == "{}" then
			if __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
				then
				if tonumber(_ED.user_info.user_gender) == 1 then
					self.left_head = "301,4"
				else
					self.left_head = "302,4"
				end
			else
				for i, shipInfo in pairs(_ED.user_ship) do
					if shipInfo.ship_id~= nil then
						local shipData = dms.element(dms["ship_mould"],shipInfo.ship_template_id)
						if dms.atoi(shipData, ship_mould.captain_type) == 0 then
							self.right_head = dms.atos(shipData, ship_mould.bust_index)
							self.right_head = tonumber(self.right_head) - 1000
							if shipInfo._head ~= nil then
								self.right_head = shipInfo._head
							end
						end
					end
				end
			end
		end
		if __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
			then
		else
			self.left_head = tonumber(self.left_head)
			self.right_head = tonumber(self.right_head)
		end
		self._isBoxAllIn = false

		local waitCd = dms.atoi(self.mission, mission_param11)
		if waitCd > 0 then
			fwin:addService({
	            callback = function ( params )
	            	local tmission = params[1]
	            	local twindows = params[2]
	            	if nil ~= twindows and twindows.mission == tmission then
	                	state_machine.excute("role_dialogue_touch", 0, nil)
	            	end
	            	params[1] = nil
	            	params[2] = nil
	            	params = nil
	            end,
	            delay = waitCd,
	            params = {self.mission, self}
	        })
	    end
	end
	
	function RoleDialogue:touchNextMission()
		local eventCount = #self.missions
		local nextMission = (self.eventIndex + 1) < eventCount and self.missions[self.eventIndex + 2] or nil
		if nextMission ~= nil then
			if __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
				then
	        	self.actions[1]:play("window_open", false)
	        end
			local eventType = dms.atos(nextMission, mission_execute_type)
			if eventType ~= execute_type_dialog and eventType ~= execute_type_treasure_drop then
				state_machine.excute("role_dialogue_out", 0, "role_dialogue_out.")
			else
				saveExecuteEvent(self.mission, true)
			end
		else
			state_machine.excute("role_dialogue_out", 0, "role_dialogue_out.")
		end	
	end

	function RoleDialogue:changeCgState( ... )
		for i,v in pairs(self.cgList) do
			if i > self.currentCgIndex and tonumber(v) > 0 then
				self.currentCgFrame = v
				self.currentCgIndex = i
				-- print("search to change next cg......", v, i)
				self:updateCGArmature()
				return
			end
		end
	end

	function RoleDialogue:updateCGArmature()
		local armature = nil
		for i,v in ipairs(self.animationList) do
			if v._frame == self.currentCgFrame then
				self.panel_cg_dh:removeChildByTag(self.currentCgFrame, true)
				table.remove(self.animationList, ""..i)
			end
		end

        local function changeActionCallback( armatureBack )
        	local _self = armatureBack._self
        	-- print("play frame end---------------", _self.currentCgFrame, _self.currentCgIndex)
        	armatureBack:pause()
            if _self.lastAniIndex == _self.currentCgIndex then
            	if _self._string == "" then
            		state_machine.excute("role_dialogue_touch", 0, nil)
            	end
            	if _self.isClearAllCG == true then
            		_self.panel_cg_dh:removeAllChildren()
            		_self.animationList = {}
            	end
            else
            	_self:changeCgState()
            end
        end

        if armature == nil then
			-- print("create armature frame = ", self.currentCgFrame)
			armature = ccs.Armature:create("dialog_cg_"..self.currentCgFrame)
			table.insert(self.animationList, {_frame = self.currentCgFrame, _armature = armature})
			draw.initArmature(armature, nil, -1, 0, 1)
			armature._invoke = changeActionCallback
	        armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
	        armature._self = self
	        armature:setTag(self.currentCgFrame)
	        self.panel_cg_dh:addChild(armature)
		end

		if armature ~= nil then
			local frame = self.currentCgIndex
			if self.currentCgIndex >= 4 then
				frame = frame - 3
			end
			-- print("begin play frame----------------", frame)
			armature:resume()
			csb.animationChangeToAction(armature, tonumber(frame) - 1, tonumber(frame) -1, false)
		end
	end
	
-----龙虎门的对话框  结束-------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
else

	RoleDialogue = class("RoleDialogueClass", Window)

	function RoleDialogue:ctor()
		self.super:ctor()
		
		self.roots = {}
		
		self.mission = nil
		self.missions = nil
		self.eventIndex = nil
		
		app.load("client.mission.missionex.RoleDialogueWidget.RoleDialogueExpressionWidget")
		app.load("client.mission.missionex.RoleDialogueWidget.RoleDialogueLeftBoxWidget")
		app.load("client.mission.missionex.RoleDialogueWidget.RoleDialogueRightBoxWidget")
		app.load("client.mission.missionex.RoleDialogueWidget.RoleDialogueLeftRoleWidget")
		app.load("client.mission.missionex.RoleDialogueWidget.RoleDialogueRightRoleWidget")
		
		self._is_running_state = 0
		self._isBoxAllIn = false
		self._isAnimateEnd = false
		self._isShowTextEnd = true
		self._string = nil
		self._name = nil
		self._dir = nil
		self.left_head = nil
		self.right_head = nil
		self.left_look = nil
		self.right_look = nil
		self.bg_name = nil
		
		self._last_left_head = nil
		self._last_right_head = nil
		self._last_dir = nil
		self.light_Panel = nil
		self.light_area = nil
		self._light_start_x = nil
		self._light_start_y = nil
		self.light_image = nil
		
		-- 记录对话次数
		self._counts = 0
		
		local function init_RoleDialogue_terminal()
			local role_dialogue_event_over_terminal = {
				_name = "role_dialogue_event_over",
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
			
			local role_dialogue_box_in_terminal = {
				_name = "role_dialogue_box_in",
				_init = function (terminal)
					
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					local _listView = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_1")
					
					if self._dir == 1 then
						local rightBoxWidget = RoleDialogueRightBoxWidget:createCell()
						rightBoxWidget:init(self._name, self._string)
						_listView:insertCustomItem(rightBoxWidget, 0)
						
						state_machine.excute("role_dialogue_right_box_in", 0, rightBoxWidget)
					else
						local leftBoxWidget = RoleDialogueLeftBoxWidget:createCell()
						leftBoxWidget:init(self._name, self._string)
						_listView:insertCustomItem(leftBoxWidget, 0)
						
						state_machine.excute("role_dialogue_left_box_in", 0, leftBoxWidget)
					end
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}
			
			local role_dialogue_role_in_terminal = {
				_name = "role_dialogue_role_in",
				_init = function (terminal)
					
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					local _parent = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_20")
					local headLayout = ccui.Helper:seekWidgetByName(_parent, string.format("Panel_big_head_%d", self._dir+1))
					
					local _head = self._dir == 1 and self.right_head or self.left_head 
					local _expression = self._dir == 1 and self.right_look or self.left_look
					if self._dir == 1 then
						local rightRoleWidget = headLayout.rightRoleWidget
						if rightRoleWidget == nil then
							rightRoleWidget = RoleDialogueRightRoleWidget:createCell()
							rightRoleWidget:init(_head)
							rightRoleWidget:setTag(501)
							-- headLayout:removeAllChildren(true)
							headLayout:addChild(rightRoleWidget)
							headLayout.rightRoleWidget = rightRoleWidget
						else	
							rightRoleWidget:setShadow(false)
							rightRoleWidget.action1:play("right_role_dt", true)
						end
						
						-- 变暗处理
						local otherHeadLayout = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_big_head_1")
						local otherHeadWidget = otherHeadLayout:getChildByTag(501)
						if otherHeadWidget ~= nil then 
							-- print("变暗处理")
							otherHeadWidget.action1:gotoFrameAndPlay(10, 10, false)
							otherHeadWidget:setShadow(true)
						end
						
						state_machine.excute("role_dialogue_right_role_in", 0, {rightRoleWidget, _head, _expression})
					else
						local leftRoleWidget = headLayout.leftRoleWidget
						if leftRoleWidget == nil then
							leftRoleWidget = RoleDialogueLeftRoleWidget:createCell()
							leftRoleWidget:init(_head)
							leftRoleWidget:setTag(501)
							-- headLayout:removeAllChildren(true)
							headLayout:addChild(leftRoleWidget)
							headLayout.leftRoleWidget = leftRoleWidget
						else	
							leftRoleWidget:setShadow(false)
							leftRoleWidget.action1:play("left_role_dt", true)
						end
						
						-- 变暗处理
						local otherHeadLayout = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_big_head_2")
						local otherHeadWidget = otherHeadLayout:getChildByTag(501)
						if otherHeadWidget ~= nil then 
							-- print("变暗处理")
							otherHeadWidget.action1:gotoFrameAndPlay(10, 10, false)
							otherHeadWidget:setShadow(true)
						end
						
						state_machine.excute("role_dialogue_left_role_in", 0, {leftRoleWidget, _head, _expression})
					end
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}
			
			local role_dialogue_in_terminal = {
				_name = "role_dialogue_in",
				_init = function (terminal)
					
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					self._isAnimateEnd = false
					instance.action:gotoFrameAndPlay(20, 20, false)
					-- instance.action:setFrameEventCallFunc(function (frame)
						-- if nil == frame then
							-- return
						-- end

						-- local str = frame:getEvent()
						-- if str == "exit0" then
							-- self._isAnimateEnd = true
							
							-- state_machine.excute("role_dialogue_box_in", 0, "role_dialogue_box_in.")
						-- end
					-- end)
					self._isAnimateEnd = true
							
					state_machine.excute("role_dialogue_box_in", 0, "role_dialogue_box_in.")
					state_machine.excute("role_dialogue_role_in", 0, "role_dialogue_role_in.")
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}
			
			local role_dialogue_push_terminal = {
				_name = "role_dialogue_push",
				_init = function (terminal)
					
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					instance:init(params._mission, params._missions, params._eventIndex)
					if __lua_project_id == __lua_project_adventure then 
						instance:onUpdateLightArea()
					end
					local _listView = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_1")
					if _listView == nil or _listView:getItem(0) == nil or _listView:getItem(0).roots[1] == nil then
						return
					end
					_listView:getItem(0).roots[1]:setOpacity(180)
					ccui.Helper:seekWidgetByName(_listView:getItem(0).roots[1], "Image_8"):setVisible(false)
				
					
					local leftExpressionLayout = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_2")
					local lastLeftWidget = leftExpressionLayout:getChildByTag(1001)
					if lastLeftWidget ~= nil then
						state_machine.excute("role_dialogue_expression_out", 0, lastLeftWidget)
					end
					
					local rightExpressionLayout = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_3")
					local lastRightWidget = rightExpressionLayout:getChildByTag(1001)
					if lastRightWidget ~= nil then
						state_machine.excute("role_dialogue_expression_out", 0, lastRightWidget)
					end
					
					-- 这里改成判断上次左右边头像和 这次左右边头像
					if instance._last_left_head ~= instance.left_head and instance._dir == 0 or
					  instance._last_right_head ~= instance.right_head and instance._dir == 1 then
						-- 人物不同 先消失之前的
						local headLayout = ccui.Helper:seekWidgetByName(instance.roots[1], string.format("Panel_big_head_%d", self._last_dir+1))
						local headWidget = headLayout:getChildByTag(501)
						if headWidget ~= nil then
							if instance._dir == 1 then
								state_machine.excute("role_dialogue_right_role_out", 0, {headWidget = headWidget, sessionGoOn = true})
							else
								state_machine.excute("role_dialogue_left_role_out", 0, {headWidget = headWidget, sessionGoOn = true})
							end
						end	
					end	
					state_machine.excute("role_dialogue_box_in", 0, "role_dialogue_box_in.")
					state_machine.excute("role_dialogue_role_in", 0, "role_dialogue_role_in.")
					
					instance._last_left_head = instance.left_head
					instance._last_right_head = instance.right_head
					instance._last_dir = instance._dir
					instance._counts = instance._counts + 1
					
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}

			local role_dialogue_out_terminal = {
				_name = "role_dialogue_out",
				_init = function (terminal)
					
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					self._isAnimateEnd = false				
					local leftExpressionLayout = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_2")
					local lastLeftWidget = leftExpressionLayout:getChildByTag(1001)
					if lastLeftWidget ~= nil then
						state_machine.excute("role_dialogue_expression_out", 0, lastLeftWidget)
					end
					
					local rightExpressionLayout = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_3")
					local lastRightWidget = rightExpressionLayout:getChildByTag(1001)
					if lastRightWidget ~= nil then
						state_machine.excute("role_dialogue_expression_out", 0, lastRightWidget)
					end
					
					local leftHeadLayout = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_big_head_1")
					local leftHeadWidget = leftHeadLayout:getChildByTag(501)
					if leftHeadWidget ~= nil then
						state_machine.excute("role_dialogue_left_role_out", 0, {headWidget = leftHeadWidget, sessionGoOn = false})
					end
					
					local rightHeadLayout = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_big_head_2")
					local rightHeadWidget = rightHeadLayout:getChildByTag(501)
					if rightHeadWidget ~= nil then
						state_machine.excute("role_dialogue_right_role_out", 0, {headWidget = rightHeadWidget, sessionGoOn = false})
					end
					
					instance.action:play("dialog_bg_out", false)
					instance.action:setFrameEventCallFunc(function (frame)
						if nil == frame then
							return
						end

						local str = frame:getEvent()
						if str == "exit" then
							self._isAnimateEnd = true
							local temp_mission = self.mission
							fwin:close(instance)
							--> print("222")
							--> debug.print_r(temp_mission)
							saveExecuteEvent(temp_mission, true)
							--> print("333333333")
							-- executeNextEvent(nil, true)

							cc.Director:getInstance():getTextureCache():removeUnusedTextures()
						end
					end)

					return true
				end,
				_terminal = nil,
				_terminals = nil
			}

			local role_dialogue_touch_terminal = {
				_name = "role_dialogue_touch",
				_init = function (terminal)
					
				end,
				_inited = false,
				_instance = self,
				_state = 0,
				_invoke = function(terminal, instance, params)
					if self._isAnimateEnd == false or self._isBoxAllIn == false then
						return
					end	
					if self._isShowTextEnd == false then
						self._isShowTextEnd = true
						self._isTouced = true
					end
					if self._isTouced ~= true then
						self._isTouced = true
						
						-- local missionRound = mission:atoi(0)
						local missionRound = 0
						if missionRound > 0 then
							-- CCDirector:sharedDirector():touchListener((missionRound > 0 and false or true))
							--executeEvent()
						else
							-- CCDirector:sharedDirector():touchListener(false)
							local eventCount = #self.missions
							-- local nowEventIndex = self.eventIndex
							-- local nextEventIndex = nowEventIndex + 1
							local nextMission = (self.eventIndex + 1) < eventCount and self.missions[self.eventIndex + 2] or nil
							if nextMission ~= nil then
								local eventType = dms.atos(nextMission, mission_execute_type)
								if eventType ~= execute_type_dialog and eventType ~= execute_type_treasure_drop then
									state_machine.excute("role_dialogue_out", 0, "role_dialogue_out.")
								else
									saveExecuteEvent(self.mission, true)
									-- executeNextEvent(nil, true)
								end
							else
								state_machine.excute("role_dialogue_out", 0, "role_dialogue_out.")
							end	
							
							-- executeEvent()
							-- CCDirector:sharedDirector():touchListener(true)
						end
					end
					self._isTouced = false
				
					return true
				end,
				_terminal = nil,
				_terminals = nil
			}			
			
			state_machine.add(role_dialogue_event_over_terminal)
			state_machine.add(role_dialogue_box_in_terminal)
			state_machine.add(role_dialogue_role_in_terminal)
			state_machine.add(role_dialogue_in_terminal)
			state_machine.add(role_dialogue_push_terminal)
			state_machine.add(role_dialogue_out_terminal)
			state_machine.add(role_dialogue_touch_terminal)
			state_machine.init()
		end
		
		init_RoleDialogue_terminal()
	end

	function RoleDialogue:init(current_mission, missions, eventIndex)
		self.mission = current_mission
		self.missions = missions
		self.eventIndex = eventIndex
		
		self._dir = dms.atoi(self.mission, mission_param1)
		self.left_head = dms.atos(self.mission, mission_param2)
		self.right_head = dms.atos(self.mission, mission_param3)
		self._name = dms.atos(self.mission, mission_param4)
		local msg = dms.atos(self.mission, mission_param5)
		self._string = zstring.replace(msg, "{}", _ED.user_info.user_name)
		self.left_look = dms.atoi(self.mission, mission_param6)
		self.right_look = dms.atoi(self.mission, mission_param7)
		self.bg_name = dms.atos(self.mission, mission_param8)
		if __lua_project_id == __lua_project_adventure then 
			self.light_area = dms.atos(self.mission, mission_param10)
		end
		
		if self._name == "{}" then
			self._name = _ED.user_info.user_name
		end
		
		if self.left_head == "{}" then
			if __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
				then
				if tonumber(_ED.user_info.user_gender) == 1 then
					self.left_head = "301,4"
				else
					self.left_head = "302,4"
				end
			else
				for i, shipInfo in pairs(_ED.user_ship) do
					if shipInfo.ship_id~= nil then
						local shipData = dms.element(dms["ship_mould"],shipInfo.ship_template_id)
						if dms.atoi(shipData, ship_mould.captain_type) == 0 then
							if __lua_project_id == __lua_project_pokemon 
								or __lua_project_id == __lua_project_rouge
								then
								local base_mould = dms.atos(shipData, ship_mould.base_mould)
								for k,v in pairs(_tipString_dialogue_role_ani) do
									if tonumber(v[1]) == tonumber(base_mould) then
										self.left_head = tonumber(v[2])
									end
								end
							else
								self.left_head = dms.atos(shipData, ship_mould.bust_index)
								if shipInfo._head ~= nil then
									self.left_head = shipInfo._head
								end
							end
						end
					end
				end
			end
		end
		
		if self.right_head == "{}" then
			if __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
				then
				if tonumber(_ED.user_info.user_gender) == 1 then
					self.left_head = "301,4"
				else
					self.left_head = "302,4"
				end
			else
				for i, shipInfo in pairs(_ED.user_ship) do
					if shipInfo.ship_id~= nil then
						local shipData = dms.element(dms["ship_mould"],shipInfo.ship_template_id)
						if dms.atoi(shipData, ship_mould.captain_type) == 0 then
							if __lua_project_id == __lua_project_pokemon 
								or __lua_project_id == __lua_project_rouge
								then
								local base_mould = dms.atos(shipData, ship_mould.base_mould)
								for k,v in pairs(_tipString_dialogue_role_ani) do
									if tonumber(v[1]) == tonumber(base_mould) then
										self.right_head = tonumber(v[2])
									end
								end
							else
								self.right_head = dms.atos(shipData, ship_mould.bust_index)
								if shipInfo._head ~= nil then
									self.right_head = shipInfo._head
								end
							end
						end
					end
				end
			end
		end
		
		self.left_head = tonumber(self.left_head)
		self.right_head = tonumber(self.right_head)
		self._isBoxAllIn = false
	end

	function RoleDialogue:onUpdateLightArea()
		--print("数据:",self.light_area)
		if self.light_area ~= nil and self.light_area ~= "" and self.light_area ~= "0" then 
			local array_pt = zstring.split("" .. self.light_area,",")
			
			if array_pt ~= nil and #array_pt > 3 then 
				local _light_area = {
					x =  tonumber(array_pt[1]),
					y =  tonumber(array_pt[2]),
					scaleX = tonumber(array_pt[3]),
					scaleY = tonumber(array_pt[4]),
					direction = tonumber(array_pt[5]),
				}
			local uiPosition = cc.p(_light_area.x , _light_area.y)
			local size = self.light_Panel:getContentSize()
			local anchor = self.light_Panel:getAnchorPoint()
			self.light_Panel:setPosition(cc.p(self._light_start_x,self._light_start_y))
			local swp = fwin:convertToWorldSpaceAR(self.light_Panel, cc.p(0, 0)) -- selectObject:convertToWorldSpaceAR(cc.p(0, 0))
			
			if _light_area.direction == 3 then
				local offsetY = ((app.screenSize.height - app.winSize.height)/2)/app.scaleFactor
				uiPosition.y = uiPosition.y + offsetY
				local offsetScale = _light_area.scaleY + (offsetY * 2)/size.height
				_light_area.scaleY = offsetScale
			else
				if _light_area.direction == 0 then
					local offsetY = (app.screenSize.height - app.winSize.height)/app.scaleFactor
					uiPosition.y = uiPosition.y + offsetY
				end
			end
			-- uiPosition.x = uiPosition.x + (size.width * _light_area.scaleX)/2
			-- uiPosition.y = uiPosition.y + (size.height * _light_area.scaleY)/2
			--print("转换的坐标:",swp.x,swp.y, self._light_start_y,app.baseOffsetY)
			
			-- local offX = (tonumber(array_pt[3]) * 100 ) /2 
			-- local offY = 0 
			-- if _light_area.direction == 3  then 
			-- 	-- _light_area.scaleY = _light_area.scaleY
			-- 	offY = ((tonumber(array_pt[4]) * 100) +  math.abs(app.baseOffsetY)) / 2 
			-- 	uiPosition.y = uiPosition.y + swp.y / app.scaleFactor + size.height / 2 - size.height * anchor.y
			-- else
			-- 	offY = ((tonumber(array_pt[4]) * 100) ) /2 
			-- 	uiPosition.y = uiPosition.y + swp.y / app.scaleFactor + size.height / 2 - size.height * anchor.y
			-- end
			-- uiPosition.x = uiPosition.x + swp.x / app.scaleFactor + size.width / 2 - size.width * anchor.x
			-- uiPosition.x =  uiPosition.x + offX
			-- if _light_area.direction == 1 then 
			-- 	--uiPosition.y =  uiPosition.y + offY - swp.y
			-- 	uiPosition.y =  uiPosition.y + offY - self._light_start_y
			-- elseif  _light_area.direction == 3 then 
			-- 	uiPosition.y =  uiPosition.y + offY  - self._light_start_y
			-- else
			-- 	uiPosition.y =  uiPosition.y + offY
			-- end
			
			--print("---最后坐标2:",uiPosition.x,uiPosition.y)
			self.light_Panel:setPosition(uiPosition)
			self.light_image:setPosition(uiPosition)
			self.light_Panel:setScaleX(_light_area.scaleX)
			self.light_Panel:setScaleY(_light_area.scaleY)
			self.light_image:setContentSize(cc.size(_light_area.scaleX*100,_light_area.scaleY *100))
			self.light_image:setVisible(true)
			self.light_Panel:setVisible(true)
			
			-- if _light_area.direction == 1  then 
			-- elseif _light_area.direction == 2 then 
			-- elseif _light_area.direction == 3 then 
			-- elseif _light_area.direction == 4 then 
			-- else
			-- end

			end
		else
			self.light_image:setVisible(false)
			self.light_Panel:setVisible(false)
		end
	end


	function RoleDialogue:onUpdate(dt)
		if self._is_running_state == 0 then
			self._is_running_state = 1
			return
		end
		if self._is_running_state == 1 then
			self._is_running_state = 2
			if self.action ~= nil then
			   state_machine.excute("role_dialogue_in", 1, "role_dialogue_in.")
			end
		end
	end

	function RoleDialogue:onEnterTransitionFinish()
		local csbRoleDialogue = csb.createNode("Chat/dialog.csb")
		self:addChild(csbRoleDialogue)
		local root = csbRoleDialogue:getChildByName("root")
		table.insert(self.roots, root)
		
		self.action = csb.createTimeline("Chat/dialog.csb")
		csbRoleDialogue:runAction(self.action)
		
		local _listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
		local _parent = ccui.Helper:seekWidgetByName(root, "Panel_20")
		local _L_head = ccui.Helper:seekWidgetByName(_parent, "Panel_big_head_1")
		local _R_head = ccui.Helper:seekWidgetByName(_parent, "Panel_big_head_2")

		-- _R_head:setPosition(_L_head:getPositionX()+50, _L_head:getPositionY())
		-- _R_head:setVisible(true)
		-- _R_head:setLocalZOrder(1009)
		-- _listView:setPositionY(_listView:getPositionY() + 400)
		-- 人物坐标问题 ， listview层级问题 ， 剪裁 , 对话框Panel_dialog 去掉交互, 角色重名了
		-- ccui.Helper:seekWidgetByName(root, "ImageView_dialog1"):setLocalZOrder(-1)
		-- _listView:setLocalZOrder(1000)
		_listView:setSwallowTouches(false)
		
		self._last_left_head = self.left_head
		self._last_right_head = self.right_head
		self._last_dir = self._dir
		
		_parent:setBackGroundImage(string.format("images/ui/bg/%s", self.bg_name))

		if __lua_project_id == __lua_project_adventure then 
			self.light_Panel = ccui.Helper:seekWidgetByName(root, "Panel_light_10")
			self.light_image = ccui.Helper:seekWidgetByName(root, "Image_light")
			self.light_Panel:setVisible(false)
			self._light_start_x = self.light_Panel:getPositionX()
			self._light_start_y = self.light_Panel:getPositionY()
			--print("开始坐标:",self._light_start_x,self._light_start_y)
		end
		
		-- state_machine.excute("role_dialogue_in", 1, "role_dialogue_in.")
		
		fwin:addTouchEventListener(root, nil, {terminal_name = "role_dialogue_touch", terminal_state = 1}, nil, 0)
	end

	function RoleDialogue:onExit()
		self._counts = 0

		state_machine.remove("role_dialogue_event_over")
		state_machine.remove("role_dialogue_box_in")
		state_machine.remove("role_dialogue_role_in")
		state_machine.remove("role_dialogue_in")
		state_machine.remove("role_dialogue_push")
		state_machine.remove("role_dialogue_out")
		state_machine.remove("role_dialogue_touch")
	end
end