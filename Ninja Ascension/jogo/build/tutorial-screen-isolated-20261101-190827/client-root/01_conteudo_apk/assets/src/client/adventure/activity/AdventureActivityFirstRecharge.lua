----------------------------------------------------------------------------------------------------
-- 说明：首充活动
----------------------------------------------------------------------------------------------------
AdventureActivityFirstRecharge = class("AdventureActivityFirstRechargeClass", Window)
AdventureActivityFirstRecharge.__size = nil

function AdventureActivityFirstRecharge:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.activity = nil
	self.drawType = 0
	self.number = 0
	self.mould = nil
	
	app.load("client.adventure.cells.prop.adventure_new_prop_icon_cell")
	-- Initialize adventure hero icon cell state machine.
	local function init_adventure_activity_cumulative_recruit_terminal()
		
        state_machine.init()
	end

	-- call func init adventure hero icon cell state machine.
	init_adventure_activity_cumulative_recruit_terminal()
end

function AdventureActivityFirstRecharge:updateDraw()

	local root = self.roots[1]
	local Panel_gift_1 = ccui.Helper:seekWidgetByName(root, "Panel_gift_1")
	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name_2")
	local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number_2")
	local Text_info = ccui.Helper:seekWidgetByName(root, "Text_info_2")
	
	Panel_gift_1:removeAllChildren(true)	
	Text_number:setString(""..getResourceValueToStringForAdventure(self.number))
	if self.drawType == 1 then
		local cell = adventureNewPropIconCell:createCell()
		cell:init(0, {resource_type = 1} , 0, 0)
		Panel_gift_1:addChild(cell)
		Text_name:setString(_All_tip_string_info._fundName)
		Text_info:setString(_All_tip_string_info_description._fundNameDescription)
	elseif self.drawType == 2 then
		local cell = adventureNewPropIconCell:createCell()
		cell:init(0, {resource_type = 2} , 0, 0)
		Panel_gift_1:addChild(cell)
		Text_name:setString(_All_tip_string_info._crystalName)
		Text_info:setString(_All_tip_string_info_description._crystalNameDescription)
	elseif self.drawType == 3 then
		local cell = adventureNewPropIconCell:createCell()
		cell:init(0, {resource_type = 3} , 0, 0)
		Panel_gift_1:addChild(cell)
		Text_name:setString(_All_tip_string_info._glories)
		Text_info:setString(_All_tip_string_info_description._gloriesDescription)
	elseif self.drawType == 4 then
		local cell = adventureNewPropIconCell:createCell()
		cell:init(0, {resource_type = 4} , 0, 0)
		Panel_gift_1:addChild(cell)
		Text_name:setString(_All_tip_string_info._reputation)
		Text_info:setString(_All_tip_string_info_description._soulJadeNameDescription)
	elseif self.drawType == 6 then
		local cell = adventureNewPropIconCell:createCell()
		cell:init(0, {mould_id = self.mould.propMould} , 0, 0)
		Panel_gift_1:addChild(cell)
		local datas = dms.element(dms["prop_mould"], self.mould.propMould)
		Text_name:setString(dms.atos(datas, prop_mould.prop_name))
		Text_info:setString(dms.atos(datas, prop_mould.remarks))
	end
	
end

function AdventureActivityFirstRecharge:onInit()
	local root = cacher.createUIRef("list/list_shouchong.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	
	-- Get size for root node.
	if AdventureActivityFirstRecharge.__size == nil then
		local size = root:getContentSize()
		AdventureActivityFirstRecharge.__size = size
	end
	
	self:updateDraw()
end

function AdventureActivityFirstRecharge:onExit()
	cacher.freeRef("list/list_shouchong.csb", self.roots[1])
end

function AdventureActivityFirstRecharge:init(drawType,number,mould)
	self.drawType = drawType
	self.number = number
	self.mould = mould
	-- if drawIndex ~= nil and drawIndex < 8 then
		self:onInit()
	-- end
	
	self:setContentSize(AdventureActivityFirstRecharge.__size)
	return self
end

function AdventureActivityFirstRecharge:reload()
	-- local root = self.roots[1]
	-- if root ~= nil then
	-- 	return
	-- end
	-- self:onInit()
end

function AdventureActivityFirstRecharge:unload()
	-- local root = self.roots[1]
	-- if root == nil then
	-- 	return
	-- end
	-- cacher.freeRef("list/list_shouchong.csb", root)
	-- root:stopAllActions()
	-- root:removeFromParent(false)
	-- self.roots = {}
end

function AdventureActivityFirstRecharge:createCell()
	local cell = AdventureActivityFirstRecharge:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

