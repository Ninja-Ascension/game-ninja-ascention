----------------------------------------------------------------------------------------------------
-- 说明：小伙伴装备位置的开启状态绘制
-------------------------------------------------------------------------------------------------------
PartnerOpenStatusCell = class("PartnerOpenStatusCellClass", Window)

function PartnerOpenStatusCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.data = {}		-- 根据不同的界面提供相应的逻辑数据
end

function PartnerOpenStatusCell:onUpdateDraw()
	
end

function PartnerOpenStatusCell:onEnterTransitionFinish()
	local filePath = "icon/box_add.csb"
	local csbItem = csb.createNode(filePath)
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	self:onUpdateDraw()
end

function PartnerOpenStatusCell:onExit()
end

function PartnerOpenStatusCell:init(data)
	self.data = data
end

function PartnerOpenStatusCell:createCell()
	local cell = PartnerOpenStatusCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

