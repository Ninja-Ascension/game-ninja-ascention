----------------------------------------------------------------------------------------------------
-- 说明：三星扫荡 关卡奖励
-------------------------------------------------------------------------------------------------------
TrialTowerOneKeyFloorListCell = class("TrialTowerOneKeyFloorListCellClass", Window)

function TrialTowerOneKeyFloorListCell:ctor()
    self.super:ctor()
    -- 定义封装类中的变量
	self.roots = {}				-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self._reward = nil --奖励
	self._current_floor = 0 --当前层数
	self._current_index = 0 --第几关
	
end

function TrialTowerOneKeyFloorListCell:onEnterTransitionFinish()
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
	honour:setString("" ..self.honour)
	
	
	-- Text_152_0 银币
	local silver = ccui.Helper:seekWidgetByName(self.roots[1], "Text_152_0")
	silver:setString("" ..self.silver)
	
	
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

function TrialTowerOneKeyFloorListCell:onExit()
	
end

-- 关卡数,荣誉,荣誉暴击,银币,银币暴击
function TrialTowerOneKeyFloorListCell:init(reward,floor,index)
	self._reward = reward
	self._current_index = floor
	self._current_index = index
	self.honour = zstring.tonumber(reward._honour)
	self.honourBaoJi = reward._honour_type
	self.silver = zstring.tonumber(reward._silver)
	self.silverBaoJi = reward._silver_type
	self.level = (floor - 1) * 3 + index
end

function TrialTowerOneKeyFloorListCell:createCell()
	local cell = TrialTowerOneKeyFloorListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end