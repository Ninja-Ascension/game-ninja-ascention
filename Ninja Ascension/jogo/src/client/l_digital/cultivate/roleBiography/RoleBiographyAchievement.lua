--[[ ----------------------------------------------------------------------------
-- 成就界面
--]] ----------------------------------------------------------------------------
RoleBiographyAchievement = class("RoleBiographyAchievementClass", Window)

-- 打开窗口
local role_biography_achievement_window_open_terminal = {
	_name = "role_biography_achievement_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RoleBiographyAchievementClass") then
			fwin:open(RoleBiographyAchievement:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local role_biography_achievement_window_close_terminal = {
	_name = "role_biography_achievement_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RoleBiographyAchievementClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_achievement_window_open_terminal)
state_machine.add(role_biography_achievement_window_close_terminal)
state_machine.init()

-- 构造器
function RoleBiographyAchievement:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies task page state machine.
	local function init_role_biography_achievement_terminal()
		-- 打开角色创建窗口
		local role_biography_achievement_open_terminal = {
			_name = "role_biography_achievement_open",
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

		-- 关闭角色创建窗口
		local role_biography_achievement_close_terminal = {
			_name = "role_biography_achievement_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_achievement_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local role_biography_achievement_show_terminal = {
			_name = "role_biography_achievement_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local role_biography_achievement_hide_terminal = {
			_name = "role_biography_achievement_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新UI
		local role_biography_achievement_refresh_terminal = {
			_name = "role_biography_achievement_refresh",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:updateUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 选中某成就
		local role_biography_achievement_select_terminal = {
			_name = "role_biography_achievement_select",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance._selectId = params
					instance:updatePropertyList()
					instance:updateBottomUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 激活成就
		local role_biography_achievement_activate_terminal = {
			_name = "role_biography_achievement_activate",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					state_machine.lock("role_biography_achievement_activate")

					local curSelectId = instance._selectId
					-- print("激活成就 curSelectId = ", curSelectId)
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							-- 激活成功弹窗
							state_machine.excute("role_biography_achieve_success_window_open", 0, curSelectId)

							-- 清空原有属性
							RoleBiographyHandle.clearTotalPropertyData()
							-- 战力飘字
							_ED.offCalculateTotalFight = false
							smFightingChange()

							-- 刷新界面
							state_machine.excute("role_biography_achievement_refresh", 0, nil)
							state_machine.excute("role_biography_chapter_refresh_ui", 0, nil)
							state_machine.excute("role_biography_refresh_ui", 0, nil)

							state_machine.excute("notification_center_update",0,"push_notification_role_biography")

							state_machine.unlock("role_biography_achievement_activate")
						else
							_ED.offCalculateTotalFight = false
							state_machine.unlock("role_biography_achievement_activate")
						end
					end
					_ED.offCalculateTotalFight = true
					protocol_command.biographies_achieve_activate.param_list = "" .. curSelectId
					NetworkManager:register(protocol_command.biographies_achieve_activate.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(role_biography_achievement_open_terminal)
		state_machine.add(role_biography_achievement_close_terminal)
		state_machine.add(role_biography_achievement_show_terminal)
		state_machine.add(role_biography_achievement_hide_terminal)
		state_machine.add(role_biography_achievement_refresh_terminal)
		state_machine.add(role_biography_achievement_select_terminal)
		state_machine.add(role_biography_achievement_activate_terminal)
		state_machine.init()
	end
	-- call func init ninja biographies task state machine.
	init_role_biography_achievement_terminal()
end

-- 对象初始化
function RoleBiographyAchievement:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function RoleBiographyAchievement:updateUI()
	self._selectId = self:getNextUnlockAchievementId()

	-- 成就
	self:updateAchievementList()

	-- 属性
	self:updatePropertyList()

	self:updateBottomUI()
end

function RoleBiographyAchievement:getNextUnlockAchievementId()
	local jumpIndex = 1
	local totalIndex = dms.count(dms["biographies_achieve"])

	for i, v in ipairs(dms["biographies_achieve"]) do
		local id = dms.atof(v, biographies_achieve.id)
		local isUnlock = RoleBiographyHandle.getAchievementIsUnlock(id)
		if isUnlock then
			jumpIndex = jumpIndex + 1
		end
	end

	return jumpIndex > totalIndex and totalIndex or jumpIndex
end

function RoleBiographyAchievement:updateBottomUI()
	local curValue = RoleBiographyHandle.getCurAchievementValue()
	local selectValue = dms.int(dms["biographies_achieve"], self._selectId, biographies_achieve.achievementValue)

	-- 是否解锁
	local condition_1 = RoleBiographyHandle.getAchievementIsUnlock(self._selectId)
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

	local canActivate = (not condition_1) and condition_2 and (self._selectId == nextId)

	self:startActivateAnimation(canActivate)

	self.Panel_activiting:setVisible(not condition_1)
	self.Image_activiting:setVisible(condition_1)

	self.Text_1_0:setString(curValue)
	self.Text_pro_0:setString(curValue .. "/" .. selectValue)
	-- 可激活或者已解锁 绿色
	if curValue >= selectValue then
		self.Text_pro_0:setColor(cc.c3b(126, 255, 118))
	else
		self.Text_pro_0:setColor(cc.c3b(255, 0, 0))
	end
end

-- 激活按钮光效
function RoleBiographyAchievement:startActivateAnimation(isShow)
	local Panel_effect = self.Panel_effect
	Panel_effect:setVisible(isShow)

	Panel_effect:removeAllChildren(true)
	if isShow then
		local animationName = "animation"
		local jsonFile = "images/ui/effice/effect_ninja_biographies/effect_ninja_biographies.json"
		local atlasFile = "images/ui/effice/effect_ninja_biographies/effect_ninja_biographies.atlas"

		local animation = sp.spine(jsonFile, atlasFile, 1, 0, animationName, isLoop, nil)
		sp.initArmature(animation, true)
		animation:setAnimation(0, animationName, true)
		animation:setPosition(cc.p(Panel_effect:getContentSize().width/2, Panel_effect:getContentSize().height/2))
		Panel_effect:addChild(animation)

		self.Button_activiting:setVisible(false)
		Panel_effect:setTouchEnabled(true)
		fwin:addTouchEventListener(Panel_effect, nil,
		{
			terminal_name = "role_biography_achievement_activate",
			terminal_state = 0,
			isPressedActionEnabled = true,
		}, nil, 0)
	else
		self.Button_activiting:setVisible(true)
		self.Button_activiting:setTouchEnabled(false)
		self.Button_activiting:setBright(false)

		Panel_effect:setTouchEnabled(false)
		fwin:removeTouchEventListener(Panel_effect)
	end
end

function RoleBiographyAchievement:updateAchievementList()	
	local Panel_5 = self.Panel_5
	Panel_5:removeAllChildren(true)

	local cell = state_machine.excute("role_biography_achievement_cell_1_create", 0, nil)
	Panel_5:addChild(cell)
end

function RoleBiographyAchievement:updatePropertyList()
	local tSortedHeroes = self:getPropertyList()

	local ListView_2 = self.ListView_2
	ListView_2:removeAllItems()
	
	for i, v in ipairs(tSortedHeroes) do
		local cell = RoleBiographyHandle.addPropertyCell(v, 3)
		ListView_2:addChild(cell)
	end

	ListView_2:jumpToTop()
	ListView_2:requestRefreshView()
end

function RoleBiographyAchievement:getPropertyList()
	local selectId = self._selectId

	local property_add = dms.string(dms["biographies_achieve"], selectId, biographies_achieve.property_add)
	local propertyData = zstring.split(property_add, "|")

	local unlock_type = dms.int(dms["biographies_achieve"], selectId, biographies_achieve.unlock_type)


	local unlockStr = nil

	if unlock_type > 0 then
		local chapterId = dms.int(dms["biographies_achieve"], selectId, biographies_achieve.param)
		local name_mould_id = dms.int(dms["biographies_section_mould"], chapterId, biographies_section_mould.name)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
		local name = word_info[3]

		-- 解锁篇章
		if unlock_type == 1 then
			unlockStr = tipStringInfo_role_biography[6] .. "," .. name
		elseif unlock_type == 2 then -- 解锁篇章升星
			unlockStr = tipStringInfo_role_biography[7] .. "," .. name
		end
	end

	local result = {}
	local index = 1

	local function pushData(index, data)
		if result[index] == nil then
			result[index] = {}
		end
		if #result[index] < 2 then
			table.insert(result[index], data)
		else
			index = index + 1
			pushData(index, data)
		end
	end

	for _, v in ipairs(propertyData) do
		pushData(index, v)
	end

	if unlockStr then
		pushData(index, unlockStr)
	end
	

	-- debug.print_r(result, "result")
	return result
end

function RoleBiographyAchievement:onUpdateDraw()
	local root = self.roots[1]

	-- 印记数值
	self.Text_pro_0 = ccui.Helper:seekWidgetByName(root, "Text_pro_0")

	-- 成就容器
	self.Panel_5 = ccui.Helper:seekWidgetByName(root, "Panel_5")

	-- 属性容器
	self.ListView_2 = ccui.Helper:seekWidgetByName(root, "ListView_2")

	self.Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")

	self.Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")

	self.Panel_activiting = ccui.Helper:seekWidgetByName(root, "Panel_activiting")

	self.Image_activiting = ccui.Helper:seekWidgetByName(root, "Image_activiting")

	self:updateUI()
end

function RoleBiographyAchievement:onEnterTransitionFinish()
	-- 加载RoleBiographyAchievementWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_task = res/cultivate/ninja_biographies/ninja_biographies_task.csb
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_task.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 激活按钮
	self.Button_activiting = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_activiting"), nil,
	{
		terminal_name = "role_biography_achievement_activate",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 属性总览
	self.Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil,
	{
		terminal_name = "role_biography_property_preview_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_buy_power_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_power_close"), nil,
	{
		terminal_name = "role_biography_achievement_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function RoleBiographyAchievement:onExit()
	-- 释放RoleBiographyAchievementWindow界面资源.
	state_machine.remove("role_biography_achievement_open")
	state_machine.remove("role_biography_achievement_close")
	state_machine.remove("role_biography_achievement_show")
	state_machine.remove("role_biography_achievement_hide")
	state_machine.remove("role_biography_achievement_refresh")
	state_machine.remove("role_biography_achievement_select")
	state_machine.remove("role_biography_achievement_activate")
end

function RoleBiographyAchievement:close()
	-- window event : close.
	
end

function RoleBiographyAchievement:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
