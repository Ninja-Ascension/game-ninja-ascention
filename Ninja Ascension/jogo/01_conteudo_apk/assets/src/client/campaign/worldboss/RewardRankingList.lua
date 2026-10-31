-- ----------------------------------------------------------------------------------------------------
-- 说明：奖励排行榜list
-- 创建时间	2015-03-06
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

RewardRankingList = class("RewardRankingListClass", Window)
    
function RewardRankingList:ctor()
    self.super:ctor()
	self.roots = {}
	self.myIndex = 0
    local function init_world_boss_terminal()
		
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_world_boss_terminal()
end

function RewardRankingList:onUpdateDraw()
	local root = self.roots[1]
	local ImageBgOne = ccui.Helper:seekWidgetByName(root, "Image_13_6")
	local ImageBgTwo = ccui.Helper:seekWidgetByName(root, "Image_13_6_0")
	local minRanking = dms.string(dms["rebel_army_order_reward"],self.myIndex,rebel_army_order_reward.min_ranking)	--最低排名
	local maxRanking = dms.string(dms["rebel_army_order_reward"],self.myIndex,rebel_army_order_reward.max_ranking)	--最高排名
	local damageReward = dms.string(dms["rebel_army_order_reward"],self.myIndex,rebel_army_order_reward.damage_reward)	--伤害排名奖励
	local exploitsReward = dms.string(dms["rebel_army_order_reward"],self.myIndex,rebel_army_order_reward.exploits_reward)	--战功排名奖励

	if tonumber(self.myIndex)%2 == 0 then
		ImageBgOne:setVisible(true)
		ImageBgTwo:setVisible(false)
	else
		ImageBgOne:setVisible(false)
		ImageBgTwo:setVisible(true)
	end
	
	local interval = ccui.Helper:seekWidgetByName(root, "Text_17_0")
	local exploit = ccui.Helper:seekWidgetByName(root, "Text_19_0")
	local hurt = ccui.Helper:seekWidgetByName(root, "Text_21_0")
	if tonumber(minRanking) == tonumber (maxRanking) then
		interval:setString(_string_piece_info[330]..maxRanking.._string_piece_info[331])
	else
		interval:setString(_string_piece_info[330]..minRanking.."-"..maxRanking.._string_piece_info[331])
	end
	exploit:setString(_string_piece_info[332]..exploitsReward)
	hurt:setString(_string_piece_info[332]..damageReward)
end

function RewardRankingList:onEnterTransitionFinish()
	
	local csbRewardRankingListFriend = csb.createNode("campaign/WorldBoss/worldBoss_ranking_list_1.csb")
	self:addChild(csbRewardRankingListFriend)
	local root = csbRewardRankingListFriend:getChildByName("root")
	self:setContentSize(root:getChildByName("Panel_3"):getContentSize())
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
end

function RewardRankingList:onExit()
	-- state_machine.remove("button_add_friend")
end

function RewardRankingList:init(myIndex)
	self.myIndex = myIndex
end

function RewardRankingList:createCell()
	local cell = RewardRankingList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end