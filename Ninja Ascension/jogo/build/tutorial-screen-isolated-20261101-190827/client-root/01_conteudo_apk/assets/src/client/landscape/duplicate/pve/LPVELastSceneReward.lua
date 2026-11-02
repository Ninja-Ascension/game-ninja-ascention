-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏副关卡场景界面
-------------------------------------------------------------------------------------------------------
LPVELastSceneReward = class("LPVELastSceneRewardClass", Window)

local lpve_last_scene_reward_open_terminal = {
    _name = "lpve_last_scene_reward_open",
    _init = function (terminal) 
		app.load("client.duplicate.pve.PVESceneStarChart")
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local rewardwindow = LPVELastSceneReward:new()
		rewardwindow:init(params)
		fwin:open(rewardwindow, fwin._windows)	
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(lpve_last_scene_reward_open_terminal)
state_machine.init()
function LPVELastSceneReward:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions ={}
	
    local function lpve_last_scene_reward_terminal()
		-- 副本排行
		local lpve_last_scene_reward_get_terminal = {
            _name = "lpve_last_scene_reward_get",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.lock("lpve_last_scene_reward_get")
            	local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						fwin:close(response.node)
						app.load("client.landscape.duplicate.pve.LPVELastSceneRewardShow")
						local getRewardWnd = LPVELastSceneRewardShow:new()
						getRewardWnd:init()
						fwin:open(getRewardWnd, fwin._windows)
						state_machine.excute("lpve_scene_updeteinfo",0,"")--刷新顶部信息
						state_machine.excute("lpve_main_scene_updeteinfo",0,"")
						state_machine.unlock("lpve_last_scene_reward_get")
					else
						state_machine.unlock("lpve_last_scene_reward_get")
					end
				end
            	protocol_command.one_key_draw_reward.param_list = ""..instance.sceneID
				NetworkManager:register(protocol_command.one_key_draw_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(lpve_last_scene_reward_get_terminal)
        state_machine.init()
    end
    
    lpve_last_scene_reward_terminal()
end

function LPVELastSceneReward:onUpdateDraw()
	local root = self.roots[1]
	
end

function LPVELastSceneReward:onEnterTransitionFinish()
    local csbLPVEScene = csb.createNode("duplicate/pve_baoxiang_all.csb")
    local root = csbLPVEScene:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbLPVEScene)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_226"), nil, 
	{
		terminal_name = "lpve_last_scene_reward_get", 
		terminal_state = 0,
		isPressedActionEnabled = true}, 
	nil, 0)
	self:onUpdateDraw()
end
function LPVELastSceneReward:close()

end

function LPVELastSceneReward:init(sceneID)
	self.sceneID = sceneID
end
function LPVELastSceneReward:onExit()
	state_machine.remove("lpve_last_scene_reward_get")
end
