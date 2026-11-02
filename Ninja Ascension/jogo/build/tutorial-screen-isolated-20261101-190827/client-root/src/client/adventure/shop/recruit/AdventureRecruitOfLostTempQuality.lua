----------------------------------------------------------------------------------------------------
-- 说明：神殿的品质列表控件
----------------------------------------------------------------------------------------------------
AdventureRecruitOfLostTempQuality = class("AdventureRecruitOfLostTempQualityClass", Window)
AdventureRecruitOfLostTempQuality.__size = nil

function AdventureRecruitOfLostTempQuality:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.data = nil
	
	-- Initialize adventure hero list cell state machine.
	local function init_adventure_recruit_of_lost_temp_hero_list_terminal()
		
		
        state_machine.init()
	end

	-- call func init adventure hero list cell state machine.
	init_adventure_recruit_of_lost_temp_hero_list_terminal()
end

function AdventureRecruitOfLostTempQuality:updateDraw()
	local root = self.roots[1]
	local shipData = dms.element(dms["ship_mould"], self.data.exchange_id)
	ccui.Helper:seekWidgetByName(root, "Text_pingzhi"):setString(_hero_quality_name[dms.atoi(shipData, ship_mould.ship_type)+1])
end

function AdventureRecruitOfLostTempQuality:onInit()
	self.roots = {}
	local root = cacher.createUIRef("shop/heroshop/heroshop_shendian_1.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

	-- Get size for root node.
	if AdventureRecruitOfLostTempQuality.__size == nil then
		local size = root:getContentSize()
		AdventureRecruitOfLostTempQuality.__size = size
	end

	self:updateDraw()
end

function AdventureRecruitOfLostTempQuality:onExit()
	cacher.freeRef("shop/heroshop/heroshop_shendian_1.csb", self.roots[1])
end

function AdventureRecruitOfLostTempQuality:init(qualityData)
	self.data = qualityData
	-- if drawIndex ~= nil and drawIndex < 8 then
		self:onInit()
	-- end

	self:setContentSize(AdventureRecruitOfLostTempQuality.__size)
	return self
end

function AdventureRecruitOfLostTempQuality:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureRecruitOfLostTempQuality:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("shop/heroshop/heroshop_shendian_1.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureRecruitOfLostTempQuality:createCell()
	local cell = AdventureRecruitOfLostTempQuality:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

