--------------------------------------------------------------------------------------------------------------
--  说明：竞技场分享
--------------------------------------------------------------------------------------------------------------
ArenaShare = class("ArenaShareClass", Window)

--打开界面
local arena_share_open_terminal = {
	_name = "arena_share_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if params ~= nil then
			local ArenaShareWindow = fwin:find("ArenaShareClass")
			if ArenaShareWindow ~= nil and ArenaShareWindow:isVisible() == true then
				return true
			end
			fwin:open(ArenaShare:new():init(params),fwin._ui)
		end	
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local arena_share_close_terminal = {
	_name = "arena_share_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
            fwin:close(fwin:find("ArenaShareClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(arena_share_open_terminal)
state_machine.add(arena_share_close_terminal)
state_machine.init()

function ArenaShare:ctor()
	self.super:ctor()
	self.roots = {}

	 -- Initialize arena share state machine.
    local function init_arena_share_terminal()
		
		
		--确认分享
		local arena_share_ensure_button_terminal = {
            _name = "arena_share_ensure_button",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local str = params._datas.share_str
            	state_machine.excute("platform_the_request_share", 0, {_datas={_shareId = 2,_shareStr = str}})  -- _shareId 分享ID _shareStr 描述信息
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(arena_share_ensure_button_terminal)
        state_machine.init()
    end
    
    -- call func init arena share state machine.
    init_arena_share_terminal()

end

	
function ArenaShare:updateDraw()
	
end

function ArenaShare:onInit()
	local csbArenaShare = csb.createNode("utils/prompt_1.csb")
    local root = csbArenaShare:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbArenaShare)

	
	local titleName = ccui.Helper:seekWidgetByName(root, "Text_141")
	local str = ""
	if _ED.is_arena_share_rank ~= nil then
		str = str..string.format(_share_text_2,_ED.is_arena_share_rank)
	else
		str = str..string.format(_share_text_2,_ED.arena_user_rank)
	end
	titleName:setString(str)
	self:updateDraw()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4_8"), 	nil, {
		terminal_name = "arena_share_close", 	 	
		current_button_name = "Button_4_8",	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	--- 确认分享
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3_6"), 	nil, {
		terminal_name = "arena_share_ensure_button", 	 	
		current_button_name = "Button_3_6",	
		share_str = str,
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), 	nil, {
		terminal_name = "arena_share_close", 	 	
		current_button_name = "Panel_2",	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)

end

function ArenaShare:onEnterTransitionFinish()

end

function ArenaShare:init()
	self:onInit()
	return self
end

function ArenaShare:onExit()
	state_machine.remove("arena_share_ensure_button")
end