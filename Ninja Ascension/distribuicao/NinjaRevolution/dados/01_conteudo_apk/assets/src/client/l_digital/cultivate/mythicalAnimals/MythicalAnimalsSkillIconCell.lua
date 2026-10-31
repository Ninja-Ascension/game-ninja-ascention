--[[ ----------------------------------------------------------------------------
-- 神兽技能icon cell
--]] ----------------------------------------------------------------------------
MythicalAnimalsSkillIconCell = class("MythicalAnimalsSkillIconCellClass", Window)
MythicalAnimalsSkillIconCell.__size = nil

-- 创建Cell实例
local mythical_animals_skill_icon_cell_create_terminal = {
	_name = "mythical_animals_skill_icon_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if MythicalAnimalsSkillIconCell then
			local cell = MythicalAnimalsSkillIconCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_skill_icon_cell_create_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsSkillIconCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._deltaTime = 0.5
	self._startTime = 0

	-- load lua files.

	-- Initialize ninja biographies0 cell page state machine.
	local function init_mythical_animals_skill_icon_cell_terminal()
		local mythical_animals_skill_icon_cell_select_terminal = {
			_name = "mythical_animals_skill_icon_cell_select",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if params ~= nil then
					local animalsMouldId = params
					state_machine.excute("mythical_animals_skill_tip_window_open", 0, animalsMouldId)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		local mythical_animals_skill_icon_cell_open_set_skill_window_terminal = {
			_name = "mythical_animals_skill_icon_cell_open_set_skill_window",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("mythical_animals_skill_window_open", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(mythical_animals_skill_icon_cell_select_terminal)
		state_machine.add(mythical_animals_skill_icon_cell_open_set_skill_window_terminal)
	end
	-- call func init ninja biographies0 cell state machine.
	init_mythical_animals_skill_icon_cell_terminal()
end

-- 对象初始化
function MythicalAnimalsSkillIconCell:init(params)
	self._index = params.index
	self._animalsMouldId = params.animalsMouldId
	self._isCanDrag = true

	if params.isCanDrag ~= nil then
		self._isCanDrag = params.isCanDrag
	end

	self:onInit(params)
	
	self:setContentSize(MythicalAnimalsSkillIconCell.__size)
	return self
end

function MythicalAnimalsSkillIconCell:onUpdateDraw()
	local root = self.roots[1]

	self.Panel_animals_prop_box = ccui.Helper:seekWidgetByName(root, "Panel_animals_prop_box")
	self.Panel_animals_prop_box:setTouchEnabled(false)
	fwin:removeTouchEventListener(self.Panel_animals_prop_box)

	local _self = self

	local function skillIconSetSkillTouchCallback(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			
		elseif eventType == ccui.TouchEventType.moved then

		elseif eventType == ccui.TouchEventType.ended then
			state_machine.excute("mythical_animals_skill_icon_cell_open_set_skill_window", 0, nil)
		end
	end

	if self._animalsMouldId == -1 then
		self.Panel_animals_prop_box:setTouchEnabled(true)
		self.Panel_animals_prop_box:addTouchEventListener(skillIconSetSkillTouchCallback)
	end

	-- 技能图标
	self.Panel_skill = ccui.Helper:seekWidgetByName(root, "Panel_skill")
	-- 品质
	self.Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	-- 消耗点数
	self.Text_num = ccui.Helper:seekWidgetByName(root, "Text_num")

	self.Image_exchange = ccui.Helper:seekWidgetByName(root, "Image_exchange")

	self.Image_equip = ccui.Helper:seekWidgetByName(root, "Image_equip")

	self.Image_add = ccui.Helper:seekWidgetByName(root, "Image_add")

	self.Image_cost = ccui.Helper:seekWidgetByName(root, "Image_cost")
	

	self:updateUI()
end

function MythicalAnimalsSkillIconCell:judgeChangeSkill(skillPanel, newObject)
	local changeIndex = nil

    local worldMenuP = fwin:convertToWorldSpace(newObject, cc.p(0, 0))
    local rect4 = {}
    rect4.x = worldMenuP.x
    rect4.y = worldMenuP.y
    rect4.width = MythicalAnimalsSkillIconCell.__size.width
    rect4.height = MythicalAnimalsSkillIconCell.__size.height

    for i, v in ipairs(skillPanel) do
    	local rect3 = {}
		local worldvp = fwin:convertToWorldSpace(v, cc.p(0, 0))
		rect3.x = worldvp.x
		rect3.y = worldvp.y
		rect3.width = MythicalAnimalsSkillIconCell.__size.width
		rect3.height = MythicalAnimalsSkillIconCell.__size.height

		if cc.rectIntersectsRect(rect3, rect4) == true then


			changeIndex = i
			break
		end
    end

	return changeIndex
end

function MythicalAnimalsSkillIconCell:updateUI()
	local Panel_skill = self.Panel_skill
	Panel_skill:removeAllChildren(true)

	if self._animalsMouldId == -1 then
		self.Image_add:setVisible(true)
	else
		local info = MythicalAnimalsHandle.getAnimalsSkillInfoById(self._animalsMouldId)

		local talentMouldId = info.talentMouldId
		local coolRound = info.coolRound
		local needAnger = info.needAnger

		--天赋模板id
		local pic_index = dms.int(dms["talent_mould"], talentMouldId, talent_mould.new_skill_pic)
		local skill_icon = cc.Sprite:create(string.format("images/ui/skills/skills_%d.png", pic_index))
		skill_icon:setPosition(cc.p(Panel_skill:getContentSize().width/2, Panel_skill:getContentSize().height/2))
		Panel_skill:addChild(skill_icon)

		self.Text_num:setString(needAnger)
		self.Text_num:setVisible(true)
		self.Image_cost:setVisible(true)
	end
end

function MythicalAnimalsSkillIconCell:onInit(params)
	-- 加载MythicalAnimalsSkillIconCellWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_skill_item = res/cultivate/Mythical_animals/mythical_animals_skill_item.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_skill_item.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/Mythical_animals/mythical_animals_skill_item.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if MythicalAnimalsSkillIconCell.__size == nil then
		MythicalAnimalsSkillIconCell.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function MythicalAnimalsSkillIconCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Panel_skill = ccui.Helper:seekWidgetByName(root, "Panel_skill")
	self.Panel_skill:removeAllChildren(true)

	self.Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	self.Panel_kuang:removeAllChildren(true)
	
	self.Text_num = ccui.Helper:seekWidgetByName(root, "Text_num")
	self.Text_num:setString("")

	self.Image_exchange = ccui.Helper:seekWidgetByName(root, "Image_exchange")
	self.Image_exchange:setVisible(false)

	self.Image_equip = ccui.Helper:seekWidgetByName(root, "Image_equip")
	self.Image_equip:setVisible(false)

	self.Image_add = ccui.Helper:seekWidgetByName(root, "Image_add")
	self.Image_add:setVisible(false)
end

function MythicalAnimalsSkillIconCell:onExit()
	-- 释放MythicalAnimalsSkillIconCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_skill_item.csb", root)
	-- ]]
end

function MythicalAnimalsSkillIconCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function MythicalAnimalsSkillIconCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_skill_item.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
