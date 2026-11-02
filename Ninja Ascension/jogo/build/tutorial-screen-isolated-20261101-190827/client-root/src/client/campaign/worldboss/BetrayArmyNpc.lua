-- ----------------------------------------------------------------------------------------------------
-- 说明：围剿叛军主页NPC
-- 创建时间	2015-03-06
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

BetrayArmyNpc = class("BetrayArmyNpcClass", Window)
    
function BetrayArmyNpc:ctor()
    self.super:ctor()
    self.roots = {}
	app.load("client.cells.campaign.betray_army_npc_cell")
	
	self.roleCellList = {}
	-- self.rebelArmyExample = nil 
	-- app.load("client.packs.treasure.TreasureStorage")
	
    -- Initialize BetrayArmyNpc page state machine.
    local function init_world_boss_terminal()
		-- npc状态和血量更新的状态机
		-- local betray_army_npc_state_update_terminal = {
            -- _name = "betray_army_npc_state_update",
            -- _init = function (terminal) 
			
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params) 
				
				-- state_machine.excute("betray_army_npc_cell_update_battle_info", 0, params)
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
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

function BetrayArmyNpc:onUpdateDraw()
	local root = self.roots[1]
	local rebelArmyStr = {
		"Panel_role_3",
		"Panel_role_1",
		"Panel_role_2",
		
	}
			-- betray_army_example = npos(list),	--实例 
			-- betray_army_id = npos(list),		--叛军模板 
			-- belong_to_id = npos(list),			--所属用户 
			-- stop_time = npos(list)				--停留时间
		
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		local index = 0
		local function repetBack( sender )
			index = index + 1
			if index > #self.rebelArmyExample then
				self:stopAllActionsByTag(100)
				return
			end

			local rebelArmyRole = ccui.Helper:seekWidgetByName(root, rebelArmyStr[index])
			local cell = BetrayArmyNpcCell:createCell()
			cell:init(self.rebelArmyExample[index])
			rebelArmyRole:addChild(cell)
			
			table.insert(self.roleCellList, cell)
		end
		local action = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.05), cc.CallFunc:create(repetBack)))
		self:runAction(action)
		action:setTag(100)
	else
		for i , v in pairs(self.rebelArmyExample) do
			local rebelArmyRole = ccui.Helper:seekWidgetByName(root, rebelArmyStr[i])
			local cell = BetrayArmyNpcCell:createCell()
			cell:init(v)
			rebelArmyRole:addChild(cell)
			
			table.insert(self.roleCellList, cell)
		end
	end
end

function BetrayArmyNpc:distribute()

	for i = 1 , table.getn(self.roleCellList) do
		local cell = self.roleCellList[i]
		state_machine.excute("world_boss_update_role_npc_info", 0,{cell = cell}) 
	end

end

function BetrayArmyNpc:onEnterTransitionFinish()
	
	local csbBetrayArmyNpc = csb.createNode("campaign/WorldBoss/worldBoss_page.csb")
	self:addChild(csbBetrayArmyNpc)
	local root = csbBetrayArmyNpc:getChildByName("root")
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
end


function BetrayArmyNpc:init(rebelArmyExample)
	self.rebelArmyExample = rebelArmyExample
end
function BetrayArmyNpc:createCell()
	local cell = BetrayArmyNpc:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
function BetrayArmyNpc:onExit()
	state_machine.remove("world_boss_update_page_npc_info")
end
