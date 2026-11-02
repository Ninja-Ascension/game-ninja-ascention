-- ----------------------------------------------------------------------------------------------------
-- 说明：冒险副本地图最佳掉落奖励
-------------------------------------------------------------------------------------------------------
AdventureDuplicateBestDropReward = class("AdventureDuplicateBestDropRewardClass", Window)
    
function AdventureDuplicateBestDropReward:ctor()
    self.super:ctor()
    self.roots = {}

    self.currentNpcId = -1

    app.load("client.adventure.cells.hero.adventure_hero_icon_cell")

    -- Initialize adventure duplicate map best drop reward state machine.
    local function init_adventure_duplicate_map_best_drop_reward_terminal()

        state_machine.init()
    end
    
    -- call func init adventure duplicate map best drop reward state machine.
    init_adventure_duplicate_map_best_drop_reward_terminal()
end

function AdventureDuplicateBestDropReward:init(currentNpcId)
    self.currentNpcId = zstring.tonumber(currentNpcId)
	return self
end

function AdventureDuplicateBestDropReward:drawHeroDropReward()
    if self.currentNpcId > 0 then
        local root = self.roots[1]
        local on_hook_reward_id = dms.string(dms["npc"], self.currentNpcId, npc.on_hook_reward)
        local rewardString = dms.string(dms["on_hook_reward"], on_hook_reward_id, on_hook_reward.drop_ships) or "1,2,3"
        local rewardList = zstring.split(rewardString, ",")
        for i, v in pairs(rewardList) do
            local pad = ccui.Helper:seekWidgetByName(root, "Panel_huode_" .. i)
            if pad ~= nil then
                pad:removeAllChildren(true)
                local cell = AdventureHeroIconCell:createCell()
                cell:init(0, {ship_template_id = tonumber(v)}, 1, 1, nil, nil, nil, nil, 0)
                pad:addChild(cell)
            end
        end
    else
        print("AdventureDuplicateBestDropReward@drawHeroDropReward()", "current npc id ", self.currentNpcId)
    end
end

function AdventureDuplicateBestDropReward:onEnterTransitionFinish()
	local csbAdventureDuplicateBestDropReward = csb.createNode("duplicate/maoxian_baowu_info.csb")
    local root = csbAdventureDuplicateBestDropReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureDuplicateBestDropReward)

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureDuplicateBestDropRewardClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    self:drawHeroDropReward()
end

function AdventureDuplicateBestDropReward:onExit()

end