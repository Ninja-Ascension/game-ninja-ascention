--[[ ----------------------------------------------------------------------------
-- 神锻
--]] ----------------------------------------------------------------------------
MythicalAnimalsForge = class("MythicalAnimalsForgeClass", Window)

-- 打开窗口
local mythical_animals_forge_window_open_terminal = {
	_name = "mythical_animals_forge_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("MythicalAnimalsForgeClass") then
			fwin:open(MythicalAnimalsForge:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local mythical_animals_forge_window_close_terminal = {
	_name = "mythical_animals_forge_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("MythicalAnimalsForgeClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_forge_window_open_terminal)
state_machine.add(mythical_animals_forge_window_close_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsForge:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize lim pool rule page state machine.
	local function init_mythical_animals_forge_terminal()
		-- 打开角色创建窗口
		local mythical_animals_forge_open_terminal = {
			_name = "mythical_animals_forge_open",
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
		local mythical_animals_forge_close_terminal = {
			_name = "mythical_animals_forge_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("mythical_animals_forge_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local mythical_animals_forge_show_terminal = {
			_name = "mythical_animals_forge_show",
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
		local mythical_animals_forge_hide_terminal = {
			_name = "mythical_animals_forge_hide",
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

		-- 天赋信息查看
		local mythical_animals_forge_open_tanlent_info_terminal = {
			_name = "mythical_animals_forge_open_tanlent_info",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					state_machine.excute("mythical_animals_talent_tip_window_open", 0, instance._animalsMouldId)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 翻页
		local mythical_animals_forge_turn_page_terminal = {
			_name = "mythical_animals_forge_turn_page",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local dir = params._datas._dir
					local maxCount = #instance._haveActivateList

					if dir > 0 then
						self._curSelectAnimalIndx = self._curSelectAnimalIndx + 1
						if self._curSelectAnimalIndx > maxCount then
							self._curSelectAnimalIndx = 1
						end
					else
						self._curSelectAnimalIndx = self._curSelectAnimalIndx - 1
						if self._curSelectAnimalIndx < 1 then
							self._curSelectAnimalIndx = maxCount
						end
					end

					instance._animalsMouldId = instance._haveActivateList[self._curSelectAnimalIndx]

					state_machine.excute("mythical_animals_forge_refresh_ui", 0, nil)

				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 神锻
		local mythical_animals_forge_go_terminal = {
			_name = "mythical_animals_forge_go",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local animalsMouldId = instance._animalsMouldId
					local mySelectIndex = instance._mySelectIndex

					local curStage = MythicalAnimalsHandle.getMythicalAnimalsStageById(animalsMouldId)
					local costProp = MythicalAnimalsHandle.getAnimalsUpStagCostPropInfoById(animalsMouldId, curStage)
					if costProp == nil then
						TipDlg.drawTextDailog(tipStringInfo_magical_animals_word[19])
						return
					end

					local forgeType = 0

					-- 锻造类型（0 锻造一次 1 锻造一次溢出消耗 2 一键锻造，3一键锻造消耗所有道具
					local function showConfirmTip(instance)
						state_machine.lock("mythical_animals_forge_go")
						local function responseCallback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								-- 战力飘字
								smFightingChange()

								instance:playForgeAniByType()

								-- 刷新界面
								state_machine.excute("mythical_animals_forge_refresh_ui", 0, nil)
								state_machine.excute("mythical_animals_refresh_ui", 0, nil)

								state_machine.excute("notification_center_update",0,"push_notification_mythical_animal")

								state_machine.excute("mythical_animals_main_ui_refresh_red_dot", 0, 0)

								state_machine.unlock("mythical_animals_forge_go")
							else
								state_machine.unlock("mythical_animals_forge_go")
							end
						end
						protocol_command.magical_animals_forging.param_list = "" .. animalsMouldId .. "\r\n" .. (mySelectIndex - 1) .. "\r\n" .. forgeType
						NetworkManager:register(protocol_command.magical_animals_forging.code, nil, nil, nil, instance, responseCallback, false, nil)
					end

					local isFull = MythicalAnimalsHandle.getForgeProgressIsFullById(animalsMouldId, mySelectIndex)
					if isFull == true then
						forgeType = 1

						app.load("client.utils.ConfirmTip")
						local tip = ConfirmTip:new()
						tip:init(instance, showConfirmTip, tipStringInfo_magical_animals_word[7], nil, nil, nil, false)
						fwin:open(tip, fwin._ui)
					else
						forgeType = 0
						showConfirmTip(instance)
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 一键神锻
		local mythical_animals_forge_fast_go_terminal = {
			_name = "mythical_animals_forge_fast_go",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local animalsMouldId = instance._animalsMouldId
					local mySelectIndex = instance._mySelectIndex

					local curStage = MythicalAnimalsHandle.getMythicalAnimalsStageById(animalsMouldId)
					local costProp = MythicalAnimalsHandle.getAnimalsUpStagCostPropInfoById(animalsMouldId, curStage)
					if costProp == nil then
						TipDlg.drawTextDailog(tipStringInfo_magical_animals_word[19])
						return
					end

					local forgeType = 2

					-- 锻造类型（0 锻造一次 1 锻造一次溢出消耗 2 一键锻造，3一键锻造消耗所有道具
					local function showConfirmTip(instance)
						state_machine.lock("mythical_animals_forge_go")
						local function responseCallback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								-- 战力飘字
								smFightingChange()

								instance:playForgeAniByType()

								-- 刷新界面
								state_machine.excute("mythical_animals_forge_refresh_ui", 0, nil)
								state_machine.excute("mythical_animals_refresh_ui", 0, nil)

								state_machine.excute("notification_center_update",0,"push_notification_mythical_animal")

								state_machine.excute("mythical_animals_main_ui_refresh_red_dot", 0, 0)

								state_machine.unlock("mythical_animals_forge_go")
							else
								state_machine.unlock("mythical_animals_forge_go")
							end
						end
						protocol_command.magical_animals_forging.param_list = "" .. animalsMouldId .. "\r\n" .. (mySelectIndex - 1) .. "\r\n" .. forgeType
						NetworkManager:register(protocol_command.magical_animals_forging.code, nil, nil, nil, instance, responseCallback, false, nil)
					end

					local isFull = MythicalAnimalsHandle.getForgeProgressIsFullById(animalsMouldId, mySelectIndex)
					if isFull == true then
						forgeType = 3

						app.load("client.utils.ConfirmTip")
						local tip = ConfirmTip:new()
						tip:init(instance, showConfirmTip, tipStringInfo_magical_animals_word[7], nil, nil, nil, false)
						fwin:open(tip, fwin._ui)
					else
						forgeType = 2
						showConfirmTip(instance)
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 选中cell
		local mythical_animals_forge_select_cell_terminal = {
			_name = "mythical_animals_forge_select_cell",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local index = params

					local items = instance.ListView_1:getItems()
					for i, v in ipairs(items) do
						v:setSelectState(false)
						if i == index then
							v:setSelectState(true)
						end
					end

					for i, v in ipairs(instance.Panel_stone_icon) do
						local cell = v:getChildren()
						if cell and cell[1] then
							cell[1]:setSelectState(false)
							if i == index then
								cell[1]:setSelectState(true)
							end
						end
					end

					instance._mySelectIndex = index
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新UI
		local mythical_animals_forge_refresh_ui_terminal = {
			_name = "mythical_animals_forge_refresh_ui",
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

		state_machine.add(mythical_animals_forge_open_terminal)
		state_machine.add(mythical_animals_forge_close_terminal)
		state_machine.add(mythical_animals_forge_show_terminal)
		state_machine.add(mythical_animals_forge_hide_terminal)
		state_machine.add(mythical_animals_forge_open_tanlent_info_terminal)
		state_machine.add(mythical_animals_forge_turn_page_terminal)
		state_machine.add(mythical_animals_forge_go_terminal)
		state_machine.add(mythical_animals_forge_fast_go_terminal)
		state_machine.add(mythical_animals_forge_select_cell_terminal)
		state_machine.add(mythical_animals_forge_refresh_ui_terminal)
		state_machine.init()
	end
	-- call func init lim pool rule state machine.
	init_mythical_animals_forge_terminal()
end

-- 对象初始化
function MythicalAnimalsForge:init(params)
	self._animalsMouldId = params
	self._mySelectIndex = 1

	local sortList = MythicalAnimalsHandle.getSortAnimalsList()
	self._haveActivateList = {}

	for _, v in ipairs(sortList) do
		local id = dms.atof(v, magical_animals_mould.id)
		local animalsInfo = MythicalAnimalsHandle.getMythicalAnimalsInfoById(id)
		if animalsInfo ~= nil then
			table.insert(self._haveActivateList, id)
		end
	end

	self._curSelectAnimalIndx = -1
	for i, v in ipairs(self._haveActivateList) do
		if self._animalsMouldId == v then
			self._curSelectAnimalIndx = i
			break
		end
	end

	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function MythicalAnimalsForge:onUpdateDraw()
	local root = self.roots[1]

	-- 名字
	self.Text_animals_name = ccui.Helper:seekWidgetByName(root, "Text_animals_name")
	-- 当前阶数
	self.Text_stage_num = ccui.Helper:seekWidgetByName(root, "Text_stage_num")
	-- 天赋名字
	self.Text_skil_info = ccui.Helper:seekWidgetByName(root, "Text_skil_info")
	
	-- 神锻属性
	self.Text_Property = {}
	table.insert(self.Text_Property, {name = ccui.Helper:seekWidgetByName(root, "Text_atk"), value = ccui.Helper:seekWidgetByName(root, "Text_atk_num")})
	table.insert(self.Text_Property, {name = ccui.Helper:seekWidgetByName(root, "Text_def"), value = ccui.Helper:seekWidgetByName(root, "Text_def_num")})
	table.insert(self.Text_Property, {name = ccui.Helper:seekWidgetByName(root, "Text_hp"), value = ccui.Helper:seekWidgetByName(root, "Text_hp_num")})

	-- 神锻材料列表
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
	
	self.Panel_stone_icon = {}
	for i = 1, 3 do
		local Panel_stone_icon = ccui.Helper:seekWidgetByName(root, "Panel_stone_icon_"..i)
		table.insert(self.Panel_stone_icon, Panel_stone_icon)
	end

	self.Panel_anima_forging_success = ccui.Helper:seekWidgetByName(root, "Panel_anima_forging_success")

	self:updateUI()
end

-- 播放神锻动画
function MythicalAnimalsForge:playForgeAniByType()
	self.Panel_anima_forging_success:removeAllChildren(true)

	local jsonFile = "images/ui/effice/effect_shenshou1/effect_shenshou1.json"
	local atlasFile = "images/ui/effice/effect_shenshou1/effect_shenshou1.atlas"

	local aniName = "animation"
	if self._mySelectIndex == 1 then
		aniName = "animation"
	elseif self._mySelectIndex == 2 then
		aniName = "animation2"
	elseif self._mySelectIndex == 3 then
		aniName = "animation3"
	end

	local animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName, true, nil)
	sp.initArmature(animation, true)
	animation:setAnimation(0, aniName, false)
	animation:setPosition(self.Panel_anima_forging_success:getContentSize().width / 2, self.Panel_anima_forging_success:getContentSize().height / 2)
	self.Panel_anima_forging_success:addChild(animation)
end

function MythicalAnimalsForge:updateUI()
	self:updateLeftTop()
	self:updateLeftBottom()

	self:updateRightList()
end

function MythicalAnimalsForge:updateLeftTop()
	local name = MythicalAnimalsHandle.getAnimalsNameById(self._animalsMouldId)
	self.Text_animals_name:setString(name)

	local curStage = MythicalAnimalsHandle.getMythicalAnimalsStageById(self._animalsMouldId)
	local costProp = MythicalAnimalsHandle.getAnimalsUpStagCostPropInfoById(self._animalsMouldId, curStage)
	local forgeUseCount = MythicalAnimalsHandle.getMythicalAnimalsForgeUseCountById(self._animalsMouldId)

	local Panel_stone_icon = self.Panel_stone_icon
	for i, v in ipairs(Panel_stone_icon) do
		v:removeAllChildren(true)

		if costProp ~= nil then
			local prop = costProp[i]
			local useCount = forgeUseCount[i]
			local cell = state_machine.excute("mythical_animals_forge_stone_cell_create", 0, {index = i, prop = prop, useCount = useCount})
			v:addChild(cell)
		end
	end
end

function MythicalAnimalsForge:updateLeftBottom()
	local curStage = MythicalAnimalsHandle.getMythicalAnimalsStageById(self._animalsMouldId)
	self.Text_stage_num:setString(curStage)

	local propertyData = MythicalAnimalsHandle.getAnimalsForgePropertyById(self._animalsMouldId)

	local result = {}
	for k, v in pairs(propertyData) do
		table.insert(result, {propertyType = k, propertyValue = v})
	end
	local function sortFunc(a, b)
		return a.propertyType < b.propertyType
	end
	table.sort(result, sortFunc)

	for i, v in ipairs(self.Text_Property) do
		v.name:setVisible(false)
		v.value:setVisible(false)

		if result[i] then
			local propertyType = tonumber(result[i].propertyType)
			local propertyValue = tonumber(result[i].propertyValue)
			local name, value = getHardenPropertyNameAndValue(propertyType, propertyValue, true, tipStringInfo_magical_animals_property_name_and_value)

			v.name:setString(name)
			v.value:setString(value)
			
			v.name:setVisible(true)
			v.value:setVisible(true)
		end
	end

	-- 神锻天赋
	local talentMouldId = MythicalAnimalsHandle.getAnimalsCurStageTalentById(self._animalsMouldId, curStage)
	local text = tipStringInfo_magical_animals_word[12]
	if talentMouldId and talentMouldId > 0 then
		local nameId = dms.int(dms["talent_mould"], talentMouldId, talent_mould.talent_describe)
		local word_info = dms.element(dms["word_mould"], nameId)
		text = word_info[3]
	end

	self.Text_skil_info:setString(text)
end

function MythicalAnimalsForge:updateRightList()
	local ListView_1 = self.ListView_1
	ListView_1:removeAllItems()

	local forgeUseCount = MythicalAnimalsHandle.getMythicalAnimalsForgeUseCountById(self._animalsMouldId)

	--神锻消耗材料
	local props = MythicalAnimalsHandle.getForgeProps()

	for i = 1, 3 do
		local prop = props[i]
		local useCount = forgeUseCount[i]
		local cell = state_machine.excute("mythical_animals_forge_cell_create", 0, {index = i, prop = prop, useCount = useCount, animalsMouldId = self._animalsMouldId})

		ListView_1:addChild(cell)
	end

	state_machine.excute("mythical_animals_forge_select_cell", 0, self._mySelectIndex)
end

function MythicalAnimalsForge:onEnterTransitionFinish()
	-- 加载MythicalAnimalsForgeWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_forging = res/cultivate/Mythical_animals/mythical_animals_forging.csb
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_forging.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_animals_forging_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_animals_forging_close"), nil,
	{
		terminal_name = "mythical_animals_forge_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 天赋信息查看
	self.Button_inf = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_inf"), nil,
	{
		terminal_name = "mythical_animals_forge_open_tanlent_info",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 左
	self.Button_left = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_left"), nil,
	{
		terminal_name = "mythical_animals_forge_turn_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_dir = -1
	}, nil, 0)

	-- 右
	self.Button_right = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_right"), nil,
	{
		terminal_name = "mythical_animals_forge_turn_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_dir = 1
	}, nil, 0)	

	-- 神锻
	self.Button_forging = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_forging"), nil,
	{
		terminal_name = "mythical_animals_forge_go",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 一键神锻
	self.Button_forging_up = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_forging_up"), nil,
	{
		terminal_name = "mythical_animals_forge_fast_go",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self:onUpdateDraw()
end

function MythicalAnimalsForge:onExit()
	-- 释放MythicalAnimalsForgeWindow界面资源.
	state_machine.remove("mythical_animals_forge_open")
	state_machine.remove("mythical_animals_forge_close")
	state_machine.remove("mythical_animals_forge_show")
	state_machine.remove("mythical_animals_forge_hide")
	state_machine.remove("mythical_animals_forge_open_tanlent_info")
	state_machine.remove("mythical_animals_forge_turn_page")
	state_machine.remove("mythical_animals_forge_go")
	state_machine.remove("mythical_animals_forge_fast_go")
	state_machine.remove("mythical_animals_forge_select_cell")
	state_machine.remove("mythical_animals_forge_refresh_ui")
end

function MythicalAnimalsForge:close()
	-- window event : close.
	
end

function MythicalAnimalsForge:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
