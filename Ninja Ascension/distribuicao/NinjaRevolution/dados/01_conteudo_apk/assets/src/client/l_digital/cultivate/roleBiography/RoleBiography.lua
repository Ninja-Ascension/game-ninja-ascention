--[[ ----------------------------------------------------------------------------
-- 忍列传列表界面(激活，升星)
--]] ----------------------------------------------------------------------------
RoleBiography = class("RoleBiographyClass", Window)

-- 打开窗口
local role_biography_window_open_terminal = {
	_name = "role_biography_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RoleBiographyClass") then
			fwin:open(RoleBiography:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local role_biography_window_close_terminal = {
	_name = "role_biography_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RoleBiographyClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_window_open_terminal)
state_machine.add(role_biography_window_close_terminal)
state_machine.init()

-- 构造器
function RoleBiography:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._chapterId = nil

	self._selectBiographyId = nil

	self._isOpenCompose = false -- 是否开启合成功能

	--	
	-- Initialize role_biography page state machine.
	local function init_role_biography_terminal()
		-- 打开角色创建窗口
		local role_biography_open_terminal = {
			_name = "role_biography_open",
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
		local role_biography_close_terminal = {
			_name = "role_biography_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local role_biography_show_terminal = {
			_name = "role_biography_show",
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
		local role_biography_hide_terminal = {
			_name = "role_biography_hide",
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

		-- 成就值界面
		local role_biography_achievement_terminal = {
			_name = "role_biography_achievement",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_achievement_window_open", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 印记抽取
		local role_biography_draw_signet_window_open_terminal = {
			_name = "role_biography_draw_signet_window_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_divine_window_open", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 选中列传cell查看右侧面板
		local role_biography_select_biography_terminal = {
			_name = "role_biography_select_biography",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local biographyId = params
					instance:updateSelectId(biographyId)
					instance:updateRightUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新列表
		local role_biography_refresh_ui_terminal = {
			_name = "role_biography_refresh_ui",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance:updateUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 规则按钮
		local role_biography_open_rule_window_terminal = {
			_name = "role_biography_open_rule_window",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_rule_window_open", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 激活按钮
		local role_biography_activate_terminal = {
			_name = "role_biography_activate",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					state_machine.lock("role_biography_activate")
					local biographyId = instance._selectBiographyId
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							-- 激活成功弹窗
							state_machine.excute("role_biography_activate_success_window_open", 0, biographyId)
							
							-- 清空原有属性
							RoleBiographyHandle.clearTotalPropertyData()
							-- 战力飘字
							_ED.offCalculateTotalFight = false
							smFightingChange()

							-- 刷新界面
							state_machine.excute("role_biography_refresh_ui", 0, nil)
							state_machine.excute("role_biography_chapter_refresh_ui", 0, nil)

							state_machine.excute("notification_center_update",0,"push_notification_role_biography")

							state_machine.unlock("role_biography_activate")
						else
							_ED.offCalculateTotalFight = false
							state_machine.unlock("role_biography_activate")
						end
					end
					_ED.offCalculateTotalFight = true
					protocol_command.biographies_activate.param_list = "" .. biographyId
					NetworkManager:register(protocol_command.biographies_activate.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 升星按钮
		local role_biography_up_level_terminal = {
			_name = "role_biography_up_level",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local biographyId = instance._selectBiographyId
					state_machine.excute("role_biography_up_level_window_open", 0, biographyId)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 升星重置按钮
		local role_biography_reset_terminal = {
			_name = "role_biography_reset",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 打开升星重置界面
				if nil ~= instance then
					local biographyId = instance._selectBiographyId
					state_machine.excute("role_biography_start_reset_window_open", 0, biographyId)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 选中光效
		local role_biography_update_select_terminal = {
			_name = "role_biography_update_select",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local index = params
					instance:updateSelectImage(index)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 是否打开一键合成界面
		local role_biography_check_open_one_bond_synthesis_terminal = {
			_name = "role_biography_check_open_one_bond_synthesis",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local biographyId = instance._selectBiographyId
					local type = params._datas.type
					local isCompose = instance:getActivateOrLevelUpByCompose()
					if isCompose then
						state_machine.excute("role_biography_one_bond_synthesis_window_open", 0, {biographyId = biographyId, type = type})
					else
						if type == 1 then
							state_machine.excute("role_biography_activate", 0, nil)
						else
							state_machine.excute("role_biography_up_level", 0, nil)
						end
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		

		state_machine.add(role_biography_open_terminal)
		state_machine.add(role_biography_close_terminal)
		state_machine.add(role_biography_show_terminal)
		state_machine.add(role_biography_hide_terminal)
		state_machine.add(role_biography_achievement_terminal)
		state_machine.add(role_biography_draw_signet_window_open_terminal)
		state_machine.add(role_biography_select_biography_terminal)
		state_machine.add(role_biography_refresh_ui_terminal)
		state_machine.add(role_biography_open_rule_window_terminal)
		state_machine.add(role_biography_activate_terminal)
		state_machine.add(role_biography_up_level_terminal)
		state_machine.add(role_biography_reset_terminal)
		state_machine.add(role_biography_update_select_terminal)
		state_machine.add(role_biography_check_open_one_bond_synthesis_terminal)

		state_machine.init()
	end
	-- call func init role_biography state machine.
	init_role_biography_terminal()
end

-- 判断当时是否为通过合成印记来进行升星/激活
function RoleBiography:getActivateOrLevelUpByCompose()
	local isCompose = false 
	local canNormalActivate, canComposeActivate = RoleBiographyHandle.getBiographyCanActivte(self._selectBiographyId)
	local canNormalLevelUp, canComposeLevelUp = RoleBiographyHandle.getBiographyCanLevelUp(self._selectBiographyId)
	if canComposeActivate or canComposeLevelUp then
		isCompose = true
	end

	return isCompose
end

-- 对象初始化
function RoleBiography:init(params)
	self._chapterId = params
	self._isOpenCompose = GetProjectFunctionIsOpen(ProjectFunctionEnum.RoleBiographyCompose)
	return self
end

function RoleBiography:updateUI()
	local sortResult = self:getSortBiographyList()

	self:updateBiographyList(sortResult)

	local firstData = sortResult[1]
	if firstData then
		local biographyId = dms.atof(firstData, biographies_mould.id)
		self:updateSelectId(biographyId)
	end

	self:updateSelectImage(1)
		
	self:updateRightUI()
end

-- 更新选中的列传Id
function RoleBiography:updateSelectId(biographyId)
	self._selectBiographyId = biographyId
end

function RoleBiography:updateRightUI()
	self:updateRightTop()
	self:updateRightBottom()
	self:updateScrollView()

	
	local isMaxStar = RoleBiographyHandle.getIsMaxStar(self._selectBiographyId)
	self.Button_reset:setVisible(isMaxStar)

	local isActivate = RoleBiographyHandle.getBiographyIsActivate(self._selectBiographyId)
	local canActivate, canComposeActivate = RoleBiographyHandle.getBiographyCanActivte(self._selectBiographyId)
	local canUpLevel, canComposeLevelUp = RoleBiographyHandle.getBiographyCanLevelUp(self._selectBiographyId)
	
	-- 激活状态并可以升星并且没有满级
	self.Button_up:setVisible(isActivate and (not isMaxStar))
	self.Button_up:setTouchEnabled(canUpLevel == true or canComposeLevelUp == true)
	self.Button_up:setBright(canUpLevel == true or canComposeLevelUp == true)


	-- self.Button_activiting:setVisible(canActivate)

	local curStar = RoleBiographyHandle.getAllBiographyInfo()[self._selectBiographyId]

	local chapterId = dms.int(dms["biographies_mould"], self._selectBiographyId, biographies_mould.chapterId)
	local _, canAdvance = RoleBiographyHandle.getChapterLockState(chapterId)

	if curStar and canAdvance then
		for i, v in ipairs(self.Image_stars) do
			v:setVisible(curStar >= i)
		end
		self.Panel_star:setVisible(true)
	else
		self.Panel_star:setVisible(false)
	end

	local isShow = canActivate or canComposeActivate
	self:startActivateAnimation(isShow, isActivate)

	self:showAchieveRedDot()
end

-- 激活按钮光效
function RoleBiography:startActivateAnimation(isShow, isActivate)
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
		local effectTerminalName = self:getActivitingTerminalName()
		fwin:addTouchEventListener(Panel_effect, nil,
		{
			terminal_name = effectTerminalName,
			terminal_state = 0,
			isPressedActionEnabled = true,
			type = 1
		}, nil, 0)
	else
		self.Button_activiting:setVisible(isActivate == false)
		self.Button_activiting:setTouchEnabled(false)
		self.Button_activiting:setBright(false)

		Panel_effect:setTouchEnabled(false)
		fwin:removeTouchEventListener(Panel_effect)
	end
end

-- 成就按钮红点
function RoleBiography:showAchieveRedDot()
	if self.Button_task._istips == true then
		self.Button_task:removeChild(self.Button_task._nodeChild, true)
		self.Button_task._nodeChild = nil
		self.Button_task._istips = false
	end

	if RoleBiographyHandle.showAchieveDot() == true then
		if self.Button_task._istips == nil or self.Button_task._istips == false then
			local ball = cc.Sprite:create("images/ui/bar/tips.png")
			ball:setAnchorPoint(cc.p(0.5, 0.5))
			ball:setPosition(cc.p(self.Button_task:getContentSize().width-ball:getContentSize().width*0.5, self.Button_task:getContentSize().height-ball:getContentSize().height*0.5))
			self.Button_task:addChild(ball)
			self.Button_task._nodeChild = ball
			self.Button_task._istips = true
		end
	end
end

-- 列传的印记组成
function RoleBiography:updateRightTop()
	local selectBiographyId = self._selectBiographyId

	local data = dms.element(dms["biographies_mould"], selectBiographyId)

	local signetCostStr = dms.atos(data, biographies_mould.signet_cost)
	local signetCost = zstring.splits(signetCostStr, "|", ",")

	local isActivate = RoleBiographyHandle.getBiographyIsActivate(selectBiographyId)
	local isMaxStar = RoleBiographyHandle.getIsMaxStar(selectBiographyId)
	
	for i, v in ipairs(self.Panel_boxs) do
		v:removeAllChildren(true)

		local prop = signetCost[i]
		if prop then
			-- 1代表数量足够 2代表可合成 -1 不显示  true代表显示已拥有
			local showState =-1

			if self._isOpenCompose == true then
				showState = self:getImprintState(prop)
				-- 如果已满星，不显示标签
				showState = (not isMaxStar) and showState or -1
			else
				local haveEnoughCount = tonumber(getPropAllCountByMouldId(prop[2])) >= tonumber(prop[3])
				showState = (not isActivate) and haveEnoughCount
			end
			local cell = RoleBiographyHandle.addSpecialIconCell(prop, true, showState)
			v:addChild(cell)
		end
	end
end

-- 获取当前印记状态
function RoleBiography:getImprintState(propInfo)
	local showState =-1
	local haveEnoughCount = tonumber(getPropAllCountByMouldId(propInfo[2])) >= tonumber(propInfo[3])

	if haveEnoughCount then
		showState = 1
	else
		if RoleBiographyHandle.getCurImprintComposeIsEnough(propInfo) then
			showState = 2
		end
	end

	return showState
end

-- 列传的状态（可以激活 可以升星 未激活 已激活）
function RoleBiography:updateRightBottom()
	local selectBiographyId = self._selectBiographyId

	local data = dms.element(dms["biographies_mould"], selectBiographyId)
	local name_mould_id = dms.atos(data, biographies_mould.name)

	local word_info = dms.element(dms["word_mould"], name_mould_id)
	local name = word_info[3]
	self.Text_name:setString(name)

	local achievementAdd = dms.atof(data, biographies_mould.achievementAdd)
	self.Text_name_0:setString(string.format(tipStringInfo_role_biography[2], achievementAdd))
end

-- 添加选中光效
function RoleBiography:updateSelectImage(index)
	local items = self.ListView_1:getChildren()
	for i, v in ipairs(items) do
		local selectImage = nil
		local cell = v
		if cell ~= nil then
			local root = cell:getChildByName("root")
			if root ~= nil then
				selectImage = root:getChildByName("Image_4_0")
			end
		end
		if selectImage then
			selectImage:setVisible(i == index)
		end
	end
end

-- 绘制列传列表
function RoleBiography:updateBiographyList(sortResult)
	local ListView_1 = self.ListView_1
	ListView_1:removeAllItems()
	
	for i, v in ipairs(sortResult) do
		local cell = state_machine.excute("role_biography_cell_create", 0, {index = i, data = v})
		ListView_1:addChild(cell)
	end
	self.ListView_1_poy = self.ListView_1:getInnerContainer():getPositionY()

	ListView_1:jumpToTop()
	ListView_1:requestRefreshView()
end

function RoleBiography:getSortBiographyList()
	local biographies = RoleBiographyHandle.getBiographiesByChapterId(self._chapterId)

	--列表排序：
		--可以激活>可合成激活>可以升星>可合成升星>未激活>已激活
	--内部排序：
		--品质>印记组成个数>id


	local function sortFunc(a, b)
		local aQuality = dms.atof(a, biographies_mould.quality)
		local bQuality = dms.atof(b, biographies_mould.quality)

		if aQuality == bQuality then
			local aTempStr = dms.atos(a, biographies_mould.signet_cost)
			local bTempStr = dms.atos(b, biographies_mould.signet_cost)

			local aComponentsNum = table.nums(zstring.split(aTempStr, "|"))
			local bComponentsNum = table.nums(zstring.split(bTempStr, "|"))

			if aComponentsNum == bComponentsNum then
				local aId = dms.atof(a, biographies_mould.id)
				local bId = dms.atof(b, biographies_mould.id)

				return aId > bId
			end

			return aComponentsNum > bComponentsNum
		end

		return aQuality > bQuality
	end

	local sortList = {}

	local canUnlockList = {}
	local canUnlockCopmoseList = {}				-- 合成可激活
	local canLevelUpList = {}
	local canLevelUpComposeList = {}			-- 合成可升星
	local notUnlockList = {}
	local haveActivateList = {}

	local function sortNormalFunc()
		for _, v in ipairs(biographies) do
			local biographyId = dms.atof(v, biographies_mould.id)
			
			local isActivate = RoleBiographyHandle.getBiographyIsActivate(biographyId)
			if RoleBiographyHandle.getBiographyCanActivte(biographyId) then
				table.insert(canUnlockList, v)
			elseif RoleBiographyHandle.getBiographyCanLevelUp(biographyId) then
				table.insert(canLevelUpList, v)
			elseif not isActivate then
				table.insert(notUnlockList, v)
			else
				table.insert(haveActivateList, v)
			end
		end
	end

	-- 添加印记合成逻辑
	local function sortComposeFunc()
		for _, v in ipairs(biographies) do
			local biographyId = dms.atof(v, biographies_mould.id)
			
			local isActivate = RoleBiographyHandle.getBiographyIsActivate(biographyId)

			local canNormalActivate, canComposeActivate = RoleBiographyHandle.getBiographyCanActivte(biographyId)
			local canNormalLevelUp, canComposeLevelUp = RoleBiographyHandle.getBiographyCanLevelUp(biographyId)

			-- print(canNormalActivate, "====canNormalActivate", canComposeActivate, '====canComposeActivate')
			-- print(canNormalLevelUp, "====canNormalLevelUp", canComposeLevelUp, '====canComposeLevelUp')
			-- print("---------------------------------")
			
			if canNormalActivate then
				table.insert(canUnlockList, v)
			elseif canComposeActivate then 
				table.insert(canUnlockCopmoseList, v)
			elseif canNormalLevelUp then
				table.insert(canLevelUpList, v)
			elseif canComposeLevelUp then
				table.insert(canLevelUpComposeList, v)
			elseif not isActivate then
				table.insert(notUnlockList, v)
			else
				table.insert(haveActivateList, v)
			end
		end
	end

	-- 是否启用一键合成
	if self._isOpenCompose == true then
		sortComposeFunc()
	else
		sortNormalFunc()
	end

	table.sort(canUnlockList, sortFunc)
	for _, v in ipairs(canUnlockList) do
		table.insert(sortList, v)
	end

	table.sort(canUnlockCopmoseList, sortFunc)
	for _, v in ipairs(canUnlockCopmoseList) do
		table.insert(sortList, v)
	end

	table.sort(canLevelUpList, sortFunc)
	for _, v in ipairs(canLevelUpList) do
		table.insert(sortList, v)
	end

	table.sort(canLevelUpComposeList, sortFunc)
	for _, v in ipairs(canLevelUpComposeList) do
		table.insert(sortList, v)
	end

	table.sort(notUnlockList, sortFunc)
	for _, v in ipairs(notUnlockList) do
		table.insert(sortList, v)
	end

	table.sort(haveActivateList, sortFunc)
	for _, v in ipairs(haveActivateList) do
		table.insert(sortList, v)
	end

	return sortList
end

function RoleBiography:updateScrollView()
	local tSortedHeroes = self:getPropertyList()

	local ListView_2 = self.ListView_2
	ListView_2:removeAllItems()
	
	for i, v in ipairs(tSortedHeroes) do
		local cell = RoleBiographyHandle.addPropertyCell(v, 1)
		ListView_2:addChild(cell)
	end

	ListView_2:jumpToTop()
	ListView_2:requestRefreshView()
end

function RoleBiography:getPropertyList()
	local totalData = {}

    local function addPropertyValue(property_add)
        for _, v in pairs(property_add) do
            local propertyType = tonumber(v[1])
            local propertyValue = tonumber(v[2])

            totalData[propertyType] = (totalData[propertyType] or 0) + propertyValue
        end
    end

	local property_add_str = dms.string(dms["biographies_mould"], self._selectBiographyId, biographies_mould.property_add)
	local property_add_1 = zstring.splits(property_add_str, "|", ",")
    addPropertyValue(property_add_1)

	local curStar = RoleBiographyHandle.getAllBiographyInfo()[self._selectBiographyId]
	if curStar then
		for _, v in pairs(dms["biographies_star_mould"]) do
	        local id = dms.atof(v, biographies_star_mould.biographies_mould_id)
	        if self._selectBiographyId == id then
	            local star = dms.atof(v, biographies_star_mould.star)
	            if curStar > 0 and curStar >= star then
	                local property_add_str = dms.atos(v, biographies_star_mould.property_add)
	                if property_add_str ~= "-1" then
	                    local property_add_2 = zstring.splits(property_add_str, "|", ",")
	                    addPropertyValue(property_add_2)
	                end
	            end
	        end
	    end
	end

    local propertyData = {}
    -- k 属性类型 v属性值
    for k, v in pairs(totalData) do
    	local propertyStr = k .. "," .. v
    	table.insert(propertyData, propertyStr)
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
	-- debug.print_r(result)
	return result
end

function RoleBiography:onUpdateDraw()
	local root = self.roots[1]

	-- 忍列传属性
	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")

	-- 印记icon
	self.Panel_boxs = {}
	for i = 1, 7 do
		local Panel_box = ccui.Helper:seekWidgetByName(root, "Panel_box_"..i)
		table.insert(self.Panel_boxs, Panel_box)
	end

	-- 忍列传名称
	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")

	-- 印记数值
	self.Text_name_0 = ccui.Helper:seekWidgetByName(root, "Text_name_0")

	-- 属性滚动容器
	self.ListView_2 = ccui.Helper:seekWidgetByName(root, "ListView_2")

	-- 列传容器
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	-- 星星容器
	self.Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")

	self.Image_stars = {}
	for i = 1, 7 do
		local Image_star = ccui.Helper:seekWidgetByName(root, "Image_star_"..i)
		table.insert(self.Image_stars, Image_star)
	end

	-- 激活按钮动画
	self.Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")

	self:openTopWindow()
	self:updateUI()
end

function RoleBiography:getActivitingTerminalName()
	local terminalName = "role_biography_activate"
	if self._isOpenCompose then
		terminalName = "role_biography_check_open_one_bond_synthesis"
	end

	return terminalName
end

function RoleBiography:getLevelUpTerminalName()
	local terminalName = "role_biography_up_level"
	if self._isOpenCompose then
		terminalName = "role_biography_check_open_one_bond_synthesis"
	end

	return terminalName
end

function RoleBiography:openTopWindow()
	local userinfo = UserTopInfoA:new()
	userinfo._rootWindows = self
	fwin:open(userinfo, fwin._windows)
end

-- @onUpdate(dt)
function RoleBiography:onUpdate(dt)
	if self.ListView_1 ~= nil then
		local size = self.ListView_1:getContentSize()
		local posY = self.ListView_1:getInnerContainer():getPositionY()
		if self.ListView_1_poy == posY then
			return
		end
		self.ListView_1_poy = posY
		local items = self.ListView_1:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempY = v:getPositionY() + posY
			if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then	
				v:unload()
			else	
				v:reload()				
			end
		end
	end
end

function RoleBiography:onEnterTransitionFinish()
	-- 加载NinjaBiographies0Window界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_0 = res/cultivate/ninja_biographies/ninja_biographies_0.csb
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_0.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 占卜按钮
	self.Button_chouka = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chouka"), nil,
	{
		terminal_name = "role_biography_draw_signet_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 成就按钮
	self.Button_task = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task"), nil,
	{
		terminal_name = "role_biography_achievement",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	local activitingTerminalName = self:getActivitingTerminalName()
	-- 激活按钮
	self.Button_activiting = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_activiting"), nil,
	{
		terminal_name = activitingTerminalName,
		terminal_state = 0,
		isPressedActionEnabled = true,
		type = 1,
	}, nil, 0)	

	local levelUpTerminalName = self:getLevelUpTerminalName()
	-- 升星按钮（默认隐藏）
	self.Button_up = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_up"), nil,
	{
		terminal_name = levelUpTerminalName,
		terminal_state = 0,
		isPressedActionEnabled = true,
		type = 2,
	}, nil, 0)	


	-- 升星重置
	self.Button_reset = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reset"), nil,
	{
		terminal_name = "role_biography_reset",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	-- 规则按钮
	self.Button_help = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_help"), nil,
	{
		terminal_name = "role_biography_open_rule_window",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "role_biography_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self:onUpdateDraw()
end

function RoleBiography:onExit()
	-- 释放RoleBiographyWindow界面资源.
	state_machine.remove("role_biography_open")
	state_machine.remove("role_biography_close")
	state_machine.remove("role_biography_show")
	state_machine.remove("role_biography_hide")

	state_machine.remove("role_biography_achievement")
	state_machine.remove("role_biography_jump_signet_warehouse")
	state_machine.remove("role_biography_select_biography")
	state_machine.remove("role_biography_refresh_ui")
	state_machine.remove("role_biography_open_rule_window")

	state_machine.remove("role_biography_activate")
	state_machine.remove("role_biography_up_level")
	state_machine.remove("role_biography_reset")

	state_machine.remove("role_biography_update_select")

	state_machine.remove("role_biography_check_open_one_bond_synthesis")
	
end

function RoleBiography:close()
	-- window event : close.

end

function RoleBiography:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
