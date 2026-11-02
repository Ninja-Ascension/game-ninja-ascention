-- ----------------------------------------------------------------------------------------------------
-- 说明：单个列表推荐阵容
-------------------------------------------------------------------------------------------------------

RecommendFormationList = class("RecommendFormationListClass", Window)
   
function RecommendFormationList:ctor()
    self.super:ctor()
	self.roots = {}
	self.pageIndex = 0
	app.load("client.cells.formation.recommend_formation_list_cell") 
    -- Initialize Home page state machine.
    local function init_recommend_formation_list_terminal()
    end
    
    init_recommend_formation_list_terminal()
end

function RecommendFormationList:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	listView:removeAllItems()
	local moulds = dms.searchs(dms["ship_power_rank"], ship_power_rank.camp,self.pageIndex) 
	for k,v in pairs(moulds) do
		local cell = RecommendFormationListCell:createCell()
		cell:init(v)
		listView:addChild(cell)
	end
end

function RecommendFormationList:onEnterTransitionFinish()

end

function RecommendFormationList:onExit()
end

function RecommendFormationList:init(index)
	self.roots = {}
	self.pageIndex = index
    local csbEquipInformation = csb.createNode("formation/Formation_tuijian_list.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)
	self:setContentSize(root:getContentSize())
	self:onUpdateDraw()
end
