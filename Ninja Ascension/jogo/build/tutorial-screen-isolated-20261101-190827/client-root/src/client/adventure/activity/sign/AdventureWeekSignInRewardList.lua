-- ----------------------------------------------------------------------------------------------------
-- 说明：本周的奖励列表
-------------------------------------------------------------------------------------------------------
AdventureWeekSignInRewardList = class("AdventureWeekSignInRewardListClass", Window)
    
function AdventureWeekSignInRewardList:ctor()
    self.super:ctor()
	self.roots = {}
	self.rewardData = nil
    -- Initialize adventure daily sign in state machine.
	app.load("client.adventure.cells.prop.adventure_new_prop_small_icon_cell")
    local function init_adventure_daily_sign_in_terminal()
		
        state_machine.init()
    end
    
    -- call func init adventure daily sign in state machine.
    init_adventure_daily_sign_in_terminal()
end

function AdventureWeekSignInRewardList:init(reward)
	self.rewardData = reward
    return self
end

function AdventureWeekSignInRewardList:onEnterTransitionFinish()
    local csbAdventureWeekSignInReward = csb.createNode("list/list_sign_week.csb")
    local root = csbAdventureWeekSignInReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureWeekSignInReward)
	
	local size = root:getContentSize()

	self:setContentSize(root:getContentSize())
	local isReceive = zstring.split(self.rewardData.activityInfo_isReward,",")
	local Text_date = ccui.Helper:seekWidgetByName(root, "Text_date")
	local times = zstring.split(self.rewardData.activityInfo_name,"-")
	Text_date:setString(times[2]..tipStringInfo_time_info[2]..times[3]..tipStringInfo_time_info[10])
 
		-- 类型
	-- 1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:经验 9:耐力 10:功能点 11:上阵人数 12:体力 
	-- 13:武将 14竞技场排名 15:伤害 16:比武积分 17:霸气 18 威名 19 日常任务积分 20功勋 
	-- 21战功 22日常副本基础奖励 23日常副本额外奖励 24出击令 25免战时间 26 战力
	for i ,w in pairs(self.rewardData.activityInfo_prop_info) do 
		local cellOne = adventureNewSmallPropIconCell:createCell()
		local Panel_reward = ccui.Helper:seekWidgetByName(root, "Panel_reward_"..i)
		Panel_reward:removeAllChildren(true)
		if zstring.tonumber(w.propIcon) == 1 then
			cellOne:init(7, {resource_type = 1} , "" .. getResourceValueToStringForAdventure(w.propMouldCount), nil, 0, 0)
			Panel_reward:addChild(cellOne)
		elseif zstring.tonumber(w.propIcon) == 2 then
			cellOne:init(7, {resource_type = 2} , "" .. getResourceValueToStringForAdventure(w.propMouldCount), nil, 0, 0)
			Panel_reward:addChild(cellOne)
		elseif zstring.tonumber(w.propIcon) == 3 then
			cellOne:init(7, {resource_type = 3} , "" .. getResourceValueToStringForAdventure(w.propMouldCount), nil, 0, 0)
			Panel_reward:addChild(cellOne)
		elseif zstring.tonumber(w.propIcon) == 4 then
			cellOne:init(7, {resource_type = 4} , "" .. getResourceValueToStringForAdventure(w.propMouldCount), nil, 0, 0)
			Panel_reward:addChild(cellOne)
		elseif zstring.tonumber(w.propIcon) == 6 then
			cellOne:init(7, {mould_id = w.propMould} ,"" .. getResourceValueToStringForAdventure(w.propMouldCount),nil,0,0)
			Panel_reward:addChild(cellOne)
		end
		if zstring.tonumber(isReceive[i]) > 0 then
			local ball = cc.Sprite:create("images/ui/icon/button_decide_yes.png")
			ball:setAnchorPoint(cc.p(0.5, 0.5))
			ball:setPosition(cc.p(cellOne:getContentSize().width-ball:getContentSize().width*0.5, cellOne:getContentSize().height-ball:getContentSize().height*0.5))
			cellOne:addChild(ball)
			cellOne._nodeChild = ball
		else
			cellOne:removeChild(cellOne._nodeChild, true)
			cellOne._nodeChild = nil
		end
	end 
	
	
	
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureWeekSignInRewardListClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureWeekSignInRewardList:onExit()
	state_machine.remove("everyday_sign_in_button")
end

function AdventureWeekSignInRewardList:createCell()
	local cell = AdventureWeekSignInRewardList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end