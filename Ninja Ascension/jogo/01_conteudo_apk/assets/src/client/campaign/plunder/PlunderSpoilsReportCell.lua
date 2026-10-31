----------------------------------------------------------------------------------------------------
-- 说明：抢夺5次战报列表的条目cell
-------------------------------------------------------------------------------------------------------
PlunderSpoilsReportCell = class("PlunderSpoilsReportCellClass", Window)

function PlunderSpoilsReportCell:ctor()
    self.super:ctor()
	self.roots = {}				-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.config = nil
end

function PlunderSpoilsReportCell:getPropIconCell(mouldId,count)
	app.load("client.cells.prop.model_prop_icon_cell")
	count = count or 1
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig(mouldId, count, true,nil,nil,true)
	cell:init(cellConfig)
	return cell
end

function PlunderSpoilsReportCell:getMoneyCell(mouldId,count,spoilsType)
	app.load("client.cells.prop.model_prop_icon_cell")
	count = count or 1
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig(mouldId, count, true, nil, spoilsType)
	cell:init(cellConfig)
	return cell
end

function PlunderSpoilsReportCell:onUpdateDraw()
	self.timeIndexTxt:setString(string.format(tipStringInfo_plunder[4], self.config.index)) 
	self.expTxt:setString(tostring(self.config.experience)) 
	self.moneyTxt:setString(tostring(self.config.money)) 
	
	local name = ""
	local quality = nil
	local cell = nil
	
	if tonumber(self.config.spoilsType) == 6 then
		cell = self:getPropIconCell(self.config.spoilsMouldId, self.config.spoilsCount)
	elseif tonumber(self.config.spoilsType) == 1 then
		quality = 1
		cell = self:getMoneyCell(self.config.spoilsMouldId, self.config.spoilsCount, self.config.spoilsType)
	else
		quality = 3
		cell = self:getMoneyCell(self.config.spoilsMouldId, self.config.spoilsCount, self.config.spoilsType)
	end
	if cell ~= nil then
		self.spoilsIconPanel:addChild(cell)
	end
	
	if nil == self.config.winMouldId then
		self.winPanel:setVisible(false)
		self.lostTxt:setVisible(true)
	else
		self.winPanel:setVisible(true)
		self.lostTxt:setVisible(false)
		
		name = dms.string(dms["prop_mould"], self.config.winMouldId, prop_mould.prop_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        name = setThePropsIcon(self.config.winMouldId)[2]
		end
		quality = dms.string(dms["prop_mould"], self.config.winMouldId, prop_mould.prop_quality)+1
		if self.goodsTxt ~= nil then
			if nil ~= name then
				self.goodsTxt:setString(name)
			end
			if nil ~= quality then
				self.goodsTxt:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			end
		end
	end
end

function PlunderSpoilsReportCell:onEnterTransitionFinish()
	local csbItem = csb.createNode("campaign/Snatch/snatch_results_list.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	local pc = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_dbzb_list")
	self:setContentSize(pc:getContentSize())

	-- 第几次  
	self.timeIndexTxt = ccui.Helper:seekWidgetByName(self.roots[1], "Text_9")
	
	-- 战利品框
	self.spoilsIconPanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_7")
	
	--遗憾没抢到
	self.lostTxt = ccui.Helper:seekWidgetByName(self.roots[1], "Text_12")
	
	--抢到的panel
	self.winPanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_9")
	
	-- 抢到的物品名
	self.goodsTxt = ccui.Helper:seekWidgetByName(self.roots[1], "Text_10_11_0")
	
	-- 经验
	self.expTxt = ccui.Helper:seekWidgetByName(self.roots[1], "Text_303")
	
	-- 金钱
	self.moneyTxt = ccui.Helper:seekWidgetByName(self.roots[1], "Text_3040")
	
	self:onUpdateDraw()
end

function PlunderSpoilsReportCell:onExit()
	
end

function PlunderSpoilsReportCell:createConfig(winMouldId, 	
												index,		
												experience,
												money, 		
												spoilsMouldId,
												spoilsType, 
												spoilsCount
												)
	-- winMouldId:  如果空,就表示该条显示的是失败信息,否则显示获得的物品名和文字品质
	local data = {}
	data.winMouldId 	= winMouldId or nil
	data.index 			= index or nil
	data.experience 	= experience or nil
	data.money 			= money or nil
	data.spoilsMouldId 	= spoilsMouldId or nil
	data.spoilsType 	= spoilsType or nil
	data.spoilsCount 	= spoilsCount or nil
	return data
end


function PlunderSpoilsReportCell:init(config)
	self.config = config
end

function PlunderSpoilsReportCell:createCell()
	local cell = PlunderSpoilsReportCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end