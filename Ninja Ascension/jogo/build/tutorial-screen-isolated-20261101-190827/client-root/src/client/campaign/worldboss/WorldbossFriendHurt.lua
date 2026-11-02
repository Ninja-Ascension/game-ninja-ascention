-----------------------------------------------------------------------------------------------
-- 说明：叛军主界面上好友显示伤害提示
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

WorldbossFriendHurt = class("WorldbossFriendHurtClass", Window)
    
function WorldbossFriendHurt:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- local function init_WorldbossFriendHurt_terminal()
		-- -- 销毁
		-- local worldboss_friend_hurt_close_terminal = {
            -- _name = "worldboss_friend_hurt_close",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
				-- fwin:close(instance)
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		-- -- 提示 动画
		-- local worldboss_friend_hurt_animation_terminal = {
            -- _name = "worldboss_friend_hurt_animation",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
				
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		-- state_machine.add(worldboss_friend_hurt_close_terminal)
		-- state_machine.add(worldboss_friend_hurt_animation_terminal)
        -- state_machine.init()
    -- end
    
    -- init_WorldbossFriendHurt_terminal()
	
end


function WorldbossFriendHurt:onEnterTransitionFinish()
    local csbItem = csb.createNode("campaign/WorldBoss/worldBoss_hurt_ing.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(true)
    self:addChild(root)
	table.insert(self.roots, root)

	local action = csb.createTimeline("campaign/WorldBoss/worldBoss_hurt_ing.csb")
    table.insert(self.actions, action )
    root:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
		
        local str = frame:getEvent()
        if str == "text_hurt_ing_over" then
			state_machine.excute("world_boss_open_float_hurt", 0, 0)
			fwin:close(self)
			
        end
    end)
	action:play("text_hurt_ing", false)
	
	ccui.Helper:seekWidgetByName(root, "Text_1036"):setString(self.txt)
	
end


function WorldbossFriendHurt:onExit()
	state_machine.remove("worldboss_battle_tip_title_close")
	state_machine.remove("worldboss_battle_tip_title_promote")
	state_machine.remove("worldboss_battle_tip_title_common")
	state_machine.remove("worldboss_battle_tip_title_allout")
end


function WorldbossFriendHurt:init(txt)
	self.txt = txt
end

function WorldbossFriendHurt:createCell()
	local cell = WorldbossFriendHurt:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
