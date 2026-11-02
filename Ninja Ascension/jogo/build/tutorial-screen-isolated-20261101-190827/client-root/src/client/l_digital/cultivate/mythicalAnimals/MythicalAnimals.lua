--[[ ----------------------------------------------------------------------------
-- 神兽页签界面
--]] ----------------------------------------------------------------------------
MythicalAnimals = class("MythicalAnimalsClass", Window)
MythicalAnimals.__size = nil

-- 打开窗口
local mythical_animals_window_open_terminal = {
	_name = "mythical_animals_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local panel = MythicalAnimals:new():init(params)
        fwin:open(panel)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_window_open_terminal)
state_machine.init()

-- 构造器
function MythicalAnimals:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	


	-- Initialize role_biography page state machine.
	local function init_mythical_animals_terminal()
		-- 显示窗口
		local mythical_animals_show_terminal = {
			_name = "mythical_animals_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:updateUI()
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local mythical_animals_hide_terminal = {
			_name = "mythical_animals_hide",
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

		-- 升星
		local mythical_animals_open_up_star_terminal = {
			_name = "mythical_animals_open_up_star",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local curStar = 0
					local animalsInfo = MythicalAnimalsHandle.getMythicalAnimalsInfoById(instance._curSelectMouldId)
					if animalsInfo ~= nil then
						curStar = MythicalAnimalsHandle.getMythicalAnimalsStarById(instance._curSelectMouldId)
					end

					-- 最大星级
					if curStar == 5 then
						TipDlg.drawTextDailog(tipStringInfo_magical_animals_word[13])
						return
					end

					state_machine.excute("mythical_animals_up_star_window_open", 0, instance._curSelectMouldId)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 激活
		local mythical_animals_activate_terminal = {
			_name = "mythical_animals_activate",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local animalsMouldId = instance._curSelectMouldId

					local canActivate = MythicalAnimalsHandle.canMythicalAnimalsUpStar(animalsMouldId, 0)
					if canActivate then
						state_machine.lock("mythical_animals_activate")
						local function responseCallback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								-- 战力飘字
								smFightingChange()

								-- 刷新界面
								state_machine.excute("mythical_animals_refresh_ui", 0, 1)

								state_machine.excute("notification_center_update",0,"push_notification_mythical_animal")

								state_machine.excute("mythical_animals_main_ui_refresh_red_dot", 0, 0)

								state_machine.unlock("mythical_animals_activate")
							else
								state_machine.unlock("mythical_animals_activate")
							end
						end
						protocol_command.magical_animals_activate.param_list = "" .. animalsMouldId
						NetworkManager:register(protocol_command.magical_animals_activate.code, nil, nil, nil, instance, responseCallback, false, nil)
					else
						TipDlg.drawTextDailog(tipStringInfo_magical_animals_word[5])
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 重生
		local mythical_animals_open_rebirth_terminal = {
			_name = "mythical_animals_open_rebirth",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("mythical_animals_rebirth_window_open", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 连携
		local mythical_animals_open_league_terminal = {
			_name = "mythical_animals_open_league",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					state_machine.excute("mythical_animals_league_window_open", 0, instance._curSelectMouldId)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 神锻
		local mythical_animals_open_forge_terminal = {
			_name = "mythical_animals_open_forge",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local animalsInfo = MythicalAnimalsHandle.getMythicalAnimalsInfoById(instance._curSelectMouldId)
					if animalsInfo ~= nil then
						state_machine.excute("mythical_animals_forge_window_open", 0, instance._curSelectMouldId)
					else
						TipDlg.drawTextDailog(tipStringInfo_magical_animals_word[11])
					end
					return true
				end
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新神兽信息
		local mythical_animals_refresh_ui_terminal = {
			_name = "mythical_animals_refresh_ui",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:updateLeftList()

					-- 当前选中的神兽索引
					if params ~= nil then
						instance._curLeftSelectIndex = params

						local sortList = instance:getSortAnimalsList()

						for i, v in ipairs(sortList) do
							if i == instance._curLeftSelectIndex then
								-- 当前神兽的mouldId
								instance._curSelectMouldId = dms.atof(v, magical_animals_mould.id)
								break
							end
						end
					end

					instance:selectLeftAnimal()
					instance:updateButtonState()
					instance:updateProgressBar()
					instance:updateAnimalModel()
					instance:updateRightUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(mythical_animals_show_terminal)
		state_machine.add(mythical_animals_hide_terminal)
		state_machine.add(mythical_animals_open_up_star_terminal)
		state_machine.add(mythical_animals_activate_terminal)
		state_machine.add(mythical_animals_open_rebirth_terminal)
		state_machine.add(mythical_animals_open_league_terminal)
		state_machine.add(mythical_animals_open_forge_terminal)
		state_machine.add(mythical_animals_refresh_ui_terminal)
		state_machine.init()
	end
	-- call func init role_biography state machine.
	init_mythical_animals_terminal()
end

-- 对象初始化
function MythicalAnimals:init(params)
	local rootWindow = params[1] 
    self._rootWindows = rootWindow

    self:onInit()
	return self
end

-- 打开对应页签
function MythicalAnimals:onInit()
	local csbItem = csb.createNode("cultivate/Mythical_animals/mythical_animals_cell.csb")
	self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

	if MythicalAnimals.__size == nil then
		MythicalAnimals.__size = root:getContentSize()
	end
	self:setContentSize(MythicalAnimals.__size)
	self:onUpdateDraw()
end

function MythicalAnimals:onUpdateDraw()
	local root = self.roots[1]

	-- 升星
	self.Button_starUp = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_starUp"), nil,
	{
		terminal_name = "mythical_animals_open_up_star",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 激活
	self.Button_unlock = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_unlock"), nil,
	{
		terminal_name = "mythical_animals_activate",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 重生
	self.Button_rebirth = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rebirth"), nil,
	{
		terminal_name = "mythical_animals_open_rebirth",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 连携
	self.Button_comb = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_comb"), nil,
	{
		terminal_name = "mythical_animals_open_league",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 神锻
	self.Button_forging = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_forging"), nil,
	{
		terminal_name = "mythical_animals_open_forge",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	
	-- 动画
	self.Panel_armatureNode = ccui.Helper:seekWidgetByName(root, "Panel_armatureNode")
	-- 左侧神兽列表
	self.ListView_2 = ccui.Helper:seekWidgetByName(root, "ListView_2")

	self.Image_star = {}
	for i = 1, 5 do
		local Image_star = ccui.Helper:seekWidgetByName(root, "Image_star_"..i)
		table.insert(self.Image_star, Image_star)
	end

	-- 神兽属性对全体武将的属性
	self.ListView_info_1 = ccui.Helper:seekWidgetByName(root, "ListView_info_1")

	-- 升阶天赋
	self.ListView_info_2 = ccui.Helper:seekWidgetByName(root, "ListView_info_2")

	self.Text_skill_name = ccui.Helper:seekWidgetByName(root, "Text_skill_name")

	self.Text_skill_info = ccui.Helper:seekWidgetByName(root, "Text_skill_info")

	self.Panel_skill_icon = ccui.Helper:seekWidgetByName(root, "Panel_skill_icon")

	self.Text_animal_name = ccui.Helper:seekWidgetByName(root, "Text_animal_name")

	self.Text_animal_stage = ccui.Helper:seekWidgetByName(root, "Text_animal_stage")

	self.Text_suipian_need = ccui.Helper:seekWidgetByName(root, "Text_suipian_need")

	-- 激活
	self.Panel_activty_animation_1 = ccui.Helper:seekWidgetByName(root, "Panel_activty_animation_1")
	-- 升星
	self.Panel_activty_animation_2 = ccui.Helper:seekWidgetByName(root, "Panel_activty_animation_2")

	-- 升星满级
	self.Text_max = ccui.Helper:seekWidgetByName(root, "Text_max")

	-- 解锁红点
	self.Image_red_1 = ccui.Helper:seekWidgetByName(root, "Image_red_1")
	-- 连携红点
	self.Image_red_2 = ccui.Helper:seekWidgetByName(root, "Image_red_2")
	-- 神锻红点
	self.Image_red_3 = ccui.Helper:seekWidgetByName(root, "Image_red_3")

	self.Image_15_1 = ccui.Helper:seekWidgetByName(root, "Image_15_1")

	-- 限定神兽标签挂载控件
	self.Panel_effect_sp = ccui.Helper:seekWidgetByName(root, "Panel_effect_sp")

	self:updateUI()
end

-- 按钮光效
function MythicalAnimals:playButtonAniByType(buttonType)
	local panel = buttonType == 0 and self.Panel_activty_animation_1 or self.Panel_activty_animation_2

	local jsonFile = "images/ui/effice/effect_illustration2/effect_illustration2.json"
	local atlasFile = "images/ui/effice/effect_illustration2/effect_illustration2.atlas"

	local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
	sp.initArmature(animation, true)
	animation:setAnimation(0, "animation", true)
	animation:setPosition(panel:getContentSize().width / 2, panel:getContentSize().height / 2)
	panel:addChild(animation)
end

function MythicalAnimals:updateUI()
	-- 默认选中第一个
	local curLeftSelectIndex = self._curLeftSelectIndex or 1
	state_machine.excute("mythical_animals_refresh_ui", 0, curLeftSelectIndex)
end

function MythicalAnimals:getSortAnimalsList()
	local sortList = MythicalAnimalsHandle.getSortAnimalsList()
	return sortList
end

-- 左侧列表
function MythicalAnimals:updateLeftList()
	local ListView_2 = self.ListView_2
	ListView_2:removeAllItems()

	local sortData = self:getSortAnimalsList()

	for i, v in ipairs(sortData) do
		local cell = state_machine.excute("mythical_animals_icon_cell_create", 0, {index = i, data = v, isCanTouch = true})
		ListView_2:addChild(cell)
	end
end

-- 设置按钮状态（激活 or 升星）
function MythicalAnimals:updateButtonState()
	local animalsInfo = MythicalAnimalsHandle.getMythicalAnimalsInfoById(self._curSelectMouldId)
	self.Button_unlock:setVisible(animalsInfo == nil)
	self.Button_starUp:setVisible(animalsInfo ~= nil)


	self.Panel_activty_animation_1:removeAllChildren(true)
	self.Panel_activty_animation_2:removeAllChildren(true)

	if animalsInfo == nil then
		-- 可激活
		if MythicalAnimalsHandle.canMythicalAnimalsUpStar(self._curSelectMouldId, 0) then
			self:playButtonAniByType(0)
		end
	else
		local curStar = MythicalAnimalsHandle.getMythicalAnimalsStarById(self._curSelectMouldId)
		if MythicalAnimalsHandle.canMythicalAnimalsUpStar(self._curSelectMouldId, curStar) then
			self:playButtonAniByType(1)
		end
	end

	local curStar = 0
	if animalsInfo ~= nil then
		local isMaxStar = MythicalAnimalsHandle.isMaxStarLevel(self._curSelectMouldId)
		if isMaxStar == true then
			self.Panel_activty_animation_1:removeAllChildren(true)
			self.Panel_activty_animation_2:removeAllChildren(true)
			self.Button_unlock:setVisible(false)
			self.Button_starUp:setVisible(false)
		end
	end
end

-- 激活/升星进度条
function MythicalAnimals:updateProgressBar()
	self.Text_suipian_need:setVisible(true)
	self.Image_15_1:setVisible(true)
	self.Text_max:setVisible(false)

	local animalsInfo = MythicalAnimalsHandle.getMythicalAnimalsInfoById(self._curSelectMouldId)

	local curStar = 0
	if animalsInfo ~= nil then
		curStar = MythicalAnimalsHandle.getMythicalAnimalsStarById(self._curSelectMouldId)
	end
	
	local _, costProp = MythicalAnimalsHandle.canMythicalAnimalsUpStar(self._curSelectMouldId, curStar)

	if costProp ~= nil then
		local haveCount = tonumber(getPropAllCountByMouldId(costProp[2]))
		local needCount = tonumber(costProp[3])

		self.Text_suipian_need:setString(haveCount .. "/" .. needCount)
		self.Text_suipian_need:setVisible(true)
	else
		self.Text_suipian_need:setVisible(false)
	end

	if animalsInfo ~= nil then
		local isMaxStar = MythicalAnimalsHandle.isMaxStarLevel(self._curSelectMouldId)
		if isMaxStar == true then
			self.Text_suipian_need:setVisible(false)
			self.Image_15_1:setVisible(false)
			self.Text_max:setVisible(true)
		end
	end
end

-- 选择左侧神兽
function MythicalAnimals:selectLeftAnimal()
	local curLeftSelectIndex = self._curLeftSelectIndex

	local items = self.ListView_2:getItems()
	for i, v in ipairs(items) do
		v:setSelectState(false)
		if i == curLeftSelectIndex then
			v:setSelectState(true)
		end
	end
end

function MythicalAnimals:updateAnimalModel()
	self.Panel_armatureNode:removeAllChildren(true)
	self:addHeroAnimation(self.Panel_armatureNode)
	-- 限定神兽标签
	if self.Panel_effect_sp then 
		self.Panel_effect_sp:removeAllChildren(true)
		self.Panel_effect_sp:setVisible(false)
		DisplayLimitAnimal(self._curSelectMouldId, nil, self.Panel_effect_sp, 3)
	end
end

function MythicalAnimals:addHeroAnimation(widget)
    local spriteId = dms.int(dms["magical_animals_mould"], self._curSelectMouldId, magical_animals_mould.spriteId)

    local hero_animation = sp.spine_sprite(widget, spriteId, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
	hero_animation.animationNameList = spineAnimations
	sp.initArmature(hero_animation, true)
end

function MythicalAnimals:updateRightUI()
	self:updateAnimalInfo()
	self:updatePropertyList()
	self:updateTalentList()

	self:updateSkillInfo()
	self:updateUIRedDot()
end

function MythicalAnimals:updateAnimalInfo()
	local name = MythicalAnimalsHandle.getAnimalsNameById(self._curSelectMouldId)
	self.Text_animal_name:setString(name)

	local curStar = MythicalAnimalsHandle.getMythicalAnimalsStarById(self._curSelectMouldId)
	for i, v in ipairs(self.Image_star) do
		v:setVisible(i <= curStar)
	end

	local curStage = MythicalAnimalsHandle.getMythicalAnimalsStageById(self._curSelectMouldId)
	self.Text_animal_stage:setString(string.format(tipStringInfo_magical_animals_word[2], curStage))
end

function MythicalAnimals:updatePropertyList()
	local ListView_info_1 = self.ListView_info_1
	ListView_info_1:removeAllItems()

	local curStar = MythicalAnimalsHandle.getMythicalAnimalsStarById(self._curSelectMouldId)
	curStar = (curStar == 0) and 1 or curStar

	local curPropertyData = MythicalAnimalsHandle.getAnimalsUpStarPropertyById(self._curSelectMouldId, curStar - 1)
	local forgeAddProperty = MythicalAnimalsHandle.getAnimalsForgePropertyById(self._curSelectMouldId)

	local result = {}
    for k, v in pairs(curPropertyData) do
        table.insert(result, {propertyType = k, propertyValue = v})
    end

    table.sort(result, function(a, b)
        return a.propertyType < b.propertyType
    end)

	for _, v in ipairs(result) do
		local cell = state_machine.excute("mythical_animals_property_cell_create", 0, {data = v, forgeAddProperty = forgeAddProperty})
		ListView_info_1:addChild(cell)
	end
end

function MythicalAnimals:updateTalentList()
	local ListView_info_2 = self.ListView_info_2
	ListView_info_2:removeAllItems()

	local talentList = MythicalAnimalsHandle.getAnimalsStageTalentById(self._curSelectMouldId)
	local curStage = MythicalAnimalsHandle.getMythicalAnimalsStageById(self._curSelectMouldId)
	for i, v in ipairs(talentList) do
		local cell = state_machine.excute("mythical_animals_talent_tip_cell_create", 0, {index = i, talentMouldId = v, curStage = curStage})
		ListView_info_2:addChild(cell)
	end
end

local function skillIconSkillTouchCallback(sender, eventType)
	local _self = sender._datas._self
	
	if eventType == ccui.TouchEventType.began then
		
	elseif eventType == ccui.TouchEventType.moved then

	elseif eventType == ccui.TouchEventType.ended then
		state_machine.excute("mythical_animals_skill_icon_cell_select", 0, _self._curSelectMouldId)
	end
end

function MythicalAnimals:updateSkillInfo()
	local info = MythicalAnimalsHandle.getAnimalsSkillInfoById(self._curSelectMouldId)

	local talentMouldId = info.talentMouldId
	local skillNameId = dms.int(dms["talent_mould"], talentMouldId, talent_mould.talent_name)
	local word_info = dms.element(dms["word_mould"], skillNameId)
	local skillName = word_info[3]
	self.Text_skill_name:setString(skillName)

	local desNameId = dms.int(dms["talent_mould"], talentMouldId, talent_mould.talent_describe)
	local word_info = dms.element(dms["word_mould"], desNameId)
	local desName = word_info[3]
	self.Text_skill_info:setString(desName)

	self.Panel_skill_icon:removeAllChildren(true)
	local cell = state_machine.excute("mythical_animals_skill_icon_cell_create", 0, {index = nil, animalsMouldId = self._curSelectMouldId, isCanDrag = false})
	self.Panel_skill_icon._datas = {_self = self}
	self.Panel_skill_icon:setTouchEnabled(true)
	self.Panel_skill_icon:addTouchEventListener(skillIconSkillTouchCallback)
	self.Panel_skill_icon:addChild(cell)
end

-- 界面上红点
function MythicalAnimals:updateUIRedDot()
	self.Image_red_1:setVisible(false)
	self.Image_red_2:setVisible(false)
	self.Image_red_3:setVisible(false)

	-- 连携的红点
	local isShow = MythicalAnimalsHandle.canMythicalAnimalsLeague(self._curSelectMouldId)
	self.Image_red_2:setVisible(isShow)

	local animalsInfo = MythicalAnimalsHandle.getMythicalAnimalsInfoById(self._curSelectMouldId)
	if animalsInfo ~= nil then
		-- 神锻红点
       	isShow = MythicalAnimalsHandle.isShowForgeRedDot(self._curSelectMouldId)
       	self.Image_red_3:setVisible(isShow)

       	-- 解锁红点
       	-- local curStar = MythicalAnimalsHandle.getMythicalAnimalsStarById(self._curSelectMouldId)
	    -- isShow = MythicalAnimalsHandle.canMythicalAnimalsUpStar(self._curSelectMouldId, curStar)
	else
		isShow = MythicalAnimalsHandle.canMythicalAnimalsUpStar(self._curSelectMouldId, 0)
		self.Image_red_1:setVisible(isShow)
	end
end

function MythicalAnimals:onExit()
	-- 释放RoleBiographyWindow界面资源.
	state_machine.remove("mythical_animals_show")
	state_machine.remove("mythical_animals_hide")
	state_machine.remove("mythical_animals_open_up_star")
	state_machine.remove("mythical_animals_activate")
	state_machine.remove("mythical_animals_open_rebirth")
	state_machine.remove("mythical_animals_open_league")
	state_machine.remove("mythical_animals_open_forge")
	state_machine.remove("mythical_animals_refresh_ui")
end

function MythicalAnimals:close()
	-- window event : close.

end

function MythicalAnimals:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
