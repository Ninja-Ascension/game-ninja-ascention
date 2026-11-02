--[[ ----------------------------------------------------------------------------
-- 成就小控件
--]] ----------------------------------------------------------------------------
RoleBiographyAchievementCell2 = class("RoleBiographyAchievementCell2Class", Window)
RoleBiographyAchievementCell2.__size = nil

-- 创建Cell实例
local role_biography_achievement_cell_2_create_terminal = {
	_name = "role_biography_achievement_cell_2_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if RoleBiographyAchievementCell2 then
			local cell = RoleBiographyAchievementCell2:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_achievement_cell_2_create_terminal)
state_machine.init()

-- 构造器
function RoleBiographyAchievementCell2:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies task1 page state machine.
	local function init_role_biography_achievement_cell_2_terminal()
		-- 选中成就
		local role_biography_achievement_cell_2_select_terminal = {
			_name = "role_biography_achievement_cell_2_select",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local id = params._datas._id
				-- print("成就id = ", id)

				local index = params._datas._index

				-- 选中
				state_machine.excute("role_biography_achievement_cell_1_select", 0, index)

				state_machine.excute("role_biography_achievement_select", 0, id)

				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(role_biography_achievement_cell_2_select_terminal)
	end
	-- call func init ninja biographies task1 state machine.
	init_role_biography_achievement_cell_2_terminal()
end

-- 对象初始化
function RoleBiographyAchievementCell2:init(params)
	self._index = params[1]
	self._data = params[2]

	self:onInit(params)
	self:setContentSize(RoleBiographyAchievementCell2.__size)
	return self
end

function RoleBiographyAchievementCell2:onUpdateDraw()
	local root = self.roots[1]

	local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	local Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")

	local id = dms.atof(self._data, biographies_achieve.id)
	
	local name_mould_id = dms.atof(self._data, biographies_achieve.name)
    local word_info = dms.element(dms["word_mould"], name_mould_id)
    local name = word_info[3]
	Text_2:setString(name)

	local achievementValue = dms.atof(self._data, biographies_achieve.achievementValue)
	Text_1:setString(achievementValue)

	local Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
	local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")

	local isUnlock = RoleBiographyHandle.getAchievementIsUnlock(id)
	Panel_1:setVisible(not isUnlock)
	Panel_2:setVisible(isUnlock)

	local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
	Panel_effect:setTouchEnabled(false)


	local curValue = RoleBiographyHandle.getCurAchievementValue()
	local selectValue = dms.int(dms["biographies_achieve"], id, biographies_achieve.achievementValue)

	-- 是否解锁
	local condition_1 = RoleBiographyHandle.getAchievementIsUnlock(id)
	-- 成就值是否达到
	local condition_2 = curValue >= selectValue
	-- 需要判断当前id 是否是可以解锁的成就id
	local nextId = 1

    local info = RoleBiographyHandle.getBiographyAchieveInfo()
    local achieveStatus = zstring.split(info.achieveStatusInfo, ",")
    for id, status in ipairs(achieveStatus) do
        if tonumber(status) == 0 then
            nextId = id
            break
        end
    end

	local canActivate = (not condition_1) and condition_2 and (id == nextId)
	
	local Image_hint = ccui.Helper:seekWidgetByName(root, "Image_hint")
	Image_hint:setVisible(canActivate)
	
end

function RoleBiographyAchievementCell2:onEnterTransitionFinish()
	
end

function RoleBiographyAchievementCell2:onInit(params)
	-- 加载RoleBiographyAchievementCell2Window界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_task_1 = res/cultivate/ninja_biographies/ninja_biographies_task_1.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_task_1.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/ninja_biographies/ninja_biographies_task_1.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if RoleBiographyAchievementCell2.__size == nil then
		RoleBiographyAchievementCell2.__size = root:getContentSize()
	end

	local Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
	local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")

	local id = dms.atof(self._data, biographies_achieve.id)
	fwin:removeTouchEventListener(Panel_1)
	fwin:removeTouchEventListener(Panel_2)
	
	fwin:addTouchEventListener(Panel_1, nil,
	{
		terminal_name = "role_biography_achievement_cell_2_select",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_id = id,
		_index = self._index
	}, nil, 0)

	fwin:addTouchEventListener(Panel_2, nil,
	{
		terminal_name = "role_biography_achievement_cell_2_select",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_id = id,
		_index = self._index
	}, nil, 0)

	self:onUpdateDraw()
end

function RoleBiographyAchievementCell2:onExit()
	-- 释放RoleBiographyAchievementCell2Window界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_task_1.csb", root)
	-- ]]
end

function RoleBiographyAchievementCell2:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RoleBiographyAchievementCell2:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_task_1.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
