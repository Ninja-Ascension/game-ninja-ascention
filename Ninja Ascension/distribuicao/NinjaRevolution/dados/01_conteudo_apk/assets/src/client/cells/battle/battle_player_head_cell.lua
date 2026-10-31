----------------------------------------------------------------------------------------------------
-- 说明：主线副本列表元件的绘制及逻辑实现
-------------------------------------------------------------------------------------------------------
BattlePlayerHeadCell = class("BattlePlayerHeadCellClass", Window)
BattlePlayerHeadCell.__userHeroFontName = nil
function BattlePlayerHeadCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.armature = {}
	self.index = 0	-- 敌方头像索引
	self.type = 2
	self.pos = 0
	self.name = ""
	self.hpLoadingBar = nil
	self.spLoadingBar = nil
	self.initPositionY = 0
	self.roleInfo = nil
	self.initSP = -1
    
	local function init_battle_player_head_terminal()
		-- 角色攻击状态控制
		local battle_player_head_update_terminal = {
			_name = "battle_player_head_update", 
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				--> print("角色攻击了")
				local cell = params._cell
				local eventType = params._eventType
				local roleIndex = params._roleIndex
				local value = params._value
				if eventType == 5 then
					-- 更新血量值
					--> print("更新血量值", value)
				end
				if tonumber(cell.pos) == tonumber(roleIndex) then
					cell:eventController(eventType, value)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(battle_player_head_update_terminal)
        state_machine.init()
    end
    -- init_plot_copy_cell_terminal()
	
	init_battle_player_head_terminal()
end

function BattlePlayerHeadCell:onUpdateDraw()
	local root = self.roots[1]
	-- 设置名字
	local heroName = ccui.Helper:seekWidgetByName(root, "Text_hero_name")
	-- 头像
	local headIcon = ccui.Helper:seekWidgetByName(root, "Panel_hero_touxiang")
	-- 设置品质框
	local qualityBox = ccui.Helper:seekWidgetByName(root, "Panel_hero_pinzi")
	-- 设置底图
	local back = ccui.Helper:seekWidgetByName(root, "Panel_xue_1")
	-- 设置阵型
	local zhenxing = ccui.Helper:seekWidgetByName(root, "Panel_zhenxing")
	
	-- 血量
	local hp = ccui.Helper:seekWidgetByName(back:getChildByName("Image_2_1"), "LoadingBar_xue_1")
	self.hpLoadingBar = hp
	-- 怒气
	local sp = ccui.Helper:seekWidgetByName(back:getChildByName("Image_2_0_1"), "LoadingBar_nu_1")
	self.spLoadingBar = sp
	--> print("BattlePlayerHeadCell:onUpdateDraw: ", self.armature._mouldId)
	-- 武将模板id
	if tonumber(self.armature._mouldId) ~= 0 then
	
		local picIndex = self.roleInfo._head + 1000
		local quality = nil
		local types = nil
		local name = nil
		if tonumber(self.roleInfo._type) == 0 then
			quality = dms.int(dms["ship_mould"], self.armature._mouldId, ship_mould.ship_type)+1
			types = dms.int(dms["ship_mould"], self.armature._mouldId, ship_mould.capacity)
			name = dms.string(dms["ship_mould"], self.armature._mouldId, ship_mould.captain_name)
			local captain_type = dms.int(dms["ship_mould"], self.armature._mouldId, ship_mould.captain_type)
			if captain_type == 0 then
				name = _ED.user_info.user_name
			end
			
		else
			quality = dms.int(dms["environment_ship"], self.armature._mouldId, environment_ship.ship_type)+1
			types = dms.int(dms["environment_ship"], self.armature._mouldId, environment_ship.capacity)
			name = dms.int(dms["environment_ship"], self.armature._mouldId, environment_ship.ship_name) 
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				local word_info = dms.element(dms["word_mould"], name)
				name = word_info[3]
			end
		end
	
	
	
	
		--headIcon:setBackGroundImage("images/face/hero_head/props_1001.png")
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
			headIcon:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
			qualityBox:setBackGroundImage(string.format("images/ui/quality/icon_hero_%d.png", quality))
		else
			headIcon:setBackGroundImage(string.format("images/face/hero_head/props_%d.png", picIndex))
			qualityBox:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))
		end
	
		-- back:setBackGroundImage(string.format("images/ui/quality/icon_hero_%d.png", quality))
		
		-- self.hpLoadingBar:loadTexture("images/ui/pragress/xuetiao_1.png", 0)
		self.hpLoadingBar:setPercent(100)
		
		--self.spLoadingBar:loadTexture("images/ui/pragress/slot_2.png", 0)
		self.spLoadingBar:setPercent(0)
		
		self.name = name
		
		local colortype = quality
		heroName:setColor(cc.c3b(color_Type[colortype][1],color_Type[colortype][2],color_Type[colortype][3]))
		if ___is_open_leadname == true then
			if BattlePlayerHeadCell.__userHeroFontName == nil then
				BattlePlayerHeadCell.__userHeroFontName = heroName:getFontName()
			end
			if dms.int(dms["ship_mould"], tonumber(self.armature._mouldId), ship_mould.captain_type) == 0 then
				heroName:setFontName("")
				heroName:setFontSize(heroName:getFontSize())-->设置字体大小
			else
				heroName:setFontName(BattlePlayerHeadCell.__userHeroFontName)
			end
		end


		heroName:setString(self.name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		else	
			if types == 0 then
			elseif types == 1 then
				zhenxing:setBackGroundImage("images/ui/quality/pve_leixing_1.png")
			elseif types == 2 then
				zhenxing:setBackGroundImage("images/ui/quality/pve_leixing_2.png")
			elseif types == 3 then
				zhenxing:setBackGroundImage("images/ui/quality/pve_leixing_3.png")
			elseif types == 4 then
				zhenxing:setBackGroundImage("images/ui/quality/pve_leixing_4.png")
			end
		end
		
		
	else
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
			qualityBox:setBackGroundImage("images/ui/quality/icon_hero_0.png")
		else
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                qualityBox:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", 0))
            else
				qualityBox:setBackGroundImage(string.format("images/ui/quality/icon_hero_%d.png", 0))
			end
		end
	end
end

-- 事件类型
-- 1. 角色攻击
-- 2. 角色怒气
-- 3. 角色破衣服
-- 4. 角色死亡
function BattlePlayerHeadCell:eventController(eventType, value)
	if tonumber(eventType) == 1 then
		--> print("攻击*********dsa*")
		-- 1. 角色攻击
		self:roleAttack()
	elseif tonumber(eventType) == 2 then
		-- 2. 角色怒气
		self:roleSP()
	elseif tonumber(eventType) == 3 then
		-- 3. 角色破衣服
		self:roleBlast()
	elseif tonumber(eventType) == 4 then
		-- 4. 角色死亡
		self:roleDeath()
	elseif tonumber(eventType) == 5 then
		-- 5. 更新血条
		self.hpLoadingBar:setPercent(tonumber(value))
		if tonumber(value) <= 40 then
			-- 3. 角色破衣服
			self:roleBlast()
		end
		if tonumber(value) <= 0 then
			-- 4. 角色死亡
			self:roleDeath()
		end
	elseif tonumber(eventType) == 6 then
		-- 6. 更新怒气条
		local percent = (value / 4) * 100
		if self.initSP < 0 then
			self.initSP = value
		end
		--> print("-palyer sp-", value)
		self.spLoadingBar:setPercent(tonumber(percent))
		self:showSPEffect(percent)
	elseif tonumber(eventType) == 7 then
		self:updatePlayerPosition()
	elseif tonumber(eventType) == 8 then -- 角色信息重置
		self:resetPlayer()
	end
end

-- 角色信息重置
function BattlePlayerHeadCell:resetPlayer()
	self:leftTopIcon(3)
	self:eventController(5, 100)
	-- if self.initSP > 0 then
		-- self:eventController(6, self.initSP)
	-- end
	
	local sp = _ED.battleData._heros[self.pos]._sp
	self:eventController(6, sp)
end

-- 角色攻击
function BattlePlayerHeadCell:roleAttack()
	local root = self.roots[1]
	local pos = cc.p(root:getPositionX(), root:getPositionY() + 20)
	local move = cc.MoveTo:create(0.1, pos)
	root:runAction(move)
end
-- 角色归位
function BattlePlayerHeadCell:updatePlayerPosition()
	local root = self.roots[1]
	--> print("重置玩家的位置")
	local pos = cc.p(root:getPositionX(), 0)
	local move = cc.MoveTo:create(0.1, pos)
	root:stopAllActions()
	root:runAction(move)
end
-- 角色怒气
function BattlePlayerHeadCell:roleSP()
	
end
-- 角色破衣
function BattlePlayerHeadCell:roleBlast()
	if self.roleInfo._quality >= 3 then
		-- 破衣服
		self:leftTopIcon(1)
		state_machine.excute("attack_logic_role_blast",0,{roleInfo = self.roleInfo})
	end
end
-- 角色死亡
function BattlePlayerHeadCell:roleDeath()
	-- 失败icon
	self:leftTopIcon(2)
end

-- 更新血条显示
function BattlePlayerHeadCell:updateHP()
	
end
-- 更新怒气条显示
function BattlePlayerHeadCell:updateSP()
	
end
-- 显示怒气满的特效
function BattlePlayerHeadCell:showSPEffect(percent)
	local root = self.roots[1]
	local back = ccui.Helper:seekWidgetByName(root, "Panel_xue_1")
	local spEffect = ccui.Helper:seekWidgetByName(root, "Image_2_0_1"):getChildByName("ArmatureNode_122")
	if tonumber(percent) >= 100 then
		-- 显示怒气满的动画
		spEffect:setVisible(true)
	else
		spEffect:setVisible(false)
	end
end

-- 角色左上角小iocn切换显示
-- 1. 破衣icon
-- 2. 失败icon
function BattlePlayerHeadCell:leftTopIcon(iconType)
	local root = self.roots[1]
	local poIcon = ccui.Helper:seekWidgetByName(root, "Image_po_1")
	local loseIcon = ccui.Helper:seekWidgetByName(root, "Image_bai_1")
	if iconType == 1 then
		poIcon:setVisible(true)
		loseIcon:setVisible(false)
	elseif iconType == 2 then
		poIcon:setVisible(false)
		loseIcon:setVisible(true)
	else
		poIcon:setVisible(false)
		loseIcon:setVisible(false)
	end
end

function BattlePlayerHeadCell:init(armature, roleInfo)
	self.armature = armature
	self.pos = armature._index
	self.name = armature._name
	self.roleInfo = roleInfo
	--> print("位置值*****************************************", self.pos)
	--> print("BattlePlayerHeadCell:init: ", self.armature._mouldId, tonumber(self.armature._mouldId))
end
function BattlePlayerHeadCell:onEnterTransitionFinish()
    local csbEquipPatchListCell = csb.createNode("battle/battle_hero_icon.csb")
	local root = csbEquipPatchListCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(true)
	self:addChild(root)	
	
	self.initPositionY = root:getPositionY()
	--control
	-- local arena_button 	= fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
	-- {
		-- terminal_name = "plot_copy_cell_into_pve_window", 
		-- terminal_state = 0, 
		-- sceneId = self.pveSceneID
	-- }, nil, 0)
	
	--draw
	self:onUpdateDraw()
end

function BattlePlayerHeadCell:onExit()
	state_machine.remove("battle_player_head_update")
end

function BattlePlayerHeadCell:createCell()
	local cell = BattlePlayerHeadCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end