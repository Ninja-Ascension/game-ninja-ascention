---------------------------------
---说明：武将仓库分割线
-- 创建时间:2017.07.12
-- 作者：李文鋆
-- 修改记录：
-- 最后修改人：
---------------------------------
SmShipDividingLine = class("SmShipDividingLineClass", Window)
SmShipDividingLine.__size = nil
function SmShipDividingLine:ctor()
    self.super:ctor()
	
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
end

function SmShipDividingLine:onEnterTransitionFinish()

end

function SmShipDividingLine:onInit()
	local root = cacher.createUIRef("packs/HeroStorage/sm_list_separate.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if SmShipDividingLine.__size == nil then
 		SmShipDividingLine.__size = root:getContentSize()
 	end
end

function SmShipDividingLine:close( ... )

end

function SmShipDividingLine:onExit()
	local root = self.roots[1]
	if root ~= nil then
		cacher.freeRef("packs/HeroStorage/sm_list_separate.csb", self.roots[1])
	end
end

function SmShipDividingLine:init()
	self:onInit()
	self:setContentSize(SmShipDividingLine.__size)
	return self
end

function SmShipDividingLine:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SmShipDividingLine:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("packs/HeroStorage/sm_list_separate.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:removeFromParent(false)
	self.roots = {}
	self.csbHeroSell = nil
end

function SmShipDividingLine:createCell()
	local cell = SmShipDividingLine:new()
	cell:registerOnNodeEvent(cell)
	return cell
end