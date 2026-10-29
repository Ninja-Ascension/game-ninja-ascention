----------------------------------------------------------------------------------------------------
-- 说明：推荐阵容list
-------------------------------------------------------------------------------------------------------
RecommendFormationListCell = class("RecommendFormationListCellClass", Window)

function RecommendFormationListCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self._index = 0
	self._mouldData = nil

	app.load("client.cells.formation.recommend_formation_ship_icon_cell")
	local function init_recommend_formation_list_cell_terminal()
		
	end
	init_recommend_formation_list_cell_terminal()
end

function RecommendFormationListCell:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local panel_level = ccui.Helper:seekWidgetByName(root, "Panel_tuijian")
	panel_level:removeBackGroundImage()
	panel_level:setBackGroundImage(string.format("images/ui/quality/line_%d.png", dms.atoi(self._mouldData,ship_power_rank.camp_level)))
	ccui.Helper:seekWidgetByName(root, "Text_ID"):setString(dms.atos(self._mouldData,ship_power_rank.camp_name))
	ccui.Helper:seekWidgetByName(root, "Text_tishi"):setString(dms.atos(self._mouldData,ship_power_rank.camp_introduce))
	local baseMoulds = {}
	for i=1,6 do
		local ship_mouldId = dms.atoi(self._mouldData,ship_power_rank.camp_level + i)
		local moudId = 0
		if ship_mouldId == 0 then 
			moudId = 0
		else
			moudId = dms.int(dms["ship_mould"],ship_mouldId,ship_mould.base_mould)
		end
		baseMoulds[i] = moudId
	end
	local lights = {false,false,false,false,false,false}

	for i,shipInfo in pairs(_ED.user_ship) do
		local baseId = dms.int(dms["ship_mould"],shipInfo.ship_template_id,ship_mould.base_mould)
		if baseId == baseMoulds[1]  then 
			lights[1] = true
		elseif baseId == baseMoulds[2] then 
			lights[2] = true
		elseif baseId == baseMoulds[3] then 
			lights[3] = true
		elseif baseId == baseMoulds[4] then
			lights[4] = true
		elseif baseId == baseMoulds[5] then 
			lights[5] = true
		elseif baseId == baseMoulds[6] then 			
			lights[6] = true
		end
	end
	for i=1,6 do
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_no_" .. i)
		panel:removeAllChildren(true)
		local cell = RecommendFormationShipIconCell:createCell()
 		cell:init(dms.atoi(self._mouldData,ship_power_rank.camp_level + i),lights[i])
 		panel:addChild(cell)
	end
end

function RecommendFormationListCell:onEnterTransitionFinish()

end

function RecommendFormationListCell:onExit()

end

function RecommendFormationListCell:init(data)
	self._mouldData = data
	local csbItem = csb.createNode("formation/Formation_tuijian.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	self:setContentSize(root:getContentSize())
	table.insert(self.roots, root)
	self:onUpdateDraw()
end

function RecommendFormationListCell:createCell()
	local cell = RecommendFormationListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

