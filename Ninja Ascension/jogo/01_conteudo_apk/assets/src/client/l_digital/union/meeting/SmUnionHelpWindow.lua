-- ----------------------------------------------------------------------------------------------------
-- 说明：公会帮助界面
-------------------------------------------------------------------------------------------------------
SmUnionHelpWindow = class("SmUnionHelpWindowClass", Window)

local sm_union_help_window_open_terminal = {
    _name = "sm_union_help_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionHelpWindowClass")
        if nil == _homeWindow then
            local panel = SmUnionHelpWindow:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_help_window_close_terminal = {
    _name = "sm_union_help_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionHelpWindowClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionHelpWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_help_window_open_terminal)
state_machine.add(sm_union_help_window_close_terminal)
state_machine.init()
    
function SmUnionHelpWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    local function init_sm_union_help_window_terminal()
        -- 显示界面
        local sm_union_help_window_display_terminal = {
            _name = "sm_union_help_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionHelpWindowWindow = fwin:find("SmUnionHelpWindowClass")
                if SmUnionHelpWindowWindow ~= nil then
                    SmUnionHelpWindowWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_help_window_hide_terminal = {
            _name = "sm_union_help_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionHelpWindowWindow = fwin:find("SmUnionHelpWindowClass")
                if SmUnionHelpWindowWindow ~= nil then
                    SmUnionHelpWindowWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_help_window_display_terminal)
        state_machine.add(sm_union_help_window_hide_terminal)
        state_machine.init()
    end
    init_sm_union_help_window_terminal()
end

function SmUnionHelpWindow:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    
end

function SmUnionHelpWindow:init(params)
    self.example = params
    self:onInit()
    return self
end

function SmUnionHelpWindow:onInit()
    local csbSmUnionHelpWindow = csb.createNode("legion/sm_legion_help_info.csb")
    local root = csbSmUnionHelpWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionHelpWindow)
    self:onUpdateDraw()

    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_union_help_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
end

function SmUnionHelpWindow:onExit()
    state_machine.remove("sm_union_help_window_display")
    state_machine.remove("sm_union_help_window_hide")
end