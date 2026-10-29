GameComonBack = class("GameComonBackClass", Window)

function GameComonBack:ctor()
    self.super:ctor()
    app.load("client.login.login")
		--返回
        local game_comon_back_terminal = {
            _name = "game_comon_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
	

			
			
            --fwin:open(Login:new(), fwin._screen)
            return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(game_comon_back_terminal)
		state_machine.init()
end

function GameComonBack:onEnterTransitionFinish()
 
     local csbPveMap = csb.createNode("duplicate/pve_duplicate.csb")
	 self:addChild(csbPveMap)
	
	local root = csbPveMap:getChildByName("root")
	
	 fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {func_string = [[state_machine.excute("game_comon_back", 0, "game_comon_back")]], 
									isPressedActionEnabled = true}, nil, 0)
	
end

function GameComonBack:onExit()
	
	state_machine.remove("game_comon_back")

end