----------------------------------------------------------------------------------------------------
-- 说明：战斗中，用于完成QuickTimeEvent的角色头像控件
-------------------------------------------------------------------------------------------------------
BattleQTEHeadCell = class("BattleQTEHeadCellClass", Window)
 
function BattleQTEHeadCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.isCanTouch = false

	self._normalSkillState = -1
	self._powerSkillState = -1
    
	local function init_battle_qte_head_terminal()
		local battle_qte_head_update_draw_terminal = {
			_name = "battle_qte_head_update_draw", 
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params.cell
				if cell ~= nil then
					cell:updateDraw(params)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		local battle_qte_head_touch_head_role_terminal = {
			_name = "battle_qte_head_touch_head_role", 
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				cell:select(params)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		local battle_qte_head_touch_head_role_skill_state_terminal = {
			_name = "battle_qte_head_touch_head_role_skill_state", 
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params.cell
				if cell ~= nil then
					cell:updateSkillState(params)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		local battle_qte_head_cell_play_hurt_action_terminal = {
			_name = "battle_qte_head_cell_play_hurt_action", 
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params.cell
				if cell ~= nil then
					local action = cell.actions[1]
					if action then
						if true ~= cell._lock_action then
							cell._lock_action = true
							action:play("hurt", false)

        					playEffectMusic(9708)
						end
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		local mission_touch_move_terminal = {
			_name = "mission_touch_move", 
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params.cell
				if cell ~= nil then
					-- if -1 < cell._self._powerSkillState then
						local root = cell._self.roots[1]
						local Panel_tonch_bg = ccui.Helper:seekWidgetByName(root, "Panel_tonch_bg")
						local Panel_tonch = ccui.Helper:seekWidgetByName(root, "Panel_tonch")
						if nil ~= Panel_tonch_bg then
							Panel_tonch_bg:setVisible(true)
						end
						if nil ~= Panel_tonch then
							Panel_tonch:setVisible(true)
						end
					-- end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(battle_qte_head_update_draw_terminal)
		state_machine.add(battle_qte_head_touch_head_role_terminal)
		state_machine.add(battle_qte_head_touch_head_role_skill_state_terminal)
		state_machine.add(battle_qte_head_cell_play_hurt_action_terminal)
		state_machine.add(mission_touch_move_terminal)
        state_machine.init()
    end

	init_battle_qte_head_terminal()
end

function BattleQTEHeadCell:updateDraw(params)
	if self.deathed == true then
		return
	end

	local root = self.roots[1]
	local status = params.status
	local Panel_hand_head = ccui.Helper:seekWidgetByName(root, "Panel_hand_head")
	local headPad = ccui.Helper:seekWidgetByName(root, "Panel_head")
	local Panel_jinengshifang = ccui.Helper:seekWidgetByName(root, "Panel_jinengshifang")
	local Panel_heji = ccui.Helper:seekWidgetByName(root, "Panel_heji")
	local Panel_tonch_dh = ccui.Helper:seekWidgetByName(root, "Panel_tonch_dh")
	local ArmatureNode_2 = Panel_tonch_dh:getChildByName("ArmatureNode_2")
	local Panel_shouchaokaiqi = ccui.Helper:seekWidgetByName(root, "Panel_shouchaokaiqi")
	local ArmatureNode_1_0 = Panel_shouchaokaiqi:getChildByName("ArmatureNode_1_0")
	local Panel_nuqijineng = ccui.Helper:seekWidgetByName(root, "Panel_nuqijineng")
	local ArmatureNode_1 = Panel_nuqijineng:getChildByName("ArmatureNode_1")

	local headIcon = ccui.Helper:seekWidgetByName(root, "Panel_head_role")
	headIcon:setVisible(true)

	local hetiIcon = ccui.Helper:seekWidgetByName(root, "Panel_hetiji_tubiao")
	
	Panel_shouchaokaiqi:setVisible(false)
	-- Panel_jinengshifang:setVisible(false)
	-- Panel_heji:setVisible(false)
	Panel_tonch_dh:setVisible(false)
	-- Panel_nuqijineng:setVisible(false)

	if status == "init" then
		self:updateSkillState(nil)
		self.qteOver = false
		--self.isCanTouch = true
		Panel_hand_head:setOpacity(255)
		Panel_hand_head:setColor(cc.c3b(255, 255, 255))
		headPad:setColor(cc.c3b(255, 255, 255))
		if zstring.tonumber(self.armature._info._current_hp) > 0 or zstring.tonumber(self.armature._info._current_sp) > 0 then
			local sppercent = 0
			local hppercent = 0
			local lhp = zstring.tonumber(self.armature.armature._role._lhp)
			if lhp < self.armature.armature._role._hp then
				lhp = self.armature.armature._role._hp
			end
			local lsp = zstring.tonumber(self.armature.armature._role._lsp)
			if lsp < self.armature.armature._role._sp then
				lsp = self.armature.armature._role._sp
			end
			hppercent = math.max(0, (zstring.tonumber(lhp) / zstring.tonumber(self.armature._info._max_hp)) * 100)
			sppercent = math.max(0, (zstring.tonumber(lsp) / FightModule.MAX_SP) * 100)
			self.hpLoadingBar:setPercent(hppercent)
			self.spLoadingBar:setPercent(sppercent)
		else
			self.hpLoadingBar:setPercent(100)
			self.hpLoadingBar:setPercent(100)
		end
		self.deathed = false
	end

	if self.deathed == true then
		return
	end

	if status == "deathed" then  -- 角色死亡
		self.isCanTouch = false
		Panel_hand_head:setColor(cc.c3b(230, 0, 17))

		self.hpLoadingBar:setPercent(0)
		
		local percent = 0
		self.spLoadingBar:setPercent(percent)
		self.deathed = true
	elseif status == "update" then -- 角色属性更新
		local sppercent = 0
		local hppercent = 0
		if self.armature.armature ~= nil then
			-- local lhp = zstring.tonumber(self.armature.armature._role._lhp)
			-- if lhp < self.armature.armature._role._hp then
				lhp = self.armature.armature._role._hp
			-- end
			-- local lsp = zstring.tonumber(self.armature.armature._role._lsp)
			-- if lsp < self.armature.armature._role._sp then
				lsp = self.armature.armature._role._sp
			-- end

			local skf = params.skf
			local armatureSkf = params.armatureSkf
			if skf and skf.__skill_influence and armatureSkf then
			    if armatureSkf <= skf.__skill_influence then
                    if tonumber(lhp) > tonumber(skf.aliveHP) then
                        lhp = skf.aliveHP
                        self.armature.armature._role._hp = lhp
                    end
	            end
			end

			if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_13 or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_11 then
				-- sppercent = math.max(0, (zstring.tonumber(self.armature.armature._role._sp) / 4) * 100)
				sppercent = math.max(0, (zstring.tonumber(lsp) / FightModule.MAX_SP) * 100)
			else
				sppercent = math.max(0, (zstring.tonumber(lsp) / FightModule.MAX_SP) * 100)
			end
			if zstring.tonumber(self.armature._info._current_hp) > 0 or zstring.tonumber(self.armature._info._current_hp) > 0 then
				hppercent = math.max(0, (zstring.tonumber(lhp) / zstring.tonumber(self.armature._info._max_hp)) * 100)
			else
				hppercent = math.max(0, (zstring.tonumber(lhp) / zstring.tonumber(self.armature._info._max_hp)) * 100)
			end
			

			if sppercent >= 100 then
				if true ~= self.spLoadingBar._full then
					playEffectMusic(9701)
				end
				self.spLoadingBar._full = true
			else
				self.spLoadingBar._full = false
			end

			local Panel_power_max = ccui.Helper:seekWidgetByName(root, "Panel_power_max")
			if nil ~= Panel_power_max then
				if sppercent >= 100 and self._powerSkillState > -1 then
					Panel_power_max:setVisible(true)
				else
					Panel_power_max:setVisible(false)
				end
			end
		end
		self.spLoadingBar:setPercent(sppercent)
		self.hpLoadingBar:setPercent(hppercent)
	elseif status == "dizziness" then -- 眩晕状态
		self.isCanTouch = false
		headPad:setColor(cc.c3b(50, 50, 50))
	elseif status == "undizziness" then -- 眩晕解除
		self.isCanTouch = true
		headPad:setColor(cc.c3b(255, 255, 255))
	elseif status == "dizzy" then
		-- if nil ~= self.Image_chenmo then
		-- 	self.Image_chenmo:setVisible(true)
		-- end
		if nil ~= self.Panel_leixing then
			self.Panel_leixing:setVisible(true)
		end
	elseif status == "undizzy" then
		-- if nil ~= self.Image_chenmo then
		-- 	self.Image_chenmo:setVisible(false)
		-- end
		if nil ~= self.Panel_leixing then
			self.Panel_leixing:setVisible(false)
		end
	elseif status == "silence" then
		if nil ~= self.Image_chenmo then
			self.Image_chenmo:setVisible(true)
		end
	elseif status == "unsilence" then
		if nil ~= self.Image_chenmo then
			self.Image_chenmo:setVisible(false)
		end
	elseif status == "finish" then -- 手操结束
		if -1 < self._powerSkillState then
			self._powerSkillState = -1
			if true ~= self.armature._FightRoleController.auto_select then
				Panel_tonch_dh:setVisible(true)
			end
			local animation = ArmatureNode_2:getAnimation()
			animation:playWithIndex(0, 0, 0)
			if -1 < self._normalSkillState then
				self:updateSkillState({status = self._normalSkillState})
				return
			end
		else
			self._normalSkillState = -1
		end

		self:updateSkillState(nil)
		Panel_hand_head:setOpacity(90)
		if self.isCanTouch then
			if true ~= self.armature._FightRoleController.auto_select then
				Panel_tonch_dh:setVisible(true)
			end
			local animation = ArmatureNode_2:getAnimation()
			animation:playWithIndex(0, 0, 0)
		end
		self.isCanTouch = false
		hetiIcon:setVisible(false)
	elseif status == "lock" then -- 不能手操，锁定状态
		if root:getOpacity() >= 255 then
			Panel_hand_head:setOpacity(90)
		end
		self.isCanTouch = false
	elseif status == "active" then -- 解除所有异常和锁定状态
		self:updateSkillState(nil)

		self.isCanTouch = true
		Panel_hand_head:setOpacity(255)
		Panel_hand_head:setColor(cc.c3b(255, 255, 255))

		headPad:setColor(cc.c3b(255, 255, 255))

		-- if nil ~= self.Image_chenmo then
		-- 	self.Image_chenmo:setVisible(false)
		-- end
		-- if nil ~= self.Panel_leixing then
		-- 	self.Panel_leixing:setVisible(false)
		-- end

		Panel_shouchaokaiqi:setVisible(true)
		local animation = ArmatureNode_1_0:getAnimation()
		animation:playWithIndex(0, 0, 0)

		local sppercent = 0
		local hppercent = 0
		if self.armature.armature ~= nil then
			-- local lhp = zstring.tonumber(self.armature.armature._role._lhp)
			-- if lhp < self.armature.armature._role._hp then
				lhp = self.armature.armature._role._hp
			-- end
			-- local lsp = zstring.tonumber(self.armature.armature._role._lsp)
			-- if lsp < self.armature.armature._role._sp then
				lsp = self.armature.armature._role._sp
			-- end
			if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_13 or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_11 then
				-- sppercent = math.max(0, (zstring.tonumber(self.armature.armature._role._sp) / 4) * 100)
				sppercent = math.max(0, (zstring.tonumber(lsp) / FightModule.MAX_SP) * 100)
			else
				sppercent = math.max(0, (zstring.tonumber(lsp) / FightModule.MAX_SP) * 100)
			end
			if zstring.tonumber(self.armature._info._current_hp) > 0 or zstring.tonumber(self.armature._info._current_hp) > 0 then
				hppercent = math.max(0, (zstring.tonumber(lhp) / zstring.tonumber(self.armature._info._max_hp)) * 100)
			else
				hppercent = math.max(0, (zstring.tonumber(lhp) / zstring.tonumber(self.armature._info._max_hp)) * 100)
			end

			local Panel_power_max = ccui.Helper:seekWidgetByName(root, "Panel_power_max")
			if nil ~= Panel_power_max then
				if sppercent >= 100 and self._powerSkillState > -1 then
					Panel_power_max:setVisible(true)
				else
					Panel_power_max:setVisible(false)
				end
			end
		end
		self.spLoadingBar:setPercent(sppercent)
		self.hpLoadingBar:setPercent(hppercent)
	elseif status == "root_lock" then
		self.isCanTouch = false
		root:setOpacity(60)
	elseif status == "root_active" then
		self.isCanTouch = true
		root:setOpacity(255)
	elseif status == "root_lock_130" then
		self.isCanTouch = false
		root:setOpacity(90)
	elseif status == "exile" then
		self.isCanTouch = false
		headPad:setColor(cc.c3b(50, 50, 50))
		if nil ~= self.Panel_fangzhu then
			self.Panel_fangzhu:setVisible(true)
		end
	elseif status == "unexile" then
		headPad:setColor(cc.c3b(255, 255, 255))
		self.isCanTouch = true
		if nil ~= self.Panel_fangzhu then
			self.Panel_fangzhu:setVisible(false)
		end
	elseif status == "stone" then
		self.isCanTouch = false
		headPad:setColor(cc.c3b(50, 50, 50))
	elseif status == "unstone" then
		headPad:setColor(cc.c3b(255, 255, 255))
		self.isCanTouch = true
	end
end

function BattleQTEHeadCell:updateSkillState( params )
	if self.deathed == true then
		return
	end
	local root = self.roots[1]
	
	local Panel_jinengshifang = ccui.Helper:seekWidgetByName(root, "Panel_jinengshifang")
	local Panel_heji = ccui.Helper:seekWidgetByName(root, "Panel_heji")
	local Panel_nuqijineng = ccui.Helper:seekWidgetByName(root, "Panel_nuqijineng")
	local Panel_nuqijineng_bg = ccui.Helper:seekWidgetByName(root, "Panel_nuqijineng_bg")
	local Panel_jueji_effect = ccui.Helper:seekWidgetByName(root, "Panel_jueji_effect")
	local Panel_head = ccui.Helper:seekWidgetByName(root, "Panel_head")

	Panel_jinengshifang:setVisible(false)
	Panel_heji:setVisible(false)
	Panel_nuqijineng:setVisible(false)
	if nil ~= Panel_nuqijineng_bg then
		Panel_nuqijineng_bg:setVisible(false)
	end
	if nil ~= Panel_jueji_effect then
		Panel_jueji_effect:setVisible(false)
	end
	if nil ~= Panel_head then
		local action2 = self.actions[2]
		if action2 then
			action2:pause()
		end
		Panel_head:setScale(1.0)
		Panel_head:stopAllActions()
	end

	if params == nil then
		return
	end
	local status = params.status
	if tonumber(status) == 4 or tonumber(status) == 6 then
		self._normalSkillState = 1
		self._powerSkillState = tonumber(status)
		-- Panel_jinengshifang:setVisible(true)
		Panel_nuqijineng:setVisible(true)
		if nil ~= Panel_nuqijineng_bg then
			Panel_nuqijineng_bg:setVisible(true)
		end
		if nil ~= Panel_jueji_effect then
			Panel_jueji_effect:setVisible(true)
		end
		if nil ~= Panel_head then
			-- Panel_head:runAction(cc.RepeatForever:create(cc.Sequence:create({
			-- 		cc.ScaleTo:create(40 / 60.0, 1.1),
			-- 		cc.ScaleTo:create(40 / 60.0, 1.0)
			-- 	})))

			local action2 = self.actions[2]
			if action2 then
				action2:stop()
				action2:resume()
				action2:play("skill", true)
			end
		end
	-- elseif tonumber(status) == 5 then
	-- 	local headIcon = ccui.Helper:seekWidgetByName(root, "Panel_head_role")
	-- 	headIcon:setVisible(false)
	-- 	local hetiIcon = ccui.Helper:seekWidgetByName(root, "Panel_hetiji_tubiao")
	-- 	hetiIcon:setVisible(true)
	-- 	local picIndex = self.armature._info._head + 1000
	-- 	hetiIcon:setBackGroundImage(string.format("images/ui/battle/hetijitubiao/jinengtubiao_%d.png", picIndex))
	-- 	Panel_heji:setVisible(true)
		if self._powerSkillState > -1 then
			local Panel_head_role_xy = ccui.Helper:seekWidgetByName(root, "Panel_head_role_xy")
			Panel_head_role_xy._mission_touch_move = true
		end
		self.spLoadingBar:setPercent(100)
	elseif tonumber(status) == 7 then
		self._normalSkillState = tonumber(status)
		if -1 < self._powerSkillState then
			Panel_jinengshifang:setVisible(true)
			Panel_nuqijineng:setVisible(true)
			if nil ~= Panel_nuqijineng_bg then
				Panel_nuqijineng_bg:setVisible(true)
			end
			if nil ~= Panel_jueji_effect then
				Panel_jueji_effect:setVisible(true)
			end
			if nil ~= Panel_head then
				-- Panel_head:runAction(cc.RepeatForever:create(cc.Sequence:create({
				-- 		cc.ScaleTo:create(40 / 60.0, 1.1),
				-- 		cc.ScaleTo:create(40 / 60.0, 1.0)
				-- 	})))

				local action2 = self.actions[2]
				if action2 then
					action2:stop()
					action2:resume()
					action2:play("skill", true)
				end
			end
		else
			Panel_jinengshifang:setVisible(true)
			Panel_heji:setVisible(true)
		end
	end

	local sppercent = self.spLoadingBar:getPercent()
	local Panel_power_max = ccui.Helper:seekWidgetByName(root, "Panel_power_max")
	if nil ~= Panel_power_max then
		if sppercent >= 100 and self._powerSkillState > -1 then
			Panel_power_max:setVisible(true)
		else
			Panel_power_max:setVisible(false)
		end
	end
	if self._normalSkillState > -1 then
		self.isCanTouch = true
	end
	if self._powerSkillState > -1 then
		local Panel_head_role_xy = ccui.Helper:seekWidgetByName(root, "Panel_head_role_xy")
		Panel_head_role_xy._mission_touch_move = true
	end
end

function BattleQTEHeadCell:select(params)
	if self.isCanTouch == false then
		return
	end
	self.armature.isBeginHeti = false
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("fight_qte_controller_qte_to_next_attack_role", 0, self)
	else
		state_machine.excute("fight_qte_controller_qte_to_next_attack_role", 0, self.armature)
	end
end

function BattleQTEHeadCell:onUpdateDrawHead(_picIndex)
	local root = self.roots[1]
	-- 头像
	local headIcon = ccui.Helper:seekWidgetByName(root, "Panel_head_role")

	if nil ~= _picIndex and _picIndex > 0 then
		headIcon:setBackGroundImage(string.format("images/ui/props/props_%d.png", _picIndex))
		return
	end

	-- 武将模板id
	if tonumber(self.armature._info._mouldId) ~= 0 then
		local picIndex = self.armature._info._head + 1000
		local quality = nil
		local types = nil
		local name = nil
		local currStar = 1
		if tonumber(self.armature._info._type) == 0 then
			picIndex = dms.int(dms["ship_mould"], self.armature._info._mouldId, ship_mould.head_icon)
		else
			picIndex = dms.int(dms["environment_ship"], self.armature._info._mouldId, environment_ship.pic_index)
			currStar = dms.int(dms["environment_ship"], self.armature._info._mouldId, environment_ship.physics_attack_mode)
		end
		
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			if _ED.user_ship[""..self.armature._info._id] == nil then
				headIcon:setBackGroundImage(string.format("images/ui/props/props_%d.png", self.armature._info._head))
				
				local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
				local layer = neWshowShipStarTwo(Panel_star, currStar, true)
			else
				--进化形象
				local evo_image = dms.string(dms["ship_mould"], self.armature._info._mouldId, ship_mould.fitSkillTwo)
				local evo_info = zstring.split(evo_image, ",")
				--进化模板id
				local ship_info = _ED.user_ship[""..self.armature._info._id]
				local ship_evo = zstring.split(ship_info.evolution_status, "|")
				local evo_mould_id = smGetSkinEvoIdChange(ship_info)
				picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
				headIcon:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
			end
		else
			headIcon:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
		end
	end
end

-- 创建角色头像光效
function BattleQTEHeadCell:createRoleIconEffect(effectStr)
	local root = self.roots[1]
	local Panel_fangzhu = ccui.Helper:seekWidgetByName(root, "Panel_fangzhu")
	if nil ~= Panel_fangzhu then
		Panel_fangzhu:removeAllChildren(true)

		local buffInfo = _battle_buff_head_animation_dictionary["" .. effectStr]
		local armature = sp.spine_effect(buffInfo[1], buffInfo[3][1], false, nil, nil, nil, nil, nil, nil, nil)
		armature._px = Panel_fangzhu:getContentSize().width / 2
		armature:setPosition(cc.p(armature._px + buffInfo[4][1][1], buffInfo[4][1][2]))
		armature.animationNameList = buffInfo
		armature._invoke = nil
		sp.initArmature(armature, true)
		Panel_fangzhu:addChild(armature)
		self.Panel_fangzhu = Panel_fangzhu
		self.Panel_fangzhu:setVisible(false)
	end
end

function BattleQTEHeadCell:onUpdateDraw()
	local root = self.roots[1]
	-- -- 设置名字
	-- local heroName = ccui.Helper:seekWidgetByName(root, "Text_hero_name")
	-- 设置品质框
	local qualityBox = ccui.Helper:seekWidgetByName(root, "Panel_head_pinzhi")
	-- 头像
	local headIcon = ccui.Helper:seekWidgetByName(root, "Panel_head_role")

	--框子
	local Panel_kuang =	ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	-- 血量
	self.hpLoadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_xuetiao")
	-- 怒气
	self.spLoadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_nuqi")

	ccui.Helper:seekWidgetByName(root, "Panel_hetiji_tubiao"):setVisible(false)

	self.Image_jiange = ccui.Helper:seekWidgetByName(root, "Image_jiange")
	-- 设置阵型
	local zhenxing = ccui.Helper:seekWidgetByName(root, "Panel_leixing")
	-- 武将类型
	local Panel_type = ccui.Helper:seekWidgetByName(root, "Panel_type")

	-- 眩晕状态
	self.Image_chenmo = ccui.Helper:seekWidgetByName(root, "Image_chenmo")
	if nil ~= self.Image_chenmo then
		self.Image_chenmo:setVisible(false)
	end

	local Panel_leixing = ccui.Helper:seekWidgetByName(root, "Panel_leixing")
	if nil ~= Panel_leixing then
		Panel_leixing:removeAllChildren(true)

		local buffInfo = _battle_buff_animation_dictionary[6]
		local armature = sp.spine_effect(buffInfo[1], buffInfo[3][1], false, nil, nil, nil, nil, nil, nil, nil)
        armature.animationNameList = buffInfo
        armature._invoke = nil
        sp.initArmature(armature, true)
        Panel_leixing:addChild(armature)
        self.Panel_leixing = Panel_leixing
        self.Panel_leixing:setVisible(false)
	end

	-- 创建角色头像光效
	self:createRoleIconEffect("81")

	-- 武将模板id
	if tonumber(self.armature._info._mouldId) ~= 0 then
		local picIndex = self.armature._info._head + 1000
		local quality = 1
		local types = nil
		local name = nil
		if tonumber(self.armature._info._type) == 0 then
			quality = dms.int(dms["ship_mould"], self.armature._info._mouldId, ship_mould.ship_type)+1
			types = dms.int(dms["ship_mould"], self.armature._info._mouldId, ship_mould.capacity)
			name = dms.string(dms["ship_mould"], self.armature._info._mouldId, ship_mould.captain_name)
			local captain_type = dms.int(dms["ship_mould"], self.armature._info._mouldId, ship_mould.captain_type)
			if captain_type == 0 then
				name = _ED.user_info.user_name
			end
			picIndex = dms.int(dms["ship_mould"], self.armature._info._mouldId, ship_mould.head_icon)
		else
			quality = dms.int(dms["environment_ship"], self.armature._info._mouldId, environment_ship.ship_type)+1
			types = dms.int(dms["environment_ship"], self.armature._info._mouldId, environment_ship.capacity)
			name = dms.int(dms["environment_ship"], self.armature._info._mouldId, environment_ship.ship_name) 
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				local word_info = dms.element(dms["word_mould"], name)
				name = word_info[3]
			end
			picIndex = dms.int(dms["environment_ship"], self.armature._info._mouldId, environment_ship.pic_index)
			-- local camp_preference = dms.int(dms["ship_mould"], dms.int(dms["environment_ship"], self.armature._info._mouldId, environment_ship.directing), ship_mould.camp_preference)
			local camp_preference = dms.int(dms["environment_ship"], self.armature._info._mouldId, environment_ship.camp_preference)
			if camp_preference > 0 and camp_preference <=3 then
				Panel_type:setBackGroundImage(string.format("images/ui/icon/sm_type_bar_%d.png", camp_preference))
			end
		end

		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			if _ED.user_ship[""..self.armature._info._id] == nil then
				headIcon:setBackGroundImage(string.format("images/ui/props/props_%d.png", self.armature._info._head))
				-- local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
				-- local layer = neWshowShipStarTwo(Panel_star, 5, true)
				-- layer:setPositionY(layer:getPositionY() + 15)
				if _ED.purify_user_ship ~= nil and table.nums(_ED.purify_user_ship) >= 1 then
					for i,v in pairs(_ED.purify_user_ship) do
						if i == tonumber(self.armature._info._pos) then
							local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
							local layer = neWshowShipStarTwo(Panel_star, tonumber(v.StarRating), true)
							local camp_preference = dms.int(dms["ship_mould"], self.armature._info._mouldId, ship_mould.camp_preference)
							if camp_preference> 0 and camp_preference <=3 then
								Panel_type:setBackGroundImage(string.format("images/ui/icon/sm_type_bar_%d.png", camp_preference))
							end
							break
						end
					end
				else
					local currStar = dms.int(dms["environment_ship"], self.armature._info._mouldId, environment_ship.physics_attack_mode)
					local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
					local layer = neWshowShipStarTwo(Panel_star, currStar, true)
				end
			else
				--进化形象
				local evo_image = dms.string(dms["ship_mould"], self.armature._info._mouldId, ship_mould.fitSkillTwo)
				local evo_info = zstring.split(evo_image, ",")
				--进化模板id
				local ship_info = _ED.user_ship[""..self.armature._info._id]
				local ship_evo = zstring.split(ship_info.evolution_status, "|")
				local evo_mould_id = smGetSkinEvoIdChange(ship_info)
				picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
				headIcon:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
				local currStar = dms.int(dms["ship_mould"], self.armature._info._mouldId, ship_mould.ship_star)
				if ship_info ~= nil and ship_info.StarRating ~= nil then
					currStar = ship_info.StarRating
				end

				local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
				local layer = neWshowShipStarTwo(Panel_star, currStar, true)
				-- layer:setPositionY(layer:getPositionY() + 15)
				
				local camp_preference = dms.int(dms["ship_mould"], self.armature._info._mouldId, ship_mould.camp_preference)
				if camp_preference> 0 and camp_preference <=3 then
					Panel_type:setBackGroundImage(string.format("images/ui/icon/sm_type_bar_%d.png", camp_preference))
				end
			end
		else
			headIcon:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
		end
		
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
			qualityBox:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))
		else
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				if _ED.user_ship[""..self.armature._info._id] == nil then
					-- quality = 1
				else
					local ship_info = _ED.user_ship[""..self.armature._info._id]
					quality = tonumber(ship_info.Order)+1
				end
				qualityBox:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", shipOrEquipSetColour(quality - 1)))
				if Panel_kuang ~= nil then
					Panel_kuang:setBackGroundImage(string.format("images/ui/quality/quality_frame_%d.png", quality))
				end
			else
				qualityBox:setBackGroundImage(string.format("images/ui/quality/icon_hero_%d.png", quality))
			end
		end
		
		
		-- self.hpLoadingBar:setPercent(100)
		local hppercent = 0
		local lhp = zstring.tonumber(self.armature.armature._role._lhp)
		if lhp < self.armature.armature._role._hp then
			lhp = self.armature.armature._role._hp
		end
		local lsp = zstring.tonumber(self.armature.armature._role._lsp)
		if lsp < self.armature.armature._role._sp then
			lsp = self.armature.armature._role._sp
		end
		hppercent = math.max(0, (zstring.tonumber(lhp) / zstring.tonumber(self.armature._info._max_hp)) * 100)
		sppercent = math.max(0, (zstring.tonumber(lsp) / FightModule.MAX_SP) * 100)
		self.hpLoadingBar:setPercent(hppercent)
		self.spLoadingBar:setPercent(sppercent)

		local Panel_power_max = ccui.Helper:seekWidgetByName(root, "Panel_power_max")
		if nil ~= Panel_power_max then
			if sppercent >= 100 and self._powerSkillState > -1 then
				Panel_power_max:setVisible(true)
			else
				Panel_power_max:setVisible(false)
			end
		end

		-- local percent = 0
		-- if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_13 or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_11 then
		-- 	-- percent = math.max(0, (zstring.tonumber(self.armature._info._sp) / 4) * 100)
		-- 	percent = math.max(0, (zstring.tonumber(self.armature._info._sp) / FightModule.MAX_SP) * 100)
		-- else
		-- 	percent = math.max(0, (zstring.tonumber(self.armature._info._sp) / FightModule.MAX_SP) * 100)
		-- end
		-- self.spLoadingBar:setPercent(percent)

		-- local Panel_power_max = ccui.Helper:seekWidgetByName(root, "Panel_power_max")
		-- if nil ~= Panel_power_max then
		-- 	if percent >= 100 and self._powerSkillState > -1 then
		-- 		Panel_power_max:setVisible(true)
		-- 	else
		-- 		Panel_power_max:setVisible(false)
		-- 	end
		-- end
		
		-- self.name = name
		
		-- local colortype = quality
		-- heroName:setColor(cc.c3b(color_Type[colortype][1],color_Type[colortype][2],color_Type[colortype][3]))
		-- heroName:setString(self.name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		else	
			zhenxing:setBackGroundImage(string.format("images/ui/quality/pve_leixing_%s.png", types))
		end

		-- add touch event
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto or true then
			local Panel_head_role_xy = ccui.Helper:seekWidgetByName(root, "Panel_head_role_xy")
			if nil ~= Panel_head_role_xy then
				Panel_head_role_xy._uncanceled = true
				Panel_head_role_xy._datas = {
		            terminal_name = "battle_qte_head_touch_head_role",
		            cell = self,
		            terminal_state = 0
		        }
		        Panel_head_role_xy._self = self

		        self._max_y = -10000
		        self._qte_canceled = false
		        local function qteTouchCallfunc(sender, evenType)
					local __spoint = sender:getTouchBeganPosition()
					local __mpoint = sender:getTouchMovePosition()
					local __epoint = sender:getTouchEndPosition()
					local root = sender._self.roots[1]

					if sender._self._e_lock == true or sender._self.isCanTouch ~= true then
						return
					end
					if FightRoleController.__lock_battle == true then
						return
					end
					
					local auto_select = state_machine.excute("fight_role_controller_auto_select", 0, 0)
                    if auto_select then
                        return
                    end

					if evenType == ccui.TouchEventType.began then
						sender._self._max_y = -10000
		        		sender._self._qte_canceled = false
						if -1 < sender._self._powerSkillState then
							local Panel_tonch_bg = ccui.Helper:seekWidgetByName(root, "Panel_tonch_bg")
							local Panel_tonch = ccui.Helper:seekWidgetByName(root, "Panel_tonch")
							if nil ~= Panel_tonch_bg then
								Panel_tonch_bg:setVisible(true)
							end
							if nil ~= Panel_tonch then
								Panel_tonch:setVisible(true)
							end
							-- pushEffect(formatMusicFile("effect", 9703), true)
							pushEffect(formatMusicFile("effect", 9703))
						end
						sender._self._max_y = __mpoint.y
					elseif evenType == ccui.TouchEventType.moved then
						if true ~= sender._self._qte_canceled then
							if sender._self._max_y <= __mpoint.y then
								sender._self._max_y = __mpoint.y
							else
								if __mpoint.y < __spoint.y and math.abs(__mpoint.y - sender._self._max_y) >= 40 then
									if -1 < sender._self._powerSkillState then
										local Panel_tonch_bg = ccui.Helper:seekWidgetByName(root, "Panel_tonch_bg")
										local Panel_tonch = ccui.Helper:seekWidgetByName(root, "Panel_tonch")
										if nil ~= Panel_tonch_bg then
											Panel_tonch_bg:setVisible(false)
										end
										if nil ~= Panel_tonch then
											Panel_tonch:setVisible(false)
										end
									end
									sender._self._qte_canceled = true
									-- stopEffect()
									-- cc.SimpleAudioEngine:getInstance():stopAllEffects()
								end
							end
						end
					elseif evenType == ccui.TouchEventType.ended 
						or evenType == ccui.TouchEventType.canceled 
						then
						if -1 < sender._self._powerSkillState then
							local Panel_tonch_bg = ccui.Helper:seekWidgetByName(root, "Panel_tonch_bg")
							local Panel_tonch = ccui.Helper:seekWidgetByName(root, "Panel_tonch")
							if nil ~= Panel_tonch_bg then
								Panel_tonch_bg:setVisible(false)
							end
							if nil ~= Panel_tonch then
								Panel_tonch:setVisible(false)
							end
						end

						sender._self._max_y = -10000

						if sender._self._qte_canceled then
							sender._self._qte_canceled = false
							-- stopEffect()
							-- cc.SimpleAudioEngine:getInstance():stopAllEffects()
							return
						end

						sender._self._qte_canceled = false

						sender._self._unlock_power = false
						if false == missionIsOver() then

						else
							if math.abs(__epoint.y - __spoint.y) < 20 then
								if sender._self._powerSkillState > -1 then
									sender._self._powerSkillState = - 1
									sender._self._unlock_power = true
									playEffectMusic(9704)
								end
							end
						end

						-- stopEffect()
						-- cc.SimpleAudioEngine:getInstance():stopAllEffects()

						if sender._self._powerSkillState > -1 then
						else
							playEffectMusic(9702)
						end

						state_machine.excute(sender._datas.terminal_name, sender._datas.terminal_state or 0, sender)
						sender._one_called = true
					end
				end
				Panel_head_role_xy:addTouchEventListener(qteTouchCallfunc)
				Panel_head_role_xy.callback = qteTouchCallfunc
				if self._powerSkillState > -1 then
					Panel_head_role_xy._mission_touch_move = true
				end
				Panel_head_role_xy._mission_touch_move_name = "mission_touch_move"
				self._touch_object = Panel_head_role_xy
			end
		else
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_head_role_xy"),  nil, 
	        {
	            terminal_name = "battle_qte_head_touch_head_role",
	            cell = self,
	            terminal_state = 0
	        }, 
	        nil, 0)._uncanceled = true
	    end
	end
end

function BattleQTEHeadCell:setLastCell( isLast )
	self.Image_jiange:setVisible(not isLast)
end

function BattleQTEHeadCell:init(armature)
	self.armature = armature
	self.armature._qte = self
	return self
end

function BattleQTEHeadCell:onEnterTransitionFinish()
    local csbBattleQTEHeadCell = csb.createNode("battle/battle_hand_control_head.csb")
	local root = csbBattleQTEHeadCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(true)
	self:addChild(root)
	self:setContentSize(root:getContentSize())

	local action = csb.createTimeline("battle/battle_hand_control_head.csb")
	root:runAction(action)
	-- action:play("hurt", true)
	table.insert(self.actions, action)

	action:setFrameEventCallFunc(function (frame)
	        if nil == frame then
	            return
	        end

	        local str = frame:getEvent()
	        if str == "over" then
				self._lock_action = false
	        end
	    end)

	local action1 = csb.createTimeline("battle/battle_hand_control_head.csb")
	root:runAction(action1)
	-- action:play("hurt", true)
	table.insert(self.actions, action1)

	self:onUpdateDraw()
end

function BattleQTEHeadCell:onExit()
	state_machine.remove("battle_qte_head_update_draw")
	state_machine.remove("battle_qte_head_touch_head_role")
	state_machine.remove("battle_qte_head_touch_head_role_skill_state")
	state_machine.remove("mission_touch_move")
end

function BattleQTEHeadCell:createCell()
	local cell = BattleQTEHeadCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end