-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE名将副本
-- 创建时间
-- 作者：胡文轩
-- 修改记录：GameComon
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

GameComon = class("GameComonClass", Window)
    
GameComon.botton_index = 0




function GameComon:ctor()
    self.super:ctor()
    
	
	--app.load("client.duplicate.common.GameComonMap")
    -- Initialize GameComon page state machine.
    local function init_game_comon_terminal()
	
	
		-- 退出当前副本集
		local game_comon_exit_terminal = {
            _name = "game_comon_exit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                
				fwin:open(Duplicate:new(), fwin._view)
				fwin:close(instance)
			
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		
		--传记介绍框
		local game_comon_show_story_terminal = {
            _name = "game_comon_show_story",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                
				local root = instance:getChildByTag(10000):getChildByName("root")
				local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
				
				if GameComon.botton_index == 0 then
					GameComon.botton_index = 1
					Image_1:setVisible(true)
				elseif GameComon.botton_index == 1 then
					GameComon.botton_index = 0
					Image_1:setVisible(false)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--点击关卡信息框
		local game_comon_show_level_terminal = {
            _name = "game_comon_show_level",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
			
				
                local root = instance:getChildByTag(10000):getChildByName("root")
				local Panel_info = ccui.Helper:seekWidgetByName(root, "Panel_info")
				Panel_info:setVisible(true)
				Panel_info:setTouchEnabled(true)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--关闭关卡信息框
		local game_comon_exit_level_terminal = {
            _name = "game_comon_exit_level",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
			
				
                local root = instance:getChildByTag(10000):getChildByName("root")
				local Panel_info = ccui.Helper:seekWidgetByName(root, "Panel_info")
				Panel_info:setVisible(false)
				Panel_info:setTouchEnabled(false)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		
	
		state_machine.add(game_comon_exit_terminal)
		state_machine.add(game_comon_show_story_terminal)
		state_machine.add(game_comon_show_level_terminal)
		state_machine.add(game_comon_exit_level_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_game_comon_terminal()
end




function GameComon:onEnterTransitionFinish()
	
	local csbpve_duplicate = csb.createNode("duplicate/pve_duplicate_1.csb")
	self:addChild(csbpve_duplicate)
	
    
	app.load("client.duplicate.common.GameComonMap")
	fwin:open(GameComonMap:new(), fwin._background)
	
				
				
	app.load("client.duplicate.common.GameComonTitle")
	if __lua_project_id ~= __lua_project_red_alert_time then
		fwin:open(GameComonTitle:new(), fwin._view)
	end
	
	
	app.load("client.duplicate.common.GameComonBack")
	fwin:open(GameComonBack:new(), fwin._view)	
	
	
end


function GameComon:onExit()

	
	state_machine.remove("game_comon_exit")
	state_machine.remove("game_comon_show_story")
	state_machine.remove("game_comon_show_level")
	state_machine.remove("game_comon_exit_level")
end