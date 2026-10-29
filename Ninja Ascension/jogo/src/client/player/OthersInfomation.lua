-- ----------------------------------------------------------------------------------------------------
-- 说明：玩家详细信息及操作
-- 创建时间	2015-03-06
-- 作者：胡文轩
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

OthersInfomation = class("OthersInfomationClass", Window, true)
    
function OthersInfomation:ctor()
    self.super:ctor()
    
	-- app.load("client.packs.treasure.TreasureStorage")
	
    -- Initialize OthersInfomation page state machine.
    local function init_others_infomation_terminal()
	
		local others_infomation_back_terminal = {
            _name = "others_infomation_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("home_manager",1,"open") 
				fwin:close(instance)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(others_infomation_back_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_others_infomation_terminal()
end

function OthersInfomation:onEnterTransitionFinish()
	local csbOthersInfomation = csb.createNode("player/OthersInfomation.csb")
	self:addChild(csbOthersInfomation)
		
	local root = csbOthersInfomation:getChildByName("root")
	local Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_0"), nil, {terminal_name = "others_infomation_back", terminal_state = 0}, nil, 0)
	
	local Text = ccui.Helper:seekWidgetByName(root, "Text")
	Text:setString(_string_piece_info[146])
end


function OthersInfomation:onExit()
	
	
	state_machine.remove("others_infomation_back")
end