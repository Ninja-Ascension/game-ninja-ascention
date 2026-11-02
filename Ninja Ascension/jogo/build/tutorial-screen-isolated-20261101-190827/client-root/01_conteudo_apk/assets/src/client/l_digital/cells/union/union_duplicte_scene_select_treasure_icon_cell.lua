--------------------------------------------------------------------------------------------------------------
--  说明：军团副本场景宝藏宝藏类型选择按钮框
--------------------------------------------------------------------------------------------------------------
UnionDuplicteSceneSelectTreasureIconCell = class("UnionDuplicteSceneSelectTreasureIconCellClass", Window)

function UnionDuplicteSceneSelectTreasureIconCell:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union duplicte scene select treasure icon cell state machine.
    local function init_union_duplicte_scene_select_treasure_icon_cell_terminal()
		-- 刷新
		local union_duplicte_scene_select_treasure_icon_cell_refresh_info_terminal = {
            _name = "union_duplicte_scene_select_treasure_icon_cell_refresh_info",
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
		state_machine.add(union_duplicte_scene_select_treasure_icon_cell_refresh_info_terminal)
        state_machine.init()
    end
    -- call func init union duplicte scene select treasure icon cell state machine.
    init_union_duplicte_scene_select_treasure_icon_cell_terminal()

end

function UnionDuplicteSceneSelectTreasureIconCell:updateDraw()

end

function UnionDuplicteSceneSelectTreasureIconCell:onInit()
	self:updateDraw()
end

function UnionDuplicteSceneSelectTreasureIconCell:onEnterTransitionFinish()

end

function UnionDuplicteSceneSelectTreasureIconCell:init()
	self:onInit()
	return self
end

function UnionDuplicteSceneSelectTreasureIconCell:onExit()

end

function UnionDuplicteSceneSelectTreasureIconCell:createCell()
	local cell = UnionDuplicteSceneSelectTreasureIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
