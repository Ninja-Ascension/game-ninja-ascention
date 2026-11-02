----------------------------------------------------------------------------------------------------
-- 说明：主线副本列表元件的绘制及逻辑实现
-------------------------------------------------------------------------------------------------------
BattleMasterHeadCell = class("BattleMasterHeadCellClass", Window)
 
function BattleMasterHeadCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.armature = {}
	self.index = 0	-- 敌方头像索引
	self.pos = 0	
	self.type = 1
	self.hpLoadingBar = nil
	self.spLoadingBar = nil
	self.roleInfo = nil
	
	local function init_battle_master_head_terminal()
		-- 角色攻击状态控制
		local battle_master_head_update_terminal = {
			_name = "battle_master_head_update", 
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._cell
				local evenyType = params._eventType
				local roleIndex = params._roleIndex
				local value = params._value
				if tonumber(cell.pos) == tonumber(roleIndex) then
					--> print("角色头像位置", cell.pos, roleIndex, value)
					--> print("事件类型", evenyType)
					cell:eventController(evenyType, value)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(battle_master_head_update_terminal)
        state_machine.init()
    end
    -- init_plot_copy_cell_terminal()
	
	init_battle_master_head_terminal()
end

function BattleMasterHeadCell:onUpdateDraw()
	local root = self.roots[1]
	
	-- 头像
	local headIcon = ccui.Helper:seekWidgetByName(root, "Panel_enemy_touxiang")
	-- 设置品质框
	local qualityBox = ccui.Helper:seekWidgetByName(root, "Panel_enemy_pinzi")
	-- 失败icon
	local loseIcon = ccui.Helper:seekWidgetByName(root:getChildByName("Panel_jiesuan"), "Image_bai_2")
	-- 破衣服
	local poIcon = ccui.Helper:seekWidgetByName(root:getChildByName("Panel_jiesuan"), "Image_po_2")
		-- 设置底图
	local back = ccui.Helper:seekWidgetByName(root, "Panel_xue_2")
	-- 血量
	local hp = ccui.Helper:seekWidgetByName(back:getChildByName("Image_2_2"), "LoadingBar_xue_2")
	self.hpLoadingBar = hp
	-- 怒气
	local sp = ccui.Helper:seekWidgetByName(back:getChildByName("Image_2_0_2"), "LoadingBar_nu_2")
	self.spLoadingBar = sp
	-- 武将模板id
	-- local picIndex = dms.int(dms["environment_ship"], self.armature._mouldId, environment_ship.pic_index)
	-- local quality = dms.int(dms["environment_ship"], self.armature._mouldId, environment_ship.ship_type)+1
	local picIndex = self.roleInfo._head + 1000
	local quality = self.roleInfo._quality + 1
	-- if zstring.tonumber(self.roleInfo._type) == 1 then
	-- 	picIndex = dms.int(dms["environment_ship"], self.armature._mouldId, environment_ship.pic_index)
	-- 	quality = dms.int(dms["environment_ship"], self.armature._mouldId, environment_ship.ship_type)+1
	-- end
	headIcon:setBackGroundImage(getPropsPath(picIndex))
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		qualityBox:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))	
	else
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			qualityBox:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))	
		else
			qualityBox:setBackGroundImage(string.format("images/ui/quality/icon_bigkuang_%d.png", quality))	
		end
	end
	
	
	if self.armature._mouldId ~= 0 then
		--self.hpLoadingBar:loadTexture("images/ui/pragress/xuetiao_1.png", 0)
		self.hpLoadingBar:setPercent(100)
		
		--self.spLoadingBar:loadTexture("images/ui/pragress/slot_2.png", 0)
		self.spLoadingBar:setPercent(0)
	end
	-- 设置为隐藏
end

-- 事件类型
-- 1. 角色攻击
-- 2. 角色怒气
-- 3. 角色破衣服
-- 4. 角色死亡
function BattleMasterHeadCell:eventController(eventType, value)
	--> print("进入事件分发", eventType)
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
		--> print("更新显示血条最后呈现", value)
		-- 5. 更新血条
		self.hpLoadingBar:setPercent(tonumber(value))
		if value <= 40 then
			-- 3. 角色破衣服
			-- self:roleBlast()
		end
		if value <= 0 then
			-- 4. 角色死亡
			self:roleDeath()
		end
	elseif tonumber(eventType) == 6 then
		-- 6. 更新怒气条
		local percent = (value / 4) * 100
		--> print("-master sp-", value)
		self.spLoadingBar:setPercent(tonumber(percent))
		self:showSPEffect(percent)
	end
end
-- 角色攻击
function BattleMasterHeadCell:roleAttack()
	
end
-- 角色怒气
function BattleMasterHeadCell:roleSP()
	
end
-- 角色破衣
function BattleMasterHeadCell:roleBlast()
	if self.roleInfo._quality >= 3 then
		-- 破衣服
		self:leftTopIcon(1)
		state_machine.excute("attack_logic_role_blast",0,{roleInfo = self.roleInfo})
	end
end
-- 角色死亡
function BattleMasterHeadCell:roleDeath()
	-- 失败icon
	self:leftTopIcon(2)
end
-- 显示怒气满的特效
function BattleMasterHeadCell:showSPEffect(percent)
	local root = self.roots[1]
	local back = ccui.Helper:seekWidgetByName(root, "Panel_xue_2")
	local spEffect = ccui.Helper:seekWidgetByName(root, "Image_2_0_2"):getChildByName("Particle_mannu_2")
	if tonumber(percent) >= 100 then
		-- 显示怒气满的动画
		-- spEffect:setVisible(true)
		--> print("需要显示怒气满的动画，之前的动画让美术取消到了。")
	else
		--spEffect:setVisible(false)
		--> print("需要隐藏怒气满的动画，之前的动画让美术取消到了。")
	end
end
-- 角色左上角小iocn切换显示
-- 1. 破衣icon
-- 2. 失败icon
function BattleMasterHeadCell:leftTopIcon(iconType)
	local root = self.roots[1]
	local poIcon = ccui.Helper:seekWidgetByName(root, "Image_po_2")
	local loseIcon = ccui.Helper:seekWidgetByName(root, "Image_bai_2")
	if tonumber(iconType) == 1 then
		poIcon:setVisible(true)
		loseIcon:setVisible(false)
	elseif tonumber(iconType) == 2 then
		poIcon:setVisible(false)
		loseIcon:setVisible(true)
	else
		
	end
end

function BattleMasterHeadCell:init(armature, roleInfo)
	self.armature = armature
	self.pos = armature._index
	self.roleInfo = roleInfo
end
function BattleMasterHeadCell:onEnterTransitionFinish()
    local csbEquipPatchListCell = csb.createNode("battle/battle_enemy_icon.csb")
	local root = csbEquipPatchListCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(true)
	self:addChild(root)	
	
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

function BattleMasterHeadCell:onExit()
	state_machine.remove("battle_master_head_update")
end

function BattleMasterHeadCell:createCell()
	local cell = BattleMasterHeadCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end