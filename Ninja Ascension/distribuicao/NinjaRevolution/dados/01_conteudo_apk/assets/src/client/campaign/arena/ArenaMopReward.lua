-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场扫荡结算
-------------------------------------------------------------------------------------------------------

ArenaMopReward = class("ArenaMopRewardClass", Window)
   
local arena_mop_reward_window_open_terminal = {
    _name = "arena_mop_reward_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ArenaMopRewardClass") then
        	local mopWindow = ArenaMopReward:new()
			mopWindow:init()
			fwin:open(mopWindow, fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local arena_mop_reward_window_close_terminal = {
    _name = "arena_mop_reward_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("arena_update_information",0,"")
        fwin:close(fwin:find("ArenaMopRewardClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_mop_reward_window_open_terminal)
state_machine.add(arena_mop_reward_window_close_terminal)
state_machine.init()
  
function ArenaMopReward:ctor()
    self.super:ctor()
	self.roots = {}
	
	app.load("client.cells.campaign.arena_mop_reward_list_cell")
	
    -- Initialize Home page state machine.
    local function init_arena_mop_reward_terminal()
        --确定升级
        local arena_mop_reward_streng_terminal = {
            _name = "arena_mop_reward_streng",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(arena_mop_reward_streng_terminal)
        state_machine.init()
    end
    
    init_arena_mop_reward_terminal()
end

function ArenaMopReward:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end

	local listView = ccui.Helper:seekWidgetByName(root, "ListView_2")
	listView:removeAllItems()
	for i,v in pairs(_ED._areana_one_key_reward) do
		local cell = ArenaMopRewardListCell:createCell()
		cell:init(v)
		listView:addChild(cell)
	end
	listView:refreshView()
end

function ArenaMopReward:onEnterTransitionFinish()
	self.roots = {}
    local csbEquipInformation = csb.createNode("campaign/ArenaStorage/ArenaStorage_results.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)

	self:onUpdateDraw()
	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
	{
		terminal_name = "arena_mop_reward_window_close",   
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)	
	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
	{
		terminal_name = "arena_mop_reward_window_close",   
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)	
	
end

function ArenaMopReward:onExit()
end

function ArenaMopReward:init()

end
