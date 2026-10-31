-- ----------------------------------------------------------------------------------------------------
-- 说明：矿山资源不足提示界面
-------------------------------------------------------------------------------------------------------
AdventureMineTip = class("AdventureMineTipClass", Window)
    
function AdventureMineTip:ctor()
    self.super:ctor()
    self.roots = {}
	self.reward = nil
	self.getHero = false
    -- Initialize adventure battle reward state machine.
    local function init_adventure_mine_tip_terminal()
		local adventure_mine_tip_jump_terminal = {
            _name = "adventure_mine_tip_jump",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				app.load("client.adventure.campaign.mine.AdventureMinePackage")
				local function responseMineExploitCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						fwin:open(AdventureMinePackage:new():init(2), fwin._view)
						fwin:close(fwin:find("AdventureMineTipClass"))
					end
				end
				NetworkManager:register(protocol_command.get_mineral_prop_list.code, nil, nil, nil, cell, responseMineExploitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }
		
		state_machine.add(adventure_mine_tip_jump_terminal)
        state_machine.init()
    end
    
    -- call func init adventure battle reward state machine.
    init_adventure_mine_tip_terminal()
end

function AdventureMineTip:init()
	return self
end

function AdventureMineTip:onUpdateDraw()
	local root = self.roots[1]
	local Text_141 = ccui.Helper:seekWidgetByName(root, "Text_141")
	Text_141:setString(_string_piece_info[395])
end

function AdventureMineTip:onEnterTransitionFinish()
	local csbAdventureBattleReward = csb.createNode("utils/prompt_1.csb")
    local root = csbAdventureBattleReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureBattleReward)
	self:onUpdateDraw()
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4_8"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMineTipClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
	
	--打开资源仓库
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3_6"), nil, 
    {
        terminal_name = "adventure_mine_tip_jump", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

end

function AdventureMineTip:onExit()

end