--------------------------------------------------------------------------------
-- 叛军 战斗  获得伤害功勋 ,覆盖在战斗场景上
--------------------------------------------------------------------------------


WorldbossBattleDescribe = class("WorldbossBattleDescribeClass", Window)
    
function WorldbossBattleDescribe:ctor()
    self.super:ctor()
	self.actions = {}
	self.roots = {}
    -- Initialize WorldbossBattleDescribe page state machine.
    local function init_world_boss_terminal()
	
	
		--返回
		local world_boss_battle_describe_back_activity_terminal = {
            _name = "world_boss_battle_describe_back_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
              
				fwin:close(instance)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--伤害
		local world_boss_battle_describe_hurt_activity_terminal = {
            _name = "world_boss_battle_describe_hurt_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			

				local value = math.abs(zstring.tonumber(params[1]))
				instance.hurtText:setString(value)

				value = math.floor(value/1000)
				
				-- 功勋加倍
				if zstring.tonumber(_ED.betray_army_information.is_exploit) == 1 then
					value = value * 2
				end
				
				instance.exploitText:setString(value)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(world_boss_battle_describe_hurt_activity_terminal)
		state_machine.add(world_boss_battle_describe_back_activity_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_world_boss_terminal()
end


function WorldbossBattleDescribe:onEnterTransitionFinish()

    local csbCampaign = csb.createNode("campaign/WorldBoss/wordBoss_battle.csb")	
	local root = csbCampaign:getChildByName("root")
    self:addChild(csbCampaign)
	table.insert(self.roots, root)
	
	-- 伤害
	self.hurtText = ccui.Helper:seekWidgetByName(root, "Text_101_0")
	self.hurtText:setString("0")
	
	-- 功勋
	self.exploitText = ccui.Helper:seekWidgetByName(root, "Text_102_0")
	self.exploitText:setString("0")
end

function WorldbossBattleDescribe:init()
	
	
end

function WorldbossBattleDescribe:onExit()
	state_machine.remove("world_boss_battle_describe_hurt_activity")
	state_machine.remove("world_boss_battle_describe_back_activity")

end
