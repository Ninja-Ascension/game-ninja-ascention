----------------------------------------------------------------------------------------------------
-- 说明：合体技能的武将cell
----------------------------------------------------------------------------------------------------
AdventureSkillFitCell = class("AdventureSkillFitCellClass", Window)
AdventureSkillFitCell.__size = nil

function AdventureSkillFitCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.current_type = 0
	self.enum_type = {
		_TYPE_NORMAL = 0,					-- 静态的UI显示
	}
	self.drawShowType = 0
	self.drawSkillType = 0
	self.size = 0
	-- Initialize adventure hero icon cell state machine.
	local function init_adventure_skill_fit_cell_terminal()

        state_machine.init()
	end

	-- call func init adventure hero icon cell state machine.
	init_adventure_skill_fit_cell_terminal()
end

function AdventureSkillFitCell:onInit()
	local root = cacher.createUIRef("utils/skill_tips_hero.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	
	local Panel_role_di = ccui.Helper:seekWidgetByName(root, "Panel_role_di")
	local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
	Panel_role_di:removeBackGroundImage()
	Panel_role:removeBackGroundImage()
	local quality = dms.atoi(self.mould_data, ship_mould.ship_type)
	if quality == nil then
		print("AdventureHeroIconCell@onEnterTransitionFinish()", "hero mould_data ship_mould.ship_type is nil.")
		return
	end
	local qualityImage = string.format("images/ui/quality/icon_prop_%d.png", quality+1)
	Panel_role_di:setBackGroundImage(qualityImage)
	local picIndex = dms.atos(self.mould_data, ship_mould.head_icon)
	Panel_role:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(picIndex)))
	
	local Text_role_name = ccui.Helper:seekWidgetByName(root, "Text_role_name")
	Text_role_name:setString(dms.atos(self.mould_data, ship_mould.captain_name).."x1")
	
	local isRecruit, isBattle = getShipAccessInfoAdventure(self.hero.ship_template_id)
	if isRecruit == true and isBattle == true then
		ccui.Helper:seekWidgetByName(root, "Image_red"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_green"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_yellow"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Text_zhaomu_no"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Text_shangzhen_no"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Text_shangzhen_yes"):setVisible(true)
	elseif isRecruit == true and isBattle == false then
		ccui.Helper:seekWidgetByName(root, "Image_red"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_green"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_yellow"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_zhaomu_no"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Text_shangzhen_no"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_shangzhen_yes"):setVisible(false)
	elseif isRecruit == false and isBattle == false then	
		ccui.Helper:seekWidgetByName(root, "Image_red"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_green"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_yellow"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Text_zhaomu_no"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_shangzhen_no"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Text_shangzhen_yes"):setVisible(false)
	end
	
	if AdventureSkillFitCell.__size == nil then
		local size = root:getContentSize()
		AdventureSkillFitCell.__size = size
	end
end

function AdventureSkillFitCell:onExit()
	local root =  self.roots[1]
	root:stopAllActions()

	cacher.freeRef("utils/skill_tips_hero.csb", self.roots[1])
end

-- /**
-- */
function AdventureSkillFitCell:init(interfaceType, hero,drawIndex)
	self.current_type = interfaceType
	self.hero = hero
	self.mould_data = hero.mould_data or dms.element(dms["ship_mould"], self.hero.ship_template_id)
	if drawIndex ~= nil and drawIndex < 45 then
		self:onInit()
	end
	
	self:setContentSize(AdventureSkillFitCell.__size)
	return self
end

function AdventureSkillFitCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureSkillFitCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("utils/skill_tips_hero.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureSkillFitCell:createCell()
	local cell = AdventureSkillFitCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

