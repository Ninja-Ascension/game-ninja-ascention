--[[ ----------------------------------------------------------------------------
-- 神兽详情弹窗
--]] ----------------------------------------------------------------------------
MythicalAnimalsTip = class("MythicalAnimalsTipClass", Window)

-- 打开窗口
local mythical_animals_tip_window_open_terminal = {
	_name = "mythical_animals_tip_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("MythicalAnimalsTipClass") then
			local layerOrder = fwin._ui
			-- if params and params.layerOrder then
			-- 	layerOrder = params.layerOrder
			-- end
			fwin:open(MythicalAnimalsTip:new():init(params), layerOrder)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local mythical_animals_tip_window_close_terminal = {
	_name = "mythical_animals_tip_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("MythicalAnimalsTipClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_tip_window_open_terminal)
state_machine.add(mythical_animals_tip_window_close_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsTip:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize lim pool rule page state machine.
	local function init_mythical_animals_tip_terminal()
		-- 打开角色创建窗口
		local mythical_animals_tip_open_terminal = {
			_name = "mythical_animals_tip_open",
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
		local mythical_animals_tip_close_terminal = {
			_name = "mythical_animals_tip_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("mythical_animals_tip_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local mythical_animals_tip_show_terminal = {
			_name = "mythical_animals_tip_show",
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
		local mythical_animals_tip_hide_terminal = {
			_name = "mythical_animals_tip_hide",
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

		state_machine.add(mythical_animals_tip_open_terminal)
		state_machine.add(mythical_animals_tip_close_terminal)
		state_machine.add(mythical_animals_tip_show_terminal)
		state_machine.add(mythical_animals_tip_hide_terminal)
		state_machine.init()
	end
	-- call func init lim pool rule state machine.
	init_mythical_animals_tip_terminal()
end

-- 对象初始化
function MythicalAnimalsTip:init(params)
	self._mouldId = params.mould_id
	self._info = params.info

	local curStar = MythicalAnimalsHandle.getMythicalAnimalsStarById(self._mouldId)
	self._animalStar = curStar
	
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function MythicalAnimalsTip:onUpdateDraw()
	local root = self.roots[1]

	self.Text_animal_name = ccui.Helper:seekWidgetByName(root, "Text_animal_name")
	self.Text_animal_stage = ccui.Helper:seekWidgetByName(root, "Text_animal_stage")

	self.Text_animal_stage_0 = ccui.Helper:seekWidgetByName(root, "Text_animal_stage_0")
	-- 当前碎片
	self.Text_animal_stage_0_0 = ccui.Helper:seekWidgetByName(root, "Text_animal_stage_0_0")
	-- 需要的碎片
	self.Text_animal_stage_0_0_0 = ccui.Helper:seekWidgetByName(root, "Text_animal_stage_0_0_0")
	-- 已装备
	self.Image_equip_done = ccui.Helper:seekWidgetByName(root, "Image_equip_done")
	-- 技能名称
	self.Text_skill_name = ccui.Helper:seekWidgetByName(root, "Text_skill_name")
	-- 技能描述
	self.Text_skill_info = ccui.Helper:seekWidgetByName(root, "Text_skill_info")
	-- 技能icon
	self.Panel_skill_icon = ccui.Helper:seekWidgetByName(root, "Panel_skill_icon")
	-- 属性列表
	self.ListView_info_1 = ccui.Helper:seekWidgetByName(root, "ListView_info_1")
	-- 天赋列表
	self.ListView_info_2 = ccui.Helper:seekWidgetByName(root, "ListView_info_2")
	-- 神兽icon
	self.Panel_skill_icon_0 = ccui.Helper:seekWidgetByName(root, "Panel_skill_icon_0")

	self.Button_equip = ccui.Helper:seekWidgetByName(root, "Button_equip")

	self:updateUI()
end

function MythicalAnimalsTip:updateUI()
	local name = MythicalAnimalsHandle.getAnimalsNameById(self._mouldId)
	self.Text_animal_name:setString(name)

	local info = MythicalAnimalsHandle.getMythicalAnimalsInfoById(self._mouldId)	
	local curStage = 0

	if info ~= nil then
		curStage = MythicalAnimalsHandle.getMythicalAnimalsStageById(self._mouldId)
	end
	self.Text_animal_stage:setString(string.format(tipStringInfo_magical_animals_word[2], curStage))

	self.Image_equip_done:setVisible(false)
	self.Button_equip:setVisible(false)

	self:updateAnimalsIcon()
	self:updateFragmentCount()
	self:updatePropertyList()
	self:updateTalentList()
	self:updateSkillInfo()
end

function MythicalAnimalsTip:updateAnimalsIcon()
	self.Panel_skill_icon_0:removeAllChildren(true)

	-- local propData = {}
	-- propData[1] = 72
	-- propData[2] = self._mouldId
	-- propData[3] = 1
	-- propData[4] = self._animalStar

	-- local cell = DrawHandle.drawIcon(propData)
	local data = dms.element(dms["magical_animals_mould"], self._mouldId)
	local cell = state_machine.excute("mythical_animals_icon_cell_create", 0, {index = nil, data = data, isCanTouch = false})

	self.Panel_skill_icon_0:addChild(cell)
end

-- 更新所需碎片数量
function MythicalAnimalsTip:updateFragmentCount()
	self.Text_animal_stage_0:setVisible(false)
	self.Text_animal_stage_0_0:setVisible(false)
	self.Text_animal_stage_0_0_0:setVisible(false)

	local _, costProp = MythicalAnimalsHandle.canMythicalAnimalsUpStar(self._mouldId, self._animalStar)

	local count_1, count_2 = 0, 0

	if costProp ~= nil then
		count_1 = tonumber(getPropAllCountByMouldId(costProp[2]))
		count_2 = tonumber(costProp[3])

		self.Text_animal_stage_0:setVisible(true)
		self.Text_animal_stage_0_0:setVisible(true)
		self.Text_animal_stage_0_0_0:setVisible(true)
	end

	self.Text_animal_stage_0_0:setString(count_1)
	self.Text_animal_stage_0_0_0:setString("/" .. count_2)
end

function MythicalAnimalsTip:updatePropertyList()
	local ListView_info_1 = self.ListView_info_1
	ListView_info_1:removeAllItems()

	local initProperty = MythicalAnimalsHandle.getAnimalsUpStarPropertyById(self._mouldId, 0)
	local forgeAddProperty = MythicalAnimalsHandle.getAnimalsForgePropertyById(self._mouldId)

	local result = {}
    for k, v in pairs(initProperty) do
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

function MythicalAnimalsTip:updateTalentList()
	local ListView_info_2 = self.ListView_info_2
	ListView_info_2:removeAllItems()

	local talentList = MythicalAnimalsHandle.getAnimalsStageTalentById(self._mouldId)
	local curStage = MythicalAnimalsHandle.getMythicalAnimalsStageById(self._mouldId)
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
		state_machine.excute("mythical_animals_skill_icon_cell_select", 0, _self._mouldId)
	end
end

function MythicalAnimalsTip:updateSkillInfo()
	local info = MythicalAnimalsHandle.getAnimalsSkillInfoById(self._mouldId)

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
	local cell = state_machine.excute("mythical_animals_skill_icon_cell_create", 0, {index = nil, animalsMouldId = self._mouldId, isCanDrag = false})

	self.Panel_skill_icon._datas = {_self = self}
	self.Panel_skill_icon:setTouchEnabled(true)
	self.Panel_skill_icon:addTouchEventListener(skillIconSkillTouchCallback)
	self.Panel_skill_icon:addChild(cell)
end

function MythicalAnimalsTip:onEnterTransitionFinish()
	-- 加载MythicalAnimalsTipWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_info = res/cultivate/Mythical_animals/mythical_animals_info.csb
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_info.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Image_1_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_1_1"), nil,
	{
		terminal_name = "mythical_animals_tip_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 去获取
	self.Button_equip = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_equip"), nil,
	{
		terminal_name = "",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self.Button_equip:setVisible(false)
	

	self:onUpdateDraw()
end

function MythicalAnimalsTip:onExit()
	-- 释放MythicalAnimalsTipWindow界面资源.
	state_machine.remove("mythical_animals_tip_open")
	state_machine.remove("mythical_animals_tip_close")
	state_machine.remove("mythical_animals_tip_show")
	state_machine.remove("mythical_animals_tip_hide")
end

function MythicalAnimalsTip:close()
	-- window event : close.
	
end

function MythicalAnimalsTip:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
