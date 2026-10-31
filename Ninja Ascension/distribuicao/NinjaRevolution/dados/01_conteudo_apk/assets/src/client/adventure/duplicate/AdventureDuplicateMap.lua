-- ----------------------------------------------------------------------------------------------------
-- 说明：冒险副本地图
-------------------------------------------------------------------------------------------------------
AdventureDuplicateMap = class("AdventureDuplicateMapClass", Window)

app.load("client.adventure.duplicate.AdventureDuplicateBestDropReward")
AdventureDuplicateMap.__selectNpcCellId = nil --上一次挂机的场景

function AdventureDuplicateMap:ctor()
    self.super:ctor()
    self.roots = {}

    self._scene_difficulty_index = 1
    self.selectSceneId = -1

    self.currentSelectNpcCell = nil

    self.cells = {}

    fwin:close(fwin:find("AdventureDuplicateMapClass"))

    app.load("client.adventure.cells.duplicate.adventure_duplicate_map_npc_cell")

    -- Initialize adventure duplicate map state machine.
    local function init_adventure_duplicate_map_terminal()
        -- 选择场景
        local adventure_duplicate_map_change_scene_terminal = {
            _name = "adventure_duplicate_map_change_scene",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:selectNpc(params, true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 选择场景-通过地图NPC索引
        local adventure_duplicate_map_change_scene_with_npc_index_terminal = {
            _name = "adventure_duplicate_map_change_scene_with_npc_index",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params

                state_machine.excute("adventure_duplicate_map_npc_cell_change_scene", 0, {_datas = {cell = instance.cells[index]}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 切换地图难度
        local adventure_duplicate_map_change_scene_difficulty_terminal = {
            _name = "adventure_duplicate_map_change_scene_difficulty",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeSceneDifficulty(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 最佳掉落
        local adventure_duplicate_best_drop_reward_terminal = {
            _name = "adventure_duplicate_best_drop_reward",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureDuplicateBestDropReward:new():init(AdventureDuplicateMap.__selectNpcCellId), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 绘制场景中的挂机信息
        local adventure_duplicate_map_on_hook_reward_scene_terminal = {
            _name = "adventure_duplicate_map_on_hook_reward_scene",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:drawMapOnHookReward()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 校验焦点
        local adventure_duplicate_map_check_selected_terminal = {
            _name = "adventure_duplicate_map_check_selected",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.cells ~= nil then
                    for i, v in pairs(instance.cells) do
                        if state_machine.excute("adventure_duplicate_map_npc_cell_check_selected", 0, {cell = v, npcId = params}) == true then
                            instance:selectNpc(v, false)
                            return true
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_duplicate_map_change_scene_terminal)
        state_machine.add(adventure_duplicate_map_change_scene_with_npc_index_terminal)
        state_machine.add(adventure_duplicate_map_change_scene_difficulty_terminal)
        state_machine.add(adventure_duplicate_best_drop_reward_terminal)
        state_machine.add(adventure_duplicate_map_on_hook_reward_scene_terminal)
        state_machine.add(adventure_duplicate_map_check_selected_terminal)
        state_machine.init()
    end
    
    -- call func init adventure duplicate map state machine.
    init_adventure_duplicate_map_terminal()
end

function AdventureDuplicateMap:init(window, sceneId, sceneDifficultyIndex)
    self._rootWindows = window
    self.selectSceneId = sceneId
    self._scene_difficulty_index = sceneDifficultyIndex or self._scene_difficulty_index
    self:onInit()
	return self
end

function AdventureDuplicateMap:selectNpc(cell, changeTo)

    if (changeTo == true) then
        for _, cell in pairs(self.cells) do
            state_machine.excute("adventure_duplicate_map_npc_cell_unselected", 0, cell)
        end
    end
    self.currentSelectNpcCell = cell
    AdventureDuplicateMap.__selectNpcCellId = self.currentSelectNpcCell.npcId
    if changeTo == true then
        state_machine.excute("adventure_duplicate_change_scene", 0, {sceneId = self.currentSelectNpcCell.sceneId, npcId = self.currentSelectNpcCell.npcId})
    end
end

function AdventureDuplicateMap:drawMapOnHookReward()
    local root = self.roots[1]
    -- 绘制挂机恢复信息
    local rewardGold = _ED.on_hook_reward_gold_s -- dms.string(dms["on_hook_reward"], self.currentSelectNpcCell.npcId, on_hook_reward.gold) or "0"
    local rewardExp = _ED.on_hook_reward_experience_s -- dms.string(dms["on_hook_reward"], self.currentSelectNpcCell.npcId, on_hook_reward.experience) or "0"
    ccui.Helper:seekWidgetByName(root, "Text_jinbi"):setString("" .. rewardGold .. "/S")
    ccui.Helper:seekWidgetByName(root, "Text_exp"):setString("".. rewardExp .. "/S")
end

function AdventureDuplicateMap:changeSceneDifficulty(params)
    local difficulty = params
    self._scene_difficulty_index = difficulty
    self.currentSelectNpcCell = nil
    self:updateMapNpc()
end

function AdventureDuplicateMap:updateMapNpc()
    local root = self.roots[1]
    local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
    local sceneMould = dms.element(dms["pve_scene"], self.selectSceneId)
    local npcs = dms.atos(sceneMould, pve_scene.npcs)
    local lists = zstring.split(npcs, "|")
    local list = zstring.split(lists[self._scene_difficulty_index], ",")

    local adsIsOpened = fwin:find("AdventureDuplicateSceneClass") ~= nil and true or false
    self.cells = {}

    for i = 1, 5 do
        local Panel_stage = ccui.Helper:seekWidgetByName(Panel_6, "Panel_stage_"..i)
        local cell = AdventureDuplicateMapNpcCell:createCell()
        cell:init(self.selectSceneId, list[i], i)
        Panel_stage:removeAllChildren(true)
        Panel_stage:addChild(cell)

        table.insert(self.cells, cell)

        if adsIsOpened == true and tonumber(_ED.npc_state[tonumber(""..list[i])]) == 0 then
            local params = {_datas={}}
            params._datas.cell = cell
            --state_machine.excute("adventure_duplicate_map_npc_cell_change_scene", 0, params)
        end
    end
end

function AdventureDuplicateMap:onEnterTransitionFinish()
    
end

function AdventureDuplicateMap:onInit()
    local mapIndex = dms.string(dms["pve_scene"], self.selectSceneId, pve_scene.scene_map_id)
	local csbAdventureDuplicateMap = csb.createNode("duplicate/maoxian_checkpoint_" .. mapIndex .. ".csb")
    local root = csbAdventureDuplicateMap:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureDuplicateMap)
    -- 绘制地图上面的场景入口
    self:updateMapNpc()

    -- -- 最佳掉落
    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_diaoluo"),       nil, 
    -- {
    --     terminal_name = "adventure_duplicate_best_drop_reward",         
    --     terminal_state = 0, 
    --     isPressedActionEnabled = true
    -- }, 
    -- nil, 0)
end

function AdventureDuplicateMap:onExit()
    state_machine.remove("adventure_duplicate_map_change_scene")
    state_machine.remove("adventure_duplicate_map_change_scene_with_npc_index")
    state_machine.remove("adventure_duplicate_map_change_scene_difficulty")
    state_machine.remove("adventure_duplicate_best_drop_reward")
    state_machine.remove("adventure_duplicate_map_on_hook_reward_scene")
    state_machine.remove("adventure_duplicate_map_check_selected")
end