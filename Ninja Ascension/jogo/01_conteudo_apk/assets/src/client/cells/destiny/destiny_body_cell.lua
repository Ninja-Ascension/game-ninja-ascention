----------------------------------------------------------------------------------------------------
-- 说明：天命的全身图绘制
-------------------------------------------------------------------------------------------------------
DestinyBodyCell = class("DestinyBodyCellClass", Window)

function DestinyBodyCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.mouldIndex = 0
	self.pageData = nil
	self._cellQueue = nil
end



function DestinyBodyCell:onUpdate(dt)
	--> print("DestinyBodyCell----------------")

end

function DestinyBodyCell:onUpdateDraw()
	for i = 1, #self.pageData do
		local cell = self:createIconCell()
		cell:init(self.pageData[i][1])
		local pname = string.format("Panel_sgz_mx_%d"..i, self.layout_index)
		ccui.Helper:seekWidgetByName(self.roots[1], pname):addChild(cell)
		if i == #self.pageData then
			cell:setEnd(true)
		end
	end
end

-- 传递该页需要显示的模板数据内容数组
function DestinyBodyCell:updateCreateNode(table_pageData)
	local oldroot = self.roots[1]
	if oldroot then
		oldroot:removeFromParent(true)
	end
	self.pageData = table_pageData
	
	self.mouldIndex = dms.int(table_pageData, 1, destiny_mould.pic_index)
	self.page_index = dms.int(table_pageData, 1, destiny_mould.page_index)
	self.layout_index = dms.int(dms["destiny_mould_layout"],self.page_index, destiny_mould_layout.layout_index) 
	
	local csbItem =  csb.createNode(string.format("destiny/destiny_page_%d.csb", self.layout_index))
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
end

function DestinyBodyCell:onEnterTransitionFinish()	
	
end

function DestinyBodyCell:onExit()

end

function DestinyBodyCell:createIconCell()
	app.load("client.cells.destiny.destiny_body_icon_cell")
	local cell = DestinyBodyIconCell:createCell()
	return cell
end

function DestinyBodyCell:setCreateNode()

end

function DestinyBodyCell:createCell()
	local cell = DestinyBodyCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

