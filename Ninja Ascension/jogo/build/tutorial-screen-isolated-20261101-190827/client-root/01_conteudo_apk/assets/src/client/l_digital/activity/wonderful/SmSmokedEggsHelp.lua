-- ----------------------------------------------------------------------------------------------------
-- 说明：砸金蛋帮助
-------------------------------------------------------------------------------------------------------
SmSmokedEggsHelp = class("SmSmokedEggsHelpClass", Window)

local sm_smoked_eggs_help_window_open_terminal = {
    _name = "sm_smoked_eggs_help_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmSmokedEggsHelpClass")
        if nil == _homeWindow then
            local activity_type = params._datas.activity_type
            local panel = SmSmokedEggsHelp:new():init(activity_type)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_smoked_eggs_help_window_close_terminal = {
    _name = "sm_smoked_eggs_help_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmSmokedEggsHelpClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmSmokedEggsHelpClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_smoked_eggs_help_window_open_terminal)
state_machine.add(sm_smoked_eggs_help_window_close_terminal)
state_machine.init()
    
function SmSmokedEggsHelp:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._activity_type = 0
    local function init_sm_smoked_eggs_help_window_terminal()
        -- 显示界面
        local sm_smoked_eggs_help_window_display_terminal = {
            _name = "sm_smoked_eggs_help_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmSmokedEggsHelpWindow = fwin:find("SmSmokedEggsHelpClass")
                if SmSmokedEggsHelpWindow ~= nil then
                    SmSmokedEggsHelpWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_smoked_eggs_help_window_hide_terminal = {
            _name = "sm_smoked_eggs_help_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmSmokedEggsHelpWindow = fwin:find("SmSmokedEggsHelpClass")
                if SmSmokedEggsHelpWindow ~= nil then
                    SmSmokedEggsHelpWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_smoked_eggs_help_window_display_terminal)
        state_machine.add(sm_smoked_eggs_help_window_hide_terminal)
        state_machine.init()
    end
    init_sm_smoked_eggs_help_window_terminal()
end

function SmSmokedEggsHelp:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local Text_guize = ccui.Helper:seekWidgetByName(root,"Text_guize")
    if self._activity_type == 87 then   -- 金币砸金蛋
        Text_guize:setString(_activity_smoked_eggs_rule_tips[1])
    else -- 钻石砸金蛋
        Text_guize:setString(_activity_smoked_eggs_rule_tips[2])
    end
end

function SmSmokedEggsHelp:init(activity_type)
    self._activity_type = activity_type
    self:onInit()
    return self
end

function SmSmokedEggsHelp:onInit()
    local csbSmSmokedEggsHelp = csb.createNode("activity/wonderful/sm_gold_egg_rule.csb")
    local root = csbSmSmokedEggsHelp:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmSmokedEggsHelp)
    self:onUpdateDraw()

    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_smoked_eggs_help_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
end

function SmSmokedEggsHelp:onExit()
    state_machine.remove("sm_smoked_eggs_help_window_display")
    state_machine.remove("sm_smoked_eggs_help_window_hide")
end