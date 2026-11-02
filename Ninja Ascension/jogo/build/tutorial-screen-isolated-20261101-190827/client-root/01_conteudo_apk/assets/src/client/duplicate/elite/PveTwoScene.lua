-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE主线副本NPC二级战斗准备界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

PveTwoScene = class("PveTwoSceneClass", Window)
    

function PveTwoScene:ctor()
    self.super:ctor()
    self.roots = {}

	
    -- Initialize GameElite page state machine.
	local function init_pve_scene_npc_two ()
		local duplicate_show_list_1_terminal = {
            _name = "touch_colose",
            _init = function (terminal)          
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("PveTwoSceneClass"))
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--请求战斗回调
		local duplicate_challenge_request = {
            _name = "challenge_request",
            _init = function (terminal)          
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--TODO  发送战斗的请求
				
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(duplicate_show_list_1_terminal)
		state_machine.add(duplicate_challenge_request)
        state_machine.init()
    end
    
    -- call func init hom state machine.
	init_pve_scene_npc_two()
end




function PveTwoScene:onEnterTransitionFinish()
	local csbCardRole = csb.createNode("duplicate/elite_copy_drop.csb")
	self:addChild(csbCardRole)
	local root = csbCardRole:getChildByName("root")
	table.insert(self.roots, root)
	--TODO  战斗准备二级界面的绘制和逻辑设计
	
	local ButtonColose = ccui.Helper:seekWidgetByName(root, "Button_colose")
	local ButtonChallenge = ccui.Helper:seekWidgetByName(root, "Button_2265")
	
	fwin:addTouchEventListener(ButtonColose, nil, {func_string = [[state_machine.excute("touch_colose", 0, "click touch_colose.'")]], 
									isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(ButtonChallenge, nil, {func_string = [[state_machine.excute("challenge_request", 0, "click challenge_request.'")]], 
									isPressedActionEnabled = true}, nil, 0)
end


function PveTwoScene:onExit()
	state_machine.remove("touch_colose")
	state_machine.remove("challenge_request")
end