--------------------------------------------------------------------------------------------------------------
--  说明：军团副本场景宝藏宝箱
--------------------------------------------------------------------------------------------------------------
UnionDuplicateSceneTreasureChestIconCell = class("UnionDuplicateSceneTreasureChestIconCellClass", Window)

function UnionDuplicateSceneTreasureChestIconCell:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union duplicate scene treasure chest icon cell state machine.
    local function init_union_duplicate_scene_treasure_chest_icon_cell_terminal()
		-- 点击宝箱
		local union_duplicate_scene_treasure_chest_icon_cell_get_reward_terminal = {
            _name = "union_duplicate_scene_treasure_chest_icon_cell_get_reward",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 刷新
		local union_duplicate_scene_treasure_chest_icon_cell_refresh_info_terminal = {
            _name = "union_duplicate_scene_treasure_chest_icon_cell_refresh_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(union_duplicate_scene_treasure_chest_icon_cell_get_reward_terminal)
		state_machine.add(union_duplicate_scene_treasure_chest_icon_cell_refresh_info_terminal)
        state_machine.init()
    end
    -- call func init union duplicate scene treasure chest icon cell state machine.
    init_union_duplicate_scene_treasure_chest_icon_cell_terminal()

end

function UnionDuplicateSceneTreasureChestIconCell:updateDraw()

end

function UnionDuplicateSceneTreasureChestIconCell:onInit()
	self:updateDraw()
end

function UnionDuplicateSceneTreasureChestIconCell:onEnterTransitionFinish()

end

function UnionDuplicateSceneTreasureChestIconCell:init()
	self:onInit()
	return self
end

function UnionDuplicateSceneTreasureChestIconCell:onExit()

end

function UnionDuplicateSceneTreasureChestIconCell:createCell()
	local cell = UnionDuplicateSceneTreasureChestIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
