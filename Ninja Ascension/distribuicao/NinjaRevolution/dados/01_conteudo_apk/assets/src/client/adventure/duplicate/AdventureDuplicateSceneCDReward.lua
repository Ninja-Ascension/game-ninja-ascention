-- ----------------------------------------------------------------------------------------------------
-- 说明：冒险副本挂机奖励
-------------------------------------------------------------------------------------------------------
AdventureDuplicateSceneCDReward = class("AdventureDuplicateSceneCDRewardClass", Window)

function AdventureDuplicateSceneCDReward:ctor()
    self.super:ctor()
    self.roots = {}

    self.selectSceneId = -1
    self.selectNpcId = -1

    fwin:close(fwin:find("AdventureDuplicateSceneCDRewardClass"))
    
    -- Initialize adventure duplicate scene state machine.
    local function init_adventure_duplicate_scene_terminal() 
        -- 领取挂机奖励
        local adventure_duplicate_scene_cd_reward_terminal = {
            _name = "adventure_duplicate_scene_draw_cd_reward",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- TipDlg.drawTextDailog("领取奖励：未实现。")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_duplicate_scene_cd_reward_terminal)
        state_machine.init()
    end
    
    -- call func init adventure duplicate scene state machine.
    init_adventure_duplicate_scene_terminal()
end

function AdventureDuplicateSceneCDReward:init(sceneId, npcId)
    self.selectSceneId = sceneId
    self.selectNpcId = npcId
    return self
end

function AdventureDuplicateSceneCDReward:onEnterTransitionFinish()
    local csAdventureDuplicateSceneCDReward = csb.createNode("duplicate/exploration_results.csb")
    local root = csAdventureDuplicateSceneCDReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csAdventureDuplicateSceneCDReward)
    local npcId = tonumber(""..self.selectNpcId)
    ccui.Helper:seekWidgetByName(root, "Text_result"):setString("" .. _ED.all_npc_reward_count[npcId] .."/".._ED.max_box_reward_count)
    local sceneMould = dms.element(dms["pve_scene"], self.selectSceneId)
    local npcs = dms.atos(sceneMould, pve_scene.npcs)
    local lists = zstring.split(npcs, "|")
    local index = 0
    for m, h in pairs(lists) do
        local list = zstring.split(h, ",")
        for i, v in pairs(list) do
            if ""..v == ""..self.selectNpcId then
                index = i
                break
            end
        end
    end
    index = zstring.tonumber(index)
    ccui.Helper:seekWidgetByName(root, "Panel_"..index):setVisible(true)
    local num_names = {
        "Text_exp_num",
        "Text_money_num",
        "Text_yb_num",
        "Text_daoju_num",
        "Text_wujiang_num",
    }
    ccui.Helper:seekWidgetByName(root, num_names[index]):setString("" .. _ED.all_npc_reward_count[npcId])

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureDuplicateSceneCDRewardClass"))]],      
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 挂机奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_huoqu"),       nil, 
    {
        -- terminal_name = "adventure_duplicate_scene_draw_cd_reward",
        func_string = [[fwin:close(fwin:find("AdventureDuplicateSceneCDRewardClass"))]],          
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureDuplicateSceneCDReward:onExit()
    state_machine.remove("adventure_duplicate_scene_draw_cd_reward")
end