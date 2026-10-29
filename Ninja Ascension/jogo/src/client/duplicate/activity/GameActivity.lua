-- ----------------------------------------------------------------------------------------------------
-- 说明：日常副本
-- 创建时间	2015-03-06
-- 作者：胡文轩
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

GameActivity = class("GameActivityClass", Window)
    
function GameActivity:ctor()
    self.super:ctor()   
	-- app.load("client.packs.treasure.TreasureStorage")	
    -- Initialize GameActivity page state machine.
    local function init_game_activity_terminal()
	
		local game_activity_back_terminal = {
            _name = "game_activity_back",
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
		
		state_machine.add(game_activity_back_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_game_activity_terminal()
end

function GameActivity:onEnterTransitionFinish()
	local csbGameActivity = csb.createNode("duplicate/activity/GameActivity.csb")
	self:addChild(csbGameActivity)
		
	local root = csbGameActivity:getChildByName("root")
	local Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, {terminal_name = "game_activity_back", terminal_state = 0, 
									isPressedActionEnabled = true}, nil, 2)
	
	local Text = ccui.Helper:seekWidgetByName(root, "Text")
	Text:setString(_string_piece_info[135])

end


function GameActivity:onExit()

	state_machine.remove("game_activity_back")
end