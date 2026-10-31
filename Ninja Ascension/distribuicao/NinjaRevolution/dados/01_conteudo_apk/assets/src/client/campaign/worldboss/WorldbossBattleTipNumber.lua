-----------------------------------------------------------------------------------------------
-- 说明：叛军战斗前提示 x10 倍数
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

WorldbossBattleTipNumber = class("WorldbossBattleTipNumberClass", Window)
    
function WorldbossBattleTipNumber:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	--self.showRoleId = nil
	-- local function init_WorldbossBattleTipNumber_terminal()
		-- -- 销毁
		-- local worldboss_battle_tip_number_close_terminal = {
            -- _name = "worldboss_battle_tip_number_close",
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
		-- -- 提示 突破动画
		-- local worldboss_battle_tip_number_promote_terminal = {
            -- _name = "worldboss_battle_tip_number_promote",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
				-- if instance.showRoleId == nil or instance.showRoleId == params.roleId then
					-- instance.showRoleId = params.roleId 
					-- instance.promoteImg:setVisible(true)
					-- instance.actions[1]:play("attack_shuxin_up", false)
				
				-- end
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		-- -- 提示 普通动画
		-- local worldboss_battle_tip_number_common_terminal = {
            -- _name = "worldboss_battle_tip_number_common",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
				-- if instance.showRoleId == nil or instance.showRoleId == params.roleId then
					-- instance.showRoleId = params.roleId 
					-- instance.commonImg:setVisible(true)
					-- instance.actions[1]:play("attack_shuxin_up", false)
				-- end
				-- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		-- -- 提示 全力动画		
		-- local worldboss_battle_tip_number_allout_terminal = {
            -- _name = "worldboss_battle_tip_number_allout",
            -- _init = function (terminal) 
               
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
				-- if instance.showRoleId == nil or instance.showRoleId == params.roleId then
					-- instance.showRoleId = params.roleId 
					-- instance.alloutImg:setVisible(true)
					-- instance.actions[1]:play("attack_shuxin_up", false)
				-- end
				-- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		-- state_machine.add(worldboss_battle_tip_number_close_terminal)
		-- state_machine.add(worldboss_battle_tip_number_promote_terminal)
		-- state_machine.add(worldboss_battle_tip_number_common_terminal)
		-- state_machine.add(worldboss_battle_tip_number_allout_terminal)
        -- state_machine.init()
    -- end
    
    -- init_WorldbossBattleTipNumber_terminal()
	
end


function WorldbossBattleTipNumber:onEnterTransitionFinish()
    local csbItem = csb.createNode("campaign/WorldBoss/wordBoss_battle_2.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(true)
    self:addChild(root)
	table.insert(self.roots, root)

	--local panel = ccui.Helper:seekWidgetByName(root, "Panel_257")
	-- local size = panel:getContentSize()
	-- self:setContentSize(size)
	
	state_machine.excute("worldboss_battle_tip_title_promote", 0, {roleId = self.rid})
	
	local length = 2
	
	local label = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_147")
	
	label:setString("x"..self.surmount)
	
	local action = csb.createTimeline("campaign/WorldBoss/wordBoss_battle_2.csb")
    table.insert(self.actions, action )
    root:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
		
        local str = frame:getEvent()
        if str == "attack_text_up_over" then
			length = length - 1
			if length > 0 then
				
				if self.etype == 1 then
					state_machine.excute("worldboss_battle_tip_title_common", 0, {roleId = self.rid})
				elseif self.etype == 2 then
					state_machine.excute("worldboss_battle_tip_title_allout", 0, {roleId = self.rid})
				end
			
				label:setString("x"..self.advance)
				action:play("attack_text_up", false)
			else
				state_machine.excute("fight_hero_fight_ready_over", 0, 0)
				state_machine.excute("worldboss_battle_tip_title_close", 0, 0)
				fwin:close(self)
			end
        end
    end)
	action:play("attack_text_up", false)
end


function WorldbossBattleTipNumber:onExit()

end

-- 当前角色id, 突破数, 提升数,提升类型
function WorldbossBattleTipNumber:init(rid, n, m, etype)
	
	self.rid = rid
	self.surmount = n
	self.advance = m
	self.etype = etype
end

function WorldbossBattleTipNumber:createCell()
	local cell = WorldbossBattleTipNumber:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
