ExitGameView = class("ExitGameViewClass", Window)

function ExitGameView:ctor()
    self.super:ctor()
	self.roots = {}

	local function init_exit_game_view_terminal()

		-- 取消退出
		local exit_game_view_cancel_terminal = {
			_name = "exit_game_view_cancel",
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
		-- 确认退出
		local exit_game_view_affirm_terminal = {
			_name = "exit_game_view_affirm",
			_init = function (terminal) 
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if app.configJson.OperatorName == "qfdy" or app.configJson.OperatorName == "lfgame" then
					local union_name = nil
			        if _ED.union == nil or _ED.union.union_info == nil or _ED.union.union_info.union_name == nil then
			            union_name = "null"
			        else
			            union_name = _ED.union.union_info.union_name
			        end
			        local strs = ""
			        if fwin:find("LogoClass") ~= nil or fwin:find("LoginClass") ~= nil then 
			        	strs = "null"
			        else
			        	strs = _ED.user_info.user_id.."|".._ED.user_info.user_name.."|".._ED.user_info.user_grade.."|".._ED.selected_server.."|".._ED.all_servers[_ED.selected_server].server_name.."|".._ED.user_info.user_gold.."|".._ED.vip_grade.."|"..union_name
			        end
					handlePlatformRequest(0, CC_GAME_EXIT_DETERMINE, strs)
				else
					handlePlatformRequest(0, CC_GAME_EXIT_DETERMINE, "")
				end
				fwin:close(instance)
			    return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		state_machine.add(exit_game_view_cancel_terminal)
		state_machine.add(exit_game_view_affirm_terminal)
		state_machine.init()
	end
	
	init_exit_game_view_terminal()
	
	
	local csbExitGameView = csb.createNode("utils/tuichu.csb")
    self:addChild(csbExitGameView)
	local root = csbExitGameView:getChildByName("Panel_5320")
	table.insert(self.roots, root)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5327"), nil, 
	{
		terminal_name = "exit_game_view_cancel",
		_window = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5328"), nil, 
	{
		terminal_name = "exit_game_view_affirm",
		_window = self,
		isPressedActionEnabled = true
	},
	nil, 0)
end

function ExitGameView:onEnterTransitionFinish()
	
end

function ExitGameView:onExit()

end

function ExitGameView:reset(request)
	self.request = request
end
