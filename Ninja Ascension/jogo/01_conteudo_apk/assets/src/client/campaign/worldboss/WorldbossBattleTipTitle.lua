-----------------------------------------------------------------------------------------------
-- 说明：叛军战斗前提示 标题
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

WorldbossBattleTipTitle = class("WorldbossBattleTipTitleClass", Window)
    
function WorldbossBattleTipTitle:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.showRoleId = nil
	local function init_WorldbossBattleTipTitle_terminal()
		-- 销毁
		local worldboss_battle_tip_title_close_terminal = {
            _name = "worldboss_battle_tip_title_close",
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
		-- 提示 突破动画
		local worldboss_battle_tip_title_promote_terminal = {
            _name = "worldboss_battle_tip_title_promote",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.showRoleId == nil or instance.showRoleId == params.roleId then
					instance.showRoleId = params.roleId 
					instance.promoteImg:setVisible(true)
					instance.commonImg:setVisible(false)
					instance.alloutImg:setVisible(false)
					instance.actions[1]:play("attack_shuxin_up", false)
				
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 提示 普通动画
		local worldboss_battle_tip_title_common_terminal = {
            _name = "worldboss_battle_tip_title_common",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.showRoleId == nil or instance.showRoleId == params.roleId then
					instance.showRoleId = params.roleId 
					instance.promoteImg:setVisible(false)
					instance.commonImg:setVisible(true)
					instance.alloutImg:setVisible(false)
					instance.actions[1]:play("attack_shuxin_up", false)
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 提示 全力动画		
		local worldboss_battle_tip_title_allout_terminal = {
            _name = "worldboss_battle_tip_title_allout",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.showRoleId == nil or instance.showRoleId == params.roleId then
					instance.showRoleId = params.roleId 
					instance.promoteImg:setVisible(false)
					instance.commonImg:setVisible(false)
					instance.alloutImg:setVisible(true)
					instance.actions[1]:play("attack_shuxin_up", false)
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(worldboss_battle_tip_title_close_terminal)
		state_machine.add(worldboss_battle_tip_title_promote_terminal)
		state_machine.add(worldboss_battle_tip_title_common_terminal)
		state_machine.add(worldboss_battle_tip_title_allout_terminal)
        state_machine.init()
    end
    
    init_WorldbossBattleTipTitle_terminal()
	
end


function WorldbossBattleTipTitle:onEnterTransitionFinish()
    local csbItem = csb.createNode("campaign/WorldBoss/wordBoss_battle_1.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(true)
    self:addChild(root)
	table.insert(self.roots, root)

	--local panel = ccui.Helper:seekWidgetByName(root, "Panel_257")
	-- local size = panel:getContentSize()
	-- self:setContentSize(size)
	
	
	local action = csb.createTimeline("campaign/WorldBoss/wordBoss_battle_1.csb")
    table.insert(self.actions, action )
    root:runAction(action)
    -- action:setFrameEventCallFunc(function (frame)
        -- if nil == frame then
            -- return
        -- end
		
        -- local str = frame:getEvent()
        -- if str == "biaoqin_ing_over" then
			-- local index = self.index
			-- local cell = self.cell
			
			-- fwin:close(self)
			-- state_machine.excute("mine_manager_manor_patrol_dialogue", 0, {index = index, cell = cell}) 
        -- end
    -- end)
	action:play("attack_shuxin_up", false)
	
	self.commonImg = ccui.Helper:seekWidgetByName(root, "Image_attack_1")
	self.promoteImg = ccui.Helper:seekWidgetByName(root, "Image_attack_2")
	self.alloutImg = ccui.Helper:seekWidgetByName(root, "Image_attack_3")
end


function WorldbossBattleTipTitle:onExit()
	state_machine.remove("worldboss_battle_tip_title_close")
	state_machine.remove("worldboss_battle_tip_title_promote")
	state_machine.remove("worldboss_battle_tip_title_common")
	state_machine.remove("worldboss_battle_tip_title_allout")
end


function WorldbossBattleTipTitle:init()
	
end

function WorldbossBattleTipTitle:createCell()
	local cell = WorldbossBattleTipTitle:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
