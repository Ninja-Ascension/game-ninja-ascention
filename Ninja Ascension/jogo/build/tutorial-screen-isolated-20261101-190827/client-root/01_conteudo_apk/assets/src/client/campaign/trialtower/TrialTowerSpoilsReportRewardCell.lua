----------------------------------------------------------------------------------------------------
-- 说明：三国无双扫荡 通关奖励 战报列表的条目cell
-------------------------------------------------------------------------------------------------------
TrialTowerSpoilsReportRewardCell = class("TrialTowerSpoilsReportRewardCellClass", Window)

function TrialTowerSpoilsReportRewardCell:ctor()
    self.super:ctor()
    -- 定义封装类中的变量
	self.roots = {}				-- 界面中的UI根节点，供模块获取界面中的UI元素实例	
end


--道具
function TrialTowerSpoilsReportRewardCell:getPropCell(mid, count,mtype)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = mid
	cellConfig.count = count
	cellConfig.isShowName = true
	cellConfig.isDebris = true
	cellConfig.mouldType = mtype
	cell:init(cellConfig)
	return cell
end


-- 更新画面
function TrialTowerSpoilsReportRewardCell:onUpdateDraw()
	
end

function TrialTowerSpoilsReportRewardCell:onEnterTransitionFinish()
	local csbItem = csb.createNode("campaign/TrialTower/trial_tower_raids_list_1.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	local pc = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_206")
	self:setContentSize(pc:getContentSize())
	
	local panelList = {
		"Panel_345",
		"Panel_346",
	}
	
	local num = math.min(table.getn(panelList), table.getn(self.list))
	 
	for i = 1 , num do
		local cell = self:getPropCell(self.list[i].mid, self.list[i].count, self.list[i].mouldType)
		ccui.Helper:seekWidgetByName(self.roots[1], panelList[i]):addChild(cell)
	end
	--扫荡之后值不正确
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b  
		then 
		--显示宝箱关卡修改
		local counts = zstring.tonumber(self.endlevel) - zstring.tonumber(self.level)
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_287"):setString(string.format(tipStringInfo_trialTower[31],self.level,self.endlevel-1,counts*3))
	else
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_287"):setString(string.format(tipStringInfo_trialTower[27],self.level+1,self.endlevel+1))	
	end
	
end

function TrialTowerSpoilsReportRewardCell:onExit()
	
end


--list.mid
--list.count
--list.mouldType
function TrialTowerSpoilsReportRewardCell:init(level, list, endlevel)
	self.level = level
	self.list = list
	self.endlevel = endlevel
end

function TrialTowerSpoilsReportRewardCell:createCell()
	local cell = TrialTowerSpoilsReportRewardCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end