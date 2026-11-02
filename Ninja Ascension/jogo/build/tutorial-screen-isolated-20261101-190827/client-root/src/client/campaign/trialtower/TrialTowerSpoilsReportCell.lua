----------------------------------------------------------------------------------------------------
-- 说明：三国无双扫荡 战报列表的条目cell
-------------------------------------------------------------------------------------------------------
TrialTowerSpoilsReportCell = class("TrialTowerSpoilsReportCellClass", Window)

function TrialTowerSpoilsReportCell:ctor()
    self.super:ctor()
    -- 定义封装类中的变量
	self.roots = {}				-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	
end

function TrialTowerSpoilsReportCell:onEnterTransitionFinish()
	local csbItem = csb.createNode("campaign/TrialTower/trial_tower_raids_list.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	local pc = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_2")
	self:setContentSize(pc:getContentSize())

	
	-- Text_289 第x关
	local level = ccui.Helper:seekWidgetByName(self.roots[1], "Text_289")
	level:setString(string.format(tipStringInfo_trialTower[8],self.level))
	
	
	-- Text_062_0 威望
	local honour = ccui.Helper:seekWidgetByName(self.roots[1], "Text_062_0")
	honour:setString(self.honour)
	
	
	-- Text_152_0 银币
	local silver = ccui.Helper:seekWidgetByName(self.roots[1], "Text_152_0")
	silver:setString(self.silver)
	
	
	-- Text_6 威望暴击
	local honourBaoJi = ccui.Helper:seekWidgetByName(self.roots[1], "Text_6")
	
	
	-- Text_6_0 银币暴击
	local silverBaoJi = ccui.Helper:seekWidgetByName(self.roots[1], "Text_6_0")
	
	
	if nil ~= self.silverBaoJi and self.silverBaoJi > 0 then 
		silverBaoJi:setColor(cc.c3b(
			tipStringInfo_trialTower_multiplying_color[self.silverBaoJi][1], 
			tipStringInfo_trialTower_multiplying_color[self.silverBaoJi][2], 
			tipStringInfo_trialTower_multiplying_color[self.silverBaoJi][3])
		)
		silverBaoJi:setString(tipStringInfo_trialTower_multiplying[self.silverBaoJi])
	end
	
	if nil ~= self.honourBaoJi and self.honourBaoJi > 0 then 
		honourBaoJi:setColor(cc.c3b(
			tipStringInfo_trialTower_multiplying_color[self.honourBaoJi][1], 
			tipStringInfo_trialTower_multiplying_color[self.honourBaoJi][2], 
			tipStringInfo_trialTower_multiplying_color[self.honourBaoJi][3])
		)
		honourBaoJi:setString(tipStringInfo_trialTower_multiplying[self.honourBaoJi])
	end
			

end

function TrialTowerSpoilsReportCell:onExit()
	
end

-- 关卡数,荣誉,荣誉暴击,银币,银币暴击
function TrialTowerSpoilsReportCell:init(level,honour,honourBaoJi, silver, silverBaoJi)
	self.honour = honour
	self.honourBaoJi = honourBaoJi
	self.silver = silver
	self.silverBaoJi = silverBaoJi
	-- 一件三星奖励界面 关卡数 错误，都少1 舰娘 也有相同错误，所以不做版本控制
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then 
		self.level = level --已经是计算过的值
	else
		self.level = level + 1
	end
	
end

function TrialTowerSpoilsReportCell:createCell()
	local cell = TrialTowerSpoilsReportCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end