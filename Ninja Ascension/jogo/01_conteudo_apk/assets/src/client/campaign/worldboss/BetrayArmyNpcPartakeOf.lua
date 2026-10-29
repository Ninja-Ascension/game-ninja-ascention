-- ----------------------------------------------------------------------------------------------------
-- 说明：围剿叛军主页NPC
-- 创建时间	2015-03-06
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

BetrayArmyNpcPartakeOf = class("BetrayArmyNpcPartakeOfClass", Window)
    
function BetrayArmyNpcPartakeOf:ctor()
    self.super:ctor()
    self.roots = {}
	
    -- Initialize BetrayArmyNpcPartakeOf page state machine.
    local function init_world_boss_terminal()
		
		
		local world_boss_update_page_npc_info_terminal = {
            _name = "world_boss_update_page_npc_info",
            _init = function (terminal) 
			
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				
				--state_machine.excute("betray_army_npc_cell_update_battle_info", 0, params)
				
				params.cell:distribute()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(world_boss_update_page_npc_info_terminal)
		
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_world_boss_terminal()
end

function BetrayArmyNpcPartakeOf:onUpdateDraw()
	local root = self.roots[1]
	
end


function BetrayArmyNpcPartakeOf:onEnterTransitionFinish()
	
	local csbBetrayArmyNpc = csb.createNode("campaign/WorldBoss/worldBoss_page.csb")
	self:addChild(csbBetrayArmyNpc)
	local root = csbBetrayArmyNpc:getChildByName("root")
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
end


function BetrayArmyNpcPartakeOf:init()

end
function BetrayArmyNpcPartakeOf:createCell()
	local cell = BetrayArmyNpcPartakeOf:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
function BetrayArmyNpcPartakeOf:onExit()
	state_machine.remove("world_boss_update_page_npc_info")
end
