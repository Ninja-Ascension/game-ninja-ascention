-----------------------------
-- 天赋规则界面
-----------------------------
SmTalentRuler = class("SmTalentRulerClass", Window)

--打开界面
local sm_talent_ruler_open_terminal = {
	_name = "sm_talent_ruler_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmTalentRulerClass") == nil then
			fwin:open(SmTalentRuler:new():init(), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_talent_ruler_close_terminal = {
	_name = "sm_talent_ruler_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmTalentRulerClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_talent_ruler_open_terminal)
state_machine.add(sm_talent_ruler_close_terminal)
state_machine.init()

function SmTalentRuler:ctor()
	self.super:ctor()
	self.roots = {}

	local function init_sm_talent_ruler_terminal()
		local sm_talent_ruler_goto_pve_terminal = {
            _name = "sm_talent_ruler_goto_pve",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				app.load("client.landscape.duplicate.LDuplicateWindow")
				state_machine.excute("lduplicate_window_manager", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_talent_ruler_goto_pve_terminal)
        state_machine.init()
    end
    init_sm_talent_ruler_terminal()
    
end

function SmTalentRuler:onUpdateDraw()
    local root = self.roots[1]
end

function SmTalentRuler:init()
	self:onInit()
    return self
end

function SmTalentRuler:onInit()
    local csbItem = csb.createNode("cultivate/cultivate_talent_help.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_01_7"), nil, 
    {
        terminal_name = "sm_talent_ruler_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_talent_ruler_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_to_pve"), nil, 
    {
        terminal_name = "sm_talent_ruler_goto_pve", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    ccui.Helper:seekWidgetByName(root,"Image_di"):setTouchEnabled(true)
	self:onUpdateDraw()

end

function SmTalentRuler:onEnterTransitionFinish()
    
end


function SmTalentRuler:onExit()
	state_machine.remove("sm_talent_ruler_goto_pve")
end

