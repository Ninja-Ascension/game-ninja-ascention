--------------------------------------------------------------------------------------------------------------
--  说明：个人排行奖励单个控件
--------------------------------------------------------------------------------------------------------------
WorldBossRewardRankCell = class("WorldBossRewardRankCellClass", Window)
WorldBossRewardRankCell.__size = nil

--创建个人排行奖励cell
local world_boss_reward_rank_cell_terminal = {
    _name = "world_boss_reward_rank_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = WorldBossRewardRankCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(world_boss_reward_rank_cell_terminal)
state_machine.init()

function WorldBossRewardRankCell:ctor()
    self.super:ctor()
    self.roots = {}
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.equip.equip_icon_cell")
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.shop.recharge.RechargeDialog")
    app.load("client.reward.DrawRareReward")
    app.load("client.cells.prop.prop_money_icon")

end
--绘制逻辑处理
function WorldBossRewardRankCell:updateDraw()
    local root = self.roots[1]
    self.reworld_sorting = {}
    local Text_jjc_ph_st = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_st")--排名文本
    local Panel_jjc_ph_st = ccui.Helper:seekWidgetByName(root, "Panel_jjc_ph_st") --排名文本背景

    local ListView_boss_challenge_reward = ccui.Helper:seekWidgetByName(root, "ListView_boss_challenge_reward")
    local rewards = self.data.rewards
    local index = 1
    ListView_boss_challenge_reward:removeAllItems()
    for i, reward in ipairs(rewards) do
        local rewardType = zstring.tonumber(reward[1])
        local cell = ResourcesIconCell:createCell()
        if 13 == rewardType then
            local table = {}
            if reward[4] ~= nil and tonumber(reward[4]) ~= -1 then
                table.shipStar = tonumber(reward[4])
            end
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1,table)
        else
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1)
        end
        local rewardinfo = {}
        rewardinfo.type = rewardType
        rewardinfo.id = reward[2]
        rewardinfo.number = tonumber(reward[3])
        self.reworld_sorting[index] = rewardinfo
        index = index + 1
        ListView_boss_challenge_reward:addChild(cell)
    end
    local rank_str = ""..self.data.min
    if self.data.min ~= self.data.max then
        rank_str =  self.data.min.."-"..self.data.max
    end
    local min = tonumber(self.data.min)
    if min==1 or  min == 2 or  min == 3 then --第1/2/3名
        Panel_jjc_ph_st:setVisible(true)
        Panel_jjc_ph_st:setBackGroundImage("images/ui/play/arena/jjc_phb_pic_"..self.data.min..".png")
        Text_jjc_ph_st:setVisible(false)
    elseif min==666666  then --惊喜大奖
        Panel_jjc_ph_st:setVisible(true)
        Panel_jjc_ph_st:setBackGroundImage("images/ui/text/boss/bar_jingxidajiang.png")
        Text_jjc_ph_st:setVisible(false)
    elseif min==777777 then --最后一刀
        Panel_jjc_ph_st:setVisible(true)
        Panel_jjc_ph_st:setBackGroundImage("images/ui/text/boss/bar_zuihouyiji.png")
        Text_jjc_ph_st:setVisible(false)
    else
        Panel_jjc_ph_st:setVisible(false)
        Text_jjc_ph_st:setVisible(true)
        Text_jjc_ph_st:setString(rank_str)
    end
    -- DSC重塑
	if __lua_project_id == __lua_project_l_digital then 
		for i = 1,3 do 
			local Image_ranking = ccui.Helper:seekWidgetByName(root,"Image_ranking_"..i)
			if Image_ranking then 
				if min == i then 
					Image_ranking:setVisible(true)
				else
					Image_ranking:setVisible(false)
				end
			end
        end
        local Image_2 = ccui.Helper:seekWidgetByName(root,"Image_2")
        if Image_2 and (min==666666 or min==777777) then 
            Image_2:setVisible(false)
        else
            Image_2:setVisible(true)
        end
    end
end

function WorldBossRewardRankCell:onInit()
    local root = cacher.createUIRef("campaign/world_boss/world_boss_reward_rank_cell.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)
    if WorldBossRewardRankCell.__size == nil then
        WorldBossRewardRankCell.__size = root:getContentSize()
    end
    self:updateDraw()
end

function WorldBossRewardRankCell:onEnterTransitionFinish()

end

function WorldBossRewardRankCell:clearUIInfo( ... )
    local root = self.roots[1]
    local ListView_boss_challenge_reward = ccui.Helper:seekWidgetByName(root, "ListView_boss_challenge_reward")
    if ListView_boss_challenge_reward ~= nil then
        ListView_boss_challenge_reward:removeAllItems()
    end
end

function WorldBossRewardRankCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function WorldBossRewardRankCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef("campaign/world_boss/world_boss_reward_rank_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function WorldBossRewardRankCell:init(params)
    self.data = params[1]
    self.id = self.data.id
    local index = params[2]
    if index and tonumber(index) < 5 then
        self:onInit()
    end
    if WorldBossRewardRankCell.__size then
        self:setContentSize(WorldBossRewardRankCell.__size)
    end
    return self
end

function WorldBossRewardRankCell:onExit()
    self:clearUIInfo()
    cacher.freeRef("campaign/world_boss/world_boss_reward_rank_cell.csb", self.roots[1])
end