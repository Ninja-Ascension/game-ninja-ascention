move_logic = move_logic or {}
local move_mode = {
	move_mode_normal_situ	= 0,							-- 0原地
	move_mode_normal_screen_center	= 1,					-- 1屏幕中（固定敌方2号位对象前）
	move_mode_normal_defender_front	= 2,					-- 2移动到承受者所在直线前方（固定敌方123号位前方）
	move_mode_normal_defender_front_row	= 3,				-- 3移动到承受者前方(前排优先)
	move_mode_normal_defender_back_row	= 4,				-- 4移动到承受者前方(后排优先)
	move_mode_normal_assassination	= 5,					-- 5攻击者消失（暗杀）
	move_mode_normal_front_row_first	= 6,				-- 6移动到前排1号位左下方
	move_mode_normal_back_row_four	= 7,					-- 7移动到后排4号位左下方
	move_mode_normal_camp_center	= 8,					-- 8敌方阵营中心
	move_mode_union_situ	= 101,							-- 101原地
	move_mode_union_lr_screen_center	= 102,				-- 102屏幕中心点左右两边（对应敌方2号位的左右）
	move_mode_union_lr_screen	= 103,						-- 103屏幕中心两端边缘（对应敌方1号位左边，3号位右边）
	move_mode_union_ud_screen_center	= 104,				-- 104屏幕中心点上下（对应敌方2号位的下边）
	move_mode_union_lf_front_col	= 105,					-- 105移动到承受者所在直线前方左右（固定敌方123号位前方）
	move_mode_union_un_front_col	= 106,					-- 106移动到承受者所在直线前方上下（固定敌方123号位前方）
	move_mode_union_defender_lf_front_col	= 107,			-- 107移动到承受者前方左右（前排优先）
	move_mode_union_defender_lf_back_col	= 108,			-- 108移动到承受者前方左右（后排优先）
	move_mode_union_lr_camp_center	= 109,					-- 109移动到敌方阵营中心左右
	move_mode_union_camp_four_corner	= 110,				-- 110移动到敌方阵营的四角
}

local display_size = cc.size(app.screenSize.width, app.screenSize.height)
local display_design_size = cc.size(app.designSize.width, app.designSize.height)
local move_formation_postions = {
	-- 攻击方的编队坐标偏移
	{
		{0, 0},			-- 0原地
		{0, 0},			-- 1屏幕中（固定敌方2号位对象前）
	},
	-- 防守方的编队坐标偏移
	{
		{0, 0},			-- 0原地
		{0, 0},			-- 1屏幕中（固定敌方2号位对象前）
	},
}

-- roles 	当前的行动角色队列
-- params	参数序列
--          skillElementData = params[1]
--	        skillInfluenceElementData = params[2]
-- 			attackMovePos = params[3]
-- 			attackers = params[4]
-- 			defenders = params[5]
-- 			sync = params[6]
-- skillElementData     技能
-- skillInfluenceElementData   技能效用

-- 获取移动的坐标-0原地
function move_logic.move_mode_normal_situ_position(roles, params, skillElementData, skillInfluenceElementData)
	return nil
end

-- 获取移动的坐标-1屏幕中（固定敌方2号位对象前）
function move_logic.move_mode_normal_screen_center_position(roles, params, skillElementData, skillInfluenceElementData)
	local positions = nil
	if roles ~= nil and #roles > 0 then
		positions = {}
		local attackers = params[_enum_params_index.param_attackers]
		local defenders = params[_enum_params_index.param_defenders]
		local att_center_node = attackers[2]
		local def_center_node = defenders[2]
		local att_center_node_parent = att_center_node--:getParent()
		local def_center_node_parent = def_center_node--:getParent()
		local target_size = att_center_node_parent:getContentSize()
		local att_center_node_position = cc.p(att_center_node_parent:getPosition())
		local def_center_node_position = cc.p(def_center_node_parent:getPosition())
		local center_pos = cc.p(att_center_node_position.x, att_center_node_position.y + (def_center_node_position.y - att_center_node_position.y) / 2)
		local nCount = #roles
		local cell_width = display_design_size.width / nCount
		for i, v in pairs(roles) do
			local camp = v._camp
			local curr_attacker = v
			local att_parent_size = curr_attacker:getContentSize()
			-- table.insert(positions, cc.p(center_pos.x, center_pos.y))
			table.insert(positions, cc.p(cell_width * (i - 1) + (cell_width - att_parent_size.width) / 2, center_pos.y))
		end
	end
	return positions
end

-- 获取移动的坐标-2移动到承受者所在直线前方（固定敌方123号位前方）
function move_logic.move_mode_normal_defender_front_position(roles, params, skillElementData, skillInfluenceElementData)
	local positions = nil
	if roles ~= nil and #roles > 0 then
		positions = {}
		local attack_move_pos = zstring.tonumber(params[3]) - 1
		local defenders = params[_enum_params_index.param_defenders]
		local defender_node_parent = defenders[attack_move_pos]--:getParent()
		local defender_node_size = defender_node_parent:getContentSize()
		local def_node_position = cc.p(defender_node_parent:getPosition())
		local nCount = #roles
		local tWidth = defender_node_size.width + (nCount > 0 and 1 or 0) * defender_node_size.width
		local cell_width = tWidth / nCount
		local target_pos = cc.p(def_node_position.x - (tWidth - defender_node_size.width) / 2, def_node_position.y)

		for i, v in pairs(roles) do
			local camp = zstring.tonumber(v._camp)
			local curr_attacker = v
			local att_parent_size = curr_attacker:getContentSize()
			table.insert(positions, cc.p(target_pos.x + cell_width * (i - 1) + (cell_width - att_parent_size.width) / 2, 
				target_pos.y + (camp == 1 and 1 or -1) * att_parent_size.height))
		end

		-- local defenders = params[_enum_params_index.param_defenders]
		-- local attack_move_pos = zstring.tonumber(params[3]) - 1
		-- local defender_node_parent = defenders[attack_move_pos]--:getParent()
		-- local defender_node_size = defender_node_parent:getContentSize()
		-- local def_node_position = cc.p(defender_node_parent:getPosition())
		-- local target_pos = cc.p(def_node_position.x + defender_node_size.width / 2, def_node_position.y)
		-- for i, v in pairs(roles) do
		-- 	local curr_attacker = v
		-- 	local camp = curr_attacker._camp
		-- 	local att_parent_size = curr_attacker:getContentSize()
		-- 	local offsetHeight = att_parent_size.height
		-- 	local mcoodf = 1
		-- 	if camp == "0" then
		-- 		mcoodf = -1
		-- 	end
		-- 	offsetHeight = mcoodf * offsetHeight
		-- 	table.insert(positions, cc.p(target_pos.x + att_parent_size.width / 2, target_pos.y + offsetHeight))
		-- end
	end
	return positions
end

-- 获取移动的坐标-3移动到承受者前方(前排优先)
function move_logic.move_mode_normal_defender_front_rowu_position(roles, params, skillElementData, skillInfluenceElementData)
	return move_logic.move_mode_normal_defender_front_position(roles, params, skillElementData, skillInfluenceElementData)
end

-- 获取移动的坐标-4移动到承受者前方(后排优先)
function move_logic.move_mode_normal_defender_back_rowu_position(roles, params, skillElementData, skillInfluenceElementData)
	return move_logic.move_mode_normal_defender_front_position(roles, params, skillElementData, skillInfluenceElementData)
end

-- 获取移动的坐标-5攻击者消失（暗杀）
function move_logic.move_mode_normal_assassinationu_position(roles, params, skillElementData, skillInfluenceElementData)
	return move_logic.move_mode_normal_defender_front_position(roles, params, skillElementData, skillInfluenceElementData)
end

-- 获取移动的坐标-6移动到前排1号位左下方
function move_logic.move_mode_normal_front_row_firstu_position(roles, params, skillElementData, skillInfluenceElementData)
	return move_logic.move_mode_normal_defender_front_position(roles, params, skillElementData, skillInfluenceElementData)
end

-- 获取移动的坐标-7移动到后排4号位左下方
function move_logic.move_mode_normal_back_row_fouru_position(roles, params, skillElementData, skillInfluenceElementData)
	return move_logic.move_mode_normal_defender_front_position(roles, params, skillElementData, skillInfluenceElementData)
end

-- 获取移动的坐标-8敌方阵营中心
function move_logic.move_mode_normal_camp_centeru_position(roles, params, skillElementData, skillInfluenceElementData)
	return nil
end

-- 获取移动的坐标-101原地
function move_logic.move_mode_union_situu_position(roles, params, skillElementData, skillInfluenceElementData)
	return nil
end

-- 获取移动的坐标-102屏幕中心点左右两边（对应敌方2号位的左右）
function move_logic.move_mode_union_lr_screen_centeru_position(roles, params, skillElementData, skillInfluenceElementData)
	return nil
end

-- 获取移动的坐标-103屏幕中心两端边缘（对应敌方1号位左边，3号位右边）
function move_logic.move_mode_union_lr_screenu_position(roles, params, skillElementData, skillInfluenceElementData)
	return nil
end

-- 获取移动的坐标-104屏幕中心点上下（对应敌方2号位的下边）
function move_logic.move_mode_union_ud_screen_centeru_position(roles, params, skillElementData, skillInfluenceElementData)
	return nil
end

-- 获取移动的坐标-105移动到承受者所在直线前方左右（固定敌方123号位前方）
function move_logic.move_mode_union_lf_front_colu_position(roles, params, skillElementData, skillInfluenceElementData)
	return nil
end

-- 获取移动的坐标-106移动到承受者所在直线前方上下（固定敌方123号位前方）
function move_logic.move_mode_union_un_front_colu_position(roles, params, skillElementData, skillInfluenceElementData)
	return nil
end

-- 获取移动的坐标-107移动到承受者前方左右（前排优先）
function move_logic.move_mode_union_defender_lf_front_colu_position(roles, params, skillElementData, skillInfluenceElementData)
end

-- 获取移动的坐标-108移动到承受者前方左右（后排优先）
function move_logic.move_mode_union_defender_lf_back_colu_position(roles, params, skillElementData, skillInfluenceElementData)
end

-- 获取移动的坐标-109移动到敌方阵营中心左右
function move_logic.move_mode_union_lr_camp_centeru_position(roles, params, skillElementData, skillInfluenceElementData)
end

-- 获取移动的坐标-110移动到敌方阵营的四角
function move_logic.move_mode_union_camp_four_corneru_position(roles, params, skillElementData, skillInfluenceElementData)
end

-- 获移动到的坐标点
function move_logic.init_move_position(roles, params)
	local skillElementData = params[1]
	local skillInfluenceElementData = params[2]
	-- params[3] = 5
	local attackMovePos = params[3]
	local positions = nil

	if attackMovePos == move_mode.move_mode_normal_situ then
		positions = move_logic.move_mode_normal_situ_position(roles, params, skillElementData, skillInfluenceElementData)
	elseif attackMovePos == move_mode.move_mode_normal_screen_center then
		positions = move_logic.move_mode_normal_screen_center_position(roles, params, skillElementData, skillInfluenceElementData)
	elseif attackMovePos == move_mode.move_mode_normal_defender_front then
		positions = move_logic.move_mode_normal_defender_front_position(roles, params, skillElementData, skillInfluenceElementData)
	elseif attackMovePos == move_mode.move_mode_normal_defender_front_row then
		positions = move_logic.move_mode_normal_defender_front_rowu_position(roles, params, skillElementData, skillInfluenceElementData)
	elseif attackMovePos == move_mode.move_mode_normal_defender_back_row then
		positions = move_logic.move_mode_normal_defender_back_rowu_position(roles, params, skillElementData, skillInfluenceElementData)
	elseif attackMovePos == move_mode.move_mode_normal_assassination then
		positions = move_logic.move_mode_normal_assassinationu_position(roles, params, skillElementData, skillInfluenceElementData)
	elseif attackMovePos == move_mode.move_mode_normal_front_row_first then
		positions = move_logic.move_mode_normal_front_row_firstu_position(roles, params, skillElementData, skillInfluenceElementData)
	elseif attackMovePos == move_mode.move_mode_normal_back_row_four then
		positions = move_logic.move_mode_normal_back_row_fouru_position(roles, params, skillElementData, skillInfluenceElementData)
	elseif attackMovePos == move_mode.move_mode_normal_camp_center then
		positions = move_logic.move_mode_normal_camp_centeru_position(roles, params, skillElementData, skillInfluenceElementData)
	elseif attackMovePos == move_mode.move_mode_union_situ then
		positions = move_logic.move_mode_union_situu_position(roles, params, skillElementData, skillInfluenceElementData)
	elseif attackMovePos == move_mode.move_mode_union_lr_screen_center then
		positions = move_logic.move_mode_union_lr_screen_centeru_position(roles, params, skillElementData, skillInfluenceElementData)
	elseif attackMovePos == move_mode.move_mode_union_lr_screen then
		positions = move_logic.move_mode_union_lr_screenu_position(roles, params, skillElementData, skillInfluenceElementData)
	elseif attackMovePos == move_mode.move_mode_union_ud_screen_center then
		positions = move_logic.move_mode_union_ud_screen_centeru_position(roles, params, skillElementData, skillInfluenceElementData)
	elseif attackMovePos == move_mode.move_mode_union_lf_front_col then
		positions = move_logic.move_mode_union_lf_front_colu_position(roles, params, skillElementData, skillInfluenceElementData)
	elseif attackMovePos == move_mode.move_mode_union_un_front_col then
		positions = move_logic.move_mode_union_un_front_colu_position(roles, params, skillElementData, skillInfluenceElementData)
	elseif attackMovePos == move_mode.move_mode_union_defender_lf_front_col then
		positions = move_logic.move_mode_union_defender_lf_front_colu_position(roles, params, skillElementData, skillInfluenceElementData)
	elseif attackMovePos == move_mode.move_mode_union_defender_lf_back_col then
		positions = move_logic.move_mode_union_defender_lf_back_colu_position(roles, params, skillElementData, skillInfluenceElementData)
	elseif attackMovePos == move_mode.move_mode_union_lr_camp_center then
		positions = move_logic.move_mode_union_lr_camp_centeru_position(roles, params, skillElementData, skillInfluenceElementData)
	elseif attackMovePos == move_mode.move_mode_union_camp_four_corner then
		positions = move_logic.move_mode_union_camp_four_corneru_position(roles, params, skillElementData, skillInfluenceElementData)
	else
		--> print("无效的移动位置！")
	end
	return positions
end

-- 处理战斗攻击的移动处理
function move_logic.initailize(roles, params, positions)
	move_logic._datas = {roles, params}
	for i, v in pairs(roles) do
		v._move_logic_need_move_back = true
		v._move_logic_need_move_backing = false
		v._move_logic_need_move = true
		v._move_logic_is_moving = false
		v._move_logic_origin_position = cc.p(v:getPosition())
		v._move_logic_target_position = positions ~= nil and positions[i] or nil
		if v._armature ~= nil then
			v._armature._move_logic_save_invoke = v._armature._invoke
			v._armature._current_role = v
			v._armature._current_role._move_logic_is_moving = false
			v._armature._current_role._move_logic_is_attacking = false
		end
	end
end

-- 校验移动是否结束
function move_logic.check_move_over(roles, params)
	for i, v in pairs(roles) do
		if v._move_logic_is_moving == true then
			return false
		end
	end
	return true
end

function move_logic.check_move_back_over(roles, params)
	for i, v in pairs(roles) do
		if v._move_logic_need_move_backing == true then
			return false
		end
	end
	return true
end

function move_logic.move_ot_attack(armatureBack)
	local armature = armatureBack
	armature._current_role._move_logic_is_attacking = true
	local isOver = true
	local roles = move_logic._datas[1]
	local params = move_logic._datas[2]
	armature._nextAction = _enum_animation_frame_index.animation_standby
	if armature._sync == true then
		isOver = move_logic.check_move_over(roles, params)
	end
	if isOver == true then
		local next_terminal_name = params[_enum_params_index.param_next_terminal_name]
		--> print("战斗过程中，所有角色移动结束了。", next_terminal_name)
		state_machine.excute(next_terminal_name, 0, {roles, params, armature})
	end
end

function move_logic.move_ot_origin_point(armatureBack)

end

-- 创建移动控制动作
function move_logic.move_change_action_callback(armatureBack)
	local armature = armatureBack
	if armature ~= nil then
		local actionIndex = armature._actionIndex
		if actionIndex == _enum_animation_frame_index.animation_standby then
			-- if armature._current_role._move_logic_is_attacking == false then
			--> print("角色移动完毕。让角色进入到待机状态，准备发动攻击。", actionIndex)
			-- 	move_logic.move_ot_attack(armatureBack)
			-- end
		elseif actionIndex == _enum_animation_frame_index.animation_attack_moving 
			or actionIndex == _enum_animation_frame_index.animation_skill_moving 
			or actionIndex == _enum_animation_frame_index.animation_fit_move_action 
			then
			local array = {}
			local params = move_logic._datas[2]
			local mtime = params[_enum_params_index.param_move_time]
			table.insert(array, cc.MoveTo:create(mtime * __fight_recorder_action_time_speed, armature._current_role._move_logic_target_position))
			table.insert(array, cc.CallFunc:create(move_logic.moveOverFuncN))
			local seq = cc.Sequence:create(array)
			armature._current_role:runAction(seq)
			armature._current_role._move_logic_is_moving = true
			armature._current_role._move_logic_is_attacking = false
			armature._nextAction = _enum_animation_frame_index.animation_standby

			params[_enum_params_index.param_restart_attack_callback](armature)
		end
	end
end

-- 角色移动结束的事件监听
function move_logic.moveOverFuncN(sender)
	sender._move_logic_is_moving = false
	-- sender._armature._nextAction = _enum_animation_frame_index.animation_standby
end

-- 创建移动控制动作
function move_logic.create_action(role, params)

	local sync = params[_enum_params_index.param_next_terminal_name]
	local roles = params[1]

	local armature = role._armature
	armature._current_role = role
	armature._sync = sync
	local camp = zstring.tonumber(armature._camp) + 1
	--> debug.print_r(armature._sie_action)
	local indexs = zstring.split(dms.atos(armature._sie_action, skill_influence.attack_move_action), ",")
	-- local actionIndex = zstring.tonumber(indexs[camp])
	local skillProperty = dms.atoi(armature._sie_action, skill_mould.skill_property)	-- 技能属性(0:物理 1:法术)
	local actionIndex = skillProperty == 0 and _enum_animation_frame_index.animation_attack_moving or _enum_animation_frame_index.animation_skill_moving
	if roles ~= nil and #roles > 0 then
		actionIndex = _enum_animation_frame_index.animation_fit_move_action
	end
	armature._nextAction = actionIndex
	armature._invoke = move_logic.move_change_action_callback
end

function move_logic.moveBackOverFuncN(sender)
	sender._move_logic_need_move_backing = false

	local roles = move_logic._datas[1]
	local params = move_logic._datas[2]
	local sync = params[_enum_params_index.param_next_terminal_name]
	if move_logic.check_move_back_over(roles, params) == true then
		params[_enum_params_index.param_move_back_callback]()
	end
end

function move_logic.create_back_action(role, params)
	local params = move_logic._datas[2]
	local mtime = params[_enum_params_index.param_move_time]
	local array = {}
	table.insert(array, cc.MoveTo:create((mtime + 0.5) * __fight_recorder_action_time_speed, role._move_logic_origin_position))
	table.insert(array, cc.CallFunc:create(move_logic.moveBackOverFuncN))
	local seq = cc.Sequence:create(array)
	role:runAction(seq)
end

-- 进行角色移动
function move_logic.moving(roles, params)
	for i, v in pairs(roles) do
		if v._move_logic_need_move == true then
			move_logic.create_action(v, params)
			v._move_logic_need_move = false
		elseif v._move_logic_need_move_back == true then
			v._move_logic_need_move_back = false
			v._move_logic_need_move_backing = true
			move_logic.create_back_action(v, params)
		end
	end
end

-- 处理战斗攻击的移动处理
function move_logic.excute(roles, params)
	local positions = move_logic.init_move_position(roles, params)
	-- initailize role move state.
	move_logic.initailize(roles, params, positions)
	if positions == nil then
		--> print("无需移动，直接进入后续逻辑。")
		for i, v in pairs(roles) do
			v._move_logic_need_move = false
			move_logic.move_ot_attack(v._armature)
		end
	else
		--> print("进入角色移动逻辑。")
		move_logic.moving(roles, params)
	end
end

function move_logic.back()
	--> print("进入角色移动返回逻辑。")
	local roles = move_logic._datas[1]
	local params = move_logic._datas[2]
	local moveCount = 0
	for i, v in pairs(roles) do
		if v._move_logic_need_move_back == true then
			moveCount = moveCount + 1
		end
	end
	if moveCount == 0 then
		params[_enum_params_index.param_move_back_callback]()
	else
		move_logic.moving(roles, params)
	end
end

-- Initialize login fight move logic state machine.
local function init_move_logic_terminal()
	-- 创建角色
	local move_logic_begin_move_all_role_terminal = {
        _name = "move_logic_begin_move_all_role",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			move_logic.excute(params[1], params[2])
			return true
        end,
        _terminal = nil,
        _terminals = nil
	}
	state_machine.add(move_logic_begin_move_all_role_terminal)
    state_machine.init()
end

-- call func init fight move logic state machine.
init_move_logic_terminal()



















