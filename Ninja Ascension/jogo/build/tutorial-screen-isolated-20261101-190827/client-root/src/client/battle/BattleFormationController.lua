-- ----------------------------------------------------------------------------------------------------
-- 说明：
-------------------------------------------------------------------------------------------------------
BattleFormationController = class("BattleFormationControllerClass", Window)

function BattleFormationController:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.roleType = 0
	self.roleIndex = 0
	self.roleSeat = {0, 0, 0, 0, 0, 0}
	self.roleTeam = {}
	self.masterTeam = {}
	self.crearePlayerOver = false
	self.group = {
		
	}
	self.enum_type = {
		_ROLE_ATTACK_CONTROLLER = 1,		-- 角色攻击状态控制
		_ROLE_ANGER_CONTROLLER = 2,			-- 角色怒气状态控制
		_ROLE_BLAST_CONTROLLER = 3,			-- 角色爆破状态控制
		_ROLE_DEATHED_CONTROLLER = 4,		-- 角色死亡状态控制
		_ROLE_HP_CONTROLLER = 5,			-- 角色血条控制
		_ROLE_SP_CONTROLLER = 6,				-- 角色怒气控制
		_ROLE_UPDATE_PLAYER_POSITION = 7	-- 更新玩家头像显示位置
	}
	
	app.load("client.cells.battle.battle_master_head_cell")
	app.load("client.cells.battle.battle_player_head_cell")
	-- Initialize battle_formation_controller page state machine.
    local function init_battle_formation_controller_terminal()
		-- 角色攻击状态控制
		local battle_formation_controller_role_attack_terminal = {
			_name = "battle_formation_controller_role_attack", 
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				--> print("角色攻击了")
				local roleType = params.roleType
				local roleIndex = params.roleIndex
				instance:roleAttack(roleType, roleIndex)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		-- 角色怒气状态控制
		local battle_formation_controller_role_anger_terminal = {
            _name = "battle_formation_controller_role_anger",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--> print("角色怒气满了")
				local roleType = params.roleType
				local roleIndex = params.roleIndex
				instance:roleAnger(roleType, roleIndex)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 角色爆破状态控制
		local battle_formation_controller_role_blast_terminal = {
            _name = "battle_formation_controller_role_blast",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--> print("衣服破了")
				local roleType = params.roleType
				local roleIndex = params.roleIndex
				instance:roleBlast(roleType, roleIndex)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 角色死亡状态控制
		local battle_formation_controller_role_deathed_terminal = {
            _name = "battle_formation_controller_role_deathed",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--> print("角色死亡了")
				local roleType = params.roleType
				local roleIndex = params.roleIndex
				instance:roleDeathed(roleType, roleIndex)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 创建我方武将
		local battle_formation_create_role_head_terminal = {
			_name = "battle_formation_create_role_head",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--> print("创建角色头像")
				-- 创建我方武将
				local roleType = params._roleType
				local mouldId = params._mouldId
				local pos = params._pos
				local roleName = params._roleName
				instance:createHead(roleType, mouldId, pos, roleName, params._v)
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		-- 我方武将创建完毕
			local battle_formation_create_role_head_over_terminal = {
			_name = "battle_formation_create_role_head_over",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--> print("创建角色头像完毕")
				-- 创建我方武将
				local num = params._num
				if self.crearePlayerOver == false then
					instance:createOther()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		-- 更新玩家的血条显示	
		local battle_formation_update_pragress_terminal = {
			_name = "battle_formation_update_pragress",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local updateType = params._type
				local roleType = params._roleType
				local roleIndex = params._roleIndex
				local value = params._value
				if tonumber(updateType) == 1 then
					-- 更新血量
					--> print("更新玩家血量显示", roleIndex, value)
					instance:updateRoleHp(roleType, roleIndex, value)
				else
					-- 更新怒气
					--> print("更新玩家怒气显示", roleIndex, value)
					instance:updateRoleSP(roleType, roleIndex, value)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		-- 更新UI界面显示
			local battle_formation_update_ui_terminal = {
			_name = "battle_formation_update_ui",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local num = params._num
				instance:updateBattleUI(num)
				instance.roleType = 0
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		-- 战斗入场动画UI界面显示
		local battle_formation_show_ui_terminal = {
			_name = "battle_formation_show_ui",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local root = instance.roots[1]
				root:setVisible(true)
				instance:battleRoundStart()
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}

		-- 战斗入场动画UI界面显示
		local battle_formation_hide_ui_terminal = {
			_name = "battle_formation_hide_ui",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local root = instance.roots[1]
				root:setVisible(true)
				instance:battleNextRound()
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}

		-- 动画加速控制
        local battle_formation_action_time_speed_terminal = {
            _name = "battle_formation_action_time_speed",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setTimeSpeed()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 重置我们角色信息
        local battle_formation_update_reset_hero_information_terminal = {
            _name = "battle_formation_update_reset_hero_information",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateResetHeroInformation()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(battle_formation_controller_role_attack_terminal)
		state_machine.add(battle_formation_controller_role_anger_terminal)
		state_machine.add(battle_formation_controller_role_blast_terminal)
		state_machine.add(battle_formation_controller_role_deathed_terminal)
		state_machine.add(battle_formation_create_role_head_terminal)
		state_machine.add(battle_formation_create_role_head_over_terminal)
		state_machine.add(battle_formation_update_pragress_terminal)
		state_machine.add(battle_formation_update_ui_terminal)
		state_machine.add(battle_formation_show_ui_terminal)
		state_machine.add(battle_formation_hide_ui_terminal)
		state_machine.add(battle_formation_action_time_speed_terminal)
		state_machine.add(battle_formation_update_reset_hero_information_terminal)
        state_machine.init()
    end
    
	-- 发送状态事件
	-- state_machine.excute("battle_formation_controller_role_deathed", 0, {})
    -- call func init battle_formation_controller state machine.
    init_battle_formation_controller_terminal()
	
	local csbPveDuplicate = csb.createNode("battle/battle_kongjian.csb")
	local root = csbPveDuplicate:getChildByName("root")
	self.csbPveDuplicate = csbPveDuplicate
	table.insert(self.roots, root)
	self:addChild(csbPveDuplicate)
	-- root:setVisible(false)
end

function BattleFormationController:setTimeSpeed()
	local action = self.actions[1]
	action:setTimeSpeed(1.0 / __fight_recorder_action_time_speed)
end

-- 角色攻击状态控制
-- 角色类型, 1.敌方角色， 2. 我方角色
-- 角色死亡位置	
function BattleFormationController:roleAttack(roleType, roleIndex)
	self.roleType = roleType
	self.roleIndex = roleIndex
	self:roleController(roleType, roleIndex, 1)
end
-- 角色怒气状态控制
-- 角色类型, 1.敌方角色， 2. 我方角色
-- 角色死亡位置	
function BattleFormationController:roleAnger(roleType, roleIndex)
	self:roleController(roleType, roleIndex, 2)
end
-- 角色爆破状态控制
-- 角色类型, 1.敌方角色， 2. 我方角色
-- 角色死亡位置	
function BattleFormationController:roleBlast(roleType, roleIndex)
	self:roleController(roleType, roleIndex, 3)
end
-- 角色死亡状态控制
-- 角色类型, 1.敌方角色， 2. 我方角色
-- 角色死亡位置		
function BattleFormationController:roleDeathed(roleType, roleIndex)
	self:roleController(roleType, roleIndex, 4)
end

-- 角色状态控制器
function BattleFormationController:roleController(roleType, roleIndex, eventType, value)
	local arr = nil
	if tonumber(roleType) == 1 then
		arr = self.masterTeam
	else
		arr = self.roleTeam
	end
	if arr[tonumber(roleIndex)] ~= nil then
		--> print("这是位置点是", roleIndex, arr[roleIndex].pos)
		--> print("事件分发到各个子对象进行处理", eventType)
		-- 将消息分发到所有节点
		if tonumber(roleType) == 1 then
			state_machine.excute("battle_master_head_update", 0, {_cell = arr[tonumber(roleIndex)], _eventType = eventType, _roleType = 1, _roleIndex = roleIndex, _value = value})
		else
			state_machine.excute("battle_player_head_update", 0, {_cell = arr[tonumber(roleIndex)], _eventType = eventType, _roleType = 2, _roleIndex = roleIndex, _value = value})
		end
	end
end

-- 创建我方武将头像
-- 角色类型, 1.敌方角色， 2. 我方角色
function BattleFormationController:createHead(roleType, mouldId, index, roleName, roleInfo)
	local root = self.roots[1]
	-- 创建UI显示头像
	if roleType == 1 then
		-- 敌方武将
		local cell = BattleMasterHeadCell:createCell()
		cell:init({_mouldId = mouldId, _index = index, _name = roleName}, roleInfo)
		-- 获取敌方武将坑位置
		local seatmaster = ccui.Helper:seekWidgetByName(root, string.format("Panel__enemy_%d", index))
		seatmaster:addChild(cell)
		self.masterTeam[tonumber(index)] = cell
	else
		if self.crearePlayerOver == false then
			-- 我方武将
			local cell = BattlePlayerHeadCell:createCell()
			cell:init({_mouldId = mouldId, _index = index, _name = roleName}, roleInfo)
			local seat = ccui.Helper:seekWidgetByName(root, string.format("Panel__hore_%d", index))
			--> print("头像创建中********", string.format("Panel_hore_%d", index))
			seat:addChild(cell)
			self.roleSeat[tonumber(index)] = 1
			self.roleTeam[tonumber(index)] = cell
		end
	end
end
-- 创建剩下的位置
function BattleFormationController:createOther()
	local root = self.roots[1]
	--> print("头像创建完毕开始创建剩余头像中")
	for i, v in pairs(self.roleSeat) do
		--> print("-------------------------", v)
		if v ~= 1 then
			local cell = BattlePlayerHeadCell:createCell()
			cell:init({_mouldId = 0})
			--> print("创建空余头像********", string.format("Panel_hore_%d", i))
			local seat = ccui.Helper:seekWidgetByName(root, string.format("Panel__hore_%d", i))
			seat:addChild(cell)
		end
	end
	self.crearePlayerOver = true
end
-- 更新队伍UI显示
function BattleFormationController:updateBattleUI(num)
	local root = self.roots[1]

	--> print("回合结束清空敌人列表显示")
	if tonumber(num) == 2 then
		self:updatePlayerPosition()
	else
		for i, v in pairs(self.masterTeam) do
			local seatmaster = ccui.Helper:seekWidgetByName(root, string.format("Panel__enemy_%d", v.pos))
			seatmaster:removeChild(v)
		end
		self.masterTeam = {}
	end
end
function BattleFormationController:updatePlayerPosition()
	for i, v in pairs(self.roleTeam) do
		self:roleController(tonumber(v.type), tonumber(v.pos), 7)
	end
end

function BattleFormationController:updateResetHeroInformation()
	for i, v in pairs(self.roleTeam) do
		self:roleController(tonumber(v.type), tonumber(v.pos), 8)
	end
end

-- 更新血量显示
function BattleFormationController:updateRoleHp(roleType, roleIndex, value)
	self:roleController(roleType, roleIndex, 5, value)
end
function BattleFormationController:updateRoleSP(roleType, roleIndex, value)
	self:roleController(roleType, roleIndex, 6, value)
end

-- 播放战斗开始动画


function BattleFormationController:battleRoundStart()
	
	local action = csb.createTimeline("battle/battle_kongjian.csb")
	table.insert(self.actions, action)
	self.csbPveDuplicate:runAction(action)
	action:play("battle_kongjian_ui", false)
	action:setFrameEventCallFunc(function (frame)
			if nil == frame then
				return
			end
			
			local str = frame:getEvent()
			--> print("角色UI信息:", str)
			if str == "battle_kongjian_ui_close_1" then
				-- 开场动画播放完毕
				-- 请求开始战斗
				--self:battleRoundStart()
				--> print("角色UI信息显示完毕。")
				state_machine.excute("fight_draw_ui", 0, 0)
			end
		end)
end

function BattleFormationController:battleNextRound()
	--> print("BattleFormationController 隐藏角色小头像")
	local action = self.actions[1]
	action:play("battle_kongjian_ui_out", false)
	action:setFrameEventCallFunc(function (frame)
			if nil == frame then
				return
			end
			
			local str = frame:getEvent()
			--> print("角色UI信息:", str)
			if str == "battle_kongjian_ui_close_2" then
				-- 开场动画播放完毕
				-- 请求开始战斗
				--self:battleRoundStart()
				--> print("角色UI信息隐藏完毕。")
				-- state_machine.excute("fight_draw_ui", 0, 0)

				-- 对我方角色进行加血处理

				-- 复位各角色的图标
				state_machine.excute("battle_formation_update_ui", 0, {_num = 2})
				state_machine.excute("battle_formation_update_reset_hero_information", 0, "")
			end
		end)
end

function BattleFormationController:onUpdateDraw()
	
end

function BattleFormationController:onEnterTransitionFinish()

end

function BattleFormationController:onExit()
	state_machine.remove("battle_formation_controller_role_attack")
	state_machine.remove("battle_formation_controller_role_anger")
	state_machine.remove("battle_formation_controller_role_blast")
	state_machine.remove("battle_formation_controller_role_deathed")
	state_machine.remove("battle_formation_create_role_head")
	state_machine.remove("battle_formation_create_role_head_over")
	state_machine.remove("battle_formation_update_pragress")
	state_machine.remove("battle_formation_update_ui")
	state_machine.remove("battle_formation_show_ui")
	state_machine.remove("battle_formation_hide_ui")
	state_machine.remove("battle_formation_action_time_speed")
	state_machine.remove("battle_formation_update_reset_hero_information")
end
